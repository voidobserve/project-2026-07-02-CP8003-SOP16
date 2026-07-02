/*************************************************************************************************
 * @file       app_isr.c
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
#include "driver_gpio.h"
#include "driver_timer.h"

#define GPADC_Handler   Interrupt7_Handler



extern void RF_2G4_RADIO_Handler(void);


__RAM_CODE_SECTION ATTRIBUTE_ISR void  RADIO_DMA_Handler(void)
{
    RF_2G4_RADIO_Handler();
}



