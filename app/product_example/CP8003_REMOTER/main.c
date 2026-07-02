/*************************************************************************************************
 * @file       main.c
 * @author     BLE Group
 * @brief
 * @version    1.0.8
 * @date       2025.11.04
 *
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 *
 ************************************************************************************************/
#include "api_rf_2g4.h"
#include "driver_timer.h"
#include "hal_clock.h"
#include "include.h"
#include "log_dbg.h"
#include "string.h"

// 遥控器功能头文件
#include "app_remoter.h"
#include "app_viot_handler.h"
#include "key_process.h"
#include "rmt_key_config.h"

// 睡眠唤醒相关头文件
#include "api_sleep_wakeup.h"
#include "driver_gpio.h"

/* 全局变量 */
uint64_t watch_dog_T = 0;
uint64_t key_scan_timer = 0;
uint64_t sleep_check_timer = 0;

uint8_t adv_rx_data_buf[MAX_RF_LENGTH];

extern volatile str_key_info key_info;
extern volatile uint16_t no_keypress_50ms_cnt;
extern const str_key_fun keys_func_table[];
extern const uint8_t KEYS_FUNCTION_NUM;
extern void app_remoter_key_scan(void);    // 按键扫描函数
extern volatile uint8_t key_activity_flag; // 按键活动标志
extern ENUM_GPIO_PIN output_pin[OUTPUT_PIN_NUM];
extern ENUM_GPIO_PIN input_pin[INPUT_PIN_NUM];

/**
 * @brief 睡眠唤醒回调函数
 * @param wkup_type 唤醒类型：0 = timeout超时唤醒, 1 = GPIO按键唤醒
 * @return 0 = 继续睡眠, 1 = 完全唤醒
 * @note 该函数在RAM中执行，用于处理唤醒后的逻辑判断
 *       不要在此函数中调用 enter_sleep_mode()
 */
__RAM_CODE_SECTION uint8_t sleep_wakeup_handler(uint32_t wkup_type)
{
    if (wkup_type == 1) {
        // GPIO按键唤醒 - 完全唤醒系统
        return 1;
    }

    return 1;
}

/**
 * 函数的作用说明：
 *    遥控器主入口函数，负责系统初始化和主循环
 *    主要功能：按键扫描、按键处理、指示灯控制、涂鸦广播发送
 */
int main(void)
{
#if (BOOT_OTP)
    // OTP 模式下必须配置
    gpio_set_func(10, 0x20);
#endif

#if (LOG_ENABLE)
    log_dbg_init();
    log_printf("初始化完成");
#endif

    // ========== 初始化2.4G射频模块 ==========
    rf_2g4_init();
    rf_2g4_set_tx_power(5); // 设置发射功率 0dBm

    // ========== 初始化遥控器GPIO和按键 ==========
    app_remoter_gpio_init();
    key_process_init();
    // VIOT协议初始化已在key_process_init()中调用ble_packet_init()完成
    log_printf("Remoter initialized (VIOT mode)\n");

    // ========== 初始化BLE广播发送参数 ==========
    ble_adv_timer_init(); // 初始化广播发送参数（主循环模式）

    /* ==================== 主循环 ==================== */
    while (1) {

        hal_clock_time_run();

        /* ========== 按键扫描（5ms周期）========== */
        if (hal_clock_time_exceed(key_scan_timer, 5 * 1000)) {
            key_scan_timer = hal_clock_get_system_tick();
            app_remoter_key_scan(); // 主循环中扫描按键
        }

        /* ========== BLE数据包发送处理 ========== */
        ble_adv_process(); // 在主循环中处理发包

        // ========== 看门狗喂狗（100ms） ==========
        if (hal_clock_time_exceed(watch_dog_T, 100 * 1000)) {
            watch_dog_T = hal_clock_get_system_tick();
            WDT_FEED();
        }

        /* ========== 按键处理 ========== */
        // 按键扫描在主循环中完成，此处响应按键事件
        if (key_info.handle_flag) {

            key_process(key_info.curr_key, key_info.pressed_time, key_info.handle_flag);
            key_info.handle_flag = 0x0;
        }

        /* ========== 休眠检查（50ms周期）========== */
        if (hal_clock_time_exceed(sleep_check_timer, 50 * 1000)) {
            sleep_check_timer = hal_clock_get_system_tick();

            // 检查按键活动标志
            if (key_activity_flag == 0) {
                // 无按键活动，计数增加
                no_keypress_50ms_cnt++;
                if (no_keypress_50ms_cnt >= 100) { // 5秒无操作
                    log_printf("Ready to sleep (no action for 5s)\n");
                    no_keypress_50ms_cnt = 0;

                    // ========== 2. 设置输出口为低（矩阵键唤醒必需）==========
                    uint32_t output_bits = 0;
                    for (uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
                        output_bits |= (1 << output_pin[i]);
                    }
                    gpio_write(output_bits, GPIO_LOW);

                    // ========== 3. 配置唤醒GPIO ==========
                    uint32_t wakeup_gpio_bits = 0;
                    for (uint8_t i = 0; i < INPUT_PIN_NUM; i++) {
                        wakeup_gpio_bits |= (1 << input_pin[i]);
                    }
                    config_wakeup_gpio(wakeup_gpio_bits, 1);

                    log_printf("Enter sleep mode\n");

                    // ========== 4. 进入睡眠 ==========
                    enter_sleep_mode();

                    // ========== 5. 唤醒后初始化 ==========
                    log_printf("\n=== Wakeup from sleep ===\n");
                    log_printf("Wakeup IO: 0x%x\n", AON_CTRL->WAKEUP_RECORD);

                    // 5.1 恢复输出口
                    gpio_write(output_bits, GPIO_HIGH);

                    // 5.2 重新初始化BLE广播发送
                    ble_adv_timer_init();

                    // 5.3 重置时钟计数器
                    watch_dog_T = hal_clock_get_system_tick();
                    key_scan_timer = hal_clock_get_system_tick();
                    sleep_check_timer = hal_clock_get_system_tick();

                    key_activity_flag = 0;
                    log_printf("=== System resumed ===\n\n");
                }
            } else {
                // 有按键活动，重置计数和标志
                no_keypress_50ms_cnt = 0;
                key_activity_flag = 0;
            }
        }

        /* ========== 指示灯闪烁处理 ========== */
        app_remoter_led_blink();
    }

    return 0;
}
