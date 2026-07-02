/*************************************************************************************************
 * @file       app_main.h
 * @author     BLE Group
 * @brief 
 * @version    1.0.0
 * @date       2024-07-25
 * 
 * @copyright Copyright (c) 2024, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
#include "log_dbg.h"
#include "driver_gpadc.h"


void gpadc_test(void)
{
	uint16_t volt_1,volt_2;
	uint16_t vbat;
	uint32_t loop_count =0;
	
	gpadc_channel_Init(GPADC_CHANNEL_GPIO6);
	gpadc_channel_Init(GPADC_CHANNEL_GPIO7);
	
	while(1)
	{
		
		// ADC IN voltage sample
        volt_1 = gpadc_get_sample(GPADC_CHANNEL_GPIO6);
		volt_2 = gpadc_get_sample(GPADC_CHANNEL_GPIO7);
		
		// BAT voltage sample
		vbat = gpadc_get_sampleBAT();
		
		log_printf("loop count:%d , volt_1= %4d, volt_2= %4d ,vbat = %4d \n",loop_count,volt_1,volt_2,vbat);
		
		loop_count++;
		DELAY_MS(300);
	}
}

int app_main(void)
{
	WDT_DIS();
	//test example
	gpadc_test();
	
    return 0;
}
