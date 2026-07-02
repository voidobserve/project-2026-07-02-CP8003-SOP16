/*************************************************************************************************
 * @file       app_remoter.h
 * @brief      遥控器应用层头文件
 * @date       2025.11.06
 ************************************************************************************************/
#ifndef _APP_REMOTER_H_
#define _APP_REMOTER_H_

#include <stdint.h>

/* 全局变量声明 */
extern volatile uint8_t led_blink_flag;
extern volatile uint8_t led_blink_times;
extern volatile uint8_t key_activity_flag;  // 按键活动标志：1=有按键活动，0=无按键

/* 函数声明 */
void app_remoter_gpio_init(void);
void app_remoter_key_scan(void);
void app_remoter_led_blink(void);

#endif
