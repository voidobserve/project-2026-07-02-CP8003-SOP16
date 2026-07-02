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


#define GPADC_Handler   Interrupt7_Handler



extern void RF_2G4_RADIO_Handler(void);


__RAM_CODE_SECTION ATTRIBUTE_ISR void  RADIO_DMA_Handler(void)
{
//    RF_2G4_RADIO_Handler();
}

//ATTRIBUTE_ISR void UART1_Handler(void)
//{
//
//}



// ATTRIBUTE_ISR void CLKCAL_Handler(void)
// {
//     VTIMER_CLKCALIRQHandler();
// }

ATTRIBUTE_ISR void GPADC_Handler(void)
{

}

ATTRIBUTE_ISR void WDT_Handler(void)
{

}

ATTRIBUTE_ISR void GPIO_Handler(void)
{

}
#if 0
ATTRIBUTE_ISR void TIMER0_Handler(void)
{

}

ATTRIBUTE_ISR void TIMER1_Handler(void)
{

}

ATTRIBUTE_ISR void TIMER2_Handler(void)
{

}

ATTRIBUTE_ISR void TIMER3_Handler(void)
{

}

ATTRIBUTE_ISR void TIMER4_Handler(void)
{


}

// ATTRIBUTE_ISR void TIMER5_Handler(void)
// {

// }

ATTRIBUTE_ISR void TIMER6_Handler(void)
{

}

ATTRIBUTE_ISR void TIMER7_Handler(void)
{

}
#endif