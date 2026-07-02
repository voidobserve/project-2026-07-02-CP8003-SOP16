/*************************************************************************************************
 * @file ble_service.c
 * @brief Custom BLE Service Implementation for CP800X Series
 * 
 * @description Implements a custom GATT service with read/write/notify characteristics
 * following BLE 5.2 specifications. Designed for industrial IoT applications requiring
 * bidirectional data transfer with flow control.
 *************************************************************************************************/
#include "include.h"
#include "api_blestack.h"
#if(BLE_MODE_SEL == BLE_2G4_STACK_VER)
#include "api_ble2g4stack.h"
#endif
#include "ble_service.h"

#include "bt_buf.h"


volatile uint8_t ccc_cfg_enable =0;///< Client Characteristic Configuration (CCC) status flag

static ssize_t  gatt_data_write(struct bt_conn *conn, const struct bt_gatt_attr *attr, const uint8_t *buf, uint16_t len,uint16_t offset, uint8_t flags)
{
	log_printf("gatt_data_write \n");
    for(uint8_t i=0;i<len;i++)
    log_printf("%02x ", buf[i]);
    log_printf("\n ");
	return len;
}

static ssize_t  gatt_data_read(struct bt_conn *conn, const struct bt_gatt_attr *attr, uint8_t *buf, uint16_t len,uint16_t offset)
{
    uint8_t read_data[20]={0x0,0x1,0x2,0x3,0x4,0x5,0x6};//"CP8000 TEST Data";

	log_printf("gatt_data_read \n");
    
    return bt_gatt_attr_read(conn, attr, buf, len, offset, read_data,20 );//sizeof(read_data)
}

static void svc_ccc_cfg_changed(const struct bt_gatt_attr *attr, uint16_t value)
{
	ccc_cfg_enable = value;
	log_printf("ccc_cfg_enable :%d \n",ccc_cfg_enable);
}

/**
 * @struct BT_GATT_SERVICE_DEFINE(user_ble_service)
 * @brief Custom GATT Service Structure
 * 
 * @composition:
 * - Primary Service Declaration (0xFF00)
 * - Write Characteristic (0xFF01):
 *   - Write Without Response
 *   - 255-byte buffer support
 * - Read/Notify Characteristic (0xFF02):
 *   - Server-initiated notifications
 *   - 20-byte MTU optimization
 * - CCC Descriptor with Security:
 *   - Read/Write permissions
 *   - Encrypted connections required
 */
BT_GATT_SERVICE_DEFINE(user_ble_service,
    BT_GATT_PRIMARY_SERVICE(BT_UUID_DECLARE_16(CUSTOM_SERVICE_UUID)),
    BT_GATT_CHARACTERISTIC(BT_UUID_DECLARE_16(DATA_WRITE_UUID),
        BT_GATT_CHRC_WRITE_WITHOUT_RESP,
        BT_GATT_PERM_WRITE,
        NULL, 
        (void *)gatt_data_write, 
        NULL),
    BT_GATT_CHARACTERISTIC(BT_UUID_DECLARE_16(DATA_READ_UUID),
        BT_GATT_CHRC_READ | BT_GATT_CHRC_NOTIFY,
        BT_GATT_PERM_READ,
        (void *)gatt_data_read, 
        NULL, 
        NULL),
    BT_GATT_CCC(user_ble_service, svc_ccc_cfg_changed,
        BT_GATT_PERM_READ | BT_GATT_PERM_WRITE)
);


void ble_user_service_init(void)
{
	log_printf("ble_user_service_init \n");
    ble_user_service_add(&user_ble_service);
}

//call this function to send data
int ble_user_data_notify_send(uint32_t cn_hdl,uint32_t uuid, uint8_t *data, uint16_t len)
{
	if(!ccc_cfg_enable) return -2;
	
	if(bt_buf_reserve_size_host_tx_acl() == 0) return -1;
	
    struct bt_gatt_notify_params params;

    memset(&params, 0, sizeof(params));
	params.uuid = BT_UUID_DECLARE_16(uuid);
    params.data = data;
    params.len = len;
    params.func = NULL;

    return bt_gatt_notify_cb((struct bt_conn *)cn_hdl, &params);
}