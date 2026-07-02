/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.0
 * @date       2024-07-25
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
 *                  All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "log_dbg.h"
#include "hal_clock.h"
#include "api_sleep_wakeup.h"
#include "driver_keyscan.h"

#define KEY_BIT_MASK (0x06FE)                                               // 按键位掩码,用于配置需要扫描的按键位
//例如这里的 0 x 06 FE 等于 110 1111 1110，分别对应 KEYSCAN_LINE_10~KEYSCAN_LINE_0 的使能位

#define LONG_PRESS_TIME_MS      2000                                        // 长按阈值时间(毫秒)
#define LONG_PRESS_REPEAT_MS    200                                         // 长按重复触发间隔(毫秒)

keyscan_result_typedef result_str;                                          // 按键扫描结果结构体,用于存储按键扫描的结果

// 长按检测相关变量
uint32_t key_press_time = 0;                                                // 按键按下时间戳
uint8_t  last_key_val = 0xFF;                                               // 上一次按下的按键值(0xFF表示无按键)
uint8_t  key_state = 0;                                                     // 按键状态: 0=空闲, 1=按下, 2=长按中
uint32_t last_repeat_time = 0;                                              // 上次长按重复触发时间

uint32_t sleep_T;
uint8_t sleep_cnt;

extern uint32_t enter_sleep_mode(void);

/**
 * @brief  按键扫描测试函数(带长按检测)
 *         功能说明: 初始化按键扫描模块并循环检测按键事件
 *         支持: 短按、长按、长按重复触发
 * @param  无
 * @retval 无
 */
void keyscan_test(void)
{
	log_printf("keyscan_test with long press support\n");
	//keyscan init
	keyscan_init_typedef keyscan_init_struct;                               // 按键扫描初始化结构体
	keyscan_init_struct.key_mask = (KEY_BIT_MASK & KEYSCAN_ALL_MASK);       // 设置按键掩码,指定需要扫描的按键
	keyscan_init_struct.key_mode = 0;                                       // 设置按键模式
	keyscan_init_struct.key_wakeup = 0;                                     // 设置按键唤醒功能
	keyscan_init_struct.key_debounce = 0xA;                                 // 设置按键消抖时间
	keyscan_init_struct.key_area = KEYSCAN_AREA_ALL;                        // 设置按键扫描区域为全部区域
	keyscan_init_struct.keyscan_delay = 0xFF;                               // 设置按键扫描延时
	keyscan_init_struct.key_comb = 0x0;                                     // 设置组合键配置
	keyscan_init(&keyscan_init_struct);                                     // 初始化按键扫描模块
	
	while(1)
	{
		hal_clock_time_run();                                               // 更新系统时钟
		
		if(result_str.key_valid)                                        	// 检查是否有有效的按键事件
		{
			result_str.key_valid = 0;                               		// 清除按键有效标志
			
			if(result_str.key_num > 0)                                      // 有按键按下
			{
				uint8_t current_key = result_str.key_val[0];
				
				log_printf("current_key:%d",current_key);
				
				if(key_state == 0)                                          // 空闲状态 -> 按下
				{
					key_state = 1;
					last_key_val = current_key;
					key_press_time = hal_clock_get_system_tick();
					log_printf("[SHORT] key_press: %d\r\n", current_key);   // 按下事件
				}
			}
			else                                                            // 按键释放
			{
				if(key_state == 1)                                          // 短按释放
				{
					log_printf("[SHORT] key_release: %d\r\n", last_key_val);
				}
				else if(key_state == 2)                                     // 长按释放
				{
					log_printf("[LONG] key_release: %d\r\n", last_key_val);
				}
				key_state = 0;
				last_key_val = 0xFF;
			}
		}
		
		// 长按检测逻辑
		if(key_state == 1)                                                  // 按下状态,检测是否达到长按
		{
			if(hal_clock_time_exceed(key_press_time, LONG_PRESS_TIME_MS * 1000))
			{
				key_state = 2;                                              // 进入长按状态
				last_repeat_time = hal_clock_get_system_tick();
				log_printf("[LONG] key_long_press: %d\r\n", last_key_val);  // 首次长按触发
			}
		}
		else if(key_state == 2)                                             // 长按状态,持续触发
		{
			if(hal_clock_time_exceed(last_repeat_time, LONG_PRESS_REPEAT_MS * 1000))
			{
				last_repeat_time = hal_clock_get_system_tick();
				log_printf("[LONG] key_repeat: %d\r\n", last_key_val);      // 长按重复触发
			}
		}
	}
	
}



