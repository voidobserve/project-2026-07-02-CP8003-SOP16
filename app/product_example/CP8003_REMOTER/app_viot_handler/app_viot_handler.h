/*************************************************************************************************
 * @file       app_viot_handler.h
 * @brief      VIOT协议按键回调函数
 * @version    1.0.0
 * @date       2025.11.06
 * @note      
 ************************************************************************************************/
#ifndef _APP_VIOT_HANDLER_H_
#define _APP_VIOT_HANDLER_H_

#include <stdint.h>
#include <stdbool.h>
#include "ble_viot.h"


#ifndef ADV_CHANNEL_BIT_37
#define ADV_CHANNEL_BIT_37  (0x01)
#endif

/* MAC地址定义 */
extern uint8_t* MAC_ADDR;

/* 函数参数结构 */
typedef struct
{
    uint16_t para_a;
    uint16_t para_b;
    uint16_t para_c;
    uint16_t para_d;
} str_fun_para;


/* 状态存储结构*/
typedef struct
{
    uint8_t sys_reset_cause;
    uint8_t current_group_index;
    uint16_t tx_count;
    uint16_t rand_seed;
    uint16_t rfu;
} str_retention_memory;

/* BLE数据包发送配置）*/
#define SEND_BEACON_MAX_TIMES   (70)    // 兼容旧AK803方案：每次按键发送70次
#define SEND_BEACON_INTERVAL    (1)     // 兼容旧AK803方案：每次发送间隔1ms
#define SEND_BEACON_CHANNEL     ADV_CHANNEL_BIT_37
#define GROUP_INDEX_MAX         (4)     // 最大组索引

/* MAC地址字节序反转函数 */
void reverse_mac_address(const uint8_t* src, uint8_t* dst);


/* 全局变量声明 */
extern volatile uint8_t send_packet_request;

/* BLE广播发送函数声明 */
void ble_adv_send(uint8_t type, const uint8_t* data, uint8_t data_len, uint16_t tx_num, uint16_t interval_ms, uint8_t tx_chmap);
void ble_adv_process(void);             // 主循环发包处理函数
void ble_adv_stop(uint8_t adv_type);    // 停止广播发送
void ble_adv_timer_init(void);          // 初始化广播发送

/* 基础函数 */
void ble_packet_init(void);
uint8_t ble_packet_send(void);
void null_handler(str_fun_para* para);

/* 按键处理回调函数 */
void onoff_reverse_handler(str_fun_para* para);              // 总开关
void lamp_onoff_reverse_handler(str_fun_para* para);         // 开关灯
void lamp_bright_inc_dec_handler(str_fun_para* para);        // 亮度+/-
void lamp_bright_long_inc_dec_handler(str_fun_para* para);   // 亮度长按
void lamp_temperatue_inc_dec_handler(str_fun_para* para);    // 色温+/-
void lamp_temperatue_long_inc_dec_handler(str_fun_para* para); // 色温长按
void lamp_bright_temperatue_set(str_fun_para* para);         // 色温亮度设置
void lamp_temperatue_switch_handler(str_fun_para* para);     // 色温切换
void rgb_set_handler(str_fun_para* para);                    // RGB设置
void rgb_mode_set_handler(str_fun_para* para);               // RGB模式设置
void binding_handler(str_fun_para* para);                    // 绑定
void unbinding_handler(str_fun_para* para);                  // 解绑
void direct_key_value(str_fun_para* para);                   // 直接发送键值
void lamp_time_handler(str_fun_para* para);                  // 倒计时
#endif
