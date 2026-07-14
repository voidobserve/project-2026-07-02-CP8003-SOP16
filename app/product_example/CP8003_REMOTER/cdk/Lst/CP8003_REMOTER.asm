
.//Obj/CP8003_REMOTER.elf:     file format elf32-littleriscv


Disassembly of section .text:

1f800000 <reset_handler>:
1f800000:	00000093          	li	ra,0
1f800004:	8106                	mv	sp,ra
1f800006:	8186                	mv	gp,ra
1f800008:	8206                	mv	tp,ra
1f80000a:	8286                	mv	t0,ra
1f80000c:	8306                	mv	t1,ra
1f80000e:	8386                	mv	t2,ra
1f800010:	8406                	mv	s0,ra
1f800012:	8486                	mv	s1,ra
1f800014:	8506                	mv	a0,ra
1f800016:	8586                	mv	a1,ra
1f800018:	8606                	mv	a2,ra
1f80001a:	8686                	mv	a3,ra
1f80001c:	8706                	mv	a4,ra
1f80001e:	8786                	mv	a5,ra
1f800020:	00000517          	auipc	a0,0x0
1f800024:	06050513          	addi	a0,a0,96 # 1f800080 <trap_handler>
1f800028:	00356513          	ori	a0,a0,3
1f80002c:	30551073          	csrw	mtvec,a0
1f800030:	00800517          	auipc	a0,0x800
1f800034:	fd050513          	addi	a0,a0,-48 # 20000000 <__VECTOR_TABLE>
1f800038:	30751073          	csrw	mtvt,a0
1f80003c:	00804117          	auipc	sp,0x804
1f800040:	fc410113          	addi	sp,sp,-60 # 20004000 <__StackTop>
1f800044:	34011073          	csrw	mscratch,sp
1f800048:	698000ef          	jal	1f8006e0 <sys_entry>

1f80004c <__exit>:
1f80004c:	a001                	j	1f80004c <__exit>
1f80004e:	00000013          	nop
1f800052:	00000013          	nop
1f800056:	00000013          	nop
1f80005a:	00000013          	nop
1f80005e:	00000013          	nop
1f800062:	00000013          	nop
1f800066:	00000013          	nop
1f80006a:	00000013          	nop
1f80006e:	00000013          	nop
1f800072:	00000013          	nop
1f800076:	00000013          	nop
1f80007a:	00000013          	nop
1f80007e:	0001                	nop

1f800080 <trap_handler>:
1f800080:	30047573          	csrrci	a0,mstatus,8

1f800084 <__deadloop>:
1f800084:	a001                	j	1f800084 <__deadloop>
1f800086:	30200073          	mret
	...

1f8000b4 <direct_key_value>:
 * 说明：直接发送按键键值
 * 输入：0x00-0xff
 ***************************************************************************/
void direct_key_value(str_fun_para* para)
{
    ble_viot_para.cmd = 0xFF;
1f8000b4:	200017b7          	lui	a5,0x20001
1f8000b8:	25878793          	addi	a5,a5,600 # 20001258 <ble_viot_para>
1f8000bc:	577d                	li	a4,-1
1f8000be:	00e788a3          	sb	a4,17(a5)
    ble_viot_para.para[0] = para->para_a;
1f8000c2:	00055703          	lhu	a4,0(a0)
1f8000c6:	00e79923          	sh	a4,18(a5)
}
1f8000ca:	8082                	ret

