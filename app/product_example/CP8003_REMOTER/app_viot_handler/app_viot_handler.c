/*************************************************************************************************
 * @file       app_viot_handler.c
 * @brief      VIOT协议按键回调函数实现
 * @version    1.0.0
 * @date       2025.11.06
 * @note       
 ************************************************************************************************/
#include "app_viot_handler.h"
#include "ble_viot.h"
#include "driver_gpio.h"
#include "driver_timer.h"  // 添加定时器驱动头文件
#include "api_rf_2g4.h"  
#include "hal_clock.h"
#include "log_dbg.h"
#include "string.h"
#include "rmt_key_config.h"  

/* ==================== 全局变量==================== */
str_retention_memory ret_mem_data = {0};
uint32_t GROUP_ADDR = 0x0;
str_ble_viot_para ble_viot_para = {0};  // VIOT参数
uint8_t DEFAULT_BLE_MAC[6] = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66};

/* MAC地址定义*/
#if(BOOT_OTP)
#define MAC_ADDR_BASE 0x1F803E80  // MAC地址存储地址
#else
#define MAC_ADDR_BASE 0x1003f000
#endif
uint8_t* MAC_ADDR = (uint8_t*)(MAC_ADDR_BASE);


/* 发包全局变量 */
volatile uint8_t send_packet_request = 0;  // 发包请求标志
uint8_t packet_buffer[39];  // 数据包缓冲区
uint8_t packet_len = 0;     // 数据包长度
uint16_t packet_tx_count = 0;  // 剩余发送次数
uint64_t last_send_time = 0;   // 上次发送时间
uint16_t send_interval_us = 0; // 发送间隔(微秒)

/* ==================== 辅助函数 ==================== */
inline void SET_GROUP_INDEX(uint8_t new_group_index)
{
    ret_mem_data.current_group_index = new_group_index;
}

inline uint8_t GET_GROUP_INDEX(void)
{
    return ret_mem_data.current_group_index;
}

/* ==================== 基础回调函数 ==================== */
void null_handler(str_fun_para* para)
{
    // 空函数
    (void)para;
}

/* ==================== 按键处理回调函数==================== */

/***************************************************************************
 * 函数名称：onoff_reverse_handler
 * 说明：总开关函数
 * 输入：0关，1开，2取反，组号0为全控
 ***************************************************************************/
void onoff_reverse_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x02;
    ble_viot_para.para[0] = para->para_a;
    SET_GROUP_INDEX(para->para_b);
}

/***************************************************************************
 * 函数名称：lamp_onoff_reverse_handler
 * 说明：开关灯函数
 * 输入：0关，1开，2取反，组号0为全控
 ***************************************************************************/
void lamp_onoff_reverse_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x20;
    ble_viot_para.para[0] = para->para_a;
    SET_GROUP_INDEX(para->para_b);
}

/***************************************************************************
 * 函数名称：lamp_bright_inc_dec_handler
 * 说明：亮度+/-
 * 输入：para_a: 0定，1+，2-，3循环; para_b: 改变的步长
 ***************************************************************************/
void lamp_bright_inc_dec_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x21;
    ble_viot_para.para[0] = para->para_a;
    ble_viot_para.para[1] = para->para_b;
}

/***************************************************************************
 * 函数名称：lamp_bright_long_inc_dec_handler
 * 说明：亮度+/-(长按无极)
 * 输入：para_a: 0-增加，1-减少，2-停止，3-循环
 ***************************************************************************/
void lamp_bright_long_inc_dec_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x22;
    ble_viot_para.para[0] = para->para_a;
}

/***************************************************************************
 * 函数名称：lamp_temperatue_inc_dec_handler
 * 说明：色温+/-设置函数
 * 输入：para_a: 0定，1+，2-，3循环; para_b: 改变的步长
 ***************************************************************************/
void lamp_temperatue_inc_dec_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x23;
    ble_viot_para.para[0] = para->para_a;
    ble_viot_para.para[1] = para->para_b;
}

/***************************************************************************
 * 函数名称：lamp_temperatue_long_inc_dec_handler
 * 说明：色温+/-（长按无极）
 * 输入：para_a: 0-增加，1-减少，2-停止，3-循环
 ***************************************************************************/
void lamp_temperatue_long_inc_dec_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x24;
    ble_viot_para.para[0] = para->para_a;
}

