/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-03-07
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "log_dbg.h"
#include "driver_gpio.h"

/*************************************************************************************************
 * @宏定义说明：
 * TEST_GPIO_OUTPUT        - 输出测试GPIO（GPIO00）
 * TEST_GPIO_INPUT_PULL_UP - 上拉输入测试GPIO（GPIO06）
 * TEST_GPIO_INPUT_PULL_DOWN - 下拉输入测试GPIO（GPIO07）
 * TEST_GPIO_INTERRUPT_RISING - 上升沿中断测试GPIO（GPIO15）
 * TEST_GPIO_INTERRUPT_FALLING - 下降沿中断测试GPIO（GPIO18）
 * TEST_GPIO_INTERRUPT_HIGH - 高电平中断测试GPIO（GPIO20）
 ************************************************************************************************/
#define TEST_GPIO_OUTPUT        	(1<<GPIO_PIN0)   // GPIO0
#define TEST_GPIO_INPUT_PULL_UP     (1<<GPIO_PIN6)   // GPIO06
#define TEST_GPIO_INPUT_PULL_DOWN   (1<<GPIO_PIN7)   // GPIO07
#define TEST_GPIO_INTERRUPT_RISING  (1<<GPIO_PIN15)  // GPIO15上升沿中断测试GPIO
#define TEST_GPIO_INTERRUPT_FALLING (1<<GPIO_PIN18)  // GPIO18下降沿中断测试GPIO
#define TEST_GPIO_INTERRUPT_HIGH 	(1<<GPIO_PIN20)  // GPIO20高电平中断测试GPIO




/*************************************************************************************************
 * @全局变量：
 * gpio_test_flag - GPIO测试标志位，用于状态翻转（0/1）
 ************************************************************************************************/
volatile uint8_t gpio_test_flag = 0;

/*************************************************************************************************
 * @函数作用：GPIO输出测试
 * @功能说明：
 *    - 初始化指定GPIO为输出模式
 *    - 周期性翻转GPIO输出状态（500ms间隔）
 * @传入参数：无
 ************************************************************************************************/
void gpio_output_test(void)
{
	log_printf("%s \n",__FUNCTION__);
	gpio_set_output(TEST_GPIO_OUTPUT,GPIO_HIGH);
	
	while(1)
	{
		gpio_test_flag ^= 1;
		gpio_write(TEST_GPIO_OUTPUT,gpio_test_flag);
		delay_ms(500);
		log_printf("loop \n");
	}
	
}

/*************************************************************************************************
 * @函数作用：GPIO输入测试
 * @功能说明：
 *    - 配置GPIO06为上拉输入模式
 *    - 配置GPIO07为下拉输入模式
 *    - 循环检测并打印输入状态变化
 * @传入参数：无
 ************************************************************************************************/
void gpio_input_test(void)
{
	log_printf("%s \n",__FUNCTION__);
    gpio_set_input(TEST_GPIO_INPUT_PULL_UP, GPIO_MODE_IN_PULL_UP);    // GPIO06上拉
    gpio_set_input(TEST_GPIO_INPUT_PULL_DOWN, GPIO_MODE_IN_PULL_DOWN);// GPIO07下拉
    
    while(1)
    {
        uint32_t status = gpio_read();
        // 检测GPIO06低电平
        if(!(status & TEST_GPIO_INPUT_PULL_UP)) {
            log_printf("GPIO06 LOW detected\n");
        }
        // 检测GPIO07高电平
        if(status & TEST_GPIO_INPUT_PULL_DOWN) {
            log_printf("GPIO07 HIGH detected\n");
        }
        delay_ms(100);
    }

}

/*************************************************************************************************
 * @函数作用：GPIO中断测试
 * @功能说明：
 *    - 配置不同GPIO的中断触发模式
 *    - 包括：上升沿、下降沿、高电平、低电平触发
 * @传入参数：无
 ************************************************************************************************/
void gpio_inttrupt_test(void)
{
	log_printf("%s \n",__FUNCTION__);
    // 配置各GPIO输入模式
    gpio_set_input(TEST_GPIO_INTERRUPT_RISING, GPIO_MODE_IN_PULL_DOWN);  // GPIO15下拉
    gpio_set_input(TEST_GPIO_INTERRUPT_FALLING, GPIO_MODE_IN_PULL_UP);   // GPIO18上拉
    gpio_set_input(TEST_GPIO_INTERRUPT_HIGH, GPIO_MODE_IN_PULL_DOWN); 	 // GPIO20下拉
    
    // 配置中断触发方式
    gpio_interrupt_config(TEST_GPIO_INTERRUPT_RISING, GPIO_IT_RISING);   // 上升沿
    gpio_interrupt_config(TEST_GPIO_INTERRUPT_FALLING, GPIO_IT_FALLING); // 下降沿
    gpio_interrupt_config(TEST_GPIO_INTERRUPT_HIGH, GPIO_IT_HIGH);       // 高电平
    
    while(1) { /* 空循环等待中断 */ }
}

/*************************************************************************************************
 * @函数作用：GPIO中断服务函数
 * @功能说明：
 *    - 处理所有GPIO中断事件
 *    - 识别具体中断源并打印对应信息
 *    - 清除已处理的中断标志
 * @传入参数：无
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void GPIO_Handler(void)
{
	uint32_t status = gpio_get_int_status();
    
    if(status & TEST_GPIO_INTERRUPT_RISING) 	log_printf("GPIO15 Rising Edge\n");
    if(status & TEST_GPIO_INTERRUPT_FALLING) 	log_printf("GPIO18 Falling Edge\n");
    if(status & TEST_GPIO_INTERRUPT_HIGH) 		log_printf("GPIO20 High Level\n");
    
    gpio_int_clear(TEST_GPIO_INTERRUPT_RISING|TEST_GPIO_INTERRUPT_FALLING|TEST_GPIO_INTERRUPT_HIGH);
	
}

/*************************************************************************************************
 * @函数作用：主应用程序入口
 * @功能说明：
 *    - 程序执行入口函数
 *    - 通过注释切换不同测试模式
 *    - 当前启用中断测试模式
 * @传入参数：无
 ************************************************************************************************/
int app_main(void)
{
    WDT_DIS();
	//GPIO输出测试例程
	gpio_output_test();
	
	//GPIO输入测试例程
//	gpio_input_test();
	
	//GPIO中断测试例程
//	gpio_inttrupt_test();
	
    return 0;
}
