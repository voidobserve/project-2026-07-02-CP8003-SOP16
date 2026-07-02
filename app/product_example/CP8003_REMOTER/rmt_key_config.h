/*************************************************************************************************
 * @file       rmt_key_config.h
 * @brief      遥控器按键配置
 * @version    1.0.0
 * @date       2025.11.04
 * 
 * @note       
 ************************************************************************************************/
#ifndef _RMT_KEY_CONFIG_H_
#define _RMT_KEY_CONFIG_H_

#include "driver_gpio.h"

/* ==================== 产品选择 ==================== */
#define RMT_30KEY     0x0030  // 30键 (25个矩阵键 + 5个GND键) - 5行5列配置
#define RMT_28KEY     0x0028  // 28键 (24个矩阵键 + 4个GND键) - 4行6列配置
#define RMT_25KEY     0x0025  // 25键 (20个矩阵键 + 5个GND键) - 5行4列配置
#define RMT_12KEY     0x0012  // 12键 (7个矩阵键 + 5个GND键)  - 5行自定义配置

#define PRODUCT_SELECTION  RMT_28KEY  // 兼容旧AK803参考工程当前使用的28键产品


// 位掩码宏定义，用于简化按键表配置
#define PIN0   (1 << GPIO_PIN0)
#define PIN1   (1 << GPIO_PIN1)
#define PIN6   (1 << GPIO_PIN6)
#define PIN7   (1 << GPIO_PIN7)
#define PIN8   (1 << GPIO_PIN8)

#define PIN9   (1 << GPIO_PIN9)
#define PIN15  (1 << GPIO_PIN15)
#define PIN18  (1 << GPIO_PIN18)
#define PIN19  (1 << GPIO_PIN19)
#define PIN20  (1 << GPIO_PIN20)
#define PIN21  (1 << GPIO_PIN21)

// GND扫描按键定义（虚拟GPIO位）
#define GNDB  (1<<22)      

// 指示灯
#define SINGLE_LED_GPIO   GPIO_PIN9    

// 按AK803 SOP16旧板物理脚位映射配置：
// AK803输出 GPIO00/GPIO01/GPIO02/GPIO07/GPIO09/GPIO10 -> CP8003 P8/P0/P7/P15/P6/P1
// AK803输入 GPIO03/GPIO04/GPIO05/GPIO06 -> CP8003 P21/P20/P19/P18
#define OUTPUT_PINS  GPIO_PIN8, GPIO_PIN0, GPIO_PIN7, GPIO_PIN15, GPIO_PIN6, GPIO_PIN1
#define INPUT_PINS   GPIO_PIN21, GPIO_PIN20, GPIO_PIN19, GPIO_PIN18

/* ==================== 按键时间配置 ==================== */
#define DEFAULT_SHORT_THRESHOLD  50    // 默认短按消抖时间(ms)
#define DEFAULT_LONG_THRESHOLD   2000  // 默认长按触发时间(ms)


/* ==================== 矩阵配置（无需更改） ==================== */
// 辅助宏：计算可变参数个数（支持1-8个参数）
#define COUNT_ARGS_IMPL(_1, _2, _3, _4, _5, _6, _7, _8, N, ...) N
#define COUNT_ARGS(...) COUNT_ARGS_IMPL(__VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1)

//以下自动计算，无需修改
#define OUTPUT_PIN_NUM    COUNT_ARGS(OUTPUT_PINS)      // 自动计算输出引脚数量
#define INPUT_PIN_NUM     COUNT_ARGS(INPUT_PINS)       // 自动计算输入引脚数量
#define OUTPUT_PINS_INIT  {OUTPUT_PINS}                // 数组初始化用
#define INPUT_PINS_INIT   {INPUT_PINS}                 // 数组初始化用

// 实际按键配置数量
extern const uint8_t KEYS_FUNCTION_NUM;

#endif