1f8000cc <gpio_set_output>:
void gpio_set_func(ENUM_GPIO_PIN pin, uint8_t func_code)
{
    if(!VALID_PIN(pin)) return;

    /* Direct register access with boundary check */
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f8000cc:	40010737          	lui	a4,0x40010
 */
void gpio_set_output(uint32_t gpio_bits,uint8_t state)
{
    /* Set GPIO mode to floating input (base configuration) */
	uint32_t cfg_val =  GPIO_MODE_IN_FLOATING;
    for (int pin = 0; pin < GPIO_MAX; pin++)
1f8000d0:	4781                	li	a5,0
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f8000d2:	20070713          	addi	a4,a4,512 # 40010200 <__StackTop+0x2000c200>
    for (int pin = 0; pin < GPIO_MAX; pin++)
1f8000d6:	4661                	li	a2,24
    {
		if(gpio_bits & PIN_TO_MASK(pin))
1f8000d8:	00f556b3          	srl	a3,a0,a5
1f8000dc:	8a85                	andi	a3,a3,1
1f8000de:	c689                	beqz	a3,1f8000e8 <gpio_set_output+0x1c>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f8000e0:	00e786b3          	add	a3,a5,a4
1f8000e4:	00068023          	sb	zero,0(a3)
    for (int pin = 0; pin < GPIO_MAX; pin++)
1f8000e8:	0785                	addi	a5,a5,1
1f8000ea:	fec797e3          	bne	a5,a2,1f8000d8 <gpio_set_output+0xc>

        gpio_set_func(pin, cfg_val);
    }

    /* Update output registers */
    GPIO_INOUT->GPIO_OE |= gpio_bits;
1f8000ee:	400107b7          	lui	a5,0x40010
1f8000f2:	5b98                	lw	a4,48(a5)
1f8000f4:	8f49                	or	a4,a4,a0
1f8000f6:	db98                	sw	a4,48(a5)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f8000f8:	43b8                	lw	a4,64(a5)
1f8000fa:	c581                	beqz	a1,1f800102 <gpio_set_output+0x36>
1f8000fc:	8d59                	or	a0,a0,a4
1f8000fe:	c3a8                	sw	a0,64(a5)
}
1f800100:	8082                	ret
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f800102:	fff54513          	not	a0,a0
1f800106:	8d79                	and	a0,a0,a4
1f800108:	bfdd                	j	1f8000fe <gpio_set_output+0x32>

1f80010a <hal_clock_time_exceed>:
uint32_t _u32_tick = 0;

/******************************************************************************************/
uint32_t hal_clock_get_system_tick(void)
{
    return _u32_tick;
1f80010a:	200017b7          	lui	a5,0x20001
1f80010e:	25878793          	addi	a5,a5,600 # 20001258 <ble_viot_para>
uint8_t hal_clock_time_exceed(uint64_t ref, uint32_t span_us)
{
	uint8_t ret = 0;
	uint32_t tick_temp = hal_clock_get_system_tick();

	if(tick_temp >= ref)
1f800112:	4f9c                	lw	a5,24(a5)
1f800114:	ed81                	bnez	a1,1f80012c <hal_clock_time_exceed+0x22>
1f800116:	00a7eb63          	bltu	a5,a0,1f80012c <hal_clock_time_exceed+0x22>
	{
		ret = ((tick_temp - ref) > span_us); 
1f80011a:	40a78733          	sub	a4,a5,a0
1f80011e:	4505                	li	a0,1
1f800120:	02e7e363          	bltu	a5,a4,1f800146 <hal_clock_time_exceed+0x3c>
	}
	else
	{
		ret = ((0xFFFFFFFF - ref + tick_temp) > span_us);
1f800124:	02e66163          	bltu	a2,a4,1f800146 <hal_clock_time_exceed+0x3c>
1f800128:	4501                	li	a0,0
1f80012a:	8082                	ret
1f80012c:	fff78693          	addi	a3,a5,-1
1f800130:	40a68733          	sub	a4,a3,a0
1f800134:	00f037b3          	snez	a5,a5
1f800138:	00e6b6b3          	sltu	a3,a3,a4
1f80013c:	40b785b3          	sub	a1,a5,a1
1f800140:	4505                	li	a0,1
1f800142:	fed581e3          	beq	a1,a3,1f800124 <hal_clock_time_exceed+0x1a>
	}

	return ret;
}
1f800146:	8082                	ret

1f800148 <ble_adv_timer_init>:
}

void ble_adv_timer_init(void)
{
    // 初始化发包参数
    send_packet_request = 0;
1f800148:	20001537          	lui	a0,0x20001
1f80014c:	25850513          	addi	a0,a0,600 # 20001258 <ble_viot_para>
    packet_tx_count = 0;
    last_send_time = 0;
1f800150:	4701                	li	a4,0
1f800152:	4781                	li	a5,0
    send_packet_request = 0;
1f800154:	00050e23          	sb	zero,28(a0)
    packet_tx_count = 0;
1f800158:	00051f23          	sh	zero,30(a0)
    last_send_time = 0;
1f80015c:	d118                	sw	a4,32(a0)
1f80015e:	d15c                	sw	a5,36(a0)
    memset(packet_buffer, 0, sizeof(packet_buffer));
1f800160:	02700613          	li	a2,39
1f800164:	4581                	li	a1,0
1f800166:	02850513          	addi	a0,a0,40
1f80016a:	28b0106f          	j	1f801bf4 <memset>

1f80016e <main>:
 * 函数的作用说明：
 *    遥控器主入口函数，负责系统初始化和主循环
 *    主要功能：按键扫描、按键处理、指示灯控制、涂鸦广播发送
 */
int main(void)
{
1f80016e:	fa810113          	addi	sp,sp,-88
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f800172:	400107b7          	lui	a5,0x40010
1f800176:	ca86                	sw	ra,84(sp)
1f800178:	c8a2                	sw	s0,80(sp)
1f80017a:	c6a6                	sw	s1,76(sp)
1f80017c:	02000413          	li	s0,32
1f800180:	20878523          	sb	s0,522(a5) # 4001020a <__StackTop+0x2000c20a>
    log_dbg_init();
    log_printf("初始化完成");
#endif

    // ========== 初始化2.4G射频模块 ==========
    rf_2g4_init(); 
1f800184:	672010ef          	jal	1f8017f6 <rf_2g4_init>
    rf_2g4_set_tx_power(6); // 设置发射功率 
1f800188:	4519                	li	a0,6
1f80018a:	039010ef          	jal	1f8019c2 <rf_2g4_set_tx_power>
1f80018e:	400107b7          	lui	a5,0x40010
 * @see ENUM_GPIO_MODE for available input modes
 */
void gpio_set_input(uint32_t gpio_bits,ENUM_GPIO_MODE mode)
{
	uint32_t cfg_val = (mode&0xE0)| 0x0;
    for (int i = 0; i < GPIO_MAX; i++)
1f800192:	4601                	li	a2,0
    {
		if(gpio_bits&(0x1<<i))
1f800194:	4685                	li	a3,1
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f800196:	20078793          	addi	a5,a5,512 # 40010200 <__StackTop+0x2000c200>
    for (int i = 0; i < GPIO_MAX; i++)
1f80019a:	4761                	li	a4,24
		if(gpio_bits&(0x1<<i))
1f80019c:	00c695b3          	sll	a1,a3,a2
1f8001a0:	0125d513          	srli	a0,a1,0x12
1f8001a4:	893d                	andi	a0,a0,15
1f8001a6:	c509                	beqz	a0,1f8001b0 <main+0x42>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f8001a8:	00f605b3          	add	a1,a2,a5
1f8001ac:	00858023          	sb	s0,0(a1)
    for (int i = 0; i < GPIO_MAX; i++)
1f8001b0:	0605                	addi	a2,a2,1
1f8001b2:	fee615e3          	bne	a2,a4,1f80019c <main+0x2e>

        gpio_set_func(i, cfg_val);
    }

	GPIO_INOUT->GPIO_OE &=~gpio_bits;
1f8001b6:	400106b7          	lui	a3,0x40010
1f8001ba:	5a9c                	lw	a5,48(a3)
1f8001bc:	ffc40737          	lui	a4,0xffc40
1f8001c0:	177d                	addi	a4,a4,-1 # ffc3ffff <__StackTop+0xdfc3bfff>
1f8001c2:	8ff9                	and	a5,a5,a4
1f8001c4:	c032                	sw	a2,0(sp)

    // 配置输入口：上拉输入
    gpio_set_input(input_bits, GPIO_MODE_IN_PULL_UP);

    // 配置输出口：输出模式，初始高电平
    gpio_set_output(output_bits, GPIO_HIGH);
1f8001c6:	6521                	lui	a0,0x8
1f8001c8:	da9c                	sw	a5,48(a3)
1f8001ca:	4585                	li	a1,1
1f8001cc:	1c350513          	addi	a0,a0,451 # 81c3 <ble_viot.c.e415c280+0x2b20>
1f8001d0:	3df5                	jal	1f8000cc <gpio_set_output>
extern const uint8_t KEYS_FUNCTION_NUM;

/* 按键处理初始化 */
void key_process_init(void)
{
    memset((void *)&key_info, 0x0, sizeof(str_key_info));
1f8001d2:	20001437          	lui	s0,0x20001
1f8001d6:	25840413          	addi	s0,s0,600 # 20001258 <ble_viot_para>

    // 配置指示灯：输出模式，初始关闭
    gpio_set_output((1UL << SINGLE_LED_GPIO), GPIO_LOW);
1f8001da:	4581                	li	a1,0
1f8001dc:	20000513          	li	a0,512
1f8001e0:	35f5                	jal	1f8000cc <gpio_set_output>
1f8001e2:	04042823          	sw	zero,80(s0)
1f8001e6:	04042a23          	sw	zero,84(s0)
1f8001ea:	04042c23          	sw	zero,88(s0)
1f8001ee:	04042e23          	sw	zero,92(s0)
/* ==================== 初始化函数==================== */
void ble_packet_init(void)
{
    // 兼容旧AK803 payload字段：广播中使用GROUP_ADDR低16位作为滚码。
    // CP8003上旧地址0x1FE0未确认可读，先沿用SDK已有MAC存储区作为稳定来源。
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
1f8001f2:	1f8047b7          	lui	a5,0x1f804
1f8001f6:	e807a783          	lw	a5,-384(a5) # 1f803e80 <__etext+0x1ed4>
    
    // 初始化 VIOT 参数结构
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
1f8001fa:	4602                	lw	a2,0(sp)
1f8001fc:	4581                	li	a1,0
1f8001fe:	8522                	mv	a0,s0
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
1f800200:	d03c                	sw	a5,96(s0)
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
1f800202:	1f3010ef          	jal	1f801bf4 <memset>
    key_process_init();
    // VIOT协议初始化已在key_process_init()中调用ble_packet_init()完成
    log_printf("Remoter initialized (VIOT mode)\n");

    // ========== 初始化BLE广播发送参数 ==========
    ble_adv_timer_init(); // 初始化广播发送参数（主循环模式）
1f800206:	3789                	jal	1f800148 <ble_adv_timer_init>

void hal_clock_time_run(void)
{
	static uint32_t pre_tick = 0;

	uint32_t cur_tick = REG_RD(0x42000104);// (SYS_CTRL->AON_RTC);
1f800208:	420007b7          	lui	a5,0x42000
1f80020c:	1047a703          	lw	a4,260(a5) # 42000104 <__StackTop+0x21ffc104>
	
	if(cur_tick >= pre_tick)
1f800210:	4c1c                	lw	a5,24(s0)
1f800212:	5074                	lw	a3,100(s0)
1f800214:	97ba                	add	a5,a5,a4
1f800216:	8f95                	sub	a5,a5,a3
		_u32_tick += (cur_tick - pre_tick);
		pre_tick = cur_tick;
	}
	else
	{
		_u32_tick += ( 0xFFFFFFFF- pre_tick + cur_tick);
1f800218:	fff78493          	addi	s1,a5,-1
	if(cur_tick >= pre_tick)
1f80021c:	00d76363          	bltu	a4,a3,1f800222 <main+0xb4>
		_u32_tick += (cur_tick - pre_tick);
1f800220:	84be                	mv	s1,a5
    while (1) {

        hal_clock_time_run();

        /* ========== 按键扫描（5ms周期）========== */
        if (hal_clock_time_exceed(key_scan_timer, 5 * 1000)) {
1f800222:	5428                	lw	a0,104(s0)
1f800224:	546c                	lw	a1,108(s0)
1f800226:	6605                	lui	a2,0x1
1f800228:	38860613          	addi	a2,a2,904 # 1388 <main.c.de3c76ba+0x9e7>
1f80022c:	cc04                	sw	s1,24(s0)
		pre_tick = cur_tick;
1f80022e:	d078                	sw	a4,100(s0)
1f800230:	3de9                	jal	1f80010a <hal_clock_time_exceed>
1f800232:	cd69                	beqz	a0,1f80030c <main+0x19e>
            key_scan_timer = hal_clock_get_system_tick();
1f800234:	1f8026b7          	lui	a3,0x1f802
1f800238:	c0868693          	addi	a3,a3,-1016 # 1f801c08 <output_pin>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f80023c:	40010737          	lui	a4,0x40010
1f800240:	d424                	sw	s1,104(s0)
1f800242:	06042623          	sw	zero,108(s0)
{
    uint32_t scaned_key = 0x0;
    uint32_t gpio_state = 0;

    // 矩阵扫描
    for (uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
1f800246:	01868313          	addi	t1,a3,24
    uint32_t scaned_key = 0x0;
1f80024a:	4781                	li	a5,0
        // 输出口依次置低
        gpio_write((1 << output_pin[i]), GPIO_LOW);
1f80024c:	4285                	li	t0,1
1f80024e:	0741                	addi	a4,a4,16 # 40010010 <__StackTop+0x2000c010>
1f800250:	4290                	lw	a2,0(a3)
1f800252:	5b08                	lw	a0,48(a4)
1f800254:	00c29633          	sll	a2,t0,a2
1f800258:	fff64593          	not	a1,a2
1f80025c:	8de9                	and	a1,a1,a0
1f80025e:	db0c                	sw	a1,48(a4)

        // 小延时，确保电平稳定
        for (volatile int d = 0; d < 20; d++)
1f800260:	c402                	sw	zero,8(sp)
1f800262:	45a2                	lw	a1,8(sp)
1f800264:	454d                	li	a0,19
1f800266:	14b55763          	bge	a0,a1,1f8003b4 <main+0x246>
 * @brief Read entire GPIO input register
 * @return uint32_t Current state of all GPIO inputs (bitmask)
 */
uint32_t gpio_read(void)
{
	return GPIO_INOUT->GPIO_I;
1f80026a:	01072383          	lw	t2,16(a4)

        // 读取所有GPIO状态
        gpio_state = gpio_read();

        // 检查所有输入口
        for (uint8_t j = 0; j < INPUT_PIN_NUM; j++) {
1f80026e:	851a                	mv	a0,t1
            // 检测对应输入口是否为低电平（按键按下）
            if ((gpio_state & (1 << input_pin[j])) == 0) {
1f800270:	410c                	lw	a1,0(a0)
1f800272:	00b295b3          	sll	a1,t0,a1
1f800276:	0075f4b3          	and	s1,a1,t2
1f80027a:	e099                	bnez	s1,1f800280 <main+0x112>
                scaned_key |= ((1 << output_pin[i]) | (1 << input_pin[j]));
1f80027c:	8dd1                	or	a1,a1,a2
1f80027e:	8fcd                	or	a5,a5,a1
        for (uint8_t j = 0; j < INPUT_PIN_NUM; j++) {
1f800280:	1f8025b7          	lui	a1,0x1f802
1f800284:	0511                	addi	a0,a0,4
1f800286:	c3058593          	addi	a1,a1,-976 # 1f801c30 <keys_func_table>
1f80028a:	fea593e3          	bne	a1,a0,1f800270 <main+0x102>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f80028e:	5b0c                	lw	a1,48(a4)
    for (uint8_t i = 0; i < OUTPUT_PIN_NUM; i++) {
1f800290:	0691                	addi	a3,a3,4
1f800292:	8e4d                	or	a2,a2,a1
1f800294:	db10                	sw	a2,48(a4)
1f800296:	fad31de3          	bne	t1,a3,1f800250 <main+0xe2>
1f80029a:	5b14                	lw	a3,48(a4)
1f80029c:	6621                	lui	a2,0x8
1f80029e:	1c360613          	addi	a2,a2,451 # 81c3 <ble_viot.c.e415c280+0x2b20>
1f8002a2:	8ed1                	or	a3,a3,a2
1f8002a4:	db14                	sw	a3,48(a4)

    // 设置所有输出口为高电平
    gpio_write(all_output_bits, GPIO_HIGH);

    // 小延时，确保电平稳定
    for (volatile int d = 0; d < 20; d++)
1f8002a6:	c202                	sw	zero,4(sp)
1f8002a8:	46cd                	li	a3,19
1f8002aa:	4712                	lw	a4,4(sp)
1f8002ac:	10e6d863          	bge	a3,a4,1f8003bc <main+0x24e>
	return GPIO_INOUT->GPIO_I;
1f8002b0:	40010737          	lui	a4,0x40010
1f8002b4:	0741                	addi	a4,a4,16 # 40010010 <__StackTop+0x2000c010>
1f8002b6:	4b18                	lw	a4,16(a4)
    // 读取GPIO状态
    gpio_state = gpio_read();

    // 检查所有输入口，如果为低则表示连接到GND
    for (uint8_t j = 0; j < INPUT_PIN_NUM; j++) {
        if ((gpio_state & (1 << input_pin[j])) == 0) {
1f8002b8:	00a71693          	slli	a3,a4,0xa
1f8002bc:	1006d463          	bgez	a3,1f8003c4 <main+0x256>
1f8002c0:	00b71693          	slli	a3,a4,0xb
1f8002c4:	1006d363          	bgez	a3,1f8003ca <main+0x25c>
1f8002c8:	00c71693          	slli	a3,a4,0xc
1f8002cc:	1006d263          	bgez	a3,1f8003d0 <main+0x262>
1f8002d0:	00d71693          	slli	a3,a4,0xd
1f8002d4:	1006c163          	bltz	a3,1f8003d6 <main+0x268>
1f8002d8:	000407b7          	lui	a5,0x40
            // 输入口为低，表示GND按键按下
            // 注意：GND按键应该单独存在，不与矩阵扫描结果混合
            scaned_key = (GNDB | (1 << input_pin[j]));
1f8002dc:	00400737          	lui	a4,0x400
1f8002e0:	8fd9                	or	a5,a5,a4
            break; // 找到一个GND按键就退出，避免多个GND按键同时触发
        }
    }

    key_info.curr_key = scaned_key;
1f8002e2:	c83c                	sw	a5,80(s0)

    // 设置按键活动标志
    if (scaned_key != 0) {
        key_activity_flag = 1; // 检测到按键按下
1f8002e4:	4685                	li	a3,1
1f8002e6:	06d40823          	sb	a3,112(s0)
    }

    key_info.curr_key = scaned_key;
1f8002ea:	c83c                	sw	a5,80(s0)
    if (scaned_key && key_info.curr_key == key_info.last_key) {
1f8002ec:	4830                	lw	a2,80(s0)
1f8002ee:	4878                	lw	a4,84(s0)
1f8002f0:	0ee61863          	bne	a2,a4,1f8003e0 <main+0x272>
        // 按键按下
        key_info.pressed_time += 5; // 每次按键按下时累加5ms
1f8002f4:	4c78                	lw	a4,92(s0)
1f8002f6:	0715                	addi	a4,a4,5 # 400005 <ble_viot.c.e415c280+0x3fa962>
1f8002f8:	cc78                	sw	a4,92(s0)
        key_info.handle_flag = 0x01;
1f8002fa:	04d40da3          	sb	a3,91(s0)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f8002fe:	40010737          	lui	a4,0x40010
1f800302:	4334                	lw	a3,64(a4)
1f800304:	2006e693          	ori	a3,a3,512
1f800308:	c334                	sw	a3,64(a4)
            gpio_write((1 << SINGLE_LED_GPIO), GPIO_LOW);
        }
    }
#endif

    key_info.last_key = scaned_key;
1f80030a:	c87c                	sw	a5,84(s0)
    if(send_packet_request == 0 || packet_tx_count == 0) {
1f80030c:	01c44783          	lbu	a5,28(s0)
1f800310:	c3b1                	beqz	a5,1f800354 <main+0x1e6>
1f800312:	01e45783          	lhu	a5,30(s0)
1f800316:	cf9d                	beqz	a5,1f800354 <main+0x1e6>
    if(last_send_time == 0 || hal_clock_time_exceed(last_send_time, send_interval_us)) {
1f800318:	5008                	lw	a0,32(s0)
1f80031a:	504c                	lw	a1,36(s0)
1f80031c:	00b567b3          	or	a5,a0,a1
1f800320:	c789                	beqz	a5,1f80032a <main+0x1bc>
1f800322:	07245603          	lhu	a2,114(s0)
1f800326:	33d5                	jal	1f80010a <hal_clock_time_exceed>
1f800328:	c515                	beqz	a0,1f800354 <main+0x1e6>
        rf_2g4_tx_data(packet_buffer, packet_len, RF_CH37);
1f80032a:	07444583          	lbu	a1,116(s0)
1f80032e:	4601                	li	a2,0
1f800330:	02840513          	addi	a0,s0,40
    return _u32_tick;
1f800334:	4c04                	lw	s1,24(s0)
1f800336:	5e4010ef          	jal	1f80191a <rf_2g4_tx_data>
        packet_tx_count--;
1f80033a:	01e45783          	lhu	a5,30(s0)
    uint64_t current_time = hal_clock_get_system_tick();
1f80033e:	d004                	sw	s1,32(s0)
1f800340:	02042223          	sw	zero,36(s0)
        packet_tx_count--;
1f800344:	17fd                	addi	a5,a5,-1 # 3ffff <ble_viot.c.e415c280+0x3a95c>
1f800346:	07c2                	slli	a5,a5,0x10
1f800348:	83c1                	srli	a5,a5,0x10
1f80034a:	00f41f23          	sh	a5,30(s0)
        if(packet_tx_count == 0) {
1f80034e:	e399                	bnez	a5,1f800354 <main+0x1e6>
            send_packet_request = 0;
1f800350:	00040e23          	sb	zero,28(s0)

        /* ========== BLE数据包发送处理 ========== */
        ble_adv_process(); // 在主循环中处理发包

        // ========== 看门狗喂狗（100ms） ==========
        if (hal_clock_time_exceed(watch_dog_T, 100 * 1000)) {
1f800354:	5c28                	lw	a0,120(s0)
1f800356:	5c6c                	lw	a1,124(s0)
1f800358:	6661                	lui	a2,0x18
1f80035a:	6a060613          	addi	a2,a2,1696 # 186a0 <ble_viot.c.e415c280+0x12ffd>
1f80035e:	3375                	jal	1f80010a <hal_clock_time_exceed>
1f800360:	c919                	beqz	a0,1f800376 <main+0x208>
            watch_dog_T = hal_clock_get_system_tick();
1f800362:	4c1c                	lw	a5,24(s0)
1f800364:	06042e23          	sw	zero,124(s0)
            WDT_FEED();
1f800368:	0d800713          	li	a4,216
            watch_dog_T = hal_clock_get_system_tick();
1f80036c:	dc3c                	sw	a5,120(s0)
            WDT_FEED();
1f80036e:	400007b7          	lui	a5,0x40000
1f800372:	10e7a023          	sw	a4,256(a5) # 40000100 <__StackTop+0x1fffc100>
        }

        /* ========== 按键处理 ========== */
        // 按键扫描在主循环中完成，此处响应按键事件
        if (key_info.handle_flag) {
1f800376:	05b44783          	lbu	a5,91(s0)
1f80037a:	c3c9                	beqz	a5,1f8003fc <main+0x28e>

            key_process(key_info.curr_key, key_info.pressed_time);
1f80037c:	1f8027b7          	lui	a5,0x1f802
1f800380:	05042303          	lw	t1,80(s0)
1f800384:	c0878793          	addi	a5,a5,-1016 # 1f801c08 <output_pin>
1f800388:	4c74                	lw	a3,92(s0)
void key_process(uint32_t key_value, uint32_t press_time)
{
    str_key_fun *p_key_fun = NULL;

    // 查找匹配的按键配置
    for (uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i) {
1f80038a:	02878593          	addi	a1,a5,40
1f80038e:	4701                	li	a4,0
1f800390:	862e                	mv	a2,a1
1f800392:	4571                	li	a0,28
        if (key_value == keys_func_table[i].key_value) {
1f800394:	0005a283          	lw	t0,0(a1)
1f800398:	04531c63          	bne	t1,t0,1f8003f0 <main+0x282>
    if (p_key_fun == NULL) {
        log_printf("No matching key found for 0x%08X\n", key_value);
        return;
    }

    if (press_time >= STOP_PRESS_THRESHOLD) {
1f80039c:	65bd                	lui	a1,0xf
1f80039e:	a5f58593          	addi	a1,a1,-1441 # ea5f <ble_viot.c.e415c280+0x93bc>
1f8003a2:	12d5f563          	bgeu	a1,a3,1f8004cc <main+0x35e>
1f8003a6:	400107b7          	lui	a5,0x40010
1f8003aa:	43b8                	lw	a4,64(a5)
1f8003ac:	dff77713          	andi	a4,a4,-513
1f8003b0:	c3b8                	sw	a4,64(a5)
}
1f8003b2:	a099                	j	1f8003f8 <main+0x28a>
        for (volatile int d = 0; d < 20; d++)
1f8003b4:	45a2                	lw	a1,8(sp)
1f8003b6:	0585                	addi	a1,a1,1
1f8003b8:	c42e                	sw	a1,8(sp)
1f8003ba:	b565                	j	1f800262 <main+0xf4>
    for (volatile int d = 0; d < 20; d++)
1f8003bc:	4712                	lw	a4,4(sp)
1f8003be:	0705                	addi	a4,a4,1 # 40010001 <__StackTop+0x2000c001>
1f8003c0:	c23a                	sw	a4,4(sp)
1f8003c2:	b5e5                	j	1f8002aa <main+0x13c>
        if ((gpio_state & (1 << input_pin[j])) == 0) {
1f8003c4:	002007b7          	lui	a5,0x200
1f8003c8:	bf11                	j	1f8002dc <main+0x16e>
1f8003ca:	001007b7          	lui	a5,0x100
1f8003ce:	b739                	j	1f8002dc <main+0x16e>
1f8003d0:	000807b7          	lui	a5,0x80
1f8003d4:	b721                	j	1f8002dc <main+0x16e>
    key_info.curr_key = scaned_key;
1f8003d6:	c83c                	sw	a5,80(s0)
    if (scaned_key != 0) {
1f8003d8:	f00796e3          	bnez	a5,1f8002e4 <main+0x176>
    key_info.curr_key = scaned_key;
1f8003dc:	04042823          	sw	zero,80(s0)
        key_info.pressed_time = 0x00;
1f8003e0:	04042e23          	sw	zero,92(s0)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f8003e4:	40010737          	lui	a4,0x40010
1f8003e8:	4334                	lw	a3,64(a4)
1f8003ea:	dff6f693          	andi	a3,a3,-513
1f8003ee:	bf29                	j	1f800308 <main+0x19a>
    for (uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i) {
1f8003f0:	0705                	addi	a4,a4,1 # 40010001 <__StackTop+0x2000c001>
1f8003f2:	05f1                	addi	a1,a1,28
1f8003f4:	faa710e3          	bne	a4,a0,1f800394 <main+0x226>
            key_info.handle_flag = 0x00;
1f8003f8:	04040da3          	sb	zero,91(s0)
        }

        /* ========== 休眠检查（50ms周期）========== */
        if (hal_clock_time_exceed(sleep_check_timer, 50 * 1000)) {
1f8003fc:	08842503          	lw	a0,136(s0)
1f800400:	08c42583          	lw	a1,140(s0)
1f800404:	6631                	lui	a2,0xc
1f800406:	35060613          	addi	a2,a2,848 # c350 <ble_viot.c.e415c280+0x6cad>
1f80040a:	3301                	jal	1f80010a <hal_clock_time_exceed>
1f80040c:	de050ee3          	beqz	a0,1f800208 <main+0x9a>
            sleep_check_timer = hal_clock_get_system_tick();
1f800410:	4c1c                	lw	a5,24(s0)
1f800412:	08042623          	sw	zero,140(s0)
1f800416:	08f42423          	sw	a5,136(s0)

            // 检查按键活动标志
            if (key_activity_flag == 0) {
1f80041a:	07044783          	lbu	a5,112(s0)
1f80041e:	1e079063          	bnez	a5,1f8005fe <main+0x490>
                // 无按键活动，计数增加
                no_keypress_50ms_cnt++;
1f800422:	09045783          	lhu	a5,144(s0)
1f800426:	0785                	addi	a5,a5,1 # 80001 <ble_viot.c.e415c280+0x7a95e>
1f800428:	07c2                	slli	a5,a5,0x10
1f80042a:	83c1                	srli	a5,a5,0x10
1f80042c:	08f41823          	sh	a5,144(s0)
                if (no_keypress_50ms_cnt >= 100) { // 5秒无操作
1f800430:	09045703          	lhu	a4,144(s0)
1f800434:	06300793          	li	a5,99
1f800438:	dce7f8e3          	bgeu	a5,a4,1f800208 <main+0x9a>
1f80043c:	400107b7          	lui	a5,0x40010
                    log_printf("Ready to sleep (no action for 5s)\n");
                    no_keypress_50ms_cnt = 0;
1f800440:	08041823          	sh	zero,144(s0)
1f800444:	43b8                	lw	a4,64(a5)
1f800446:	76e1                	lui	a3,0xffff8
1f800448:	e3c68693          	addi	a3,a3,-452 # ffff7e3c <__StackTop+0xdfff3e3c>
1f80044c:	8f75                	and	a4,a4,a3
1f80044e:	c3b8                	sw	a4,64(a5)
 *                   (active-low wake-up)
 */
void config_wakeup_gpio(uint32_t gpio_mask, uint8_t is_n_wakeup)
{
    /* Remove specified GPIOs from sleep unused mask to keep them active during sleep */
    unused_gpio_mask_when_sleep &= ~gpio_mask;
1f800450:	200016b7          	lui	a3,0x20001
1f800454:	56c6a783          	lw	a5,1388(a3) # 2000156c <unused_gpio_mask_when_sleep>
1f800458:	ffc40737          	lui	a4,0xffc40
1f80045c:	177d                	addi	a4,a4,-1 # ffc3ffff <__StackTop+0xdfc3bfff>
1f80045e:	8ff9                	and	a5,a5,a4
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f800460:	40010737          	lui	a4,0x40010
    unused_gpio_mask_when_sleep &= ~gpio_mask;
1f800464:	56f6a623          	sw	a5,1388(a3)
    uint32_t func_val = is_n_wakeup ? 0x20 : 0x40;
    /* Iterate through all possible GPIO bits (0-23) to configure masked pins */
    for (int i = 0; i < 24; i++)
    {
        if ((gpio_mask >> i) & 0x1)
1f800468:	003c05b7          	lui	a1,0x3c0
    for (int i = 0; i < 24; i++)
1f80046c:	4781                	li	a5,0
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f80046e:	20070713          	addi	a4,a4,512 # 40010200 <__StackTop+0x2000c200>
1f800472:	02000513          	li	a0,32
    for (int i = 0; i < 24; i++)
1f800476:	4661                	li	a2,24
        if ((gpio_mask >> i) & 0x1)
1f800478:	00f5d6b3          	srl	a3,a1,a5
1f80047c:	8a85                	andi	a3,a3,1
1f80047e:	c689                	beqz	a3,1f800488 <main+0x31a>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
1f800480:	00e786b3          	add	a3,a5,a4
1f800484:	00a68023          	sb	a0,0(a3)
    for (int i = 0; i < 24; i++)
1f800488:	0785                	addi	a5,a5,1 # 40010001 <__StackTop+0x2000c001>
1f80048a:	fec797e3          	bne	a5,a2,1f800478 <main+0x30a>
    {
        AON_CTRL->WAKEUP_CTRL0 = gpio_mask;  // Active-high wake-up configuration
    }
    else
    {
        AON_CTRL->WAKEUP_CTRL1 = gpio_mask;  // Active-low wake-up configuration
1f80048e:	003c07b7          	lui	a5,0x3c0
1f800492:	400804b7          	lui	s1,0x40080
1f800496:	c8dc                	sw	a5,20(s1)
                    config_wakeup_gpio(wakeup_gpio_bits, 1);

                    log_printf("Enter sleep mode\n");

                    // ========== 4. 进入睡眠 ==========
                    enter_sleep_mode();
1f800498:	5b6010ef          	jal	1f801a4e <enter_sleep_mode>

                    // ========== 5. 唤醒后初始化 ==========
                    log_printf("\n=== Wakeup from sleep ===\n");
                    log_printf("Wakeup IO: 0x%x\n", AON_CTRL->WAKEUP_RECORD);
1f80049c:	4cdc                	lw	a5,28(s1)
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
1f80049e:	66a1                	lui	a3,0x8
1f8004a0:	400107b7          	lui	a5,0x40010
1f8004a4:	43b8                	lw	a4,64(a5)
1f8004a6:	1c368693          	addi	a3,a3,451 # 81c3 <ble_viot.c.e415c280+0x2b20>
1f8004aa:	8f55                	or	a4,a4,a3
1f8004ac:	c3b8                	sw	a4,64(a5)

                    // 5.1 恢复输出口
                    gpio_write(output_bits, GPIO_HIGH);

                    // 5.2 重新初始化BLE广播发送
                    ble_adv_timer_init();
1f8004ae:	3969                	jal	1f800148 <ble_adv_timer_init>

                    // 5.3 重置时钟计数器
                    watch_dog_T = hal_clock_get_system_tick();
1f8004b0:	4c1c                	lw	a5,24(s0)
1f8004b2:	06042e23          	sw	zero,124(s0)
                    key_scan_timer = hal_clock_get_system_tick();
1f8004b6:	06042623          	sw	zero,108(s0)
                    watch_dog_T = hal_clock_get_system_tick();
1f8004ba:	dc3c                	sw	a5,120(s0)
                    key_scan_timer = hal_clock_get_system_tick();
1f8004bc:	d43c                	sw	a5,104(s0)
                    sleep_check_timer = hal_clock_get_system_tick();
1f8004be:	08f42423          	sw	a5,136(s0)
1f8004c2:	08042623          	sw	zero,140(s0)
                    log_printf("=== System resumed ===\n\n");
                }
            } else {
                // 有按键活动，重置计数和标志
                no_keypress_50ms_cnt = 0;
                key_activity_flag = 0;
1f8004c6:	06040823          	sb	zero,112(s0)
1f8004ca:	bb3d                	j	1f800208 <main+0x9a>
        // 如果到了长按的截止时间，关闭LED，表示不发送信号

        // 熄灭指示灯
        gpio_write((1UL << SINGLE_LED_GPIO), GPIO_LOW);
        return;
    } else if (press_time >= LONG_PRESS_THRESHOLD) {
1f8004cc:	04500593          	li	a1,69
1f8004d0:	10d5fc63          	bgeu	a1,a3,1f8005e8 <main+0x47a>
        // check whether continuous transmission is required

        // pack packet only when it's pack interval
        if (0x00 ==
            ((press_time - LONG_PRESS_THRESHOLD) % SEND_BEACON_MAX_TIMES)) {
1f8004d4:	fba68693          	addi	a3,a3,-70
1f8004d8:	04600593          	li	a1,70
1f8004dc:	02b6f6b3          	remu	a3,a3,a1
        if (0x00 ==
1f8004e0:	fe81                	bnez	a3,1f8003f8 <main+0x28a>
            p_key_fun->long_press_handler((str_fun_para *)&p_key_fun->long_press_para);
1f8004e2:	44f1                	li	s1,28
1f8004e4:	029704b3          	mul	s1,a4,s1
1f8004e8:	97a6                	add	a5,a5,s1
1f8004ea:	5f98                	lw	a4,56(a5)
1f8004ec:	01448513          	addi	a0,s1,20 # 40080014 <__StackTop+0x2007c014>
1f8004f0:	9532                	add	a0,a0,a2
1f8004f2:	c03e                	sw	a5,0(sp)
1f8004f4:	9702                	jalr	a4
        } else {
            return;
        }

        p_key_fun->short_press_handler((str_fun_para *)&p_key_fun->short_press_para);
1f8004f6:	4782                	lw	a5,0(sp)
1f8004f8:	1f802737          	lui	a4,0x1f802
1f8004fc:	00848513          	addi	a0,s1,8
1f800500:	57dc                	lw	a5,44(a5)
1f800502:	c3070613          	addi	a2,a4,-976 # 1f801c30 <keys_func_table>
        goto send_adv_label;
    } else if (press_time == SHORT_PRESS_THRESHOLD) {
        // 短按
        // 将键值写入
        p_key_fun->short_press_handler((str_fun_para *)&p_key_fun->short_press_para);
1f800506:	9532                	add	a0,a0,a2
1f800508:	9782                	jalr	a5
    uint8_t encoded_data[31];  // VIOT编码后的31字节payload
    uint8_t encoded_data_len;
    uint8_t index = 0x0;       // 广播索引
    uint8_t* group_index = &ret_mem_data.current_group_index;
    uint16_t rand_seed = ret_mem_data.rand_seed;
    uint16_t tx_count = ret_mem_data.tx_count++;
1f80050a:	08245483          	lhu	s1,130(s0)
	return crc16;
}

uint8_t ble_viot_encoder(str_ble_viot_para* opcode_para,uint8_t rand_seed,uint8_t* out_data,uint8_t* out_data_len)
{
	uint8_t ble_payload[BLE_ADV_PDU_MAX_LENGTH] = {0x0};
1f80050e:	467d                	li	a2,31
1f800510:	4581                	li	a1,0
1f800512:	00148793          	addi	a5,s1,1
1f800516:	08f41123          	sh	a5,130(s0)
    
    // 验证group_index，如果越界则重置为0
    *group_index = (*group_index > GROUP_INDEX_MAX) ? 0x00 : *group_index;
1f80051a:	08144783          	lbu	a5,129(s0)
1f80051e:	1068                	addi	a0,sp,44
1f800520:	0057b713          	sltiu	a4,a5,5
1f800524:	40e00733          	neg	a4,a4
1f800528:	8ff9                	and	a5,a5,a4
1f80052a:	06045703          	lhu	a4,96(s0)
1f80052e:	08f400a3          	sb	a5,129(s0)
1f800532:	c03a                	sw	a4,0(sp)
1f800534:	6c0010ef          	jal	1f801bf4 <memset>
	*p_ble_payload++ = 0x1D;
	*p_ble_payload++ = 0x1E;

	//copy the encoded data to out buffer
	*out_data_len = BLE_ADV_PDU_MAX_LENGTH;
	memcpy(out_data,ble_payload,BLE_ADV_PDU_MAX_LENGTH);
1f800538:	1b0207b7          	lui	a5,0x1b020
1f80053c:	10278793          	addi	a5,a5,258 # 1b020102 <ble_viot.c.e415c280+0x1b01aa5f>
1f800540:	d63e                	sw	a5,44(sp)
1f800542:	77f9                	lui	a5,0xffffe
1f800544:	c0378793          	addi	a5,a5,-1021 # ffffdc03 <__StackTop+0xdfff9c03>
1f800548:	02f11823          	sh	a5,48(sp)
1f80054c:	fdc00793          	li	a5,-36
1f800550:	02f10923          	sb	a5,50(sp)
1f800554:	fc300793          	li	a5,-61
1f800558:	02f10b23          	sb	a5,54(sp)
1f80055c:	181717b7          	lui	a5,0x18171
1f800560:	6c378793          	addi	a5,a5,1731 # 181716c3 <ble_viot.c.e415c280+0x1816c020>
1f800564:	dc3e                	sw	a5,56(sp)
1f800566:	1c1b27b7          	lui	a5,0x1c1b2
1f80056a:	4702                	lw	a4,0(sp)
	*p_ble_payload++ = (uint8_t)opcode_para->para[0];
1f80056c:	01244683          	lbu	a3,18(s0)
	memcpy(out_data,ble_payload,BLE_ADV_PDU_MAX_LENGTH);
1f800570:	a1978793          	addi	a5,a5,-1511 # 1c1b1a19 <ble_viot.c.e415c280+0x1c1ac376>
1f800574:	de3e                	sw	a5,60(sp)
1f800576:	6789                	lui	a5,0x2
1f800578:	e1d78793          	addi	a5,a5,-483 # 1e1d <main.c.de3c76ba+0x147c>
1f80057c:	106c                	addi	a1,sp,44
1f80057e:	467d                	li	a2,31
1f800580:	0068                	addi	a0,sp,12
1f800582:	02e11a23          	sh	a4,52(sp)
1f800586:	02d109a3          	sb	a3,51(sp)
1f80058a:	04f11023          	sh	a5,64(sp)
    
    // 填充VIOT参数
    ble_viot_para.relay = 0x54;           // 固定值
    ble_viot_para.type = 0x00;            // 类型
    ble_viot_para.version = 0x00;         // 版本
    ble_viot_para.count = tx_count;       // 递增计数
1f80058e:	02910ba3          	sb	s1,55(sp)
1f800592:	64a010ef          	jal	1f801bdc <memcpy>
    packet_len = 8 + data_len;  // 2字节头部 + 6字节MAC + 数据长度
1f800596:	02700793          	li	a5,39
1f80059a:	06f40a23          	sb	a5,116(s0)
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
1f80059e:	221127b7          	lui	a5,0x22112
1f8005a2:	54278793          	addi	a5,a5,1346 # 22112542 <__StackTop+0x210e542>
1f8005a6:	d41c                	sw	a5,40(s0)
1f8005a8:	665547b7          	lui	a5,0x66554
1f8005ac:	43378793          	addi	a5,a5,1075 # 66554433 <__StackTop+0x46550433>
    memcpy(&packet_buffer[8], data, data_len);
1f8005b0:	006c                	addi	a1,sp,12
1f8005b2:	467d                	li	a2,31
1f8005b4:	03040513          	addi	a0,s0,48
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
1f8005b8:	d45c                	sw	a5,44(s0)
    memcpy(&packet_buffer[8], data, data_len);
1f8005ba:	622010ef          	jal	1f801bdc <memcpy>
    packet_tx_count = tx_num;
1f8005be:	04600793          	li	a5,70
1f8005c2:	00f41f23          	sh	a5,30(s0)
    send_interval_us = interval_ms * 1000;  // 转换为微秒
1f8005c6:	3e800793          	li	a5,1000
1f8005ca:	06f41923          	sh	a5,114(s0)
    last_send_time = 0;
1f8005ce:	4781                	li	a5,0
1f8005d0:	4701                	li	a4,0
1f8005d2:	d05c                	sw	a5,36(s0)
    
    // 发送编码后的数据包
    ble_adv_send(index, encoded_data, encoded_data_len, SEND_BEACON_MAX_TIMES, SEND_BEACON_INTERVAL, SEND_BEACON_CHANNEL);
    
    // 清空参数
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
1f8005d4:	4661                	li	a2,24
    send_packet_request = 1;
1f8005d6:	4785                	li	a5,1
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
1f8005d8:	4581                	li	a1,0
1f8005da:	8522                	mv	a0,s0
    last_send_time = 0;
1f8005dc:	d018                	sw	a4,32(s0)
    send_packet_request = 1;
1f8005de:	00f40e23          	sb	a5,28(s0)
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
1f8005e2:	612010ef          	jal	1f801bf4 <memset>
    
    return ret;
1f8005e6:	bd09                	j	1f8003f8 <main+0x28a>
    } else if (press_time == SHORT_PRESS_THRESHOLD) {
1f8005e8:	4595                	li	a1,5
1f8005ea:	e0b697e3          	bne	a3,a1,1f8003f8 <main+0x28a>
        p_key_fun->short_press_handler((str_fun_para *)&p_key_fun->short_press_para);
1f8005ee:	46f1                	li	a3,28
1f8005f0:	02d70733          	mul	a4,a4,a3
1f8005f4:	97ba                	add	a5,a5,a4
1f8005f6:	57dc                	lw	a5,44(a5)
1f8005f8:	00870513          	addi	a0,a4,8
1f8005fc:	b729                	j	1f800506 <main+0x398>
                no_keypress_50ms_cnt = 0;
1f8005fe:	08041823          	sh	zero,144(s0)
1f800602:	b5d1                	j	1f8004c6 <main+0x358>

1f800604 <Default_Handler>:
1f800604:	400007b7          	lui	a5,0x40000
1f800608:	0f800713          	li	a4,248
1f80060c:	10e7a023          	sw	a4,256(a5) # 40000100 <__StackTop+0x1fffc100>
1f800610:	a001                	j	1f800610 <Default_Handler+0xc>

1f800612 <clic_init>:
1f800612:	e0800737          	lui	a4,0xe0800
1f800616:	435c                	lw	a5,4(a4)
1f800618:	83d1                	srli	a5,a5,0x14
1f80061a:	8bf9                	andi	a5,a5,30
1f80061c:	00f70023          	sb	a5,0(a4) # e0800000 <__StackTop+0xc07fc000>
1f800620:	4701                	li	a4,0
1f800622:	e0800537          	lui	a0,0xe0800
1f800626:	6585                	lui	a1,0x1
1f800628:	4685                	li	a3,1
1f80062a:	03000613          	li	a2,48
1f80062e:	00271793          	slli	a5,a4,0x2
1f800632:	97aa                	add	a5,a5,a0
1f800634:	97ae                	add	a5,a5,a1
1f800636:	00d78023          	sb	a3,0(a5)
1f80063a:	000780a3          	sb	zero,1(a5)
1f80063e:	00d78123          	sb	a3,2(a5)
1f800642:	0705                	addi	a4,a4,1
1f800644:	fec715e3          	bne	a4,a2,1f80062e <clic_init+0x1c>
1f800648:	8082                	ret

1f80064a <t1100_rom_init>:
1f80064a:	8082                	ret

1f80064c <ram_init>:
1f80064c:	1171                	addi	sp,sp,-4
1f80064e:	c006                	sw	ra,0(sp)
1f800650:	1f802737          	lui	a4,0x1f802
1f800654:	f9870713          	addi	a4,a4,-104 # 1f801f98 <__exidx_end>
1f800658:	1f8027b7          	lui	a5,0x1f802
1f80065c:	fa478793          	addi	a5,a5,-92 # 1f801fa4 <__copy_table_end__>
1f800660:	86ba                	mv	a3,a4
1f800662:	853e                	mv	a0,a5
1f800664:	04f76563          	bltu	a4,a5,1f8006ae <ram_init+0x62>
1f800668:	1f802737          	lui	a4,0x1f802
1f80066c:	fa470713          	addi	a4,a4,-92 # 1f801fa4 <__copy_table_end__>
1f800670:	1f8027b7          	lui	a5,0x1f802
1f800674:	fac78793          	addi	a5,a5,-84 # 1f801fac <__etext>
1f800678:	06f77063          	bgeu	a4,a5,1f8006d8 <ram_init+0x8c>
1f80067c:	86ba                	mv	a3,a4
1f80067e:	1f8025b7          	lui	a1,0x1f802
1f800682:	fab58593          	addi	a1,a1,-85 # 1f801fab <__copy_table_end__+0x7>
1f800686:	8d99                	sub	a1,a1,a4
1f800688:	99e1                	andi	a1,a1,-8
1f80068a:	05a1                	addi	a1,a1,8
1f80068c:	95ba                	add	a1,a1,a4
1f80068e:	a089                	j	1f8006d0 <ram_init+0x84>
1f800690:	00279613          	slli	a2,a5,0x2
1f800694:	4298                	lw	a4,0(a3)
1f800696:	9732                	add	a4,a4,a2
1f800698:	430c                	lw	a1,0(a4)
1f80069a:	42d8                	lw	a4,4(a3)
1f80069c:	9732                	add	a4,a4,a2
1f80069e:	c30c                	sw	a1,0(a4)
1f8006a0:	0785                	addi	a5,a5,1
1f8006a2:	4698                	lw	a4,8(a3)
1f8006a4:	fee7e6e3          	bltu	a5,a4,1f800690 <ram_init+0x44>
1f8006a8:	06b1                	addi	a3,a3,12
1f8006aa:	faa6ffe3          	bgeu	a3,a0,1f800668 <ram_init+0x1c>
1f8006ae:	4698                	lw	a4,8(a3)
1f8006b0:	4781                	li	a5,0
1f8006b2:	ff79                	bnez	a4,1f800690 <ram_init+0x44>
1f8006b4:	bfd5                	j	1f8006a8 <ram_init+0x5c>
1f8006b6:	4298                	lw	a4,0(a3)
1f8006b8:	00279613          	slli	a2,a5,0x2
1f8006bc:	9732                	add	a4,a4,a2
1f8006be:	00072023          	sw	zero,0(a4)
1f8006c2:	0785                	addi	a5,a5,1
1f8006c4:	42d8                	lw	a4,4(a3)
1f8006c6:	fee7e8e3          	bltu	a5,a4,1f8006b6 <ram_init+0x6a>
1f8006ca:	06a1                	addi	a3,a3,8
1f8006cc:	00b68663          	beq	a3,a1,1f8006d8 <ram_init+0x8c>
1f8006d0:	42d8                	lw	a4,4(a3)
1f8006d2:	4781                	li	a5,0
1f8006d4:	f36d                	bnez	a4,1f8006b6 <ram_init+0x6a>
1f8006d6:	bfd5                	j	1f8006ca <ram_init+0x7e>
1f8006d8:	3f8d                	jal	1f80064a <t1100_rom_init>
1f8006da:	4082                	lw	ra,0(sp)
1f8006dc:	0111                	addi	sp,sp,4
1f8006de:	8082                	ret

1f8006e0 <sys_entry>:
1f8006e0:	400007b7          	lui	a5,0x40000
1f8006e4:	4398                	lw	a4,0(a5)
1f8006e6:	6785                	lui	a5,0x1
1f8006e8:	10178793          	addi	a5,a5,257 # 1101 <main.c.de3c76ba+0x760>
1f8006ec:	00f70363          	beq	a4,a5,1f8006f2 <sys_entry+0x12>
1f8006f0:	8082                	ret
1f8006f2:	1141                	addi	sp,sp,-16
1f8006f4:	c606                	sw	ra,12(sp)
1f8006f6:	c422                	sw	s0,8(sp)
1f8006f8:	c226                	sw	s1,4(sp)
1f8006fa:	3f89                	jal	1f80064c <ram_init>
1f8006fc:	3f19                	jal	1f800612 <clic_init>
1f8006fe:	40080437          	lui	s0,0x40080
1f800702:	4785                	li	a5,1
1f800704:	c83c                	sw	a5,80(s0)
1f800706:	42000737          	lui	a4,0x42000
1f80070a:	6785                	lui	a5,0x1
1f80070c:	70178793          	addi	a5,a5,1793 # 1701 <main.c.de3c76ba+0xd60>
1f800710:	10f72023          	sw	a5,256(a4) # 42000100 <__StackTop+0x21ffc100>
1f800714:	2051                	jal	1f800798 <otp_load_cfg>
1f800716:	218d                	jal	1f800b78 <otp_apply_cfg>
1f800718:	30d000ef          	jal	1f801224 <PMU_OnChip_Init>
1f80071c:	400004b7          	lui	s1,0x40000
1f800720:	50dc                	lw	a5,36(s1)
1f800722:	001007b7          	lui	a5,0x100
1f800726:	40078793          	addi	a5,a5,1024 # 100400 <ble_viot.c.e415c280+0xfad5d>
1f80072a:	d0dc                	sw	a5,36(s1)
1f80072c:	42002737          	lui	a4,0x42002
1f800730:	431c                	lw	a5,0(a4)
1f800732:	9bf5                	andi	a5,a5,-3
1f800734:	c31c                	sw	a5,0(a4)
1f800736:	11042783          	lw	a5,272(s0) # 40080110 <__StackTop+0x2007c110>
1f80073a:	6721                	lui	a4,0x8
1f80073c:	80070713          	addi	a4,a4,-2048 # 7800 <ble_viot.c.e415c280+0x215d>
1f800740:	8fd9                	or	a5,a5,a4
1f800742:	10f42823          	sw	a5,272(s0)
1f800746:	00fcd537          	lui	a0,0xfcd
1f80074a:	bff50513          	addi	a0,a0,-1025 # fccbff <ble_viot.c.e415c280+0xfc755c>
1f80074e:	00800097          	auipc	ra,0x800
1f800752:	d98080e7          	jalr	-616(ra) # 200004e6 <poweron_unused_gpio_mask_parse_and_set>
1f800756:	12044783          	lbu	a5,288(s0)
1f80075a:	0047e793          	ori	a5,a5,4
1f80075e:	12f40023          	sb	a5,288(s0)
1f800762:	40000793          	li	a5,1024
1f800766:	c49c                	sw	a5,8(s1)
1f800768:	c002                	sw	zero,0(sp)
1f80076a:	4702                	lw	a4,0(sp)
1f80076c:	47a5                	li	a5,9
1f80076e:	00e7c963          	blt	a5,a4,1f800780 <sys_entry+0xa0>
1f800772:	873e                	mv	a4,a5
1f800774:	4782                	lw	a5,0(sp)
1f800776:	0785                	addi	a5,a5,1
1f800778:	c03e                	sw	a5,0(sp)
1f80077a:	4782                	lw	a5,0(sp)
1f80077c:	fef75ce3          	bge	a4,a5,1f800774 <sys_entry+0x94>
1f800780:	400007b7          	lui	a5,0x40000
1f800784:	0007a423          	sw	zero,8(a5) # 40000008 <__StackTop+0x1fffc008>
1f800788:	300467f3          	csrrsi	a5,mstatus,8
1f80078c:	32cd                	jal	1f80016e <main>
1f80078e:	40b2                	lw	ra,12(sp)
1f800790:	4422                	lw	s0,8(sp)
1f800792:	4492                	lw	s1,4(sp)
1f800794:	0141                	addi	sp,sp,16
1f800796:	8082                	ret

1f800798 <otp_load_cfg>:
1f800798:	1f8046b7          	lui	a3,0x1f804
1f80079c:	f3068713          	addi	a4,a3,-208 # 1f803f30 <__etext+0x1f84>
1f8007a0:	200017b7          	lui	a5,0x20001
1f8007a4:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
1f8007a8:	f7868693          	addi	a3,a3,-136
1f8007ac:	00072383          	lw	t2,0(a4)
1f8007b0:	00472283          	lw	t0,4(a4)
1f8007b4:	00872303          	lw	t1,8(a4)
1f8007b8:	4748                	lw	a0,12(a4)
1f8007ba:	4b0c                	lw	a1,16(a4)
1f8007bc:	4b50                	lw	a2,20(a4)
1f8007be:	0077a023          	sw	t2,0(a5)
1f8007c2:	0057a223          	sw	t0,4(a5)
1f8007c6:	0067a423          	sw	t1,8(a5)
1f8007ca:	c7c8                	sw	a0,12(a5)
1f8007cc:	cb8c                	sw	a1,16(a5)
1f8007ce:	cbd0                	sw	a2,20(a5)
1f8007d0:	0761                	addi	a4,a4,24
1f8007d2:	07e1                	addi	a5,a5,24
1f8007d4:	fcd71ce3          	bne	a4,a3,1f8007ac <otp_load_cfg+0x14>
1f8007d8:	200017b7          	lui	a5,0x20001
1f8007dc:	2ec7c703          	lbu	a4,748(a5) # 200012ec <g_otp_cfg>
1f8007e0:	0ff00793          	li	a5,255
1f8007e4:	00f71d63          	bne	a4,a5,1f8007fe <otp_load_cfg+0x66>
1f8007e8:	20001737          	lui	a4,0x20001
1f8007ec:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f8007f0:	00074783          	lbu	a5,0(a4)
1f8007f4:	9bc1                	andi	a5,a5,-16
1f8007f6:	00a7e793          	ori	a5,a5,10
1f8007fa:	00f70023          	sb	a5,0(a4)
1f8007fe:	200017b7          	lui	a5,0x20001
1f800802:	2ee7c703          	lbu	a4,750(a5) # 200012ee <g_otp_cfg+0x2>
1f800806:	0ff00793          	li	a5,255
1f80080a:	10f70f63          	beq	a4,a5,1f800928 <otp_load_cfg+0x190>
1f80080e:	200017b7          	lui	a5,0x20001
1f800812:	2f07d703          	lhu	a4,752(a5) # 200012f0 <g_otp_cfg+0x4>
1f800816:	67c1                	lui	a5,0x10
1f800818:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f80081a:	12f70363          	beq	a4,a5,1f800940 <otp_load_cfg+0x1a8>
1f80081e:	200017b7          	lui	a5,0x20001
1f800822:	2f27d703          	lhu	a4,754(a5) # 200012f2 <g_otp_cfg+0x6>
1f800826:	67c1                	lui	a5,0x10
1f800828:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f80082a:	12f70263          	beq	a4,a5,1f80094e <otp_load_cfg+0x1b6>
1f80082e:	200017b7          	lui	a5,0x20001
1f800832:	2f47d703          	lhu	a4,756(a5) # 200012f4 <g_otp_cfg+0x8>
1f800836:	67c1                	lui	a5,0x10
1f800838:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f80083a:	12f70163          	beq	a4,a5,1f80095c <otp_load_cfg+0x1c4>
1f80083e:	200017b7          	lui	a5,0x20001
1f800842:	2f87a703          	lw	a4,760(a5) # 200012f8 <g_otp_cfg+0xc>
1f800846:	57fd                	li	a5,-1
1f800848:	12f70763          	beq	a4,a5,1f800976 <otp_load_cfg+0x1de>
1f80084c:	200017b7          	lui	a5,0x20001
1f800850:	2fc7a703          	lw	a4,764(a5) # 200012fc <g_otp_cfg+0x10>
1f800854:	57fd                	li	a5,-1
1f800856:	14f70263          	beq	a4,a5,1f80099a <otp_load_cfg+0x202>
1f80085a:	200017b7          	lui	a5,0x20001
1f80085e:	3007a703          	lw	a4,768(a5) # 20001300 <g_otp_cfg+0x14>
1f800862:	57fd                	li	a5,-1
1f800864:	14f70d63          	beq	a4,a5,1f8009be <otp_load_cfg+0x226>
1f800868:	200017b7          	lui	a5,0x20001
1f80086c:	3047a703          	lw	a4,772(a5) # 20001304 <g_otp_cfg+0x18>
1f800870:	57fd                	li	a5,-1
1f800872:	16f70863          	beq	a4,a5,1f8009e2 <otp_load_cfg+0x24a>
1f800876:	200017b7          	lui	a5,0x20001
1f80087a:	3087a703          	lw	a4,776(a5) # 20001308 <g_otp_cfg+0x1c>
1f80087e:	57fd                	li	a5,-1
1f800880:	18f70363          	beq	a4,a5,1f800a06 <otp_load_cfg+0x26e>
1f800884:	200017b7          	lui	a5,0x20001
1f800888:	30c7a703          	lw	a4,780(a5) # 2000130c <g_otp_cfg+0x20>
1f80088c:	57fd                	li	a5,-1
1f80088e:	18f70e63          	beq	a4,a5,1f800a2a <otp_load_cfg+0x292>
1f800892:	200017b7          	lui	a5,0x20001
1f800896:	3107a703          	lw	a4,784(a5) # 20001310 <g_otp_cfg+0x24>
1f80089a:	57fd                	li	a5,-1
1f80089c:	1af70963          	beq	a4,a5,1f800a4e <otp_load_cfg+0x2b6>
1f8008a0:	200017b7          	lui	a5,0x20001
1f8008a4:	3147a703          	lw	a4,788(a5) # 20001314 <g_otp_cfg+0x28>
1f8008a8:	57fd                	li	a5,-1
1f8008aa:	1cf70663          	beq	a4,a5,1f800a76 <otp_load_cfg+0x2de>
1f8008ae:	200017b7          	lui	a5,0x20001
1f8008b2:	3187d703          	lhu	a4,792(a5) # 20001318 <g_otp_cfg+0x2c>
1f8008b6:	67c1                	lui	a5,0x10
1f8008b8:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f8008ba:	1ef70063          	beq	a4,a5,1f800a9a <otp_load_cfg+0x302>
1f8008be:	200017b7          	lui	a5,0x20001
1f8008c2:	31c7d703          	lhu	a4,796(a5) # 2000131c <g_otp_cfg+0x30>
1f8008c6:	67c1                	lui	a5,0x10
1f8008c8:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f8008ca:	1ef70363          	beq	a4,a5,1f800ab0 <otp_load_cfg+0x318>
1f8008ce:	200017b7          	lui	a5,0x20001
1f8008d2:	31e7d703          	lhu	a4,798(a5) # 2000131e <g_otp_cfg+0x32>
1f8008d6:	67c1                	lui	a5,0x10
1f8008d8:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f8008da:	1ef70663          	beq	a4,a5,1f800ac6 <otp_load_cfg+0x32e>
1f8008de:	200017b7          	lui	a5,0x20001
1f8008e2:	3207d703          	lhu	a4,800(a5) # 20001320 <g_otp_cfg+0x34>
1f8008e6:	67c1                	lui	a5,0x10
1f8008e8:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.e415c280+0xa95c>
1f8008ea:	1ef70963          	beq	a4,a5,1f800adc <otp_load_cfg+0x344>
1f8008ee:	200017b7          	lui	a5,0x20001
1f8008f2:	3247a703          	lw	a4,804(a5) # 20001324 <g_otp_cfg+0x38>
1f8008f6:	57fd                	li	a5,-1
1f8008f8:	1ef70f63          	beq	a4,a5,1f800af6 <otp_load_cfg+0x35e>
1f8008fc:	200017b7          	lui	a5,0x20001
1f800900:	3287a703          	lw	a4,808(a5) # 20001328 <g_otp_cfg+0x3c>
1f800904:	57fd                	li	a5,-1
1f800906:	20f70463          	beq	a4,a5,1f800b0e <otp_load_cfg+0x376>
1f80090a:	200017b7          	lui	a5,0x20001
1f80090e:	32c7a703          	lw	a4,812(a5) # 2000132c <g_otp_cfg+0x40>
1f800912:	57fd                	li	a5,-1
1f800914:	20f70c63          	beq	a4,a5,1f800b2c <otp_load_cfg+0x394>
1f800918:	200017b7          	lui	a5,0x20001
1f80091c:	3307a703          	lw	a4,816(a5) # 20001330 <g_otp_cfg+0x44>
1f800920:	57fd                	li	a5,-1
1f800922:	22f70963          	beq	a4,a5,1f800b54 <otp_load_cfg+0x3bc>
1f800926:	8082                	ret
1f800928:	20001737          	lui	a4,0x20001
1f80092c:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800930:	00274783          	lbu	a5,2(a4)
1f800934:	9bc1                	andi	a5,a5,-16
1f800936:	0037e793          	ori	a5,a5,3
1f80093a:	00f70123          	sb	a5,2(a4)
1f80093e:	bdc1                	j	1f80080e <otp_load_cfg+0x76>
1f800940:	200017b7          	lui	a5,0x20001
1f800944:	f8d00713          	li	a4,-115
1f800948:	2ee78823          	sb	a4,752(a5) # 200012f0 <g_otp_cfg+0x4>
1f80094c:	bdc9                	j	1f80081e <otp_load_cfg+0x86>
1f80094e:	200017b7          	lui	a5,0x20001
1f800952:	fb700713          	li	a4,-73
1f800956:	2ee78923          	sb	a4,754(a5) # 200012f2 <g_otp_cfg+0x6>
1f80095a:	bdd1                	j	1f80082e <otp_load_cfg+0x96>
1f80095c:	20001737          	lui	a4,0x20001
1f800960:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800964:	00875783          	lhu	a5,8(a4)
1f800968:	c007f793          	andi	a5,a5,-1024
1f80096c:	1407e793          	ori	a5,a5,320
1f800970:	00f71423          	sh	a5,8(a4)
1f800974:	b5e9                	j	1f80083e <otp_load_cfg+0xa6>
1f800976:	20001737          	lui	a4,0x20001
1f80097a:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f80097e:	475c                	lw	a5,12(a4)
1f800980:	76fd                	lui	a3,0xfffff
1f800982:	8ff5                	and	a5,a5,a3
1f800984:	2587e793          	ori	a5,a5,600
1f800988:	fc0106b7          	lui	a3,0xfc010
1f80098c:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f80098e:	8ff5                	and	a5,a5,a3
1f800990:	02ab06b7          	lui	a3,0x2ab0
1f800994:	8fd5                	or	a5,a5,a3
1f800996:	c75c                	sw	a5,12(a4)
1f800998:	bd55                	j	1f80084c <otp_load_cfg+0xb4>
1f80099a:	20001737          	lui	a4,0x20001
1f80099e:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f8009a2:	4b1c                	lw	a5,16(a4)
1f8009a4:	76fd                	lui	a3,0xfffff
1f8009a6:	8ff5                	and	a5,a5,a3
1f8009a8:	0c87e793          	ori	a5,a5,200
1f8009ac:	fc0106b7          	lui	a3,0xfc010
1f8009b0:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f8009b2:	8ff5                	and	a5,a5,a3
1f8009b4:	00e406b7          	lui	a3,0xe40
1f8009b8:	8fd5                	or	a5,a5,a3
1f8009ba:	cb1c                	sw	a5,16(a4)
1f8009bc:	bd79                	j	1f80085a <otp_load_cfg+0xc2>
1f8009be:	20001737          	lui	a4,0x20001
1f8009c2:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f8009c6:	4b5c                	lw	a5,20(a4)
1f8009c8:	76fd                	lui	a3,0xfffff
1f8009ca:	8ff5                	and	a5,a5,a3
1f8009cc:	4b07e793          	ori	a5,a5,1200
1f8009d0:	fc0106b7          	lui	a3,0xfc010
1f8009d4:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f8009d6:	8ff5                	and	a5,a5,a3
1f8009d8:	02ab06b7          	lui	a3,0x2ab0
1f8009dc:	8fd5                	or	a5,a5,a3
1f8009de:	cb5c                	sw	a5,20(a4)
1f8009e0:	b561                	j	1f800868 <otp_load_cfg+0xd0>
1f8009e2:	20001737          	lui	a4,0x20001
1f8009e6:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f8009ea:	4f1c                	lw	a5,24(a4)
1f8009ec:	76fd                	lui	a3,0xfffff
1f8009ee:	8ff5                	and	a5,a5,a3
1f8009f0:	1907e793          	ori	a5,a5,400
1f8009f4:	fc0106b7          	lui	a3,0xfc010
1f8009f8:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f8009fa:	8ff5                	and	a5,a5,a3
1f8009fc:	00e406b7          	lui	a3,0xe40
1f800a00:	8fd5                	or	a5,a5,a3
1f800a02:	cf1c                	sw	a5,24(a4)
1f800a04:	bd8d                	j	1f800876 <otp_load_cfg+0xde>
1f800a06:	20001737          	lui	a4,0x20001
1f800a0a:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800a0e:	4f5c                	lw	a5,28(a4)
1f800a10:	76fd                	lui	a3,0xfffff
1f800a12:	8ff5                	and	a5,a5,a3
1f800a14:	7087e793          	ori	a5,a5,1800
1f800a18:	fc0106b7          	lui	a3,0xfc010
1f800a1c:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f800a1e:	8ff5                	and	a5,a5,a3
1f800a20:	02ab06b7          	lui	a3,0x2ab0
1f800a24:	8fd5                	or	a5,a5,a3
1f800a26:	cf5c                	sw	a5,28(a4)
1f800a28:	bdb1                	j	1f800884 <otp_load_cfg+0xec>
1f800a2a:	20001737          	lui	a4,0x20001
1f800a2e:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800a32:	531c                	lw	a5,32(a4)
1f800a34:	76fd                	lui	a3,0xfffff
1f800a36:	8ff5                	and	a5,a5,a3
1f800a38:	2587e793          	ori	a5,a5,600
1f800a3c:	fc0106b7          	lui	a3,0xfc010
1f800a40:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f800a42:	8ff5                	and	a5,a5,a3
1f800a44:	00e406b7          	lui	a3,0xe40
1f800a48:	8fd5                	or	a5,a5,a3
1f800a4a:	d31c                	sw	a5,32(a4)
1f800a4c:	b599                	j	1f800892 <otp_load_cfg+0xfa>
1f800a4e:	20001737          	lui	a4,0x20001
1f800a52:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800a56:	535c                	lw	a5,36(a4)
1f800a58:	76fd                	lui	a3,0xfffff
1f800a5a:	8ff5                	and	a5,a5,a3
1f800a5c:	6685                	lui	a3,0x1
1f800a5e:	96068693          	addi	a3,a3,-1696 # 960 <__STACK_SIZE+0x660>
1f800a62:	8fd5                	or	a5,a5,a3
1f800a64:	fc0106b7          	lui	a3,0xfc010
1f800a68:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f800a6a:	8ff5                	and	a5,a5,a3
1f800a6c:	02ab06b7          	lui	a3,0x2ab0
1f800a70:	8fd5                	or	a5,a5,a3
1f800a72:	d35c                	sw	a5,36(a4)
1f800a74:	b535                	j	1f8008a0 <otp_load_cfg+0x108>
1f800a76:	20001737          	lui	a4,0x20001
1f800a7a:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800a7e:	571c                	lw	a5,40(a4)
1f800a80:	76fd                	lui	a3,0xfffff
1f800a82:	8ff5                	and	a5,a5,a3
1f800a84:	3207e793          	ori	a5,a5,800
1f800a88:	fc0106b7          	lui	a3,0xfc010
1f800a8c:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f800a8e:	8ff5                	and	a5,a5,a3
1f800a90:	00e406b7          	lui	a3,0xe40
1f800a94:	8fd5                	or	a5,a5,a3
1f800a96:	d71c                	sw	a5,40(a4)
1f800a98:	bd19                	j	1f8008ae <otp_load_cfg+0x116>
1f800a9a:	200017b7          	lui	a5,0x20001
1f800a9e:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
1f800aa2:	02c7d703          	lhu	a4,44(a5)
1f800aa6:	3ff76713          	ori	a4,a4,1023
1f800aaa:	02e79623          	sh	a4,44(a5)
1f800aae:	bd01                	j	1f8008be <otp_load_cfg+0x126>
1f800ab0:	200017b7          	lui	a5,0x20001
1f800ab4:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
1f800ab8:	0307d703          	lhu	a4,48(a5)
1f800abc:	76fd                	lui	a3,0xfffff
1f800abe:	8f75                	and	a4,a4,a3
1f800ac0:	02e79823          	sh	a4,48(a5)
1f800ac4:	b529                	j	1f8008ce <otp_load_cfg+0x136>
1f800ac6:	200017b7          	lui	a5,0x20001
1f800aca:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
1f800ace:	0327d703          	lhu	a4,50(a5)
1f800ad2:	76fd                	lui	a3,0xfffff
1f800ad4:	8f75                	and	a4,a4,a3
1f800ad6:	02e79923          	sh	a4,50(a5)
1f800ada:	b511                	j	1f8008de <otp_load_cfg+0x146>
1f800adc:	20001737          	lui	a4,0x20001
1f800ae0:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800ae4:	03475783          	lhu	a5,52(a4)
1f800ae8:	76fd                	lui	a3,0xfffff
1f800aea:	8ff5                	and	a5,a5,a3
1f800aec:	40c7e793          	ori	a5,a5,1036
1f800af0:	02f71a23          	sh	a5,52(a4)
1f800af4:	bbed                	j	1f8008ee <otp_load_cfg+0x156>
1f800af6:	20001737          	lui	a4,0x20001
1f800afa:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800afe:	5f1c                	lw	a5,56(a4)
1f800b00:	800006b7          	lui	a3,0x80000
1f800b04:	8ff5                	and	a5,a5,a3
1f800b06:	0357e793          	ori	a5,a5,53
1f800b0a:	df1c                	sw	a5,56(a4)
1f800b0c:	bbc5                	j	1f8008fc <otp_load_cfg+0x164>
1f800b0e:	20001737          	lui	a4,0x20001
1f800b12:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800b16:	5f5c                	lw	a5,60(a4)
1f800b18:	800006b7          	lui	a3,0x80000
1f800b1c:	8ff5                	and	a5,a5,a3
1f800b1e:	0003b6b7          	lui	a3,0x3b
1f800b22:	98068693          	addi	a3,a3,-1664 # 3a980 <ble_viot.c.e415c280+0x352dd>
1f800b26:	8fd5                	or	a5,a5,a3
1f800b28:	df5c                	sw	a5,60(a4)
1f800b2a:	b3c5                	j	1f80090a <otp_load_cfg+0x172>
1f800b2c:	20001737          	lui	a4,0x20001
1f800b30:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800b34:	433c                	lw	a5,64(a4)
1f800b36:	76fd                	lui	a3,0xfffff
1f800b38:	8ff5                	and	a5,a5,a3
1f800b3a:	6685                	lui	a3,0x1
1f800b3c:	bb868693          	addi	a3,a3,-1096 # bb8 <main.c.de3c76ba+0x217>
1f800b40:	8fd5                	or	a5,a5,a3
1f800b42:	fc0106b7          	lui	a3,0xfc010
1f800b46:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f800b48:	8ff5                	and	a5,a5,a3
1f800b4a:	035506b7          	lui	a3,0x3550
1f800b4e:	8fd5                	or	a5,a5,a3
1f800b50:	c33c                	sw	a5,64(a4)
1f800b52:	b3d9                	j	1f800918 <otp_load_cfg+0x180>
1f800b54:	20001737          	lui	a4,0x20001
1f800b58:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800b5c:	437c                	lw	a5,68(a4)
1f800b5e:	76fd                	lui	a3,0xfffff
1f800b60:	8ff5                	and	a5,a5,a3
1f800b62:	7d07e793          	ori	a5,a5,2000
1f800b66:	fc0106b7          	lui	a3,0xfc010
1f800b6a:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1f800b6c:	8ff5                	and	a5,a5,a3
1f800b6e:	023906b7          	lui	a3,0x2390
1f800b72:	8fd5                	or	a5,a5,a3
1f800b74:	c37c                	sw	a5,68(a4)
1f800b76:	8082                	ret

1f800b78 <otp_apply_cfg>:
1f800b78:	400807b7          	lui	a5,0x40080
1f800b7c:	1047a603          	lw	a2,260(a5) # 40080104 <__StackTop+0x2007c104>
1f800b80:	fffc4737          	lui	a4,0xfffc4
1f800b84:	177d                	addi	a4,a4,-1 # fffc3fff <__StackTop+0xdffbffff>
1f800b86:	8e79                	and	a2,a2,a4
1f800b88:	20001737          	lui	a4,0x20001
1f800b8c:	2ec70713          	addi	a4,a4,748 # 200012ec <g_otp_cfg>
1f800b90:	00275683          	lhu	a3,2(a4)
1f800b94:	8abd                	andi	a3,a3,15
1f800b96:	06ba                	slli	a3,a3,0xe
1f800b98:	8ed1                	or	a3,a3,a2
1f800b9a:	10d7a223          	sw	a3,260(a5)
1f800b9e:	1087a603          	lw	a2,264(a5)
1f800ba2:	76c1                	lui	a3,0xffff0
1f800ba4:	0ff68693          	addi	a3,a3,255 # ffff00ff <__StackTop+0xdffec0ff>
1f800ba8:	8e75                	and	a2,a2,a3
1f800baa:	00474683          	lbu	a3,4(a4)
1f800bae:	06a2                	slli	a3,a3,0x8
1f800bb0:	8ed1                	or	a3,a3,a2
1f800bb2:	10d7a423          	sw	a3,264(a5)
1f800bb6:	10c7a603          	lw	a2,268(a5)
1f800bba:	76e1                	lui	a3,0xffff8
1f800bbc:	07f68693          	addi	a3,a3,127 # ffff807f <__StackTop+0xdfff407f>
1f800bc0:	8e75                	and	a2,a2,a3
1f800bc2:	00674683          	lbu	a3,6(a4)
1f800bc6:	069e                	slli	a3,a3,0x7
1f800bc8:	8ed1                	or	a3,a3,a2
1f800bca:	10d7a623          	sw	a3,268(a5)
1f800bce:	1107a603          	lw	a2,272(a5)
1f800bd2:	ff0406b7          	lui	a3,0xff040
1f800bd6:	16fd                	addi	a3,a3,-1 # ff03ffff <__StackTop+0xdf03bfff>
1f800bd8:	8e75                	and	a2,a2,a3
1f800bda:	5f14                	lw	a3,56(a4)
1f800bdc:	06ca                	slli	a3,a3,0x12
1f800bde:	8ed1                	or	a3,a3,a2
1f800be0:	10d7a823          	sw	a3,272(a5)
1f800be4:	42002637          	lui	a2,0x42002
1f800be8:	4614                	lw	a3,8(a2)
1f800bea:	880007b7          	lui	a5,0x88000
1f800bee:	17fd                	addi	a5,a5,-1 # 87ffffff <__StackTop+0x67ffbfff>
1f800bf0:	8efd                	and	a3,a3,a5
1f800bf2:	431c                	lw	a5,0(a4)
1f800bf4:	8bbd                	andi	a5,a5,15
1f800bf6:	07ee                	slli	a5,a5,0x1b
1f800bf8:	8fd5                	or	a5,a5,a3
1f800bfa:	c61c                	sw	a5,8(a2)
1f800bfc:	8082                	ret

1f800bfe <cal_autolen_pkt_desc_offset>:
1f800bfe:	200017b7          	lui	a5,0x20001
1f800c02:	32078a23          	sb	zero,820(a5) # 20001334 <autolen_pkt_desc_offset>
1f800c06:	200017b7          	lui	a5,0x20001
1f800c0a:	3587c783          	lbu	a5,856(a5) # 20001358 <rf_2g4_mgr+0x1c>
1f800c0e:	cf9d                	beqz	a5,1f800c4c <cal_autolen_pkt_desc_offset+0x4e>
1f800c10:	200017b7          	lui	a5,0x20001
1f800c14:	3597c783          	lbu	a5,857(a5) # 20001359 <rf_2g4_mgr+0x1d>
1f800c18:	c791                	beqz	a5,1f800c24 <cal_autolen_pkt_desc_offset+0x26>
1f800c1a:	200017b7          	lui	a5,0x20001
1f800c1e:	4705                	li	a4,1
1f800c20:	32e78a23          	sb	a4,820(a5) # 20001334 <autolen_pkt_desc_offset>
1f800c24:	200017b7          	lui	a5,0x20001
1f800c28:	33478793          	addi	a5,a5,820 # 20001334 <autolen_pkt_desc_offset>
1f800c2c:	0007c703          	lbu	a4,0(a5)
1f800c30:	00170693          	addi	a3,a4,1
1f800c34:	00d78023          	sb	a3,0(a5)
1f800c38:	200017b7          	lui	a5,0x20001
1f800c3c:	35b7c783          	lbu	a5,859(a5) # 2000135b <rf_2g4_mgr+0x1f>
1f800c40:	c791                	beqz	a5,1f800c4c <cal_autolen_pkt_desc_offset+0x4e>
1f800c42:	0709                	addi	a4,a4,2
1f800c44:	200017b7          	lui	a5,0x20001
1f800c48:	32e78a23          	sb	a4,820(a5) # 20001334 <autolen_pkt_desc_offset>
1f800c4c:	8082                	ret

1f800c4e <RF_2G4_DescInit_Mode>:
1f800c4e:	200017b7          	lui	a5,0x20001
1f800c52:	38a7c703          	lbu	a4,906(a5) # 2000138a <rf_2g4_thld+0x2>
1f800c56:	200017b7          	lui	a5,0x20001
1f800c5a:	3d478793          	addi	a5,a5,980 # 200013d4 <rf_common_desc_modem_rx>
1f800c5e:	08f50c63          	beq	a0,a5,1f800cf6 <RF_2G4_DescInit_Mode+0xa8>
1f800c62:	420026b7          	lui	a3,0x42002
1f800c66:	0c06a783          	lw	a5,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
1f800c6a:	07f7f793          	andi	a5,a5,127
1f800c6e:	0cf6a023          	sw	a5,192(a3)
1f800c72:	200017b7          	lui	a5,0x20001
1f800c76:	33e7c783          	lbu	a5,830(a5) # 2000133e <rf_2g4_mgr+0x2>
1f800c7a:	46c5                	li	a3,17
1f800c7c:	cf95                	beqz	a5,1f800cb8 <RF_2G4_DescInit_Mode+0x6a>
1f800c7e:	4605                	li	a2,1
1f800c80:	04c78463          	beq	a5,a2,1f800cc8 <RF_2G4_DescInit_Mode+0x7a>
1f800c84:	08000793          	li	a5,128
1f800c88:	42001637          	lui	a2,0x42001
1f800c8c:	00460593          	addi	a1,a2,4 # 42001004 <__StackTop+0x21ffd004>
1f800c90:	c10c                	sw	a1,0(a0)
1f800c92:	06c2                	slli	a3,a3,0x10
1f800c94:	6589                	lui	a1,0x2
1f800c96:	8ecd                	or	a3,a3,a1
1f800c98:	c154                	sw	a3,4(a0)
1f800c9a:	08c60693          	addi	a3,a2,140
1f800c9e:	c514                	sw	a3,8(a0)
1f800ca0:	0742                	slli	a4,a4,0x10
1f800ca2:	8f4d                	or	a4,a4,a1
1f800ca4:	c558                	sw	a4,12(a0)
1f800ca6:	05060613          	addi	a2,a2,80
1f800caa:	c910                	sw	a2,16(a0)
1f800cac:	07c2                	slli	a5,a5,0x10
1f800cae:	8fcd                	or	a5,a5,a1
1f800cb0:	0087e793          	ori	a5,a5,8
1f800cb4:	c95c                	sw	a5,20(a0)
1f800cb6:	8082                	ret
1f800cb8:	46c5                	li	a3,17
1f800cba:	200017b7          	lui	a5,0x20001
1f800cbe:	3887c703          	lbu	a4,904(a5) # 20001388 <rf_2g4_thld>
1f800cc2:	08000793          	li	a5,128
1f800cc6:	b7c9                	j	1f800c88 <RF_2G4_DescInit_Mode+0x3a>
1f800cc8:	420026b7          	lui	a3,0x42002
1f800ccc:	0c06a703          	lw	a4,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
1f800cd0:	08076713          	ori	a4,a4,128
1f800cd4:	0ce6a023          	sw	a4,192(a3)
1f800cd8:	20001737          	lui	a4,0x20001
1f800cdc:	3d470713          	addi	a4,a4,980 # 200013d4 <rf_common_desc_modem_rx>
1f800ce0:	468d                	li	a3,3
1f800ce2:	00e50363          	beq	a0,a4,1f800ce8 <RF_2G4_DescInit_Mode+0x9a>
1f800ce6:	86be                	mv	a3,a5
1f800ce8:	200017b7          	lui	a5,0x20001
1f800cec:	3897c703          	lbu	a4,905(a5) # 20001389 <rf_2g4_thld+0x1>
1f800cf0:	08400793          	li	a5,132
1f800cf4:	bf51                	j	1f800c88 <RF_2G4_DescInit_Mode+0x3a>
1f800cf6:	420026b7          	lui	a3,0x42002
1f800cfa:	0c06a783          	lw	a5,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
1f800cfe:	07f7f793          	andi	a5,a5,127
1f800d02:	0cf6a023          	sw	a5,192(a3)
1f800d06:	200017b7          	lui	a5,0x20001
1f800d0a:	33e7c783          	lbu	a5,830(a5) # 2000133e <rf_2g4_mgr+0x2>
1f800d0e:	4685                	li	a3,1
1f800d10:	f7bd                	bnez	a5,1f800c7e <RF_2G4_DescInit_Mode+0x30>
1f800d12:	4685                	li	a3,1
1f800d14:	b75d                	j	1f800cba <RF_2G4_DescInit_Mode+0x6c>

1f800d16 <RF_2G4_UpdateDesc_TxCommon>:
1f800d16:	20001537          	lui	a0,0x20001
1f800d1a:	39050513          	addi	a0,a0,912 # 20001390 <rf_2g4_tx_pkt_desc>
1f800d1e:	200017b7          	lui	a5,0x20001
1f800d22:	37878793          	addi	a5,a5,888 # 20001378 <rf_2g4_preamble>
1f800d26:	c11c                	sw	a5,0(a0)
1f800d28:	200016b7          	lui	a3,0x20001
1f800d2c:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
1f800d30:	0036c703          	lbu	a4,3(a3)
1f800d34:	070e                	slli	a4,a4,0x3
1f800d36:	177d                	addi	a4,a4,-1
1f800d38:	0742                	slli	a4,a4,0x10
1f800d3a:	6605                	lui	a2,0x1
1f800d3c:	8f51                	or	a4,a4,a2
1f800d3e:	c158                	sw	a4,4(a0)
1f800d40:	00468793          	addi	a5,a3,4
1f800d44:	c51c                	sw	a5,8(a0)
1f800d46:	00c6c783          	lbu	a5,12(a3)
1f800d4a:	078e                	slli	a5,a5,0x3
1f800d4c:	17fd                	addi	a5,a5,-1
1f800d4e:	07c2                	slli	a5,a5,0x10
1f800d50:	8fd1                	or	a5,a5,a2
1f800d52:	c55c                	sw	a5,12(a0)
1f800d54:	0521                	addi	a0,a0,8
1f800d56:	8082                	ret

1f800d58 <RF_2G4_UpdateDesc_TxPkt>:
1f800d58:	1131                	addi	sp,sp,-20
1f800d5a:	c806                	sw	ra,16(sp)
1f800d5c:	c622                	sw	s0,12(sp)
1f800d5e:	c426                	sw	s1,8(sp)
1f800d60:	20001437          	lui	s0,0x20001
1f800d64:	33c40413          	addi	s0,s0,828 # 2000133c <rf_2g4_mgr>
1f800d68:	00f44783          	lbu	a5,15(s0)
1f800d6c:	079a                	slli	a5,a5,0x6
1f800d6e:	0407f793          	andi	a5,a5,64
1f800d72:	c03e                	sw	a5,0(sp)
1f800d74:	01244783          	lbu	a5,18(s0)
1f800d78:	0792                	slli	a5,a5,0x4
1f800d7a:	8bc1                	andi	a5,a5,16
1f800d7c:	c23e                	sw	a5,4(sp)
1f800d7e:	00179493          	slli	s1,a5,0x1
1f800d82:	3f51                	jal	1f800d16 <RF_2G4_UpdateDesc_TxCommon>
1f800d84:	00850713          	addi	a4,a0,8
1f800d88:	505c                	lw	a5,36(s0)
1f800d8a:	0087d693          	srli	a3,a5,0x8
1f800d8e:	02344603          	lbu	a2,35(s0)
1f800d92:	0ff7f793          	zext.b	a5,a5
1f800d96:	07a2                	slli	a5,a5,0x8
1f800d98:	8fd1                	or	a5,a5,a2
1f800d9a:	40f687b3          	sub	a5,a3,a5
1f800d9e:	200016b7          	lui	a3,0x20001
1f800da2:	38f69623          	sh	a5,908(a3) # 2000138c <rf_2g4_trans_len>
1f800da6:	01c44783          	lbu	a5,28(s0)
1f800daa:	c7b5                	beqz	a5,1f800e16 <RF_2G4_UpdateDesc_TxPkt+0xbe>
1f800dac:	200017b7          	lui	a5,0x20001
1f800db0:	3597c783          	lbu	a5,857(a5) # 20001359 <rf_2g4_mgr+0x1d>
1f800db4:	c79d                	beqz	a5,1f800de2 <RF_2G4_UpdateDesc_TxPkt+0x8a>
1f800db6:	20001737          	lui	a4,0x20001
1f800dba:	33c70713          	addi	a4,a4,828 # 2000133c <rf_2g4_mgr>
1f800dbe:	01e70793          	addi	a5,a4,30
1f800dc2:	c51c                	sw	a5,8(a0)
1f800dc4:	01d74783          	lbu	a5,29(a4)
1f800dc8:	17fd                	addi	a5,a5,-1
1f800dca:	07c2                	slli	a5,a5,0x10
1f800dcc:	01174703          	lbu	a4,17(a4)
1f800dd0:	8f45                	or	a4,a4,s1
1f800dd2:	8fd9                	or	a5,a5,a4
1f800dd4:	4702                	lw	a4,0(sp)
1f800dd6:	8fd9                	or	a5,a5,a4
1f800dd8:	6705                	lui	a4,0x1
1f800dda:	8fd9                	or	a5,a5,a4
1f800ddc:	c55c                	sw	a5,12(a0)
1f800dde:	01050713          	addi	a4,a0,16
1f800de2:	200017b7          	lui	a5,0x20001
1f800de6:	38c78793          	addi	a5,a5,908 # 2000138c <rf_2g4_trans_len>
1f800dea:	c31c                	sw	a5,0(a4)
1f800dec:	200016b7          	lui	a3,0x20001
1f800df0:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
1f800df4:	01c6c783          	lbu	a5,28(a3)
1f800df8:	17fd                	addi	a5,a5,-1
1f800dfa:	07c2                	slli	a5,a5,0x10
1f800dfc:	0116c603          	lbu	a2,17(a3)
1f800e00:	8e45                	or	a2,a2,s1
1f800e02:	8fd1                	or	a5,a5,a2
1f800e04:	4602                	lw	a2,0(sp)
1f800e06:	8fd1                	or	a5,a5,a2
1f800e08:	6605                	lui	a2,0x1
1f800e0a:	8fd1                	or	a5,a5,a2
1f800e0c:	c35c                	sw	a5,4(a4)
1f800e0e:	01f6c783          	lbu	a5,31(a3)
1f800e12:	ebb9                	bnez	a5,1f800e68 <RF_2G4_UpdateDesc_TxPkt+0x110>
1f800e14:	0721                	addi	a4,a4,8 # 1008 <main.c.de3c76ba+0x667>
1f800e16:	200016b7          	lui	a3,0x20001
1f800e1a:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
1f800e1e:	0236c603          	lbu	a2,35(a3)
1f800e22:	0246c783          	lbu	a5,36(a3)
1f800e26:	07a2                	slli	a5,a5,0x8
1f800e28:	8fd1                	or	a5,a5,a2
1f800e2a:	20001637          	lui	a2,0x20001
1f800e2e:	33862603          	lw	a2,824(a2) # 20001338 <rf_2g4_fifo>
1f800e32:	97b2                	add	a5,a5,a2
1f800e34:	c31c                	sw	a5,0(a4)
1f800e36:	200017b7          	lui	a5,0x20001
1f800e3a:	38c7d783          	lhu	a5,908(a5) # 2000138c <rf_2g4_trans_len>
1f800e3e:	078e                	slli	a5,a5,0x3
1f800e40:	17fd                	addi	a5,a5,-1
1f800e42:	07c2                	slli	a5,a5,0x10
1f800e44:	0116c683          	lbu	a3,17(a3)
1f800e48:	8cd5                	or	s1,s1,a3
1f800e4a:	8fc5                	or	a5,a5,s1
1f800e4c:	4692                	lw	a3,4(sp)
1f800e4e:	8fd5                	or	a5,a5,a3
1f800e50:	4682                	lw	a3,0(sp)
1f800e52:	8fd5                	or	a5,a5,a3
1f800e54:	6685                	lui	a3,0x1
1f800e56:	8fd5                	or	a5,a5,a3
1f800e58:	0087e793          	ori	a5,a5,8
1f800e5c:	c35c                	sw	a5,4(a4)
1f800e5e:	40c2                	lw	ra,16(sp)
1f800e60:	4432                	lw	s0,12(sp)
1f800e62:	44a2                	lw	s1,8(sp)
1f800e64:	0151                	addi	sp,sp,20
1f800e66:	8082                	ret
1f800e68:	200016b7          	lui	a3,0x20001
1f800e6c:	33c68693          	addi	a3,a3,828 # 2000133c <rf_2g4_mgr>
1f800e70:	02068793          	addi	a5,a3,32
1f800e74:	c71c                	sw	a5,8(a4)
1f800e76:	01f6c783          	lbu	a5,31(a3)
1f800e7a:	17fd                	addi	a5,a5,-1
1f800e7c:	07c2                	slli	a5,a5,0x10
1f800e7e:	0116c683          	lbu	a3,17(a3)
1f800e82:	8ec5                	or	a3,a3,s1
1f800e84:	8fd5                	or	a5,a5,a3
1f800e86:	4682                	lw	a3,0(sp)
1f800e88:	8fd5                	or	a5,a5,a3
1f800e8a:	6685                	lui	a3,0x1
1f800e8c:	8fd5                	or	a5,a5,a3
1f800e8e:	c75c                	sw	a5,12(a4)
1f800e90:	0741                	addi	a4,a4,16
1f800e92:	b751                	j	1f800e16 <RF_2G4_UpdateDesc_TxPkt+0xbe>

1f800e94 <reverse8>:
1f800e94:	00151793          	slli	a5,a0,0x1
1f800e98:	8505                	srai	a0,a0,0x1
1f800e9a:	05557713          	andi	a4,a0,85
1f800e9e:	0aa7f513          	andi	a0,a5,170
1f800ea2:	8d59                	or	a0,a0,a4
1f800ea4:	00251793          	slli	a5,a0,0x2
1f800ea8:	8509                	srai	a0,a0,0x2
1f800eaa:	03357513          	andi	a0,a0,51
1f800eae:	0cc7f793          	andi	a5,a5,204
1f800eb2:	8d5d                	or	a0,a0,a5
1f800eb4:	00451793          	slli	a5,a0,0x4
1f800eb8:	8111                	srli	a0,a0,0x4
1f800eba:	8d5d                	or	a0,a0,a5
1f800ebc:	0ff57513          	zext.b	a0,a0
1f800ec0:	8082                	ret

1f800ec2 <omw_svc_2g4_set_phy_divisor>:
1f800ec2:	87aa                	mv	a5,a0
1f800ec4:	e111                	bnez	a0,1f800ec8 <omw_svc_2g4_set_phy_divisor+0x6>
1f800ec6:	4785                	li	a5,1
1f800ec8:	0ff7f793          	zext.b	a5,a5
1f800ecc:	20001737          	lui	a4,0x20001
1f800ed0:	33e74683          	lbu	a3,830(a4) # 2000133e <rf_2g4_mgr+0x2>
1f800ed4:	4705                	li	a4,1
1f800ed6:	04d77163          	bgeu	a4,a3,1f800f18 <omw_svc_2g4_set_phy_divisor+0x56>
1f800eda:	00279713          	slli	a4,a5,0x2
1f800ede:	973e                	add	a4,a4,a5
1f800ee0:	0746                	slli	a4,a4,0x11
1f800ee2:	6695                	lui	a3,0x5
1f800ee4:	06a1                	addi	a3,a3,8 # 5008 <__RAM_SIZE+0x1008>
1f800ee6:	8f55                	or	a4,a4,a3
1f800ee8:	200006b7          	lui	a3,0x20000
1f800eec:	1ae6ae23          	sw	a4,444(a3) # 200001bc <rf_common_desc_tx_end_delay+0x4>
1f800ef0:	4705                	li	a4,1
1f800ef2:	02a77b63          	bgeu	a4,a0,1f800f28 <omw_svc_2g4_set_phy_divisor+0x66>
1f800ef6:	0ff78693          	addi	a3,a5,255
1f800efa:	42001737          	lui	a4,0x42001
1f800efe:	06d71823          	sh	a3,112(a4) # 42001070 <__StackTop+0x21ffd070>
1f800f02:	42000737          	lui	a4,0x42000
1f800f06:	4685                	li	a3,1
1f800f08:	0cd707a3          	sb	a3,207(a4) # 420000cf <__StackTop+0x21ffc0cf>
1f800f0c:	6741                	lui	a4,0x10
1f800f0e:	97ba                	add	a5,a5,a4
1f800f10:	42000737          	lui	a4,0x42000
1f800f14:	cf7c                	sw	a5,92(a4)
1f800f16:	8082                	ret
1f800f18:	00279713          	slli	a4,a5,0x2
1f800f1c:	973e                	add	a4,a4,a5
1f800f1e:	0742                	slli	a4,a4,0x10
1f800f20:	6695                	lui	a3,0x5
1f800f22:	06a1                	addi	a3,a3,8 # 5008 <__RAM_SIZE+0x1008>
1f800f24:	8f55                	or	a4,a4,a3
1f800f26:	b7c9                	j	1f800ee8 <omw_svc_2g4_set_phy_divisor+0x26>
1f800f28:	42001737          	lui	a4,0x42001
1f800f2c:	06071823          	sh	zero,112(a4) # 42001070 <__StackTop+0x21ffd070>
1f800f30:	42000737          	lui	a4,0x42000
1f800f34:	0c0707a3          	sb	zero,207(a4) # 420000cf <__StackTop+0x21ffc0cf>
1f800f38:	bfd1                	j	1f800f0c <omw_svc_2g4_set_phy_divisor+0x4a>

1f800f3a <RF_2G4_PrepareStart>:
1f800f3a:	1151                	addi	sp,sp,-12
1f800f3c:	c406                	sw	ra,8(sp)
1f800f3e:	c222                	sw	s0,4(sp)
1f800f40:	c026                	sw	s1,0(sp)
1f800f42:	20001437          	lui	s0,0x20001
1f800f46:	33c40413          	addi	s0,s0,828 # 2000133c <rf_2g4_mgr>
1f800f4a:	00244703          	lbu	a4,2(s0)
1f800f4e:	1f8027b7          	lui	a5,0x1f802
1f800f52:	f4078793          	addi	a5,a5,-192 # 1f801f40 <freq_ratios>
1f800f56:	97ba                	add	a5,a5,a4
1f800f58:	0007c503          	lbu	a0,0(a5)
1f800f5c:	379d                	jal	1f800ec2 <omw_svc_2g4_set_phy_divisor>
1f800f5e:	4048                	lw	a0,4(s0)
1f800f60:	007ff097          	auipc	ra,0x7ff
1f800f64:	61e080e7          	jalr	1566(ra) # 2000057e <omw_svc_2g4_set_access_word>
1f800f68:	01344783          	lbu	a5,19(s0)
1f800f6c:	420004b7          	lui	s1,0x42000
1f800f70:	ccdc                	sw	a5,28(s1)
1f800f72:	485c                	lw	a5,20(s0)
1f800f74:	d09c                	sw	a5,32(s1)
1f800f76:	4c1c                	lw	a5,24(s0)
1f800f78:	d0dc                	sw	a5,36(s1)
1f800f7a:	01c44783          	lbu	a5,28(s0)
1f800f7e:	04f48a23          	sb	a5,84(s1) # 42000054 <__StackTop+0x21ffc054>
1f800f82:	20001537          	lui	a0,0x20001
1f800f86:	3ec50513          	addi	a0,a0,1004 # 200013ec <rf_common_desc_modem_tx>
1f800f8a:	31d1                	jal	1f800c4e <RF_2G4_DescInit_Mode>
1f800f8c:	01044783          	lbu	a5,16(s0)
1f800f90:	00f49a23          	sh	a5,20(s1)
1f800f94:	00045583          	lhu	a1,0(s0)
1f800f98:	20000537          	lui	a0,0x20000
1f800f9c:	35450513          	addi	a0,a0,852 # 20000354 <rf_common_desc_tx_setfreq>
1f800fa0:	00800097          	auipc	ra,0x800
1f800fa4:	8c2080e7          	jalr	-1854(ra) # 20000862 <RADIO_CommonDescInit_SetFreq>
1f800fa8:	200007b7          	lui	a5,0x20000
1f800fac:	0e078793          	addi	a5,a5,224 # 200000e0 <rf_2g4_common_desc_pll_delay>
1f800fb0:	0047d703          	lhu	a4,4(a5)
1f800fb4:	001e06b7          	lui	a3,0x1e0
1f800fb8:	8f55                	or	a4,a4,a3
1f800fba:	c3d8                	sw	a4,4(a5)
1f800fbc:	20000737          	lui	a4,0x20000
1f800fc0:	200017b7          	lui	a5,0x20001
1f800fc4:	39078793          	addi	a5,a5,912 # 20001390 <rf_2g4_tx_pkt_desc>
1f800fc8:	12f72023          	sw	a5,288(a4) # 20000120 <rf_call_desc_list_tx_process+0x38>
1f800fcc:	4cbc                	lw	a5,88(s1)
1f800fce:	83a1                	srli	a5,a5,0x8
1f800fd0:	8b85                	andi	a5,a5,1
1f800fd2:	00444703          	lbu	a4,4(s0)
1f800fd6:	8b05                	andi	a4,a4,1
1f800fd8:	05500693          	li	a3,85
1f800fdc:	02e78f63          	beq	a5,a4,1f80101a <RF_2G4_PrepareStart+0xe0>
1f800fe0:	200017b7          	lui	a5,0x20001
1f800fe4:	33f7c703          	lbu	a4,831(a5) # 2000133f <rf_2g4_mgr+0x3>
1f800fe8:	cb19                	beqz	a4,1f800ffe <RF_2G4_PrepareStart+0xc4>
1f800fea:	200017b7          	lui	a5,0x20001
1f800fee:	37878793          	addi	a5,a5,888 # 20001378 <rf_2g4_preamble>
1f800ff2:	973e                	add	a4,a4,a5
1f800ff4:	00d78023          	sb	a3,0(a5)
1f800ff8:	0785                	addi	a5,a5,1
1f800ffa:	fee79de3          	bne	a5,a4,1f800ff4 <RF_2G4_PrepareStart+0xba>
1f800ffe:	200017b7          	lui	a5,0x20001
1f801002:	33c78793          	addi	a5,a5,828 # 2000133c <rf_2g4_mgr>
1f801006:	4705                	li	a4,1
1f801008:	02e787a3          	sb	a4,47(a5)
1f80100c:	02078823          	sb	zero,48(a5)
1f801010:	40a2                	lw	ra,8(sp)
1f801012:	4412                	lw	s0,4(sp)
1f801014:	4482                	lw	s1,0(sp)
1f801016:	0131                	addi	sp,sp,12
1f801018:	8082                	ret
1f80101a:	0aa00693          	li	a3,170
1f80101e:	b7c9                	j	1f800fe0 <RF_2G4_PrepareStart+0xa6>

1f801020 <omw_svc_2g4_init>:
1f801020:	1151                	addi	sp,sp,-12
1f801022:	c406                	sw	ra,8(sp)
1f801024:	85aa                	mv	a1,a0
1f801026:	200017b7          	lui	a5,0x20001
1f80102a:	38878793          	addi	a5,a5,904 # 20001388 <rf_2g4_thld>
1f80102e:	4709                	li	a4,2
1f801030:	00e78023          	sb	a4,0(a5)
1f801034:	00e780a3          	sb	a4,1(a5)
1f801038:	00e78123          	sb	a4,2(a5)
1f80103c:	00e781a3          	sb	a4,3(a5)
1f801040:	03b00613          	li	a2,59
1f801044:	20001537          	lui	a0,0x20001
1f801048:	33c50513          	addi	a0,a0,828 # 2000133c <rf_2g4_mgr>
1f80104c:	391000ef          	jal	1f801bdc <memcpy>
1f801050:	367d                	jal	1f800bfe <cal_autolen_pkt_desc_offset>
1f801052:	40a2                	lw	ra,8(sp)
1f801054:	0131                	addi	sp,sp,12
1f801056:	8082                	ret

1f801058 <omw_rf_init>:
1f801058:	1151                	addi	sp,sp,-12
1f80105a:	c406                	sw	ra,8(sp)
1f80105c:	420006b7          	lui	a3,0x42000
1f801060:	6605                	lui	a2,0x1
1f801062:	70160793          	addi	a5,a2,1793 # 1701 <main.c.de3c76ba+0xd60>
1f801066:	10f69023          	sh	a5,256(a3) # 42000100 <__StackTop+0x21ffc100>
1f80106a:	478d                	li	a5,3
1f80106c:	06f68023          	sb	a5,96(a3)
1f801070:	e08007b7          	lui	a5,0xe0800
1f801074:	43d8                	lw	a4,4(a5)
1f801076:	8355                	srli	a4,a4,0x15
1f801078:	00f77793          	andi	a5,a4,15
1f80107c:	4721                	li	a4,8
1f80107e:	8f1d                	sub	a4,a4,a5
1f801080:	e08015b7          	lui	a1,0xe0801
1f801084:	04b5c783          	lbu	a5,75(a1) # e080104b <__StackTop+0xc07fd04b>
1f801088:	0ff7f513          	zext.b	a0,a5
1f80108c:	0ff00793          	li	a5,255
1f801090:	00e797b3          	sll	a5,a5,a4
1f801094:	fff7c793          	not	a5,a5
1f801098:	8fe9                	and	a5,a5,a0
1f80109a:	4511                	li	a0,4
1f80109c:	00e51733          	sll	a4,a0,a4
1f8010a0:	8fd9                	or	a5,a5,a4
1f8010a2:	0ff7f793          	zext.b	a5,a5
1f8010a6:	04f585a3          	sb	a5,75(a1)
1f8010aa:	0495c783          	lbu	a5,73(a1)
1f8010ae:	0ff7f793          	zext.b	a5,a5
1f8010b2:	0017e793          	ori	a5,a5,1
1f8010b6:	04f584a3          	sb	a5,73(a1)
1f8010ba:	02f00713          	li	a4,47
1f8010be:	0ce6a623          	sw	a4,204(a3)
1f8010c2:	77fd                	lui	a5,0xfffff
1f8010c4:	70078793          	addi	a5,a5,1792 # fffff700 <__StackTop+0xdfffb700>
1f8010c8:	00f69423          	sh	a5,8(a3)
1f8010cc:	420017b7          	lui	a5,0x42001
1f8010d0:	a0160613          	addi	a2,a2,-1535
1f8010d4:	db90                	sw	a2,48(a5)
1f8010d6:	0ca68723          	sb	a0,206(a3)
1f8010da:	02c00713          	li	a4,44
1f8010de:	10e79023          	sh	a4,256(a5) # 42001100 <__StackTop+0x21ffd100>
1f8010e2:	22c1                	jal	1f8012a2 <RF_OnChip_Init>
1f8010e4:	40a2                	lw	ra,8(sp)
1f8010e6:	0131                	addi	sp,sp,12
1f8010e8:	8082                	ret

1f8010ea <rf_get_ad_pll_counter>:
1f8010ea:	1131                	addi	sp,sp,-20
1f8010ec:	c806                	sw	ra,16(sp)
1f8010ee:	c622                	sw	s0,12(sp)
1f8010f0:	c426                	sw	s1,8(sp)
1f8010f2:	c02a                	sw	a0,0(sp)
1f8010f4:	c22e                	sw	a1,4(sp)
1f8010f6:	4415                	li	s0,5
1f8010f8:	4481                	li	s1,0
1f8010fa:	400006b7          	lui	a3,0x40000
1f8010fe:	1846a783          	lw	a5,388(a3) # 40000184 <__StackTop+0x1fffc184>
1f801102:	7741                	lui	a4,0xffff0
1f801104:	8ff9                	and	a5,a5,a4
1f801106:	4712                	lw	a4,4(sp)
1f801108:	8fd9                	or	a5,a5,a4
1f80110a:	18f6a223          	sw	a5,388(a3)
1f80110e:	4502                	lw	a0,0(sp)
1f801110:	00800097          	auipc	ra,0x800
1f801114:	896080e7          	jalr	-1898(ra) # 200009a6 <_rf_kvco_read_y>
1f801118:	94aa                	add	s1,s1,a0
1f80111a:	147d                	addi	s0,s0,-1
1f80111c:	fc79                	bnez	s0,1f8010fa <rf_get_ad_pll_counter+0x10>
1f80111e:	4515                	li	a0,5
1f801120:	02a4d533          	divu	a0,s1,a0
1f801124:	40c2                	lw	ra,16(sp)
1f801126:	4432                	lw	s0,12(sp)
1f801128:	44a2                	lw	s1,8(sp)
1f80112a:	0151                	addi	sp,sp,20
1f80112c:	8082                	ret

1f80112e <omw_rf_set_tx_pwr_lvl>:
1f80112e:	200017b7          	lui	a5,0x20001
1f801132:	42d78783          	lb	a5,1069(a5) # 2000142d <g_rf_cfg+0x9>
1f801136:	953e                	add	a0,a0,a5
1f801138:	57a5                	li	a5,-23
1f80113a:	00f55363          	bge	a0,a5,1f801140 <omw_rf_set_tx_pwr_lvl+0x12>
1f80113e:	5525                	li	a0,-23
1f801140:	47b5                	li	a5,13
1f801142:	00a7d363          	bge	a5,a0,1f801148 <omw_rf_set_tx_pwr_lvl+0x1a>
1f801146:	4535                	li	a0,13
1f801148:	01750793          	addi	a5,a0,23
1f80114c:	0ff7f793          	zext.b	a5,a5
1f801150:	20001737          	lui	a4,0x20001
1f801154:	42674683          	lbu	a3,1062(a4) # 20001426 <g_rf_cfg+0x2>
1f801158:	01968593          	addi	a1,a3,25
1f80115c:	0ff5f593          	zext.b	a1,a1
1f801160:	02100713          	li	a4,33
1f801164:	4601                	li	a2,0
1f801166:	00f77d63          	bgeu	a4,a5,1f801180 <omw_rf_set_tx_pwr_lvl+0x52>
1f80116a:	fde78713          	addi	a4,a5,-34
1f80116e:	00171613          	slli	a2,a4,0x1
1f801172:	20000737          	lui	a4,0x20000
1f801176:	43870713          	addi	a4,a4,1080 # 20000438 <rf_pwr_lvl_map_1>
1f80117a:	9732                	add	a4,a4,a2
1f80117c:	00075603          	lhu	a2,0(a4)
1f801180:	00561713          	slli	a4,a2,0x5
1f801184:	80077713          	andi	a4,a4,-2048
1f801188:	03f67613          	andi	a2,a2,63
1f80118c:	8e59                	or	a2,a2,a4
1f80118e:	00168713          	addi	a4,a3,1
1f801192:	072e                	slli	a4,a4,0xb
1f801194:	06be                	slli	a3,a3,0xf
1f801196:	8ecd                	or	a3,a3,a1
1f801198:	8ed9                	or	a3,a3,a4
1f80119a:	00c68733          	add	a4,a3,a2
1f80119e:	00179693          	slli	a3,a5,0x1
1f8011a2:	200007b7          	lui	a5,0x20000
1f8011a6:	3ec78793          	addi	a5,a5,1004 # 200003ec <rf_pwr_lvl_map_0>
1f8011aa:	97b6                	add	a5,a5,a3
1f8011ac:	0007d783          	lhu	a5,0(a5)
1f8011b0:	420026b7          	lui	a3,0x42002
1f8011b4:	08c6a583          	lw	a1,140(a3) # 4200208c <__StackTop+0x21ffe08c>
1f8011b8:	03f7f613          	andi	a2,a5,63
1f8011bc:	fffc0537          	lui	a0,0xfffc0
1f8011c0:	7c050513          	addi	a0,a0,1984 # fffc07c0 <__StackTop+0xdffbc7c0>
1f8011c4:	8de9                	and	a1,a1,a0
1f8011c6:	8e4d                	or	a2,a2,a1
1f8011c8:	0796                	slli	a5,a5,0x5
1f8011ca:	8007f793          	andi	a5,a5,-2048
1f8011ce:	8fd1                	or	a5,a5,a2
1f8011d0:	08f6a623          	sw	a5,140(a3)
1f8011d4:	469c                	lw	a5,8(a3)
1f8011d6:	fff80637          	lui	a2,0xfff80
1f8011da:	7c060613          	addi	a2,a2,1984 # fff807c0 <__StackTop+0xdff7c7c0>
1f8011de:	8ff1                	and	a5,a5,a2
1f8011e0:	8fd9                	or	a5,a5,a4
1f8011e2:	c69c                	sw	a5,8(a3)
1f8011e4:	200007b7          	lui	a5,0x20000
1f8011e8:	35478793          	addi	a5,a5,852 # 20000354 <rf_common_desc_tx_setfreq>
1f8011ec:	00b75693          	srli	a3,a4,0xb
1f8011f0:	8abd                	andi	a3,a3,15
1f8011f2:	06ce                	slli	a3,a3,0x13
1f8011f4:	5bcc                	lw	a1,52(a5)
1f8011f6:	ff010637          	lui	a2,0xff010
1f8011fa:	167d                	addi	a2,a2,-1 # ff00ffff <__StackTop+0xdf00bfff>
1f8011fc:	8df1                	and	a1,a1,a2
1f8011fe:	8ecd                	or	a3,a3,a1
1f801200:	dbd4                	sw	a3,52(a5)
1f801202:	00f75693          	srli	a3,a4,0xf
1f801206:	8a85                	andi	a3,a3,1
1f801208:	06de                	slli	a3,a3,0x17
1f80120a:	5fcc                	lw	a1,60(a5)
1f80120c:	8df1                	and	a1,a1,a2
1f80120e:	8ecd                	or	a3,a3,a1
1f801210:	dfd4                	sw	a3,60(a5)
1f801212:	000706b7          	lui	a3,0x70
1f801216:	8f75                	and	a4,a4,a3
1f801218:	43f4                	lw	a3,68(a5)
1f80121a:	8e75                	and	a2,a2,a3
1f80121c:	8f51                	or	a4,a4,a2
1f80121e:	c3f8                	sw	a4,68(a5)
1f801220:	4501                	li	a0,0
1f801222:	8082                	ret

1f801224 <PMU_OnChip_Init>:
1f801224:	1151                	addi	sp,sp,-12
1f801226:	c406                	sw	ra,8(sp)
1f801228:	21a5                	jal	1f801690 <omw_rf_cal>
1f80122a:	400807b7          	lui	a5,0x40080
1f80122e:	1107a703          	lw	a4,272(a5) # 40080110 <__StackTop+0x2007c110>
1f801232:	00776713          	ori	a4,a4,7
1f801236:	10e7a823          	sw	a4,272(a5)
1f80123a:	6725                	lui	a4,0x9
1f80123c:	64270713          	addi	a4,a4,1602 # 9642 <ble_viot.c.e415c280+0x3f9f>
1f801240:	d3b8                	sw	a4,96(a5)
1f801242:	6719                	lui	a4,0x6
1f801244:	bab70713          	addi	a4,a4,-1109 # 5bab <ble_viot.c.e415c280+0x508>
1f801248:	10e7a623          	sw	a4,268(a5)
1f80124c:	21290737          	lui	a4,0x21290
1f801250:	177d                	addi	a4,a4,-1 # 2128ffff <__StackTop+0x128bfff>
1f801252:	c798                	sw	a4,8(a5)
1f801254:	1107a703          	lw	a4,272(a5)
1f801258:	ff0386b7          	lui	a3,0xff038
1f80125c:	7ff68693          	addi	a3,a3,2047 # ff0387ff <__StackTop+0xdf0347ff>
1f801260:	8f75                	and	a4,a4,a3
1f801262:	00d046b7          	lui	a3,0xd04
1f801266:	8f55                	or	a4,a4,a3
1f801268:	10e7a823          	sw	a4,272(a5)
1f80126c:	40a2                	lw	ra,8(sp)
1f80126e:	0131                	addi	sp,sp,12
1f801270:	8082                	ret

1f801272 <Radio_OnChip_Set_Freq_Sw>:
1f801272:	0505                	addi	a0,a0,1
1f801274:	4719                	li	a4,6
1f801276:	02e547b3          	div	a5,a0,a4
1f80127a:	0c878793          	addi	a5,a5,200
1f80127e:	07d2                	slli	a5,a5,0x14
1f801280:	02e56533          	rem	a0,a0,a4
1f801284:	0002b737          	lui	a4,0x2b
1f801288:	aaa70713          	addi	a4,a4,-1366 # 2aaaa <ble_viot.c.e415c280+0x25407>
1f80128c:	02e50533          	mul	a0,a0,a4
1f801290:	8fc9                	or	a5,a5,a0
1f801292:	8385                	srli	a5,a5,0x1
1f801294:	80000737          	lui	a4,0x80000
1f801298:	8fd9                	or	a5,a5,a4
1f80129a:	42001737          	lui	a4,0x42001
1f80129e:	d35c                	sw	a5,36(a4)
1f8012a0:	8082                	ret

1f8012a2 <RF_OnChip_Init>:
1f8012a2:	fcc10113          	addi	sp,sp,-52
1f8012a6:	d806                	sw	ra,48(sp)
1f8012a8:	d622                	sw	s0,44(sp)
1f8012aa:	d426                	sw	s1,40(sp)
1f8012ac:	00800097          	auipc	ra,0x800
1f8012b0:	a54080e7          	jalr	-1452(ra) # 20000d00 <RF_OnChip_Base_Init>
1f8012b4:	200015b7          	lui	a1,0x20001
1f8012b8:	42458593          	addi	a1,a1,1060 # 20001424 <g_rf_cfg>
1f8012bc:	0025c703          	lbu	a4,2(a1)
1f8012c0:	20000537          	lui	a0,0x20000
1f8012c4:	2b450513          	addi	a0,a0,692 # 200002b4 <rf_common_desc_rftx_on>
1f8012c8:	4154                	lw	a3,4(a0)
1f8012ca:	ff0107b7          	lui	a5,0xff010
1f8012ce:	17fd                	addi	a5,a5,-1 # ff00ffff <__StackTop+0xdf00bfff>
1f8012d0:	8efd                	and	a3,a3,a5
1f8012d2:	01970613          	addi	a2,a4,25 # 42001019 <__StackTop+0x21ffd019>
1f8012d6:	0ff67613          	zext.b	a2,a2
1f8012da:	0642                	slli	a2,a2,0x10
1f8012dc:	8ed1                	or	a3,a3,a2
1f8012de:	c154                	sw	a3,4(a0)
1f8012e0:	20000637          	lui	a2,0x20000
1f8012e4:	2a460613          	addi	a2,a2,676 # 200002a4 <rf_common_desc_rftx_off>
1f8012e8:	4254                	lw	a3,4(a2)
1f8012ea:	8efd                	and	a3,a3,a5
1f8012ec:	0055c503          	lbu	a0,5(a1)
1f8012f0:	0542                	slli	a0,a0,0x10
1f8012f2:	8ec9                	or	a3,a3,a0
1f8012f4:	c254                	sw	a3,4(a2)
1f8012f6:	20000537          	lui	a0,0x20000
1f8012fa:	35450613          	addi	a2,a0,852 # 20000354 <rf_common_desc_tx_setfreq>
1f8012fe:	4674                	lw	a3,76(a2)
1f801300:	8efd                	and	a3,a3,a5
1f801302:	0065c303          	lbu	t1,6(a1)
1f801306:	0342                	slli	t1,t1,0x10
1f801308:	0066e6b3          	or	a3,a3,t1
1f80130c:	c674                	sw	a3,76(a2)
1f80130e:	00170393          	addi	t2,a4,1
1f801312:	0ff3f693          	zext.b	a3,t2
1f801316:	03462303          	lw	t1,52(a2)
1f80131a:	00f37333          	and	t1,t1,a5
1f80131e:	00168293          	addi	t0,a3,1 # d04001 <ble_viot.c.e415c280+0xcfe95e>
1f801322:	02ce                	slli	t0,t0,0x13
1f801324:	00536333          	or	t1,t1,t0
1f801328:	02662a23          	sw	t1,52(a2)
1f80132c:	03c62283          	lw	t0,60(a2)
1f801330:	00f2f2b3          	and	t0,t0,a5
1f801334:	01769413          	slli	s0,a3,0x17
1f801338:	00ff0337          	lui	t1,0xff0
1f80133c:	00647433          	and	s0,s0,t1
1f801340:	0082e2b3          	or	t0,t0,s0
1f801344:	02562e23          	sw	t0,60(a2)
1f801348:	04462283          	lw	t0,68(a2)
1f80134c:	00f2f2b3          	and	t0,t0,a5
1f801350:	8285                	srli	a3,a3,0x1
1f801352:	06c2                	slli	a3,a3,0x10
1f801354:	00d2e6b3          	or	a3,t0,a3
1f801358:	c274                	sw	a3,68(a2)
1f80135a:	200006b7          	lui	a3,0x20000
1f80135e:	2c468693          	addi	a3,a3,708 # 200002c4 <rf_common_desc_rx_setfreq>
1f801362:	0346a283          	lw	t0,52(a3)
1f801366:	00f2f2b3          	and	t0,t0,a5
1f80136a:	03ce                	slli	t2,t2,0x13
1f80136c:	0072e2b3          	or	t0,t0,t2
1f801370:	0256aa23          	sw	t0,52(a3)
1f801374:	03c6a283          	lw	t0,60(a3)
1f801378:	00f2f2b3          	and	t0,t0,a5
1f80137c:	01771393          	slli	t2,a4,0x17
1f801380:	0063f3b3          	and	t2,t2,t1
1f801384:	0072e2b3          	or	t0,t0,t2
1f801388:	0256ae23          	sw	t0,60(a3)
1f80138c:	0446a283          	lw	t0,68(a3)
1f801390:	00f2f2b3          	and	t0,t0,a5
1f801394:	00175393          	srli	t2,a4,0x1
1f801398:	03c2                	slli	t2,t2,0x10
1f80139a:	0072e2b3          	or	t0,t0,t2
1f80139e:	0456a223          	sw	t0,68(a3)
1f8013a2:	1779                	addi	a4,a4,-2
1f8013a4:	0ff77713          	zext.b	a4,a4
1f8013a8:	200006b7          	lui	a3,0x20000
1f8013ac:	28468693          	addi	a3,a3,644 # 20000284 <rf_common_desc_rfrx_on>
1f8013b0:	00c6a283          	lw	t0,12(a3)
1f8013b4:	00f2f2b3          	and	t0,t0,a5
1f8013b8:	01771393          	slli	t2,a4,0x17
1f8013bc:	0063f3b3          	and	t2,t2,t1
1f8013c0:	0072e2b3          	or	t0,t0,t2
1f8013c4:	0056a623          	sw	t0,12(a3)
1f8013c8:	0146a283          	lw	t0,20(a3)
1f8013cc:	00f2f2b3          	and	t0,t0,a5
1f8013d0:	8305                	srli	a4,a4,0x1
1f8013d2:	0742                	slli	a4,a4,0x10
1f8013d4:	00e2e733          	or	a4,t0,a4
1f8013d8:	cad8                	sw	a4,20(a3)
1f8013da:	0035c703          	lbu	a4,3(a1)
1f8013de:	200006b7          	lui	a3,0x20000
1f8013e2:	26468693          	addi	a3,a3,612 # 20000264 <rf_common_desc_rfrx_off>
1f8013e6:	42cc                	lw	a1,4(a3)
1f8013e8:	8dfd                	and	a1,a1,a5
1f8013ea:	01771293          	slli	t0,a4,0x17
1f8013ee:	0062f333          	and	t1,t0,t1
1f8013f2:	0065e333          	or	t1,a1,t1
1f8013f6:	0066a223          	sw	t1,4(a3)
1f8013fa:	46cc                	lw	a1,12(a3)
1f8013fc:	8fed                	and	a5,a5,a1
1f8013fe:	8305                	srli	a4,a4,0x1
1f801400:	0742                	slli	a4,a4,0x10
1f801402:	8f5d                	or	a4,a4,a5
1f801404:	c6d8                	sw	a4,12(a3)
1f801406:	42001737          	lui	a4,0x42001
1f80140a:	4b3c                	lw	a5,80(a4)
1f80140c:	0207e793          	ori	a5,a5,32
1f801410:	cb3c                	sw	a5,80(a4)
1f801412:	6785                	lui	a5,0x1
1f801414:	40778793          	addi	a5,a5,1031 # 1407 <main.c.de3c76ba+0xa66>
1f801418:	02f11223          	sh	a5,36(sp)
1f80141c:	02100793          	li	a5,33
1f801420:	02f10323          	sb	a5,38(sp)
1f801424:	420027b7          	lui	a5,0x42002
1f801428:	60600713          	li	a4,1542
1f80142c:	cbd8                	sw	a4,20(a5)
1f80142e:	400006b7          	lui	a3,0x40000
1f801432:	1846a783          	lw	a5,388(a3) # 40000184 <__StackTop+0x1fffc184>
1f801436:	7701                	lui	a4,0xfffe0
1f801438:	8ff9                	and	a5,a5,a4
1f80143a:	6741                	lui	a4,0x10
1f80143c:	20070713          	addi	a4,a4,512 # 10200 <ble_viot.c.e415c280+0xab5d>
1f801440:	8fd9                	or	a5,a5,a4
1f801442:	18f6a223          	sw	a5,388(a3)
1f801446:	8660b7b7          	lui	a5,0x8660b
1f80144a:	53878793          	addi	a5,a5,1336 # 8660b538 <__StackTop+0x66607538>
1f80144e:	c21c                	sw	a5,0(a2)
1f801450:	35450513          	addi	a0,a0,852
1f801454:	007ff097          	auipc	ra,0x7ff
1f801458:	5ee080e7          	jalr	1518(ra) # 20000a42 <start_await_dma>
1f80145c:	200017b7          	lui	a5,0x20001
1f801460:	41078793          	addi	a5,a5,1040 # 20001410 <g_hp>
1f801464:	cc3e                	sw	a5,24(sp)
1f801466:	105c                	addi	a5,sp,36
1f801468:	ce3e                	sw	a5,28(sp)
1f80146a:	6785                	lui	a5,0x1
1f80146c:	80078793          	addi	a5,a5,-2048 # 800 <__STACK_SIZE+0x500>
1f801470:	d03e                	sw	a5,32(sp)
1f801472:	a29d                	j	1f8015d8 <RF_OnChip_Init+0x336>
1f801474:	4789                	li	a5,2
1f801476:	4702                	lw	a4,0(sp)
1f801478:	12e7c463          	blt	a5,a4,1f8015a0 <RF_OnChip_Init+0x2fe>
1f80147c:	47f2                	lw	a5,28(sp)
1f80147e:	0007c503          	lbu	a0,0(a5)
1f801482:	3bc5                	jal	1f801272 <Radio_OnChip_Set_Freq_Sw>
1f801484:	42002437          	lui	s0,0x42002
1f801488:	00042c23          	sw	zero,24(s0) # 42002018 <__StackTop+0x21ffe018>
1f80148c:	4785                	li	a5,1
1f80148e:	cc1c                	sw	a5,24(s0)
1f801490:	470d                	li	a4,3
1f801492:	cc18                	sw	a4,24(s0)
1f801494:	cc1c                	sw	a5,24(s0)
1f801496:	0c800513          	li	a0,200
1f80149a:	007ff097          	auipc	ra,0x7ff
1f80149e:	0b0080e7          	jalr	176(ra) # 2000054a <delay_us>
1f8014a2:	4c5c                	lw	a5,28(s0)
1f8014a4:	0002c737          	lui	a4,0x2c
1f8014a8:	8fd9                	or	a5,a5,a4
1f8014aa:	cc5c                	sw	a5,28(s0)
1f8014ac:	67a5                	lui	a5,0x9
1f8014ae:	80278793          	addi	a5,a5,-2046 # 8802 <ble_viot.c.e415c280+0x315f>
1f8014b2:	0cf42a23          	sw	a5,212(s0)
1f8014b6:	4c5c                	lw	a5,28(s0)
1f8014b8:	83b9                	srli	a5,a5,0xe
1f8014ba:	8b8d                	andi	a5,a5,3
1f8014bc:	5702                	lw	a4,32(sp)
1f8014be:	00f714b3          	sll	s1,a4,a5
1f8014c2:	01049713          	slli	a4,s1,0x10
1f8014c6:	8341                	srli	a4,a4,0x10
1f8014c8:	19c00593          	li	a1,412
1f8014cc:	c23a                	sw	a4,4(sp)
1f8014ce:	853a                	mv	a0,a4
1f8014d0:	3929                	jal	1f8010ea <rf_get_ad_pll_counter>
1f8014d2:	c42a                	sw	a0,8(sp)
1f8014d4:	26400593          	li	a1,612
1f8014d8:	4512                	lw	a0,4(sp)
1f8014da:	3901                	jal	1f8010ea <rf_get_ad_pll_counter>
1f8014dc:	4c5c                	lw	a5,28(s0)
1f8014de:	7701                	lui	a4,0xfffe0
1f8014e0:	177d                	addi	a4,a4,-1 # fffdffff <__StackTop+0xdffdbfff>
1f8014e2:	8ff9                	and	a5,a5,a4
1f8014e4:	cc5c                	sw	a5,28(s0)
1f8014e6:	67a5                	lui	a5,0x9
1f8014e8:	81978793          	addi	a5,a5,-2023 # 8819 <ble_viot.c.e415c280+0x3176>
1f8014ec:	0cf42a23          	sw	a5,212(s0)
1f8014f0:	47a2                	lw	a5,8(sp)
1f8014f2:	8d1d                	sub	a0,a0,a5
1f8014f4:	00151793          	slli	a5,a0,0x1
1f8014f8:	953e                	add	a0,a0,a5
1f8014fa:	050a                	slli	a0,a0,0x2
1f8014fc:	00549713          	slli	a4,s1,0x5
1f801500:	8f05                	sub	a4,a4,s1
1f801502:	070a                	slli	a4,a4,0x2
1f801504:	9726                	add	a4,a4,s1
1f801506:	02a75733          	divu	a4,a4,a0
1f80150a:	4329                	li	t1,10
1f80150c:	026777b3          	remu	a5,a4,t1
1f801510:	0057b793          	sltiu	a5,a5,5
1f801514:	0017c793          	xori	a5,a5,1
1f801518:	02675733          	divu	a4,a4,t1
1f80151c:	973e                	add	a4,a4,a5
1f80151e:	0ff77713          	zext.b	a4,a4
1f801522:	4462                	lw	s0,24(sp)
1f801524:	85a2                	mv	a1,s0
1f801526:	00e40123          	sb	a4,2(s0)
1f80152a:	0fa00793          	li	a5,250
1f80152e:	02f487b3          	mul	a5,s1,a5
1f801532:	02a7d7b3          	divu	a5,a5,a0
1f801536:	0267f6b3          	remu	a3,a5,t1
1f80153a:	0056b693          	sltiu	a3,a3,5
1f80153e:	0016c693          	xori	a3,a3,1
1f801542:	0267d7b3          	divu	a5,a5,t1
1f801546:	97b6                	add	a5,a5,a3
1f801548:	0ff7f693          	zext.b	a3,a5
1f80154c:	00d40023          	sb	a3,0(s0)
1f801550:	1f400793          	li	a5,500
1f801554:	02f487b3          	mul	a5,s1,a5
1f801558:	02a7d7b3          	divu	a5,a5,a0
1f80155c:	0267f633          	remu	a2,a5,t1
1f801560:	00563613          	sltiu	a2,a2,5
1f801564:	00164613          	xori	a2,a2,1
1f801568:	0267d7b3          	divu	a5,a5,t1
1f80156c:	97b2                	add	a5,a5,a2
1f80156e:	0ff7f793          	zext.b	a5,a5
1f801572:	00f400a3          	sb	a5,1(s0)
1f801576:	fc068613          	addi	a2,a3,-64
1f80157a:	0ff67613          	zext.b	a2,a2
1f80157e:	03f00513          	li	a0,63
1f801582:	eec569e3          	bltu	a0,a2,1f801474 <RF_OnChip_Init+0x1d2>
1f801586:	4632                	lw	a2,12(sp)
1f801588:	96b2                	add	a3,a3,a2
1f80158a:	c636                	sw	a3,12(sp)
1f80158c:	46c2                	lw	a3,16(sp)
1f80158e:	97b6                	add	a5,a5,a3
1f801590:	c83e                	sw	a5,16(sp)
1f801592:	47d2                	lw	a5,20(sp)
1f801594:	97ba                	add	a5,a5,a4
1f801596:	ca3e                	sw	a5,20(sp)
1f801598:	4782                	lw	a5,0(sp)
1f80159a:	0785                	addi	a5,a5,1
1f80159c:	c03e                	sw	a5,0(sp)
1f80159e:	bdd9                	j	1f801474 <RF_OnChip_Init+0x1d2>
1f8015a0:	478d                	li	a5,3
1f8015a2:	4732                	lw	a4,12(sp)
1f8015a4:	02f75733          	divu	a4,a4,a5
1f8015a8:	00e58023          	sb	a4,0(a1)
1f8015ac:	4742                	lw	a4,16(sp)
1f8015ae:	02f75733          	divu	a4,a4,a5
1f8015b2:	00e580a3          	sb	a4,1(a1)
1f8015b6:	4752                	lw	a4,20(sp)
1f8015b8:	02f757b3          	divu	a5,a4,a5
1f8015bc:	00f58123          	sb	a5,2(a1)
1f8015c0:	47e2                	lw	a5,24(sp)
1f8015c2:	078d                	addi	a5,a5,3
1f8015c4:	cc3e                	sw	a5,24(sp)
1f8015c6:	4772                	lw	a4,28(sp)
1f8015c8:	0705                	addi	a4,a4,1
1f8015ca:	ce3a                	sw	a4,28(sp)
1f8015cc:	20001737          	lui	a4,0x20001
1f8015d0:	41970713          	addi	a4,a4,1049 # 20001419 <g_hp+0x9>
1f8015d4:	00e78763          	beq	a5,a4,1f8015e2 <RF_OnChip_Init+0x340>
1f8015d8:	c002                	sw	zero,0(sp)
1f8015da:	ca02                	sw	zero,20(sp)
1f8015dc:	c802                	sw	zero,16(sp)
1f8015de:	c602                	sw	zero,12(sp)
1f8015e0:	bd71                	j	1f80147c <RF_OnChip_Init+0x1da>
1f8015e2:	20000537          	lui	a0,0x20000
1f8015e6:	2a450513          	addi	a0,a0,676 # 200002a4 <rf_common_desc_rftx_off>
1f8015ea:	007ff097          	auipc	ra,0x7ff
1f8015ee:	458080e7          	jalr	1112(ra) # 20000a42 <start_await_dma>
1f8015f2:	40000737          	lui	a4,0x40000
1f8015f6:	18472783          	lw	a5,388(a4) # 40000184 <__StackTop+0x1fffc184>
1f8015fa:	7681                	lui	a3,0xfffe0
1f8015fc:	8ff5                	and	a5,a5,a3
1f8015fe:	2007e793          	ori	a5,a5,512
1f801602:	18f72223          	sw	a5,388(a4)
1f801606:	420027b7          	lui	a5,0x42002
1f80160a:	471d                	li	a4,7
1f80160c:	cbd8                	sw	a4,20(a5)
1f80160e:	007ff097          	auipc	ra,0x7ff
1f801612:	3e8080e7          	jalr	1000(ra) # 200009f6 <trigger_gpadc_temp_sampling>
1f801616:	4529                	li	a0,10
1f801618:	007ff097          	auipc	ra,0x7ff
1f80161c:	f32080e7          	jalr	-206(ra) # 2000054a <delay_us>
1f801620:	400407b7          	lui	a5,0x40040
1f801624:	57f8                	lw	a4,108(a5)
1f801626:	200017b7          	lui	a5,0x20001
1f80162a:	42e78623          	sb	a4,1068(a5) # 2000142c <g_rf_cfg+0x8>
1f80162e:	2829                	jal	1f801648 <disable_gpadc>
1f801630:	007ff097          	auipc	ra,0x7ff
1f801634:	78a080e7          	jalr	1930(ra) # 20000dba <RF_OnChip_Cali_Cfg>
1f801638:	4501                	li	a0,0
1f80163a:	3cd5                	jal	1f80112e <omw_rf_set_tx_pwr_lvl>
1f80163c:	50c2                	lw	ra,48(sp)
1f80163e:	5432                	lw	s0,44(sp)
1f801640:	54a2                	lw	s1,40(sp)
1f801642:	03410113          	addi	sp,sp,52
1f801646:	8082                	ret

1f801648 <disable_gpadc>:
1f801648:	420027b7          	lui	a5,0x42002
1f80164c:	0e87a703          	lw	a4,232(a5) # 420020e8 <__StackTop+0x21ffe0e8>
1f801650:	9b79                	andi	a4,a4,-2
1f801652:	0ee7a423          	sw	a4,232(a5)
1f801656:	40040737          	lui	a4,0x40040
1f80165a:	00072023          	sw	zero,0(a4) # 40040000 <__StackTop+0x2003c000>
1f80165e:	43d8                	lw	a4,4(a5)
1f801660:	9b79                	andi	a4,a4,-2
1f801662:	c3d8                	sw	a4,4(a5)
1f801664:	8082                	ret

1f801666 <get_vtrim>:
1f801666:	c609                	beqz	a2,1f801670 <get_vtrim+0xa>
1f801668:	479d                	li	a5,7
1f80166a:	00a7d363          	bge	a5,a0,1f801670 <get_vtrim+0xa>
1f80166e:	1541                	addi	a0,a0,-16
1f801670:	952e                	add	a0,a0,a1
1f801672:	00c54663          	blt	a0,a2,1f80167e <get_vtrim+0x18>
1f801676:	063d                	addi	a2,a2,15
1f801678:	00c55363          	bge	a0,a2,1f80167e <get_vtrim+0x18>
1f80167c:	862a                	mv	a2,a0
1f80167e:	0641                	addi	a2,a2,16
1f801680:	41f65513          	srai	a0,a2,0x1f
1f801684:	8171                	srli	a0,a0,0x1c
1f801686:	962a                	add	a2,a2,a0
1f801688:	8a3d                	andi	a2,a2,15
1f80168a:	40a60533          	sub	a0,a2,a0
1f80168e:	8082                	ret

1f801690 <omw_rf_cal>:
1f801690:	1131                	addi	sp,sp,-20
1f801692:	c806                	sw	ra,16(sp)
1f801694:	c622                	sw	s0,12(sp)
1f801696:	c426                	sw	s1,8(sp)
1f801698:	200017b7          	lui	a5,0x20001
1f80169c:	31b7c703          	lbu	a4,795(a5) # 2000131b <g_otp_cfg+0x2f>
1f8016a0:	8b3d                	andi	a4,a4,15
1f8016a2:	479d                	li	a5,7
1f8016a4:	0ee7fb63          	bgeu	a5,a4,1f80179a <omw_rf_cal+0x10a>
1f8016a8:	ff070793          	addi	a5,a4,-16
1f8016ac:	0ff7f693          	zext.b	a3,a5
1f8016b0:	200015b7          	lui	a1,0x20001
1f8016b4:	42458593          	addi	a1,a1,1060 # 20001424 <g_rf_cfg>
1f8016b8:	00f585a3          	sb	a5,11(a1)
1f8016bc:	1755                	addi	a4,a4,-11
1f8016be:	0ff77613          	zext.b	a2,a4
1f8016c2:	00c581a3          	sb	a2,3(a1)
1f8016c6:	0f000713          	li	a4,240
1f8016ca:	0ec77463          	bgeu	a4,a2,1f8017b2 <omw_rf_cal+0x122>
1f8016ce:	4701                	li	a4,0
1f8016d0:	20001637          	lui	a2,0x20001
1f8016d4:	42e60323          	sb	a4,1062(a2) # 20001426 <g_rf_cfg+0x2>
1f8016d8:	00378713          	addi	a4,a5,3
1f8016dc:	0706                	slli	a4,a4,0x1
1f8016de:	0ff77713          	zext.b	a4,a4
1f8016e2:	0f000613          	li	a2,240
1f8016e6:	4581                	li	a1,0
1f8016e8:	00e66963          	bltu	a2,a4,1f8016fa <omw_rf_cal+0x6a>
1f8016ec:	85ba                	mv	a1,a4
1f8016ee:	467d                	li	a2,31
1f8016f0:	00e67363          	bgeu	a2,a4,1f8016f6 <omw_rf_cal+0x66>
1f8016f4:	45fd                	li	a1,31
1f8016f6:	0ff5f593          	zext.b	a1,a1
1f8016fa:	20001637          	lui	a2,0x20001
1f8016fe:	42460613          	addi	a2,a2,1060 # 20001424 <g_rf_cfg>
1f801702:	00b60223          	sb	a1,4(a2)
1f801706:	00169713          	slli	a4,a3,0x1
1f80170a:	0ff77713          	zext.b	a4,a4
1f80170e:	00770693          	addi	a3,a4,7
1f801712:	00d602a3          	sb	a3,5(a2)
1f801716:	07b1                	addi	a5,a5,12
1f801718:	0786                	slli	a5,a5,0x1
1f80171a:	00f60323          	sb	a5,6(a2)
1f80171e:	0715                	addi	a4,a4,5
1f801720:	00e603a3          	sb	a4,7(a2)
1f801724:	200017b7          	lui	a5,0x20001
1f801728:	3187a783          	lw	a5,792(a5) # 20001318 <g_otp_cfg+0x2c>
1f80172c:	83d1                	srli	a5,a5,0x14
1f80172e:	8bbd                	andi	a5,a5,15
1f801730:	471d                	li	a4,7
1f801732:	08f77863          	bgeu	a4,a5,1f8017c2 <omw_rf_cal+0x132>
1f801736:	17c1                	addi	a5,a5,-16
1f801738:	01879493          	slli	s1,a5,0x18
1f80173c:	84e1                	srai	s1,s1,0x18
1f80173e:	20001437          	lui	s0,0x20001
1f801742:	42440413          	addi	s0,s0,1060 # 20001424 <g_rf_cfg>
1f801746:	00940523          	sb	s1,10(s0)
1f80174a:	200017b7          	lui	a5,0x20001
1f80174e:	2ec78793          	addi	a5,a5,748 # 200012ec <g_otp_cfg>
1f801752:	c03e                	sw	a5,0(sp)
1f801754:	4398                	lw	a4,0(a5)
1f801756:	4601                	li	a2,0
1f801758:	85a6                	mv	a1,s1
1f80175a:	c23a                	sw	a4,4(sp)
1f80175c:	00f77513          	andi	a0,a4,15
1f801760:	3719                	jal	1f801666 <get_vtrim>
1f801762:	00a40023          	sb	a0,0(s0)
1f801766:	4712                	lw	a4,4(sp)
1f801768:	01075513          	srli	a0,a4,0x10
1f80176c:	5661                	li	a2,-8
1f80176e:	85a6                	mv	a1,s1
1f801770:	893d                	andi	a0,a0,15
1f801772:	3dd5                	jal	1f801666 <get_vtrim>
1f801774:	00a400a3          	sb	a0,1(s0)
1f801778:	478d                	li	a5,3
1f80177a:	00f404a3          	sb	a5,9(s0)
1f80177e:	4782                	lw	a5,0(sp)
1f801780:	5bd0                	lw	a2,52(a5)
1f801782:	0652                	slli	a2,a2,0x14
1f801784:	8251                	srli	a2,a2,0x14
1f801786:	1f8027b7          	lui	a5,0x1f802
1f80178a:	f4c78793          	addi	a5,a5,-180 # 1f801f4c <rssi_thresholds>
1f80178e:	00c78593          	addi	a1,a5,12
1f801792:	4501                	li	a0,0
1f801794:	470d                	li	a4,3
1f801796:	4305                	li	t1,1
1f801798:	a825                	j	1f8017d0 <omw_rf_cal+0x140>
1f80179a:	200015b7          	lui	a1,0x20001
1f80179e:	42458593          	addi	a1,a1,1060 # 20001424 <g_rf_cfg>
1f8017a2:	00e585a3          	sb	a4,11(a1)
1f8017a6:	87ba                	mv	a5,a4
1f8017a8:	86ba                	mv	a3,a4
1f8017aa:	00570613          	addi	a2,a4,5
1f8017ae:	00c581a3          	sb	a2,3(a1)
1f8017b2:	8732                	mv	a4,a2
1f8017b4:	45bd                	li	a1,15
1f8017b6:	00c5f363          	bgeu	a1,a2,1f8017bc <omw_rf_cal+0x12c>
1f8017ba:	473d                	li	a4,15
1f8017bc:	0ff77713          	zext.b	a4,a4
1f8017c0:	bf01                	j	1f8016d0 <omw_rf_cal+0x40>
1f8017c2:	01879493          	slli	s1,a5,0x18
1f8017c6:	84e1                	srai	s1,s1,0x18
1f8017c8:	bf9d                	j	1f80173e <omw_rf_cal+0xae>
1f8017ca:	0789                	addi	a5,a5,2
1f8017cc:	00b78b63          	beq	a5,a1,1f8017e2 <omw_rf_cal+0x152>
1f8017d0:	0007d683          	lhu	a3,0(a5)
1f8017d4:	fed64be3          	blt	a2,a3,1f8017ca <omw_rf_cal+0x13a>
1f8017d8:	177d                	addi	a4,a4,-1
1f8017da:	0762                	slli	a4,a4,0x18
1f8017dc:	8761                	srai	a4,a4,0x18
1f8017de:	851a                	mv	a0,t1
1f8017e0:	b7ed                	j	1f8017ca <omw_rf_cal+0x13a>
1f8017e2:	c509                	beqz	a0,1f8017ec <omw_rf_cal+0x15c>
1f8017e4:	200017b7          	lui	a5,0x20001
1f8017e8:	42e786a3          	sb	a4,1069(a5) # 2000142d <g_rf_cfg+0x9>
1f8017ec:	40c2                	lw	ra,16(sp)
1f8017ee:	4432                	lw	s0,12(sp)
1f8017f0:	44a2                	lw	s1,8(sp)
1f8017f2:	0151                	addi	sp,sp,20
1f8017f4:	8082                	ret

1f8017f6 <rf_2g4_init>:
1f8017f6:	715d                	addi	sp,sp,-80
1f8017f8:	c686                	sw	ra,76(sp)
1f8017fa:	c4a2                	sw	s0,72(sp)
1f8017fc:	30047073          	csrci	mstatus,8
1f801800:	38a1                	jal	1f801058 <omw_rf_init>
1f801802:	20001737          	lui	a4,0x20001
1f801806:	200017b7          	lui	a5,0x20001
1f80180a:	45878793          	addi	a5,a5,1112 # 20001458 <rf_2g4_rx_data_buf>
1f80180e:	32f72c23          	sw	a5,824(a4) # 20001338 <rf_2g4_fifo>
1f801812:	20001437          	lui	s0,0x20001
1f801816:	33c40413          	addi	s0,s0,828 # 2000133c <rf_2g4_mgr>
1f80181a:	200017b7          	lui	a5,0x20001
1f80181e:	4487aa23          	sw	s0,1108(a5) # 20001454 <rf_2g4_para>
1f801822:	04300613          	li	a2,67
1f801826:	4581                	li	a1,0
1f801828:	850a                	mv	a0,sp
1f80182a:	26e9                	jal	1f801bf4 <memset>
1f80182c:	03c00793          	li	a5,60
1f801830:	00f11023          	sh	a5,0(sp)
1f801834:	4785                	li	a5,1
1f801836:	00f101a3          	sb	a5,3(sp)
1f80183a:	8e89c737          	lui	a4,0x8e89c
1f80183e:	ed670713          	addi	a4,a4,-298 # 8e89bed6 <__StackTop+0x6e897ed6>
1f801842:	c23a                	sw	a4,4(sp)
1f801844:	4711                	li	a4,4
1f801846:	00e10623          	sb	a4,12(sp)
1f80184a:	02000713          	li	a4,32
1f80184e:	00e106a3          	sb	a4,13(sp)
1f801852:	04e00713          	li	a4,78
1f801856:	00e10723          	sb	a4,14(sp)
1f80185a:	00f107a3          	sb	a5,15(sp)
1f80185e:	02500713          	li	a4,37
1f801862:	00e10823          	sb	a4,16(sp)
1f801866:	00f10923          	sb	a5,18(sp)
1f80186a:	478d                	li	a5,3
1f80186c:	00f109a3          	sb	a5,19(sp)
1f801870:	005557b7          	lui	a5,0x555
1f801874:	55578793          	addi	a5,a5,1365 # 555555 <ble_viot.c.e415c280+0x54feb2>
1f801878:	ca3e                	sw	a5,20(sp)
1f80187a:	010007b7          	lui	a5,0x1000
1f80187e:	65b78793          	addi	a5,a5,1627 # 100065b <ble_viot.c.e415c280+0xffafb8>
1f801882:	cc3e                	sw	a5,24(sp)
1f801884:	10000793          	li	a5,256
1f801888:	00f11f23          	sh	a5,30(sp)
1f80188c:	850a                	mv	a0,sp
1f80188e:	f92ff0ef          	jal	1f801020 <omw_svc_2g4_init>
1f801892:	4501                	li	a0,0
1f801894:	3869                	jal	1f80112e <omw_rf_set_tx_pwr_lvl>
1f801896:	ea4ff0ef          	jal	1f800f3a <RF_2G4_PrepareStart>
1f80189a:	cbeff0ef          	jal	1f800d58 <RF_2G4_UpdateDesc_TxPkt>
1f80189e:	400807b7          	lui	a5,0x40080
1f8018a2:	07a00713          	li	a4,122
1f8018a6:	c398                	sw	a4,0(a5)
1f8018a8:	30046073          	csrsi	mstatus,8
1f8018ac:	02040c23          	sb	zero,56(s0)
1f8018b0:	200017b7          	lui	a5,0x20001
1f8018b4:	44078823          	sb	zero,1104(a5) # 20001450 <current_tx_rx_switch_flag>
1f8018b8:	200017b7          	lui	a5,0x20001
1f8018bc:	54078e23          	sb	zero,1372(a5) # 2000155c <rx_restart_flag>
1f8018c0:	200017b7          	lui	a5,0x20001
1f8018c4:	54078ea3          	sb	zero,1373(a5) # 2000155d <tx_restart_flag>
1f8018c8:	40b6                	lw	ra,76(sp)
1f8018ca:	4426                	lw	s0,72(sp)
1f8018cc:	6161                	addi	sp,sp,80
1f8018ce:	8082                	ret

1f8018d0 <adv_channel_idx_to_channel_num>:
1f8018d0:	02500793          	li	a5,37
1f8018d4:	c905                	beqz	a0,1f801904 <adv_channel_idx_to_channel_num+0x34>
1f8018d6:	fff50793          	addi	a5,a0,-1
1f8018da:	0ff7f793          	zext.b	a5,a5
1f8018de:	4729                	li	a4,10
1f8018e0:	02f77263          	bgeu	a4,a5,1f801904 <adv_channel_idx_to_channel_num+0x34>
1f8018e4:	47b1                	li	a5,12
1f8018e6:	02f50763          	beq	a0,a5,1f801914 <adv_channel_idx_to_channel_num+0x44>
1f8018ea:	ff350793          	addi	a5,a0,-13
1f8018ee:	0ff7f793          	zext.b	a5,a5
1f8018f2:	4765                	li	a4,25
1f8018f4:	00f77a63          	bgeu	a4,a5,1f801908 <adv_channel_idx_to_channel_num+0x38>
1f8018f8:	02700713          	li	a4,39
1f8018fc:	02500793          	li	a5,37
1f801900:	00e50863          	beq	a0,a4,1f801910 <adv_channel_idx_to_channel_num+0x40>
1f801904:	853e                	mv	a0,a5
1f801906:	8082                	ret
1f801908:	1579                	addi	a0,a0,-2
1f80190a:	0ff57793          	zext.b	a5,a0
1f80190e:	bfdd                	j	1f801904 <adv_channel_idx_to_channel_num+0x34>
1f801910:	87aa                	mv	a5,a0
1f801912:	bfcd                	j	1f801904 <adv_channel_idx_to_channel_num+0x34>
1f801914:	02600793          	li	a5,38
1f801918:	b7f5                	j	1f801904 <adv_channel_idx_to_channel_num+0x34>

1f80191a <rf_2g4_tx_data>:
1f80191a:	1121                	addi	sp,sp,-24
1f80191c:	ca06                	sw	ra,20(sp)
1f80191e:	c822                	sw	s0,16(sp)
1f801920:	c626                	sw	s1,12(sp)
1f801922:	c02a                	sw	a0,0(sp)
1f801924:	c22e                	sw	a1,4(sp)
1f801926:	8432                	mv	s0,a2
1f801928:	200017b7          	lui	a5,0x20001
1f80192c:	4507c783          	lbu	a5,1104(a5) # 20001450 <current_tx_rx_switch_flag>
1f801930:	0ff7f793          	zext.b	a5,a5
1f801934:	c3d1                	beqz	a5,1f8019b8 <rf_2g4_tx_data+0x9e>
1f801936:	200017b7          	lui	a5,0x20001
1f80193a:	4485                	li	s1,1
1f80193c:	44978823          	sb	s1,1104(a5) # 20001450 <current_tx_rx_switch_flag>
1f801940:	200017b7          	lui	a5,0x20001
1f801944:	54078e23          	sb	zero,1372(a5) # 2000155c <rx_restart_flag>
1f801948:	8722                	mv	a4,s0
1f80194a:	0ff47793          	zext.b	a5,s0
1f80194e:	0786                	slli	a5,a5,0x1
1f801950:	02678793          	addi	a5,a5,38
1f801954:	20000437          	lui	s0,0x20000
1f801958:	49a40413          	addi	s0,s0,1178 # 2000049a <adv_channel_idx>
1f80195c:	00f41023          	sh	a5,0(s0)
1f801960:	0ff77513          	zext.b	a0,a4
1f801964:	37b5                	jal	1f8018d0 <adv_channel_idx_to_channel_num>
1f801966:	200007b7          	lui	a5,0x20000
1f80196a:	49c78793          	addi	a5,a5,1180 # 2000049c <whiten_chl>
1f80196e:	00a78023          	sb	a0,0(a5)
1f801972:	20001737          	lui	a4,0x20001
1f801976:	55d70713          	addi	a4,a4,1373 # 2000155d <tx_restart_flag>
1f80197a:	c43a                	sw	a4,8(sp)
1f80197c:	00970023          	sb	s1,0(a4)
1f801980:	00045603          	lhu	a2,0(s0)
1f801984:	0007c683          	lbu	a3,0(a5)
1f801988:	0ff6f693          	zext.b	a3,a3
1f80198c:	0642                	slli	a2,a2,0x10
1f80198e:	8241                	srli	a2,a2,0x10
1f801990:	4592                	lw	a1,4(sp)
1f801992:	4502                	lw	a0,0(sp)
1f801994:	007ff097          	auipc	ra,0x7ff
1f801998:	cd2080e7          	jalr	-814(ra) # 20000666 <omw_svc_2g4_tx_data>
1f80199c:	1f400513          	li	a0,500
1f8019a0:	007ff097          	auipc	ra,0x7ff
1f8019a4:	baa080e7          	jalr	-1110(ra) # 2000054a <delay_us>
1f8019a8:	4722                	lw	a4,8(sp)
1f8019aa:	00070023          	sb	zero,0(a4)
1f8019ae:	40d2                	lw	ra,20(sp)
1f8019b0:	4442                	lw	s0,16(sp)
1f8019b2:	44b2                	lw	s1,12(sp)
1f8019b4:	0161                	addi	sp,sp,24
1f8019b6:	8082                	ret
1f8019b8:	007ff097          	auipc	ra,0x7ff
1f8019bc:	d4c080e7          	jalr	-692(ra) # 20000704 <omw_svc_2g4_set_idle>
1f8019c0:	bf9d                	j	1f801936 <rf_2g4_tx_data+0x1c>

1f8019c2 <rf_2g4_set_tx_power>:
1f8019c2:	1151                	addi	sp,sp,-12
1f8019c4:	c406                	sw	ra,8(sp)
1f8019c6:	c222                	sw	s0,4(sp)
1f8019c8:	842a                	mv	s0,a0
1f8019ca:	f64ff0ef          	jal	1f80112e <omw_rf_set_tx_pwr_lvl>
1f8019ce:	200017b7          	lui	a5,0x20001
1f8019d2:	5487ac23          	sw	s0,1368(a5) # 20001558 <rf_current_power>
1f8019d6:	40a2                	lw	ra,8(sp)
1f8019d8:	4412                	lw	s0,4(sp)
1f8019da:	0131                	addi	sp,sp,12
1f8019dc:	8082                	ret

1f8019de <t1001_sleep_restore_uart_reg_info>:
1f8019de:	200006b7          	lui	a3,0x20000
1f8019e2:	4a468693          	addi	a3,a3,1188 # 200004a4 <uart_addr_idx_list>
1f8019e6:	4701                	li	a4,0
1f8019e8:	4615                	li	a2,5
1f8019ea:	431d                	li	t1,7
1f8019ec:	42a1                	li	t0,8
1f8019ee:	a835                	j	1f801a2a <t1001_sleep_restore_uart_reg_info+0x4c>
1f8019f0:	5d7c                	lw	a5,124(a0)
1f8019f2:	8b85                	andi	a5,a5,1
1f8019f4:	c791                	beqz	a5,1f801a00 <t1001_sleep_restore_uart_reg_info+0x22>
1f8019f6:	5d7c                	lw	a5,124(a0)
1f8019f8:	8b85                	andi	a5,a5,1
1f8019fa:	dbfd                	beqz	a5,1f8019f0 <t1001_sleep_restore_uart_reg_info+0x12>
1f8019fc:	5d7c                	lw	a5,124(a0)
1f8019fe:	bfcd                	j	1f8019f0 <t1001_sleep_restore_uart_reg_info+0x12>
1f801a00:	455c                	lw	a5,12(a0)
1f801a02:	0807e793          	ori	a5,a5,128
1f801a06:	c55c                	sw	a5,12(a0)
1f801a08:	0006c783          	lbu	a5,0(a3)
1f801a0c:	078a                	slli	a5,a5,0x2
1f801a0e:	97aa                	add	a5,a5,a0
1f801a10:	0005a383          	lw	t2,0(a1)
1f801a14:	0077a023          	sw	t2,0(a5)
1f801a18:	0705                	addi	a4,a4,1
1f801a1a:	0685                	addi	a3,a3,1
1f801a1c:	0591                	addi	a1,a1,4
1f801a1e:	a031                	j	1f801a2a <t1001_sleep_restore_uart_reg_info+0x4c>
1f801a20:	0705                	addi	a4,a4,1
1f801a22:	0685                	addi	a3,a3,1
1f801a24:	0591                	addi	a1,a1,4
1f801a26:	02570363          	beq	a4,t0,1f801a4c <t1001_sleep_restore_uart_reg_info+0x6e>
1f801a2a:	fcc703e3          	beq	a4,a2,1f8019f0 <t1001_sleep_restore_uart_reg_info+0x12>
1f801a2e:	0006c783          	lbu	a5,0(a3)
1f801a32:	078a                	slli	a5,a5,0x2
1f801a34:	97aa                	add	a5,a5,a0
1f801a36:	0005a383          	lw	t2,0(a1)
1f801a3a:	0077a023          	sw	t2,0(a5)
1f801a3e:	fe6711e3          	bne	a4,t1,1f801a20 <t1001_sleep_restore_uart_reg_info+0x42>
1f801a42:	455c                	lw	a5,12(a0)
1f801a44:	f7f7f793          	andi	a5,a5,-129
1f801a48:	c55c                	sw	a5,12(a0)
1f801a4a:	8082                	ret
1f801a4c:	8082                	ret

1f801a4e <enter_sleep_mode>:
1f801a4e:	f9410113          	addi	sp,sp,-108
1f801a52:	d486                	sw	ra,104(sp)
1f801a54:	d2a2                	sw	s0,100(sp)
1f801a56:	d0a6                	sw	s1,96(sp)
1f801a58:	200017b7          	lui	a5,0x20001
1f801a5c:	4705                	li	a4,1
1f801a5e:	44e78423          	sb	a4,1096(a5) # 20001448 <has_flash>
1f801a62:	200007b7          	lui	a5,0x20000
1f801a66:	4729                	li	a4,10
1f801a68:	48e78c23          	sb	a4,1176(a5) # 20000498 <gpio_vdd_pin1>
1f801a6c:	200007b7          	lui	a5,0x20000
1f801a70:	577d                	li	a4,-1
1f801a72:	48e78ca3          	sb	a4,1177(a5) # 20000499 <gpio_vdd_pin2>
1f801a76:	20001737          	lui	a4,0x20001
1f801a7a:	200016b7          	lui	a3,0x20001
1f801a7e:	55d74783          	lbu	a5,1373(a4) # 2000155d <tx_restart_flag>
1f801a82:	0ff7f793          	zext.b	a5,a5
1f801a86:	ffe5                	bnez	a5,1f801a7e <enter_sleep_mode+0x30>
1f801a88:	55c6c783          	lbu	a5,1372(a3) # 2000155c <rx_restart_flag>
1f801a8c:	0ff7f793          	zext.b	a5,a5
1f801a90:	f7fd                	bnez	a5,1f801a7e <enter_sleep_mode+0x30>
1f801a92:	007ff097          	auipc	ra,0x7ff
1f801a96:	c72080e7          	jalr	-910(ra) # 20000704 <omw_svc_2g4_set_idle>
1f801a9a:	30047073          	csrci	mstatus,8
1f801a9e:	1018                	addi	a4,sp,32
1f801aa0:	200017b7          	lui	a5,0x20001
1f801aa4:	56e7a023          	sw	a4,1376(a5) # 20001560 <g_save_buf>
1f801aa8:	200017b7          	lui	a5,0x20001
1f801aac:	000336b7          	lui	a3,0x33
1f801ab0:	56d7a623          	sw	a3,1388(a5) # 2000156c <unused_gpio_mask_when_sleep>
1f801ab4:	200017b7          	lui	a5,0x20001
1f801ab8:	5627a423          	sw	sp,1384(a5) # 20001568 <uart0_save_buf>
1f801abc:	1f8027b7          	lui	a5,0x1f802
1f801ac0:	f5878413          	addi	s0,a5,-168 # 1f801f58 <addr_list>
1f801ac4:	04040493          	addi	s1,s0,64
1f801ac8:	f5878793          	addi	a5,a5,-168
1f801acc:	4394                	lw	a3,0(a5)
1f801ace:	4294                	lw	a3,0(a3)
1f801ad0:	c314                	sw	a3,0(a4)
1f801ad2:	0791                	addi	a5,a5,4
1f801ad4:	0711                	addi	a4,a4,4
1f801ad6:	fe979be3          	bne	a5,s1,1f801acc <enter_sleep_mode+0x7e>
1f801ada:	20000637          	lui	a2,0x20000
1f801ade:	4a460613          	addi	a2,a2,1188 # 200004a4 <uart_addr_idx_list>
1f801ae2:	858a                	mv	a1,sp
1f801ae4:	4685                	li	a3,1
1f801ae6:	4519                	li	a0,6
1f801ae8:	41001737          	lui	a4,0x41001
1f801aec:	431d                	li	t1,7
1f801aee:	a035                	j	1f801b1a <enter_sleep_mode+0xcc>
1f801af0:	5f7c                	lw	a5,124(a4)
1f801af2:	8b85                	andi	a5,a5,1
1f801af4:	c791                	beqz	a5,1f801b00 <enter_sleep_mode+0xb2>
1f801af6:	5f7c                	lw	a5,124(a4)
1f801af8:	8b85                	andi	a5,a5,1
1f801afa:	dbfd                	beqz	a5,1f801af0 <enter_sleep_mode+0xa2>
1f801afc:	5f7c                	lw	a5,124(a4)
1f801afe:	bfcd                	j	1f801af0 <enter_sleep_mode+0xa2>
1f801b00:	475c                	lw	a5,12(a4)
1f801b02:	0807e793          	ori	a5,a5,128
1f801b06:	c75c                	sw	a5,12(a4)
1f801b08:	00064783          	lbu	a5,0(a2)
1f801b0c:	078a                	slli	a5,a5,0x2
1f801b0e:	97ba                	add	a5,a5,a4
1f801b10:	439c                	lw	a5,0(a5)
1f801b12:	c19c                	sw	a5,0(a1)
1f801b14:	0685                	addi	a3,a3,1 # 33001 <ble_viot.c.e415c280+0x2d95e>
1f801b16:	0605                	addi	a2,a2,1
1f801b18:	0591                	addi	a1,a1,4
1f801b1a:	fca68be3          	beq	a3,a0,1f801af0 <enter_sleep_mode+0xa2>
1f801b1e:	00064783          	lbu	a5,0(a2)
1f801b22:	078a                	slli	a5,a5,0x2
1f801b24:	97ba                	add	a5,a5,a4
1f801b26:	439c                	lw	a5,0(a5)
1f801b28:	c19c                	sw	a5,0(a1)
1f801b2a:	fed375e3          	bgeu	t1,a3,1f801b14 <enter_sleep_mode+0xc6>
1f801b2e:	400807b7          	lui	a5,0x40080
1f801b32:	3ff00713          	li	a4,1023
1f801b36:	08e79223          	sh	a4,132(a5) # 40080084 <__StackTop+0x2007c084>
1f801b3a:	01000737          	lui	a4,0x1000
1f801b3e:	cf98                	sw	a4,24(a5)
1f801b40:	007ff097          	auipc	ra,0x7ff
1f801b44:	376080e7          	jalr	886(ra) # 20000eb6 <T1001_ChipSleepCriticalWork>
1f801b48:	30047073          	csrci	mstatus,8
1f801b4c:	200017b7          	lui	a5,0x20001
1f801b50:	5687a583          	lw	a1,1384(a5) # 20001568 <uart0_save_buf>
1f801b54:	41001537          	lui	a0,0x41001
1f801b58:	3559                	jal	1f8019de <t1001_sleep_restore_uart_reg_info>
1f801b5a:	200017b7          	lui	a5,0x20001
1f801b5e:	5607a783          	lw	a5,1376(a5) # 20001560 <g_save_buf>
1f801b62:	4394                	lw	a3,0(a5)
1f801b64:	4018                	lw	a4,0(s0)
1f801b66:	c314                	sw	a3,0(a4)
1f801b68:	0411                	addi	s0,s0,4
1f801b6a:	0791                	addi	a5,a5,4
1f801b6c:	fe941be3          	bne	s0,s1,1f801b62 <enter_sleep_mode+0x114>
1f801b70:	40080737          	lui	a4,0x40080
1f801b74:	08075783          	lhu	a5,128(a4) # 40080080 <__StackTop+0x2007c080>
1f801b78:	07c2                	slli	a5,a5,0x10
1f801b7a:	83c1                	srli	a5,a5,0x10
1f801b7c:	200016b7          	lui	a3,0x20001
1f801b80:	56f6a223          	sw	a5,1380(a3) # 20001564 <sleep_wakeup_reason>
1f801b84:	3ff00793          	li	a5,1023
1f801b88:	08f71223          	sh	a5,132(a4)
1f801b8c:	30046073          	csrsi	mstatus,8
1f801b90:	007ff097          	auipc	ra,0x7ff
1f801b94:	b74080e7          	jalr	-1164(ra) # 20000704 <omw_svc_2g4_set_idle>
1f801b98:	4701                	li	a4,0
1f801b9a:	e08005b7          	lui	a1,0xe0800
1f801b9e:	4605                	li	a2,1
1f801ba0:	03000693          	li	a3,48
1f801ba4:	40070793          	addi	a5,a4,1024
1f801ba8:	078a                	slli	a5,a5,0x2
1f801baa:	97ae                	add	a5,a5,a1
1f801bac:	00c78123          	sb	a2,2(a5)
1f801bb0:	0705                	addi	a4,a4,1
1f801bb2:	fed719e3          	bne	a4,a3,1f801ba4 <enter_sleep_mode+0x156>
1f801bb6:	200017b7          	lui	a5,0x20001
1f801bba:	54078e23          	sb	zero,1372(a5) # 2000155c <rx_restart_flag>
1f801bbe:	200017b7          	lui	a5,0x20001
1f801bc2:	54078ea3          	sb	zero,1373(a5) # 2000155d <tx_restart_flag>
1f801bc6:	30046073          	csrsi	mstatus,8
1f801bca:	400807b7          	lui	a5,0x40080
1f801bce:	4fc8                	lw	a0,28(a5)
1f801bd0:	50a6                	lw	ra,104(sp)
1f801bd2:	5416                	lw	s0,100(sp)
1f801bd4:	5486                	lw	s1,96(sp)
1f801bd6:	06c10113          	addi	sp,sp,108
1f801bda:	8082                	ret

1f801bdc <memcpy>:
1f801bdc:	832a                	mv	t1,a0
1f801bde:	ca09                	beqz	a2,1f801bf0 <memcpy+0x14>
1f801be0:	0005c383          	lbu	t2,0(a1) # e0800000 <__StackTop+0xc07fc000>
1f801be4:	00730023          	sb	t2,0(t1) # ff0000 <ble_viot.c.e415c280+0xfea95d>
1f801be8:	167d                	addi	a2,a2,-1
1f801bea:	0305                	addi	t1,t1,1
1f801bec:	0585                	addi	a1,a1,1
1f801bee:	fa6d                	bnez	a2,1f801be0 <memcpy+0x4>
1f801bf0:	8082                	ret
	...

1f801bf4 <memset>:
1f801bf4:	832a                	mv	t1,a0
1f801bf6:	c611                	beqz	a2,1f801c02 <memset+0xe>
1f801bf8:	00b30023          	sb	a1,0(t1)
1f801bfc:	167d                	addi	a2,a2,-1
1f801bfe:	0305                	addi	t1,t1,1
1f801c00:	fe65                	bnez	a2,1f801bf8 <memset+0x4>
1f801c02:	8082                	ret
1f801c04:	0000                	unimp
	...

1f801c08 <output_pin>:
1f801c08:	0008 0000 0000 0000 0007 0000 000f 0000     ................
1f801c18:	0006 0000 0001 0000                         ........

1f801c20 <input_pin>:
1f801c20:	0015 0000 0014 0000 0013 0000 0012 0000     ................

1f801c30 <keys_func_table>:
1f801c30:	0001 0020 00b4 1f80 0011 0000 0000 0000     .. .............
1f801c40:	00b4 1f80 0011 0000 0000 0000 0001 0010     ................
1f801c50:	00b4 1f80 0012 0000 0000 0000 00b4 1f80     ................
1f801c60:	0012 0000 0000 0000 0001 0008 00b4 1f80     ................
1f801c70:	0013 0000 0000 0000 00b4 1f80 0013 0000     ................
1f801c80:	0000 0000 0001 0004 00b4 1f80 0014 0000     ................
1f801c90:	0000 0000 00b4 1f80 0014 0000 0000 0000     ................
1f801ca0:	0002 0020 00b4 1f80 0021 0000 0000 0000     .. .....!.......
1f801cb0:	00b4 1f80 0021 0000 0000 0000 0002 0010     ....!...........
1f801cc0:	00b4 1f80 0022 0000 0000 0000 00b4 1f80     ...."...........
1f801cd0:	0022 0000 0000 0000 0002 0008 00b4 1f80     "...............
1f801ce0:	0023 0000 0000 0000 00b4 1f80 0023 0000     #...........#...
1f801cf0:	0000 0000 0002 0004 00b4 1f80 0024 0000     ............$...
1f801d00:	0000 0000 00b4 1f80 0024 0000 0000 0000     ........$.......
1f801d10:	0040 0020 00b4 1f80 0031 0000 0000 0000     @. .....1.......
1f801d20:	00b4 1f80 0031 0000 0000 0000 0040 0010     ....1.......@...
1f801d30:	00b4 1f80 0032 0000 0000 0000 00b4 1f80     ....2...........
1f801d40:	0032 0000 0000 0000 0040 0008 00b4 1f80     2.......@.......
1f801d50:	0033 0000 0000 0000 00b4 1f80 0033 0000     3...........3...
1f801d60:	0000 0000 0040 0004 00b4 1f80 0034 0000     ....@.......4...
1f801d70:	0000 0000 00b4 1f80 0034 0000 0000 0000     ........4.......
1f801d80:	0080 0020 00b4 1f80 0041 0000 0000 0000     .. .....A.......
1f801d90:	00b4 1f80 0041 0000 0000 0000 0080 0010     ....A...........
1f801da0:	00b4 1f80 0042 0000 0000 0000 00b4 1f80     ....B...........
1f801db0:	0042 0000 0000 0000 0080 0008 00b4 1f80     B...............
1f801dc0:	0043 0000 0000 0000 00b4 1f80 0043 0000     C...........C...
1f801dd0:	0000 0000 0080 0004 00b4 1f80 0044 0000     ............D...
1f801de0:	0000 0000 00b4 1f80 0044 0000 0000 0000     ........D.......
1f801df0:	0100 0020 00b4 1f80 0051 0000 0000 0000     .. .....Q.......
1f801e00:	00b4 1f80 0051 0000 0000 0000 0100 0010     ....Q...........
1f801e10:	00b4 1f80 0052 0000 0000 0000 00b4 1f80     ....R...........
1f801e20:	0052 0000 0000 0000 0100 0008 00b4 1f80     R...............
1f801e30:	0053 0000 0000 0000 00b4 1f80 0053 0000     S...........S...
1f801e40:	0000 0000 0100 0004 00b4 1f80 0054 0000     ............T...
1f801e50:	0000 0000 00b4 1f80 0054 0000 0000 0000     ........T.......
1f801e60:	8000 0020 00b4 1f80 0061 0000 0000 0000     .. .....a.......
1f801e70:	00b4 1f80 0061 0000 0000 0000 8000 0010     ....a...........
1f801e80:	00b4 1f80 0062 0000 0000 0000 00b4 1f80     ....b...........
1f801e90:	0062 0000 0000 0000 8000 0008 00b4 1f80     b...............
1f801ea0:	0063 0000 0000 0000 00b4 1f80 0063 0000     c...........c...
1f801eb0:	0000 0000 8000 0004 00b4 1f80 0064 0000     ............d...
1f801ec0:	0000 0000 00b4 1f80 0064 0000 0000 0000     ........d.......
1f801ed0:	0000 0060 00b4 1f80 0001 0000 0000 0000     ..`.............
1f801ee0:	00b4 1f80 0001 0000 0000 0000 0000 0050     ..............P.
1f801ef0:	00b4 1f80 0002 0000 0000 0000 00b4 1f80     ................
1f801f00:	0002 0000 0000 0000 0000 0048 00b4 1f80     ..........H.....
1f801f10:	0003 0000 0000 0000 00b4 1f80 0003 0000     ................
1f801f20:	0000 0000 0000 0044 00b4 1f80 0004 0000     ......D.........
1f801f30:	0000 0000 00b4 1f80 0004 0000 0000 0000     ................

1f801f40 <freq_ratios>:
1f801f40:	0101 0101 0402 1408 6428 00fa               ........(d..

1f801f4c <rssi_thresholds>:
1f801f4c:	0309 0368 03d2 0449 04cf 0566               ..h...I...f.

1f801f58 <addr_list>:
1f801f58:	0200 4001 0204 4001 0208 4001 020c 4001     ...@...@...@...@
1f801f68:	0210 4001 0214 4001 0300 4001 0304 4001     ...@...@...@...@
1f801f78:	0010 4001 0030 4001 0040 4001 0170 4001     ...@0..@@..@p..@
1f801f88:	0180 4001 0190 4001 01a0 4001 0140 4001     ...@...@...@@..@

Disassembly of section .data:

20000000 <__VECTOR_TABLE>:
	...
2000000c:	0604 1f80 0000 0000 0000 0000 0000 0000     ................
2000001c:	0604 1f80 0000 0000 0000 0000 0000 0000     ................
2000002c:	0604 1f80 0000 0000 0000 0000 0000 0000     ................
2000003c:	0000 0000 0604 1f80 0604 1f80 04b0 2000     ............... 
2000004c:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
2000005c:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
2000006c:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
2000007c:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
2000008c:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
2000009c:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
200000ac:	0604 1f80 0604 1f80 0604 1f80 0604 1f80     ................
200000bc:	0604 1f80                                   ....

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
200005bc:	ff801097          	auipc	ra,0xff801
200005c0:	8d8080e7          	jalr	-1832(ra) # 1f800e94 <reverse8>
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
2000076a:	ee070713          	addi	a4,a4,-288 # 2ee0 <app_viot_handler.c.d912e21e+0x56b>
2000076e:	02e54433          	div	s0,a0,a4
20000772:	0c540413          	addi	s0,s0,197
20000776:	0442                	slli	s0,s0,0x10
20000778:	8041                	srli	s0,s0,0x10
2000077a:	02f74733          	div	a4,a4,a5
2000077e:	02e5e5b3          	rem	a1,a1,a4
20000782:	02f585b3          	mul	a1,a1,a5
20000786:	67d5                	lui	a5,0x15
20000788:	55578793          	addi	a5,a5,1365 # 15555 <ble_viot.c.e415c280+0xfeb2>
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
2000080e:	30070713          	addi	a4,a4,768 # 300300 <ble_viot.c.e415c280+0x2fac5d>
20000812:	8fd9                	or	a5,a5,a4
20000814:	0cf6a623          	sw	a5,204(a3)
20000818:	200017b7          	lui	a5,0x20001
2000081c:	33e7c703          	lbu	a4,830(a5) # 2000133e <rf_2g4_mgr+0x2>
20000820:	4785                	li	a5,1
20000822:	02f70963          	beq	a4,a5,20000854 <RADIO_DescInit_Freq+0x110>
20000826:	800006b7          	lui	a3,0x80000
2000082a:	67d5                	lui	a5,0x15
2000082c:	55578713          	addi	a4,a5,1365 # 15555 <ble_viot.c.e415c280+0xfeb2>
20000830:	bf79                	j	200007ce <RADIO_DescInit_Freq+0x8a>
20000832:	420026b7          	lui	a3,0x42002
20000836:	0cc6a783          	lw	a5,204(a3) # 420020cc <__StackTop+0x21ffe0cc>
2000083a:	ffd00737          	lui	a4,0xffd00
2000083e:	cff70713          	addi	a4,a4,-769 # ffcffcff <__StackTop+0xdfcfbcff>
20000842:	8ff9                	and	a5,a5,a4
20000844:	00300737          	lui	a4,0x300
20000848:	30070713          	addi	a4,a4,768 # 300300 <ble_viot.c.e415c280+0x2fac5d>
2000084c:	8fd9                	or	a5,a5,a4
2000084e:	0cf6a623          	sw	a5,204(a3)
20000852:	b7d9                	j	20000818 <RADIO_DescInit_Freq+0xd4>
20000854:	800006b7          	lui	a3,0x80000
20000858:	0002b737          	lui	a4,0x2b
2000085c:	aab70713          	addi	a4,a4,-1365 # 2aaab <ble_viot.c.e415c280+0x25408>
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
20000a86:	17ed                	addi	a5,a5,-5 # 27ffb <ble_viot.c.e415c280+0x22958>
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
20000d26:	f8870713          	addi	a4,a4,-120 # 3f88 <__ROM_SIZE+0x88>
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
20000da8:	fff70793          	addi	a5,a4,-1 # 3fff <__ROM_SIZE+0xff>
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
20000df8:	0609                	addi	a2,a2,2 # 2002 <rmt_key_config.c.5b7dd704+0xb>
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
20000e5c:	30270713          	addi	a4,a4,770 # 1302 <main.c.de3c76ba+0x961>
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
20000fea:	bb778793          	addi	a5,a5,-1097 # bb7 <main.c.de3c76ba+0x216>
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
200010d4:	12170713          	addi	a4,a4,289 # 2121 <rmt_key_config.c.5b7dd704+0x12a>
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
