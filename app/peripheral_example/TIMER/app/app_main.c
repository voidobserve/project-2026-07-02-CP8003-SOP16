/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief      定时器应用示例主程序文件
 * @version    1.0.1
 * @date       2025-02-25
 * 
 * @copyright Copyright (c) 2025, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "log_dbg.h"
#include "driver_timer.h"
#include "driver_gpio.h"

/* 宏定义说明 */
#define TEST_GPIO_0_FLAG     (1<<GPIO_PIN0)  		// 测试用GPIO0引脚标志
#define TEST_GPIO_1_FLAG     (1<<GPIO_PIN1)  		// 测试用GPIO1引脚标志
#define TEST_GPIO_21_FLAG    (1<<GPIO_PIN21) 		// 测试用GPI21引脚标志

/* 定时器周期设置 */
#define TIMER1_PERIOD        (200)          // 定时器1周期：200us
#define TIMER2_PERIOD        (500)          // 定时器2周期：500us
#define TIMER3_PERIOD        (1000)         // 定时器3周期：1000us (1ms)
#define TIMER4_PERIOD        (2000)         // 定时器4周期：2ms
#define TIMER5_PERIOD        (5000)         // 定时器5周期：5ms
#define TIMER6_PERIOD        (10000)        // 定时器6周期：10ms
#define TIMER7_PERIOD        (20000)        // 定时器7周期：20ms

/* 定时器中断计数阈值 */
#define TIMER4_THRESHOLD     (500)          // 定时器4计数阈值，用于1秒打印 (2ms * 500 = 1s)
#define TIMER5_THRESHOLD     (400)          // 定时器5计数阈值，用于2秒打印 (5ms * 400 = 2s)
#define TIMER6_THRESHOLD     (300)          // 定时器6计数阈值，用于3秒打印 (10ms * 300 = 3s)
#define TIMER7_THRESHOLD     (250)          // 定时器7计数阈值，用于5秒打印 (20ms * 250 = 5s)

/* 静态变量用于定时器中断计数 */
static uint32_t timer4_count = 0;
static uint32_t timer5_count = 0;
static uint32_t timer6_count = 0;
static uint32_t timer7_count = 0;


/*************************************************************************************************
 * @brief 定时器1中断服务函数
 * @note 在定时器周期到达时翻转GPIO0状态
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER1_Handler(void)
{
	// 函数作用：定时器1的中断服务函数，用于在定时器周期到达时翻转GPIO0引脚状态。
	static uint8_t gpio_0_flag = 0; 			// 静态变量，用于记录GPIO0的当前状态
	
	gpio_0_flag ^= 0x01;
	gpio_write(TEST_GPIO_0_FLAG,gpio_0_flag); 	// 将GPIO0引脚设置为高电平
	
	timerx_int_clear(TIMER1);					// 清除定时器中断标志位，以便下次中断可以正常触发
}

/*************************************************************************************************
 * @brief 定时器2中断服务函数
 * @note 在定时器周期到达时翻转GPIO1状态
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER2_Handler(void)
{
	// 函数作用：定时器2的中断服务函数，用于在定时器周期到达时翻转GPIO1引脚状态。
	static uint8_t gpio_1_flag = 0; 			// 静态变量，用于记录GPIO1的当前状态
	
	gpio_1_flag ^= 0x01;
	gpio_write(TEST_GPIO_1_FLAG,gpio_1_flag); 	// 将GPIO1引脚设置为高电平
	
	timerx_int_clear(TIMER2);					// 清除定时器中断标志位，以便下次中断可以正常触发
}

/*************************************************************************************************
 * @brief 定时器3中断服务函数
 * @note 在定时器周期到达时翻转GPIO21状态
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER3_Handler(void)
{
	// 函数作用：定时器3的中断服务函数，用于在定时器周期到达时翻转GPIO21引脚状态。
	static uint8_t gpio_21_flag = 0; 			// 静态变量，用于记录GPIO21的当前状态
	gpio_21_flag ^= 0x01;
	gpio_write(TEST_GPIO_21_FLAG,gpio_21_flag); // 将GPIO1引脚设置为高电平
	
	timerx_int_clear(TIMER3);        			// 清除定时器中断标志位，以便下次中断可以正常触发
}

/*************************************************************************************************
 * @brief 定时器4中断服务函数
 * @note 累加计数器timer4_count
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER4_Handler(void)
{
	timer4_count++; 							// 累加定时器4的计数器
	timerx_int_clear(TIMER4); 					// 清除定时器中断标志位，以便下次中断可以正常触发
}


/*************************************************************************************************
 * @brief 定时器5中断服务函数
 * @note 累加计数器timer5_count
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER5_Handler(void)
{
	timer5_count++; 							// 累加定时器5的计数器
	timerx_int_clear(TIMER5); 					// 清除定时器中断标志位，以便下次中断可以正常触发
}

/*************************************************************************************************
 * @brief 定时器6中断服务函数
 * @note 累加计数器timer6_count
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER6_Handler(void)
{
	timer6_count++; 							// 累加定时器6的计数器
	timerx_int_clear(TIMER6);					// 清除定时器中断标志位，以便下次中断可以正常触发
}

/*************************************************************************************************
 * @brief 定时器7中断服务函数
 * @note 累加计数器timer7_count
 ************************************************************************************************/
