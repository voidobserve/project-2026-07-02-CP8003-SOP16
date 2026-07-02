/*************************************************************************************************
 * @file       mian.c
 * @author     BLE Group
 * @brief 
 * @version    1.0.1
 * @date       2025-02-07
 * 
 * @copyright Copyright (c) 2025, CHIP PUMP Microelectronics.
                 All rights reserved.
 * 
 ************************************************************************************************/
#include "include.h"
 
int app_main(void);

int main(void)
{
	
	REG_WRT(0x40080124,0x13);
	
#if(LOG_ENABLE)
	log_dbg_init();
	
	log_printf("SDK_VERSION:%x \n",SDK_VERSION);
	log_printf("SDK_DATE:%x \n",SDK_DATE);
#endif
	
	
	log_printf("vdd:%x \r\n",REG_RD(0x40080124));
	//app
	app_main();

    return 0;
}