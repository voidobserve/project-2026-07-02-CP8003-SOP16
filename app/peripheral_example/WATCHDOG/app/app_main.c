/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-02-23
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "driver_gpio.h"
#include "driver_clkcal.h"
#include "driver_wdt.h"
#include "log_dbg.h"

// 宏定义说明：
// TEST_WDT_RESET_OR_INT - 用于选择看门狗工作模式
// 0 表示测试看门狗复位模式：当看门狗计时超时时，将触发系统复位
// 1 表示测试看门狗中断模式：当看门狗计时超时时，将触发中断（此模式下，正常情况GPIO_PIN3会周期性翻转，并通过串口打印数据）
#define TEST_WDT_RESET_OR_INT 1     //0是测试wdt复位，1是测试wdt中断
                                    //正常情况：GPIO_PIN3周期翻转以及串口打印数据

#define TEST_GPIO_BITS              (1<<GPIO_PIN0)

/**
 * 函数作用说明：看门狗中断服务函数
 *               当看门狗计时器触发中断时，系统自动进入该函数以进行中断处理。
 *               处理流程包括：清除中断状态、切换GPIO输出状态、打印日志以及重新喂狗，重新启动计时器。
 *
 * 传入的参数说明：无
 */
__RAM_CODE_SECTION ATTRIBUTE_ISR void WDT_Handler(void)
{
    static uint8_t high_low = 1;  
    
    // 清除看门狗中断状态，防止中断重复触发
    wdt_clr_int_status();
    
    // 根据当前状态设置指定GPIO引脚的输出电平，实现输出翻转效果
    gpio_set_output(TEST_GPIO_BITS, high_low);
    
    high_low ^= 1;
    
    log_printf("wdt interrrupt\r\n");
    
    // 喂狗操作，重置看门狗计数器，超时时间设置为2000毫秒
    wdt_feed(2000);
}


/**
 * 函数作用说明：应用程序入口函数
 *               该函数完成系统初始化（例如日志模块、看门狗、GPIO等）并根据预编译宏选择相应的看门狗模式，
 *               最后进入一个无限循环，等待看门狗触发复位或中断。
 *
 * 传入的参数说明：无
 */
int app_main(void)
{
    WDT_DIS();
    
#if(TEST_WDT_RESET_OR_INT == 0)   // 测试看门狗复位模式
    // 设置测试用的GPIO为高电平，便于从GPIO状态确认系统状态
    gpio_set_output(TEST_GPIO_BITS, GPIO_HIGH);
    
    // 检查看门狗是否记录了系统因超时而复位的情况
    if(wdt_get_reset_record() == TRUE)
    {
        // 如果检测到复位记录，则清除该记录，避免重复判断
        wdt_clr_reset_record();
        // 打印日志信息，提示系统曾因看门狗超时而复位
        log_printf("wdt reset\r\n");
    }
    
    // 配置看门狗参数：
    //   enable_status: TRUE 表示使能看门狗
    //   mode: WDT_RESET_MODE 设置为复位模式
    //   period_ms: 2000 毫秒超时
    wdt_cfg_t cfg = {.enable_status = TRUE, .mode = WDT_RESET_MODE, .period_ms = 2000};
    // 初始化看门狗，根据传入的配置参数
    wdt_init(&cfg);
#else                            // 测试看门狗中断模式
    // 配置看门狗参数：
    wdt_cfg_t cfg = 
	{	.enable_status = TRUE, 	//enable_status: TRUE 表示使能看门狗
		.mode = WDT_INT_MODE,	//mode: WDT_INT_MODE 设置为中断模式
		.period_ms = 2000		//period_ms: 2000 毫秒超时
	};
    // 初始化看门狗，根据传入的配置参数
    wdt_init(&cfg);
    
    // 在NVIC中设置看门狗中断的优先级，设置为中等优先级
    NVIC_SetPriority(WDT_IRQn, IRQ_MED_PRIORITY);
    // 使能看门狗中断，使系统能够响应看门狗超时时的中断请求
    NVIC_EnableIRQ(WDT_IRQn);
#endif
    while(1)
    {
	   //喂狗操作，取消注释则不会定时溢出发生复位或者中断
       //wdt_feed(2000);
    }
    
    return 0;
}
