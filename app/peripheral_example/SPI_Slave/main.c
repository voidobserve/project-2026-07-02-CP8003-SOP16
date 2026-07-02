/*************************************************************************************************
 * @file       mian.c
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
int app_main(void);
int main(void)
{
#if(LOG_ENABLE)
	log_dbg_init();
	
	log_printf("SDK_VERSION:%x \n",SDK_VERSION);
	log_printf("SDK_DATE:%x \n",SDK_DATE);
#endif

	//app
	app_main();

    return 0;
}