/****************************************************************************
 * @FILENAME:  key_process.h
 * @FUNCTION:  按键处理框架（使用VIOT协议）
 * @AUTHOR:    
 * @DATE:      2025.11.06
 ****************************************************************************/

#ifndef _KEY_PROCESS__H_
#define _KEY_PROCESS__H_

#include <stdint.h>
#include "app_viot_handler.h"  // 使用VIOT的参数结构
#include "rmt_key_config.h"    // 包含按键配置宏定义

/* 按键信息结构 */
typedef struct
{
    uint32_t curr_key;      // 当前按键值
    uint32_t last_key;      // 上次按键值
    uint8_t  para[3];       // 参数
    uint8_t  handle_flag;   // 处理标志: 0x01=按下 0x02=短按释放 0x03=长按释放
    uint32_t pressed_time;  // 按下时长(ms)
} str_key_info;

/* 按键功能配置结构 */
typedef struct
{
    uint32_t key_value;                             // 按键值

    void (*short_press_handler)(str_fun_para*);     // 短按释放回调（按键释放时触发）
    str_fun_para short_press_para;                  // 短按释放参数
    
    void (*long_press_handler)(str_fun_para*);      // 长按触发回调
    str_fun_para long_press_para;                   // 长按参数
    
    void (*long_release_handler)(str_fun_para*);    // 长按释放回调
    str_fun_para long_release_para;                 // 长按释放参数
} str_key_fun;

/* 外部变量声明 */
extern const str_key_fun keys_func_table[];

/* 函数声明 */
void key_process_init(void);
void key_process(uint32_t key_value, uint32_t press_time, uint8_t handle_flag);

#endif

