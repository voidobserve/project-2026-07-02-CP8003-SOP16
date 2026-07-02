/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief      PWM应用示例主程序
 * @version    1.0.1
 * @date       2025-03-07
 * 
 * @copyright Copyright (c) 2025, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "log_dbg.h"
#include "driver_clkcal.h"
#include "driver_timer.h"

/* PWM测试参数宏定义 ----------------------------------------------------------*/
#define PWM_FREQ           (20000)      			// 1KHz频率,PWM周期（单位：Hz），在不分频的情况下，最低频率为183Hz,即65535/12M = 183Hz
#define PWM_CYCLE_CNT      (12000000/PWM_FREQ) 		// 周期计数器值（PWM 默认12MHz时钟），频率=12MHz/PWM_FREQ
#define DUTY_STEPS         (100)        			// 占空比分级数
#define DEAD_TIME_US       (5)         			 	// 死区时间5us（单位：us）,最大值为1009 PWM CLK cycle,即1009/12M = 84us
#define DEAD_TIME_CNT      (12 * DEAD_TIME_US) 	 	// 死区计数器值

// 例程1配置：两路独立PWM
pwm_config_param_t pwm_independent[] = {
    {
        .pwm_Cycle_CNT = PWM_CYCLE_CNT,
        .pwm_Init_Duty_CNT = 0,
        .pwm_Pin = PWM0_PIN0,
        .pwm_Mode = PWM_POS,
        .pwm_CH = PWM0
    },
    {
        .pwm_Cycle_CNT = PWM_CYCLE_CNT,
        .pwm_Init_Duty_CNT = 0,
        .pwm_Pin = PWM1_PIN1,
        .pwm_Mode = PWM_POS,
        .pwm_CH = PWM1
    }
};

// 例程2配置：互补PWM
pwm_config_param_t pwm_complementary = {
    .pwm_Cycle_CNT = PWM_CYCLE_CNT,
    .pwm_Init_Duty_CNT = 0,
    .pwm_Pin = PWM0_PIN0,
    .pwm_N_Pin = PWM0N_PIN1,	//需进行互补输出的PWM
    .pwm_Mode = PWM_COMP,	    //若要PWM互补输出，此处必须设置为0x03
    .pwm_CH = PWM0
};

// 例程3配置：互补带死区PWM
pwm_config_param_t pwm_dead_zone = {
    .pwm_Cycle_CNT = PWM_CYCLE_CNT,
    .pwm_Init_Duty_CNT = 0,
    .pwm_Pin = PWM0_PIN0,
    .pwm_N_Pin = PWM0N_PIN1,	//需进行互补输出的PWM
    .pwm_Mode = PWM_COMP,	    //若要PWM互补输出，此处必须设置为0x03
    .pwm_DT_CNT = DEAD_TIME_CNT,//死区时间配置
    .pwm_CH = PWM0
};

/**
  * @brief  例程1：两路独立PWM呼吸灯
  * @note   PWM0和PWM1独立输出，占空比同步变化
  */
void pwm_test_independent(void)
{
    log_printf("Independent PWM Test\n");
    pwm_init(&pwm_independent[0]);
    pwm_init(&pwm_independent[1]);
    
    uint8_t step = 0;
    int8_t dir = 1;
    while(1) {
        // 计算当前占空比（三角波变化）
        uint32_t duty = (PWM_CYCLE_CNT * step) / DUTY_STEPS;
        
        // 设置两路PWM占空比
        pwm_duty_set(PWM0, duty);
        pwm_duty_set(PWM1, duty);
        
        // 更新步进
        step += dir;
        if(step >= DUTY_STEPS || step == 0) dir = -dir;
        
        clkcal_delayms(10); // 10ms步进，总周期1秒
    }
}

/**
  * @brief  例程2：互补PWM呼吸灯
  * @note   PWM0和PWM0N互补输出，无死区
  */
void pwm_test_complementary(void)
{
    log_printf("Complementary PWM Test\n");
    pwm_init(&pwm_complementary);
    
    uint8_t step = 0;
    int8_t dir = 1;
    while(1) {
        uint32_t duty = (PWM_CYCLE_CNT * step) / DUTY_STEPS;
        pwm_duty_set(PWM0, duty);
        step += dir;
        if(step >= DUTY_STEPS || step == 0) dir = -dir;
        clkcal_delayms(10);
    }
}

/**
  * @brief  例程3：带死区互补PWM呼吸灯
  * @note   PWM0和PWM0N互补输出，带5us死区
  */
void pwm_test_dead_zone(void)
{
    log_printf("Dead Zone PWM Test\n");
    pwm_init(&pwm_dead_zone);
    
    uint8_t step = 0;
    int8_t dir = 1;
    while(1) {
        uint32_t duty = (PWM_CYCLE_CNT * step) / DUTY_STEPS;
        pwm_duty_set(PWM0, duty);
        step += dir;
        if(step >= DUTY_STEPS || step == 0) dir = -dir;
        clkcal_delayms(10);
    }
}

/**
  * @brief  主应用程序入口
  * @note   系统启动后首先执行的函数
  * @param  无
  * @retval int 程序执行状态（始终返回0）
  */
int app_main(void)
{
     WDT_DIS();
    // 通过注释选择测试例程
	
	//例程1：PWM0和PWM1独立输出，占空比同步变化
//    pwm_test_independent();    		
	
	//例程2：PWM0和PWM0N互补输出，无死区
    pwm_test_complementary();  	
	
	//例程3：PWM0和PWM0N互补输出，带5us死区
//    pwm_test_dead_zone();       	

    return 0;
}
