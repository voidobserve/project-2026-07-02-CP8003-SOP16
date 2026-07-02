/****************************************************************************
 * @FILENAME:  key_process.c
 * @FUNCTION:  按键处理实现（使用VIOT协议）
 * @AUTHOR:    
 * @DATE:      2025.11.06
 ****************************************************************************/

#include "key_process.h"
#include "rmt_key_config.h"
#include "log_dbg.h"
#include "app_viot_handler.h"
#include "string.h"  // for memset

/* 按键信息全局变量 */
extern volatile str_key_info key_info;
extern const uint8_t KEYS_FUNCTION_NUM;

/* 按键处理初始化 */
void key_process_init(void)
{
    memset((void*)&key_info, 0x0, sizeof(str_key_info));
    ble_packet_init();
    log_printf("Key process init\n");
    log_printf("KEYS_FUNCTION_NUM = %d (auto-calculated)\n", KEYS_FUNCTION_NUM);
}

/* 按键处理主函数 */
void key_process(uint32_t key_value, uint32_t press_time, uint8_t handle_flag)
{
    str_key_fun* p_key_fun = NULL;
    
    // 查找匹配的按键配置
    for(uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i)
    {
        if(key_value == keys_func_table[i].key_value)
        {
            p_key_fun = (str_key_fun*)&keys_func_table[i];
            break;
        }
    }
    
    if(p_key_fun == NULL)
    {
        log_printf("No matching key found for 0x%08X\n", key_value);
        return;
    }
    
    // 按键处理逻辑：短按释放、长按、长按释放
    if(handle_flag == 0x02)
    {
        // 短按释放
        p_key_fun->short_press_handler((str_fun_para*)&p_key_fun->short_press_para);
        key_info.pressed_time = 0x0;
    }
    else if(handle_flag == 0x03)
    {
        // 长按释放
        p_key_fun->long_release_handler((str_fun_para*)&p_key_fun->long_release_para);
        key_info.pressed_time = 0x0;
    }
    else if(handle_flag == 0x01 && press_time >= DEFAULT_LONG_THRESHOLD)
    {
        // 长按触发（按键按下期间，达到长按阈值时触发，只触发一次）
        if(press_time == DEFAULT_LONG_THRESHOLD)
        {
            p_key_fun->long_press_handler((str_fun_para*)&p_key_fun->long_press_para);
        }
        else
        {
            return;  // 长按已触发，不重复发送
        }
    }
    else
    {
        // 按键按下但未达到任何触发条件
        return;
    }
    
    // 发送BLE广播
    ble_packet_send();
}

