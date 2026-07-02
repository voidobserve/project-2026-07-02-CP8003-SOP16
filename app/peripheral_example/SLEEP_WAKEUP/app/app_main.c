/*************************************************************************************************
 * @file       app_main.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-03-11
 * 
 * @copyright Copyright (c) 2025, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "hal_clock.h"
#include "driver_gpio.h"

#define TEST_WAKEUP_GPIO_BITS   (1<<GPIO_PIN6)//(1<<GPIO_PIN6)|(1<<GPIO_PIN7)

//wkup_type: 0 timeout,  1 GPIO trigger
//reture: 0 goto sleep again, 1 fully wake-up
//DO NOT CALL enter_sleep_off_mode in sleep_wakeup_handler
__RAM_CODE_SECTION uint8_t sleep_wakeup_handler(uint32_t wkup_type)
{
    if (wkup_type)  return 1;  //wakeup fully
	
	return 1;
}


void gpio_wakeup_test(void)
{
	log_printf("%s \n ",__FUNCTION__);
	uint64_t t_loop = 0;
	uint32_t loop_count = 0;
	
	uint8_t sleep_enable = 0;

	log_printf("start \n");
	while(1)
	{
		
		hal_clock_time_run();
		if(hal_clock_time_exceed(t_loop, 100*1000))
		{
		 	t_loop = hal_clock_get_system_tick();
			loop_count++;
		}
		
		if(loop_count>=10)
		{
			loop_count = 0;
			sleep_enable =1;
		}
		
		if(sleep_enable)
		{
			sleep_enable =0;
			
			//config wakeup gpio 
			config_wakeup_gpio(TEST_WAKEUP_GPIO_BITS,1);

			log_printf("sleep \n ");

			//goto sleep
			 enter_sleep_mode();
			 
			log_printf("wakeup io : %x\n ",AON_CTRL->WAKEUP_RECORD);
		}
	}
}


void gpio_wakeup_h_l_test(void)
{
	log_printf("%s \n ",__FUNCTION__);
	uint64_t t_loop = 0;
	uint32_t loop_count = 0;
	
	uint8_t sleep_enable = 0;
	gpio_set_input(TEST_WAKEUP_GPIO_BITS,GPIO_MODE_IN_PULL_UP);

	log_printf("start \n");
	while(1)
	{
		
		hal_clock_time_run();
		if(hal_clock_time_exceed(t_loop, 100*1000))
		{
		 	t_loop = hal_clock_get_system_tick();
			loop_count++;
		}
		
		if(loop_count>=10)
		{
			loop_count = 0;
			sleep_enable =1;
		}
		
		if(sleep_enable)
		{
			sleep_enable =0;
			
			// 如果休眠前GPIO是高电平，则配置低电平唤醒
			if(gpio_read_bits(TEST_WAKEUP_GPIO_BITS) == 0x01)
			{
				config_wakeup_gpio(TEST_WAKEUP_GPIO_BITS,1);

				log_printf("低电平唤醒\r\n");
			}
			else {
				
				// 如果休眠前GPIO是低电平，则配置高电平唤醒（松手唤醒）
				config_wakeup_gpio(TEST_WAKEUP_GPIO_BITS,0);
				
				gpio_set_input(TEST_WAKEUP_GPIO_BITS,GPIO_MODE_IN_PULL_UP);
				log_printf("高电平唤醒\r\n");
			}
			
			//goto sleep
			log_printf("sleep \n ");
			enter_sleep_mode();
			
			//清除唤醒的配置,必须
			AON_CTRL->WAKEUP_CTRL0 = 0x00;
			AON_CTRL->WAKEUP_CTRL1 = 0x00;
			
			
			log_printf("wakeup io : %x\n ",AON_CTRL->WAKEUP_RECORD);
		}
	}
}


void timed_wakeup_test(void)
{
	uint64_t t_loop = 0;
	uint32_t loop_count = 0;
	
	uint8_t sleep_enable = 0;


	while(1)
	{
		
		hal_clock_time_run();
		if(hal_clock_time_exceed(t_loop, 100*1000))
		{
		 	t_loop = hal_clock_get_system_tick();
			loop_count++;
		}
		
		if(loop_count>=10)
		{
			loop_count = 0;
			sleep_enable =1;
		}
		
		if(sleep_enable)
		{
			sleep_enable =0;
			 
			log_printf("sleep \n ");
			
			//config wakeup timer interval,unit:mS 
			config_sleep_duation(1000);
			
			//goto sleep
			enter_sleep_mode();
		
			log_printf("wakeup io : %x\n ",AON_CTRL->WAKEUP_RECORD);
		}
	}
}

int app_main(void)
{
	WDT_DIS();
	/* gpio wakeup test */
	gpio_wakeup_test();
	
	/* timed wake up test */
	//timed_wakeup_test();
	
	/* 高低电平动态唤醒 */
	//gpio_wakeup_h_l_test();

    return 0;
}

