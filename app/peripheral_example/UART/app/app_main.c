
/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-02-25
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "driver_gpio.h"
#include "driver_uart.h"
#include "driver_clkcal.h"


// 定义 UART 测试使用的端口及波特率
#define UART_TEST_PORT       UART1
#define UART_TEST_BAUDRATE   UART_BAUDRATE_115200

// 定义 UART 接收缓冲区大小
#define UART_RX_BUFFER_SIZE  32

// 用于中断接收模式的全局变量：接收缓冲区和索引
uint8_t uart_test_rx_buffer[UART_RX_BUFFER_SIZE] = {0};

// 在中断使用的变量用volatile修饰可避免被编译器优化
volatile uint8_t uart_test_rx_index = 0;


/**
 * @brief UART 发送测试示例函数
 *
 * 说明:
 *   - 初始化指定的 UART 端口
 *   - 循环发送字符串 "1234567890" 每 1 秒一次
 *
 * @return 无
 */
void uart_send_example(void)
{
	log_printf("%s \n",__FUNCTION__);
	uint8_t msg[] ="1234567890";
	uart_init(UART_TEST_PORT,UART_TEST_BAUDRATE);

	while(1)
	{
		// 发送字符串（不发送末尾 '\0'）
		uart_send(UART_TEST_PORT,msg,sizeof(msg)-1);
		clkcal_delayms(1000);

	}
}

/**
 * @brief UART 轮询接收测试示例函数
 *
 * 说明:
 *   - 初始化指定的 UART 端口
 *   - 通过轮询方式检测是否有数据接收
 *   - 当检测到数据时，对接收字符简单处理（+1 算术）后，通过 UART 发送出去
 *
 * @return 无
 */
void uart_recv_example(void)
{
	log_printf("%s \n",__FUNCTION__);
	uint8_t reg_val = 0;
	uart_init(UART_TEST_PORT,UART_TEST_BAUDRATE);
	while(1)
	{
        reg_val = uart_get_status(UART_TEST_PORT);

        if (reg_val&0x1)
        {
            reg_val = uart_getchar(UART_TEST_PORT);

            uart_putchar(UART_TEST_PORT, (reg_val+1));
        }
	}
}

// 注意：BLE连接场景下，为了不影响BLE连接性能，此函数放在RAM中执行，且代码尽量精简，
// 即在中断里面仅接收缓存串口数据，通过标志位在主循环解析操作具体应用逻辑
__RAM_CODE_SECTION ATTRIBUTE_ISR void UART0_Handler(void)
{
	uint8_t reg_val = uart_get_state(UART0);
	reg_val = uart_get_status(UART0);

	if (reg_val&0x1)
	{
		uart_test_rx_buffer[uart_test_rx_index++] = uart_getchar(UART0);
		if(uart_test_rx_index >= UART_RX_BUFFER_SIZE)uart_test_rx_index = 0;
	}

}

// 注意：BLE连接场景下，为了不影响BLE连接性能，此函数放在RAM中执行，且代码尽量精简，
// 即在中断里面仅接收缓存串口数据，通过标志位在主循环解析操作具体应用逻辑
__RAM_CODE_SECTION ATTRIBUTE_ISR void UART1_Handler(void)
{
	uint8_t reg_val = uart_get_state(UART1);
	reg_val = uart_get_status(UART1);

	if (reg_val&0x1)
	{
		uart_test_rx_buffer[uart_test_rx_index++] = uart_getchar(UART1);
		if(uart_test_rx_index >= UART_RX_BUFFER_SIZE)uart_test_rx_index = 0;
	}
}

/**
 * @brief UART 中断接收测试示例函数
 *
 * 说明:
 *   - 初始化 UART 并使能接收中断（本例使用 UART0）
 *   - 定期检查接收缓冲区内是否有数据
 *   - 有数据时，将缓冲区所有数据一次性发送出去，并随后清空接收缓冲区
 *
 * @return 无
 */
void uart_recv_init_example(void)
{
	log_printf("%s \n",__FUNCTION__);
	uart_init(UART_TEST_PORT,UART_TEST_BAUDRATE);
	uart_int_enable(UART_TEST_PORT,DISABLE,ENABLE);
	while(1)
	{
		if(uart_test_rx_index)
		{
			clkcal_delayms(100);
			uart_send(UART_TEST_PORT,uart_test_rx_buffer,uart_test_rx_index);
			uart_test_rx_index = 0;
			for(uint8_t i=0;i<UART_RX_BUFFER_SIZE;i++)
			uart_test_rx_buffer[i] = 0;
			
		}
	}
}

/**
 * @brief UART 测试总入口函数
 *
 * 说明:
 *   - 配置 UART 对应的 GPIO 引脚功能，确保 TX 与 RX 引脚正确设置
 *   - 根据实际需求选择并调用具体的测试示例：
 *       1. 发送测试：调用 uart_send_example()
 *       2. 轮询接收测试：调用 uart_recv_example()
 *       3. 中断接收测试：调用 uart_recv_init_example()
 *
 *
 * @return 无
 */
void uart_test_example(void)
{
	// 配置 UART 引脚，注意：这里的 GPIO_PIN8 与 GPIO_PIN9 需根据实际硬件进行调整
    uart_set_port(UART_TEST_PORT,GPIO_PIN8,GPIO_PIN9);
	
    // 选择需要执行的测试示例：
	uart_send_example();        	// UART 发送测试
//	uart_recv_example();  		    // UART 轮询接收测试
//	uart_recv_init_example(); 		// UART 中断接收测试
}



void app_main(void)
{
	WDT_DIS();

    uart_test_example();

}