void keyscan_and_sleep(void)
{
	log_printf("keyscan_and_sleep with long press support\n");
	//keyscan init
	keyscan_init_typedef keyscan_init_struct;                               // 按键扫描初始化结构体
	keyscan_init_struct.key_mask = (KEY_BIT_MASK & KEYSCAN_ALL_MASK);       // 设置按键掩码,指定需要扫描的按键
	keyscan_init_struct.key_mode = 0;                                       // 设置按键模式
	keyscan_init_struct.key_wakeup = 0;                                     // 设置按键唤醒功能
	keyscan_init_struct.key_debounce = 0xA;                                 // 设置按键消抖时间
	keyscan_init_struct.key_area = KEYSCAN_AREA_ALL;                        // 设置按键扫描区域为全部区域
	keyscan_init_struct.keyscan_delay = 0xFF;                               // 设置按键扫描延时
	keyscan_init_struct.key_comb = 0x0;                                     // 设置组合键配置
	keyscan_init(&keyscan_init_struct);                                     // 初始化按键扫描模块
	
	while(1)
	{
		hal_clock_time_run();
		
		if(result_str.key_valid)                                        	// 检查是否有有效的按键事件
		{
			result_str.key_valid = 0;                               		// 清除按键有效标志
			
			if(result_str.key_num > 0)                                      // 有按键按下
			{
				uint8_t current_key = result_str.key_val[0];
				
				if(key_state == 0)                                          // 空闲状态 -> 按下
				{
					key_state = 1;
					last_key_val = current_key;
					key_press_time = hal_clock_get_system_tick();
					sleep_cnt = 0;                                          // 有按键操作，重置休眠计数
					sleep_T = hal_clock_get_system_tick();
					log_printf("[SHORT] key_press: %d\r\n", current_key);   // 按下事件
				}
			}
			else                                                            // 按键释放
			{
				if(key_state == 1)                                          // 短按释放
				{
					log_printf("[SHORT] key_release: %d\r\n", last_key_val);
				}
				else if(key_state == 2)                                     // 长按释放
				{
					log_printf("[LONG] key_release: %d\r\n", last_key_val);
				}
				key_state = 0;
				last_key_val = 0xFF;
			}
		}
		
		// 长按检测逻辑
		if(key_state == 1)                                                  // 按下状态,检测是否达到长按
		{
			if(hal_clock_time_exceed(key_press_time, LONG_PRESS_TIME_MS * 1000))
			{
				key_state = 2;                                              // 进入长按状态
				last_repeat_time = hal_clock_get_system_tick();
				log_printf("[LONG] key_long_press: %d\r\n", last_key_val);  // 首次长按触发
			}
		}
		else if(key_state == 2)                                             // 长按状态,持续触发
		{
			if(hal_clock_time_exceed(last_repeat_time, LONG_PRESS_REPEAT_MS * 1000))
			{
				last_repeat_time = hal_clock_get_system_tick();
				log_printf("[LONG] key_repeat: %d\r\n", last_key_val);      // 长按重复触发
			}
		}
		
		// 休眠逻辑：只有在空闲状态下才进行休眠计时
		if(key_state == 0)
		{
			if(hal_clock_time_exceed(sleep_T, 1000*1000))                   // 1s查询一次
			{
				sleep_T = hal_clock_get_system_tick();
				sleep_cnt++;
				
				log_printf("sleep_cnt:%d\r\n", sleep_cnt);
				
				if(sleep_cnt > 5)
				{
					log_printf("enter sleep\r\n");
					
					keyscan_wakeup_en(&keyscan_init_struct, 1);
					
					enter_sleep_mode();
					
					log_printf("wakeup IO:%x \r\n", AON_CTRL->WAKEUP_RECORD);
					
					// 唤醒后必须重新初始化外设和状态
					keyscan_init(&keyscan_init_struct);
					sleep_cnt = 0;                                          // 重置休眠计数
					key_state = 0;                                          // 重置按键状态
					last_key_val = 0xFF;
					sleep_T = hal_clock_get_system_tick();
				}
			}
		}
		else
		{
			// 有按键操作时，重置休眠计时
			sleep_T = hal_clock_get_system_tick();
			sleep_cnt = 0;
		}
	}
	
}


/**
 * @brief  按键扫描中断服务函数
 *         功能说明: 处理按键扫描中断,读取按键扫描结果并清除中断标志
 * @param  无
 * @retval 无
 */
ATTRIBUTE_ISR void KEYSCAN_Handler(void)
{
	keyscan_handler(&result_str);                                           // 调用按键扫描处理函数,将结果存储到result_str中
	keyscan_int_clear();                                                    // 清除按键扫描中断标志
}

/**
 * @brief  应用程序主函数
 *         功能说明: 程序入口函数,禁用看门狗并启动按键扫描测试
 * @param  无
 * @retval 返回0表示正常结束
 */
int app_main(void)
{
	WDT_DIS();                                                             
	
	keyscan_test();                                                         // 启动按键扫描测试
	
	//keyscan_and_sleep();
	
    return 0;                                                                  
}