/***************************************************************************
 * 函数名称：lamp_bright_temperatue_set
 * 说明：色温亮度设置函数
 * 输入：para_a: 亮度0~1000; para_b: 色温0~1000
 ***************************************************************************/
void lamp_bright_temperatue_set(str_fun_para* para)
{
    ble_viot_para.cmd = 0x25;
    ble_viot_para.para[0] = para->para_a;
    ble_viot_para.para[1] = para->para_b;
}

/***************************************************************************
 * 函数名称：lamp_temperatue_switch_handler
 * 说明：色温黄白光切换
 ***************************************************************************/
void lamp_temperatue_switch_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x26;
    ble_viot_para.para[0] = para->para_a;
}

/***************************************************************************
 * 函数名称：rgb_set_handler
 * 说明：RGB颜色设置
 * 输入：para_a: R, para_b: G, para_c: B
 ***************************************************************************/
void rgb_set_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x30;
    ble_viot_para.para[0] = para->para_a;
    ble_viot_para.para[1] = para->para_b;
    ble_viot_para.para[2] = para->para_c;
}

/***************************************************************************
 * 函数名称：rgb_mode_set_handler
 * 说明：RGB模式设置
 ***************************************************************************/
void rgb_mode_set_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x32;
    ble_viot_para.para[0] = para->para_a;
    ble_viot_para.para[1] = para->para_b;
    ble_viot_para.para[2] = para->para_c;
    ble_viot_para.rfu[0] = para->para_d;
}

/***************************************************************************
 * 函数名称：lamp_time_handler
 * 说明：倒计时
 * 输入：无
 * 输出：
 * 备注：
 * ************************************************************************/
void lamp_time_handler(str_fun_para* para)
{
	ble_viot_para.cmd = 0x07;
	ble_viot_para.para[0] = para->para_a;//
	ble_viot_para.para[1] = para->para_b;//
}

/***************************************************************************
 * 函数名称：binding_handler
 * 说明：绑定函数
 * 输入：需要绑定的组号
 ***************************************************************************/
void binding_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x01;
    ble_viot_para.para[0] = 0x01;
    SET_GROUP_INDEX(para->para_a);
}

/***************************************************************************
 * 函数名称：unbinding_handler
 * 说明：解绑函数
 * 输入：需要绑定的组号
 ***************************************************************************/
void unbinding_handler(str_fun_para* para)
{
    ble_viot_para.cmd = 0x01;
    ble_viot_para.para[0] = 0x00;
    SET_GROUP_INDEX(para->para_a);
}

/***************************************************************************
 * 函数名称：direct_key_value
 * 说明：直接发送按键键值
 * 输入：0x00-0xff
 ***************************************************************************/
void direct_key_value(str_fun_para* para)
{
    ble_viot_para.cmd = 0xFF;
    ble_viot_para.para[0] = para->para_a;
}

/* ==================== MAC地址字节序反转函数 ==================== */
/**
 * @brief 反转MAC地址字节序
 * @param src 源MAC地址（6字节）
 * @param dst 目标MAC地址（6字节），反转后的结果
 * @note  如果Flash中存储 [0xCC, 0xBB, 0xAA, 0x99, 0x88, 0x77]
 *        反转后输出为 [0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC]
 */
void reverse_mac_address(const uint8_t* src, uint8_t* dst)
{
    for(uint8_t i = 0; i < 6; i++) {
        dst[i] = src[5 - i];  // 反转字节序
    }
}

/* ==================== 主循环发包实现 ==================== */
void ble_adv_send(uint8_t type, const uint8_t* data, uint8_t data_len, uint16_t tx_num, uint16_t interval_ms, uint8_t tx_chmap)
{
    // 参数检查
    if(!tx_num) {
        return;
    }
    
    // 构建BLE数据包
    packet_len = 8 + data_len;  // 2字节头部 + 6字节MAC + 数据长度
    
    // [0-1]: BLE Header
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
    packet_buffer[1] = 6 + data_len;  // Length
    
    // [2-7]: 旧AK803方案使用固定随机地址
    memcpy(&packet_buffer[2], DEFAULT_BLE_MAC, 6);
    
    // [8-38]: VIOT Payload
    memcpy(&packet_buffer[8], data, data_len);
    
    log_printf("广播MAC地址: ");
    for(uint8_t i = 0; i < 6; i++) {
        log_printf("%02X", DEFAULT_BLE_MAC[i]);
        if(i < 5) log_printf(":");
    }
    log_printf("\n");
    
    // 设置发送参数
    packet_tx_count = tx_num;
    send_interval_us = interval_ms * 1000;  // 转换为微秒
    last_send_time = 0;
    
    // 启动发送请求
    send_packet_request = 1;
}