__RAM_CODE_SECTION ATTRIBUTE_ISR void TIMER7_Handler(void)
{
	timer7_count++; 							// 累加定时器7的计数器
	timerx_int_clear(TIMER7); 					// 清除定时器中断标志位，以便下次中断可以正常触发
}


/*************************************************************************************************
 * @brief 定时器测试示例函数
 * @note 初始化GPIO和定时器，进入主循环
 * @param 无
 ************************************************************************************************/
void timer_test_example(void)
{
	// 函数作用：定时器测试示例函数，用于演示如何初始化GPIO和定时器，并通过定时器中断来控制GPIO的状态翻转和计数。
	// 传入参数：无
	log_printf("%s \n",__FUNCTION__); 				// 打印当前函数名，用于调试

	//GPIO Init
	gpio_set_output(TEST_GPIO_0_FLAG,GPIO_HIGH); 	// 设置GPIO0引脚为输出模式，并初始化为高电平
	gpio_set_output(TEST_GPIO_1_FLAG,GPIO_HIGH); 	// 设置GPIO1引脚为输出模式，并初始化为高电平
	gpio_set_output(TEST_GPIO_21_FLAG,GPIO_HIGH); 	// 设置GPIO21引脚为输出模式，并初始化为高电平

	//Timer Init
	timer_init(TIMER1,TIMER1_PERIOD); 				// 初始化定时器1，设置定时周期为TIMER1_PERIOD
	timer_init(TIMER2,TIMER2_PERIOD); 				// 初始化定时器2，设置定时周期为TIMER2_PERIOD
	timer_init(TIMER3,TIMER3_PERIOD); 				// 初始化定时器3，设置定时周期为TIMER3_PERIOD
	timer_init(TIMER4,TIMER4_PERIOD); 				// 初始化定时器4，设置定时周期为TIMER4_PERIOD
	timer_init(TIMER5,TIMER5_PERIOD); 				// 初始化定时器5，设置定时周期为TIMER5_PERIOD
	timer_init(TIMER6,TIMER6_PERIOD); 				// 初始化定时器6，设置定时周期为TIMER6_PERIOD
	timer_init(TIMER7,TIMER7_PERIOD); 				// 初始化定时器7，设置定时周期为TIMER7_PERIOD

	while(1)
	{
		// 主循环，程序将在此循环中运行，检查定时器计数是否达到阈值，并打印信息
		if (timer4_count >= TIMER4_THRESHOLD)
		{
			log_printf("Timer4 count reached 1 second\n"); // 打印定时器4计数达到1秒的信息
			timer4_count = 0; // 重置定时器4计数器
		}
		if (timer5_count >= TIMER5_THRESHOLD)
		{
			log_printf("Timer5 count reached 2 seconds\n"); // 打印定时器5计数达到2秒的信息
			timer5_count = 0; // 重置定时器5计数器
		}
		if (timer6_count >= TIMER6_THRESHOLD)
		{
			log_printf("Timer6 count reached 3 seconds\n"); // 打印定时器6计数达到3秒的信息
			timer6_count = 0; // 重置定时器6计数器
		}
		if (timer7_count >= TIMER7_THRESHOLD)
		{
			log_printf("Timer7 count reached 5 seconds\n"); // 打印定时器7计数达到5秒的信息
			timer7_count = 0; // 重置定时器7计数器
		}
		
	}
}

/*************************************************************************************************
 * @brief 应用程序主函数
 * @note 系统启动入口，调用测试示例
 * @return 程序执行状态（始终返回0）
 ************************************************************************************************/
int app_main(void)
{
	WDT_DIS();
	// 调用定时器测试示例函数
	timer_test_example();

    return 0; // 返回0，表示程序执行成功
}
