/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-03-07
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "log_dbg.h"
#include "driver_gpio.h"
#include "driver_clkcal.h"
#include "driver_ledc.h"


// 宏定义：MAX_LED_COUNT 表示LED灯带的最大灯珠数量，由此确定帧缓存数组的大小
#define MAX_LED_COUNT 		(100)   // 灯珠数量

/* 
 * 变量: ledc_init_str
 * 作用: LED控制器初始化参数结构体，包含控制信号的高电平持续时间、周期、通道号及输出引脚的设置。
 */
ledc_timing_init_typedef ledc_init_str = {
    .code_0_high = 0x9,      // 代码0高电平持续时间设置,24M时钟周期
    .code_1_high = 0x14,     // 代码1高电平持续时间设置,24M时钟周期
    .period = 0x1D,          // 信号周期设置
	.chnum = LEDC_CHANNEL0,  // 使用的LED通道编号
	.pin = GPIO_PIN20,       // 输出到的GPIO引脚号
};

typedef struct {
	uint8_t r;
    uint8_t g;
    uint8_t b;
	uint8_t w;  // 支持RGBW灯带
} Color_t;

typedef enum {
    COLOR_ORDER_GRB = 0,
    COLOR_ORDER_RGB,
    COLOR_ORDER_RGBW
} ColorOrder_t;

static uint16_t 	max_led_count;
static ColorOrder_t _color_order;
static uint8_t 		_data_mode;
static uint32_t 	_frame_buffer[MAX_LED_COUNT];

// 判断ledc模块数据发送完成标志
volatile uint8_t ledc_done_flag = 0x00;

/**
 * 函数的作用说明: 将HSV颜色模型转换为RGB颜色值，并存储在color结构体中。
 * 传入的参数说明:
 *   - h: 色调，范围通常为0~360。
 *   - s: 饱和度，取值以1000为满值。
 *   - v: 亮度，取值以1000为满值。
 *   - color: 指向Color_t类型的指针，用于存放转换后的RGB（及可能的W）颜色值。
 */
void app_light_tool_hsv_to_rgb(uint16_t h, uint16_t s, uint16_t v, Color_t *color)
{
	// 整型运算，占用otp小
	 uint32_t scal,hi,f;
	 uint32_t vs,vfs;
	 uint32_t p,q,t;
	 uint32_t r=0;
	 uint32_t g=0;
	 uint32_t b=0;
	
	 scal=1000;
	 hi = (h/60) % 6;
	 f = (h%60);
	
	 vs = v * s / scal;
	 vfs = v * f * s/60 /scal;
	
	 p = v	- vs;
	 q = v - vfs;
	 t = p + vfs;
	
	 switch (hi)
	 {
	  case 0:r=v; g=t; b=p;break;
	  case 1:r=q; g=v; b=p;break;
	  case 2:r=p; g=v; b=t;break;
	  case 3: r=p; g=q; b=v; break;
	  case 4:r=t; g=p; b=v;break;
	  default:r=v; g=p; b=q;break;
	 }
	
	 color->r = r * 255/scal;
	 color->g = g * 255/scal;
	 color->b = b * 255/scal;
}

/**
 * 函数的作用说明: 初始化LED灯带，包括设置灯珠数量、颜色排列顺序，以及配置LED控制器参数和中断。
 * 传入的参数说明:
 *   - led_count: LED灯带中灯珠的总数量。
 *   - color_order: 颜色排列顺序，可选值包括 COLOR_ORDER_GRB、COLOR_ORDER_RGB、COLOR_ORDER_RGBW。
 */
void LEDStrip_Init(uint16_t led_count,ColorOrder_t color_order)
{
	// LED灯珠数量
	max_led_count	 = led_count;
	
	// 线序选择
	_color_order = color_order;
	
	// 初始化LED控制器参数
	ledc_init(&ledc_init_str);
	
	// 配置中断，设置当LEDC数据传输完成时触发中断（LEDC_DONE）
	ledc_int_config(ledc_init_str.chnum,LEDC_DONE);//
	
}

/**
 * 函数的作用说明: 根据指定的索引设置单个LED灯珠的颜色。
 * 传入的参数说明:
 *   - index: LED灯珠在灯带中的索引位置。
 *   - color: 使用Color_t结构体表示的颜色值（包括RGB或RGBW）。
 */
void LEDStrip_SetPixel(uint16_t index, Color_t color) 
{
	// 避免数组溢出
	if (index >= max_led_count) return; 
    
	if(_color_order == COLOR_ORDER_GRB)
	{
		// GRB线序
		_frame_buffer[index] = (color.g<<16)|(color.r<<8)|(color.b);
	}
	else if(_color_order == COLOR_ORDER_RGB){
		// RGB线序
		_frame_buffer[index] = (color.r<<16)|(color.g<<8)|(color.b);
	}
	else  if(_color_order == COLOR_ORDER_RGBW){
		// GRBW四线模式
		_frame_buffer[index] = (color.w<<24)|(color.g<<16)|(color.r<<8)|(color.b);
	}
}

/**
 * 函数的作用说明: 为指定区域的LED灯珠填充相同的颜色。
 * 传入的参数说明:
 *   - color: 要填充的颜色值，由Color_t结构体表示。
 *   - start_idx: 填充起始的LED灯珠索引。
 *   - length: 需要填充的LED灯珠数量。
 */
