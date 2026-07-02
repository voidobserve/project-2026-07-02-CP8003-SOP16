/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief      I2C主设备测试程序
 * @version    1.0.1
 * @date       2025-02-26
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "driver_iic.h"
#include "driver_gpio.h"

/* 宏定义 --------------------------------------------------------------------------------------*/
#define IIC_DEVICE_ADDR            0x50     // I2C从设备地址（7位地址格式）

/* 结构体初始化 --------------------------------------------------------------------------------*/
I2C_Init_structure_typedef I2C_init_Str =   // I2C初始化参数结构体
{
    .i2c_mode = IIC_MODE_MASTER,            // 主模式
    .speed_mode = IIC_SPEED_STANDARD,       // 标准速度模式
    .speed = IIC_CLK_100K,                  // 100kHz时钟
    .device_addr = IIC_DEVICE_ADDR,         // 本机设备地址
    .i2c_sda_pin = GPIO_PIN0,              // SDA引脚配置
    .i2c_scl_pin = GPIO_PIN1,              // SCL引脚配置
};

/* 全局变量 ------------------------------------------------------------------------------------*/
uint8_t read_buff[8]={0x0};                 // 数据读取缓冲区

/* 函数定义 ------------------------------------------------------------------------------------*/
/**
  * @brief  I2C通信测试函数
  * @note   实现I2C主设备的读写测试功能，包含数据递增写入和回读验证
  * @param  无
  * @retval 无
  */
void iic_test(void)
{
//		*(volatile uint32_t*)(0x4008000c) &= 0xffffeffe;
		
    iic_init(&I2C_init_Str);  			    // 初始化I2C外设
    uint8_t data[8] = {0,1,2,3,4,5,6,7};  	// 测试数据缓冲区
    
    while(1)  							    // 主测试循环
    {
        // 数据递增处理（每次循环增加测试1）
        for(uint8_t i=0;i<8;i++)
            data[i] += 1;

        log_printf("loop \n");  		    // 循环计数打印

        /* I2C数据写入流程 */
        I2C_write(0, data, 8);  		    // 参数说明：0-设备地址偏移，data-写入数据指针，8-数据长度
        delay_ms(1000);    		    // 写入后延时
        
        /* I2C数据读取流程 */
        I2C_read(0, read_buff, 8);  	    // 参数说明：0-设备地址偏移，read_buff-读取缓冲区，8-读取长度

        // 打印读取结果
        for(uint8_t i=0;i<8;i++)
            log_printf("%x ",read_buff[i]);
        log_printf(" \n ");
    }
}

/**
  * @brief  应用程序主函数
  * @note   系统启动后首先执行的函数，初始化测试程序
  * @param  无
  * @retval 程序执行状态（0表示正常）
  */
int app_main(void)
{
     WDT_DIS();
    // 启动I2C测试程序
	iic_test();  
	
    return 0;
}