/*************************************************************************************************
 * @file       app_main.c
 * @brief      SPI Slave Demonstration Application
 * @details    Implements full-duplex SPI slave operation with features:
 *             - 4-wire SPI slave mode
 *             - Interrupt-driven RX FIFO handling
 *             - Preloaded TX buffer for loopback/demonstration
 *             - Diagnostic logging and result verification
 ************************************************************************************************/

 #include "include.h"
#include "driver_gpio.h"
#include "driver_spis.h"
#include "log_dbg.h"


/* SPI Slave GPIO Configuration (NSS, SCLK, MOSI, MISO) */
struct gpio_cfg_tag spis_pin_cfg[] = {
    {GPIO_PIN0,  SPIS_FUNC},  /* NSS (Slave Select) */
    {GPIO_PIN1,  SPIS_FUNC},  /* SCLK */
    {GPIO_PIN6,  SPIS_FUNC},  /* MOSI */
    {GPIO_PIN7,  SPIS_FUNC},  /* MISO */
};

#define SPI_BYTE_NUM 20  /* Test payload size */

/* Communication buffers */
uint8_t spi_rx_buf[SPI_BYTE_NUM];  /* Receive buffer */
uint8_t spi_tx_buf[SPI_BYTE_NUM];  /* Transmit buffer (preloaded) */
uint8_t test_rx_index = 0;         /* RX buffer index counter */

/**
 * @brief SPI Slave Interrupt Service Routine
 * @note Handles RX_FIFO_FULL interrupts:
 *       - Drains RX FIFO into receive buffer
 *       - Implements circular buffer index management
 *       - Clears interrupt flags automatically
 */
ATTRIBUTE_ISR void SPIS0_Handler(void)
{
	log_printf("spis int \n");
    if(SPIS_IT_RX_FIFO_FULL & spis_get_intstatus())
    {
        /* Process all available RX data */
        while(SPIS_FLAG_RECEIVE_FIFO_NOT_EMPTY & spis_get_status())
        {
            spi_rx_buf[test_rx_index] = spis_receive_data();
            test_rx_index = (test_rx_index < SPI_BYTE_NUM-1) ? test_rx_index+1 : 0;
        }
    }
    spis_int_clear();  /* Mandatory interrupt acknowledgment */
}

/**
 * @brief Main application entry point
 * @implements SPI Slave test sequence:
 *  1. Initializes test pattern buffers
 *  2. Configures SPI slave GPIOs
 *  3. Sets up SPI Slave peripheral
 *  4. Preloads TX buffer with test pattern
 *  5. Implements interrupt-driven communication
 *  6. Verifies transmission results
 */
int app_main(void)
{
    log_printf("SPI slave 4-wire full-duplex test...\n");

    WDT_DIS();

    /* Initialize test pattern */
    for(int i=0; i<SPI_BYTE_NUM; i++){
        spi_rx_buf[i] = 0;          /* Clear RX buffer */
        spi_tx_buf[i] = 0x11 + i;   /* Linear TX pattern */
    }

    /* Hardware configuration */
    gpio_set_func_ex(spis_pin_cfg, 4);  /* Configure 4 SPI pins */
    spis_deinit();                      /* Ensure clean state */

    /* SPI Slave initialization */
    SPIS_InitTypeDef SPIS_InitStruct;
    spis_struct_init(&SPIS_InitStruct);  /* Load defaults */
    SPIS_InitStruct.int_mask = SPIS_IT_RX_FIFO_FULL;  /* Interrupt config */
    spis_init(&SPIS_InitStruct);

    /* NVIC configuration */
    NVIC_SetPriority(SPIS0_IRQn, IRQ_HIGH_PRIORITY);
    NVIC_EnableIRQ(SPIS0_IRQn);

    /* Preload TX buffer */
    for(int i=0; i<SPI_BYTE_NUM; i++) {
        /* Block until TX FIFO space available */
        while(!(SPIS_FLAG_TRANSMIT_FIFO_NOT_FULL & spis_get_status()));
        spis_send_data(spi_tx_buf[i]);  /* Queue test data */
    }

    /* Wait for SPI transaction completion */
    while(SPIS_FLAG_BUSY & spis_get_status());

    /* Drain residual RX data */
    while(SPIS_FLAG_RECEIVE_FIFO_NOT_EMPTY & spis_get_status()) {
        spi_rx_buf[test_rx_index] = spis_receive_data();
        test_rx_index = (test_rx_index < SPI_BYTE_NUM-1) ? test_rx_index+1 : 0;
    }

    /* Result analysis */
    delay_us(2000);  /* Allow console output stabilization */
    log_printf("    Send Data: ");
    for(int i=0; i<SPI_BYTE_NUM; i++) log_printf("0x%02x ", spi_tx_buf[i]);
    log_printf("\n    Recv Data: ");
    for(int i=0; i<SPI_BYTE_NUM; i++) log_printf("0x%02x ", spi_rx_buf[i]);
    log_printf("\n");

    while(1) { /* Maintenance loop */ }
    
    return 0;
}
