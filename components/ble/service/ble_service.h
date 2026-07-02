/*************************************************************************************************
 * @file ble_service.h
 * @author BLE GROUP ()
 * @brief 
 * @version 1.0.0
 * @date 2025-04-03
 * 
 * 
*************************************************************************************************/
#ifndef _BLE_SERVICE_H_
#define _BLE_SERVICE_H_
#include <stddef.h>
#include <stdarg.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

/* GATT Service Configuration */
#define CUSTOM_SERVICE_UUID    0xFF00  ///< Vendor-specific service UUID
#define DATA_WRITE_UUID        0xFF01  ///< Write-only characteristic UUID
#define DATA_READ_UUID         0xFF02  ///< Read/Notify characteristic UUID
#define NOTIFY_BUFFER_SIZE     20      ///< Maximum notification payload size

void ble_user_service_init(void);

int ble_user_data_notify_send(uint32_t cn_hdl,uint32_t uuid, uint8_t *data, uint16_t len);



#endif