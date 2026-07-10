
.//Obj/CP8003_REMOTER.elf:     file format elf32-littleriscv


Disassembly of section .text:

10000000 <reset_handler>:
10000000:	00000093          	li	ra,0
10000004:	8106                	mv	sp,ra
10000006:	8186                	mv	gp,ra
10000008:	8206                	mv	tp,ra
1000000a:	8286                	mv	t0,ra
1000000c:	8306                	mv	t1,ra
1000000e:	8386                	mv	t2,ra
10000010:	8406                	mv	s0,ra
10000012:	8486                	mv	s1,ra
10000014:	8506                	mv	a0,ra
10000016:	8586                	mv	a1,ra
10000018:	8606                	mv	a2,ra
1000001a:	8686                	mv	a3,ra
1000001c:	8706                	mv	a4,ra
1000001e:	8786                	mv	a5,ra
10000020:	00000517          	auipc	a0,0x0
10000024:	06050513          	addi	a0,a0,96 # 10000080 <trap_handler>
10000028:	00356513          	ori	a0,a0,3
1000002c:	30551073          	csrw	mtvec,a0
10000030:	10000517          	auipc	a0,0x10000
10000034:	fd050513          	addi	a0,a0,-48 # 20000000 <__VECTOR_TABLE>
10000038:	30751073          	csrw	mtvt,a0
1000003c:	10004117          	auipc	sp,0x10004
10000040:	fc410113          	addi	sp,sp,-60 # 20004000 <__StackTop>
10000044:	34011073          	csrw	mscratch,sp
10000048:	692000ef          	jal	100006da <sys_entry>

1000004c <__exit>:
1000004c:	a001                	j	1000004c <__exit>
1000004e:	00000013          	nop
10000052:	00000013          	nop
10000056:	00000013          	nop
1000005a:	00000013          	nop
1000005e:	00000013          	nop
10000062:	00000013          	nop
10000066:	00000013          	nop
1000006a:	00000013          	nop
1000006e:	00000013          	nop
10000072:	00000013          	nop
10000076:	00000013          	nop
1000007a:	00000013          	nop
1000007e:	0001                	nop

10000080 <trap_handler>:
10000080:	30047573          	csrrci	a0,mstatus,8

10000084 <__deadloop>:
10000084:	a001                	j	10000084 <__deadloop>
10000086:	30200073          	mret
	...

100000b4 <direct_key_value>:
 * 说明：直接发送按键键值
 * 输入：0x00-0xff
 ***************************************************************************/
void direct_key_value(str_fun_para* para)
{
    ble_viot_para.cmd = 0xFF;
100000b4:	200017b7          	lui	a5,0x20001
100000b8:	25878793          	addi	a5,a5,600 # 20001258 <ble_viot_para>
100000bc:	577d                	li	a4,-1
100000be:	00e788a3          	sb	a4,17(a5)
    ble_viot_para.para[0] = para->para_a;
100000c2:	00055703          	lhu	a4,0(a0)
100000c6:	00e79923          	sh	a4,18(a5)
}
100000ca:	8082                	ret

