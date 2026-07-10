/****************************************************************************
 * @FILENAME:  rmt_key_config.c
 * @FUNCTION:  按键功能配置表（使用VIOT协议）
 * @AUTHOR:
 * @DATE:      2025.11.06
 ****************************************************************************/
#include "rmt_key_config.h"
#include "app_viot_handler.h"
#include "key_process.h"

/* 30键遥控器按键配置表 */
#if (PRODUCT_SELECTION == RMT_30KEY)
const str_key_fun keys_func_table[] = {
    //{键值, 	短按释放回调, 						短按释放参数, 			长按回调,
    // 长按参数, 	 长按释放回调, 						长按释放参数}
    // 开关按键：短按-开，长按-绑定组1
    {(PIN21 | PIN0),
     onoff_reverse_handler,
     {0x01, 0x00},
     binding_handler,
     {0x01},
     null_handler,
     {0x00}},

    // 关闭按键：短按-关，长按-解绑组1
    {(PIN21 | PIN1),
     onoff_reverse_handler,
     {0x00, 0x00},
     unbinding_handler,
     {0x01},
     null_handler,
     {0x00}},

    // 亮度+：短按增加10，长按连续增加
    {(PIN21 | PIN6),
     lamp_bright_inc_dec_handler,
     {0x01, 10},
     lamp_bright_long_inc_dec_handler,
     {0x00},
     lamp_bright_long_inc_dec_handler,
     {0x02}},

    // 亮度-：短按减少10，长按连续减少
    {(PIN21 | PIN7),
     lamp_bright_inc_dec_handler,
     {0x02, 10},
     lamp_bright_long_inc_dec_handler,
     {0x01},
     lamp_bright_long_inc_dec_handler,
     {0x02}},

    // (PIN21|PIN8)
    {(PIN21 | PIN8), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // 色温+：短按增加10，长按连续增加
    {(PIN20 | PIN0),
     lamp_temperatue_inc_dec_handler,
     {0x01, 10},
     lamp_temperatue_long_inc_dec_handler,
     {0x00},
     lamp_temperatue_long_inc_dec_handler,
     {0x02}},

    // 色温-：短按减少10，长按连续减少
    {(PIN20 | PIN1),
     lamp_temperatue_inc_dec_handler,
     {0x02, 10},
     lamp_temperatue_long_inc_dec_handler,
     {0x01},
     lamp_temperatue_long_inc_dec_handler,
     {0x02}},

    // 色温切换（黄白光切换）
    {(PIN20 | PIN6),
     lamp_temperatue_switch_handler,
     {0x00},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // 亮度色温设置：50%亮度，中性色温
    {(PIN20 | PIN7),
     lamp_bright_temperatue_set,
     {500, 500},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // KEY_S10
    {(PIN20 | PIN8), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // RGB红色（H=0, S=1000, V=1000）
    {(PIN19 | PIN0), rgb_set_handler, {0, 1000, 1000}, null_handler, {0x00}, null_handler, {0x00}},

    // RGB绿色（H=120, S=1000, V=1000）
    {(PIN19 | PIN1),
     rgb_set_handler,
     {120, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // RGB蓝色（H=240, S=1000, V=1000）
    {(PIN19 | PIN6),
     rgb_set_handler,
     {240, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // RGB黄色（H=60, S=1000, V=1000）
    {(PIN19 | PIN7), rgb_set_handler, {60, 1000, 1000}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S15
    {(PIN19 | PIN8), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // RGB青色（H=180, S=1000, V=1000）
    {(PIN18 | PIN0),
     rgb_set_handler,
     {180, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // RGB紫色（H=300, S=1000, V=1000）
    {(PIN18 | PIN1),
     rgb_set_handler,
     {300, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // 倒计时：分钟（单位）
    {(PIN18 | PIN6), lamp_time_handler, {60}, lamp_time_handler, {0x00}, null_handler, {0x00}},

    // RGB模式设置
    {(PIN18 | PIN7), rgb_mode_set_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S20
    {(PIN18 | PIN8), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S21
    {(PIN15 | PIN0), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S22
    {(PIN15 | PIN1), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S23
    {(PIN15 | PIN6), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S24
    {(PIN15 | PIN7), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // KEY_S25
    {(PIN15 | PIN8), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // GND扫描按键
    // 全亮（100%亮度，中性色温）
    {(GNDB | PIN21),
     lamp_bright_temperatue_set,
     {1000, 500},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // 暖光全亮（100%亮度，暖光）
    {(GNDB | PIN20),
     lamp_bright_temperatue_set,
     {1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // 白光全亮（100%亮度，冷光）
    {(GNDB | PIN19),
     lamp_bright_temperatue_set,
     {1000, 0},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // 夜灯模式（10%亮度，暖光）
    {(GNDB | PIN18),
     lamp_bright_temperatue_set,
     {100, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // KEY_GND5
    {(GNDB | PIN15), null_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},
};

#elif (PRODUCT_SELECTION == RMT_28KEY) // 28键 (24个矩阵键 + 4个GND键)
const str_key_fun keys_func_table[] = {
    // {键值, 短按释放回调, 短按释放参数, 长按回调, 长按参数, 长按释放回调, 长按释放参数}
    // 旧AK803 28键 public key-value 表：按SOP16物理脚位映射，广播payload只使用 para_a。
    {(PIN_IDX_MASK_4 | PIN_IDX_MASK_14), direct_key_value, {0x11}, direct_key_value, {0x11}},
    {(PIN_IDX_MASK_4 | PIN_IDX_MASK_13), direct_key_value, {0x12}, direct_key_value, {0x12}},
    {(PIN_IDX_MASK_4 | PIN_IDX_MASK_12), direct_key_value, {0x13}, direct_key_value, {0x13}},
    {(PIN_IDX_MASK_4 | PIN_IDX_MASK_11), direct_key_value, {0x14}, direct_key_value, {0x14}},

    {(PIN_IDX_MASK_5 | PIN_IDX_MASK_14), direct_key_value, {0x21}, direct_key_value, {0x21}},
    {(PIN_IDX_MASK_5 | PIN_IDX_MASK_13), direct_key_value, {0x22}, direct_key_value, {0x22}},
    {(PIN_IDX_MASK_5 | PIN_IDX_MASK_12), direct_key_value, {0x23}, direct_key_value, {0x23}},
    {(PIN_IDX_MASK_5 | PIN_IDX_MASK_11), direct_key_value, {0x24}, direct_key_value, {0x24}},

    {(PIN_IDX_MASK_6 | PIN_IDX_MASK_14), direct_key_value, {0x31}, direct_key_value, {0x31}},
    {(PIN_IDX_MASK_6 | PIN_IDX_MASK_13), direct_key_value, {0x32}, direct_key_value, {0x32}},
    {(PIN_IDX_MASK_6 | PIN_IDX_MASK_12), direct_key_value, {0x33}, direct_key_value, {0x33}},
    {(PIN_IDX_MASK_6 | PIN_IDX_MASK_11), direct_key_value, {0x34}, direct_key_value, {0x34}},

    {(PIN_IDX_MASK_7 | PIN_IDX_MASK_14), direct_key_value, {0x41}, direct_key_value, {0x41}},
    {(PIN_IDX_MASK_7 | PIN_IDX_MASK_13), direct_key_value, {0x42}, direct_key_value, {0x42}},
    {(PIN_IDX_MASK_7 | PIN_IDX_MASK_12), direct_key_value, {0x43}, direct_key_value, {0x43}},
    {(PIN_IDX_MASK_7 | PIN_IDX_MASK_11), direct_key_value, {0x44}, direct_key_value, {0x44}},

    {(PIN_IDX_MASK_8 | PIN_IDX_MASK_14), direct_key_value, {0x51}, direct_key_value, {0x51}},
    {(PIN_IDX_MASK_8 | PIN_IDX_MASK_13), direct_key_value, {0x52}, direct_key_value, {0x52}},
    {(PIN_IDX_MASK_8 | PIN_IDX_MASK_12), direct_key_value, {0x53}, direct_key_value, {0x53}},
    {(PIN_IDX_MASK_8 | PIN_IDX_MASK_11), direct_key_value, {0x54}, direct_key_value, {0x54}},

    {(PIN_IDX_MASK_10 | PIN_IDX_MASK_14), direct_key_value, {0x61}, direct_key_value, {0x61}},
    {(PIN_IDX_MASK_10 | PIN_IDX_MASK_13), direct_key_value, {0x62}, direct_key_value, {0x62}},
    {(PIN_IDX_MASK_10 | PIN_IDX_MASK_12), direct_key_value, {0x63}, direct_key_value, {0x63}},
    {(PIN_IDX_MASK_10 | PIN_IDX_MASK_11), direct_key_value, {0x64}, direct_key_value, {0x64}},

    {(GND_MASK | PIN_IDX_MASK_14), direct_key_value, {0x01}, direct_key_value, {0x01}},
    {(GND_MASK | PIN_IDX_MASK_13), direct_key_value, {0x02}, direct_key_value, {0x02}},
    {(GND_MASK | PIN_IDX_MASK_12), direct_key_value, {0x03}, direct_key_value, {0x03}},
    {(GND_MASK | PIN_IDX_MASK_11), direct_key_value, {0x04}, direct_key_value, {0x04}},
};

#elif (PRODUCT_SELECTION == RMT_25KEY)
const str_key_fun keys_func_table[] = {
    //{键值, 短按释放回调, 短按释放参数, 长按回调, 长按参数, 长按释放回调, 长按释放参数}

    // 开关按键：短按-开，长按-绑定组1
    {(PIN21 | PIN0),
     onoff_reverse_handler,
     {0x01, 0x00},
     binding_handler,
     {0x01},
     null_handler,
     {0x00}},
    // 关闭按键：短按-关，长按-解绑组1
    {(PIN21 | PIN1),
     onoff_reverse_handler,
     {0x00, 0x00},
     unbinding_handler,
     {0x01},
     null_handler,
     {0x00}},
    // 亮度+：
    {(PIN21 | PIN6),
     lamp_bright_inc_dec_handler,
     {0x01, 10},
     lamp_bright_long_inc_dec_handler,
     {0x00},
     lamp_bright_long_inc_dec_handler,
     {0x02}},
    // 亮度-：
    {(PIN21 | PIN7),
     lamp_bright_inc_dec_handler,
     {0x02, 10},
     lamp_bright_long_inc_dec_handler,
     {0x01},
     lamp_bright_long_inc_dec_handler,
     {0x02}},

    // 色温+：短按增加10，长按连续增加
    {(PIN21 | PIN8),
     lamp_temperatue_inc_dec_handler,
     {0x01, 10},
     lamp_temperatue_long_inc_dec_handler,
     {0x00},
     lamp_temperatue_long_inc_dec_handler,
     {0x02}},
    // 色温-：短按减少10，长按连续减少
    {(PIN20 | PIN0),
     lamp_temperatue_inc_dec_handler,
     {0x02, 10},
     lamp_temperatue_long_inc_dec_handler,
     {0x01},
     lamp_temperatue_long_inc_dec_handler,
     {0x02}},
    // 色温切换（黄白光切换）
    {(PIN20 | PIN1),
     lamp_temperatue_switch_handler,
     {0x00},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // 亮度色温设置：50%亮度，中性色温
    {(PIN20 | PIN6),
     lamp_bright_temperatue_set,
     {500, 500},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // RGB红色（H=0, S=1000, V=1000）
    {(PIN20 | PIN7), rgb_set_handler, {0, 1000, 1000}, null_handler, {0x00}, null_handler, {0x00}},
    // RGB绿色（H=120, S=1000, V=1000）
    {(PIN20 | PIN8),
     rgb_set_handler,
     {120, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // RGB蓝色（H=240, S=1000, V=1000）
    {(PIN19 | PIN0),
     rgb_set_handler,
     {240, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // RGB黄色（H=60, S=1000, V=1000）
    {(PIN19 | PIN1), rgb_set_handler, {60, 1000, 1000}, null_handler, {0x00}, null_handler, {0x00}},

    // RGB青色（H=180, S=1000, V=1000）
    {(PIN19 | PIN6),
     rgb_set_handler,
     {180, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // RGB紫色（H=300, S=1000, V=1000）
    {(PIN19 | PIN7),
     rgb_set_handler,
     {300, 1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // 倒计时：分钟（单位）
    {(PIN19 | PIN8), lamp_time_handler, {60}, lamp_time_handler, {0x00}, null_handler, {0x00}},
    // RGB模式设置
    {(PIN18 | PIN0), rgb_mode_set_handler, {0x00}, null_handler, {0x00}, null_handler, {0x00}},

    // 白光全亮（100%亮度，冷光）
    {(PIN18 | PIN1),
     lamp_bright_temperatue_set,
     {1000, 0},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // 全亮（100%亮度，中性色温）
    {(PIN18 | PIN6),
     lamp_bright_temperatue_set,
     {1000, 500},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // 暖光全亮（100%亮度，暖光）
    {(PIN18 | PIN7),
     lamp_bright_temperatue_set,
     {1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // 夜灯模式（10%亮度，暖光）
    {(PIN18 | PIN8),
     lamp_bright_temperatue_set,
     {100, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // 总开关取反
    {(GNDB | PIN21),
     onoff_reverse_handler,
     {0x02, 0x00},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    // 预留
    {(GNDB | PIN20), direct_key_value, {0x4C}, direct_key_value, {0x4C}, direct_key_value, {0x4C}},
    {(GNDB | PIN19), direct_key_value, {0x4D}, direct_key_value, {0x4D}, direct_key_value, {0x4D}},
    {(GNDB | PIN18), direct_key_value, {0x4E}, direct_key_value, {0x4E}, direct_key_value, {0x4E}},
    {(GNDB | PIN15), direct_key_value, {0x4F}, direct_key_value, {0x4F}, direct_key_value, {0x4F}},
};
#elif (PRODUCT_SELECTION == RMT_12KEY) // 12键 (7个矩阵键 + 5个GND键)
const str_key_fun keys_func_table[] = {
    //{键值, 短按释放回调, 短按释放参数, 长按回调, 长按参数, 长按释放回调, 长按释放参数}

    // 矩阵按键：基础控制
    {(PIN21 | PIN0),
     onoff_reverse_handler,
     {0x01, 0x00},
     binding_handler,
     {0x01},
     null_handler,
     {0x00}},
    {(PIN21 | PIN1),
     onoff_reverse_handler,
     {0x00, 0x00},
     unbinding_handler,
     {0x01},
     null_handler,
     {0x00}},
    {(PIN21 | PIN6),
     lamp_bright_inc_dec_handler,
     {0x01, 10},
     lamp_bright_long_inc_dec_handler,
     {0x00},
     lamp_bright_long_inc_dec_handler,
     {0x02}},
    {(PIN21 | PIN7),
     lamp_bright_inc_dec_handler,
     {0x02, 10},
     lamp_bright_long_inc_dec_handler,
     {0x01},
     lamp_bright_long_inc_dec_handler,
     {0x02}},
    {(PIN21 | PIN8),
     lamp_temperatue_inc_dec_handler,
     {0x01, 10},
     lamp_temperatue_long_inc_dec_handler,
     {0x00},
     lamp_temperatue_long_inc_dec_handler,
     {0x02}},
    {(PIN20 | PIN0),
     lamp_temperatue_inc_dec_handler,
     {0x02, 10},
     lamp_temperatue_long_inc_dec_handler,
     {0x01},
     lamp_temperatue_long_inc_dec_handler,
     {0x02}},
    {(PIN20 | PIN1),
     lamp_temperatue_switch_handler,
     {0x00},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},

    // GND扫描按键：场景快捷键
    {(GNDB | PIN21), lamp_time_handler, {60}, lamp_time_handler, {0x00}, null_handler, {0x00}},
    {(GNDB | PIN20),
     lamp_bright_temperatue_set,
     {1000, 500},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    {(GNDB | PIN19),
     lamp_bright_temperatue_set,
     {1000, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    {(GNDB | PIN18),
     lamp_bright_temperatue_set,
     {100, 1000},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
    {(GNDB | PIN15),
     onoff_reverse_handler,
     {0x02, 0x00},
     null_handler,
     {0x00},
     null_handler,
     {0x00}},
};
#endif

/* 自动计算实际配置的按键数量 */
const uint8_t KEYS_FUNCTION_NUM = sizeof(keys_func_table) / sizeof(str_key_fun);