void LEDStrip_Fill(Color_t color, uint16_t start_idx,uint16_t length) 
{
	// 参数合法性检查
    if (start_idx >= max_led_count) return;
    uint16_t end_idx = start_idx + length;
    end_idx = (end_idx > max_led_count) ? max_led_count : end_idx;

	for(uint16_t i =0; i<length; i++)
	{
		LEDStrip_SetPixel(start_idx+i,color);
	}
}	


/**
 * 函数的作用说明: 启动LED控制器，通过DMA传输将帧缓存中的数据输出到LED灯带，实现刷新显示。
 * 传入的参数说明: 无
 */
void LEDStrip_Show(void)
{
	if(_color_order == COLOR_ORDER_RGBW)
	{
		// RGBW四路模式
		_data_mode  = LEDC_DATA_MODE_32BIT;
	}
	else {
		// RGB三路模式
		_data_mode  = LEDC_DATA_MODE_24BIT;
	}
			
	// 配置DMA传输：指定通道、传输模式、数据缓冲区、缓冲区长度以及传输延时
	ledc_dma_buffer_set(ledc_init_str.chnum,_data_mode,_frame_buffer,MAX_LED_COUNT,10);	

	// 启动LED控制器开始输出数据
	ledc_start(ledc_init_str.chnum);
}


/**
 * 函数的作用说明: 清空LED灯带，将帧缓存中的所有数据清零（熄灭所有LED），并刷新显示。
 * 传入的参数说明: 无
 */
void LEDStrip_Clear()
{
	memset(_frame_buffer, 0x00,sizeof(_frame_buffer));
	LEDStrip_Show();
}


/**
 * 函数的作用说明: 通过设置颜色结构体中的w分量来调整LED灯带的色温（适用于RGBW灯带）。
 * 传入的参数说明:
 *   - color: 颜色值结构体，包含RGB和可能的W分量。
 *   - kelvin: 色温值，单位为开尔文（Kelvin）。
 */
void LEDStrip_SetColorTemperature(Color_t color,uint16_t kelvin)
{
	color.w = kelvin;
}

/**
 * 函数的作用说明: LED灯带效果测试函数，包括RGB跳变、RGB流水切换以及黄色呼吸模式的灯光效果。
 * 传入的参数说明: 无
 */
void LEDStrip_TestPattern(void)
{
    static Color_t rgb_test;
    static uint16_t rgb_stream_val = 0;
	static uint16_t rgb_jump_inx = 0;
    static uint16_t rgb_jump_val = 0;
    static uint16_t rgb_breathing = 0;
    static int8_t dir = 20;
    
    // 前面5个灯RGB三色跳变
    if (rgb_jump_val > 1000) 
	{
        rgb_jump_val = 0;
        switch(rgb_jump_inx) {
            case 0: app_light_tool_hsv_to_rgb(0,1000,1000,&rgb_test);break;
            case 1: app_light_tool_hsv_to_rgb(120,1000,1000,&rgb_test);break;
            case 2: app_light_tool_hsv_to_rgb(240,1000,1000,&rgb_test);break;
        }
		
		LEDStrip_Fill(rgb_test, 0, 30);
        rgb_jump_inx = (rgb_jump_inx + 1) % 3;
    }
	rgb_jump_val += 20;
	
	// 中间5个灯RGB流水切换
	for(uint8_t i=0; i<30; i++)
	{
		app_light_tool_hsv_to_rgb(rgb_stream_val+i*12,1000,1000,&rgb_test);
		LEDStrip_SetPixel(30+i,rgb_test);
	}
	rgb_stream_val += 5;
	if(rgb_stream_val > 360) rgb_stream_val = 0;
	
	
	// 后面5个灯黄色呼吸效果
	app_light_tool_hsv_to_rgb(40,1000,rgb_breathing,&rgb_test);
	LEDStrip_Fill(rgb_test,60,30);
	rgb_breathing += dir;
	if(rgb_breathing >= 1000 || rgb_breathing == 0) dir = -dir;

}

/**
 * 函数的作用说明: 程序的主入口，初始化LED灯带及相关模块，并在循环中检测LED数据传输完成标志，不断刷新灯带显示效果。
 * 传入的参数说明: 无
 */
int app_main(void)
{
	WDT_DIS();
	
	// led初始化
	LEDStrip_Init(MAX_LED_COUNT,COLOR_ORDER_GRB);
	
	// led关灯
	LEDStrip_Clear();
	
	while(1)
	{
		if(ledc_done_flag)
		{
			ledc_done_flag = 0x00;
			
			// LED灯带效果测试函数
			LEDStrip_TestPattern();
			
			// 刷新灯带
			LEDStrip_Show();

			// 20ms刷新一次状态
			clkcal_delayms(2);
		}
	}
}


/**
 * 函数的作用说明: LED控制器中断服务函数，用于处理LED数据传输完成中断，清除中断标志并更新传输状态。
 * 传入的参数说明: 无
 */
__RAM_CODE_SECTION ATTRIBUTE_ISR void LEDC_Handler(void)
{
	// 获取当前LED通道的中断状态
	uint8_t intstatus = ledc_int_status(ledc_init_str.chnum);
	
	// 清除当前通道的中断标志
	ledc_int_clear(ledc_init_str.chnum,intstatus);

	// 检测是否为传输完成中断，若是则重新启动LED控制器
	if(intstatus & LEDC_DONE)
	{
		ledc_done_flag = 0x01;
	}
}