100000cc <gpio_set_output>:
void gpio_set_func(ENUM_GPIO_PIN pin, uint8_t func_code)
{
    if(!VALID_PIN(pin)) return;

    /* Direct register access with boundary check */
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
100000cc:	40010737          	lui	a4,0x40010
 */
void gpio_set_output(uint32_t gpio_bits,uint8_t state)
{
    /* Set GPIO mode to floating input (base configuration) */
	uint32_t cfg_val =  GPIO_MODE_IN_FLOATING;
    for (int pin = 0; pin < GPIO_MAX; pin++)
100000d0:	4781                	li	a5,0
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
100000d2:	20070713          	addi	a4,a4,512 # 40010200 <__StackTop+0x2000c200>
    for (int pin = 0; pin < GPIO_MAX; pin++)
100000d6:	4661                	li	a2,24
    {
		if(gpio_bits & PIN_TO_MASK(pin))
100000d8:	00f556b3          	srl	a3,a0,a5
100000dc:	8a85                	andi	a3,a3,1
100000de:	c689                	beqz	a3,100000e8 <gpio_set_output+0x1c>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
100000e0:	00e786b3          	add	a3,a5,a4
100000e4:	00068023          	sb	zero,0(a3)
    for (int pin = 0; pin < GPIO_MAX; pin++)
100000e8:	0785                	addi	a5,a5,1
100000ea:	fec797e3          	bne	a5,a2,100000d8 <gpio_set_output+0xc>

        gpio_set_func(pin, cfg_val);
    }

    /* Update output registers */
    GPIO_INOUT->GPIO_OE |= gpio_bits;
100000ee:	400107b7          	lui	a5,0x40010
100000f2:	5b98                	lw	a4,48(a5)
100000f4:	8f49                	or	a4,a4,a0
100000f6:	db98                	sw	a4,48(a5)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
100000f8:	43b8                	lw	a4,64(a5)
100000fa:	c581                	beqz	a1,10000102 <gpio_set_output+0x36>
100000fc:	8d59                	or	a0,a0,a4
100000fe:	c3a8                	sw	a0,64(a5)
}
10000100:	8082                	ret
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
10000102:	fff54513          	not	a0,a0
10000106:	8d79                	and	a0,a0,a4
10000108:	bfdd                	j	100000fe <gpio_set_output+0x32>

1000010a <hal_clock_time_exceed>:
uint32_t _u32_tick = 0;

/******************************************************************************************/
uint32_t hal_clock_get_system_tick(void)
{
    return _u32_tick;
1000010a:	200017b7          	lui	a5,0x20001
1000010e:	25878793          	addi	a5,a5,600 # 20001258 <ble_viot_para>
uint8_t hal_clock_time_exceed(uint64_t ref, uint32_t span_us)
{
	uint8_t ret = 0;
	uint32_t tick_temp = hal_clock_get_system_tick();

	if(tick_temp >= ref)
10000112:	4f9c                	lw	a5,24(a5)
10000114:	ed81                	bnez	a1,1000012c <hal_clock_time_exceed+0x22>
10000116:	00a7eb63          	bltu	a5,a0,1000012c <hal_clock_time_exceed+0x22>
	{
		ret = ((tick_temp - ref) > span_us); 
1000011a:	40a78733          	sub	a4,a5,a0
1000011e:	4505                	li	a0,1
10000120:	02e7e363          	bltu	a5,a4,10000146 <hal_clock_time_exceed+0x3c>
	}
	else
	{
		ret = ((0xFFFFFFFF - ref + tick_temp) > span_us);
10000124:	02e66163          	bltu	a2,a4,10000146 <hal_clock_time_exceed+0x3c>
10000128:	4501                	li	a0,0
1000012a:	8082                	ret
1000012c:	fff78693          	addi	a3,a5,-1
10000130:	40a68733          	sub	a4,a3,a0
10000134:	00f037b3          	snez	a5,a5
10000138:	00e6b6b3          	sltu	a3,a3,a4
1000013c:	40b785b3          	sub	a1,a5,a1
10000140:	4505                	li	a0,1
10000142:	fed581e3          	beq	a1,a3,10000124 <hal_clock_time_exceed+0x1a>
	}

	return ret;
}
10000146:	8082                	ret

10000148 <ble_adv_timer_init>:
}

void ble_adv_timer_init(void)
{
    // 初始化发包参数
    send_packet_request = 0;
10000148:	20001537          	lui	a0,0x20001
1000014c:	25850513          	addi	a0,a0,600 # 20001258 <ble_viot_para>
    packet_tx_count = 0;
    last_send_time = 0;
10000150:	4701                	li	a4,0
10000152:	4781                	li	a5,0
    send_packet_request = 0;
10000154:	00050e23          	sb	zero,28(a0)
    packet_tx_count = 0;
10000158:	00051f23          	sh	zero,30(a0)
    last_send_time = 0;
1000015c:	d118                	sw	a4,32(a0)
1000015e:	d15c                	sw	a5,36(a0)
    memset(packet_buffer, 0, sizeof(packet_buffer));
10000160:	02700613          	li	a2,39
10000164:	4581                	li	a1,0
10000166:	02850513          	addi	a0,a0,40
1000016a:	2870106f          	j	10001bf0 <memset>

1000016e <main>:
 * 函数的作用说明：
 *    遥控器主入口函数，负责系统初始化和主循环
 *    主要功能：按键扫描、按键处理、指示灯控制、涂鸦广播发送
 */
int main(void)
{
1000016e:	fa810113          	addi	sp,sp,-88
10000172:	ca86                	sw	ra,84(sp)
10000174:	c8a2                	sw	s0,80(sp)
10000176:	c6a6                	sw	s1,76(sp)
    log_dbg_init();
    log_printf("初始化完成");
#endif

    // ========== 初始化2.4G射频模块 ==========
    rf_2g4_init(); 
10000178:	678010ef          	jal	100017f0 <rf_2g4_init>
    rf_2g4_set_tx_power(6); // 设置发射功率 
1000017c:	4519                	li	a0,6
1000017e:	03f010ef          	jal	100019bc <rf_2g4_set_tx_power>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
10000182:	400107b7          	lui	a5,0x40010
 * @see ENUM_GPIO_MODE for available input modes
 */
void gpio_set_input(uint32_t gpio_bits,ENUM_GPIO_MODE mode)
{
	uint32_t cfg_val = (mode&0xE0)| 0x0;
    for (int i = 0; i < GPIO_MAX; i++)
10000186:	4601                	li	a2,0
    {
		if(gpio_bits&(0x1<<i))
10000188:	4685                	li	a3,1
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1000018a:	20078793          	addi	a5,a5,512 # 40010200 <__StackTop+0x2000c200>
1000018e:	02000593          	li	a1,32
    for (int i = 0; i < GPIO_MAX; i++)
10000192:	4761                	li	a4,24
		if(gpio_bits&(0x1<<i))
10000194:	00c69533          	sll	a0,a3,a2
10000198:	01255313          	srli	t1,a0,0x12
1000019c:	00f37313          	andi	t1,t1,15
100001a0:	00030663          	beqz	t1,100001ac <main+0x3e>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
100001a4:	00f60533          	add	a0,a2,a5
100001a8:	00b50023          	sb	a1,0(a0)
    for (int i = 0; i < GPIO_MAX; i++)
100001ac:	0605                	addi	a2,a2,1
100001ae:	fee613e3          	bne	a2,a4,10000194 <main+0x26>

        gpio_set_func(i, cfg_val);
    }

	GPIO_INOUT->GPIO_OE &=~gpio_bits;
100001b2:	400106b7          	lui	a3,0x40010
100001b6:	5a9c                	lw	a5,48(a3)
100001b8:	ffc40737          	lui	a4,0xffc40
100001bc:	177d                	addi	a4,a4,-1 # ffc3ffff <__StackTop+0xdfc3bfff>
100001be:	8ff9                	and	a5,a5,a4
100001c0:	c032                	sw	a2,0(sp)

    // 配置输入口：上拉输入
    gpio_set_input(input_bits, GPIO_MODE_IN_PULL_UP);

    // 配置输出口：输出模式，初始高电平
    gpio_set_output(output_bits, GPIO_HIGH);
100001c2:	6521                	lui	a0,0x8
100001c4:	da9c                	sw	a5,48(a3)
100001c6:	4585                	li	a1,1
100001c8:	1c350513          	addi	a0,a0,451 # 81c3 <ble_viot.c.e415c280+0x2b5d>
100001cc:	3701                	jal	100000cc <gpio_set_output>
extern const uint8_t KEYS_FUNCTION_NUM;

/* 按键处理初始化 */
void key_process_init(void)
{
    memset((void *)&key_info, 0x0, sizeof(str_key_info));
100001ce:	20001437          	lui	s0,0x20001
100001d2:	25840413          	addi	s0,s0,600 # 20001258 <ble_viot_para>

    // 配置指示灯：输出模式，初始关闭
    gpio_set_output((1UL << SINGLE_LED_GPIO), GPIO_LOW);
100001d6:	4581                	li	a1,0
100001d8:	20000513          	li	a0,512
100001dc:	3dc5                	jal	100000cc <gpio_set_output>
100001de:	04042823          	sw	zero,80(s0)
100001e2:	04042a23          	sw	zero,84(s0)
100001e6:	04042c23          	sw	zero,88(s0)
100001ea:	04042e23          	sw	zero,92(s0)
/* ==================== 初始化函数==================== */
void ble_packet_init(void)
{
    // 兼容旧AK803 payload字段：广播中使用GROUP_ADDR低16位作为滚码。
    // CP8003上旧地址0x1FE0未确认可读，先沿用SDK已有MAC存储区作为稳定来源。
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
100001ee:	1003f7b7          	lui	a5,0x1003f
100001f2:	439c                	lw	a5,0(a5)
    
    // 初始化 VIOT 参数结构
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
100001f4:	4602                	lw	a2,0(sp)
100001f6:	4581                	li	a1,0
100001f8:	8522                	mv	a0,s0
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
100001fa:	d03c                	sw	a5,96(s0)
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
100001fc:	1f5010ef          	jal	10001bf0 <memset>
    key_process_init();
    // VIOT协议初始化已在key_process_init()中调用ble_packet_init()完成
    log_printf("Remoter initialized (VIOT mode)\n");

    // ========== 初始化BLE广播发送参数 ==========
    ble_adv_timer_init(); // 初始化广播发送参数（主循环模式）
10000200:	37a1                	jal	10000148 <ble_adv_timer_init>

void hal_clock_time_run(void)
{
	static uint32_t pre_tick = 0;

	uint32_t cur_tick = REG_RD(0x42000104);// (SYS_CTRL->AON_RTC);
10000202:	420007b7          	lui	a5,0x42000
10000206:	1047a703          	lw	a4,260(a5) # 42000104 <__StackTop+0x21ffc104>
	
	if(cur_tick >= pre_tick)
1000020a:	4c1c                	lw	a5,24(s0)
1000020c:	5074                	lw	a3,100(s0)
1000020e:	97ba                	add	a5,a5,a4
10000210:	8f95                	sub	a5,a5,a3
		_u32_tick += (cur_tick - pre_tick);
		pre_tick = cur_tick;
	}
	else
	{
		_u32_tick += ( 0xFFFFFFFF- pre_tick + cur_tick);
10000212:	fff78493          	addi	s1,a5,-1
	if(cur_tick >= pre_tick)
10000216:	00d76363          	bltu	a4,a3,1000021c <main+0xae>
		_u32_tick += (cur_tick - pre_tick);
1000021a:	84be                	mv	s1,a5
    while (1) {

        hal_clock_time_run();

        /* ========== 按键扫描（5ms周期）========== */
        if (hal_clock_time_exceed(key_scan_timer, 5 * 1000)) {
1000021c:	5428                	lw	a0,104(s0)
1000021e:	546c                	lw	a1,108(s0)
10000220:	6605                	lui	a2,0x1
10000222:	38860613          	addi	a2,a2,904 # 1388 <main.c.5cfd7a5a+0xa0e>
10000226:	cc04                	sw	s1,24(s0)
		pre_tick = cur_tick;
10000228:	d078                	sw	a4,100(s0)
1000022a:	35c5                	jal	1000010a <hal_clock_time_exceed>
1000022c:	cd69                	beqz	a0,10000306 <main+0x198>
            key_scan_timer = hal_clock_get_system_tick();
1000022e:	100026b7          	lui	a3,0x10002
10000232:	c0468693          	addi	a3,a3,-1020 # 10001c04 <output_pin>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
10000236:	40010737          	lui	a4,0x40010
1000023a:	d424                	sw	s1,104(s0)
1000023c:	06042623          	sw	zero,108(s0)
{
    uint32_t scaned_key = 0x0;
    uint32_t gpio_state = 0;

    // 矩阵扫描
    for (uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
10000240:	01868313          	addi	t1,a3,24
    uint32_t scaned_key = 0x0;
10000244:	4781                	li	a5,0
        // 输出口依次置低
        gpio_write((1 << output_pin[i]), GPIO_LOW);
10000246:	4285                	li	t0,1
10000248:	0741                	addi	a4,a4,16 # 40010010 <__StackTop+0x2000c010>
1000024a:	4290                	lw	a2,0(a3)
1000024c:	5b08                	lw	a0,48(a4)
1000024e:	00c29633          	sll	a2,t0,a2
10000252:	fff64593          	not	a1,a2
10000256:	8de9                	and	a1,a1,a0
10000258:	db0c                	sw	a1,48(a4)

        // 小延时，确保电平稳定
        for (volatile int d = 0; d < 20; d++)
1000025a:	c402                	sw	zero,8(sp)
1000025c:	45a2                	lw	a1,8(sp)
1000025e:	454d                	li	a0,19
10000260:	14b55763          	bge	a0,a1,100003ae <main+0x240>
 * @brief Read entire GPIO input register
 * @return uint32_t Current state of all GPIO inputs (bitmask)
 */
uint32_t gpio_read(void)
{
	return GPIO_INOUT->GPIO_I;
10000264:	01072383          	lw	t2,16(a4)

        // 读取所有GPIO状态
        gpio_state = gpio_read();

        // 检查所有输入口
        for (uint8_t j = 0; j < INPUT_PIN_NUM; j++) {
10000268:	851a                	mv	a0,t1
            // 检测对应输入口是否为低电平（按键按下）
            if ((gpio_state & (1 << input_pin[j])) == 0) {
1000026a:	410c                	lw	a1,0(a0)
1000026c:	00b295b3          	sll	a1,t0,a1
10000270:	0075f4b3          	and	s1,a1,t2
10000274:	e099                	bnez	s1,1000027a <main+0x10c>
                scaned_key |= ((1 << output_pin[i]) | (1 << input_pin[j]));
10000276:	8dd1                	or	a1,a1,a2
10000278:	8fcd                	or	a5,a5,a1
        for (uint8_t j = 0; j < INPUT_PIN_NUM; j++) {
1000027a:	100025b7          	lui	a1,0x10002
1000027e:	0511                	addi	a0,a0,4
10000280:	c2c58593          	addi	a1,a1,-980 # 10001c2c <keys_func_table>
10000284:	fea593e3          	bne	a1,a0,1000026a <main+0xfc>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
10000288:	5b0c                	lw	a1,48(a4)
    for (uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
1000028a:	0691                	addi	a3,a3,4
1000028c:	8e4d                	or	a2,a2,a1
1000028e:	db10                	sw	a2,48(a4)
10000290:	fad31de3          	bne	t1,a3,1000024a <main+0xdc>
10000294:	5b14                	lw	a3,48(a4)
10000296:	6621                	lui	a2,0x8
10000298:	1c360613          	addi	a2,a2,451 # 81c3 <ble_viot.c.e415c280+0x2b5d>
1000029c:	8ed1                	or	a3,a3,a2
1000029e:	db14                	sw	a3,48(a4)

    // 设置所有输出口为高电平
    gpio_write(all_output_bits, GPIO_HIGH);

    // 小延时，确保电平稳定
    for (volatile int d = 0; d < 20; d++)
100002a0:	c202                	sw	zero,4(sp)
100002a2:	46cd                	li	a3,19
100002a4:	4712                	lw	a4,4(sp)
100002a6:	10e6d863          	bge	a3,a4,100003b6 <main+0x248>
	return GPIO_INOUT->GPIO_I;
100002aa:	40010737          	lui	a4,0x40010
100002ae:	0741                	addi	a4,a4,16 # 40010010 <__StackTop+0x2000c010>
100002b0:	4b18                	lw	a4,16(a4)
    // 读取GPIO状态
    gpio_state = gpio_read();

    // 检查所有输入口，如果为低则表示连接到GND
    for (uint8_t j = 0; j < INPUT_PIN_NUM; j++) {
        if ((gpio_state & (1 << input_pin[j])) == 0) {
100002b2:	00a71693          	slli	a3,a4,0xa
100002b6:	1006d463          	bgez	a3,100003be <main+0x250>
100002ba:	00b71693          	slli	a3,a4,0xb
100002be:	1006d363          	bgez	a3,100003c4 <main+0x256>
100002c2:	00c71693          	slli	a3,a4,0xc
100002c6:	1006d263          	bgez	a3,100003ca <main+0x25c>
100002ca:	00d71693          	slli	a3,a4,0xd
100002ce:	1006c163          	bltz	a3,100003d0 <main+0x262>
100002d2:	000407b7          	lui	a5,0x40
            // 输入口为低，表示GND按键按下
            // 注意：GND按键应该单独存在，不与矩阵扫描结果混合
            scaned_key = (GNDB | (1 << input_pin[j]));
100002d6:	00400737          	lui	a4,0x400
100002da:	8fd9                	or	a5,a5,a4
            break; // 找到一个GND按键就退出，避免多个GND按键同时触发
        }
    }

    key_info.curr_key = scaned_key;
100002dc:	c83c                	sw	a5,80(s0)

    // 设置按键活动标志
    if (scaned_key != 0) {
        key_activity_flag = 1; // 检测到按键按下
100002de:	4685                	li	a3,1
100002e0:	06d40823          	sb	a3,112(s0)
    }

    key_info.curr_key = scaned_key;
100002e4:	c83c                	sw	a5,80(s0)
    if (scaned_key && key_info.curr_key == key_info.last_key) {
100002e6:	4830                	lw	a2,80(s0)
100002e8:	4878                	lw	a4,84(s0)
100002ea:	0ee61863          	bne	a2,a4,100003da <main+0x26c>
        // 按键按下
        key_info.pressed_time += 5; // 每次按键按下时累加5ms
100002ee:	4c78                	lw	a4,92(s0)
100002f0:	0715                	addi	a4,a4,5 # 400005 <__ROM_SIZE+0x3c0005>
100002f2:	cc78                	sw	a4,92(s0)
        key_info.handle_flag = 0x01;
100002f4:	04d40da3          	sb	a3,91(s0)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
100002f8:	40010737          	lui	a4,0x40010
100002fc:	4334                	lw	a3,64(a4)
100002fe:	2006e693          	ori	a3,a3,512
10000302:	c334                	sw	a3,64(a4)
            gpio_write((1 << SINGLE_LED_GPIO), GPIO_LOW);
        }
    }
#endif

    key_info.last_key = scaned_key;
10000304:	c87c                	sw	a5,84(s0)
    if(send_packet_request == 0 || packet_tx_count == 0) {
10000306:	01c44783          	lbu	a5,28(s0)
1000030a:	c3b1                	beqz	a5,1000034e <main+0x1e0>
1000030c:	01e45783          	lhu	a5,30(s0)
10000310:	cf9d                	beqz	a5,1000034e <main+0x1e0>
    if(last_send_time == 0 || hal_clock_time_exceed(last_send_time, send_interval_us)) {
10000312:	5008                	lw	a0,32(s0)
10000314:	504c                	lw	a1,36(s0)
10000316:	00b567b3          	or	a5,a0,a1
1000031a:	c789                	beqz	a5,10000324 <main+0x1b6>
1000031c:	07245603          	lhu	a2,114(s0)
10000320:	33ed                	jal	1000010a <hal_clock_time_exceed>
10000322:	c515                	beqz	a0,1000034e <main+0x1e0>
        rf_2g4_tx_data(packet_buffer, packet_len, RF_CH37);
10000324:	07444583          	lbu	a1,116(s0)
10000328:	4601                	li	a2,0
1000032a:	02840513          	addi	a0,s0,40
    return _u32_tick;
1000032e:	4c04                	lw	s1,24(s0)
10000330:	5e4010ef          	jal	10001914 <rf_2g4_tx_data>
        packet_tx_count--;
10000334:	01e45783          	lhu	a5,30(s0)
    uint64_t current_time = hal_clock_get_system_tick();
10000338:	d004                	sw	s1,32(s0)
1000033a:	02042223          	sw	zero,36(s0)
        packet_tx_count--;
1000033e:	17fd                	addi	a5,a5,-1 # 3ffff <ble_viot.c.e415c280+0x3a999>
10000340:	07c2                	slli	a5,a5,0x10
10000342:	83c1                	srli	a5,a5,0x10
10000344:	00f41f23          	sh	a5,30(s0)
        if(packet_tx_count == 0) {
10000348:	e399                	bnez	a5,1000034e <main+0x1e0>
            send_packet_request = 0;
1000034a:	00040e23          	sb	zero,28(s0)

        /* ========== BLE数据包发送处理 ========== */
        ble_adv_process(); // 在主循环中处理发包

        // ========== 看门狗喂狗（100ms） ==========
        if (hal_clock_time_exceed(watch_dog_T, 100 * 1000)) {
1000034e:	5c28                	lw	a0,120(s0)
10000350:	5c6c                	lw	a1,124(s0)
10000352:	6661                	lui	a2,0x18
10000354:	6a060613          	addi	a2,a2,1696 # 186a0 <ble_viot.c.e415c280+0x1303a>
10000358:	3b4d                	jal	1000010a <hal_clock_time_exceed>
1000035a:	c919                	beqz	a0,10000370 <main+0x202>
            watch_dog_T = hal_clock_get_system_tick();
1000035c:	4c1c                	lw	a5,24(s0)
1000035e:	06042e23          	sw	zero,124(s0)
            WDT_FEED();
10000362:	0d800713          	li	a4,216
            watch_dog_T = hal_clock_get_system_tick();
10000366:	dc3c                	sw	a5,120(s0)
            WDT_FEED();
10000368:	400007b7          	lui	a5,0x40000
1000036c:	10e7a023          	sw	a4,256(a5) # 40000100 <__StackTop+0x1fffc100>
        }

        /* ========== 按键处理 ========== */
        // 按键扫描在主循环中完成，此处响应按键事件
        if (key_info.handle_flag) {
10000370:	05b44783          	lbu	a5,91(s0)
10000374:	c3c9                	beqz	a5,100003f6 <main+0x288>

            key_process(key_info.curr_key, key_info.pressed_time);
10000376:	100027b7          	lui	a5,0x10002
1000037a:	05042303          	lw	t1,80(s0)
1000037e:	c0478793          	addi	a5,a5,-1020 # 10001c04 <output_pin>
10000382:	4c74                	lw	a3,92(s0)
void key_process(uint32_t key_value, uint32_t press_time)
{
    str_key_fun *p_key_fun = NULL;

    // 查找匹配的按键配置
    for (uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i) {
10000384:	02878593          	addi	a1,a5,40
10000388:	4701                	li	a4,0
1000038a:	862e                	mv	a2,a1
1000038c:	4571                	li	a0,28
        if (key_value == keys_func_table[i].key_value) {
1000038e:	0005a283          	lw	t0,0(a1)
10000392:	04531c63          	bne	t1,t0,100003ea <main+0x27c>
    if (p_key_fun == NULL) {
        log_printf("No matching key found for 0x%08X\n", key_value);
        return;
    }

    if (press_time >= STOP_PRESS_THRESHOLD) {
10000396:	65bd                	lui	a1,0xf
10000398:	a5f58593          	addi	a1,a1,-1441 # ea5f <ble_viot.c.e415c280+0x93f9>
1000039c:	12d5f563          	bgeu	a1,a3,100004c6 <main+0x358>
100003a0:	400107b7          	lui	a5,0x40010
100003a4:	43b8                	lw	a4,64(a5)
100003a6:	dff77713          	andi	a4,a4,-513
100003aa:	c3b8                	sw	a4,64(a5)
}
100003ac:	a099                	j	100003f2 <main+0x284>
        for (volatile int d = 0; d < 20; d++)
100003ae:	45a2                	lw	a1,8(sp)
100003b0:	0585                	addi	a1,a1,1
100003b2:	c42e                	sw	a1,8(sp)
100003b4:	b565                	j	1000025c <main+0xee>
    for (volatile int d = 0; d < 20; d++)
100003b6:	4712                	lw	a4,4(sp)
100003b8:	0705                	addi	a4,a4,1 # 40010001 <__StackTop+0x2000c001>
100003ba:	c23a                	sw	a4,4(sp)
100003bc:	b5e5                	j	100002a4 <main+0x136>
        if ((gpio_state & (1 << input_pin[j])) == 0) {
100003be:	002007b7          	lui	a5,0x200
100003c2:	bf11                	j	100002d6 <main+0x168>
100003c4:	001007b7          	lui	a5,0x100
100003c8:	b739                	j	100002d6 <main+0x168>
100003ca:	000807b7          	lui	a5,0x80
100003ce:	b721                	j	100002d6 <main+0x168>
    key_info.curr_key = scaned_key;
100003d0:	c83c                	sw	a5,80(s0)
    if (scaned_key != 0) {
100003d2:	f00796e3          	bnez	a5,100002de <main+0x170>
    key_info.curr_key = scaned_key;
100003d6:	04042823          	sw	zero,80(s0)
        key_info.pressed_time = 0x00;
100003da:	04042e23          	sw	zero,92(s0)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
100003de:	40010737          	lui	a4,0x40010
100003e2:	4334                	lw	a3,64(a4)
100003e4:	dff6f693          	andi	a3,a3,-513
100003e8:	bf29                	j	10000302 <main+0x194>
    for (uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i) {
100003ea:	0705                	addi	a4,a4,1 # 40010001 <__StackTop+0x2000c001>
100003ec:	05f1                	addi	a1,a1,28
100003ee:	faa710e3          	bne	a4,a0,1000038e <main+0x220>
            key_info.handle_flag = 0x00;
100003f2:	04040da3          	sb	zero,91(s0)
        }

        /* ========== 休眠检查（50ms周期）========== */
        if (hal_clock_time_exceed(sleep_check_timer, 50 * 1000)) {
100003f6:	08842503          	lw	a0,136(s0)
100003fa:	08c42583          	lw	a1,140(s0)
100003fe:	6631                	lui	a2,0xc
10000400:	35060613          	addi	a2,a2,848 # c350 <ble_viot.c.e415c280+0x6cea>
10000404:	3319                	jal	1000010a <hal_clock_time_exceed>
10000406:	de050ee3          	beqz	a0,10000202 <main+0x94>
            sleep_check_timer = hal_clock_get_system_tick();
1000040a:	4c1c                	lw	a5,24(s0)
1000040c:	08042623          	sw	zero,140(s0)
10000410:	08f42423          	sw	a5,136(s0)

            // 检查按键活动标志
            if (key_activity_flag == 0) {
10000414:	07044783          	lbu	a5,112(s0)
10000418:	1e079063          	bnez	a5,100005f8 <main+0x48a>
                // 无按键活动，计数增加
                no_keypress_50ms_cnt++;
1000041c:	09045783          	lhu	a5,144(s0)
10000420:	0785                	addi	a5,a5,1 # 80001 <__ROM_SIZE+0x40001>
10000422:	07c2                	slli	a5,a5,0x10
10000424:	83c1                	srli	a5,a5,0x10
10000426:	08f41823          	sh	a5,144(s0)
                if (no_keypress_50ms_cnt >= 100) { // 5秒无操作
1000042a:	09045703          	lhu	a4,144(s0)
1000042e:	06300793          	li	a5,99
10000432:	dce7f8e3          	bgeu	a5,a4,10000202 <main+0x94>
10000436:	400107b7          	lui	a5,0x40010
                    log_printf("Ready to sleep (no action for 5s)\n");
                    no_keypress_50ms_cnt = 0;
1000043a:	08041823          	sh	zero,144(s0)
1000043e:	43b8                	lw	a4,64(a5)
10000440:	76e1                	lui	a3,0xffff8
10000442:	e3c68693          	addi	a3,a3,-452 # ffff7e3c <__StackTop+0xdfff3e3c>
10000446:	8f75                	and	a4,a4,a3
10000448:	c3b8                	sw	a4,64(a5)
 *                   (active-low wake-up)
 */
void config_wakeup_gpio(uint32_t gpio_mask, uint8_t is_n_wakeup)
{
    /* Remove specified GPIOs from sleep unused mask to keep them active during sleep */
    unused_gpio_mask_when_sleep &= ~gpio_mask;
1000044a:	200016b7          	lui	a3,0x20001
1000044e:	56c6a783          	lw	a5,1388(a3) # 2000156c <unused_gpio_mask_when_sleep>
10000452:	ffc40737          	lui	a4,0xffc40
10000456:	177d                	addi	a4,a4,-1 # ffc3ffff <__StackTop+0xdfc3bfff>
10000458:	8ff9                	and	a5,a5,a4
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1000045a:	40010737          	lui	a4,0x40010
    unused_gpio_mask_when_sleep &= ~gpio_mask;
1000045e:	56f6a623          	sw	a5,1388(a3)
    uint32_t func_val = is_n_wakeup ? 0x20 : 0x40;
    /* Iterate through all possible GPIO bits (0-23) to configure masked pins */
    for (int i = 0; i < 24; i++)
    {
        if ((gpio_mask >> i) & 0x1)
10000462:	003c05b7          	lui	a1,0x3c0
    for (int i = 0; i < 24; i++)
10000466:	4781                	li	a5,0
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
10000468:	20070713          	addi	a4,a4,512 # 40010200 <__StackTop+0x2000c200>
1000046c:	02000513          	li	a0,32
    for (int i = 0; i < 24; i++)
10000470:	4661                	li	a2,24
        if ((gpio_mask >> i) & 0x1)
10000472:	00f5d6b3          	srl	a3,a1,a5
10000476:	8a85                	andi	a3,a3,1
10000478:	c689                	beqz	a3,10000482 <main+0x314>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1000047a:	00e786b3          	add	a3,a5,a4
1000047e:	00a68023          	sb	a0,0(a3)
    for (int i = 0; i < 24; i++)
10000482:	0785                	addi	a5,a5,1 # 40010001 <__StackTop+0x2000c001>
10000484:	fec797e3          	bne	a5,a2,10000472 <main+0x304>
    {
        AON_CTRL->WAKEUP_CTRL0 = gpio_mask;  // Active-high wake-up configuration
    }
    else
    {
        AON_CTRL->WAKEUP_CTRL1 = gpio_mask;  // Active-low wake-up configuration
10000488:	003c07b7          	lui	a5,0x3c0
1000048c:	400804b7          	lui	s1,0x40080
10000490:	c8dc                	sw	a5,20(s1)
                    config_wakeup_gpio(wakeup_gpio_bits, 1);

                    log_printf("Enter sleep mode\n");

                    // ========== 4. 进入睡眠 ==========
                    enter_sleep_mode();
10000492:	5b6010ef          	jal	10001a48 <enter_sleep_mode>

                    // ========== 5. 唤醒后初始化 ==========
                    log_printf("\n=== Wakeup from sleep ===\n");
                    log_printf("Wakeup IO: 0x%x\n", AON_CTRL->WAKEUP_RECORD);
10000496:	4cdc                	lw	a5,28(s1)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
10000498:	66a1                	lui	a3,0x8
1000049a:	400107b7          	lui	a5,0x40010
1000049e:	43b8                	lw	a4,64(a5)
100004a0:	1c368693          	addi	a3,a3,451 # 81c3 <ble_viot.c.e415c280+0x2b5d>
100004a4:	8f55                	or	a4,a4,a3
100004a6:	c3b8                	sw	a4,64(a5)

                    // 5.1 恢复输出口
                    gpio_write(output_bits, GPIO_HIGH);

                    // 5.2 重新初始化BLE广播发送
                    ble_adv_timer_init();
100004a8:	3145                	jal	10000148 <ble_adv_timer_init>

                    // 5.3 重置时钟计数器
                    watch_dog_T = hal_clock_get_system_tick();
100004aa:	4c1c                	lw	a5,24(s0)
100004ac:	06042e23          	sw	zero,124(s0)
                    key_scan_timer = hal_clock_get_system_tick();
100004b0:	06042623          	sw	zero,108(s0)
                    watch_dog_T = hal_clock_get_system_tick();
100004b4:	dc3c                	sw	a5,120(s0)
                    key_scan_timer = hal_clock_get_system_tick();
100004b6:	d43c                	sw	a5,104(s0)
                    sleep_check_timer = hal_clock_get_system_tick();
100004b8:	08f42423          	sw	a5,136(s0)
100004bc:	08042623          	sw	zero,140(s0)
                    log_printf("=== System resumed ===\n\n");
                }
            } else {
                // 有按键活动，重置计数和标志
                no_keypress_50ms_cnt = 0;
                key_activity_flag = 0;
100004c0:	06040823          	sb	zero,112(s0)
100004c4:	bb3d                	j	10000202 <main+0x94>
        // 如果到了长按的截止时间，关闭LED，表示不发送信号

        // 熄灭指示灯
        gpio_write((1UL << SINGLE_LED_GPIO), GPIO_LOW);
        return;
    } else if (press_time >= LONG_PRESS_THRESHOLD) {
100004c6:	04500593          	li	a1,69
100004ca:	10d5fc63          	bgeu	a1,a3,100005e2 <main+0x474>
        // check whether continuous transmission is required

        // pack packet only when it's pack interval
        if (0x00 ==
            ((press_time - LONG_PRESS_THRESHOLD) % SEND_BEACON_MAX_TIMES)) {
100004ce:	fba68693          	addi	a3,a3,-70
100004d2:	04600593          	li	a1,70
100004d6:	02b6f6b3          	remu	a3,a3,a1
        if (0x00 ==
100004da:	fe81                	bnez	a3,100003f2 <main+0x284>
            p_key_fun->long_press_handler((str_fun_para *)&p_key_fun->long_press_para);
100004dc:	44f1                	li	s1,28
100004de:	029704b3          	mul	s1,a4,s1
100004e2:	97a6                	add	a5,a5,s1
100004e4:	5f98                	lw	a4,56(a5)
100004e6:	01448513          	addi	a0,s1,20 # 40080014 <__StackTop+0x2007c014>
100004ea:	9532                	add	a0,a0,a2
100004ec:	c03e                	sw	a5,0(sp)
100004ee:	9702                	jalr	a4
        } else {
            return;
        }

        p_key_fun->short_press_handler((str_fun_para *)&p_key_fun->short_press_para);
100004f0:	4782                	lw	a5,0(sp)
100004f2:	10002737          	lui	a4,0x10002
100004f6:	00848513          	addi	a0,s1,8
100004fa:	57dc                	lw	a5,44(a5)
100004fc:	c2c70613          	addi	a2,a4,-980 # 10001c2c <keys_func_table>
        goto send_adv_label;
    } else if (press_time == SHORT_PRESS_THRESHOLD) {
        // 短按
        // 将键值写入
        p_key_fun->short_press_handler((str_fun_para *)&p_key_fun->short_press_para);
10000500:	9532                	add	a0,a0,a2
10000502:	9782                	jalr	a5
    uint8_t encoded_data[31];  // VIOT编码后的31字节payload
    uint8_t encoded_data_len;
    uint8_t index = 0x0;       // 广播索引
    uint8_t* group_index = &ret_mem_data.current_group_index;
    uint16_t rand_seed = ret_mem_data.rand_seed;
    uint16_t tx_count = ret_mem_data.tx_count++;
10000504:	08245483          	lhu	s1,130(s0)
	return crc16;
}

uint8_t ble_viot_encoder(str_ble_viot_para* opcode_para,uint8_t rand_seed,uint8_t* out_data,uint8_t* out_data_len)
{
	uint8_t ble_payload[BLE_ADV_PDU_MAX_LENGTH] = {0x0};
10000508:	467d                	li	a2,31
1000050a:	4581                	li	a1,0
1000050c:	00148793          	addi	a5,s1,1
10000510:	08f41123          	sh	a5,130(s0)
    
    // 验证group_index，如果越界则重置为0
    *group_index = (*group_index > GROUP_INDEX_MAX) ? 0x00 : *group_index;
10000514:	08144783          	lbu	a5,129(s0)
10000518:	1068                	addi	a0,sp,44
1000051a:	0057b713          	sltiu	a4,a5,5
1000051e:	40e00733          	neg	a4,a4
10000522:	8ff9                	and	a5,a5,a4
10000524:	06045703          	lhu	a4,96(s0)
10000528:	08f400a3          	sb	a5,129(s0)
1000052c:	c03a                	sw	a4,0(sp)
1000052e:	6c2010ef          	jal	10001bf0 <memset>
	*p_ble_payload++ = 0x1D;
	*p_ble_payload++ = 0x1E;

	//copy the encoded data to out buffer
	*out_data_len = BLE_ADV_PDU_MAX_LENGTH;
	memcpy(out_data,ble_payload,BLE_ADV_PDU_MAX_LENGTH);
10000532:	1b0207b7          	lui	a5,0x1b020
10000536:	10278793          	addi	a5,a5,258 # 1b020102 <__etext+0xb01e15a>
1000053a:	d63e                	sw	a5,44(sp)
1000053c:	77f9                	lui	a5,0xffffe
1000053e:	c0378793          	addi	a5,a5,-1021 # ffffdc03 <__StackTop+0xdfff9c03>
10000542:	02f11823          	sh	a5,48(sp)
10000546:	fdc00793          	li	a5,-36
1000054a:	02f10923          	sb	a5,50(sp)
1000054e:	fc300793          	li	a5,-61
10000552:	02f10b23          	sb	a5,54(sp)
10000556:	181717b7          	lui	a5,0x18171
1000055a:	6c378793          	addi	a5,a5,1731 # 181716c3 <__etext+0x816f71b>
1000055e:	dc3e                	sw	a5,56(sp)
10000560:	1c1b27b7          	lui	a5,0x1c1b2
10000564:	4702                	lw	a4,0(sp)
	*p_ble_payload++ = (uint8_t)opcode_para->para[0];
10000566:	01244683          	lbu	a3,18(s0)
	memcpy(out_data,ble_payload,BLE_ADV_PDU_MAX_LENGTH);
1000056a:	a1978793          	addi	a5,a5,-1511 # 1c1b1a19 <__etext+0xc1afa71>
1000056e:	de3e                	sw	a5,60(sp)
10000570:	6789                	lui	a5,0x2
10000572:	e1d78793          	addi	a5,a5,-483 # 1e1d <main.c.5cfd7a5a+0x14a3>
10000576:	106c                	addi	a1,sp,44
10000578:	467d                	li	a2,31
1000057a:	0068                	addi	a0,sp,12
1000057c:	02e11a23          	sh	a4,52(sp)
10000580:	02d109a3          	sb	a3,51(sp)
10000584:	04f11023          	sh	a5,64(sp)
    
    // 填充VIOT参数
    ble_viot_para.relay = 0x54;           // 固定值
    ble_viot_para.type = 0x00;            // 类型
    ble_viot_para.version = 0x00;         // 版本
    ble_viot_para.count = tx_count;       // 递增计数
10000588:	02910ba3          	sb	s1,55(sp)
1000058c:	64c010ef          	jal	10001bd8 <memcpy>
    packet_len = 8 + data_len;  // 2字节头部 + 6字节MAC + 数据长度
10000590:	02700793          	li	a5,39
10000594:	06f40a23          	sb	a5,116(s0)
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
10000598:	221127b7          	lui	a5,0x22112
1000059c:	54278793          	addi	a5,a5,1346 # 22112542 <__StackTop+0x210e542>
100005a0:	d41c                	sw	a5,40(s0)
100005a2:	665547b7          	lui	a5,0x66554
100005a6:	43378793          	addi	a5,a5,1075 # 66554433 <__StackTop+0x46550433>
    memcpy(&packet_buffer[8], data, data_len);
100005aa:	006c                	addi	a1,sp,12
100005ac:	467d                	li	a2,31
100005ae:	03040513          	addi	a0,s0,48
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
100005b2:	d45c                	sw	a5,44(s0)
    memcpy(&packet_buffer[8], data, data_len);
100005b4:	624010ef          	jal	10001bd8 <memcpy>
    packet_tx_count = tx_num;
100005b8:	04600793          	li	a5,70
100005bc:	00f41f23          	sh	a5,30(s0)
    send_interval_us = interval_ms * 1000;  // 转换为微秒
100005c0:	3e800793          	li	a5,1000
100005c4:	06f41923          	sh	a5,114(s0)
    last_send_time = 0;
100005c8:	4781                	li	a5,0
100005ca:	4701                	li	a4,0
100005cc:	d05c                	sw	a5,36(s0)
    
    // 发送编码后的数据包
    ble_adv_send(index, encoded_data, encoded_data_len, SEND_BEACON_MAX_TIMES, SEND_BEACON_INTERVAL, SEND_BEACON_CHANNEL);
    
    // 清空参数
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
100005ce:	4661                	li	a2,24
    send_packet_request = 1;
100005d0:	4785                	li	a5,1
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
100005d2:	4581                	li	a1,0
100005d4:	8522                	mv	a0,s0
    last_send_time = 0;
100005d6:	d018                	sw	a4,32(s0)
    send_packet_request = 1;
100005d8:	00f40e23          	sb	a5,28(s0)
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
100005dc:	614010ef          	jal	10001bf0 <memset>
    
    return ret;
100005e0:	bd09                	j	100003f2 <main+0x284>
    } else if (press_time == SHORT_PRESS_THRESHOLD) {
100005e2:	4595                	li	a1,5
100005e4:	e0b697e3          	bne	a3,a1,100003f2 <main+0x284>
        p_key_fun->short_press_handler((str_fun_para *)&p_key_fun->short_press_para);
100005e8:	46f1                	li	a3,28
100005ea:	02d70733          	mul	a4,a4,a3
100005ee:	97ba                	add	a5,a5,a4
100005f0:	57dc                	lw	a5,44(a5)
100005f2:	00870513          	addi	a0,a4,8
100005f6:	b729                	j	10000500 <main+0x392>
                no_keypress_50ms_cnt = 0;
100005f8:	08041823          	sh	zero,144(s0)
100005fc:	b5d1                	j	100004c0 <main+0x352>

100005fe <Default_Handler>:
100005fe:	400007b7          	lui	a5,0x40000
10000602:	0f800713          	li	a4,248
10000606:	10e7a023          	sw	a4,256(a5) # 40000100 <__StackTop+0x1fffc100>
1000060a:	a001                	j	1000060a <Default_Handler+0xc>

1000060c <clic_init>:
1000060c:	e0800737          	lui	a4,0xe0800
10000610:	435c                	lw	a5,4(a4)
10000612:	83d1                	srli	a5,a5,0x14
10000614:	8bf9                	andi	a5,a5,30
10000616:	00f70023          	sb	a5,0(a4) # e0800000 <__StackTop+0xc07fc000>
1000061a:	4701                	li	a4,0
1000061c:	e0800537          	lui	a0,0xe0800
10000620:	6585                	lui	a1,0x1
10000622:	4685                	li	a3,1
10000624:	03000613          	li	a2,48
10000628:	00271793          	slli	a5,a4,0x2
1000062c:	97aa                	add	a5,a5,a0
1000062e:	97ae                	add	a5,a5,a1
10000630:	00d78023          	sb	a3,0(a5)
10000634:	000780a3          	sb	zero,1(a5)
10000638:	00d78123          	sb	a3,2(a5)
1000063c:	0705                	addi	a4,a4,1
1000063e:	fec715e3          	bne	a4,a2,10000628 <clic_init+0x1c>
10000642:	8082                	ret

10000644 <t1100_rom_init>:
10000644:	8082                	ret

10000646 <ram_init>:
10000646:	1171                	addi	sp,sp,-4
10000648:	c006                	sw	ra,0(sp)
1000064a:	10002737          	lui	a4,0x10002
1000064e:	f9470713          	addi	a4,a4,-108 # 10001f94 <__exidx_end>
10000652:	100027b7          	lui	a5,0x10002
10000656:	fa078793          	addi	a5,a5,-96 # 10001fa0 <__copy_table_end__>
1000065a:	86ba                	mv	a3,a4
1000065c:	853e                	mv	a0,a5
1000065e:	04f76563          	bltu	a4,a5,100006a8 <ram_init+0x62>
10000662:	10002737          	lui	a4,0x10002
10000666:	fa070713          	addi	a4,a4,-96 # 10001fa0 <__copy_table_end__>
1000066a:	100027b7          	lui	a5,0x10002
1000066e:	fa878793          	addi	a5,a5,-88 # 10001fa8 <__etext>
10000672:	06f77063          	bgeu	a4,a5,100006d2 <ram_init+0x8c>
10000676:	86ba                	mv	a3,a4
10000678:	100025b7          	lui	a1,0x10002
1000067c:	fa758593          	addi	a1,a1,-89 # 10001fa7 <__copy_table_end__+0x7>
10000680:	8d99                	sub	a1,a1,a4
10000682:	99e1                	andi	a1,a1,-8
10000684:	05a1                	addi	a1,a1,8
10000686:	95ba                	add	a1,a1,a4
10000688:	a089                	j	100006ca <ram_init+0x84>
1000068a:	00279613          	slli	a2,a5,0x2
1000068e:	4298                	lw	a4,0(a3)
10000690:	9732                	add	a4,a4,a2
10000692:	430c                	lw	a1,0(a4)
10000694:	42d8                	lw	a4,4(a3)
10000696:	9732                	add	a4,a4,a2
10000698:	c30c                	sw	a1,0(a4)
1000069a:	0785                	addi	a5,a5,1
1000069c:	4698                	lw	a4,8(a3)
1000069e:	fee7e6e3          	bltu	a5,a4,1000068a <ram_init+0x44>
100006a2:	06b1                	addi	a3,a3,12
100006a4:	faa6ffe3          	bgeu	a3,a0,10000662 <ram_init+0x1c>
100006a8:	4698                	lw	a4,8(a3)
100006aa:	4781                	li	a5,0
100006ac:	ff79                	bnez	a4,1000068a <ram_init+0x44>
100006ae:	bfd5                	j	100006a2 <ram_init+0x5c>
100006b0:	4298                	lw	a4,0(a3)
100006b2:	00279613          	slli	a2,a5,0x2
100006b6:	9732                	add	a4,a4,a2
100006b8:	00072023          	sw	zero,0(a4)
100006bc:	0785                	addi	a5,a5,1
100006be:	42d8                	lw	a4,4(a3)
100006c0:	fee7e8e3          	bltu	a5,a4,100006b0 <ram_init+0x6a>
100006c4:	06a1                	addi	a3,a3,8
100006c6:	00b68663          	beq	a3,a1,100006d2 <ram_init+0x8c>
100006ca:	42d8                	lw	a4,4(a3)
100006cc:	4781                	li	a5,0
100006ce:	f36d                	bnez	a4,100006b0 <ram_init+0x6a>
100006d0:	bfd5                	j	100006c4 <ram_init+0x7e>
100006d2:	3f8d                	jal	10000644 <t1100_rom_init>
100006d4:	4082                	lw	ra,0(sp)
100006d6:	0111                	addi	sp,sp,4
100006d8:	8082                	ret

100006da <sys_entry>:
100006da:	400007b7          	lui	a5,0x40000
100006de:	4398                	lw	a4,0(a5)
100006e0:	6785                	lui	a5,0x1
100006e2:	10178793          	addi	a5,a5,257 # 1101 <main.c.5cfd7a5a+0x787>
100006e6:	00f70363          	beq	a4,a5,100006ec <sys_entry+0x12>
100006ea:	8082                	ret
100006ec:	1141                	addi	sp,sp,-16
100006ee:	c606                	sw	ra,12(sp)
100006f0:	c422                	sw	s0,8(sp)
100006f2:	c226                	sw	s1,4(sp)
100006f4:	3f89                	jal	10000646 <ram_init>
100006f6:	3f19                	jal	1000060c <clic_init>
100006f8:	40080437          	lui	s0,0x40080
100006fc:	4785                	li	a5,1
100006fe:	c83c                	sw	a5,80(s0)
10000700:	42000737          	lui	a4,0x42000
10000704:	6785                	lui	a5,0x1
10000706:	70178793          	addi	a5,a5,1793 # 1701 <main.c.5cfd7a5a+0xd87>
1000070a:	10f72023          	sw	a5,256(a4) # 42000100 <__StackTop+0x21ffc100>
1000070e:	2051                	jal	10000792 <otp_load_cfg>
10000710:	218d                	jal	10000b72 <otp_apply_cfg>
10000712:	30d000ef          	jal	1000121e <PMU_OnChip_Init>
10000716:	400004b7          	lui	s1,0x40000
1000071a:	50dc                	lw	a5,36(s1)
1000071c:	001007b7          	lui	a5,0x100
10000720:	40078793          	addi	a5,a5,1024 # 100400 <__ROM_SIZE+0xc0400>
10000724:	d0dc                	sw	a5,36(s1)
10000726:	42002737          	lui	a4,0x42002
1000072a:	431c                	lw	a5,0(a4)
1000072c:	9bf5                	andi	a5,a5,-3
1000072e:	c31c                	sw	a5,0(a4)
10000730:	11042783          	lw	a5,272(s0) # 40080110 <__StackTop+0x2007c110>
10000734:	6721                	lui	a4,0x8
10000736:	80070713          	addi	a4,a4,-2048 # 7800 <ble_viot.c.e415c280+0x219a>
1000073a:	8fd9                	or	a5,a5,a4
1000073c:	10f42823          	sw	a5,272(s0)
10000740:	00fcd537          	lui	a0,0xfcd
10000744:	bff50513          	addi	a0,a0,-1025 # fccbff <__ROM_SIZE+0xf8cbff>
10000748:	10000097          	auipc	ra,0x10000
1000074c:	d9e080e7          	jalr	-610(ra) # 200004e6 <poweron_unused_gpio_mask_parse_and_set>
10000750:	12044783          	lbu	a5,288(s0)
10000754:	0047e793          	ori	a5,a5,4
10000758:	12f40023          	sb	a5,288(s0)
1000075c:	40000793          	li	a5,1024
10000760:	c49c                	sw	a5,8(s1)
10000762:	c002                	sw	zero,0(sp)
10000764:	4702                	lw	a4,0(sp)
10000766:	47a5                	li	a5,9
10000768:	00e7c963          	blt	a5,a4,1000077a <sys_entry+0xa0>
1000076c:	873e                	mv	a4,a5
1000076e:	4782                	lw	a5,0(sp)
10000770:	0785                	addi	a5,a5,1
10000772:	c03e                	sw	a5,0(sp)
10000774:	4782                	lw	a5,0(sp)
10000776:	fef75ce3          	bge	a4,a5,1000076e <sys_entry+0x94>
1000077a:	400007b7          	lui	a5,0x40000
1000077e:	0007a423          	sw	zero,8(a5) # 40000008 <__StackTop+0x1fffc008>
10000782:	300467f3          	csrrsi	a5,mstatus,8
10000786:	32e5                	jal	1000016e <main>
10000788:	40b2                	lw	ra,12(sp)
1000078a:	4422                	lw	s0,8(sp)
1000078c:	4492                	lw	s1,4(sp)
1000078e:	0141                	addi	sp,sp,16
10000790:	8082                	ret

10000792 <otp_load_cfg>:
10000792:	1f8046b7          	lui	a3,0x1f804
10000796:	f3068713          	addi	a4,a3,-208 # 1f803f30 <__etext+0xf801f88>
1000079a:	200017b7          	lui	a5,0x20001
1000079e:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
100007a2:	f7868693          	addi	a3,a3,-136
100007a6:	00072383          	lw	t2,0(a4)
100007aa:	00472283          	lw	t0,4(a4)
100007ae:	00872303          	lw	t1,8(a4)
100007b2:	4748                	lw	a0,12(a4)
100007b4:	4b0c                	lw	a1,16(a4)
100007b6:	4b50                	lw	a2,20(a4)
100007b8:	0077a023          	sw	t2,0(a5)
100007bc:	0057a223          	sw	t0,4(a5)
100007c0:	0067a423          	sw	t1,8(a5)
100007c4:	c7c8                	sw	a0,12(a5)
100007c6:	cb8c                	sw	a1,16(a5)
100007c8:	cbd0                	sw	a2,20(a5)
100007ca:	0761                	addi	a4,a4,24
100007cc:	07e1                	addi	a5,a5,24
100007ce:	fcd71ce3          	bne	a4,a3,100007a6 <otp_load_cfg+0x14>
100007d2:	200017b7          	lui	a5,0x20001
100007d6:	2ec7c703          	lbu	a4,748(a5) # 200012ec <g_otp_cfg>
100007da:	0ff00793          	li	a5,255
100007de:	00f71d63          	bne	a4,a5,100007f8 <otp_load_cfg+0x66>
100007e2:	20001737          	lui	a4,0x20001
100007e6:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
100007ea:	00074783          	lbu	a5,0(a4)
100007ee:	9bc1                	andi	a5,a5,-16
100007f0:	00a7e793          	ori	a5,a5,10
100007f4:	00f70023          	sb	a5,0(a4)
100007f8:	200017b7          	lui	a5,0x20001
100007fc:	2ee7c703          	lbu	a4,750(a5) # 200012ee <g_otp_cfg+0x2>
10000800:	0ff00793          	li	a5,255
10000804:	10f70f63          	beq	a4,a5,10000922 <otp_load_cfg+0x190>
10000808:	200017b7          	lui	a5,0x20001
1000080c:	2f07d703          	lhu	a4,752(a5) # 200012f0 <g_otp_cfg+0x4>
10000810:	67c1                	lui	a5,0x10
10000812:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
10000814:	12f70363          	beq	a4,a5,1000093a <otp_load_cfg+0x1a8>
10000818:	200017b7          	lui	a5,0x20001
1000081c:	2f27d703          	lhu	a4,754(a5) # 200012f2 <g_otp_cfg+0x6>
10000820:	67c1                	lui	a5,0x10
10000822:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
10000824:	12f70263          	beq	a4,a5,10000948 <otp_load_cfg+0x1b6>
10000828:	200017b7          	lui	a5,0x20001
1000082c:	2f47d703          	lhu	a4,756(a5) # 200012f4 <g_otp_cfg+0x8>
10000830:	67c1                	lui	a5,0x10
10000832:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
10000834:	12f70163          	beq	a4,a5,10000956 <otp_load_cfg+0x1c4>
10000838:	200017b7          	lui	a5,0x20001
1000083c:	2f87a703          	lw	a4,760(a5) # 200012f8 <g_otp_cfg+0xc>
10000840:	57fd                	li	a5,-1
10000842:	12f70763          	beq	a4,a5,10000970 <otp_load_cfg+0x1de>
10000846:	200017b7          	lui	a5,0x20001
1000084a:	2fc7a703          	lw	a4,764(a5) # 200012fc <g_otp_cfg+0x10>
1000084e:	57fd                	li	a5,-1
10000850:	14f70263          	beq	a4,a5,10000994 <otp_load_cfg+0x202>
10000854:	200017b7          	lui	a5,0x20001
10000858:	3007a703          	lw	a4,768(a5) # 20001300 <g_otp_cfg+0x14>
1000085c:	57fd                	li	a5,-1
1000085e:	14f70d63          	beq	a4,a5,100009b8 <otp_load_cfg+0x226>
10000862:	200017b7          	lui	a5,0x20001
10000866:	3047a703          	lw	a4,772(a5) # 20001304 <g_otp_cfg+0x18>
1000086a:	57fd                	li	a5,-1
1000086c:	16f70863          	beq	a4,a5,100009dc <otp_load_cfg+0x24a>
10000870:	200017b7          	lui	a5,0x20001
10000874:	3087a703          	lw	a4,776(a5) # 20001308 <g_otp_cfg+0x1c>
10000878:	57fd                	li	a5,-1
1000087a:	18f70363          	beq	a4,a5,10000a00 <otp_load_cfg+0x26e>
1000087e:	200017b7          	lui	a5,0x20001
10000882:	30c7a703          	lw	a4,780(a5) # 2000130c <g_otp_cfg+0x20>
10000886:	57fd                	li	a5,-1
10000888:	18f70e63          	beq	a4,a5,10000a24 <otp_load_cfg+0x292>
1000088c:	200017b7          	lui	a5,0x20001
10000890:	3107a703          	lw	a4,784(a5) # 20001310 <g_otp_cfg+0x24>
10000894:	57fd                	li	a5,-1
10000896:	1af70963          	beq	a4,a5,10000a48 <otp_load_cfg+0x2b6>
1000089a:	200017b7          	lui	a5,0x20001
1000089e:	3147a703          	lw	a4,788(a5) # 20001314 <g_otp_cfg+0x28>
100008a2:	57fd                	li	a5,-1
100008a4:	1cf70663          	beq	a4,a5,10000a70 <otp_load_cfg+0x2de>
100008a8:	200017b7          	lui	a5,0x20001
100008ac:	3187d703          	lhu	a4,792(a5) # 20001318 <g_otp_cfg+0x2c>
100008b0:	67c1                	lui	a5,0x10
100008b2:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
100008b4:	1ef70063          	beq	a4,a5,10000a94 <otp_load_cfg+0x302>
100008b8:	200017b7          	lui	a5,0x20001
100008bc:	31c7d703          	lhu	a4,796(a5) # 2000131c <g_otp_cfg+0x30>
100008c0:	67c1                	lui	a5,0x10
100008c2:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
100008c4:	1ef70363          	beq	a4,a5,10000aaa <otp_load_cfg+0x318>
100008c8:	200017b7          	lui	a5,0x20001
100008cc:	31e7d703          	lhu	a4,798(a5) # 2000131e <g_otp_cfg+0x32>
100008d0:	67c1                	lui	a5,0x10
100008d2:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
100008d4:	1ef70663          	beq	a4,a5,10000ac0 <otp_load_cfg+0x32e>
100008d8:	200017b7          	lui	a5,0x20001
100008dc:	3207d703          	lhu	a4,800(a5) # 20001320 <g_otp_cfg+0x34>
100008e0:	67c1                	lui	a5,0x10
100008e2:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa999>
100008e4:	1ef70963          	beq	a4,a5,10000ad6 <otp_load_cfg+0x344>
100008e8:	200017b7          	lui	a5,0x20001
100008ec:	3247a703          	lw	a4,804(a5) # 20001324 <g_otp_cfg+0x38>
100008f0:	57fd                	li	a5,-1
100008f2:	1ef70f63          	beq	a4,a5,10000af0 <otp_load_cfg+0x35e>
100008f6:	200017b7          	lui	a5,0x20001
100008fa:	3287a703          	lw	a4,808(a5) # 20001328 <g_otp_cfg+0x3c>
100008fe:	57fd                	li	a5,-1
10000900:	20f70463          	beq	a4,a5,10000b08 <otp_load_cfg+0x376>
10000904:	200017b7          	lui	a5,0x20001
10000908:	32c7a703          	lw	a4,812(a5) # 2000132c <g_otp_cfg+0x40>
1000090c:	57fd                	li	a5,-1
1000090e:	20f70c63          	beq	a4,a5,10000b26 <otp_load_cfg+0x394>
10000912:	200017b7          	lui	a5,0x20001
10000916:	3307a703          	lw	a4,816(a5) # 20001330 <g_otp_cfg+0x44>
1000091a:	57fd                	li	a5,-1
1000091c:	22f70963          	beq	a4,a5,10000b4e <otp_load_cfg+0x3bc>
10000920:	8082                	ret
10000922:	20001737          	lui	a4,0x20001
10000926:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1000092a:	00274783          	lbu	a5,2(a4)
1000092e:	9bc1                	andi	a5,a5,-16
10000930:	0037e793          	ori	a5,a5,3
10000934:	00f70123          	sb	a5,2(a4)
10000938:	bdc1                	j	10000808 <otp_load_cfg+0x76>
1000093a:	200017b7          	lui	a5,0x20001
1000093e:	f8d00713          	li	a4,-115
10000942:	2ee78823          	sb	a4,752(a5) # 200012f0 <g_otp_cfg+0x4>
10000946:	bdc9                	j	10000818 <otp_load_cfg+0x86>
10000948:	200017b7          	lui	a5,0x20001
1000094c:	fb700713          	li	a4,-73
10000950:	2ee78923          	sb	a4,754(a5) # 200012f2 <g_otp_cfg+0x6>
10000954:	bdd1                	j	10000828 <otp_load_cfg+0x96>
10000956:	20001737          	lui	a4,0x20001
1000095a:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1000095e:	00875783          	lhu	a5,8(a4)
10000962:	c007f793          	andi	a5,a5,-1024
10000966:	1407e793          	ori	a5,a5,320
1000096a:	00f71423          	sh	a5,8(a4)
1000096e:	b5e9                	j	10000838 <otp_load_cfg+0xa6>
10000970:	20001737          	lui	a4,0x20001
10000974:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000978:	475c                	lw	a5,12(a4)
1000097a:	76fd                	lui	a3,0xfffff
1000097c:	8ff5                	and	a5,a5,a3
1000097e:	2587e793          	ori	a5,a5,600
10000982:	fc0106b7          	lui	a3,0xfc010
10000986:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000988:	8ff5                	and	a5,a5,a3
1000098a:	02ab06b7          	lui	a3,0x2ab0
1000098e:	8fd5                	or	a5,a5,a3
10000990:	c75c                	sw	a5,12(a4)
10000992:	bd55                	j	10000846 <otp_load_cfg+0xb4>
10000994:	20001737          	lui	a4,0x20001
10000998:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1000099c:	4b1c                	lw	a5,16(a4)
1000099e:	76fd                	lui	a3,0xfffff
100009a0:	8ff5                	and	a5,a5,a3
100009a2:	0c87e793          	ori	a5,a5,200
100009a6:	fc0106b7          	lui	a3,0xfc010
100009aa:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100009ac:	8ff5                	and	a5,a5,a3
100009ae:	00e406b7          	lui	a3,0xe40
100009b2:	8fd5                	or	a5,a5,a3
100009b4:	cb1c                	sw	a5,16(a4)
100009b6:	bd79                	j	10000854 <otp_load_cfg+0xc2>
100009b8:	20001737          	lui	a4,0x20001
100009bc:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
100009c0:	4b5c                	lw	a5,20(a4)
100009c2:	76fd                	lui	a3,0xfffff
100009c4:	8ff5                	and	a5,a5,a3
100009c6:	4b07e793          	ori	a5,a5,1200
100009ca:	fc0106b7          	lui	a3,0xfc010
100009ce:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100009d0:	8ff5                	and	a5,a5,a3
100009d2:	02ab06b7          	lui	a3,0x2ab0
100009d6:	8fd5                	or	a5,a5,a3
100009d8:	cb5c                	sw	a5,20(a4)
100009da:	b561                	j	10000862 <otp_load_cfg+0xd0>
100009dc:	20001737          	lui	a4,0x20001
100009e0:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
100009e4:	4f1c                	lw	a5,24(a4)
100009e6:	76fd                	lui	a3,0xfffff
100009e8:	8ff5                	and	a5,a5,a3
100009ea:	1907e793          	ori	a5,a5,400
100009ee:	fc0106b7          	lui	a3,0xfc010
100009f2:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100009f4:	8ff5                	and	a5,a5,a3
100009f6:	00e406b7          	lui	a3,0xe40
100009fa:	8fd5                	or	a5,a5,a3
100009fc:	cf1c                	sw	a5,24(a4)
100009fe:	bd8d                	j	10000870 <otp_load_cfg+0xde>
10000a00:	20001737          	lui	a4,0x20001
10000a04:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000a08:	4f5c                	lw	a5,28(a4)
10000a0a:	76fd                	lui	a3,0xfffff
10000a0c:	8ff5                	and	a5,a5,a3
10000a0e:	7087e793          	ori	a5,a5,1800
10000a12:	fc0106b7          	lui	a3,0xfc010
10000a16:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000a18:	8ff5                	and	a5,a5,a3
10000a1a:	02ab06b7          	lui	a3,0x2ab0
10000a1e:	8fd5                	or	a5,a5,a3
10000a20:	cf5c                	sw	a5,28(a4)
10000a22:	bdb1                	j	1000087e <otp_load_cfg+0xec>
10000a24:	20001737          	lui	a4,0x20001
10000a28:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000a2c:	531c                	lw	a5,32(a4)
10000a2e:	76fd                	lui	a3,0xfffff
10000a30:	8ff5                	and	a5,a5,a3
10000a32:	2587e793          	ori	a5,a5,600
10000a36:	fc0106b7          	lui	a3,0xfc010
10000a3a:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000a3c:	8ff5                	and	a5,a5,a3
10000a3e:	00e406b7          	lui	a3,0xe40
10000a42:	8fd5                	or	a5,a5,a3
10000a44:	d31c                	sw	a5,32(a4)
10000a46:	b599                	j	1000088c <otp_load_cfg+0xfa>
10000a48:	20001737          	lui	a4,0x20001
10000a4c:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000a50:	535c                	lw	a5,36(a4)
10000a52:	76fd                	lui	a3,0xfffff
10000a54:	8ff5                	and	a5,a5,a3
10000a56:	6685                	lui	a3,0x1
10000a58:	96068693          	addi	a3,a3,-1696 # 960 <__STACK_SIZE+0x660>
10000a5c:	8fd5                	or	a5,a5,a3
10000a5e:	fc0106b7          	lui	a3,0xfc010
10000a62:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000a64:	8ff5                	and	a5,a5,a3
10000a66:	02ab06b7          	lui	a3,0x2ab0
10000a6a:	8fd5                	or	a5,a5,a3
10000a6c:	d35c                	sw	a5,36(a4)
10000a6e:	b535                	j	1000089a <otp_load_cfg+0x108>
10000a70:	20001737          	lui	a4,0x20001
10000a74:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000a78:	571c                	lw	a5,40(a4)
10000a7a:	76fd                	lui	a3,0xfffff
10000a7c:	8ff5                	and	a5,a5,a3
10000a7e:	3207e793          	ori	a5,a5,800
10000a82:	fc0106b7          	lui	a3,0xfc010
10000a86:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000a88:	8ff5                	and	a5,a5,a3
10000a8a:	00e406b7          	lui	a3,0xe40
10000a8e:	8fd5                	or	a5,a5,a3
10000a90:	d71c                	sw	a5,40(a4)
10000a92:	bd19                	j	100008a8 <otp_load_cfg+0x116>
10000a94:	200017b7          	lui	a5,0x20001
10000a98:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
10000a9c:	02c7d703          	lhu	a4,44(a5)
10000aa0:	3ff76713          	ori	a4,a4,1023
10000aa4:	02e79623          	sh	a4,44(a5)
10000aa8:	bd01                	j	100008b8 <otp_load_cfg+0x126>
10000aaa:	200017b7          	lui	a5,0x20001
10000aae:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
10000ab2:	0307d703          	lhu	a4,48(a5)
10000ab6:	76fd                	lui	a3,0xfffff
10000ab8:	8f75                	and	a4,a4,a3
10000aba:	02e79823          	sh	a4,48(a5)
10000abe:	b529                	j	100008c8 <otp_load_cfg+0x136>
10000ac0:	200017b7          	lui	a5,0x20001
10000ac4:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
10000ac8:	0327d703          	lhu	a4,50(a5)
10000acc:	76fd                	lui	a3,0xfffff
10000ace:	8f75                	and	a4,a4,a3
10000ad0:	02e79923          	sh	a4,50(a5)
10000ad4:	b511                	j	100008d8 <otp_load_cfg+0x146>
10000ad6:	20001737          	lui	a4,0x20001
10000ada:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000ade:	03475783          	lhu	a5,52(a4)
10000ae2:	76fd                	lui	a3,0xfffff
10000ae4:	8ff5                	and	a5,a5,a3
10000ae6:	40c7e793          	ori	a5,a5,1036
10000aea:	02f71a23          	sh	a5,52(a4)
10000aee:	bbed                	j	100008e8 <otp_load_cfg+0x156>
10000af0:	20001737          	lui	a4,0x20001
10000af4:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000af8:	5f1c                	lw	a5,56(a4)
10000afa:	800006b7          	lui	a3,0x80000
10000afe:	8ff5                	and	a5,a5,a3
10000b00:	0357e793          	ori	a5,a5,53
10000b04:	df1c                	sw	a5,56(a4)
10000b06:	bbc5                	j	100008f6 <otp_load_cfg+0x164>
10000b08:	20001737          	lui	a4,0x20001
10000b0c:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000b10:	5f5c                	lw	a5,60(a4)
10000b12:	800006b7          	lui	a3,0x80000
10000b16:	8ff5                	and	a5,a5,a3
10000b18:	0003b6b7          	lui	a3,0x3b
10000b1c:	98068693          	addi	a3,a3,-1664 # 3a980 <ble_viot.c.e415c280+0x3531a>
10000b20:	8fd5                	or	a5,a5,a3
10000b22:	df5c                	sw	a5,60(a4)
10000b24:	b3c5                	j	10000904 <otp_load_cfg+0x172>
10000b26:	20001737          	lui	a4,0x20001
10000b2a:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000b2e:	433c                	lw	a5,64(a4)
10000b30:	76fd                	lui	a3,0xfffff
10000b32:	8ff5                	and	a5,a5,a3
10000b34:	6685                	lui	a3,0x1
10000b36:	bb868693          	addi	a3,a3,-1096 # bb8 <main.c.5cfd7a5a+0x23e>
10000b3a:	8fd5                	or	a5,a5,a3
10000b3c:	fc0106b7          	lui	a3,0xfc010
10000b40:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000b42:	8ff5                	and	a5,a5,a3
10000b44:	035506b7          	lui	a3,0x3550
10000b48:	8fd5                	or	a5,a5,a3
10000b4a:	c33c                	sw	a5,64(a4)
10000b4c:	b3d9                	j	10000912 <otp_load_cfg+0x180>
10000b4e:	20001737          	lui	a4,0x20001
10000b52:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000b56:	437c                	lw	a5,68(a4)
10000b58:	76fd                	lui	a3,0xfffff
10000b5a:	8ff5                	and	a5,a5,a3
10000b5c:	7d07e793          	ori	a5,a5,2000
10000b60:	fc0106b7          	lui	a3,0xfc010
10000b64:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10000b66:	8ff5                	and	a5,a5,a3
10000b68:	023906b7          	lui	a3,0x2390
10000b6c:	8fd5                	or	a5,a5,a3
10000b6e:	c37c                	sw	a5,68(a4)
10000b70:	8082                	ret

10000b72 <otp_apply_cfg>:
10000b72:	400807b7          	lui	a5,0x40080
10000b76:	1047a603          	lw	a2,260(a5) # 40080104 <__StackTop+0x2007c104>
10000b7a:	fffc4737          	lui	a4,0xfffc4
10000b7e:	177d                	addi	a4,a4,-1 # fffc3fff <__StackTop+0xdffbffff>
10000b80:	8e79                	and	a2,a2,a4
10000b82:	20001737          	lui	a4,0x20001
10000b86:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
10000b8a:	00275683          	lhu	a3,2(a4)
10000b8e:	8abd                	andi	a3,a3,15
10000b90:	06ba                	slli	a3,a3,0xe
10000b92:	8ed1                	or	a3,a3,a2
10000b94:	10d7a223          	sw	a3,260(a5)
10000b98:	1087a603          	lw	a2,264(a5)
10000b9c:	76c1                	lui	a3,0xffff0
10000b9e:	0ff68693          	addi	a3,a3,255 # ffff00ff <__StackTop+0xdffec0ff>
10000ba2:	8e75                	and	a2,a2,a3
10000ba4:	00474683          	lbu	a3,4(a4)
10000ba8:	06a2                	slli	a3,a3,0x8
10000baa:	8ed1                	or	a3,a3,a2
10000bac:	10d7a423          	sw	a3,264(a5)
10000bb0:	10c7a603          	lw	a2,268(a5)
10000bb4:	76e1                	lui	a3,0xffff8
10000bb6:	07f68693          	addi	a3,a3,127 # ffff807f <__StackTop+0xdfff407f>
10000bba:	8e75                	and	a2,a2,a3
10000bbc:	00674683          	lbu	a3,6(a4)
10000bc0:	069e                	slli	a3,a3,0x7
10000bc2:	8ed1                	or	a3,a3,a2
10000bc4:	10d7a623          	sw	a3,268(a5)
10000bc8:	1107a603          	lw	a2,272(a5)
10000bcc:	ff0406b7          	lui	a3,0xff040
10000bd0:	16fd                	addi	a3,a3,-1 # ff03ffff <__StackTop+0xdf03bfff>
10000bd2:	8e75                	and	a2,a2,a3
10000bd4:	5f14                	lw	a3,56(a4)
10000bd6:	06ca                	slli	a3,a3,0x12
10000bd8:	8ed1                	or	a3,a3,a2
10000bda:	10d7a823          	sw	a3,272(a5)
10000bde:	42002637          	lui	a2,0x42002
10000be2:	4614                	lw	a3,8(a2)
10000be4:	880007b7          	lui	a5,0x88000
10000be8:	17fd                	addi	a5,a5,-1 # 87ffffff <__StackTop+0x67ffbfff>
10000bea:	8efd                	and	a3,a3,a5
10000bec:	431c                	lw	a5,0(a4)
10000bee:	8bbd                	andi	a5,a5,15
10000bf0:	07ee                	slli	a5,a5,0x1b
10000bf2:	8fd5                	or	a5,a5,a3
10000bf4:	c61c                	sw	a5,8(a2)
10000bf6:	8082                	ret

10000bf8 <cal_autolen_pkt_desc_offset>:
10000bf8:	200017b7          	lui	a5,0x20001
10000bfc:	32078a23          	sb	zero,820(a5) # 20001334 <autolen_pkt_desc_offset>
10000c00:	200017b7          	lui	a5,0x20001
10000c04:	3587c783          	lbu	a5,856(a5) # 20001358 <rf_2g4_mgr+0x1c>
10000c08:	cf9d                	beqz	a5,10000c46 <cal_autolen_pkt_desc_offset+0x4e>
10000c0a:	200017b7          	lui	a5,0x20001
10000c0e:	3597c783          	lbu	a5,857(a5) # 20001359 <rf_2g4_mgr+0x1d>
10000c12:	c791                	beqz	a5,10000c1e <cal_autolen_pkt_desc_offset+0x26>
10000c14:	200017b7          	lui	a5,0x20001
10000c18:	4705                	li	a4,1
10000c1a:	32e78a23          	sb	a4,820(a5) # 20001334 <autolen_pkt_desc_offset>
10000c1e:	200017b7          	lui	a5,0x20001
10000c22:	33478793          	addi	a5,a5,820 # 20001334 <autolen_pkt_desc_offset>
10000c26:	0007c703          	lbu	a4,0(a5)
10000c2a:	00170693          	addi	a3,a4,1
10000c2e:	00d78023          	sb	a3,0(a5)
10000c32:	200017b7          	lui	a5,0x20001
10000c36:	35b7c783          	lbu	a5,859(a5) # 2000135b <rf_2g4_mgr+0x1f>
10000c3a:	c791                	beqz	a5,10000c46 <cal_autolen_pkt_desc_offset+0x4e>
10000c3c:	0709                	addi	a4,a4,2
10000c3e:	200017b7          	lui	a5,0x20001
10000c42:	32e78a23          	sb	a4,820(a5) # 20001334 <autolen_pkt_desc_offset>
10000c46:	8082                	ret

10000c48 <RF_2G4_DescInit_Mode>:
10000c48:	200017b7          	lui	a5,0x20001
10000c4c:	38a7c703          	lbu	a4,906(a5) # 2000138a <rf_2g4_thld+0x2>
10000c50:	200017b7          	lui	a5,0x20001
10000c54:	3d478793          	addi	a5,a5,980 # 200013d4 <rf_common_desc_modem_rx>
10000c58:	08f50c63          	beq	a0,a5,10000cf0 <RF_2G4_DescInit_Mode+0xa8>
10000c5c:	420026b7          	lui	a3,0x42002
10000c60:	0c06a783          	lw	a5,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
10000c64:	07f7f793          	andi	a5,a5,127
10000c68:	0cf6a023          	sw	a5,192(a3)
10000c6c:	200017b7          	lui	a5,0x20001
10000c70:	33e7c783          	lbu	a5,830(a5) # 2000133e <rf_2g4_mgr+0x2>
10000c74:	46c5                	li	a3,17
10000c76:	cf95                	beqz	a5,10000cb2 <RF_2G4_DescInit_Mode+0x6a>
10000c78:	4605                	li	a2,1
10000c7a:	04c78463          	beq	a5,a2,10000cc2 <RF_2G4_DescInit_Mode+0x7a>
10000c7e:	08000793          	li	a5,128
10000c82:	42001637          	lui	a2,0x42001
10000c86:	00460593          	addi	a1,a2,4 # 42001004 <__StackTop+0x21ffd004>
10000c8a:	c10c                	sw	a1,0(a0)
10000c8c:	06c2                	slli	a3,a3,0x10
10000c8e:	6589                	lui	a1,0x2
10000c90:	8ecd                	or	a3,a3,a1
10000c92:	c154                	sw	a3,4(a0)
10000c94:	08c60693          	addi	a3,a2,140
10000c98:	c514                	sw	a3,8(a0)
10000c9a:	0742                	slli	a4,a4,0x10
10000c9c:	8f4d                	or	a4,a4,a1
10000c9e:	c558                	sw	a4,12(a0)
10000ca0:	05060613          	addi	a2,a2,80
10000ca4:	c910                	sw	a2,16(a0)
10000ca6:	07c2                	slli	a5,a5,0x10
10000ca8:	8fcd                	or	a5,a5,a1
10000caa:	0087e793          	ori	a5,a5,8
10000cae:	c95c                	sw	a5,20(a0)
10000cb0:	8082                	ret
10000cb2:	46c5                	li	a3,17
10000cb4:	200017b7          	lui	a5,0x20001
10000cb8:	3887c703          	lbu	a4,904(a5) # 20001388 <rf_2g4_thld>
10000cbc:	08000793          	li	a5,128
10000cc0:	b7c9                	j	10000c82 <RF_2G4_DescInit_Mode+0x3a>
10000cc2:	420026b7          	lui	a3,0x42002
10000cc6:	0c06a703          	lw	a4,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
10000cca:	08076713          	ori	a4,a4,128
10000cce:	0ce6a023          	sw	a4,192(a3)
10000cd2:	20001737          	lui	a4,0x20001
10000cd6:	3d470713          	addi	a4,a4,980 # 200013d4 <rf_common_desc_modem_rx>
10000cda:	468d                	li	a3,3
10000cdc:	00e50363          	beq	a0,a4,10000ce2 <RF_2G4_DescInit_Mode+0x9a>
10000ce0:	86be                	mv	a3,a5
10000ce2:	200017b7          	lui	a5,0x20001
10000ce6:	3897c703          	lbu	a4,905(a5) # 20001389 <rf_2g4_thld+0x1>
10000cea:	08400793          	li	a5,132
10000cee:	bf51                	j	10000c82 <RF_2G4_DescInit_Mode+0x3a>
10000cf0:	420026b7          	lui	a3,0x42002
10000cf4:	0c06a783          	lw	a5,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
10000cf8:	07f7f793          	andi	a5,a5,127
10000cfc:	0cf6a023          	sw	a5,192(a3)
10000d00:	200017b7          	lui	a5,0x20001
10000d04:	33e7c783          	lbu	a5,830(a5) # 2000133e <rf_2g4_mgr+0x2>
10000d08:	4685                	li	a3,1
10000d0a:	f7bd                	bnez	a5,10000c78 <RF_2G4_DescInit_Mode+0x30>
10000d0c:	4685                	li	a3,1
10000d0e:	b75d                	j	10000cb4 <RF_2G4_DescInit_Mode+0x6c>

10000d10 <RF_2G4_UpdateDesc_TxCommon>:
10000d10:	20001537          	lui	a0,0x20001
10000d14:	39050513          	addi	a0,a0,912 # 20001390 <rf_2g4_tx_pkt_desc>
10000d18:	200017b7          	lui	a5,0x20001
10000d1c:	37878793          	addi	a5,a5,888 # 20001378 <rf_2g4_preamble>
10000d20:	c11c                	sw	a5,0(a0)
10000d22:	200016b7          	lui	a3,0x20001
10000d26:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
10000d2a:	0036c703          	lbu	a4,3(a3)
10000d2e:	070e                	slli	a4,a4,0x3
10000d30:	177d                	addi	a4,a4,-1
10000d32:	0742                	slli	a4,a4,0x10
10000d34:	6605                	lui	a2,0x1
10000d36:	8f51                	or	a4,a4,a2
10000d38:	c158                	sw	a4,4(a0)
10000d3a:	00468793          	addi	a5,a3,4
10000d3e:	c51c                	sw	a5,8(a0)
10000d40:	00c6c783          	lbu	a5,12(a3)
10000d44:	078e                	slli	a5,a5,0x3
10000d46:	17fd                	addi	a5,a5,-1
10000d48:	07c2                	slli	a5,a5,0x10
10000d4a:	8fd1                	or	a5,a5,a2
10000d4c:	c55c                	sw	a5,12(a0)
10000d4e:	0521                	addi	a0,a0,8
10000d50:	8082                	ret

10000d52 <RF_2G4_UpdateDesc_TxPkt>:
10000d52:	1131                	addi	sp,sp,-20
10000d54:	c806                	sw	ra,16(sp)
10000d56:	c622                	sw	s0,12(sp)
10000d58:	c426                	sw	s1,8(sp)
10000d5a:	20001437          	lui	s0,0x20001
10000d5e:	33c40413          	addi	s0,s0,828 # 2000133c <rf_2g4_mgr>
10000d62:	00f44783          	lbu	a5,15(s0)
10000d66:	079a                	slli	a5,a5,0x6
10000d68:	0407f793          	andi	a5,a5,64
10000d6c:	c03e                	sw	a5,0(sp)
10000d6e:	01244783          	lbu	a5,18(s0)
10000d72:	0792                	slli	a5,a5,0x4
10000d74:	8bc1                	andi	a5,a5,16
10000d76:	c23e                	sw	a5,4(sp)
10000d78:	00179493          	slli	s1,a5,0x1
10000d7c:	3f51                	jal	10000d10 <RF_2G4_UpdateDesc_TxCommon>
10000d7e:	00850713          	addi	a4,a0,8
10000d82:	505c                	lw	a5,36(s0)
10000d84:	0087d693          	srli	a3,a5,0x8
10000d88:	02344603          	lbu	a2,35(s0)
10000d8c:	0ff7f793          	zext.b	a5,a5
10000d90:	07a2                	slli	a5,a5,0x8
10000d92:	8fd1                	or	a5,a5,a2
10000d94:	40f687b3          	sub	a5,a3,a5
10000d98:	200016b7          	lui	a3,0x20001
10000d9c:	38f69623          	sh	a5,908(a3) # 2000138c <rf_2g4_trans_len>
10000da0:	01c44783          	lbu	a5,28(s0)
10000da4:	c7b5                	beqz	a5,10000e10 <RF_2G4_UpdateDesc_TxPkt+0xbe>
10000da6:	200017b7          	lui	a5,0x20001
10000daa:	3597c783          	lbu	a5,857(a5) # 20001359 <rf_2g4_mgr+0x1d>
10000dae:	c79d                	beqz	a5,10000ddc <RF_2G4_UpdateDesc_TxPkt+0x8a>
10000db0:	20001737          	lui	a4,0x20001
10000db4:	33c70713          	addi	a4,a4,828 # 2000133c <rf_2g4_mgr>
10000db8:	01e70793          	addi	a5,a4,30
10000dbc:	c51c                	sw	a5,8(a0)
10000dbe:	01d74783          	lbu	a5,29(a4)
10000dc2:	17fd                	addi	a5,a5,-1
10000dc4:	07c2                	slli	a5,a5,0x10
10000dc6:	01174703          	lbu	a4,17(a4)
10000dca:	8f45                	or	a4,a4,s1
10000dcc:	8fd9                	or	a5,a5,a4
10000dce:	4702                	lw	a4,0(sp)
10000dd0:	8fd9                	or	a5,a5,a4
10000dd2:	6705                	lui	a4,0x1
10000dd4:	8fd9                	or	a5,a5,a4
10000dd6:	c55c                	sw	a5,12(a0)
10000dd8:	01050713          	addi	a4,a0,16
10000ddc:	200017b7          	lui	a5,0x20001
10000de0:	38c78793          	addi	a5,a5,908 # 2000138c <rf_2g4_trans_len>
10000de4:	c31c                	sw	a5,0(a4)
10000de6:	200016b7          	lui	a3,0x20001
10000dea:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
10000dee:	01c6c783          	lbu	a5,28(a3)
10000df2:	17fd                	addi	a5,a5,-1
10000df4:	07c2                	slli	a5,a5,0x10
10000df6:	0116c603          	lbu	a2,17(a3)
10000dfa:	8e45                	or	a2,a2,s1
10000dfc:	8fd1                	or	a5,a5,a2
10000dfe:	4602                	lw	a2,0(sp)
10000e00:	8fd1                	or	a5,a5,a2
10000e02:	6605                	lui	a2,0x1
10000e04:	8fd1                	or	a5,a5,a2
10000e06:	c35c                	sw	a5,4(a4)
10000e08:	01f6c783          	lbu	a5,31(a3)
10000e0c:	ebb9                	bnez	a5,10000e62 <RF_2G4_UpdateDesc_TxPkt+0x110>
10000e0e:	0721                	addi	a4,a4,8 # 1008 <main.c.5cfd7a5a+0x68e>
10000e10:	200016b7          	lui	a3,0x20001
10000e14:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
10000e18:	0236c603          	lbu	a2,35(a3)
10000e1c:	0246c783          	lbu	a5,36(a3)
10000e20:	07a2                	slli	a5,a5,0x8
10000e22:	8fd1                	or	a5,a5,a2
10000e24:	20001637          	lui	a2,0x20001
10000e28:	33862603          	lw	a2,824(a2) # 20001338 <rf_2g4_fifo>
10000e2c:	97b2                	add	a5,a5,a2
10000e2e:	c31c                	sw	a5,0(a4)
10000e30:	200017b7          	lui	a5,0x20001
10000e34:	38c7d783          	lhu	a5,908(a5) # 2000138c <rf_2g4_trans_len>
10000e38:	078e                	slli	a5,a5,0x3
10000e3a:	17fd                	addi	a5,a5,-1
10000e3c:	07c2                	slli	a5,a5,0x10
10000e3e:	0116c683          	lbu	a3,17(a3)
10000e42:	8cd5                	or	s1,s1,a3
10000e44:	8fc5                	or	a5,a5,s1
10000e46:	4692                	lw	a3,4(sp)
10000e48:	8fd5                	or	a5,a5,a3
10000e4a:	4682                	lw	a3,0(sp)
10000e4c:	8fd5                	or	a5,a5,a3
10000e4e:	6685                	lui	a3,0x1
10000e50:	8fd5                	or	a5,a5,a3
10000e52:	0087e793          	ori	a5,a5,8
10000e56:	c35c                	sw	a5,4(a4)
10000e58:	40c2                	lw	ra,16(sp)
10000e5a:	4432                	lw	s0,12(sp)
10000e5c:	44a2                	lw	s1,8(sp)
10000e5e:	0151                	addi	sp,sp,20
10000e60:	8082                	ret
10000e62:	200016b7          	lui	a3,0x20001
10000e66:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
10000e6a:	02068793          	addi	a5,a3,32
10000e6e:	c71c                	sw	a5,8(a4)
10000e70:	01f6c783          	lbu	a5,31(a3)
10000e74:	17fd                	addi	a5,a5,-1
10000e76:	07c2                	slli	a5,a5,0x10
10000e78:	0116c683          	lbu	a3,17(a3)
10000e7c:	8ec5                	or	a3,a3,s1
10000e7e:	8fd5                	or	a5,a5,a3
10000e80:	4682                	lw	a3,0(sp)
10000e82:	8fd5                	or	a5,a5,a3
10000e84:	6685                	lui	a3,0x1
10000e86:	8fd5                	or	a5,a5,a3
10000e88:	c75c                	sw	a5,12(a4)
10000e8a:	0741                	addi	a4,a4,16
10000e8c:	b751                	j	10000e10 <RF_2G4_UpdateDesc_TxPkt+0xbe>

10000e8e <reverse8>:
10000e8e:	00151793          	slli	a5,a0,0x1
10000e92:	8505                	srai	a0,a0,0x1
10000e94:	05557713          	andi	a4,a0,85
10000e98:	0aa7f513          	andi	a0,a5,170
10000e9c:	8d59                	or	a0,a0,a4
10000e9e:	00251793          	slli	a5,a0,0x2
10000ea2:	8509                	srai	a0,a0,0x2
10000ea4:	03357513          	andi	a0,a0,51
10000ea8:	0cc7f793          	andi	a5,a5,204
10000eac:	8d5d                	or	a0,a0,a5
10000eae:	00451793          	slli	a5,a0,0x4
10000eb2:	8111                	srli	a0,a0,0x4
10000eb4:	8d5d                	or	a0,a0,a5
10000eb6:	0ff57513          	zext.b	a0,a0
10000eba:	8082                	ret

10000ebc <omw_svc_2g4_set_phy_divisor>:
10000ebc:	87aa                	mv	a5,a0
10000ebe:	e111                	bnez	a0,10000ec2 <omw_svc_2g4_set_phy_divisor+0x6>
10000ec0:	4785                	li	a5,1
10000ec2:	0ff7f793          	zext.b	a5,a5
10000ec6:	20001737          	lui	a4,0x20001
10000eca:	33e74683          	lbu	a3,830(a4) # 2000133e <rf_2g4_mgr+0x2>
10000ece:	4705                	li	a4,1
10000ed0:	04d77163          	bgeu	a4,a3,10000f12 <omw_svc_2g4_set_phy_divisor+0x56>
10000ed4:	00279713          	slli	a4,a5,0x2
10000ed8:	973e                	add	a4,a4,a5
10000eda:	0746                	slli	a4,a4,0x11
10000edc:	6695                	lui	a3,0x5
10000ede:	06a1                	addi	a3,a3,8 # 5008 <__RAM_SIZE+0x1008>
10000ee0:	8f55                	or	a4,a4,a3
10000ee2:	200006b7          	lui	a3,0x20000
10000ee6:	1ae6ae23          	sw	a4,444(a3) # 200001bc <rf_common_desc_tx_end_delay+0x4>
10000eea:	4705                	li	a4,1
10000eec:	02a77b63          	bgeu	a4,a0,10000f22 <omw_svc_2g4_set_phy_divisor+0x66>
10000ef0:	0ff78693          	addi	a3,a5,255
10000ef4:	42001737          	lui	a4,0x42001
10000ef8:	06d71823          	sh	a3,112(a4) # 42001070 <__StackTop+0x21ffd070>
10000efc:	42000737          	lui	a4,0x42000
10000f00:	4685                	li	a3,1
10000f02:	0cd707a3          	sb	a3,207(a4) # 420000cf <__StackTop+0x21ffc0cf>
10000f06:	6741                	lui	a4,0x10
10000f08:	97ba                	add	a5,a5,a4
10000f0a:	42000737          	lui	a4,0x42000
10000f0e:	cf7c                	sw	a5,92(a4)
10000f10:	8082                	ret
10000f12:	00279713          	slli	a4,a5,0x2
10000f16:	973e                	add	a4,a4,a5
10000f18:	0742                	slli	a4,a4,0x10
10000f1a:	6695                	lui	a3,0x5
10000f1c:	06a1                	addi	a3,a3,8 # 5008 <__RAM_SIZE+0x1008>
10000f1e:	8f55                	or	a4,a4,a3
10000f20:	b7c9                	j	10000ee2 <omw_svc_2g4_set_phy_divisor+0x26>
10000f22:	42001737          	lui	a4,0x42001
10000f26:	06071823          	sh	zero,112(a4) # 42001070 <__StackTop+0x21ffd070>
10000f2a:	42000737          	lui	a4,0x42000
10000f2e:	0c0707a3          	sb	zero,207(a4) # 420000cf <__StackTop+0x21ffc0cf>
10000f32:	bfd1                	j	10000f06 <omw_svc_2g4_set_phy_divisor+0x4a>

10000f34 <RF_2G4_PrepareStart>:
10000f34:	1151                	addi	sp,sp,-12
10000f36:	c406                	sw	ra,8(sp)
10000f38:	c222                	sw	s0,4(sp)
10000f3a:	c026                	sw	s1,0(sp)
10000f3c:	20001437          	lui	s0,0x20001
10000f40:	33c40413          	addi	s0,s0,828 # 2000133c <rf_2g4_mgr>
10000f44:	00244703          	lbu	a4,2(s0)
10000f48:	100027b7          	lui	a5,0x10002
10000f4c:	f3c78793          	addi	a5,a5,-196 # 10001f3c <freq_ratios>
10000f50:	97ba                	add	a5,a5,a4
10000f52:	0007c503          	lbu	a0,0(a5)
10000f56:	379d                	jal	10000ebc <omw_svc_2g4_set_phy_divisor>
10000f58:	4048                	lw	a0,4(s0)
10000f5a:	0ffff097          	auipc	ra,0xffff
10000f5e:	624080e7          	jalr	1572(ra) # 2000057e <omw_svc_2g4_set_access_word>
10000f62:	01344783          	lbu	a5,19(s0)
10000f66:	420004b7          	lui	s1,0x42000
10000f6a:	ccdc                	sw	a5,28(s1)
10000f6c:	485c                	lw	a5,20(s0)
10000f6e:	d09c                	sw	a5,32(s1)
10000f70:	4c1c                	lw	a5,24(s0)
10000f72:	d0dc                	sw	a5,36(s1)
10000f74:	01c44783          	lbu	a5,28(s0)
10000f78:	04f48a23          	sb	a5,84(s1) # 42000054 <__StackTop+0x21ffc054>
10000f7c:	20001537          	lui	a0,0x20001
10000f80:	3ec50513          	addi	a0,a0,1004 # 200013ec <rf_common_desc_modem_tx>
10000f84:	31d1                	jal	10000c48 <RF_2G4_DescInit_Mode>
10000f86:	01044783          	lbu	a5,16(s0)
10000f8a:	00f49a23          	sh	a5,20(s1)
10000f8e:	00045583          	lhu	a1,0(s0)
10000f92:	20000537          	lui	a0,0x20000
10000f96:	35450513          	addi	a0,a0,852 # 20000354 <rf_common_desc_tx_setfreq>
10000f9a:	10000097          	auipc	ra,0x10000
10000f9e:	8c8080e7          	jalr	-1848(ra) # 20000862 <RADIO_CommonDescInit_SetFreq>
10000fa2:	200007b7          	lui	a5,0x20000
10000fa6:	0e078793          	addi	a5,a5,224 # 200000e0 <rf_2g4_common_desc_pll_delay>
10000faa:	0047d703          	lhu	a4,4(a5)
10000fae:	001e06b7          	lui	a3,0x1e0
10000fb2:	8f55                	or	a4,a4,a3
10000fb4:	c3d8                	sw	a4,4(a5)
10000fb6:	20000737          	lui	a4,0x20000
10000fba:	200017b7          	lui	a5,0x20001
10000fbe:	39078793          	addi	a5,a5,912 # 20001390 <rf_2g4_tx_pkt_desc>
10000fc2:	12f72023          	sw	a5,288(a4) # 20000120 <rf_call_desc_list_tx_process+0x38>
10000fc6:	4cbc                	lw	a5,88(s1)
10000fc8:	83a1                	srli	a5,a5,0x8
10000fca:	8b85                	andi	a5,a5,1
10000fcc:	00444703          	lbu	a4,4(s0)
10000fd0:	8b05                	andi	a4,a4,1
10000fd2:	05500693          	li	a3,85
10000fd6:	02e78f63          	beq	a5,a4,10001014 <RF_2G4_PrepareStart+0xe0>
10000fda:	200017b7          	lui	a5,0x20001
10000fde:	33f7c703          	lbu	a4,831(a5) # 2000133f <rf_2g4_mgr+0x3>
10000fe2:	cb19                	beqz	a4,10000ff8 <RF_2G4_PrepareStart+0xc4>
10000fe4:	200017b7          	lui	a5,0x20001
10000fe8:	37878793          	addi	a5,a5,888 # 20001378 <rf_2g4_preamble>
10000fec:	973e                	add	a4,a4,a5
10000fee:	00d78023          	sb	a3,0(a5)
10000ff2:	0785                	addi	a5,a5,1
10000ff4:	fee79de3          	bne	a5,a4,10000fee <RF_2G4_PrepareStart+0xba>
10000ff8:	200017b7          	lui	a5,0x20001
10000ffc:	33c78793          	addi	a5,a5,828 # 2000133c <rf_2g4_mgr>
10001000:	4705                	li	a4,1
10001002:	02e787a3          	sb	a4,47(a5)
10001006:	02078823          	sb	zero,48(a5)
1000100a:	40a2                	lw	ra,8(sp)
1000100c:	4412                	lw	s0,4(sp)
1000100e:	4482                	lw	s1,0(sp)
10001010:	0131                	addi	sp,sp,12
10001012:	8082                	ret
10001014:	0aa00693          	li	a3,170
10001018:	b7c9                	j	10000fda <RF_2G4_PrepareStart+0xa6>

1000101a <omw_svc_2g4_init>:
1000101a:	1151                	addi	sp,sp,-12
1000101c:	c406                	sw	ra,8(sp)
1000101e:	85aa                	mv	a1,a0
10001020:	200017b7          	lui	a5,0x20001
10001024:	38878793          	addi	a5,a5,904 # 20001388 <rf_2g4_thld>
10001028:	4709                	li	a4,2
1000102a:	00e78023          	sb	a4,0(a5)
1000102e:	00e780a3          	sb	a4,1(a5)
10001032:	00e78123          	sb	a4,2(a5)
10001036:	00e781a3          	sb	a4,3(a5)
1000103a:	03b00613          	li	a2,59
1000103e:	20001537          	lui	a0,0x20001
10001042:	33c50513          	addi	a0,a0,828 # 2000133c <rf_2g4_mgr>
10001046:	393000ef          	jal	10001bd8 <memcpy>
1000104a:	367d                	jal	10000bf8 <cal_autolen_pkt_desc_offset>
1000104c:	40a2                	lw	ra,8(sp)
1000104e:	0131                	addi	sp,sp,12
10001050:	8082                	ret

10001052 <omw_rf_init>:
10001052:	1151                	addi	sp,sp,-12
10001054:	c406                	sw	ra,8(sp)
10001056:	420006b7          	lui	a3,0x42000
1000105a:	6605                	lui	a2,0x1
1000105c:	70160793          	addi	a5,a2,1793 # 1701 <main.c.5cfd7a5a+0xd87>
10001060:	10f69023          	sh	a5,256(a3) # 42000100 <__StackTop+0x21ffc100>
10001064:	478d                	li	a5,3
10001066:	06f68023          	sb	a5,96(a3)
1000106a:	e08007b7          	lui	a5,0xe0800
1000106e:	43d8                	lw	a4,4(a5)
10001070:	8355                	srli	a4,a4,0x15
10001072:	00f77793          	andi	a5,a4,15
10001076:	4721                	li	a4,8
10001078:	8f1d                	sub	a4,a4,a5
1000107a:	e08015b7          	lui	a1,0xe0801
1000107e:	04b5c783          	lbu	a5,75(a1) # e080104b <__StackTop+0xc07fd04b>
10001082:	0ff7f513          	zext.b	a0,a5
10001086:	0ff00793          	li	a5,255
1000108a:	00e797b3          	sll	a5,a5,a4
1000108e:	fff7c793          	not	a5,a5
10001092:	8fe9                	and	a5,a5,a0
10001094:	4511                	li	a0,4
10001096:	00e51733          	sll	a4,a0,a4
1000109a:	8fd9                	or	a5,a5,a4
1000109c:	0ff7f793          	zext.b	a5,a5
100010a0:	04f585a3          	sb	a5,75(a1)
100010a4:	0495c783          	lbu	a5,73(a1)
100010a8:	0ff7f793          	zext.b	a5,a5
100010ac:	0017e793          	ori	a5,a5,1
100010b0:	04f584a3          	sb	a5,73(a1)
100010b4:	02f00713          	li	a4,47
100010b8:	0ce6a623          	sw	a4,204(a3)
100010bc:	77fd                	lui	a5,0xfffff
100010be:	70078793          	addi	a5,a5,1792 # fffff700 <__StackTop+0xdfffb700>
100010c2:	00f69423          	sh	a5,8(a3)
100010c6:	420017b7          	lui	a5,0x42001
100010ca:	a0160613          	addi	a2,a2,-1535
100010ce:	db90                	sw	a2,48(a5)
100010d0:	0ca68723          	sb	a0,206(a3)
100010d4:	02c00713          	li	a4,44
100010d8:	10e79023          	sh	a4,256(a5) # 42001100 <__StackTop+0x21ffd100>
100010dc:	22c1                	jal	1000129c <RF_OnChip_Init>
100010de:	40a2                	lw	ra,8(sp)
100010e0:	0131                	addi	sp,sp,12
100010e2:	8082                	ret

100010e4 <rf_get_ad_pll_counter>:
100010e4:	1131                	addi	sp,sp,-20
100010e6:	c806                	sw	ra,16(sp)
100010e8:	c622                	sw	s0,12(sp)
100010ea:	c426                	sw	s1,8(sp)
100010ec:	c02a                	sw	a0,0(sp)
100010ee:	c22e                	sw	a1,4(sp)
100010f0:	4415                	li	s0,5
100010f2:	4481                	li	s1,0
100010f4:	400006b7          	lui	a3,0x40000
100010f8:	1846a783          	lw	a5,388(a3) # 40000184 <__StackTop+0x1fffc184>
100010fc:	7741                	lui	a4,0xffff0
100010fe:	8ff9                	and	a5,a5,a4
10001100:	4712                	lw	a4,4(sp)
10001102:	8fd9                	or	a5,a5,a4
10001104:	18f6a223          	sw	a5,388(a3)
10001108:	4502                	lw	a0,0(sp)
1000110a:	10000097          	auipc	ra,0x10000
1000110e:	89c080e7          	jalr	-1892(ra) # 200009a6 <_rf_kvco_read_y>
10001112:	94aa                	add	s1,s1,a0
10001114:	147d                	addi	s0,s0,-1
10001116:	fc79                	bnez	s0,100010f4 <rf_get_ad_pll_counter+0x10>
10001118:	4515                	li	a0,5
1000111a:	02a4d533          	divu	a0,s1,a0
1000111e:	40c2                	lw	ra,16(sp)
10001120:	4432                	lw	s0,12(sp)
10001122:	44a2                	lw	s1,8(sp)
10001124:	0151                	addi	sp,sp,20
10001126:	8082                	ret

10001128 <omw_rf_set_tx_pwr_lvl>:
10001128:	200017b7          	lui	a5,0x20001
1000112c:	42d78783          	lb	a5,1069(a5) # 2000142d <g_rf_cfg+0x9>
10001130:	953e                	add	a0,a0,a5
10001132:	57a5                	li	a5,-23
10001134:	00f55363          	bge	a0,a5,1000113a <omw_rf_set_tx_pwr_lvl+0x12>
10001138:	5525                	li	a0,-23
1000113a:	47b5                	li	a5,13
1000113c:	00a7d363          	bge	a5,a0,10001142 <omw_rf_set_tx_pwr_lvl+0x1a>
10001140:	4535                	li	a0,13
10001142:	01750793          	addi	a5,a0,23
10001146:	0ff7f793          	zext.b	a5,a5
1000114a:	20001737          	lui	a4,0x20001
1000114e:	42674683          	lbu	a3,1062(a4) # 20001426 <g_rf_cfg+0x2>
10001152:	01968593          	addi	a1,a3,25
10001156:	0ff5f593          	zext.b	a1,a1
1000115a:	02100713          	li	a4,33
1000115e:	4601                	li	a2,0
10001160:	00f77d63          	bgeu	a4,a5,1000117a <omw_rf_set_tx_pwr_lvl+0x52>
10001164:	fde78713          	addi	a4,a5,-34
10001168:	00171613          	slli	a2,a4,0x1
1000116c:	20000737          	lui	a4,0x20000
10001170:	43870713          	addi	a4,a4,1080 # 20000438 <rf_pwr_lvl_map_1>
10001174:	9732                	add	a4,a4,a2
10001176:	00075603          	lhu	a2,0(a4)
1000117a:	00561713          	slli	a4,a2,0x5
1000117e:	80077713          	andi	a4,a4,-2048
10001182:	03f67613          	andi	a2,a2,63
10001186:	8e59                	or	a2,a2,a4
10001188:	00168713          	addi	a4,a3,1
1000118c:	072e                	slli	a4,a4,0xb
1000118e:	06be                	slli	a3,a3,0xf
10001190:	8ecd                	or	a3,a3,a1
10001192:	8ed9                	or	a3,a3,a4
10001194:	00c68733          	add	a4,a3,a2
10001198:	00179693          	slli	a3,a5,0x1
1000119c:	200007b7          	lui	a5,0x20000
100011a0:	3ec78793          	addi	a5,a5,1004 # 200003ec <rf_pwr_lvl_map_0>
100011a4:	97b6                	add	a5,a5,a3
100011a6:	0007d783          	lhu	a5,0(a5)
100011aa:	420026b7          	lui	a3,0x42002
100011ae:	08c6a583          	lw	a1,140(a3) # 4200208c <__StackTop+0x21ffe08c>
100011b2:	03f7f613          	andi	a2,a5,63
100011b6:	fffc0537          	lui	a0,0xfffc0
100011ba:	7c050513          	addi	a0,a0,1984 # fffc07c0 <__StackTop+0xdffbc7c0>
100011be:	8de9                	and	a1,a1,a0
100011c0:	8e4d                	or	a2,a2,a1
100011c2:	0796                	slli	a5,a5,0x5
100011c4:	8007f793          	andi	a5,a5,-2048
100011c8:	8fd1                	or	a5,a5,a2
100011ca:	08f6a623          	sw	a5,140(a3)
100011ce:	469c                	lw	a5,8(a3)
100011d0:	fff80637          	lui	a2,0xfff80
100011d4:	7c060613          	addi	a2,a2,1984 # fff807c0 <__StackTop+0xdff7c7c0>
100011d8:	8ff1                	and	a5,a5,a2
100011da:	8fd9                	or	a5,a5,a4
100011dc:	c69c                	sw	a5,8(a3)
100011de:	200007b7          	lui	a5,0x20000
100011e2:	35478793          	addi	a5,a5,852 # 20000354 <rf_common_desc_tx_setfreq>
100011e6:	00b75693          	srli	a3,a4,0xb
100011ea:	8abd                	andi	a3,a3,15
100011ec:	06ce                	slli	a3,a3,0x13
100011ee:	5bcc                	lw	a1,52(a5)
100011f0:	ff010637          	lui	a2,0xff010
100011f4:	167d                	addi	a2,a2,-1 # ff00ffff <__StackTop+0xdf00bfff>
100011f6:	8df1                	and	a1,a1,a2
100011f8:	8ecd                	or	a3,a3,a1
100011fa:	dbd4                	sw	a3,52(a5)
100011fc:	00f75693          	srli	a3,a4,0xf
10001200:	8a85                	andi	a3,a3,1
10001202:	06de                	slli	a3,a3,0x17
10001204:	5fcc                	lw	a1,60(a5)
10001206:	8df1                	and	a1,a1,a2
10001208:	8ecd                	or	a3,a3,a1
1000120a:	dfd4                	sw	a3,60(a5)
1000120c:	000706b7          	lui	a3,0x70
10001210:	8f75                	and	a4,a4,a3
10001212:	43f4                	lw	a3,68(a5)
10001214:	8e75                	and	a2,a2,a3
10001216:	8f51                	or	a4,a4,a2
10001218:	c3f8                	sw	a4,68(a5)
1000121a:	4501                	li	a0,0
1000121c:	8082                	ret

1000121e <PMU_OnChip_Init>:
1000121e:	1151                	addi	sp,sp,-12
10001220:	c406                	sw	ra,8(sp)
10001222:	21a5                	jal	1000168a <omw_rf_cal>
10001224:	400807b7          	lui	a5,0x40080
10001228:	1107a703          	lw	a4,272(a5) # 40080110 <__StackTop+0x2007c110>
1000122c:	00776713          	ori	a4,a4,7
10001230:	10e7a823          	sw	a4,272(a5)
10001234:	6725                	lui	a4,0x9
10001236:	64270713          	addi	a4,a4,1602 # 9642 <ble_viot.c.e415c280+0x3fdc>
1000123a:	d3b8                	sw	a4,96(a5)
1000123c:	6719                	lui	a4,0x6
1000123e:	bab70713          	addi	a4,a4,-1109 # 5bab <ble_viot.c.e415c280+0x545>
10001242:	10e7a623          	sw	a4,268(a5)
10001246:	21290737          	lui	a4,0x21290
1000124a:	177d                	addi	a4,a4,-1 # 2128ffff <__StackTop+0x128bfff>
1000124c:	c798                	sw	a4,8(a5)
1000124e:	1107a703          	lw	a4,272(a5)
10001252:	ff0386b7          	lui	a3,0xff038
10001256:	7ff68693          	addi	a3,a3,2047 # ff0387ff <__StackTop+0xdf0347ff>
1000125a:	8f75                	and	a4,a4,a3
1000125c:	00d046b7          	lui	a3,0xd04
10001260:	8f55                	or	a4,a4,a3
10001262:	10e7a823          	sw	a4,272(a5)
10001266:	40a2                	lw	ra,8(sp)
10001268:	0131                	addi	sp,sp,12
1000126a:	8082                	ret

1000126c <Radio_OnChip_Set_Freq_Sw>:
1000126c:	0505                	addi	a0,a0,1
1000126e:	4719                	li	a4,6
10001270:	02e547b3          	div	a5,a0,a4
10001274:	0c878793          	addi	a5,a5,200
10001278:	07d2                	slli	a5,a5,0x14
1000127a:	02e56533          	rem	a0,a0,a4
1000127e:	0002b737          	lui	a4,0x2b
10001282:	aaa70713          	addi	a4,a4,-1366 # 2aaaa <ble_viot.c.e415c280+0x25444>
10001286:	02e50533          	mul	a0,a0,a4
1000128a:	8fc9                	or	a5,a5,a0
1000128c:	8385                	srli	a5,a5,0x1
1000128e:	80000737          	lui	a4,0x80000
10001292:	8fd9                	or	a5,a5,a4
10001294:	42001737          	lui	a4,0x42001
10001298:	d35c                	sw	a5,36(a4)
1000129a:	8082                	ret

1000129c <RF_OnChip_Init>:
1000129c:	fcc10113          	addi	sp,sp,-52
100012a0:	d806                	sw	ra,48(sp)
100012a2:	d622                	sw	s0,44(sp)
100012a4:	d426                	sw	s1,40(sp)
100012a6:	10000097          	auipc	ra,0x10000
100012aa:	a5a080e7          	jalr	-1446(ra) # 20000d00 <RF_OnChip_Base_Init>
100012ae:	200015b7          	lui	a1,0x20001
100012b2:	42458593          	addi	a1,a1,1060 # 20001424 <g_rf_cfg>
100012b6:	0025c703          	lbu	a4,2(a1)
100012ba:	20000537          	lui	a0,0x20000
100012be:	2b450513          	addi	a0,a0,692 # 200002b4 <rf_common_desc_rftx_on>
100012c2:	4154                	lw	a3,4(a0)
100012c4:	ff0107b7          	lui	a5,0xff010
100012c8:	17fd                	addi	a5,a5,-1 # ff00ffff <__StackTop+0xdf00bfff>
100012ca:	8efd                	and	a3,a3,a5
100012cc:	01970613          	addi	a2,a4,25 # 42001019 <__StackTop+0x21ffd019>
100012d0:	0ff67613          	zext.b	a2,a2
100012d4:	0642                	slli	a2,a2,0x10
100012d6:	8ed1                	or	a3,a3,a2
100012d8:	c154                	sw	a3,4(a0)
100012da:	20000637          	lui	a2,0x20000
100012de:	2a460613          	addi	a2,a2,676 # 200002a4 <rf_common_desc_rftx_off>
100012e2:	4254                	lw	a3,4(a2)
100012e4:	8efd                	and	a3,a3,a5
100012e6:	0055c503          	lbu	a0,5(a1)
100012ea:	0542                	slli	a0,a0,0x10
100012ec:	8ec9                	or	a3,a3,a0
100012ee:	c254                	sw	a3,4(a2)
100012f0:	20000537          	lui	a0,0x20000
100012f4:	35450613          	addi	a2,a0,852 # 20000354 <rf_common_desc_tx_setfreq>
100012f8:	4674                	lw	a3,76(a2)
100012fa:	8efd                	and	a3,a3,a5
100012fc:	0065c303          	lbu	t1,6(a1)
10001300:	0342                	slli	t1,t1,0x10
10001302:	0066e6b3          	or	a3,a3,t1
10001306:	c674                	sw	a3,76(a2)
10001308:	00170393          	addi	t2,a4,1
1000130c:	0ff3f693          	zext.b	a3,t2
10001310:	03462303          	lw	t1,52(a2)
10001314:	00f37333          	and	t1,t1,a5
10001318:	00168293          	addi	t0,a3,1 # d04001 <__ROM_SIZE+0xcc4001>
1000131c:	02ce                	slli	t0,t0,0x13
1000131e:	00536333          	or	t1,t1,t0
10001322:	02662a23          	sw	t1,52(a2)
10001326:	03c62283          	lw	t0,60(a2)
1000132a:	00f2f2b3          	and	t0,t0,a5
1000132e:	01769413          	slli	s0,a3,0x17
10001332:	00ff0337          	lui	t1,0xff0
10001336:	00647433          	and	s0,s0,t1
1000133a:	0082e2b3          	or	t0,t0,s0
1000133e:	02562e23          	sw	t0,60(a2)
10001342:	04462283          	lw	t0,68(a2)
10001346:	00f2f2b3          	and	t0,t0,a5
1000134a:	8285                	srli	a3,a3,0x1
1000134c:	06c2                	slli	a3,a3,0x10
1000134e:	00d2e6b3          	or	a3,t0,a3
10001352:	c274                	sw	a3,68(a2)
10001354:	200006b7          	lui	a3,0x20000
10001358:	2c468693          	addi	a3,a3,708 # 200002c4 <rf_common_desc_rx_setfreq>
1000135c:	0346a283          	lw	t0,52(a3)
10001360:	00f2f2b3          	and	t0,t0,a5
10001364:	03ce                	slli	t2,t2,0x13
10001366:	0072e2b3          	or	t0,t0,t2
1000136a:	0256aa23          	sw	t0,52(a3)
1000136e:	03c6a283          	lw	t0,60(a3)
10001372:	00f2f2b3          	and	t0,t0,a5
10001376:	01771393          	slli	t2,a4,0x17
1000137a:	0063f3b3          	and	t2,t2,t1
1000137e:	0072e2b3          	or	t0,t0,t2
10001382:	0256ae23          	sw	t0,60(a3)
10001386:	0446a283          	lw	t0,68(a3)
1000138a:	00f2f2b3          	and	t0,t0,a5
1000138e:	00175393          	srli	t2,a4,0x1
10001392:	03c2                	slli	t2,t2,0x10
10001394:	0072e2b3          	or	t0,t0,t2
10001398:	0456a223          	sw	t0,68(a3)
1000139c:	1779                	addi	a4,a4,-2
1000139e:	0ff77713          	zext.b	a4,a4
100013a2:	200006b7          	lui	a3,0x20000
100013a6:	28468693          	addi	a3,a3,644 # 20000284 <rf_common_desc_rfrx_on>
100013aa:	00c6a283          	lw	t0,12(a3)
100013ae:	00f2f2b3          	and	t0,t0,a5
100013b2:	01771393          	slli	t2,a4,0x17
100013b6:	0063f3b3          	and	t2,t2,t1
100013ba:	0072e2b3          	or	t0,t0,t2
100013be:	0056a623          	sw	t0,12(a3)
100013c2:	0146a283          	lw	t0,20(a3)
100013c6:	00f2f2b3          	and	t0,t0,a5
100013ca:	8305                	srli	a4,a4,0x1
100013cc:	0742                	slli	a4,a4,0x10
100013ce:	00e2e733          	or	a4,t0,a4
100013d2:	cad8                	sw	a4,20(a3)
100013d4:	0035c703          	lbu	a4,3(a1)
100013d8:	200006b7          	lui	a3,0x20000
100013dc:	26468693          	addi	a3,a3,612 # 20000264 <rf_common_desc_rfrx_off>
100013e0:	42cc                	lw	a1,4(a3)
100013e2:	8dfd                	and	a1,a1,a5
100013e4:	01771293          	slli	t0,a4,0x17
100013e8:	0062f333          	and	t1,t0,t1
100013ec:	0065e333          	or	t1,a1,t1
100013f0:	0066a223          	sw	t1,4(a3)
100013f4:	46cc                	lw	a1,12(a3)
100013f6:	8fed                	and	a5,a5,a1
100013f8:	8305                	srli	a4,a4,0x1
100013fa:	0742                	slli	a4,a4,0x10
100013fc:	8f5d                	or	a4,a4,a5
100013fe:	c6d8                	sw	a4,12(a3)
10001400:	42001737          	lui	a4,0x42001
10001404:	4b3c                	lw	a5,80(a4)
10001406:	0207e793          	ori	a5,a5,32
1000140a:	cb3c                	sw	a5,80(a4)
1000140c:	6785                	lui	a5,0x1
1000140e:	40778793          	addi	a5,a5,1031 # 1407 <main.c.5cfd7a5a+0xa8d>
10001412:	02f11223          	sh	a5,36(sp)
10001416:	02100793          	li	a5,33
1000141a:	02f10323          	sb	a5,38(sp)
1000141e:	420027b7          	lui	a5,0x42002
10001422:	60600713          	li	a4,1542
10001426:	cbd8                	sw	a4,20(a5)
10001428:	400006b7          	lui	a3,0x40000
1000142c:	1846a783          	lw	a5,388(a3) # 40000184 <__StackTop+0x1fffc184>
10001430:	7701                	lui	a4,0xfffe0
10001432:	8ff9                	and	a5,a5,a4
10001434:	6741                	lui	a4,0x10
10001436:	20070713          	addi	a4,a4,512 # 10200 <ble_viot.c.e415c280+0xab9a>
1000143a:	8fd9                	or	a5,a5,a4
1000143c:	18f6a223          	sw	a5,388(a3)
10001440:	8660b7b7          	lui	a5,0x8660b
10001444:	53878793          	addi	a5,a5,1336 # 8660b538 <__StackTop+0x66607538>
10001448:	c21c                	sw	a5,0(a2)
1000144a:	35450513          	addi	a0,a0,852
1000144e:	0ffff097          	auipc	ra,0xffff
10001452:	5f4080e7          	jalr	1524(ra) # 20000a42 <start_await_dma>
10001456:	200017b7          	lui	a5,0x20001
1000145a:	41078793          	addi	a5,a5,1040 # 20001410 <g_hp>
1000145e:	cc3e                	sw	a5,24(sp)
10001460:	105c                	addi	a5,sp,36
10001462:	ce3e                	sw	a5,28(sp)
10001464:	6785                	lui	a5,0x1
10001466:	80078793          	addi	a5,a5,-2048 # 800 <__STACK_SIZE+0x500>
1000146a:	d03e                	sw	a5,32(sp)
1000146c:	a29d                	j	100015d2 <RF_OnChip_Init+0x336>
1000146e:	4789                	li	a5,2
10001470:	4702                	lw	a4,0(sp)
10001472:	12e7c463          	blt	a5,a4,1000159a <RF_OnChip_Init+0x2fe>
10001476:	47f2                	lw	a5,28(sp)
10001478:	0007c503          	lbu	a0,0(a5)
1000147c:	3bc5                	jal	1000126c <Radio_OnChip_Set_Freq_Sw>
1000147e:	42002437          	lui	s0,0x42002
10001482:	00042c23          	sw	zero,24(s0) # 42002018 <__StackTop+0x21ffe018>
10001486:	4785                	li	a5,1
10001488:	cc1c                	sw	a5,24(s0)
1000148a:	470d                	li	a4,3
1000148c:	cc18                	sw	a4,24(s0)
1000148e:	cc1c                	sw	a5,24(s0)
10001490:	0c800513          	li	a0,200
10001494:	0ffff097          	auipc	ra,0xffff
10001498:	0b6080e7          	jalr	182(ra) # 2000054a <delay_us>
1000149c:	4c5c                	lw	a5,28(s0)
1000149e:	0002c737          	lui	a4,0x2c
100014a2:	8fd9                	or	a5,a5,a4
100014a4:	cc5c                	sw	a5,28(s0)
100014a6:	67a5                	lui	a5,0x9
100014a8:	80278793          	addi	a5,a5,-2046 # 8802 <ble_viot.c.e415c280+0x319c>
100014ac:	0cf42a23          	sw	a5,212(s0)
100014b0:	4c5c                	lw	a5,28(s0)
100014b2:	83b9                	srli	a5,a5,0xe
100014b4:	8b8d                	andi	a5,a5,3
100014b6:	5702                	lw	a4,32(sp)
100014b8:	00f714b3          	sll	s1,a4,a5
100014bc:	01049713          	slli	a4,s1,0x10
100014c0:	8341                	srli	a4,a4,0x10
100014c2:	19c00593          	li	a1,412
100014c6:	c23a                	sw	a4,4(sp)
100014c8:	853a                	mv	a0,a4
100014ca:	3929                	jal	100010e4 <rf_get_ad_pll_counter>
100014cc:	c42a                	sw	a0,8(sp)
100014ce:	26400593          	li	a1,612
100014d2:	4512                	lw	a0,4(sp)
100014d4:	3901                	jal	100010e4 <rf_get_ad_pll_counter>
100014d6:	4c5c                	lw	a5,28(s0)
100014d8:	7701                	lui	a4,0xfffe0
100014da:	177d                	addi	a4,a4,-1 # fffdffff <__StackTop+0xdffdbfff>
100014dc:	8ff9                	and	a5,a5,a4
100014de:	cc5c                	sw	a5,28(s0)
100014e0:	67a5                	lui	a5,0x9
100014e2:	81978793          	addi	a5,a5,-2023 # 8819 <ble_viot.c.e415c280+0x31b3>
100014e6:	0cf42a23          	sw	a5,212(s0)
100014ea:	47a2                	lw	a5,8(sp)
100014ec:	8d1d                	sub	a0,a0,a5
100014ee:	00151793          	slli	a5,a0,0x1
100014f2:	953e                	add	a0,a0,a5
100014f4:	050a                	slli	a0,a0,0x2
100014f6:	00549713          	slli	a4,s1,0x5
100014fa:	8f05                	sub	a4,a4,s1
100014fc:	070a                	slli	a4,a4,0x2
100014fe:	9726                	add	a4,a4,s1
10001500:	02a75733          	divu	a4,a4,a0
10001504:	4329                	li	t1,10
10001506:	026777b3          	remu	a5,a4,t1
1000150a:	0057b793          	sltiu	a5,a5,5
1000150e:	0017c793          	xori	a5,a5,1
10001512:	02675733          	divu	a4,a4,t1
10001516:	973e                	add	a4,a4,a5
10001518:	0ff77713          	zext.b	a4,a4
1000151c:	4462                	lw	s0,24(sp)
1000151e:	85a2                	mv	a1,s0
10001520:	00e40123          	sb	a4,2(s0)
10001524:	0fa00793          	li	a5,250
10001528:	02f487b3          	mul	a5,s1,a5
1000152c:	02a7d7b3          	divu	a5,a5,a0
10001530:	0267f6b3          	remu	a3,a5,t1
10001534:	0056b693          	sltiu	a3,a3,5
10001538:	0016c693          	xori	a3,a3,1
1000153c:	0267d7b3          	divu	a5,a5,t1
10001540:	97b6                	add	a5,a5,a3
10001542:	0ff7f693          	zext.b	a3,a5
10001546:	00d40023          	sb	a3,0(s0)
1000154a:	1f400793          	li	a5,500
1000154e:	02f487b3          	mul	a5,s1,a5
10001552:	02a7d7b3          	divu	a5,a5,a0
10001556:	0267f633          	remu	a2,a5,t1
1000155a:	00563613          	sltiu	a2,a2,5
1000155e:	00164613          	xori	a2,a2,1
10001562:	0267d7b3          	divu	a5,a5,t1
10001566:	97b2                	add	a5,a5,a2
10001568:	0ff7f793          	zext.b	a5,a5
1000156c:	00f400a3          	sb	a5,1(s0)
10001570:	fc068613          	addi	a2,a3,-64
10001574:	0ff67613          	zext.b	a2,a2
10001578:	03f00513          	li	a0,63
1000157c:	eec569e3          	bltu	a0,a2,1000146e <RF_OnChip_Init+0x1d2>
10001580:	4632                	lw	a2,12(sp)
10001582:	96b2                	add	a3,a3,a2
10001584:	c636                	sw	a3,12(sp)
10001586:	46c2                	lw	a3,16(sp)
10001588:	97b6                	add	a5,a5,a3
1000158a:	c83e                	sw	a5,16(sp)
1000158c:	47d2                	lw	a5,20(sp)
1000158e:	97ba                	add	a5,a5,a4
10001590:	ca3e                	sw	a5,20(sp)
10001592:	4782                	lw	a5,0(sp)
10001594:	0785                	addi	a5,a5,1
10001596:	c03e                	sw	a5,0(sp)
10001598:	bdd9                	j	1000146e <RF_OnChip_Init+0x1d2>
1000159a:	478d                	li	a5,3
1000159c:	4732                	lw	a4,12(sp)
1000159e:	02f75733          	divu	a4,a4,a5
100015a2:	00e58023          	sb	a4,0(a1)
100015a6:	4742                	lw	a4,16(sp)
100015a8:	02f75733          	divu	a4,a4,a5
100015ac:	00e580a3          	sb	a4,1(a1)
100015b0:	4752                	lw	a4,20(sp)
100015b2:	02f757b3          	divu	a5,a4,a5
100015b6:	00f58123          	sb	a5,2(a1)
100015ba:	47e2                	lw	a5,24(sp)
100015bc:	078d                	addi	a5,a5,3
100015be:	cc3e                	sw	a5,24(sp)
100015c0:	4772                	lw	a4,28(sp)
100015c2:	0705                	addi	a4,a4,1
100015c4:	ce3a                	sw	a4,28(sp)
100015c6:	20001737          	lui	a4,0x20001
100015ca:	41970713          	addi	a4,a4,1049 # 20001419 <g_hp+0x9>
100015ce:	00e78763          	beq	a5,a4,100015dc <RF_OnChip_Init+0x340>
100015d2:	c002                	sw	zero,0(sp)
100015d4:	ca02                	sw	zero,20(sp)
100015d6:	c802                	sw	zero,16(sp)
100015d8:	c602                	sw	zero,12(sp)
100015da:	bd71                	j	10001476 <RF_OnChip_Init+0x1da>
100015dc:	20000537          	lui	a0,0x20000
100015e0:	2a450513          	addi	a0,a0,676 # 200002a4 <rf_common_desc_rftx_off>
100015e4:	0ffff097          	auipc	ra,0xffff
100015e8:	45e080e7          	jalr	1118(ra) # 20000a42 <start_await_dma>
100015ec:	40000737          	lui	a4,0x40000
100015f0:	18472783          	lw	a5,388(a4) # 40000184 <__StackTop+0x1fffc184>
100015f4:	7681                	lui	a3,0xfffe0
100015f6:	8ff5                	and	a5,a5,a3
100015f8:	2007e793          	ori	a5,a5,512
100015fc:	18f72223          	sw	a5,388(a4)
10001600:	420027b7          	lui	a5,0x42002
10001604:	471d                	li	a4,7
10001606:	cbd8                	sw	a4,20(a5)
10001608:	0ffff097          	auipc	ra,0xffff
1000160c:	3ee080e7          	jalr	1006(ra) # 200009f6 <trigger_gpadc_temp_sampling>
10001610:	4529                	li	a0,10
10001612:	0ffff097          	auipc	ra,0xffff
10001616:	f38080e7          	jalr	-200(ra) # 2000054a <delay_us>
1000161a:	400407b7          	lui	a5,0x40040
1000161e:	57f8                	lw	a4,108(a5)
10001620:	200017b7          	lui	a5,0x20001
10001624:	42e78623          	sb	a4,1068(a5) # 2000142c <g_rf_cfg+0x8>
10001628:	2829                	jal	10001642 <disable_gpadc>
1000162a:	0ffff097          	auipc	ra,0xffff
1000162e:	790080e7          	jalr	1936(ra) # 20000dba <RF_OnChip_Cali_Cfg>
10001632:	4501                	li	a0,0
10001634:	3cd5                	jal	10001128 <omw_rf_set_tx_pwr_lvl>
10001636:	50c2                	lw	ra,48(sp)
10001638:	5432                	lw	s0,44(sp)
1000163a:	54a2                	lw	s1,40(sp)
1000163c:	03410113          	addi	sp,sp,52
10001640:	8082                	ret

10001642 <disable_gpadc>:
10001642:	420027b7          	lui	a5,0x42002
10001646:	0e87a703          	lw	a4,232(a5) # 420020e8 <__StackTop+0x21ffe0e8>
1000164a:	9b79                	andi	a4,a4,-2
1000164c:	0ee7a423          	sw	a4,232(a5)
10001650:	40040737          	lui	a4,0x40040
10001654:	00072023          	sw	zero,0(a4) # 40040000 <__StackTop+0x2003c000>
10001658:	43d8                	lw	a4,4(a5)
1000165a:	9b79                	andi	a4,a4,-2
1000165c:	c3d8                	sw	a4,4(a5)
1000165e:	8082                	ret

10001660 <get_vtrim>:
10001660:	c609                	beqz	a2,1000166a <get_vtrim+0xa>
10001662:	479d                	li	a5,7
10001664:	00a7d363          	bge	a5,a0,1000166a <get_vtrim+0xa>
10001668:	1541                	addi	a0,a0,-16
1000166a:	952e                	add	a0,a0,a1
1000166c:	00c54663          	blt	a0,a2,10001678 <get_vtrim+0x18>
10001670:	063d                	addi	a2,a2,15
10001672:	00c55363          	bge	a0,a2,10001678 <get_vtrim+0x18>
10001676:	862a                	mv	a2,a0
10001678:	0641                	addi	a2,a2,16
1000167a:	41f65513          	srai	a0,a2,0x1f
1000167e:	8171                	srli	a0,a0,0x1c
10001680:	962a                	add	a2,a2,a0
10001682:	8a3d                	andi	a2,a2,15
10001684:	40a60533          	sub	a0,a2,a0
10001688:	8082                	ret

1000168a <omw_rf_cal>:
1000168a:	1131                	addi	sp,sp,-20
1000168c:	c806                	sw	ra,16(sp)
1000168e:	c622                	sw	s0,12(sp)
10001690:	c426                	sw	s1,8(sp)
10001692:	200017b7          	lui	a5,0x20001
10001696:	31b7c703          	lbu	a4,795(a5) # 2000131b <g_otp_cfg+0x2f>
1000169a:	8b3d                	andi	a4,a4,15
1000169c:	479d                	li	a5,7
1000169e:	0ee7fb63          	bgeu	a5,a4,10001794 <omw_rf_cal+0x10a>
100016a2:	ff070793          	addi	a5,a4,-16
100016a6:	0ff7f693          	zext.b	a3,a5
100016aa:	200015b7          	lui	a1,0x20001
100016ae:	42458593          	addi	a1,a1,1060 # 20001424 <g_rf_cfg>
100016b2:	00f585a3          	sb	a5,11(a1)
100016b6:	1755                	addi	a4,a4,-11
100016b8:	0ff77613          	zext.b	a2,a4
100016bc:	00c581a3          	sb	a2,3(a1)
100016c0:	0f000713          	li	a4,240
100016c4:	0ec77463          	bgeu	a4,a2,100017ac <omw_rf_cal+0x122>
100016c8:	4701                	li	a4,0
100016ca:	20001637          	lui	a2,0x20001
100016ce:	42e60323          	sb	a4,1062(a2) # 20001426 <g_rf_cfg+0x2>
100016d2:	00378713          	addi	a4,a5,3
100016d6:	0706                	slli	a4,a4,0x1
100016d8:	0ff77713          	zext.b	a4,a4
100016dc:	0f000613          	li	a2,240
100016e0:	4581                	li	a1,0
100016e2:	00e66963          	bltu	a2,a4,100016f4 <omw_rf_cal+0x6a>
100016e6:	85ba                	mv	a1,a4
100016e8:	467d                	li	a2,31
100016ea:	00e67363          	bgeu	a2,a4,100016f0 <omw_rf_cal+0x66>
100016ee:	45fd                	li	a1,31
100016f0:	0ff5f593          	zext.b	a1,a1
100016f4:	20001637          	lui	a2,0x20001
100016f8:	42460613          	addi	a2,a2,1060 # 20001424 <g_rf_cfg>
100016fc:	00b60223          	sb	a1,4(a2)
10001700:	00169713          	slli	a4,a3,0x1
10001704:	0ff77713          	zext.b	a4,a4
10001708:	00770693          	addi	a3,a4,7
1000170c:	00d602a3          	sb	a3,5(a2)
10001710:	07b1                	addi	a5,a5,12
10001712:	0786                	slli	a5,a5,0x1
10001714:	00f60323          	sb	a5,6(a2)
10001718:	0715                	addi	a4,a4,5
1000171a:	00e603a3          	sb	a4,7(a2)
1000171e:	200017b7          	lui	a5,0x20001
10001722:	3187a783          	lw	a5,792(a5) # 20001318 <g_otp_cfg+0x2c>
10001726:	83d1                	srli	a5,a5,0x14
10001728:	8bbd                	andi	a5,a5,15
1000172a:	471d                	li	a4,7
1000172c:	08f77863          	bgeu	a4,a5,100017bc <omw_rf_cal+0x132>
10001730:	17c1                	addi	a5,a5,-16
10001732:	01879493          	slli	s1,a5,0x18
10001736:	84e1                	srai	s1,s1,0x18
10001738:	20001437          	lui	s0,0x20001
1000173c:	42440413          	addi	s0,s0,1060 # 20001424 <g_rf_cfg>
10001740:	00940523          	sb	s1,10(s0)
10001744:	200017b7          	lui	a5,0x20001
10001748:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
1000174c:	c03e                	sw	a5,0(sp)
1000174e:	4398                	lw	a4,0(a5)
10001750:	4601                	li	a2,0
10001752:	85a6                	mv	a1,s1
10001754:	c23a                	sw	a4,4(sp)
10001756:	00f77513          	andi	a0,a4,15
1000175a:	3719                	jal	10001660 <get_vtrim>
1000175c:	00a40023          	sb	a0,0(s0)
10001760:	4712                	lw	a4,4(sp)
10001762:	01075513          	srli	a0,a4,0x10
10001766:	5661                	li	a2,-8
10001768:	85a6                	mv	a1,s1
1000176a:	893d                	andi	a0,a0,15
1000176c:	3dd5                	jal	10001660 <get_vtrim>
1000176e:	00a400a3          	sb	a0,1(s0)
10001772:	478d                	li	a5,3
10001774:	00f404a3          	sb	a5,9(s0)
10001778:	4782                	lw	a5,0(sp)
1000177a:	5bd0                	lw	a2,52(a5)
1000177c:	0652                	slli	a2,a2,0x14
1000177e:	8251                	srli	a2,a2,0x14
10001780:	100027b7          	lui	a5,0x10002
10001784:	f4878793          	addi	a5,a5,-184 # 10001f48 <rssi_thresholds>
10001788:	00c78593          	addi	a1,a5,12
1000178c:	4501                	li	a0,0
1000178e:	470d                	li	a4,3
10001790:	4305                	li	t1,1
10001792:	a825                	j	100017ca <omw_rf_cal+0x140>
10001794:	200015b7          	lui	a1,0x20001
10001798:	42458593          	addi	a1,a1,1060 # 20001424 <g_rf_cfg>
1000179c:	00e585a3          	sb	a4,11(a1)
100017a0:	87ba                	mv	a5,a4
100017a2:	86ba                	mv	a3,a4
100017a4:	00570613          	addi	a2,a4,5
100017a8:	00c581a3          	sb	a2,3(a1)
100017ac:	8732                	mv	a4,a2
100017ae:	45bd                	li	a1,15
100017b0:	00c5f363          	bgeu	a1,a2,100017b6 <omw_rf_cal+0x12c>
100017b4:	473d                	li	a4,15
100017b6:	0ff77713          	zext.b	a4,a4
100017ba:	bf01                	j	100016ca <omw_rf_cal+0x40>
100017bc:	01879493          	slli	s1,a5,0x18
100017c0:	84e1                	srai	s1,s1,0x18
100017c2:	bf9d                	j	10001738 <omw_rf_cal+0xae>
100017c4:	0789                	addi	a5,a5,2
100017c6:	00b78b63          	beq	a5,a1,100017dc <omw_rf_cal+0x152>
100017ca:	0007d683          	lhu	a3,0(a5)
100017ce:	fed64be3          	blt	a2,a3,100017c4 <omw_rf_cal+0x13a>
100017d2:	177d                	addi	a4,a4,-1
100017d4:	0762                	slli	a4,a4,0x18
100017d6:	8761                	srai	a4,a4,0x18
100017d8:	851a                	mv	a0,t1
100017da:	b7ed                	j	100017c4 <omw_rf_cal+0x13a>
100017dc:	c509                	beqz	a0,100017e6 <omw_rf_cal+0x15c>
100017de:	200017b7          	lui	a5,0x20001
100017e2:	42e786a3          	sb	a4,1069(a5) # 2000142d <g_rf_cfg+0x9>
100017e6:	40c2                	lw	ra,16(sp)
100017e8:	4432                	lw	s0,12(sp)
100017ea:	44a2                	lw	s1,8(sp)
100017ec:	0151                	addi	sp,sp,20
100017ee:	8082                	ret

100017f0 <rf_2g4_init>:
100017f0:	715d                	addi	sp,sp,-80
100017f2:	c686                	sw	ra,76(sp)
100017f4:	c4a2                	sw	s0,72(sp)
100017f6:	30047073          	csrci	mstatus,8
100017fa:	38a1                	jal	10001052 <omw_rf_init>
100017fc:	20001737          	lui	a4,0x20001
10001800:	200017b7          	lui	a5,0x20001
10001804:	45878793          	addi	a5,a5,1112 # 20001458 <rf_2g4_rx_data_buf>
10001808:	32f72c23          	sw	a5,824(a4) # 20001338 <rf_2g4_fifo>
1000180c:	20001437          	lui	s0,0x20001
10001810:	33c40413          	addi	s0,s0,828 # 2000133c <rf_2g4_mgr>
10001814:	200017b7          	lui	a5,0x20001
10001818:	4487aa23          	sw	s0,1108(a5) # 20001454 <rf_2g4_para>
1000181c:	04300613          	li	a2,67
10001820:	4581                	li	a1,0
10001822:	850a                	mv	a0,sp
10001824:	26f1                	jal	10001bf0 <memset>
10001826:	03c00793          	li	a5,60
1000182a:	00f11023          	sh	a5,0(sp)
1000182e:	4785                	li	a5,1
10001830:	00f101a3          	sb	a5,3(sp)
10001834:	8e89c737          	lui	a4,0x8e89c
10001838:	ed670713          	addi	a4,a4,-298 # 8e89bed6 <__StackTop+0x6e897ed6>
1000183c:	c23a                	sw	a4,4(sp)
1000183e:	4711                	li	a4,4
10001840:	00e10623          	sb	a4,12(sp)
10001844:	02000713          	li	a4,32
10001848:	00e106a3          	sb	a4,13(sp)
1000184c:	04e00713          	li	a4,78
10001850:	00e10723          	sb	a4,14(sp)
10001854:	00f107a3          	sb	a5,15(sp)
10001858:	02500713          	li	a4,37
1000185c:	00e10823          	sb	a4,16(sp)
10001860:	00f10923          	sb	a5,18(sp)
10001864:	478d                	li	a5,3
10001866:	00f109a3          	sb	a5,19(sp)
1000186a:	005557b7          	lui	a5,0x555
1000186e:	55578793          	addi	a5,a5,1365 # 555555 <__ROM_SIZE+0x515555>
10001872:	ca3e                	sw	a5,20(sp)
10001874:	010007b7          	lui	a5,0x1000
10001878:	65b78793          	addi	a5,a5,1627 # 100065b <__ROM_SIZE+0xfc065b>
1000187c:	cc3e                	sw	a5,24(sp)
1000187e:	10000793          	li	a5,256
10001882:	00f11f23          	sh	a5,30(sp)
10001886:	850a                	mv	a0,sp
10001888:	f92ff0ef          	jal	1000101a <omw_svc_2g4_init>
1000188c:	4501                	li	a0,0
1000188e:	3869                	jal	10001128 <omw_rf_set_tx_pwr_lvl>
10001890:	ea4ff0ef          	jal	10000f34 <RF_2G4_PrepareStart>
10001894:	cbeff0ef          	jal	10000d52 <RF_2G4_UpdateDesc_TxPkt>
10001898:	400807b7          	lui	a5,0x40080
1000189c:	07a00713          	li	a4,122
100018a0:	c398                	sw	a4,0(a5)
100018a2:	30046073          	csrsi	mstatus,8
100018a6:	02040c23          	sb	zero,56(s0)
100018aa:	200017b7          	lui	a5,0x20001
100018ae:	44078823          	sb	zero,1104(a5) # 20001450 <current_tx_rx_switch_flag>
100018b2:	200017b7          	lui	a5,0x20001
100018b6:	54078e23          	sb	zero,1372(a5) # 2000155c <rx_restart_flag>
100018ba:	200017b7          	lui	a5,0x20001
100018be:	54078ea3          	sb	zero,1373(a5) # 2000155d <tx_restart_flag>
100018c2:	40b6                	lw	ra,76(sp)
100018c4:	4426                	lw	s0,72(sp)
100018c6:	6161                	addi	sp,sp,80
100018c8:	8082                	ret

100018ca <adv_channel_idx_to_channel_num>:
100018ca:	02500793          	li	a5,37
100018ce:	c905                	beqz	a0,100018fe <adv_channel_idx_to_channel_num+0x34>
100018d0:	fff50793          	addi	a5,a0,-1
100018d4:	0ff7f793          	zext.b	a5,a5
100018d8:	4729                	li	a4,10
100018da:	02f77263          	bgeu	a4,a5,100018fe <adv_channel_idx_to_channel_num+0x34>
100018de:	47b1                	li	a5,12
100018e0:	02f50763          	beq	a0,a5,1000190e <adv_channel_idx_to_channel_num+0x44>
100018e4:	ff350793          	addi	a5,a0,-13
100018e8:	0ff7f793          	zext.b	a5,a5
100018ec:	4765                	li	a4,25
100018ee:	00f77a63          	bgeu	a4,a5,10001902 <adv_channel_idx_to_channel_num+0x38>
100018f2:	02700713          	li	a4,39
100018f6:	02500793          	li	a5,37
100018fa:	00e50863          	beq	a0,a4,1000190a <adv_channel_idx_to_channel_num+0x40>
100018fe:	853e                	mv	a0,a5
10001900:	8082                	ret
10001902:	1579                	addi	a0,a0,-2
10001904:	0ff57793          	zext.b	a5,a0
10001908:	bfdd                	j	100018fe <adv_channel_idx_to_channel_num+0x34>
1000190a:	87aa                	mv	a5,a0
1000190c:	bfcd                	j	100018fe <adv_channel_idx_to_channel_num+0x34>
1000190e:	02600793          	li	a5,38
10001912:	b7f5                	j	100018fe <adv_channel_idx_to_channel_num+0x34>

10001914 <rf_2g4_tx_data>:
10001914:	1121                	addi	sp,sp,-24
10001916:	ca06                	sw	ra,20(sp)
10001918:	c822                	sw	s0,16(sp)
1000191a:	c626                	sw	s1,12(sp)
1000191c:	c02a                	sw	a0,0(sp)
1000191e:	c22e                	sw	a1,4(sp)
10001920:	8432                	mv	s0,a2
10001922:	200017b7          	lui	a5,0x20001
10001926:	4507c783          	lbu	a5,1104(a5) # 20001450 <current_tx_rx_switch_flag>
1000192a:	0ff7f793          	zext.b	a5,a5
1000192e:	c3d1                	beqz	a5,100019b2 <rf_2g4_tx_data+0x9e>
10001930:	200017b7          	lui	a5,0x20001
10001934:	4485                	li	s1,1
10001936:	44978823          	sb	s1,1104(a5) # 20001450 <current_tx_rx_switch_flag>
1000193a:	200017b7          	lui	a5,0x20001
1000193e:	54078e23          	sb	zero,1372(a5) # 2000155c <rx_restart_flag>
10001942:	8722                	mv	a4,s0
10001944:	0ff47793          	zext.b	a5,s0
10001948:	0786                	slli	a5,a5,0x1
1000194a:	02678793          	addi	a5,a5,38
1000194e:	20000437          	lui	s0,0x20000
10001952:	49a40413          	addi	s0,s0,1178 # 2000049a <adv_channel_idx>
10001956:	00f41023          	sh	a5,0(s0)
1000195a:	0ff77513          	zext.b	a0,a4
1000195e:	37b5                	jal	100018ca <adv_channel_idx_to_channel_num>
10001960:	200007b7          	lui	a5,0x20000
10001964:	49c78793          	addi	a5,a5,1180 # 2000049c <whiten_chl>
10001968:	00a78023          	sb	a0,0(a5)
1000196c:	20001737          	lui	a4,0x20001
10001970:	55d70713          	addi	a4,a4,1373 # 2000155d <tx_restart_flag>
10001974:	c43a                	sw	a4,8(sp)
10001976:	00970023          	sb	s1,0(a4)
1000197a:	00045603          	lhu	a2,0(s0)
1000197e:	0007c683          	lbu	a3,0(a5)
10001982:	0ff6f693          	zext.b	a3,a3
10001986:	0642                	slli	a2,a2,0x10
10001988:	8241                	srli	a2,a2,0x10
1000198a:	4592                	lw	a1,4(sp)
1000198c:	4502                	lw	a0,0(sp)
1000198e:	0ffff097          	auipc	ra,0xffff
10001992:	cd8080e7          	jalr	-808(ra) # 20000666 <omw_svc_2g4_tx_data>
10001996:	1f400513          	li	a0,500
1000199a:	0ffff097          	auipc	ra,0xffff
1000199e:	bb0080e7          	jalr	-1104(ra) # 2000054a <delay_us>
100019a2:	4722                	lw	a4,8(sp)
100019a4:	00070023          	sb	zero,0(a4)
100019a8:	40d2                	lw	ra,20(sp)
100019aa:	4442                	lw	s0,16(sp)
100019ac:	44b2                	lw	s1,12(sp)
100019ae:	0161                	addi	sp,sp,24
100019b0:	8082                	ret
100019b2:	0ffff097          	auipc	ra,0xffff
100019b6:	d52080e7          	jalr	-686(ra) # 20000704 <omw_svc_2g4_set_idle>
100019ba:	bf9d                	j	10001930 <rf_2g4_tx_data+0x1c>

100019bc <rf_2g4_set_tx_power>:
100019bc:	1151                	addi	sp,sp,-12
100019be:	c406                	sw	ra,8(sp)
100019c0:	c222                	sw	s0,4(sp)
100019c2:	842a                	mv	s0,a0
100019c4:	f64ff0ef          	jal	10001128 <omw_rf_set_tx_pwr_lvl>
100019c8:	200017b7          	lui	a5,0x20001
100019cc:	5487ac23          	sw	s0,1368(a5) # 20001558 <rf_current_power>
100019d0:	40a2                	lw	ra,8(sp)
100019d2:	4412                	lw	s0,4(sp)
100019d4:	0131                	addi	sp,sp,12
100019d6:	8082                	ret

100019d8 <t1001_sleep_restore_uart_reg_info>:
100019d8:	200006b7          	lui	a3,0x20000
100019dc:	4a468693          	addi	a3,a3,1188 # 200004a4 <uart_addr_idx_list>
100019e0:	4701                	li	a4,0
100019e2:	4615                	li	a2,5
100019e4:	431d                	li	t1,7
100019e6:	42a1                	li	t0,8
100019e8:	a835                	j	10001a24 <t1001_sleep_restore_uart_reg_info+0x4c>
100019ea:	5d7c                	lw	a5,124(a0)
100019ec:	8b85                	andi	a5,a5,1
100019ee:	c791                	beqz	a5,100019fa <t1001_sleep_restore_uart_reg_info+0x22>
100019f0:	5d7c                	lw	a5,124(a0)
100019f2:	8b85                	andi	a5,a5,1
100019f4:	dbfd                	beqz	a5,100019ea <t1001_sleep_restore_uart_reg_info+0x12>
100019f6:	5d7c                	lw	a5,124(a0)
100019f8:	bfcd                	j	100019ea <t1001_sleep_restore_uart_reg_info+0x12>
100019fa:	455c                	lw	a5,12(a0)
100019fc:	0807e793          	ori	a5,a5,128
10001a00:	c55c                	sw	a5,12(a0)
10001a02:	0006c783          	lbu	a5,0(a3)
10001a06:	078a                	slli	a5,a5,0x2
10001a08:	97aa                	add	a5,a5,a0
10001a0a:	0005a383          	lw	t2,0(a1)
10001a0e:	0077a023          	sw	t2,0(a5)
10001a12:	0705                	addi	a4,a4,1
10001a14:	0685                	addi	a3,a3,1
10001a16:	0591                	addi	a1,a1,4
10001a18:	a031                	j	10001a24 <t1001_sleep_restore_uart_reg_info+0x4c>
10001a1a:	0705                	addi	a4,a4,1
10001a1c:	0685                	addi	a3,a3,1
10001a1e:	0591                	addi	a1,a1,4
10001a20:	02570363          	beq	a4,t0,10001a46 <t1001_sleep_restore_uart_reg_info+0x6e>
10001a24:	fcc703e3          	beq	a4,a2,100019ea <t1001_sleep_restore_uart_reg_info+0x12>
10001a28:	0006c783          	lbu	a5,0(a3)
10001a2c:	078a                	slli	a5,a5,0x2
10001a2e:	97aa                	add	a5,a5,a0
10001a30:	0005a383          	lw	t2,0(a1)
10001a34:	0077a023          	sw	t2,0(a5)
10001a38:	fe6711e3          	bne	a4,t1,10001a1a <t1001_sleep_restore_uart_reg_info+0x42>
10001a3c:	455c                	lw	a5,12(a0)
10001a3e:	f7f7f793          	andi	a5,a5,-129
10001a42:	c55c                	sw	a5,12(a0)
10001a44:	8082                	ret
10001a46:	8082                	ret

10001a48 <enter_sleep_mode>:
10001a48:	f9410113          	addi	sp,sp,-108
10001a4c:	d486                	sw	ra,104(sp)
10001a4e:	d2a2                	sw	s0,100(sp)
10001a50:	d0a6                	sw	s1,96(sp)
10001a52:	200017b7          	lui	a5,0x20001
10001a56:	4705                	li	a4,1
10001a58:	44e78423          	sb	a4,1096(a5) # 20001448 <has_flash>
10001a5c:	200007b7          	lui	a5,0x20000
10001a60:	4729                	li	a4,10
10001a62:	48e78c23          	sb	a4,1176(a5) # 20000498 <gpio_vdd_pin1>
10001a66:	200007b7          	lui	a5,0x20000
10001a6a:	577d                	li	a4,-1
10001a6c:	48e78ca3          	sb	a4,1177(a5) # 20000499 <gpio_vdd_pin2>
10001a70:	20001737          	lui	a4,0x20001
10001a74:	200016b7          	lui	a3,0x20001
10001a78:	55d74783          	lbu	a5,1373(a4) # 2000155d <tx_restart_flag>
10001a7c:	0ff7f793          	zext.b	a5,a5
10001a80:	ffe5                	bnez	a5,10001a78 <enter_sleep_mode+0x30>
10001a82:	55c6c783          	lbu	a5,1372(a3) # 2000155c <rx_restart_flag>
10001a86:	0ff7f793          	zext.b	a5,a5
10001a8a:	f7fd                	bnez	a5,10001a78 <enter_sleep_mode+0x30>
10001a8c:	0ffff097          	auipc	ra,0xffff
10001a90:	c78080e7          	jalr	-904(ra) # 20000704 <omw_svc_2g4_set_idle>
10001a94:	30047073          	csrci	mstatus,8
10001a98:	1018                	addi	a4,sp,32
10001a9a:	200017b7          	lui	a5,0x20001
10001a9e:	56e7a023          	sw	a4,1376(a5) # 20001560 <g_save_buf>
10001aa2:	200017b7          	lui	a5,0x20001
10001aa6:	000336b7          	lui	a3,0x33
10001aaa:	56d7a623          	sw	a3,1388(a5) # 2000156c <unused_gpio_mask_when_sleep>
10001aae:	200017b7          	lui	a5,0x20001
10001ab2:	5627a423          	sw	sp,1384(a5) # 20001568 <uart0_save_buf>
10001ab6:	100027b7          	lui	a5,0x10002
10001aba:	f5478413          	addi	s0,a5,-172 # 10001f54 <addr_list>
10001abe:	04040493          	addi	s1,s0,64
10001ac2:	f5478793          	addi	a5,a5,-172
10001ac6:	4394                	lw	a3,0(a5)
10001ac8:	4294                	lw	a3,0(a3)
10001aca:	c314                	sw	a3,0(a4)
10001acc:	0791                	addi	a5,a5,4
10001ace:	0711                	addi	a4,a4,4
10001ad0:	fe979be3          	bne	a5,s1,10001ac6 <enter_sleep_mode+0x7e>
10001ad4:	20000637          	lui	a2,0x20000
10001ad8:	4a460613          	addi	a2,a2,1188 # 200004a4 <uart_addr_idx_list>
10001adc:	858a                	mv	a1,sp
10001ade:	4685                	li	a3,1
10001ae0:	4519                	li	a0,6
10001ae2:	41001737          	lui	a4,0x41001
10001ae6:	431d                	li	t1,7
10001ae8:	a035                	j	10001b14 <enter_sleep_mode+0xcc>
10001aea:	5f7c                	lw	a5,124(a4)
10001aec:	8b85                	andi	a5,a5,1
10001aee:	c791                	beqz	a5,10001afa <enter_sleep_mode+0xb2>
10001af0:	5f7c                	lw	a5,124(a4)
10001af2:	8b85                	andi	a5,a5,1
10001af4:	dbfd                	beqz	a5,10001aea <enter_sleep_mode+0xa2>
10001af6:	5f7c                	lw	a5,124(a4)
10001af8:	bfcd                	j	10001aea <enter_sleep_mode+0xa2>
10001afa:	475c                	lw	a5,12(a4)
10001afc:	0807e793          	ori	a5,a5,128
10001b00:	c75c                	sw	a5,12(a4)
10001b02:	00064783          	lbu	a5,0(a2)
10001b06:	078a                	slli	a5,a5,0x2
10001b08:	97ba                	add	a5,a5,a4
10001b0a:	439c                	lw	a5,0(a5)
10001b0c:	c19c                	sw	a5,0(a1)
10001b0e:	0685                	addi	a3,a3,1 # 33001 <ble_viot.c.e415c280+0x2d99b>
10001b10:	0605                	addi	a2,a2,1
10001b12:	0591                	addi	a1,a1,4
10001b14:	fca68be3          	beq	a3,a0,10001aea <enter_sleep_mode+0xa2>
10001b18:	00064783          	lbu	a5,0(a2)
10001b1c:	078a                	slli	a5,a5,0x2
10001b1e:	97ba                	add	a5,a5,a4
10001b20:	439c                	lw	a5,0(a5)
10001b22:	c19c                	sw	a5,0(a1)
10001b24:	fed375e3          	bgeu	t1,a3,10001b0e <enter_sleep_mode+0xc6>
10001b28:	400807b7          	lui	a5,0x40080
10001b2c:	3ff00713          	li	a4,1023
10001b30:	08e79223          	sh	a4,132(a5) # 40080084 <__StackTop+0x2007c084>
10001b34:	01000737          	lui	a4,0x1000
10001b38:	cf98                	sw	a4,24(a5)
10001b3a:	0ffff097          	auipc	ra,0xffff
10001b3e:	37c080e7          	jalr	892(ra) # 20000eb6 <T1001_ChipSleepCriticalWork>
10001b42:	30047073          	csrci	mstatus,8
10001b46:	200017b7          	lui	a5,0x20001
10001b4a:	5687a583          	lw	a1,1384(a5) # 20001568 <uart0_save_buf>
10001b4e:	41001537          	lui	a0,0x41001
10001b52:	3559                	jal	100019d8 <t1001_sleep_restore_uart_reg_info>
10001b54:	200017b7          	lui	a5,0x20001
10001b58:	5607a783          	lw	a5,1376(a5) # 20001560 <g_save_buf>
10001b5c:	4394                	lw	a3,0(a5)
10001b5e:	4018                	lw	a4,0(s0)
10001b60:	c314                	sw	a3,0(a4)
10001b62:	0411                	addi	s0,s0,4
10001b64:	0791                	addi	a5,a5,4
10001b66:	fe941be3          	bne	s0,s1,10001b5c <enter_sleep_mode+0x114>
10001b6a:	40080737          	lui	a4,0x40080
10001b6e:	08075783          	lhu	a5,128(a4) # 40080080 <__StackTop+0x2007c080>
10001b72:	07c2                	slli	a5,a5,0x10
10001b74:	83c1                	srli	a5,a5,0x10
10001b76:	200016b7          	lui	a3,0x20001
10001b7a:	56f6a223          	sw	a5,1380(a3) # 20001564 <sleep_wakeup_reason>
10001b7e:	3ff00793          	li	a5,1023
10001b82:	08f71223          	sh	a5,132(a4)
10001b86:	30046073          	csrsi	mstatus,8
10001b8a:	0ffff097          	auipc	ra,0xffff
10001b8e:	b7a080e7          	jalr	-1158(ra) # 20000704 <omw_svc_2g4_set_idle>
10001b92:	4701                	li	a4,0
10001b94:	e08005b7          	lui	a1,0xe0800
10001b98:	4605                	li	a2,1
10001b9a:	03000693          	li	a3,48
10001b9e:	40070793          	addi	a5,a4,1024
10001ba2:	078a                	slli	a5,a5,0x2
10001ba4:	97ae                	add	a5,a5,a1
10001ba6:	00c78123          	sb	a2,2(a5)
10001baa:	0705                	addi	a4,a4,1
10001bac:	fed719e3          	bne	a4,a3,10001b9e <enter_sleep_mode+0x156>
10001bb0:	200017b7          	lui	a5,0x20001
10001bb4:	54078e23          	sb	zero,1372(a5) # 2000155c <rx_restart_flag>
10001bb8:	200017b7          	lui	a5,0x20001
10001bbc:	54078ea3          	sb	zero,1373(a5) # 2000155d <tx_restart_flag>
10001bc0:	30046073          	csrsi	mstatus,8
10001bc4:	400807b7          	lui	a5,0x40080
10001bc8:	4fc8                	lw	a0,28(a5)
10001bca:	50a6                	lw	ra,104(sp)
10001bcc:	5416                	lw	s0,100(sp)
10001bce:	5486                	lw	s1,96(sp)
10001bd0:	06c10113          	addi	sp,sp,108
10001bd4:	8082                	ret
	...

10001bd8 <memcpy>:
10001bd8:	832a                	mv	t1,a0
10001bda:	ca09                	beqz	a2,10001bec <memcpy+0x14>
10001bdc:	0005c383          	lbu	t2,0(a1) # e0800000 <__StackTop+0xc07fc000>
10001be0:	00730023          	sb	t2,0(t1) # ff0000 <__ROM_SIZE+0xfb0000>
10001be4:	167d                	addi	a2,a2,-1
10001be6:	0305                	addi	t1,t1,1
10001be8:	0585                	addi	a1,a1,1
10001bea:	fa6d                	bnez	a2,10001bdc <memcpy+0x4>
10001bec:	8082                	ret
	...

10001bf0 <memset>:
10001bf0:	832a                	mv	t1,a0
10001bf2:	c611                	beqz	a2,10001bfe <memset+0xe>
10001bf4:	00b30023          	sb	a1,0(t1)
10001bf8:	167d                	addi	a2,a2,-1
10001bfa:	0305                	addi	t1,t1,1
10001bfc:	fe65                	bnez	a2,10001bf4 <memset+0x4>
10001bfe:	8082                	ret
10001c00:	0000                	unimp
	...

10001c04 <output_pin>:
10001c04:	0008 0000 0000 0000 0007 0000 000f 0000     ................
10001c14:	0006 0000 0001 0000                         ........

10001c1c <input_pin>:
10001c1c:	0015 0000 0014 0000 0013 0000 0012 0000     ................

10001c2c <keys_func_table>:
10001c2c:	0001 0020 00b4 1000 0011 0000 0000 0000     .. .............
10001c3c:	00b4 1000 0011 0000 0000 0000 0001 0010     ................
10001c4c:	00b4 1000 0012 0000 0000 0000 00b4 1000     ................
10001c5c:	0012 0000 0000 0000 0001 0008 00b4 1000     ................
10001c6c:	0013 0000 0000 0000 00b4 1000 0013 0000     ................
10001c7c:	0000 0000 0001 0004 00b4 1000 0014 0000     ................
10001c8c:	0000 0000 00b4 1000 0014 0000 0000 0000     ................
10001c9c:	0002 0020 00b4 1000 0021 0000 0000 0000     .. .....!.......
10001cac:	00b4 1000 0021 0000 0000 0000 0002 0010     ....!...........
10001cbc:	00b4 1000 0022 0000 0000 0000 00b4 1000     ...."...........
10001ccc:	0022 0000 0000 0000 0002 0008 00b4 1000     "...............
10001cdc:	0023 0000 0000 0000 00b4 1000 0023 0000     #...........#...
10001cec:	0000 0000 0002 0004 00b4 1000 0024 0000     ............$...
10001cfc:	0000 0000 00b4 1000 0024 0000 0000 0000     ........$.......
10001d0c:	0040 0020 00b4 1000 0031 0000 0000 0000     @. .....1.......
10001d1c:	00b4 1000 0031 0000 0000 0000 0040 0010     ....1.......@...
10001d2c:	00b4 1000 0032 0000 0000 0000 00b4 1000     ....2...........
10001d3c:	0032 0000 0000 0000 0040 0008 00b4 1000     2.......@.......
10001d4c:	0033 0000 0000 0000 00b4 1000 0033 0000     3...........3...
10001d5c:	0000 0000 0040 0004 00b4 1000 0034 0000     ....@.......4...
10001d6c:	0000 0000 00b4 1000 0034 0000 0000 0000     ........4.......
10001d7c:	0080 0020 00b4 1000 0041 0000 0000 0000     .. .....A.......
10001d8c:	00b4 1000 0041 0000 0000 0000 0080 0010     ....A...........
10001d9c:	00b4 1000 0042 0000 0000 0000 00b4 1000     ....B...........
10001dac:	0042 0000 0000 0000 0080 0008 00b4 1000     B...............
10001dbc:	0043 0000 0000 0000 00b4 1000 0043 0000     C...........C...
10001dcc:	0000 0000 0080 0004 00b4 1000 0044 0000     ............D...
10001ddc:	0000 0000 00b4 1000 0044 0000 0000 0000     ........D.......
10001dec:	0100 0020 00b4 1000 0051 0000 0000 0000     .. .....Q.......
10001dfc:	00b4 1000 0051 0000 0000 0000 0100 0010     ....Q...........
10001e0c:	00b4 1000 0052 0000 0000 0000 00b4 1000     ....R...........
10001e1c:	0052 0000 0000 0000 0100 0008 00b4 1000     R...............
10001e2c:	0053 0000 0000 0000 00b4 1000 0053 0000     S...........S...
10001e3c:	0000 0000 0100 0004 00b4 1000 0054 0000     ............T...
10001e4c:	0000 0000 00b4 1000 0054 0000 0000 0000     ........T.......
10001e5c:	8000 0020 00b4 1000 0061 0000 0000 0000     .. .....a.......
10001e6c:	00b4 1000 0061 0000 0000 0000 8000 0010     ....a...........
10001e7c:	00b4 1000 0062 0000 0000 0000 00b4 1000     ....b...........
10001e8c:	0062 0000 0000 0000 8000 0008 00b4 1000     b...............
10001e9c:	0063 0000 0000 0000 00b4 1000 0063 0000     c...........c...
10001eac:	0000 0000 8000 0004 00b4 1000 0064 0000     ............d...
10001ebc:	0000 0000 00b4 1000 0064 0000 0000 0000     ........d.......
10001ecc:	0000 0060 00b4 1000 0001 0000 0000 0000     ..`.............
10001edc:	00b4 1000 0001 0000 0000 0000 0000 0050     ..............P.
10001eec:	00b4 1000 0002 0000 0000 0000 00b4 1000     ................
10001efc:	0002 0000 0000 0000 0000 0048 00b4 1000     ..........H.....
10001f0c:	0003 0000 0000 0000 00b4 1000 0003 0000     ................
10001f1c:	0000 0000 0000 0044 00b4 1000 0004 0000     ......D.........
10001f2c:	0000 0000 00b4 1000 0004 0000 0000 0000     ................

10001f3c <freq_ratios>:
10001f3c:	0101 0101 0402 1408 6428 00fa               ........(d..

10001f48 <rssi_thresholds>:
10001f48:	0309 0368 03d2 0449 04cf 0566               ..h...I...f.

10001f54 <addr_list>:
10001f54:	0200 4001 0204 4001 0208 4001 020c 4001     ...@...@...@...@
10001f64:	0210 4001 0214 4001 0300 4001 0304 4001     ...@...@...@...@
10001f74:	0010 4001 0030 4001 0040 4001 0170 4001     ...@0..@@..@p..@
10001f84:	0180 4001 0190 4001 01a0 4001 0140 4001     ...@...@...@@..@

Disassembly of section .data:

20000000 <__VECTOR_TABLE>:
	...
2000000c:	05fe 1000 0000 0000 0000 0000 0000 0000     ................
2000001c:	05fe 1000 0000 0000 0000 0000 0000 0000     ................
2000002c:	05fe 1000 0000 0000 0000 0000 0000 0000     ................
2000003c:	0000 0000 05fe 1000 05fe 1000 04b0 2000     ............... 
2000004c:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
2000005c:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
2000006c:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
2000007c:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
2000008c:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
2000009c:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
200000ac:	05fe 1000 05fe 1000 05fe 1000 05fe 1000     ................
200000bc:	05fe 1000                                   ....

200000c0 <is_rx>:
200000c0:	0001 0000                                   ....

200000c4 <reversed_access>:
200000c4:	1344 2000                                   D.. 

200000c8 <rf_2g4_call_desc_list_tx>:
200000c8:	0354 2000 6000 0000 00e0 2000 6000 0000     T.. .`..... .`..
200000d8:	00e8 2000 6008 0000                         ... .`..

200000e0 <rf_2g4_common_desc_pll_delay>:
200000e0:	0000 0000 5008 001e                         .....P..

200000e8 <rf_call_desc_list_tx_process>:
200000e8:	0168 2000 6000 0000 02b4 2000 6000 0000     h.. .`..... .`..
200000f8:	13ec 2000 6000 0000 0180 2000 6000 0000     ... .`..... .`..
20000108:	0190 2000 6000 0000 01b0 2000 6000 0000     ... .`..... .`..
20000118:	01c4 2000 6000 0000 0000 0000 6000 0000     ... .`.......`..
20000128:	01b8 2000 6000 0000 0188 2000 6000 0000     ... .`..... .`..
20000138:	0160 2000 6000 0000 0170 2000 6000 0000     `.. .`..p.. .`..
20000148:	0158 2000 6000 0000 02a4 2000 6008 0000     X.. .`..... .`..

20000158 <rf_common_desc_mdm_off>:
20000158:	1000 4200 2008 0000                         ...B. ..

20000160 <rf_common_desc_mdm_txoff>:
20000160:	1000 4200 2008 0001                         ...B. ..

20000168 <rf_common_desc_resetmdm>:
20000168:	0000 4200 2008 0006                         ...B. ..

20000170 <rf_common_desc_rf_tx_dac_off>:
20000170:	2015 4200 3040 0200 0084 4200 3048 0200     . .B@0.....BH0..

20000180 <rf_common_desc_rf_tx_dac_on>:
20000180:	0084 4200 3048 0202                         ...BH0..

20000188 <rf_common_desc_rf_tx_pa_off>:
20000188:	2015 4200 3048 0500                         . .BH0..

20000190 <rf_common_desc_rf_tx_pa_on>:
20000190:	2015 4200 3048 0101                         . .BH0..

20000198 <rf_common_desc_setfreq>:
20000198:	1000 4200 2000 0000 0000 4200 2000 0006     ...B. .....B. ..
200001a8:	0000 0000 5008 0001                         .....P..

200001b0 <rf_common_desc_tx_carrier>:
200001b0:	1404 2000 1008 0007                         ... ....

200001b8 <rf_common_desc_tx_end_delay>:
200001b8:	0000 0000 5008 0005                         .....P..

200001c0 <g_lp>:
200001c0:	2b15 000b                                   .+..

200001c4 <rf_common_desc_mdm_txon_ext>:
200001c4:	1000 4200 2000 0003 0000 0000 5080 0002     ...B. .......P..
200001d4:	1027 4200 3048 8000                         '..BH0..

200001dc <rf_common_desc_pll_on_3>:
200001dc:	200c 4200 2080 00ff 0000 0000 5000 000a     . .B. .......P..
200001ec:	2004 4200 3040 0400 200c 4200 3040 0100     . .B@0... .B@0..
200001fc:	2018 4200 3040 0100 2018 4200 3040 0101     . .B@0... .B@0..
2000020c:	2018 4200 3040 0200 2018 4200 3040 0202     . .B@0... .B@0..
2000021c:	2018 4200 3040 0200 0198 2000 6008 0000     . .B@0..... .`..

2000022c <rf_common_desc_rfpll_off>:
2000022c:	2018 4200 3040 0100 2000 4200 3040 0100     . .B@0... .B@0..
2000023c:	200c 4200 2080 0000 2004 4200 3040 0100     . .B. ... .B@0..
2000024c:	2004 4200 3040 0200 2004 4200 3040 fc00     . .B@0... .B@0..
2000025c:	2005 4200 3048 0100                         . .BH0..

20000264 <rf_common_desc_rfrx_off>:
20000264:	2008 4200 3040 8080 2009 4200 3040 0702     . .B@0... .B@0..
20000274:	2010 4200 2080 0000 022c 2000 6008 0000     . .B. ..,.. .`..

20000284 <rf_common_desc_rfrx_on>:
20000284:	20d2 4200 3040 0f0f 2008 4200 3040 8080     . .B@0... .B@0..
20000294:	2009 4200 3040 0701 2010 4200 2088 01ff     . .B@0... .B. ..

200002a4 <rf_common_desc_rftx_off>:
200002a4:	0105 4008 3040 1f05 022c 2000 6008 0000     ...@@0..,.. .`..

200002b4 <rf_common_desc_rftx_on>:
200002b4:	2008 4200 3040 3f1e 20d2 4200 3048 0f03     . .B@0.?. .BH0..

200002c4 <rf_common_desc_rx_setfreq>:
200002c4:	0000 0000 2020 1024 20dc 4200 3040 c080     ....  $.. .B@0..
200002d4:	20dd 4200 3040 0701 20dc 4200 3040 3c3c     . .B@0... .B@0<<
200002e4:	20e4 4200 3040 1c0c 20de 4200 3040 0404     . .B@0... .B@0..
200002f4:	2009 4200 3040 7820 2009 4200 3040 8000     . .B@0 x. .B@0..
20000304:	200a 4200 3040 0702 20dd 4200 3040 0800     . .B@0... .B@0..
20000314:	20e2 4200 3040 8000 20e3 4200 3040 0300     . .B@0... .B@0..
20000324:	2000 4200 3040 0101 2004 4200 3040 0101     . .B@0... .B@0..
20000334:	2004 4200 3040 fcfc 2005 4200 3040 0101     . .B@0... .B@0..
20000344:	201c 4200 3040 1000 01dc 2000 6008 0000     . .B@0..... .`..

20000354 <rf_common_desc_tx_setfreq>:
20000354:	0000 0000 2020 1024 20dc 4200 3040 c000     ....  $.. .B@0..
20000364:	20dd 4200 3040 0700 20dc 4200 3040 3c3c     . .B@0... .B@0<<
20000374:	20e4 4200 3040 1c08 20de 4200 3040 0404     . .B@0... .B@0..
20000384:	2009 4200 3040 7830 2009 4200 3040 8080     . .B@00x. .B@0..
20000394:	200a 4200 3040 0702 0105 4008 3040 1f10     . .B@0.....@@0..
200003a4:	20dd 4200 3040 0808 20e2 4200 3040 8080     . .B@0... .B@0..
200003b4:	20e3 4200 3040 0303 2000 4200 3040 0101     . .B@0... .B@0..
200003c4:	2004 4200 2080 03ff 2015 4200 3040 0606     . .B. ... .B@0..
200003d4:	201c 4200 3040 1010 1027 4200 3040 8080     . .B@0..'..B@0..
200003e4:	01dc 2000 6008 0000                         ... .`..

200003ec <rf_pwr_lvl_map_0>:
200003ec:	100e 101a 101d 1029 102b 102d 1039 103a     ......).+.-.9.:.
200003fc:	103b 103d 184d 1888 1889 188a 188b 188c     ;.=.M...........
2000040c:	188d 18ca 18cb 18cc 18ce 190c 190d 194c     ..............L.
2000041c:	194d 198d 19cd 1a0d 1a4d 1a8d 1acd 1b4d     M.......M.....M.
2000042c:	1bcd 1ccd 1e4d 1fce 1fce 0000               ....M.......

20000438 <rf_pwr_lvl_map_1>:
20000438:	0080 0082 008a                              ......

2000043e <rf_wb_sat_th>:
2000043e:	0070                                        p.

20000440 <cr_regs_addr_list>:
20000440:	0104 4000 0000 e080 1048 e080 0008 4200     ...@....H......B
20000450:	001c 4200 0024 4200 0060 4200 0100 4200     ...B$..B`..B...B
20000460:	0080 4200 0020 4200 0024 4200 000c 4200     ...B ..B$..B...B
20000470:	1030 4200 1100 4200 114c 4200 2008 4200     0..B...BL..B. .B
20000480:	20a8 4200 208c 4200 0020 4000 0024 4000     . .B. .B ..@$..@
20000490:	0028 4000 002c 4000                         (..@,..@

20000498 <gpio_vdd_pin1>:
20000498:	                                             .

20000499 <gpio_vdd_pin2>:
20000499:	                                             .

2000049a <adv_channel_idx>:
2000049a:	0026                                        &.

2000049c <whiten_chl>:
2000049c:	0025 0000                                   %...

200004a0 <otp_init>:
200004a0:	02f9 0000                                   ....

200004a4 <uart_addr_idx_list>:
200004a4:	3303 0402 0001 3001                         .3.....0

200004ac <sleep_wakeup_handler>:
}
200004ac:	4505                	li	a0,1
200004ae:	8082                	ret

200004b0 <RADIO_DMA_Handler>:

extern void RF_2G4_RADIO_Handler(void);


__RAM_CODE_SECTION ATTRIBUTE_ISR void  RADIO_DMA_Handler(void)
{
200004b0:	fd810113          	addi	sp,sp,-40
200004b4:	d206                	sw	ra,36(sp)
200004b6:	d016                	sw	t0,32(sp)
200004b8:	ce1a                	sw	t1,28(sp)
200004ba:	cc1e                	sw	t2,24(sp)
200004bc:	ca2a                	sw	a0,20(sp)
200004be:	c82e                	sw	a1,16(sp)
200004c0:	c632                	sw	a2,12(sp)
200004c2:	c436                	sw	a3,8(sp)
200004c4:	c23a                	sw	a4,4(sp)
200004c6:	c03e                	sw	a5,0(sp)
    RF_2G4_RADIO_Handler();
200004c8:	2259                	jal	2000064e <RF_2G4_RADIO_Handler>
}
200004ca:	5092                	lw	ra,36(sp)
200004cc:	5282                	lw	t0,32(sp)
200004ce:	4372                	lw	t1,28(sp)
200004d0:	43e2                	lw	t2,24(sp)
200004d2:	4552                	lw	a0,20(sp)
200004d4:	45c2                	lw	a1,16(sp)
200004d6:	4632                	lw	a2,12(sp)
200004d8:	46a2                	lw	a3,8(sp)
200004da:	4712                	lw	a4,4(sp)
200004dc:	4782                	lw	a5,0(sp)
200004de:	02810113          	addi	sp,sp,40
200004e2:	30200073          	mret

200004e6 <poweron_unused_gpio_mask_parse_and_set>:
200004e6:	1171                	addi	sp,sp,-4
200004e8:	c022                	sw	s0,0(sp)
200004ea:	40010337          	lui	t1,0x40010
200004ee:	03032703          	lw	a4,48(t1) # 40010030 <__StackTop+0x2000c030>
200004f2:	fff54793          	not	a5,a0
200004f6:	8ff9                	and	a5,a5,a4
200004f8:	02f32823          	sw	a5,48(t1)
200004fc:	20030313          	addi	t1,t1,512
20000500:	4291                	li	t0,4
20000502:	40010437          	lui	s0,0x40010
20000506:	21840413          	addi	s0,s0,536 # 40010218 <__StackTop+0x2000c218>
2000050a:	a025                	j	20000532 <poweron_unused_gpio_mask_parse_and_set+0x4c>
2000050c:	8105                	srli	a0,a0,0x1
2000050e:	0722                	slli	a4,a4,0x8
20000510:	06a2                	slli	a3,a3,0x8
20000512:	0785                	addi	a5,a5,1 # 40080001 <__StackTop+0x2007c001>
20000514:	00578a63          	beq	a5,t0,20000528 <poweron_unused_gpio_mask_parse_and_set+0x42>
20000518:	00157593          	andi	a1,a0,1
2000051c:	d9e5                	beqz	a1,2000050c <poweron_unused_gpio_mask_parse_and_set+0x26>
2000051e:	fff74593          	not	a1,a4
20000522:	8e6d                	and	a2,a2,a1
20000524:	8e55                	or	a2,a2,a3
20000526:	b7dd                	j	2000050c <poweron_unused_gpio_mask_parse_and_set+0x26>
20000528:	00c3a023          	sw	a2,0(t2)
2000052c:	0311                	addi	t1,t1,4
2000052e:	00830b63          	beq	t1,s0,20000544 <poweron_unused_gpio_mask_parse_and_set+0x5e>
20000532:	839a                	mv	t2,t1
20000534:	00032603          	lw	a2,0(t1)
20000538:	0a000693          	li	a3,160
2000053c:	0ff00713          	li	a4,255
20000540:	4781                	li	a5,0
20000542:	bfd9                	j	20000518 <poweron_unused_gpio_mask_parse_and_set+0x32>
20000544:	4402                	lw	s0,0(sp)
20000546:	0111                	addi	sp,sp,4
20000548:	8082                	ret

2000054a <delay_us>:
2000054a:	1171                	addi	sp,sp,-4
2000054c:	420007b7          	lui	a5,0x42000
20000550:	1047a783          	lw	a5,260(a5) # 42000104 <__StackTop+0x21ffc104>
20000554:	c03e                	sw	a5,0(sp)
20000556:	420006b7          	lui	a3,0x42000
2000055a:	1046a783          	lw	a5,260(a3) # 42000104 <__StackTop+0x21ffc104>
2000055e:	4702                	lw	a4,0(sp)
20000560:	8f99                	sub	a5,a5,a4
20000562:	fea7ece3          	bltu	a5,a0,2000055a <delay_us+0x10>
20000566:	0111                	addi	sp,sp,4
20000568:	8082                	ret

2000056a <delay_ms>:
2000056a:	1171                	addi	sp,sp,-4
2000056c:	c006                	sw	ra,0(sp)
2000056e:	3e800793          	li	a5,1000
20000572:	02f50533          	mul	a0,a0,a5
20000576:	3fd1                	jal	2000054a <delay_us>
20000578:	4082                	lw	ra,0(sp)
2000057a:	0111                	addi	sp,sp,4
2000057c:	8082                	ret

2000057e <omw_svc_2g4_set_access_word>:
2000057e:	1131                	addi	sp,sp,-20
20000580:	c806                	sw	ra,16(sp)
20000582:	c622                	sw	s0,12(sp)
20000584:	c426                	sw	s1,8(sp)
20000586:	200017b7          	lui	a5,0x20001
2000058a:	34a7a023          	sw	a0,832(a5) # 20001340 <rf_2g4_mgr+0x4>
2000058e:	420007b7          	lui	a5,0x42000
20000592:	4fbc                	lw	a5,88(a5)
20000594:	83a1                	srli	a5,a5,0x8
20000596:	8b85                	andi	a5,a5,1
20000598:	c7d1                	beqz	a5,20000624 <omw_svc_2g4_set_access_word+0xa6>
2000059a:	4401                	li	s0,0
2000059c:	200004b7          	lui	s1,0x20000
200005a0:	200017b7          	lui	a5,0x20001
200005a4:	33c78793          	addi	a5,a5,828 # 2000133c <rf_2g4_mgr>
200005a8:	c23e                	sw	a5,4(sp)
200005aa:	0c44a783          	lw	a5,196(s1) # 200000c4 <reversed_access>
200005ae:	97a2                	add	a5,a5,s0
200005b0:	c03e                	sw	a5,0(sp)
200005b2:	4712                	lw	a4,4(sp)
200005b4:	008707b3          	add	a5,a4,s0
200005b8:	0047c503          	lbu	a0,4(a5)
200005bc:	f0001097          	auipc	ra,0xf0001
200005c0:	8d2080e7          	jalr	-1838(ra) # 10000e8e <reverse8>
200005c4:	4782                	lw	a5,0(sp)
200005c6:	00a78023          	sb	a0,0(a5)
200005ca:	0405                	addi	s0,s0,1
200005cc:	4791                	li	a5,4
200005ce:	fcf41ee3          	bne	s0,a5,200005aa <omw_svc_2g4_set_access_word+0x2c>
200005d2:	200007b7          	lui	a5,0x20000
200005d6:	0c47a783          	lw	a5,196(a5) # 200000c4 <reversed_access>
200005da:	4398                	lw	a4,0(a5)
200005dc:	420007b7          	lui	a5,0x42000
200005e0:	08e7a023          	sw	a4,128(a5) # 42000080 <__StackTop+0x21ffc080>
200005e4:	200017b7          	lui	a5,0x20001
200005e8:	3407c783          	lbu	a5,832(a5) # 20001340 <rf_2g4_mgr+0x4>
200005ec:	8b85                	andi	a5,a5,1
200005ee:	40f007b3          	neg	a5,a5
200005f2:	fab7f793          	andi	a5,a5,-85
200005f6:	0aa78793          	addi	a5,a5,170
200005fa:	200016b7          	lui	a3,0x20001
200005fe:	37868693          	addi	a3,a3,888 # 20001378 <rf_2g4_preamble>
20000602:	0ff7f793          	zext.b	a5,a5
20000606:	00879713          	slli	a4,a5,0x8
2000060a:	97ba                	add	a5,a5,a4
2000060c:	01079713          	slli	a4,a5,0x10
20000610:	97ba                	add	a5,a5,a4
20000612:	c29c                	sw	a5,0(a3)
20000614:	c2dc                	sw	a5,4(a3)
20000616:	c69c                	sw	a5,8(a3)
20000618:	c6dc                	sw	a5,12(a3)
2000061a:	40c2                	lw	ra,16(sp)
2000061c:	4432                	lw	s0,12(sp)
2000061e:	44a2                	lw	s1,8(sp)
20000620:	0151                	addi	sp,sp,20
20000622:	8082                	ret
20000624:	420007b7          	lui	a5,0x42000
20000628:	08a7a023          	sw	a0,128(a5) # 42000080 <__StackTop+0x21ffc080>
2000062c:	bf65                	j	200005e4 <omw_svc_2g4_set_access_word+0x66>

2000062e <omw_svc_2g4_get_sync_time>:
2000062e:	420007b7          	lui	a5,0x42000
20000632:	5fc8                	lw	a0,60(a5)
20000634:	8082                	ret

20000636 <omw_svc_2g4_get_pend_time>:
20000636:	420007b7          	lui	a5,0x42000
2000063a:	43a8                	lw	a0,64(a5)
2000063c:	8082                	ret

2000063e <omw_svc_24g_is_txrx_idle>:
2000063e:	420007b7          	lui	a5,0x42000
20000642:	43c8                	lw	a0,4(a5)
20000644:	8909                	andi	a0,a0,2
20000646:	8082                	ret
20000648:	8082                	ret
2000064a:	8082                	ret

2000064c <omw_svc_24g_sync_end>:
2000064c:	8082                	ret

2000064e <RF_2G4_RADIO_Handler>:
2000064e:	420007b7          	lui	a5,0x42000
20000652:	4705                	li	a4,1
20000654:	06e78223          	sb	a4,100(a5) # 42000064 <__StackTop+0x21ffc064>
20000658:	200017b7          	lui	a5,0x20001
2000065c:	33c78793          	addi	a5,a5,828 # 2000133c <rf_2g4_mgr>
20000660:	020787a3          	sb	zero,47(a5)
20000664:	8082                	ret

20000666 <omw_svc_2g4_tx_data>:
20000666:	1151                	addi	sp,sp,-12
20000668:	c406                	sw	ra,8(sp)
2000066a:	c222                	sw	s0,4(sp)
2000066c:	c026                	sw	s1,0(sp)
2000066e:	8436                	mv	s0,a3
20000670:	4485                	li	s1,1
20000672:	20001737          	lui	a4,0x20001
20000676:	33c70713          	addi	a4,a4,828 # 2000133c <rf_2g4_mgr>
2000067a:	029707a3          	sb	s1,47(a4)
2000067e:	20000737          	lui	a4,0x20000
20000682:	0c070023          	sb	zero,192(a4) # 200000c0 <is_rx>
20000686:	20001737          	lui	a4,0x20001
2000068a:	33474703          	lbu	a4,820(a4) # 20001334 <autolen_pkt_desc_offset>
2000068e:	0709                	addi	a4,a4,2
20000690:	0ff77713          	zext.b	a4,a4
20000694:	200016b7          	lui	a3,0x20001
20000698:	38b69623          	sh	a1,908(a3) # 2000138c <rf_2g4_trans_len>
2000069c:	00371693          	slli	a3,a4,0x3
200006a0:	20001737          	lui	a4,0x20001
200006a4:	39070713          	addi	a4,a4,912 # 20001390 <rf_2g4_tx_pkt_desc>
200006a8:	9736                	add	a4,a4,a3
200006aa:	c308                	sw	a0,0(a4)
200006ac:	00359793          	slli	a5,a1,0x3
200006b0:	17fd                	addi	a5,a5,-1
200006b2:	07c2                	slli	a5,a5,0x10
200006b4:	00475683          	lhu	a3,4(a4)
200006b8:	8fd5                	or	a5,a5,a3
200006ba:	c35c                	sw	a5,4(a4)
200006bc:	85b2                	mv	a1,a2
200006be:	20000537          	lui	a0,0x20000
200006c2:	35450513          	addi	a0,a0,852 # 20000354 <rf_common_desc_tx_setfreq>
200006c6:	2a71                	jal	20000862 <RADIO_CommonDescInit_SetFreq>
200006c8:	20001737          	lui	a4,0x20001
200006cc:	200007b7          	lui	a5,0x20000
200006d0:	13078793          	addi	a5,a5,304 # 20000130 <rf_call_desc_list_tx_process+0x48>
200006d4:	3cf72823          	sw	a5,976(a4) # 200013d0 <rf_stop_desc>
200006d8:	0442                	slli	s0,s0,0x10
200006da:	8041                	srli	s0,s0,0x10
200006dc:	420007b7          	lui	a5,0x42000
200006e0:	00879a23          	sh	s0,20(a5) # 42000014 <__StackTop+0x21ffc014>
200006e4:	20000737          	lui	a4,0x20000
200006e8:	0c870713          	addi	a4,a4,200 # 200000c8 <rf_2g4_call_desc_list_tx>
200006ec:	c7d8                	sw	a4,12(a5)
200006ee:	30047473          	csrrci	s0,mstatus,8
200006f2:	c384                	sw	s1,0(a5)
200006f4:	2ead                	jal	20000a6e <calc_hp_offset_at_curr_temp>
200006f6:	30041073          	csrw	mstatus,s0
200006fa:	40a2                	lw	ra,8(sp)
200006fc:	4412                	lw	s0,4(sp)
200006fe:	4482                	lw	s1,0(sp)
20000700:	0131                	addi	sp,sp,12
20000702:	8082                	ret

20000704 <omw_svc_2g4_set_idle>:
20000704:	420007b7          	lui	a5,0x42000
20000708:	4709                	li	a4,2
2000070a:	c398                	sw	a4,0(a5)
2000070c:	200017b7          	lui	a5,0x20001
20000710:	3d07a503          	lw	a0,976(a5) # 200013d0 <rf_stop_desc>
20000714:	cd19                	beqz	a0,20000732 <omw_svc_2g4_set_idle+0x2e>
20000716:	1151                	addi	sp,sp,-12
20000718:	c406                	sw	ra,8(sp)
2000071a:	2625                	jal	20000a42 <start_await_dma>
2000071c:	200017b7          	lui	a5,0x20001
20000720:	33c78793          	addi	a5,a5,828 # 2000133c <rf_2g4_mgr>
20000724:	020787a3          	sb	zero,47(a5)
20000728:	02078823          	sb	zero,48(a5)
2000072c:	40a2                	lw	ra,8(sp)
2000072e:	0131                	addi	sp,sp,12
20000730:	8082                	ret
20000732:	200017b7          	lui	a5,0x20001
20000736:	33c78793          	addi	a5,a5,828 # 2000133c <rf_2g4_mgr>
2000073a:	020787a3          	sb	zero,47(a5)
2000073e:	02078823          	sb	zero,48(a5)
20000742:	8082                	ret

20000744 <RADIO_DescInit_Freq>:
20000744:	1141                	addi	sp,sp,-16
20000746:	c606                	sw	ra,12(sp)
20000748:	c422                	sw	s0,8(sp)
2000074a:	c226                	sw	s1,4(sp)
2000074c:	84aa                	mv	s1,a0
2000074e:	00b5d713          	srli	a4,a1,0xb
20000752:	06400793          	li	a5,100
20000756:	02f707b3          	mul	a5,a4,a5
2000075a:	e399                	bnez	a5,20000760 <RADIO_DescInit_Freq+0x1c>
2000075c:	3e800793          	li	a5,1000
20000760:	7ff5f593          	andi	a1,a1,2047
20000764:	02f58533          	mul	a0,a1,a5
20000768:	670d                	lui	a4,0x3
2000076a:	ee070713          	addi	a4,a4,-288 # 2ee0 <app_viot_handler.c.d912e21e+0x5a8>
2000076e:	02e54433          	div	s0,a0,a4
20000772:	0c540413          	addi	s0,s0,197
20000776:	0442                	slli	s0,s0,0x10
20000778:	8041                	srli	s0,s0,0x10
2000077a:	02f74733          	div	a4,a4,a5
2000077e:	02e5e5b3          	rem	a1,a1,a4
20000782:	02f585b3          	mul	a1,a1,a5
20000786:	67d5                	lui	a5,0x15
20000788:	55578793          	addi	a5,a5,1365 # 15555 <ble_viot.c.e415c280+0xfeef>
2000078c:	02f585b3          	mul	a1,a1,a5
20000790:	3e800793          	li	a5,1000
20000794:	02f5c7b3          	div	a5,a1,a5
20000798:	c03e                	sw	a5,0(sp)
2000079a:	200007b7          	lui	a5,0x20000
2000079e:	2c478793          	addi	a5,a5,708 # 200002c4 <rf_common_desc_rx_setfreq>
200007a2:	04f48463          	beq	s1,a5,200007ea <RADIO_DescInit_Freq+0xa6>
200007a6:	200017b7          	lui	a5,0x20001
200007aa:	33e7c783          	lbu	a5,830(a5) # 2000133e <rf_2g4_mgr+0x2>
200007ae:	85be                	mv	a1,a5
200007b0:	4709                	li	a4,2
200007b2:	00f77363          	bgeu	a4,a5,200007b8 <RADIO_DescInit_Freq+0x74>
200007b6:	4589                	li	a1,2
200007b8:	7d000793          	li	a5,2000
200007bc:	02f54533          	div	a0,a0,a5
200007c0:	0ff5f593          	zext.b	a1,a1
200007c4:	0ff57513          	zext.b	a0,a0
200007c8:	2e49                	jal	20000b5a <RF_OnChip_Cfg_KVCO_Cal_val>
200007ca:	4681                	li	a3,0
200007cc:	4701                	li	a4,0
200007ce:	01441793          	slli	a5,s0,0x14
200007d2:	4602                	lw	a2,0(sp)
200007d4:	8fd1                	or	a5,a5,a2
200007d6:	8f99                	sub	a5,a5,a4
200007d8:	8385                	srli	a5,a5,0x1
200007da:	8fd5                	or	a5,a5,a3
200007dc:	c09c                	sw	a5,0(s1)
200007de:	8526                	mv	a0,s1
200007e0:	40b2                	lw	ra,12(sp)
200007e2:	4422                	lw	s0,8(sp)
200007e4:	4492                	lw	s1,4(sp)
200007e6:	0141                	addi	sp,sp,16
200007e8:	8082                	ret
200007ea:	200017b7          	lui	a5,0x20001
200007ee:	33e7c703          	lbu	a4,830(a5) # 2000133e <rf_2g4_mgr+0x2>
200007f2:	4785                	li	a5,1
200007f4:	02f70f63          	beq	a4,a5,20000832 <RADIO_DescInit_Freq+0xee>
200007f8:	420026b7          	lui	a3,0x42002
200007fc:	0cc6a783          	lw	a5,204(a3) # 420020cc <__StackTop+0x21ffe0cc>
20000800:	ffd00737          	lui	a4,0xffd00
20000804:	cff70713          	addi	a4,a4,-769 # ffcffcff <__StackTop+0xdfcfbcff>
20000808:	8ff9                	and	a5,a5,a4
2000080a:	00300737          	lui	a4,0x300
2000080e:	30070713          	addi	a4,a4,768 # 300300 <__ROM_SIZE+0x2c0300>
20000812:	8fd9                	or	a5,a5,a4
20000814:	0cf6a623          	sw	a5,204(a3)
20000818:	200017b7          	lui	a5,0x20001
2000081c:	33e7c703          	lbu	a4,830(a5) # 2000133e <rf_2g4_mgr+0x2>
20000820:	4785                	li	a5,1
20000822:	02f70963          	beq	a4,a5,20000854 <RADIO_DescInit_Freq+0x110>
20000826:	800006b7          	lui	a3,0x80000
2000082a:	67d5                	lui	a5,0x15
2000082c:	55578713          	addi	a4,a5,1365 # 15555 <ble_viot.c.e415c280+0xfeef>
20000830:	bf79                	j	200007ce <RADIO_DescInit_Freq+0x8a>
20000832:	420026b7          	lui	a3,0x42002
20000836:	0cc6a783          	lw	a5,204(a3) # 420020cc <__StackTop+0x21ffe0cc>
2000083a:	ffd00737          	lui	a4,0xffd00
2000083e:	cff70713          	addi	a4,a4,-769 # ffcffcff <__StackTop+0xdfcfbcff>
20000842:	8ff9                	and	a5,a5,a4
20000844:	00300737          	lui	a4,0x300
20000848:	30070713          	addi	a4,a4,768 # 300300 <__ROM_SIZE+0x2c0300>
2000084c:	8fd9                	or	a5,a5,a4
2000084e:	0cf6a623          	sw	a5,204(a3)
20000852:	b7d9                	j	20000818 <RADIO_DescInit_Freq+0xd4>
20000854:	800006b7          	lui	a3,0x80000
20000858:	0002b737          	lui	a4,0x2b
2000085c:	aab70713          	addi	a4,a4,-1365 # 2aaab <ble_viot.c.e415c280+0x25445>
20000860:	b7bd                	j	200007ce <RADIO_DescInit_Freq+0x8a>

20000862 <RADIO_CommonDescInit_SetFreq>:
20000862:	1151                	addi	sp,sp,-12
20000864:	c406                	sw	ra,8(sp)
20000866:	4601                	li	a2,0
20000868:	3df1                	jal	20000744 <RADIO_DescInit_Freq>
2000086a:	40a2                	lw	ra,8(sp)
2000086c:	0131                	addi	sp,sp,12
2000086e:	8082                	ret

20000870 <omw_rf_set_high_perf_apply>:
20000870:	200017b7          	lui	a5,0x20001
20000874:	4217c783          	lbu	a5,1057(a5) # 20001421 <is_high_perf>
20000878:	0ff7f793          	zext.b	a5,a5
2000087c:	c7c5                	beqz	a5,20000924 <omw_rf_set_high_perf_apply+0xb4>
2000087e:	200017b7          	lui	a5,0x20001
20000882:	4207c783          	lbu	a5,1056(a5) # 20001420 <is_add_rf_aon_adda_vc>
20000886:	ef99                	bnez	a5,200008a4 <omw_rf_set_high_perf_apply+0x34>
20000888:	200017b7          	lui	a5,0x20001
2000088c:	42478793          	addi	a5,a5,1060 # 20001424 <g_rf_cfg>
20000890:	0057c703          	lbu	a4,5(a5)
20000894:	0709                	addi	a4,a4,2
20000896:	00e782a3          	sb	a4,5(a5)
2000089a:	200017b7          	lui	a5,0x20001
2000089e:	4705                	li	a4,1
200008a0:	42e78023          	sb	a4,1056(a5) # 20001420 <is_add_rf_aon_adda_vc>
200008a4:	420027b7          	lui	a5,0x42002
200008a8:	57b8                	lw	a4,104(a5)
200008aa:	9b41                	andi	a4,a4,-16
200008ac:	00476713          	ori	a4,a4,4
200008b0:	d7b8                	sw	a4,104(a5)
200008b2:	57f8                	lw	a4,108(a5)
200008b4:	9b41                	andi	a4,a4,-16
200008b6:	00776713          	ori	a4,a4,7
200008ba:	d7f8                	sw	a4,108(a5)
200008bc:	5bb8                	lw	a4,112(a5)
200008be:	9b41                	andi	a4,a4,-16
200008c0:	00776713          	ori	a4,a4,7
200008c4:	dbb8                	sw	a4,112(a5)
200008c6:	5bf8                	lw	a4,116(a5)
200008c8:	9b41                	andi	a4,a4,-16
200008ca:	00776713          	ori	a4,a4,7
200008ce:	dbf8                	sw	a4,116(a5)
200008d0:	5fb8                	lw	a4,120(a5)
200008d2:	9b41                	andi	a4,a4,-16
200008d4:	00776713          	ori	a4,a4,7
200008d8:	dfb8                	sw	a4,120(a5)
200008da:	5ff0                	lw	a2,124(a5)
200008dc:	76fd                	lui	a3,0xfffff
200008de:	0ff68693          	addi	a3,a3,255 # fffff0ff <__StackTop+0xdfffb0ff>
200008e2:	8e75                	and	a2,a2,a3
200008e4:	6705                	lui	a4,0x1
200008e6:	80070713          	addi	a4,a4,-2048 # 800 <__STACK_SIZE+0x500>
200008ea:	8e59                	or	a2,a2,a4
200008ec:	dff0                	sw	a2,124(a5)
200008ee:	0807a603          	lw	a2,128(a5) # 42002080 <__StackTop+0x21ffe080>
200008f2:	8e75                	and	a2,a2,a3
200008f4:	8e59                	or	a2,a2,a4
200008f6:	08c7a023          	sw	a2,128(a5)
200008fa:	0847a603          	lw	a2,132(a5)
200008fe:	8e75                	and	a2,a2,a3
20000900:	8e59                	or	a2,a2,a4
20000902:	08c7a223          	sw	a2,132(a5)
20000906:	0887a603          	lw	a2,136(a5)
2000090a:	8ef1                	and	a3,a3,a2
2000090c:	8f55                	or	a4,a4,a3
2000090e:	08e7a423          	sw	a4,136(a5)
20000912:	0c87a703          	lw	a4,200(a5)
20000916:	8ff77713          	andi	a4,a4,-1793
2000091a:	20076713          	ori	a4,a4,512
2000091e:	0ce7a423          	sw	a4,200(a5)
20000922:	8082                	ret
20000924:	420027b7          	lui	a5,0x42002
20000928:	57b8                	lw	a4,104(a5)
2000092a:	9b41                	andi	a4,a4,-16
2000092c:	00476713          	ori	a4,a4,4
20000930:	d7b8                	sw	a4,104(a5)
20000932:	57f8                	lw	a4,108(a5)
20000934:	9b41                	andi	a4,a4,-16
20000936:	00776713          	ori	a4,a4,7
2000093a:	d7f8                	sw	a4,108(a5)
2000093c:	5bb8                	lw	a4,112(a5)
2000093e:	9b41                	andi	a4,a4,-16
20000940:	00776713          	ori	a4,a4,7
20000944:	dbb8                	sw	a4,112(a5)
20000946:	5bf8                	lw	a4,116(a5)
20000948:	9b41                	andi	a4,a4,-16
2000094a:	00776713          	ori	a4,a4,7
2000094e:	dbf8                	sw	a4,116(a5)
20000950:	5fb8                	lw	a4,120(a5)
20000952:	9b41                	andi	a4,a4,-16
20000954:	00776713          	ori	a4,a4,7
20000958:	dfb8                	sw	a4,120(a5)
2000095a:	5ff4                	lw	a3,124(a5)
2000095c:	777d                	lui	a4,0xfffff
2000095e:	0ff70713          	addi	a4,a4,255 # fffff0ff <__StackTop+0xdfffb0ff>
20000962:	8ef9                	and	a3,a3,a4
20000964:	2006e693          	ori	a3,a3,512
20000968:	dff4                	sw	a3,124(a5)
2000096a:	0807a683          	lw	a3,128(a5) # 42002080 <__StackTop+0x21ffe080>
2000096e:	8ef9                	and	a3,a3,a4
20000970:	2006e693          	ori	a3,a3,512
20000974:	08d7a023          	sw	a3,128(a5)
20000978:	0847a683          	lw	a3,132(a5)
2000097c:	8ef9                	and	a3,a3,a4
2000097e:	2006e693          	ori	a3,a3,512
20000982:	08d7a223          	sw	a3,132(a5)
20000986:	0887a683          	lw	a3,136(a5)
2000098a:	8f75                	and	a4,a4,a3
2000098c:	20076713          	ori	a4,a4,512
20000990:	08e7a423          	sw	a4,136(a5)
20000994:	0c87a703          	lw	a4,200(a5)
20000998:	8ff77713          	andi	a4,a4,-1793
2000099c:	20076713          	ori	a4,a4,512
200009a0:	0ce7a423          	sw	a4,200(a5)
200009a4:	8082                	ret

200009a6 <_rf_kvco_read_y>:
200009a6:	1151                	addi	sp,sp,-12
200009a8:	c406                	sw	ra,8(sp)
200009aa:	c222                	sw	s0,4(sp)
200009ac:	42002437          	lui	s0,0x42002
200009b0:	0cc42783          	lw	a5,204(s0) # 420020cc <__StackTop+0x21ffe0cc>
200009b4:	10000737          	lui	a4,0x10000
200009b8:	8fd9                	or	a5,a5,a4
200009ba:	0cf42623          	sw	a5,204(s0)
200009be:	0cc42783          	lw	a5,204(s0)
200009c2:	f0000737          	lui	a4,0xf0000
200009c6:	177d                	addi	a4,a4,-1 # efffffff <__StackTop+0xcfffbfff>
200009c8:	8ff9                	and	a5,a5,a4
200009ca:	0cf42623          	sw	a5,204(s0)
200009ce:	4785                	li	a5,1
200009d0:	cc1c                	sw	a5,24(s0)
200009d2:	4795                	li	a5,5
200009d4:	cc1c                	sw	a5,24(s0)
200009d6:	03000793          	li	a5,48
200009da:	02f55533          	divu	a0,a0,a5
200009de:	0515                	addi	a0,a0,5
200009e0:	0542                	slli	a0,a0,0x10
200009e2:	8141                	srli	a0,a0,0x10
200009e4:	369d                	jal	2000054a <delay_us>
200009e6:	0f042503          	lw	a0,240(s0)
200009ea:	052e                	slli	a0,a0,0xb
200009ec:	812d                	srli	a0,a0,0xb
200009ee:	40a2                	lw	ra,8(sp)
200009f0:	4412                	lw	s0,4(sp)
200009f2:	0131                	addi	sp,sp,12
200009f4:	8082                	ret

200009f6 <trigger_gpadc_temp_sampling>:
200009f6:	1151                	addi	sp,sp,-12
200009f8:	c406                	sw	ra,8(sp)
200009fa:	c222                	sw	s0,4(sp)
200009fc:	420027b7          	lui	a5,0x42002
20000a00:	43d8                	lw	a4,4(a5)
20000a02:	00176713          	ori	a4,a4,1
20000a06:	c3d8                	sw	a4,4(a5)
20000a08:	40040437          	lui	s0,0x40040
20000a0c:	4709                	li	a4,2
20000a0e:	c018                	sw	a4,0(s0)
20000a10:	0e87a703          	lw	a4,232(a5) # 420020e8 <__StackTop+0x21ffe0e8>
20000a14:	00176713          	ori	a4,a4,1
20000a18:	0ee7a423          	sw	a4,232(a5)
20000a1c:	08800793          	li	a5,136
20000a20:	c05c                	sw	a5,4(s0)
20000a22:	6791                	lui	a5,0x4
20000a24:	0789                	addi	a5,a5,2 # 4002 <__RAM_SIZE+0x2>
20000a26:	d03c                	sw	a5,96(s0)
20000a28:	30f00793          	li	a5,783
20000a2c:	d83c                	sw	a5,112(s0)
20000a2e:	4511                	li	a0,4
20000a30:	3e29                	jal	2000054a <delay_us>
20000a32:	800047b7          	lui	a5,0x80004
20000a36:	0789                	addi	a5,a5,2 # 80004002 <__StackTop+0x60000002>
20000a38:	d03c                	sw	a5,96(s0)
20000a3a:	40a2                	lw	ra,8(sp)
20000a3c:	4412                	lw	s0,4(sp)
20000a3e:	0131                	addi	sp,sp,12
20000a40:	8082                	ret

20000a42 <start_await_dma>:
20000a42:	420007b7          	lui	a5,0x42000
20000a46:	06078023          	sb	zero,96(a5) # 42000060 <__StackTop+0x21ffc060>
20000a4a:	c7c8                	sw	a0,12(a5)
20000a4c:	4705                	li	a4,1
20000a4e:	c398                	sw	a4,0(a5)
20000a50:	42000737          	lui	a4,0x42000
20000a54:	06474783          	lbu	a5,100(a4) # 42000064 <__StackTop+0x21ffc064>
20000a58:	0ff7f793          	zext.b	a5,a5
20000a5c:	dfe5                	beqz	a5,20000a54 <start_await_dma+0x12>
20000a5e:	420007b7          	lui	a5,0x42000
20000a62:	4705                	li	a4,1
20000a64:	06e78223          	sb	a4,100(a5) # 42000064 <__StackTop+0x21ffc064>
20000a68:	06e78023          	sb	a4,96(a5)
20000a6c:	8082                	ret

20000a6e <calc_hp_offset_at_curr_temp>:
20000a6e:	200017b7          	lui	a5,0x20001
20000a72:	4087a783          	lw	a5,1032(a5) # 20001408 <aon_tick.0>
20000a76:	cb99                	beqz	a5,20000a8c <calc_hp_offset_at_curr_temp+0x1e>
20000a78:	40000737          	lui	a4,0x40000
20000a7c:	0b072703          	lw	a4,176(a4) # 400000b0 <__StackTop+0x1fffc0b0>
20000a80:	8f1d                	sub	a4,a4,a5
20000a82:	000287b7          	lui	a5,0x28
20000a86:	17ed                	addi	a5,a5,-5 # 27ffb <ble_viot.c.e415c280+0x22995>
20000a88:	0ce7f863          	bgeu	a5,a4,20000b58 <calc_hp_offset_at_curr_temp+0xea>
20000a8c:	1101                	addi	sp,sp,-32
20000a8e:	ce06                	sw	ra,28(sp)
20000a90:	cc22                	sw	s0,24(sp)
20000a92:	ca26                	sw	s1,20(sp)
20000a94:	400807b7          	lui	a5,0x40080
20000a98:	47d4                	lw	a3,12(a5)
20000a9a:	40040437          	lui	s0,0x40040
20000a9e:	4018                	lw	a4,0(s0)
20000aa0:	c03a                	sw	a4,0(sp)
20000aa2:	4050                	lw	a2,4(s0)
20000aa4:	c232                	sw	a2,4(sp)
20000aa6:	502c                	lw	a1,96(s0)
20000aa8:	c42e                	sw	a1,8(sp)
20000aaa:	47d8                	lw	a4,12(a5)
20000aac:	00876713          	ori	a4,a4,8
20000ab0:	c7d8                	sw	a4,12(a5)
20000ab2:	5828                	lw	a0,112(s0)
20000ab4:	c62a                	sw	a0,12(sp)
20000ab6:	40000637          	lui	a2,0x40000
20000aba:	560c                	lw	a1,40(a2)
20000abc:	5838                	lw	a4,112(s0)
20000abe:	00176713          	ori	a4,a4,1
20000ac2:	d838                	sw	a4,112(s0)
20000ac4:	420024b7          	lui	s1,0x42002
20000ac8:	3ff00713          	li	a4,1023
20000acc:	c0d8                	sw	a4,4(s1)
20000ace:	6721                	lui	a4,0x8
20000ad0:	c82e                	sw	a1,16(sp)
20000ad2:	8f4d                	or	a4,a4,a1
20000ad4:	d618                	sw	a4,40(a2)
20000ad6:	c7d4                	sw	a3,12(a5)
20000ad8:	3f39                	jal	200009f6 <trigger_gpadc_temp_sampling>
20000ada:	4521                	li	a0,8
20000adc:	34bd                	jal	2000054a <delay_us>
20000ade:	547c                	lw	a5,108(s0)
20000ae0:	20001737          	lui	a4,0x20001
20000ae4:	42c74703          	lbu	a4,1068(a4) # 2000142c <g_rf_cfg+0x8>
20000ae8:	8f99                	sub	a5,a5,a4
20000aea:	0791                	addi	a5,a5,4 # 40080004 <__StackTop+0x2007c004>
20000aec:	4037d713          	srai	a4,a5,0x3
20000af0:	200017b7          	lui	a5,0x20001
20000af4:	3187a783          	lw	a5,792(a5) # 20001318 <g_otp_cfg+0x2c>
20000af8:	83bd                	srli	a5,a5,0xf
20000afa:	8bfd                	andi	a5,a5,31
20000afc:	02e787b3          	mul	a5,a5,a4
20000b00:	0795                	addi	a5,a5,5
20000b02:	4729                	li	a4,10
20000b04:	02e7c7b3          	div	a5,a5,a4
20000b08:	20001737          	lui	a4,0x20001
20000b0c:	40f72e23          	sw	a5,1052(a4) # 2000141c <g_hp_offset>
20000b10:	400006b7          	lui	a3,0x40000
20000b14:	0b06a703          	lw	a4,176(a3) # 400000b0 <__StackTop+0x1fffc0b0>
20000b18:	200017b7          	lui	a5,0x20001
20000b1c:	40e7a423          	sw	a4,1032(a5) # 20001408 <aon_tick.0>
20000b20:	0e84a783          	lw	a5,232(s1) # 420020e8 <__StackTop+0x21ffe0e8>
20000b24:	9bf9                	andi	a5,a5,-2
20000b26:	0ef4a423          	sw	a5,232(s1)
20000b2a:	06042023          	sw	zero,96(s0) # 40040060 <__StackTop+0x2003c060>
20000b2e:	06042823          	sw	zero,112(s0)
20000b32:	40dc                	lw	a5,4(s1)
20000b34:	9bf9                	andi	a5,a5,-2
20000b36:	c0dc                	sw	a5,4(s1)
20000b38:	4702                	lw	a4,0(sp)
20000b3a:	c018                	sw	a4,0(s0)
20000b3c:	4612                	lw	a2,4(sp)
20000b3e:	c050                	sw	a2,4(s0)
20000b40:	47a2                	lw	a5,8(sp)
20000b42:	d03c                	sw	a5,96(s0)
20000b44:	4532                	lw	a0,12(sp)
20000b46:	d828                	sw	a0,112(s0)
20000b48:	45c2                	lw	a1,16(sp)
20000b4a:	d68c                	sw	a1,40(a3)
20000b4c:	547c                	lw	a5,108(s0)
20000b4e:	40f2                	lw	ra,28(sp)
20000b50:	4462                	lw	s0,24(sp)
20000b52:	44d2                	lw	s1,20(sp)
20000b54:	6105                	addi	sp,sp,32
20000b56:	8082                	ret
20000b58:	8082                	ret

20000b5a <RF_OnChip_Cfg_KVCO_Cal_val>:
20000b5a:	1171                	addi	sp,sp,-4
20000b5c:	6785                	lui	a5,0x1
20000b5e:	80478793          	addi	a5,a5,-2044 # 804 <__STACK_SIZE+0x504>
20000b62:	00f11023          	sh	a5,0(sp)
20000b66:	4789                	li	a5,2
20000b68:	00f10123          	sb	a5,2(sp)
20000b6c:	832e                	mv	t1,a1
20000b6e:	005c                	addi	a5,sp,4
20000b70:	97ae                	add	a5,a5,a1
20000b72:	ffc78603          	lb	a2,-4(a5)
20000b76:	47c9                	li	a5,18
20000b78:	06a7e263          	bltu	a5,a0,20000bdc <RF_OnChip_Cfg_KVCO_Cal_val+0x82>
20000b7c:	47a1                	li	a5,8
20000b7e:	00a7e763          	bltu	a5,a0,20000b8c <RF_OnChip_Cfg_KVCO_Cal_val+0x32>
20000b82:	00161713          	slli	a4,a2,0x1
20000b86:	01871613          	slli	a2,a4,0x18
20000b8a:	8661                	srai	a2,a2,0x18
20000b8c:	4785                	li	a5,1
20000b8e:	10f58d63          	beq	a1,a5,20000ca8 <RF_OnChip_Cfg_KVCO_Cal_val+0x14e>
20000b92:	4581                	li	a1,0
20000b94:	00159793          	slli	a5,a1,0x1
20000b98:	97ae                	add	a5,a5,a1
20000b9a:	200015b7          	lui	a1,0x20001
20000b9e:	41058593          	addi	a1,a1,1040 # 20001410 <g_hp>
20000ba2:	95be                	add	a1,a1,a5
20000ba4:	959a                	add	a1,a1,t1
20000ba6:	0005c703          	lbu	a4,0(a1)
20000baa:	200017b7          	lui	a5,0x20001
20000bae:	41c7a683          	lw	a3,1052(a5) # 2000141c <g_hp_offset>
20000bb2:	96ba                	add	a3,a3,a4
20000bb4:	420015b7          	lui	a1,0x42001
20000bb8:	5188                	lw	a0,32(a1)
20000bba:	77c1                	lui	a5,0xffff0
20000bbc:	8d7d                	and	a0,a0,a5
20000bbe:	20000737          	lui	a4,0x20000
20000bc2:	1c070713          	addi	a4,a4,448 # 200001c0 <g_lp>
20000bc6:	971a                	add	a4,a4,t1
20000bc8:	00074783          	lbu	a5,0(a4)
20000bcc:	07a2                	slli	a5,a5,0x8
20000bce:	00d60733          	add	a4,a2,a3
20000bd2:	8fd9                	or	a5,a5,a4
20000bd4:	8fc9                	or	a5,a5,a0
20000bd6:	d19c                	sw	a5,32(a1)
20000bd8:	0111                	addi	sp,sp,4
20000bda:	8082                	ret
20000bdc:	03a00793          	li	a5,58
20000be0:	02a7f563          	bgeu	a5,a0,20000c0a <RF_OnChip_Cfg_KVCO_Cal_val+0xb0>
20000be4:	04400793          	li	a5,68
20000be8:	00a7f763          	bgeu	a5,a0,20000bf6 <RF_OnChip_Cfg_KVCO_Cal_val+0x9c>
20000bec:	00161713          	slli	a4,a2,0x1
20000bf0:	01871613          	slli	a2,a4,0x18
20000bf4:	8661                	srai	a2,a2,0x18
20000bf6:	40c00733          	neg	a4,a2
20000bfa:	01871613          	slli	a2,a4,0x18
20000bfe:	8661                	srai	a2,a2,0x18
20000c00:	4785                	li	a5,1
20000c02:	04f58963          	beq	a1,a5,20000c54 <RF_OnChip_Cfg_KVCO_Cal_val+0xfa>
20000c06:	4589                	li	a1,2
20000c08:	b771                	j	20000b94 <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
20000c0a:	fed50793          	addi	a5,a0,-19
20000c0e:	0ff7f793          	zext.b	a5,a5
20000c12:	4735                	li	a4,13
20000c14:	00f77b63          	bgeu	a4,a5,20000c2a <RF_OnChip_Cfg_KVCO_Cal_val+0xd0>
20000c18:	4769                	li	a4,26
20000c1a:	0af76463          	bltu	a4,a5,20000cc2 <RF_OnChip_Cfg_KVCO_Cal_val+0x168>
20000c1e:	4705                	li	a4,1
20000c20:	00e58f63          	beq	a1,a4,20000c3e <RF_OnChip_Cfg_KVCO_Cal_val+0xe4>
20000c24:	4601                	li	a2,0
20000c26:	4585                	li	a1,1
20000c28:	b7b5                	j	20000b94 <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
20000c2a:	4705                	li	a4,1
20000c2c:	00e58563          	beq	a1,a4,20000c36 <RF_OnChip_Cfg_KVCO_Cal_val+0xdc>
20000c30:	4601                	li	a2,0
20000c32:	4581                	li	a1,0
20000c34:	b785                	j	20000b94 <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
20000c36:	4711                	li	a4,4
20000c38:	06f77563          	bgeu	a4,a5,20000ca2 <RF_OnChip_Cfg_KVCO_Cal_val+0x148>
20000c3c:	4581                	li	a1,0
20000c3e:	fdf50513          	addi	a0,a0,-33
20000c42:	0ff57513          	zext.b	a0,a0
20000c46:	470d                	li	a4,3
20000c48:	4601                	li	a2,0
20000c4a:	06a77063          	bgeu	a4,a0,20000caa <RF_OnChip_Cfg_KVCO_Cal_val+0x150>
20000c4e:	a031                	j	20000c5a <RF_OnChip_Cfg_KVCO_Cal_val+0x100>
20000c50:	4589                	li	a1,2
20000c52:	b7f5                	j	20000c3e <RF_OnChip_Cfg_KVCO_Cal_val+0xe4>
20000c54:	02800793          	li	a5,40
20000c58:	4589                	li	a1,2
20000c5a:	fe578713          	addi	a4,a5,-27 # fffeffe5 <__StackTop+0xdffebfe5>
20000c5e:	0ff77713          	zext.b	a4,a4
20000c62:	468d                	li	a3,3
20000c64:	04e6f363          	bgeu	a3,a4,20000caa <RF_OnChip_Cfg_KVCO_Cal_val+0x150>
20000c68:	ff678713          	addi	a4,a5,-10
20000c6c:	0ff77713          	zext.b	a4,a4
20000c70:	468d                	li	a3,3
20000c72:	00e6fc63          	bgeu	a3,a4,20000c8a <RF_OnChip_Cfg_KVCO_Cal_val+0x130>
20000c76:	fe978713          	addi	a4,a5,-23
20000c7a:	0ff77713          	zext.b	a4,a4
20000c7e:	00e6f663          	bgeu	a3,a4,20000c8a <RF_OnChip_Cfg_KVCO_Cal_val+0x130>
20000c82:	02300713          	li	a4,35
20000c86:	f0f777e3          	bgeu	a4,a5,20000b94 <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
20000c8a:	00159793          	slli	a5,a1,0x1
20000c8e:	97ae                	add	a5,a5,a1
20000c90:	200015b7          	lui	a1,0x20001
20000c94:	41058593          	addi	a1,a1,1040 # 20001410 <g_hp>
20000c98:	95be                	add	a1,a1,a5
20000c9a:	0015c703          	lbu	a4,1(a1)
20000c9e:	1779                	addi	a4,a4,-2
20000ca0:	b729                	j	20000baa <RF_OnChip_Cfg_KVCO_Cal_val+0x50>
20000ca2:	4601                	li	a2,0
20000ca4:	4581                	li	a1,0
20000ca6:	a011                	j	20000caa <RF_OnChip_Cfg_KVCO_Cal_val+0x150>
20000ca8:	4581                	li	a1,0
20000caa:	00159793          	slli	a5,a1,0x1
20000cae:	97ae                	add	a5,a5,a1
20000cb0:	200015b7          	lui	a1,0x20001
20000cb4:	41058593          	addi	a1,a1,1040 # 20001410 <g_hp>
20000cb8:	95be                	add	a1,a1,a5
20000cba:	0015c703          	lbu	a4,1(a1)
20000cbe:	0709                	addi	a4,a4,2
20000cc0:	b5ed                	j	20000baa <RF_OnChip_Cfg_KVCO_Cal_val+0x50>
20000cc2:	4705                	li	a4,1
20000cc4:	f8e586e3          	beq	a1,a4,20000c50 <RF_OnChip_Cfg_KVCO_Cal_val+0xf6>
20000cc8:	4601                	li	a2,0
20000cca:	4589                	li	a1,2
20000ccc:	b5e1                	j	20000b94 <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>

20000cce <RF_OnChip_Corner_Cal_Cfg>:
20000cce:	1151                	addi	sp,sp,-12
20000cd0:	c406                	sw	ra,8(sp)
20000cd2:	28dd                	jal	20000dc8 <omw_rf_cal_apply_core>
20000cd4:	40a2                	lw	ra,8(sp)
20000cd6:	0131                	addi	sp,sp,12
20000cd8:	8082                	ret

20000cda <RF_OnChip_DCOC_Cal_Bw_Cfg>:
20000cda:	200017b7          	lui	a5,0x20001
20000cde:	40c7c783          	lbu	a5,1036(a5) # 2000140c <cur_bw>
20000ce2:	00a78663          	beq	a5,a0,20000cee <RF_OnChip_DCOC_Cal_Bw_Cfg+0x14>
20000ce6:	200017b7          	lui	a5,0x20001
20000cea:	40a78623          	sb	a0,1036(a5) # 2000140c <cur_bw>
20000cee:	8082                	ret

20000cf0 <RF_OnChip_DCOC_Cal_Cfg>:
20000cf0:	200017b7          	lui	a5,0x20001
20000cf4:	577d                	li	a4,-1
20000cf6:	40e78623          	sb	a4,1036(a5) # 2000140c <cur_bw>
20000cfa:	8082                	ret

20000cfc <RF_OnChip_RC_Cal_Cfg>:
20000cfc:	8082                	ret

20000cfe <RF_OnChip_KVCO_Cal_Cfg>:
20000cfe:	8082                	ret

20000d00 <RF_OnChip_Base_Init>:
20000d00:	1151                	addi	sp,sp,-12
20000d02:	c406                	sw	ra,8(sp)
20000d04:	c222                	sw	s0,4(sp)
20000d06:	c026                	sw	s1,0(sp)
20000d08:	42002437          	lui	s0,0x42002
20000d0c:	441c                	lw	a5,8(s0)
20000d0e:	fc07f793          	andi	a5,a5,-64
20000d12:	01e7e793          	ori	a5,a5,30
20000d16:	c41c                	sw	a5,8(s0)
20000d18:	479d                	li	a5,7
20000d1a:	c85c                	sw	a5,20(s0)
20000d1c:	4c5c                	lw	a5,28(s0)
20000d1e:	7771                	lui	a4,0xffffc
20000d20:	0741                	addi	a4,a4,16 # ffffc010 <__StackTop+0xdfff8010>
20000d22:	8ff9                	and	a5,a5,a4
20000d24:	6711                	lui	a4,0x4
20000d26:	f8870713          	addi	a4,a4,-120 # 3f88 <driver_gpio.c.e70419af+0x9f5>
20000d2a:	8fd9                	or	a5,a5,a4
20000d2c:	cc5c                	sw	a5,28(s0)
20000d2e:	420014b7          	lui	s1,0x42001
20000d32:	509c                	lw	a5,32(s1)
20000d34:	ff010737          	lui	a4,0xff010
20000d38:	177d                	addi	a4,a4,-1 # ff00ffff <__StackTop+0xdf00bfff>
20000d3a:	8ff9                	and	a5,a5,a4
20000d3c:	00140737          	lui	a4,0x140
20000d40:	8fd9                	or	a5,a5,a4
20000d42:	d09c                	sw	a5,32(s1)
20000d44:	47b1                	li	a5,12
20000d46:	14f4a823          	sw	a5,336(s1) # 42001150 <__StackTop+0x21ffd150>
20000d4a:	405c                	lw	a5,4(s0)
20000d4c:	2007e793          	ori	a5,a5,512
20000d50:	c05c                	sw	a5,4(s0)
20000d52:	400007b7          	lui	a5,0x40000
20000d56:	470d                	li	a4,3
20000d58:	30e7a023          	sw	a4,768(a5) # 40000300 <__StackTop+0x1fffc300>
20000d5c:	0e042783          	lw	a5,224(s0) # 420020e0 <__StackTop+0x21ffe0e0>
20000d60:	e3f7f793          	andi	a5,a5,-449
20000d64:	0c07e793          	ori	a5,a5,192
20000d68:	0ef42023          	sw	a5,224(s0)
20000d6c:	0e442783          	lw	a5,228(s0)
20000d70:	e1f7f793          	andi	a5,a5,-481
20000d74:	1607e793          	ori	a5,a5,352
20000d78:	0ef42223          	sw	a5,228(s0)
20000d7c:	0d442783          	lw	a5,212(s0)
20000d80:	6705                	lui	a4,0x1
20000d82:	80070713          	addi	a4,a4,-2048 # 800 <__STACK_SIZE+0x500>
20000d86:	8fd9                	or	a5,a5,a4
20000d88:	0cf42a23          	sw	a5,212(s0)
20000d8c:	34d5                	jal	20000870 <omw_rf_set_high_perf_apply>
20000d8e:	0ac42783          	lw	a5,172(s0)
20000d92:	eff7f793          	andi	a5,a5,-257
20000d96:	0af42623          	sw	a5,172(s0)
20000d9a:	200007b7          	lui	a5,0x20000
20000d9e:	43e7c783          	lbu	a5,1086(a5) # 2000043e <rf_wb_sat_th>
20000da2:	10f4ac23          	sw	a5,280(s1)
20000da6:	6711                	lui	a4,0x4
20000da8:	fff70793          	addi	a5,a4,-1 # 3fff <driver_gpio.c.e70419af+0xa6c>
20000dac:	12f4a823          	sw	a5,304(s1)
20000db0:	40a2                	lw	ra,8(sp)
20000db2:	4412                	lw	s0,4(sp)
20000db4:	4482                	lw	s1,0(sp)
20000db6:	0131                	addi	sp,sp,12
20000db8:	8082                	ret

20000dba <RF_OnChip_Cali_Cfg>:
20000dba:	1151                	addi	sp,sp,-12
20000dbc:	c406                	sw	ra,8(sp)
20000dbe:	3f01                	jal	20000cce <RF_OnChip_Corner_Cal_Cfg>
20000dc0:	3f05                	jal	20000cf0 <RF_OnChip_DCOC_Cal_Cfg>
20000dc2:	40a2                	lw	ra,8(sp)
20000dc4:	0131                	addi	sp,sp,12
20000dc6:	8082                	ret

20000dc8 <omw_rf_cal_apply_core>:
20000dc8:	400806b7          	lui	a3,0x40080
20000dcc:	1046a603          	lw	a2,260(a3) # 40080104 <__StackTop+0x2007c104>
20000dd0:	20001737          	lui	a4,0x20001
20000dd4:	42470713          	addi	a4,a4,1060 # 20001424 <g_rf_cfg>
20000dd8:	00474783          	lbu	a5,4(a4)
20000ddc:	078e                	slli	a5,a5,0x3
20000dde:	00574583          	lbu	a1,5(a4)
20000de2:	05a2                	slli	a1,a1,0x8
20000de4:	8fcd                	or	a5,a5,a1
20000de6:	00174583          	lbu	a1,1(a4)
20000dea:	05ba                	slli	a1,a1,0xe
20000dec:	8fcd                	or	a5,a5,a1
20000dee:	fffc05b7          	lui	a1,0xfffc0
20000df2:	8e6d                	and	a2,a2,a1
20000df4:	8fd1                	or	a5,a5,a2
20000df6:	6609                	lui	a2,0x2
20000df8:	0609                	addi	a2,a2,2 # 2002 <rmt_key_config.c.5b7dd704+0x48>
20000dfa:	8fd1                	or	a5,a5,a2
20000dfc:	10f6a223          	sw	a5,260(a3)
20000e00:	1106a783          	lw	a5,272(a3)
20000e04:	87f7f613          	andi	a2,a5,-1921
20000e08:	00774783          	lbu	a5,7(a4)
20000e0c:	17f9                	addi	a5,a5,-2
20000e0e:	079e                	slli	a5,a5,0x7
20000e10:	8fd1                	or	a5,a5,a2
20000e12:	10f6a823          	sw	a5,272(a3)
20000e16:	42002637          	lui	a2,0x42002
20000e1a:	460c                	lw	a1,8(a2)
20000e1c:	800807b7          	lui	a5,0x80080
20000e20:	87f78793          	addi	a5,a5,-1921 # 8007f87f <__StackTop+0x6007b87f>
20000e24:	8dfd                	and	a1,a1,a5
20000e26:	00274683          	lbu	a3,2(a4)
20000e2a:	0685                	addi	a3,a3,1
20000e2c:	00374783          	lbu	a5,3(a4)
20000e30:	079e                	slli	a5,a5,0x7
20000e32:	00074703          	lbu	a4,0(a4)
20000e36:	076e                	slli	a4,a4,0x1b
20000e38:	8fd9                	or	a5,a5,a4
20000e3a:	01369713          	slli	a4,a3,0x13
20000e3e:	8fd9                	or	a5,a5,a4
20000e40:	06de                	slli	a3,a3,0x17
20000e42:	8fd5                	or	a5,a5,a3
20000e44:	8fcd                	or	a5,a5,a1
20000e46:	c61c                	sw	a5,8(a2)
20000e48:	8082                	ret

20000e4a <System_Pwr_Cfg>:
20000e4a:	400007b7          	lui	a5,0x40000
20000e4e:	4725                	li	a4,9
20000e50:	c3d8                	sw	a4,4(a5)
20000e52:	4775                	li	a4,29
20000e54:	d398                	sw	a4,32(a5)
20000e56:	471d                	li	a4,7
20000e58:	d798                	sw	a4,40(a5)
20000e5a:	6705                	lui	a4,0x1
20000e5c:	30270713          	addi	a4,a4,770 # 1302 <main.c.5cfd7a5a+0x988>
20000e60:	d7d8                	sw	a4,44(a5)
20000e62:	8082                	ret

20000e64 <t1001_sleep_restore_reg_info>:
20000e64:	0ff57793          	zext.b	a5,a0
20000e68:	0ff57513          	zext.b	a0,a0
20000e6c:	02b57863          	bgeu	a0,a1,20000e9c <t1001_sleep_restore_reg_info+0x38>
20000e70:	20001737          	lui	a4,0x20001
20000e74:	44472603          	lw	a2,1092(a4) # 20001444 <g_save_buf>
20000e78:	200006b7          	lui	a3,0x20000
20000e7c:	44068693          	addi	a3,a3,1088 # 20000440 <cr_regs_addr_list>
20000e80:	050a                	slli	a0,a0,0x2
20000e82:	9532                	add	a0,a0,a2
20000e84:	4108                	lw	a0,0(a0)
20000e86:	00279713          	slli	a4,a5,0x2
20000e8a:	9736                	add	a4,a4,a3
20000e8c:	4318                	lw	a4,0(a4)
20000e8e:	c308                	sw	a0,0(a4)
20000e90:	0785                	addi	a5,a5,1 # 40000001 <__StackTop+0x1fffc001>
20000e92:	0ff7f793          	zext.b	a5,a5
20000e96:	853e                	mv	a0,a5
20000e98:	feb7e4e3          	bltu	a5,a1,20000e80 <t1001_sleep_restore_reg_info+0x1c>
20000e9c:	8082                	ret

20000e9e <omw_sleep_set_sleep_len>:
20000e9e:	3e800793          	li	a5,1000
20000ea2:	02f50533          	mul	a0,a0,a5
20000ea6:	8115                	srli	a0,a0,0x5
20000ea8:	200017b7          	lui	a5,0x20001
20000eac:	44a7a623          	sw	a0,1100(a5) # 2000144c <slp_tm_rtc_cyls>
20000eb0:	8082                	ret
20000eb2:	4501                	li	a0,0
20000eb4:	8082                	ret

20000eb6 <T1001_ChipSleepCriticalWork>:
20000eb6:	f9810113          	addi	sp,sp,-104
20000eba:	d286                	sw	ra,100(sp)
20000ebc:	d0a2                	sw	s0,96(sp)
20000ebe:	cea6                	sw	s1,92(sp)
20000ec0:	0058                	addi	a4,sp,4
20000ec2:	200017b7          	lui	a5,0x20001
20000ec6:	44e7a223          	sw	a4,1092(a5) # 20001444 <g_save_buf>
20000eca:	200007b7          	lui	a5,0x20000
20000ece:	44078793          	addi	a5,a5,1088 # 20000440 <cr_regs_addr_list>
20000ed2:	05878613          	addi	a2,a5,88
20000ed6:	4394                	lw	a3,0(a5)
20000ed8:	4294                	lw	a3,0(a3)
20000eda:	c314                	sw	a3,0(a4)
20000edc:	0791                	addi	a5,a5,4
20000ede:	0711                	addi	a4,a4,4
20000ee0:	fec79be3          	bne	a5,a2,20000ed6 <T1001_ChipSleepCriticalWork+0x20>
20000ee4:	400807b7          	lui	a5,0x40080
20000ee8:	00c7d703          	lhu	a4,12(a5) # 4008000c <__StackTop+0x2007c00c>
20000eec:	40076713          	ori	a4,a4,1024
20000ef0:	00e79623          	sh	a4,12(a5)
20000ef4:	20001737          	lui	a4,0x20001
20000ef8:	21a70713          	addi	a4,a4,538 # 2000121a <CS_contextRestore>
20000efc:	d398                	sw	a4,32(a5)
20000efe:	200017b7          	lui	a5,0x20001
20000f02:	56c7a503          	lw	a0,1388(a5) # 2000156c <unused_gpio_mask_when_sleep>
20000f06:	2485                	jal	20001166 <unused_gpio_mask_parse_and_set>
20000f08:	200017b7          	lui	a5,0x20001
20000f0c:	4487c783          	lbu	a5,1096(a5) # 20001448 <has_flash>
20000f10:	c38d                	beqz	a5,20000f32 <T1001_ChipSleepCriticalWork+0x7c>
20000f12:	200007b7          	lui	a5,0x20000
20000f16:	4987c503          	lbu	a0,1176(a5) # 20000498 <gpio_vdd_pin1>
20000f1a:	0ff00793          	li	a5,255
20000f1e:	04f51463          	bne	a0,a5,20000f66 <T1001_ChipSleepCriticalWork+0xb0>
20000f22:	200007b7          	lui	a5,0x20000
20000f26:	4997c503          	lbu	a0,1177(a5) # 20000499 <gpio_vdd_pin2>
20000f2a:	0ff00793          	li	a5,255
20000f2e:	02f51e63          	bne	a0,a5,20000f6a <T1001_ChipSleepCriticalWork+0xb4>
20000f32:	40080437          	lui	s0,0x40080
20000f36:	04c44783          	lbu	a5,76(s0) # 4008004c <__StackTop+0x2007c04c>
20000f3a:	0017e793          	ori	a5,a5,1
20000f3e:	04f40623          	sb	a5,76(s0)
20000f42:	447c                	lw	a5,76(s0)
20000f44:	eff7f793          	andi	a5,a5,-257
20000f48:	c47c                	sw	a5,76(s0)
20000f4a:	12442783          	lw	a5,292(s0)
20000f4e:	9bdd                	andi	a5,a5,-9
20000f50:	12f42223          	sw	a5,292(s0)
20000f54:	4509                	li	a0,2
20000f56:	df4ff0ef          	jal	2000054a <delay_us>
20000f5a:	12442783          	lw	a5,292(s0)
20000f5e:	9bed                	andi	a5,a5,-5
20000f60:	12f42223          	sw	a5,292(s0)
20000f64:	a835                	j	20000fa0 <T1001_ChipSleepCriticalWork+0xea>
20000f66:	2a89                	jal	200010b8 <flash_power_off>
20000f68:	bf6d                	j	20000f22 <T1001_ChipSleepCriticalWork+0x6c>
20000f6a:	22b9                	jal	200010b8 <flash_power_off>
20000f6c:	b7d9                	j	20000f32 <T1001_ChipSleepCriticalWork+0x7c>
20000f6e:	3df1                	jal	20000e4a <System_Pwr_Cfg>
20000f70:	40080437          	lui	s0,0x40080
20000f74:	10442783          	lw	a5,260(s0) # 40080104 <__StackTop+0x2007c104>
20000f78:	7779                	lui	a4,0xffffe
20000f7a:	0ff70713          	addi	a4,a4,255 # ffffe0ff <__StackTop+0xdfffa0ff>
20000f7e:	8ff9                	and	a5,a5,a4
20000f80:	6007e793          	ori	a5,a5,1536
20000f84:	10f42223          	sw	a5,260(s0)
20000f88:	45c9                	li	a1,18
20000f8a:	4501                	li	a0,0
20000f8c:	3de1                	jal	20000e64 <t1001_sleep_restore_reg_info>
20000f8e:	3b8d                	jal	20000d00 <RF_OnChip_Base_Init>
20000f90:	352d                	jal	20000dba <RF_OnChip_Cali_Cfg>
20000f92:	4c48                	lw	a0,28(s0)
20000f94:	242d                	jal	200011be <omw_sleep_wkup_worker>
20000f96:	e535                	bnez	a0,20001002 <T1001_ChipSleepCriticalWork+0x14c>
20000f98:	3e800513          	li	a0,1000
20000f9c:	daeff0ef          	jal	2000054a <delay_us>
20000fa0:	400007b7          	lui	a5,0x40000
20000fa4:	0b07a783          	lw	a5,176(a5) # 400000b0 <__StackTop+0x1fffc0b0>
20000fa8:	20001737          	lui	a4,0x20001
20000fac:	44c70493          	addi	s1,a4,1100 # 2000144c <slp_tm_rtc_cyls>
20000fb0:	4098                	lw	a4,0(s1)
20000fb2:	97ba                	add	a5,a5,a4
20000fb4:	40080437          	lui	s0,0x40080
20000fb8:	c05c                	sw	a5,4(s0)
20000fba:	10442783          	lw	a5,260(s0) # 40080104 <__StackTop+0x2007c104>
20000fbe:	7779                	lui	a4,0xffffe
20000fc0:	0ff70713          	addi	a4,a4,255 # ffffe0ff <__StackTop+0xdfffa0ff>
20000fc4:	8ff9                	and	a5,a5,a4
20000fc6:	6705                	lui	a4,0x1
20000fc8:	8fd9                	or	a5,a5,a4
20000fca:	10f42223          	sw	a5,260(s0)
20000fce:	2411                	jal	200011d2 <CS_contextSave>
20000fd0:	04040423          	sb	zero,72(s0)
20000fd4:	4098                	lw	a4,0(s1)
20000fd6:	57fd                	li	a5,-1
20000fd8:	f8f71be3          	bne	a4,a5,20000f6e <T1001_ChipSleepCriticalWork+0xb8>
20000fdc:	400807b7          	lui	a5,0x40080
20000fe0:	4fdc                	lw	a5,28(a5)
20000fe2:	f7d1                	bnez	a5,20000f6e <T1001_ChipSleepCriticalWork+0xb8>
20000fe4:	c002                	sw	zero,0(sp)
20000fe6:	4702                	lw	a4,0(sp)
20000fe8:	6785                	lui	a5,0x1
20000fea:	bb778793          	addi	a5,a5,-1097 # bb7 <main.c.5cfd7a5a+0x23d>
20000fee:	fae7c9e3          	blt	a5,a4,20000fa0 <T1001_ChipSleepCriticalWork+0xea>
20000ff2:	873e                	mv	a4,a5
20000ff4:	4782                	lw	a5,0(sp)
20000ff6:	0785                	addi	a5,a5,1
20000ff8:	c03e                	sw	a5,0(sp)
20000ffa:	4782                	lw	a5,0(sp)
20000ffc:	fef75ce3          	bge	a4,a5,20000ff4 <T1001_ChipSleepCriticalWork+0x13e>
20001000:	b745                	j	20000fa0 <T1001_ChipSleepCriticalWork+0xea>
20001002:	45d9                	li	a1,22
20001004:	4549                	li	a0,18
20001006:	3db9                	jal	20000e64 <t1001_sleep_restore_reg_info>
20001008:	200017b7          	lui	a5,0x20001
2000100c:	4487c783          	lbu	a5,1096(a5) # 20001448 <has_flash>
20001010:	ebc1                	bnez	a5,200010a0 <T1001_ChipSleepCriticalWork+0x1ea>
20001012:	20d5                	jal	200010f6 <gpio_regs_restore_before_rel_gpio_hold>
20001014:	40080437          	lui	s0,0x40080
20001018:	12442783          	lw	a5,292(s0) # 40080124 <__StackTop+0x2007c124>
2000101c:	0047e793          	ori	a5,a5,4
20001020:	12f42223          	sw	a5,292(s0)
20001024:	4509                	li	a0,2
20001026:	d24ff0ef          	jal	2000054a <delay_us>
2000102a:	12442783          	lw	a5,292(s0)
2000102e:	0087e793          	ori	a5,a5,8
20001032:	12f42223          	sw	a5,292(s0)
20001036:	04c44783          	lbu	a5,76(s0)
2000103a:	9bf9                	andi	a5,a5,-2
2000103c:	04f40623          	sb	a5,76(s0)
20001040:	447c                	lw	a5,76(s0)
20001042:	1007e793          	ori	a5,a5,256
20001046:	c47c                	sw	a5,76(s0)
20001048:	200017b7          	lui	a5,0x20001
2000104c:	4497c783          	lbu	a5,1097(a5) # 20001449 <has_otp>
20001050:	cbb1                	beqz	a5,200010a4 <T1001_ChipSleepCriticalWork+0x1ee>
20001052:	200007b7          	lui	a5,0x20000
20001056:	4a07a783          	lw	a5,1184(a5) # 200004a0 <otp_init>
2000105a:	9782                	jalr	a5
2000105c:	200017b7          	lui	a5,0x20001
20001060:	4497c783          	lbu	a5,1097(a5) # 20001449 <has_otp>
20001064:	c3a1                	beqz	a5,200010a4 <T1001_ChipSleepCriticalWork+0x1ee>
20001066:	200017b7          	lui	a5,0x20001
2000106a:	4447a783          	lw	a5,1092(a5) # 20001444 <g_save_buf>
2000106e:	47f8                	lw	a4,76(a5)
20001070:	200007b7          	lui	a5,0x20000
20001074:	48c7a783          	lw	a5,1164(a5) # 2000048c <cr_regs_addr_list+0x4c>
20001078:	c398                	sw	a4,0(a5)
2000107a:	200017b7          	lui	a5,0x20001
2000107e:	4487c783          	lbu	a5,1096(a5) # 20001448 <has_flash>
20001082:	c789                	beqz	a5,2000108c <T1001_ChipSleepCriticalWork+0x1d6>
20001084:	400007b7          	lui	a5,0x40000
20001088:	4721                	li	a4,8
2000108a:	c3d8                	sw	a4,4(a5)
2000108c:	400807b7          	lui	a5,0x40080
20001090:	0207a023          	sw	zero,32(a5) # 40080020 <__StackTop+0x2007c020>
20001094:	5096                	lw	ra,100(sp)
20001096:	5406                	lw	s0,96(sp)
20001098:	44f6                	lw	s1,92(sp)
2000109a:	06810113          	addi	sp,sp,104
2000109e:	8082                	ret
200010a0:	203d                	jal	200010ce <qspi_regs_restore>
200010a2:	bf85                	j	20001012 <T1001_ChipSleepCriticalWork+0x15c>
200010a4:	200017b7          	lui	a5,0x20001
200010a8:	4487c783          	lbu	a5,1096(a5) # 20001448 <has_flash>
200010ac:	dfcd                	beqz	a5,20001066 <T1001_ChipSleepCriticalWork+0x1b0>
200010ae:	1f400513          	li	a0,500
200010b2:	c98ff0ef          	jal	2000054a <delay_us>
200010b6:	bf45                	j	20001066 <T1001_ChipSleepCriticalWork+0x1b0>

200010b8 <flash_power_off>:
200010b8:	40010737          	lui	a4,0x40010
200010bc:	4334                	lw	a3,64(a4)
200010be:	4785                	li	a5,1
200010c0:	00a797b3          	sll	a5,a5,a0
200010c4:	fff7c793          	not	a5,a5
200010c8:	8ff5                	and	a5,a5,a3
200010ca:	c33c                	sw	a5,64(a4)
200010cc:	8082                	ret

200010ce <qspi_regs_restore>:
200010ce:	400107b7          	lui	a5,0x40010
200010d2:	6709                	lui	a4,0x2
200010d4:	12170713          	addi	a4,a4,289 # 2121 <rmt_key_config.c.5b7dd704+0x167>
200010d8:	20e7a623          	sw	a4,524(a5) # 4001020c <__StackTop+0x2000c20c>
200010dc:	20e7a823          	sw	a4,528(a5)
200010e0:	40000713          	li	a4,1024
200010e4:	db98                	sw	a4,48(a5)
200010e6:	c3b8                	sw	a4,64(a5)
200010e8:	ff325737          	lui	a4,0xff325
200010ec:	41070713          	addi	a4,a4,1040 # ff325410 <__StackTop+0xdf321410>
200010f0:	30e7a023          	sw	a4,768(a5)
200010f4:	8082                	ret

200010f6 <gpio_regs_restore_before_rel_gpio_hold>:
200010f6:	1151                	addi	sp,sp,-12
200010f8:	c406                	sw	ra,8(sp)
200010fa:	c222                	sw	s0,4(sp)
200010fc:	c026                	sw	s1,0(sp)
200010fe:	200017b7          	lui	a5,0x20001
20001102:	56078793          	addi	a5,a5,1376 # 20001560 <g_save_buf>
20001106:	4398                	lw	a4,0(a5)
20001108:	4314                	lw	a3,0(a4)
2000110a:	40010737          	lui	a4,0x40010
2000110e:	20d72023          	sw	a3,512(a4) # 40010200 <__StackTop+0x2000c200>
20001112:	4394                	lw	a3,0(a5)
20001114:	52d4                	lw	a3,36(a3)
20001116:	db14                	sw	a3,48(a4)
20001118:	439c                	lw	a5,0(a5)
2000111a:	579c                	lw	a5,40(a5)
2000111c:	c33c                	sw	a5,64(a4)
2000111e:	40000437          	lui	s0,0x40000
20001122:	448d                	li	s1,3
20001124:	d464                	sw	s1,108(s0)
20001126:	42002737          	lui	a4,0x42002
2000112a:	471c                	lw	a5,8(a4)
2000112c:	fc07f793          	andi	a5,a5,-64
20001130:	01e7e793          	ori	a5,a5,30
20001134:	c71c                	sw	a5,8(a4)
20001136:	4785                	li	a5,1
20001138:	c83c                	sw	a5,80(s0)
2000113a:	4505                	li	a0,1
2000113c:	c0eff0ef          	jal	2000054a <delay_us>
20001140:	c824                	sw	s1,80(s0)
20001142:	4515                	li	a0,5
20001144:	c06ff0ef          	jal	2000054a <delay_us>
20001148:	479d                	li	a5,7
2000114a:	c83c                	sw	a5,80(s0)
2000114c:	4505                	li	a0,1
2000114e:	bfcff0ef          	jal	2000054a <delay_us>
20001152:	47bd                	li	a5,15
20001154:	c83c                	sw	a5,80(s0)
20001156:	4519                	li	a0,6
20001158:	bf2ff0ef          	jal	2000054a <delay_us>
2000115c:	40a2                	lw	ra,8(sp)
2000115e:	4412                	lw	s0,4(sp)
20001160:	4482                	lw	s1,0(sp)
20001162:	0131                	addi	sp,sp,12
20001164:	8082                	ret

20001166 <unused_gpio_mask_parse_and_set>:
20001166:	40010337          	lui	t1,0x40010
2000116a:	03032683          	lw	a3,48(t1) # 40010030 <__StackTop+0x2000c030>
2000116e:	fff54793          	not	a5,a0
20001172:	8ff5                	and	a5,a5,a3
20001174:	02f32823          	sw	a5,48(t1)
20001178:	20030313          	addi	t1,t1,512
2000117c:	400103b7          	lui	t2,0x40010
20001180:	21838393          	addi	t2,t2,536 # 40010218 <__StackTop+0x2000c218>
20001184:	a01d                	j	200011aa <unused_gpio_mask_parse_and_set+0x44>
20001186:	8105                	srli	a0,a0,0x1
20001188:	0722                	slli	a4,a4,0x8
2000118a:	06a2                	slli	a3,a3,0x8
2000118c:	17fd                	addi	a5,a5,-1
2000118e:	cb89                	beqz	a5,200011a0 <unused_gpio_mask_parse_and_set+0x3a>
20001190:	00157593          	andi	a1,a0,1
20001194:	d9ed                	beqz	a1,20001186 <unused_gpio_mask_parse_and_set+0x20>
20001196:	fff74593          	not	a1,a4
2000119a:	8e6d                	and	a2,a2,a1
2000119c:	8e55                	or	a2,a2,a3
2000119e:	b7e5                	j	20001186 <unused_gpio_mask_parse_and_set+0x20>
200011a0:	00c2a023          	sw	a2,0(t0)
200011a4:	0311                	addi	t1,t1,4
200011a6:	00730b63          	beq	t1,t2,200011bc <unused_gpio_mask_parse_and_set+0x56>
200011aa:	829a                	mv	t0,t1
200011ac:	00032603          	lw	a2,0(t1)
200011b0:	4791                	li	a5,4
200011b2:	0a000693          	li	a3,160
200011b6:	0ff00713          	li	a4,255
200011ba:	bfd9                	j	20001190 <unused_gpio_mask_parse_and_set+0x2a>
200011bc:	8082                	ret

200011be <omw_sleep_wkup_worker>:
200011be:	c119                	beqz	a0,200011c4 <omw_sleep_wkup_worker+0x6>
200011c0:	4505                	li	a0,1
200011c2:	8082                	ret
200011c4:	1151                	addi	sp,sp,-12
200011c6:	c406                	sw	ra,8(sp)
200011c8:	ae4ff0ef          	jal	200004ac <sleep_wakeup_handler>
200011cc:	40a2                	lw	ra,8(sp)
200011ce:	0131                	addi	sp,sp,12
200011d0:	8082                	ret

200011d2 <CS_contextSave>:
200011d2:	715d                	addi	sp,sp,-80
200011d4:	c006                	sw	ra,0(sp)
200011d6:	c20a                	sw	sp,4(sp)
200011d8:	c40e                	sw	gp,8(sp)
200011da:	c612                	sw	tp,12(sp)
200011dc:	c816                	sw	t0,16(sp)
200011de:	ca1a                	sw	t1,20(sp)
200011e0:	cc1e                	sw	t2,24(sp)
200011e2:	ce22                	sw	s0,28(sp)
200011e4:	d026                	sw	s1,32(sp)
200011e6:	d22a                	sw	a0,36(sp)
200011e8:	d42e                	sw	a1,40(sp)
200011ea:	d632                	sw	a2,44(sp)
200011ec:	d836                	sw	a3,48(sp)
200011ee:	da3a                	sw	a4,52(sp)
200011f0:	dc3e                	sw	a5,56(sp)
200011f2:	307024f3          	csrr	s1,mtvt
200011f6:	30502573          	csrr	a0,mtvec
200011fa:	c0a6                	sw	s1,64(sp)
200011fc:	c2aa                	sw	a0,68(sp)
200011fe:	40080537          	lui	a0,0x40080
20001202:	02450513          	addi	a0,a0,36 # 40080024 <__StackTop+0x2007c024>
20001206:	00252023          	sw	sp,0(a0)
2000120a:	40080537          	lui	a0,0x40080
2000120e:	04850513          	addi	a0,a0,72 # 40080048 <__StackTop+0x2007c048>
20001212:	4585                	li	a1,1
20001214:	c10c                	sw	a1,0(a0)
20001216:	10500073          	wfi

2000121a <CS_contextRestore>:
2000121a:	40080537          	lui	a0,0x40080
2000121e:	02450513          	addi	a0,a0,36 # 40080024 <__StackTop+0x2007c024>
20001222:	410c                	lw	a1,0(a0)
20001224:	812e                	mv	sp,a1
20001226:	4486                	lw	s1,64(sp)
20001228:	4516                	lw	a0,68(sp)
2000122a:	30749073          	csrw	mtvt,s1
2000122e:	30551073          	csrw	mtvec,a0
20001232:	4082                	lw	ra,0(sp)
20001234:	4112                	lw	sp,4(sp)
20001236:	41a2                	lw	gp,8(sp)
20001238:	4232                	lw	tp,12(sp)
2000123a:	42c2                	lw	t0,16(sp)
2000123c:	4352                	lw	t1,20(sp)
2000123e:	43e2                	lw	t2,24(sp)
20001240:	4472                	lw	s0,28(sp)
20001242:	5482                	lw	s1,32(sp)
20001244:	5512                	lw	a0,36(sp)
20001246:	55a2                	lw	a1,40(sp)
20001248:	5632                	lw	a2,44(sp)
2000124a:	56c2                	lw	a3,48(sp)
2000124c:	5752                	lw	a4,52(sp)
2000124e:	57e2                	lw	a5,56(sp)
20001250:	6161                	addi	sp,sp,80
20001252:	8082                	ret
