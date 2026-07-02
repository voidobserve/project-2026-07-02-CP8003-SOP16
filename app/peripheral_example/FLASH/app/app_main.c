/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-02-25
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"                                                           
#include "driver_flash.h"                                                     

/**
 * @brief Flash测试基地址定义
 * 
 * 测试Flash基地址 = Flash基址 + Flash总大小 - Flash尾部保留空间
 */
#define TEST_FLASH_ADDR_BASE  (FLASH_BASE_ADDR + FLASH_TOTAL_SIZE - FLASH_TAIL_RS)    

/**
 * @brief Flash测试数据大小定义
 * 
 * 测试Flash数据大小：256字节
 */
#define TEST_FLASH_SIZE    256                                                      

/**
 * @brief Flash读取数据缓冲区定义
 * 
 * Flash读取数据缓冲区，大小为TEST_FLASH_SIZE字节
 */
uint8_t read_buff[TEST_FLASH_SIZE] = {0x0};                                          

/**
 * @brief Flash写入数据缓冲区定义
 * 
 * Flash写入数据缓冲区，大小为TEST_FLASH_SIZE字节
 */
uint8_t write_data[TEST_FLASH_SIZE] = {0x0};                                        

/**
 * @brief Flash读写测试函数
 * 
 * 执行Flash写入和读取测试，循环执行擦除、写入、读取操作进行完整性校验
 * 
 * @param  无传入参数
 * @retval 无返回值
 */
void flash_write_read_test(void)
{
    /**
     * @brief 测试循环计数器定义
     * 
     * 测试循环计数器，用于生成测试数据
     */
    uint8_t test_index =0;                                                           // 测试循环计数器

    while(1)                                                                         // 无限循环执行Flash测试
    {
        #if 1                                                                        // 条件编译开关：启用Flash测试代码
        log_printf("write data: ");
        for(uint16_t i=0;i<TEST_FLASH_SIZE;i++)                                      // 遍历并准备写入数据（256字节）
        {
            write_data[i] = i+ test_index;                                           // 生成测试数据：索引值+循环计数
            log_printf("%x ",write_data[i]);
        }
        log_printf(" \n ");
        test_index++;                                                                // 递增测试循环计数器

        log_printf("loop count:%d\n",test_index);
        
        //flash erase                                                                // Flash擦除操作
        flash_sector_erase(TEST_FLASH_ADDR_BASE);                                    // 擦除Flash扇区

        //flash write                                                                // Flash写入操作
        flash_write(TEST_FLASH_ADDR_BASE,write_data,TEST_FLASH_SIZE);                // 将测试数据写入Flash
        void clkcal_delayms(int d);
        clkcal_delayms(1000);
        
        //flash read                                                                 // Flash读取操作
        flash_read(TEST_FLASH_ADDR_BASE,read_buff,TEST_FLASH_SIZE);                  // 从Flash读取数据到缓冲区
        
        log_printf("read data: ");
        for(uint16_t i=0;i<(TEST_FLASH_SIZE);i++)                                    
            log_printf("%x ",read_buff[i]);
        log_printf(" \n ");
        
        #endif                                                                      
        clkcal_delayms(1000);
    }
}

/**
 * @brief Flash写保护测试函数
 * 
 * 执行Flash写保护测试，先锁定Flash测试写操作失败，然后解锁Flash验证写操作成功
 * 
 * @param  无传入参数
 * @retval 无返回值
 */
void flash_write_protect_test(void)
{
    /**
     * @brief 测试循环计数器定义
     * 
     * 测试循环计数器，用于生成测试数据
     */
    uint8_t test_index =0;                                                           

    flash_lock();                                                                    // 锁定Flash，禁止写操作
    log_printf("******************************************************************");
    log_printf("flash locked! \n");
    while(1)                                                                         // 第一阶段：Flash锁定状态测试循环
    {
        log_printf("write data: ");
        for(uint16_t i=0;i<TEST_FLASH_SIZE;i++)                                      // 遍历并准备写入数据（256字节）
        {
            write_data[i] = i+ test_index;                                           // 生成测试数据：索引值+循环计数
            log_printf("%x ",write_data[i]);
        }
        log_printf(" \n ");
        test_index++;                                                                // 递增测试循环计数器

        log_printf("loop count:%d\n",test_index);    
        
        //flash erase                                                                // Flash擦除操作
        flash_sector_erase(TEST_FLASH_ADDR_BASE);                                    // 擦除Flash扇区
    
        //在锁定状态下此操作应该是失败                                            	 // Flash写入操作
        flash_write(TEST_FLASH_ADDR_BASE,write_data,TEST_FLASH_SIZE);                // 将测试数据写入Flash
        void clkcal_delayms(int d);
        clkcal_delayms(1000);
        
        //flash read                                                                 // Flash读取操作
        flash_read(TEST_FLASH_ADDR_BASE,read_buff,TEST_FLASH_SIZE);                  // 从Flash读取数据到缓冲区
        
        log_printf("read data: ");
        for(uint16_t i=0;i<(TEST_FLASH_SIZE);i++)                                    // 遍历读取的数据（256字节）
            log_printf("%x ",read_buff[i]);
        log_printf(" \n ");
        
        clkcal_delayms(1000);
        if(test_index>10)                                                            // 当测试循环次数超过10次时
            break;                                                                   // 跳出循环，结束Flash锁定状态的测试阶段
    }
    

    flash_unlock();                                                                  // 解锁Flash，允许写操作
    log_printf("******************************************************************");
    log_printf("flash unlocked! \n");
    while(1)                                                                         // 第二阶段：Flash解锁状态测试循环
    {
        log_printf("write data: ");
        for(uint16_t i=0;i<TEST_FLASH_SIZE;i++)                                      // 遍历并准备写入数据（256字节）
        {
            write_data[i] = i+ test_index;                                           // 生成测试数据：索引值+循环计数
            log_printf("%x ",write_data[i]);
        }
        log_printf(" \n ");
        test_index++;                                                                // 递增测试循环计数器

        log_printf("loop count:%d\n",test_index);    
        
        //flash erase                                                                // Flash擦除操作
        flash_sector_erase(TEST_FLASH_ADDR_BASE);                                    // 擦除Flash扇区
    
        //flash write                                                                // Flash写入操作
        flash_write(TEST_FLASH_ADDR_BASE,write_data,TEST_FLASH_SIZE);                // 将测试数据写入Flash（在解锁状态下此操作应该成功）
        void clkcal_delayms(int d);
        clkcal_delayms(1000);
        
        //flash read                                                                 // Flash读取操作
        flash_read(TEST_FLASH_ADDR_BASE,read_buff,TEST_FLASH_SIZE);                  // 从Flash读取数据到缓冲区
        
        log_printf("read data: ");
        for(uint16_t i=0;i<(TEST_FLASH_SIZE);i++)                                    // 遍历读取的数据（256字节）
            log_printf("%x ",read_buff[i]);
        log_printf(" \n ");

        clkcal_delayms(1000);
    }
}

/**
 * @brief 应用程序主函数
 * 
 * 初始化系统并执行Flash测试功能
 * 
 * @param  无传入参数
 * @retval 返回整型值：程序正常结束返回0
 */
int app_main(void)
{
    WDT_DIS();                                                                       
    /* flash write read test */                                                     
//   flash_write_read_test();                                                        // 调用Flash读写测试函数
    flash_write_protect_test();                                                      // 调用Flash写保护测试函数，验证Flash锁定和解锁功能
   
    return 0;                                                                       
}