/* ==================== 主循环发包处理函数 ==================== */
void ble_adv_process(void)
{
    if(send_packet_request == 0 || packet_tx_count == 0) {
        return;  // 没有发送请求或已发送完毕
    }
    
    // 获取当前时间
    uint64_t current_time = hal_clock_get_system_tick();
    
    // 检查是否到达发送时刻
    if(last_send_time == 0 || hal_clock_time_exceed(last_send_time, send_interval_us)) {
        // 发送RF数据包
        rf_2g4_tx_data(packet_buffer, packet_len, RF_CH37);
        
        // 更新发送时间和计数
        last_send_time = current_time;
        packet_tx_count--;
        
        // 检查是否发送完毕
        if(packet_tx_count == 0) {
            send_packet_request = 0;
            log_printf("[ADV] 数据包发送完成\n");
        }
    }
}

void ble_adv_stop(uint8_t adv_type)
{
    // 停止广播发送
    packet_tx_count = 0;
    send_packet_request = 0;
    log_printf("[ADV] 广播已停止\n");
}

void ble_adv_timer_init(void)
{
    // 初始化发包参数
    send_packet_request = 0;
    packet_tx_count = 0;
    last_send_time = 0;
    memset(packet_buffer, 0, sizeof(packet_buffer));
    
    log_printf("[ADV] 广播发送初始化完成（主循环模式）\n");
}

/* ==================== 初始化函数==================== */
void ble_packet_init(void)
{
    // 兼容旧AK803 payload字段：广播中使用GROUP_ADDR低16位作为滚码。
    // CP8003上旧地址0x1FE0未确认可读，先沿用SDK已有MAC存储区作为稳定来源。
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
    
    // 初始化 VIOT 参数结构
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
    
    log_printf("[BLE] Packet initialized, GROUP_ADDR=0x%08X\n", GROUP_ADDR);
}

/* ==================== BLE数据包发送函数==================== */
uint8_t ble_packet_send(void)
{
    uint8_t ret = 0xFF;
    uint8_t encoded_data[31];  // VIOT编码后的31字节payload
    uint8_t encoded_data_len;
    uint8_t index = 0x0;       // 广播索引
    uint8_t* group_index = &ret_mem_data.current_group_index;
    uint16_t rand_seed = ret_mem_data.rand_seed;
    uint16_t tx_count = ret_mem_data.tx_count++;
    
    // 验证group_index，如果越界则重置为0
    *group_index = (*group_index > GROUP_INDEX_MAX) ? 0x00 : *group_index;
    
    // 填充VIOT参数
    ble_viot_para.relay = 0x54;           // 固定值
    ble_viot_para.type = 0x00;            // 类型
    ble_viot_para.version = 0x00;         // 版本
    ble_viot_para.count = tx_count;       // 递增计数
    ble_viot_para.addr = GROUP_ADDR;      // 设备地址
    ble_viot_para.group_index = *group_index;  // 组索引
    // cmd 和 para 由回调函数设置
    
    // 使用旧AK803简化按键值编码
    ret = ble_viot_encoder(&ble_viot_para, rand_seed, encoded_data, &encoded_data_len);
    
    // 打印编码后的数据
    log_printf("\n=== 旧格式编码后数据 ===\n");
    log_printf("编码结果: %s (ret=0x%02X)\n", (ret == 0x00) ? "成功" : "失败", ret);
    log_printf("CMD: 0x%02X, Para: [0x%04X, 0x%04X, 0x%04X]\n", 
               ble_viot_para.cmd,
               ble_viot_para.para[0],
               ble_viot_para.para[1],
               ble_viot_para.para[2]);
    log_printf("编码数据长度: %d字节\n", encoded_data_len);
    log_printf("编码数据: ");
    for(uint8_t i = 0; i < encoded_data_len; i++) {
        log_printf("%02X ", encoded_data[i]);
        if((i + 1) % 16 == 0) log_printf("\n           ");  // 每16字节换行
    }
    log_printf("\n");
    
    // 发送编码后的数据包
    ble_adv_send(index, encoded_data, encoded_data_len, SEND_BEACON_MAX_TIMES, SEND_BEACON_INTERVAL, SEND_BEACON_CHANNEL);
    
    // 清空参数
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
    
    return ret;
}
