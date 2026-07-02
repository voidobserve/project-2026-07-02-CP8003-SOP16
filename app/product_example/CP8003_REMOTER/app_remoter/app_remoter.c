/*************************************************************************************************
 * @file       app_remoter_simple.c
 * @brief      遥控器应用层实现
 * @version    2.0.0
 * @date       2025.11.06
 ************************************************************************************************/
#include "include.h"
#include "driver_gpio.h"
#include "hal_clock.h"
#include "rmt_key_config.h"
#include "key_process.h"
#include "log_dbg.h"
#include "app_remoter.h"
#include "string.h"

/* ==================== 全局变量 ==================== */
ENUM_GPIO_PIN output_pin[OUTPUT_PIN_NUM] = OUTPUT_PINS_INIT;
ENUM_GPIO_PIN input_pin[INPUT_PIN_NUM]   = INPUT_PINS_INIT;

volatile str_key_info key_info = {0};
volatile uint16_t no_keypress_50ms_cnt = 0;
volatile uint8_t led_blink_flag = 0;
volatile uint8_t led_blink_times = 0;
volatile uint8_t key_activity_flag = 0;  // 按键活动标志
uint64_t t_led_blink = 0;

/* ==================== GPIO初始化 ==================== */
void app_remoter_gpio_init(void)
{
    uint32_t input_bits = 0;
    uint32_t output_bits = 0;
    
    // 计算输入口位掩码
    for(uint8_t i = 0; i < INPUT_PIN_NUM; i++) {
        input_bits |= (1 << input_pin[i]);
    }
    
    // 计算输出口位掩码
    for(uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
        output_bits |= (1 << output_pin[i]);
    }
    
    // 配置输入口：上拉输入
    gpio_set_input(input_bits, GPIO_MODE_IN_PULL_UP);
    
    // 配置输出口：输出模式，初始高电平
    gpio_set_output(output_bits, GPIO_HIGH);
    
    // 配置指示灯：输出模式，初始关闭
    gpio_set_output((1 << SINGLE_LED_GPIO), GPIO_LOW);
    
    log_printf("Remoter GPIO initialized\n");
}

/* ==================== 按键扫描（在TIMER5中断中调用）==================== */
void app_remoter_key_scan(void)
{
    uint32_t scaned_key = 0x0;
    uint32_t gpio_state = 0;
    
    // 矩阵扫描
    for(uint8_t i = 0; i < OUTPUT_PIN_NUM; i++)
    {
        // 输出口依次置低
        gpio_write((1 << output_pin[i]), GPIO_LOW);
        
        // 小延时，确保电平稳定
        for(volatile int d = 0; d < 20; d++);
        
        // 读取所有GPIO状态
        gpio_state = gpio_read();
        
        // 检查所有输入口
        for(uint8_t j = 0; j < INPUT_PIN_NUM; j++)
        {
            // 检测对应输入口是否为低电平（按键按下）
            if((gpio_state & (1 << input_pin[j])) == 0)
            {
                scaned_key |= ((1 << output_pin[i]) | (1 << input_pin[j]));
            }
        }
        
        // 输出口恢复置高
        gpio_write((1 << output_pin[i]), GPIO_HIGH);
    }
    
    // GND扫描：所有输出口置高，检测输入口是否接GND
    // 计算所有输出口的位掩码
    uint32_t all_output_bits = 0;
    for(uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
        all_output_bits |= (1 << output_pin[i]);
    }
    
    // 设置所有输出口为高电平
    gpio_write(all_output_bits, GPIO_HIGH);
    
    // 小延时，确保电平稳定
    for(volatile int d = 0; d < 20; d++);
    
    // 读取GPIO状态
    gpio_state = gpio_read();
    
    // 检查所有输入口，如果为低则表示连接到GND
    for(uint8_t j = 0; j < INPUT_PIN_NUM; j++)
    {
        if((gpio_state & (1 << input_pin[j])) == 0)
        {
            // 输入口为低，表示GND按键按下
            // 注意：GND按键应该单独存在，不与矩阵扫描结果混合
            scaned_key = (GNDB | (1 << input_pin[j]));
            break; // 找到一个GND按键就退出，避免多个GND按键同时触发
        }
    }
    
    key_info.curr_key = scaned_key;
    
    // 设置按键活动标志
    if(scaned_key != 0) {
        key_activity_flag = 1;  // 检测到按键按下
    }
    
    // 按键状态处理
    if(key_info.curr_key && (key_info.curr_key == key_info.last_key))
    {
        key_info.pressed_time += 5;  // 每5ms累加
        key_info.handle_flag = 0x01;
        
        no_keypress_50ms_cnt = 0;
        
        // 按键按下时点亮指示灯
        if(led_blink_flag == 0) {
            gpio_write((1 << SINGLE_LED_GPIO), GPIO_HIGH);
        }
    }
    else
    {
        // 按键释放处理
        if(scaned_key == 0 && key_info.last_key != 0 && key_info.pressed_time >= DEFAULT_SHORT_THRESHOLD)
        {
            if(key_info.pressed_time < DEFAULT_LONG_THRESHOLD) {
                key_info.handle_flag = 0x02;  // 短按释放
            } else {
                key_info.handle_flag = 0x03;  // 长按释放
            }
            
            no_keypress_50ms_cnt = 0;
            key_info.curr_key = key_info.last_key;
            key_info.pressed_time = 0x0;
        }
        else
        {
            // 没有检测到有效的按键释放，清零pressed_time
            key_info.pressed_time = 0x0;
        }
        
        // 按键释放后熄灭指示灯
        if(led_blink_flag == 0) {
            gpio_write((1 << SINGLE_LED_GPIO), GPIO_LOW);
        }
    }
    
    key_info.last_key = scaned_key;
}

/* ==================== 指示灯闪烁处理 ==================== */
void app_remoter_led_blink(void)
{
    if(led_blink_flag) {
        if(hal_clock_time_exceed(t_led_blink, 150*1000)) {  // 150ms
            t_led_blink = hal_clock_get_system_tick();
            
            static uint8_t led_sta = 0;
            if(!led_sta) {
                led_sta = 1;
                gpio_write((1 << SINGLE_LED_GPIO), GPIO_HIGH);
            } else {
                led_sta = 0;
                led_blink_times--;
                gpio_write((1 << SINGLE_LED_GPIO), GPIO_LOW);
            }
            
            if(led_blink_times == 0) {
                led_blink_flag = 0;
            }
        }
    }
}

