/*************************************************************************************************
 * @file       app_main.c
 * @brief      SPI Master Controller Demonstration Application
 * @details    Implements full-duplex SPI communication test with the following features:
 *             - 4-wire SPI master operation
 *             - Interrupt-driven RX FIFO handling
 *             - GPIO-based slave select control
 *             - Data verification and diagnostic logging
 ************************************************************************************************/
#include "include.h"
#include "driver_gpio.h"
#include "driver_spim.h"
#include "log_dbg.h"
/* SPI Master GPIO Configuration (MOSI, MISO, SCLK, NSS) */
const struct gpio_cfg_tag spim0_pin_cfg[] = {
    {GPIO_PIN0,   SPIM_FUN},  /* NSS (Slave Select) */
    {GPIO_PIN1,   SPIM_FUN},  /* SCLK */
    {GPIO_PIN6,   SPIM_FUN},  /* MOSI */
    {GPIO_PIN7,   SPIM_FUN},  /* MISO */
};

#define SPI_BYTE_NUM 20  /* Test payload size */

/* Communication buffers */
uint8_t spi_rx_buf[SPI_BYTE_NUM];  /* Receive buffer */
uint8_t spi_tx_buf[SPI_BYTE_NUM];  /* Transmit buffer */
uint8_t test_rx_index = 0;         /* RX buffer index counter */

/**
 * @brief SPI Master Interrupt Service Routine
 * @note Handles RX_FIFO_FULL interrupts:
 *       - Drains RX FIFO into receive buffer
 *       - Implements circular buffer index management
 *       - Clears interrupt flags
 */
ATTRIBUTE_ISR void SPIM0_Handler(void)
{
    if(SPIM_IT_RX_FIFO_FULL & spim_get_intstatus())
    {
        /* Drain RX FIFO while data available */
        while(SPIM_FLAG_RECEIVE_FIFO_NOT_EMPTY & spim_get_status())
        {
            spi_rx_buf[test_rx_index] = spim_receive_data();
            test_rx_index = (test_rx_index < SPI_BYTE_NUM-1) ? test_rx_index+1 : 0;
        }
    }
    spim_int_clear();  /* Mandatory interrupt acknowledgment */
}

/**
 * @brief Main application entry point
 * @implements SPI Master test sequence:
 *  1. Initializes test buffers
 *  2. Configures SPI GPIOs
 *  3. Sets up SPI Master peripheral
 *  4. Configures interrupts
 *  5. Implements manual transmission trigger (GPIO-based)
 *  6. Executes data transfer
 *  7. Verifies transmission results
 */
int app_main(void)
{
    WDT_DIS();
    /* Test initialization */
    log_printf("SPI master 4-wire full-duplex test...\n");
    for(int i=0; i<SPI_BYTE_NUM; i++){
        spi_rx_buf[i] = 0;          /* Clear RX buffer */
        spi_tx_buf[i] = 0x11 + i;   /* Initialize TX pattern */
    }

    /* Hardware configuration */
    gpio_set_func_ex(spim0_pin_cfg, 4);  /* Configure 4 SPI pins */
    spim_deinit();                       /* Ensure clean state */

    /* SPI Master initialization */
    SPIM_InitTypeDef SPIM_InitStruct;
    spim_struct_init(&SPIM_InitStruct);  /* Load defaults */
    SPIM_InitStruct.int_mask = SPIM_IT_RX_FIFO_FULL;  /* Interrupt config */
    spim_init(&SPIM_InitStruct);

    /* NVIC configuration */
    NVIC_SetPriority(SPIM0_IRQn, IRQ_HIGH_PRIORITY);
    NVIC_EnableIRQ(SPIM0_IRQn);

    /* Wait for GPIO trigger (GPIO_PIN15 low) */
    gpio_set_input(1<<GPIO_PIN15, GPIO_MODE_IN_PULL_UP); 
    while(gpio_read_bits(1<<GPIO_PIN15) == SET);

    /* Transmission phase */
    gpio_write(1<<GPIO_PIN0, LOW);  /* Assert NSS */
    for(int i=0; i<SPI_BYTE_NUM; i++) {
        /* Block until TX FIFO space available */
        while(!(SPIM_FLAG_TRANSMIT_FIFO_NOT_FULL & spim_get_status())) {
            log_printf("spim status %x\n", spim_get_status());
        }
        spim_send_data(spi_tx_buf[i]);  /* Queue data */
    }

    /* Post-transmission cleanup */
    while(SPIM_FLAG_BUSY & spim_get_status());  /* Wait SPI idle */
    gpio_write(1<<GPIO_PIN0, HIGH);  /* Deassert NSS */

    /* Drain residual RX data */
    while(SPIM_FLAG_RECEIVE_FIFO_NOT_EMPTY & spim_get_status()) {
        spi_rx_buf[test_rx_index] = spim_receive_data();
        test_rx_index = (test_rx_index < SPI_BYTE_NUM-1) ? test_rx_index+1 : 0;
    }

    /* Result verification */
    delay_us(2000);  /* Allow console output stabilization */
    log_printf("    Send Data: ");
    for(int i=0; i<SPI_BYTE_NUM; i++) log_printf("0x%02x ", spi_tx_buf[i]);
    log_printf("\n    Recv Data: ");
    for(int i=0; i<SPI_BYTE_NUM; i++) log_printf("0x%02x ", spi_rx_buf[i]);
    log_printf("\n");

    while(1) { /* Maintenance loop */ }
    
    return 0;
}
