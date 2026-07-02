
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
10000048:	517000ef          	jal	10000d5e <sys_entry>

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
100000b4:	200027b7          	lui	a5,0x20002
100000b8:	8c078793          	addi	a5,a5,-1856 # 200018c0 <ble_viot_para>
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

1000010a <print_string_to_buf>:

#if(LOG_ENABLE)

static void print_string_to_buf(uint8_t* uartSndBuf, uint8_t* uartSndBufUseLen, uint8_t* buf, int len)
{
	for(uint8_t i = 0; i < len; i ++)
1000010a:	4781                	li	a5,0
	{
		if(*uartSndBufUseLen >= DEBUG_STRING_LOG_SINGLE_LINE_MAX_SIZE)
1000010c:	0c700313          	li	t1,199
	for(uint8_t i = 0; i < len; i ++)
10000110:	00d7c363          	blt	a5,a3,10000116 <print_string_to_buf+0xc>
		}
		*(uartSndBuf + *uartSndBufUseLen) = buf[i];

		*uartSndBufUseLen = *uartSndBufUseLen+1;
	}
}
10000114:	8082                	ret
		if(*uartSndBufUseLen >= DEBUG_STRING_LOG_SINGLE_LINE_MAX_SIZE)
10000116:	0005c703          	lbu	a4,0(a1)
1000011a:	fee36de3          	bltu	t1,a4,10000114 <print_string_to_buf+0xa>
		*(uartSndBuf + *uartSndBufUseLen) = buf[i];
1000011e:	00f602b3          	add	t0,a2,a5
10000122:	0002c283          	lbu	t0,0(t0)
10000126:	972a                	add	a4,a4,a0
	for(uint8_t i = 0; i < len; i ++)
10000128:	0785                	addi	a5,a5,1 # 40010001 <__StackTop+0x2000c001>
		*(uartSndBuf + *uartSndBufUseLen) = buf[i];
1000012a:	00570023          	sb	t0,0(a4)
		*uartSndBufUseLen = *uartSndBufUseLen+1;
1000012e:	0005c703          	lbu	a4,0(a1)
	for(uint8_t i = 0; i < len; i ++)
10000132:	0ff7f793          	zext.b	a5,a5
		*uartSndBufUseLen = *uartSndBufUseLen+1;
10000136:	0705                	addi	a4,a4,1
10000138:	00e58023          	sb	a4,0(a1)
	for(uint8_t i = 0; i < len; i ++)
1000013c:	bfd1                	j	10000110 <print_string_to_buf+0x6>

1000013e <hal_clock_time_exceed>:
uint32_t _u32_tick = 0;

/******************************************************************************************/
uint32_t hal_clock_get_system_tick(void)
{
    return _u32_tick;
1000013e:	200027b7          	lui	a5,0x20002
10000142:	8c078793          	addi	a5,a5,-1856 # 200018c0 <ble_viot_para>
uint8_t hal_clock_time_exceed(uint64_t ref, uint32_t span_us)
{
	uint8_t ret = 0;
	uint32_t tick_temp = hal_clock_get_system_tick();

	if(tick_temp >= ref)
10000146:	4f9c                	lw	a5,24(a5)
10000148:	ed81                	bnez	a1,10000160 <hal_clock_time_exceed+0x22>
1000014a:	00a7eb63          	bltu	a5,a0,10000160 <hal_clock_time_exceed+0x22>
	{
		ret = ((tick_temp - ref) > span_us); 
1000014e:	40a78733          	sub	a4,a5,a0
10000152:	4505                	li	a0,1
10000154:	02e7e363          	bltu	a5,a4,1000017a <hal_clock_time_exceed+0x3c>
	}
	else
	{
		ret = ((0xFFFFFFFF - ref + tick_temp) > span_us);
10000158:	02e66163          	bltu	a2,a4,1000017a <hal_clock_time_exceed+0x3c>
1000015c:	4501                	li	a0,0
1000015e:	8082                	ret
10000160:	fff78693          	addi	a3,a5,-1
10000164:	40a68733          	sub	a4,a3,a0
10000168:	00f037b3          	snez	a5,a5
1000016c:	00e6b6b3          	sltu	a3,a3,a4
10000170:	40b785b3          	sub	a1,a5,a1
10000174:	4505                	li	a0,1
10000176:	fed581e3          	beq	a1,a3,10000158 <hal_clock_time_exceed+0x1a>
	}

	return ret;
}
1000017a:	8082                	ret

1000017c <uart_send.constprop.0>:
            return;
        }
    }
    UARTx->THR = c;
}
void uart_send(UART_Sel_e uartx, void * pdata, uint32_t len)
1000017c:	95aa                	add	a1,a1,a0
    uint8_t  *ptmp = pdata;
    uint32_t pos = 0;

    while (pos < len)
    {
        while (!(UARTx->LSR& LSR_TRANS_EMPTY));
1000017e:	41001737          	lui	a4,0x41001
    while (pos < len)
10000182:	00b51363          	bne	a0,a1,10000188 <uart_send.constprop.0+0xc>

        UARTx->THR = ptmp[pos++];
    }
}
10000186:	8082                	ret
        while (!(UARTx->LSR& LSR_TRANS_EMPTY));
10000188:	01475783          	lhu	a5,20(a4) # 41001014 <__StackTop+0x20ffd014>
1000018c:	0207f793          	andi	a5,a5,32
10000190:	dfe5                	beqz	a5,10000188 <uart_send.constprop.0+0xc>
        UARTx->THR = ptmp[pos++];
10000192:	00054783          	lbu	a5,0(a0)
10000196:	0505                	addi	a0,a0,1
10000198:	00f71023          	sh	a5,0(a4)
1000019c:	b7dd                	j	10000182 <uart_send.constprop.0+0x6>

1000019e <log_printf>:

    return 0;
}

void log_printf(const char *format, ...)
{
1000019e:	eec10113          	addi	sp,sp,-276
100001a2:	c02a                	sw	a0,0(sp)
100001a4:	df86                	sw	ra,252(sp)
100001a6:	dda2                	sw	s0,248(sp)
100001a8:	dba6                	sw	s1,244(sp)
100001aa:	0948                	addi	a0,sp,148
100001ac:	dd7c                	sw	a5,124(a0)
100001ae:	d56c                	sw	a1,108(a0)
100001b0:	d930                	sw	a2,112(a0)
100001b2:	d974                	sw	a3,116(a0)
100001b4:	dd38                	sw	a4,120(a0)
	va_list ap;

	va_start(ap, format);
100001b6:	021c                	addi	a5,sp,256
100001b8:	ca3e                	sw	a5,20(sp)
    uint8_t uart_tx_local_ptr = 0;
100001ba:	000109a3          	sb	zero,19(sp)
    char HexFormat = 0;
100001be:	c202                	sw	zero,4(sp)
    while(*format)
100001c0:	4702                	lw	a4,0(sp)
100001c2:	00074703          	lbu	a4,0(a4)
100001c6:	e721                	bnez	a4,1000020e <log_printf+0x70>
    uart_send(LOG_UART, uart_tx_buff, uart_tx_local_ptr);
100001c8:	01314583          	lbu	a1,19(sp)
100001cc:	1068                	addi	a0,sp,44
100001ce:	377d                	jal	1000017c <uart_send.constprop.0>

    dbg_print_string_raw(format, ap);

    va_end(ap);
}
100001d0:	50fe                	lw	ra,252(sp)
100001d2:	546e                	lw	s0,248(sp)
100001d4:	54de                	lw	s1,244(sp)
100001d6:	11410113          	addi	sp,sp,276
100001da:	8082                	ret
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');ulIdx++)
100001dc:	0685                	addi	a3,a3,1
100001de:	4702                	lw	a4,0(sp)
100001e0:	00d70433          	add	s0,a4,a3
100001e4:	00044703          	lbu	a4,0(s0)
100001e8:	1cc70363          	beq	a4,a2,100003ae <log_printf+0x210>
100001ec:	fb65                	bnez	a4,100001dc <log_printf+0x3e>
        if(ulIdx>0)
100001ee:	ce91                	beqz	a3,1000020a <log_printf+0x6c>
            print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)format, ulIdx);
100001f0:	4602                	lw	a2,0(sp)
100001f2:	01310593          	addi	a1,sp,19
100001f6:	1068                	addi	a0,sp,44
100001f8:	c63e                	sw	a5,12(sp)
100001fa:	c43a                	sw	a4,8(sp)
100001fc:	3739                	jal	1000010a <print_string_to_buf>
        if(*format == '%')
100001fe:	4722                	lw	a4,8(sp)
10000200:	02500693          	li	a3,37
10000204:	47b2                	lw	a5,12(sp)
10000206:	1ad70663          	beq	a4,a3,100003b2 <log_printf+0x214>
        format += ulIdx;
1000020a:	c022                	sw	s0,0(sp)
1000020c:	bf55                	j	100001c0 <log_printf+0x22>
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');ulIdx++)
1000020e:	4681                	li	a3,0
10000210:	02500613          	li	a2,37
10000214:	b7e9                	j	100001de <log_printf+0x40>
           switch(*format++)
10000216:	f9d70713          	addi	a4,a4,-99
1000021a:	0ff77713          	zext.b	a4,a4
1000021e:	465d                	li	a2,23
10000220:	1ce66763          	bltu	a2,a4,100003ee <log_printf+0x250>
10000224:	10003637          	lui	a2,0x10003
10000228:	070a                	slli	a4,a4,0x2
1000022a:	14c60613          	addi	a2,a2,332 # 1000314c <memset+0x2f0>
1000022e:	9732                	add	a4,a4,a2
10000230:	4318                	lw	a4,0(a4)
10000232:	8702                	jr	a4
10000234:	05800693          	li	a3,88
10000238:	1ad71b63          	bne	a4,a3,100003ee <log_printf+0x250>
                    ulValue = va_arg(vaArgP, unsigned long);
1000023c:	00478493          	addi	s1,a5,4
10000240:	439c                	lw	a5,0(a5)
                     HexFormat='x';
10000242:	c23a                	sw	a4,4(sp)
                    ulNeg = 0;
10000244:	4601                	li	a2,0
                    ulBase = 16;
10000246:	4741                	li	a4,16
                        ulValue = -(long)ulValue;
10000248:	cc3e                	sw	a5,24(sp)
                    for(ulIdx = 1;
1000024a:	4585                	li	a1,1
                        (((ulIdx * ulBase) <= ulValue) &&
1000024c:	02e5b6b3          	mulhu	a3,a1,a4
10000250:	02e58533          	mul	a0,a1,a4
10000254:	00d036b3          	snez	a3,a3
10000258:	00a7e463          	bltu	a5,a0,10000260 <log_printf+0xc2>
1000025c:	10068963          	beqz	a3,1000036e <log_printf+0x1d0>
                    if(ulNeg)
10000260:	4681                	li	a3,0
10000262:	ce01                	beqz	a2,1000027a <log_printf+0xdc>
                    if(ulNeg && (cFill == '0'))
10000264:	03000513          	li	a0,48
                        ulCount--;
10000268:	147d                	addi	s0,s0,-1
                    if(ulNeg && (cFill == '0'))
1000026a:	00a39863          	bne	t2,a0,1000027a <log_printf+0xdc>
                        pcBuf[ulPos++] = '-';
1000026e:	02d00693          	li	a3,45
10000272:	00d10e23          	sb	a3,28(sp)
10000276:	86b2                	mv	a3,a2
                        ulNeg = 0;
10000278:	4601                	li	a2,0
                    if((ulCount > 1) && (ulCount < 16))
1000027a:	ffe40513          	addi	a0,s0,-2
1000027e:	42b5                	li	t0,13
10000280:	01c10313          	addi	t1,sp,28
10000284:	00a2ee63          	bltu	t0,a0,100002a0 <log_printf+0x102>
                        for(ulCount--; ulCount; ulCount--)
10000288:	fff40513          	addi	a0,s0,-1
1000028c:	00d302b3          	add	t0,t1,a3
                            pcBuf[ulPos++] = cFill;
10000290:	00728023          	sb	t2,0(t0)
                        for(ulCount--; ulCount; ulCount--)
10000294:	157d                	addi	a0,a0,-1
10000296:	0285                	addi	t0,t0,1
10000298:	fd65                	bnez	a0,10000290 <log_printf+0xf2>
1000029a:	9436                	add	s0,s0,a3
1000029c:	fff40693          	addi	a3,s0,-1
                    if(ulNeg)
100002a0:	ca11                	beqz	a2,100002b4 <log_printf+0x116>
                        pcBuf[ulPos++] = '-';
100002a2:	0e468613          	addi	a2,a3,228
100002a6:	0808                	addi	a0,sp,16
100002a8:	962a                	add	a2,a2,a0
100002aa:	02d00513          	li	a0,45
100002ae:	f2a60423          	sb	a0,-216(a2)
100002b2:	0685                	addi	a3,a3,1
                        else    pcBuf[ulPos++] = g_pcHex2[(ulValue / ulIdx) % ulBase];//X
100002b4:	10003637          	lui	a2,0x10003
100002b8:	e8860393          	addi	t2,a2,-376 # 10002e88 <memset+0x2c>
                        if(HexFormat=='x')  pcBuf[ulPos++] = g_pcHex1[(ulValue / ulIdx) % ulBase];//x
100002bc:	10003637          	lui	a2,0x10003
100002c0:	07800413          	li	s0,120
100002c4:	e7460613          	addi	a2,a2,-396 # 10002e74 <memset+0x18>
                    for(; ulIdx; ulIdx /= ulBase)
100002c8:	e5d5                	bnez	a1,10000374 <log_printf+0x1d6>
                    print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)pcBuf, ulPos);
100002ca:	861a                	mv	a2,t1
100002cc:	a035                	j	100002f8 <log_printf+0x15a>
                    if((format[-1] == '0') && (ulCount == 0))
100002ce:	03000613          	li	a2,48
100002d2:	00c71463          	bne	a4,a2,100002da <log_printf+0x13c>
100002d6:	e011                	bnez	s0,100002da <log_printf+0x13c>
                        cFill = '0';
100002d8:	83ba                	mv	t2,a4
                    ulCount *= 10;
100002da:	4629                	li	a2,10
100002dc:	02c40633          	mul	a2,s0,a2
100002e0:	fd060613          	addi	a2,a2,-48
                    ulCount += format[-1] - '0';
100002e4:	00c70433          	add	s0,a4,a2
        for(ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0');ulIdx++)
100002e8:	4602                	lw	a2,0(sp)
100002ea:	a8e9                	j	100003c4 <log_printf+0x226>
                    ulValue = va_arg(vaArgP, unsigned long);
100002ec:	00478493          	addi	s1,a5,4
100002f0:	439c                	lw	a5,0(a5)
                    print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)&ulValue, 1);
100002f2:	4685                	li	a3,1
100002f4:	0830                	addi	a2,sp,24
                    ulValue = va_arg(vaArgP, unsigned long);
100002f6:	cc3e                	sw	a5,24(sp)
                    print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)pcBuf, ulPos);
100002f8:	01310593          	addi	a1,sp,19
100002fc:	1068                	addi	a0,sp,44
100002fe:	3531                	jal	1000010a <print_string_to_buf>
                    break;
10000300:	a881                	j	10000350 <log_printf+0x1b2>
                    ulValue = va_arg(vaArgP, unsigned long);
10000302:	00478493          	addi	s1,a5,4
10000306:	439c                	lw	a5,0(a5)
                    if((long)ulValue < 0)
10000308:	0407db63          	bgez	a5,1000035e <log_printf+0x1c0>
                        ulValue = -(long)ulValue;
1000030c:	40f007b3          	neg	a5,a5
                        ulNeg = 1;
10000310:	4605                	li	a2,1
                    ulBase = 10;
10000312:	4729                	li	a4,10
10000314:	bf15                	j	10000248 <log_printf+0xaa>
                    pcStr = va_arg(vaArgP, char *);
10000316:	4390                	lw	a2,0(a5)
10000318:	00478493          	addi	s1,a5,4
                    for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
1000031c:	4681                	li	a3,0
1000031e:	00d607b3          	add	a5,a2,a3
10000322:	0007c783          	lbu	a5,0(a5)
10000326:	e79d                	bnez	a5,10000354 <log_printf+0x1b6>
                    print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)pcStr, ulIdx);
10000328:	01310593          	addi	a1,sp,19
1000032c:	1068                	addi	a0,sp,44
1000032e:	c436                	sw	a3,8(sp)
10000330:	3be9                	jal	1000010a <print_string_to_buf>
                    if(ulCount > ulIdx)
10000332:	46a2                	lw	a3,8(sp)
10000334:	0086fe63          	bgeu	a3,s0,10000350 <log_printf+0x1b2>
                        ulCount -= ulIdx;
10000338:	8c15                	sub	s0,s0,a3
                            print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)" ", 1);
1000033a:	10003637          	lui	a2,0x10003
1000033e:	4685                	li	a3,1
10000340:	e7060613          	addi	a2,a2,-400 # 10002e70 <memset+0x14>
10000344:	01310593          	addi	a1,sp,19
10000348:	1068                	addi	a0,sp,44
1000034a:	147d                	addi	s0,s0,-1
1000034c:	3b7d                	jal	1000010a <print_string_to_buf>
                        while(ulCount--)
1000034e:	f475                	bnez	s0,1000033a <log_printf+0x19c>
                        pcBuf[ulPos++] = '-';
10000350:	87a6                	mv	a5,s1
10000352:	b5bd                	j	100001c0 <log_printf+0x22>
                    for(ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++)
10000354:	0685                	addi	a3,a3,1
10000356:	b7e1                	j	1000031e <log_printf+0x180>
                    ulValue = va_arg(vaArgP, unsigned long);
10000358:	00478493          	addi	s1,a5,4
1000035c:	439c                	lw	a5,0(a5)
                        ulNeg = 0;
1000035e:	4601                	li	a2,0
10000360:	bf4d                	j	10000312 <log_printf+0x174>
                    ulValue = va_arg(vaArgP, unsigned long);
10000362:	00478493          	addi	s1,a5,4
                     HexFormat='x';
10000366:	07800713          	li	a4,120
                    ulValue = va_arg(vaArgP, unsigned long);
1000036a:	439c                	lw	a5,0(a5)
                     HexFormat='x';
1000036c:	bdd9                	j	10000242 <log_printf+0xa4>
                        ulIdx *= ulBase, ulCount--)
1000036e:	147d                	addi	s0,s0,-1
10000370:	85aa                	mv	a1,a0
10000372:	bde9                	j	1000024c <log_printf+0xae>
                        if(HexFormat=='x')  pcBuf[ulPos++] = g_pcHex1[(ulValue / ulIdx) % ulBase];//x
10000374:	02b7d533          	divu	a0,a5,a1
10000378:	4292                	lw	t0,4(sp)
1000037a:	02e57533          	remu	a0,a0,a4
1000037e:	00829d63          	bne	t0,s0,10000398 <log_printf+0x1fa>
10000382:	9532                	add	a0,a0,a2
                        else    pcBuf[ulPos++] = g_pcHex2[(ulValue / ulIdx) % ulBase];//X
10000384:	00054503          	lbu	a0,0(a0)
10000388:	00d302b3          	add	t0,t1,a3
1000038c:	0685                	addi	a3,a3,1
1000038e:	00a28023          	sb	a0,0(t0)
                    for(; ulIdx; ulIdx /= ulBase)
10000392:	02e5d5b3          	divu	a1,a1,a4
10000396:	bf0d                	j	100002c8 <log_printf+0x12a>
                        else    pcBuf[ulPos++] = g_pcHex2[(ulValue / ulIdx) % ulBase];//X
10000398:	951e                	add	a0,a0,t2
1000039a:	b7ed                	j	10000384 <log_printf+0x1e6>
1000039c:	c43e                	sw	a5,8(sp)
                    print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)format - 1, 1);
1000039e:	4685                	li	a3,1
100003a0:	01310593          	addi	a1,sp,19
100003a4:	1068                	addi	a0,sp,44
100003a6:	3395                	jal	1000010a <print_string_to_buf>
100003a8:	47a2                	lw	a5,8(sp)
                        pcBuf[ulPos++] = '-';
100003aa:	84be                	mv	s1,a5
100003ac:	b755                	j	10000350 <log_printf+0x1b2>
        if(ulIdx>0)
100003ae:	e40691e3          	bnez	a3,100001f0 <log_printf+0x52>
            format++;
100003b2:	00140613          	addi	a2,s0,1
            cFill = ' ';
100003b6:	02000393          	li	t2,32
            ulCount = 0;
100003ba:	4401                	li	s0,0
           switch(*format++)
100003bc:	07a00693          	li	a3,122
100003c0:	06200593          	li	a1,98
100003c4:	00160713          	addi	a4,a2,1
100003c8:	c03a                	sw	a4,0(sp)
100003ca:	00064703          	lbu	a4,0(a2)
100003ce:	02e6e063          	bltu	a3,a4,100003ee <log_printf+0x250>
100003d2:	e4e5e2e3          	bltu	a1,a4,10000216 <log_printf+0x78>
100003d6:	03900513          	li	a0,57
100003da:	e4e56de3          	bltu	a0,a4,10000234 <log_printf+0x96>
100003de:	02f00513          	li	a0,47
100003e2:	eee566e3          	bltu	a0,a4,100002ce <log_printf+0x130>
100003e6:	02500693          	li	a3,37
100003ea:	fad709e3          	beq	a4,a3,1000039c <log_printf+0x1fe>
                    print_string_to_buf(uart_tx_buff, &uart_tx_local_ptr, (uint8_t*)"ERROR", 5);
100003ee:	10003637          	lui	a2,0x10003
100003f2:	c43e                	sw	a5,8(sp)
100003f4:	4695                	li	a3,5
100003f6:	e9c60613          	addi	a2,a2,-356 # 10002e9c <memset+0x40>
100003fa:	b75d                	j	100003a0 <log_printf+0x202>

100003fc <ble_adv_timer_init>:
    send_packet_request = 0;
    log_printf("[ADV] 广播已停止\n");
}

void ble_adv_timer_init(void)
{
100003fc:	1171                	addi	sp,sp,-4
    // 初始化发包参数
    send_packet_request = 0;
100003fe:	20002537          	lui	a0,0x20002
{
10000402:	c006                	sw	ra,0(sp)
    send_packet_request = 0;
10000404:	8c050513          	addi	a0,a0,-1856 # 200018c0 <ble_viot_para>
    packet_tx_count = 0;
    last_send_time = 0;
10000408:	4701                	li	a4,0
1000040a:	4781                	li	a5,0
    send_packet_request = 0;
1000040c:	00050e23          	sb	zero,28(a0)
    packet_tx_count = 0;
10000410:	00051f23          	sh	zero,30(a0)
    last_send_time = 0;
10000414:	d118                	sw	a4,32(a0)
10000416:	d15c                	sw	a5,36(a0)
    memset(packet_buffer, 0, sizeof(packet_buffer));
10000418:	02700613          	li	a2,39
1000041c:	4581                	li	a1,0
1000041e:	02850513          	addi	a0,a0,40
10000422:	23b020ef          	jal	10002e5c <memset>
    
    log_printf("[ADV] 广播发送初始化完成（主循环模式）\n");
}
10000426:	4082                	lw	ra,0(sp)
    log_printf("[ADV] 广播发送初始化完成（主循环模式）\n");
10000428:	10003537          	lui	a0,0x10003
1000042c:	ea450513          	addi	a0,a0,-348 # 10002ea4 <memset+0x48>
}
10000430:	0111                	addi	sp,sp,4
    log_printf("[ADV] 广播发送初始化完成（主循环模式）\n");
10000432:	b3b5                	j	1000019e <log_printf>

10000434 <strlen>:
{
10000434:	872a                	mv	a4,a0
    while(str[c++] != '\0');
10000436:	4781                	li	a5,0
10000438:	853e                	mv	a0,a5
1000043a:	0785                	addi	a5,a5,1
1000043c:	00f706b3          	add	a3,a4,a5
10000440:	fff6c683          	lbu	a3,-1(a3)
10000444:	faf5                	bnez	a3,10000438 <strlen+0x4>
}
10000446:	8082                	ret

10000448 <puts>:
{
10000448:	1161                	addi	sp,sp,-8
1000044a:	c206                	sw	ra,4(sp)
1000044c:	c022                	sw	s0,0(sp)
1000044e:	842a                	mv	s0,a0
    uart_send(LOG_UART, (void *)str, strlen(str));
10000450:	37d5                	jal	10000434 <strlen>
10000452:	85aa                	mv	a1,a0
10000454:	8522                	mv	a0,s0
10000456:	331d                	jal	1000017c <uart_send.constprop.0>
    uart_send(LOG_UART, "\n", 1);
10000458:	10003537          	lui	a0,0x10003
1000045c:	0a450513          	addi	a0,a0,164 # 100030a4 <memset+0x248>
10000460:	4585                	li	a1,1
10000462:	3b29                	jal	1000017c <uart_send.constprop.0>
}
10000464:	4092                	lw	ra,4(sp)
10000466:	4402                	lw	s0,0(sp)
10000468:	4501                	li	a0,0
1000046a:	0121                	addi	sp,sp,8
1000046c:	8082                	ret

1000046e <main>:
 * 函数的作用说明：
 *    遥控器主入口函数，负责系统初始化和主循环
 *    主要功能：按键扫描、按键处理、指示灯控制、涂鸦广播发送
 */
int main(void)
{
1000046e:	711d                	addi	sp,sp,-96
10000470:	ce86                	sw	ra,92(sp)
10000472:	cca2                	sw	s0,88(sp)
10000474:	caa6                	sw	s1,84(sp)
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
10000476:	400107b7          	lui	a5,0x40010
1000047a:	02800713          	li	a4,40
1000047e:	20e78423          	sb	a4,520(a5) # 40010208 <__StackTop+0x2000c208>
10000482:	4725                	li	a4,9
10000484:	20e784a3          	sb	a4,521(a5)
    SYS_CTRL->SYS_CLKSEL_b.REG_UART_CLK_SEL = 1;
10000488:	400006b7          	lui	a3,0x40000
1000048c:	52dc                	lw	a5,36(a3)
1000048e:	767d                	lui	a2,0xfffff
10000490:	3ff60613          	addi	a2,a2,1023 # fffff3ff <__StackTop+0xdfffb3ff>
10000494:	8ff1                	and	a5,a5,a2
10000496:	4007e793          	ori	a5,a5,1024
1000049a:	d2dc                	sw	a5,36(a3)
	RESET_UART(uart_id);
1000049c:	40000793          	li	a5,1024
100004a0:	c69c                	sw	a5,8(a3)
100004a2:	c402                	sw	zero,8(sp)
100004a4:	47a2                	lw	a5,8(sp)
100004a6:	2af75263          	bge	a4,a5,1000074a <main+0x2dc>
100004aa:	400006b7          	lui	a3,0x40000
100004ae:	0006a423          	sw	zero,8(a3) # 40000008 <__StackTop+0x1fffc008>
    if( SYS_CTRL->SYS_CLKSEL_b.REG_UART_CLK_SEL == 2)
100004b2:	52dc                	lw	a5,36(a3)
100004b4:	4709                	li	a4,2
100004b6:	83a9                	srli	a5,a5,0xa
100004b8:	8b8d                	andi	a5,a5,3
100004ba:	28e79c63          	bne	a5,a4,10000752 <main+0x2e4>
        return 48000000;
100004be:	02dc7737          	lui	a4,0x2dc7
100004c2:	c0070713          	addi	a4,a4,-1024 # 2dc6c00 <__ROM_SIZE+0x2d86c00>
    if( SYS_CTRL->SYS_CLKSEL_b.REG_UART_CLK_SEL == 2)
100004c6:	52dc                	lw	a5,36(a3)
  \param [in]  priority  Priority to set.
 */
__STATIC_INLINE void csi_vic_set_prio(int32_t IRQn, uint32_t priority)
{
    uint8_t nlbits = (CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos;
    uint8_t clic_intcfg_prio_mask = (uint8_t)(0xff << (8 - nlbits));
100004c8:	4621                	li	a2,8
    UARTx->LCR_b.DLAB = 1;
100004ca:	410017b7          	lui	a5,0x41001
100004ce:	00c7c683          	lbu	a3,12(a5) # 4100100c <__StackTop+0x20ffd00c>
    gpio_set_func(10, 0x20);
#endif

#if (LOG_ENABLE)
    log_dbg_init();
    log_printf("初始化完成");
100004d2:	10003537          	lui	a0,0x10003
100004d6:	edc50513          	addi	a0,a0,-292 # 10002edc <memset+0x80>
100004da:	f806e693          	ori	a3,a3,-128
100004de:	00d78623          	sb	a3,12(a5)
    int divisor = ((get_uart_clk() / baudrate) >> 4);
100004e2:	66f1                	lui	a3,0x1c
100004e4:	20068693          	addi	a3,a3,512 # 1c200 <ble_viot.c.543f92a8+0x13b77>
100004e8:	02d75733          	divu	a4,a4,a3

    CLIC->CLICINT[IRQn].CTL = (CLIC->CLICINT[IRQn].CTL & (~clic_intcfg_prio_mask)) | (priority << (8 - nlbits));
100004ec:	e08016b7          	lui	a3,0xe0801
100004f0:	8311                	srli	a4,a4,0x4
    UARTx->DLL = divisor & 0xff;
100004f2:	0ff77713          	zext.b	a4,a4
100004f6:	00e78023          	sb	a4,0(a5)
    UARTx->DLH = (divisor >> 8) & 0xff;
100004fa:	00078223          	sb	zero,4(a5)
    UARTx->DLF = fract;
100004fe:	0c078023          	sb	zero,192(a5)
    UARTx->LCR_b.DLAB = 0;
10000502:	00c7c703          	lbu	a4,12(a5)
10000506:	07f77713          	andi	a4,a4,127
1000050a:	00e78623          	sb	a4,12(a5)
    UARTx->LCR &= (~LCR_PARITY_ENABLE);
1000050e:	00c7c703          	lbu	a4,12(a5)
10000512:	0f777713          	andi	a4,a4,247
10000516:	00e78623          	sb	a4,12(a5)
    UARTx->LCR |= LCR_WORD_SIZE_8;
1000051a:	00c7c703          	lbu	a4,12(a5)
1000051e:	00376713          	ori	a4,a4,3
10000522:	00e78623          	sb	a4,12(a5)
    UARTx->LCR &= LCR_STOP_BIT1;
10000526:	00c7c703          	lbu	a4,12(a5)
1000052a:	0fb77713          	andi	a4,a4,251
1000052e:	00e78623          	sb	a4,12(a5)
    UARTx->IER_b.ERBFI = 0;
10000532:	0047c703          	lbu	a4,4(a5)
10000536:	9b79                	andi	a4,a4,-2
10000538:	00e78223          	sb	a4,4(a5)
    UARTx->IER_b.ETBEI = 0;
1000053c:	0047c703          	lbu	a4,4(a5)
10000540:	9b75                	andi	a4,a4,-3
10000542:	00e78223          	sb	a4,4(a5)
    UARTx->FCR_b.FIFOE = 0x1;
10000546:	0087c703          	lbu	a4,8(a5)
1000054a:	00176713          	ori	a4,a4,1
1000054e:	00e78423          	sb	a4,8(a5)
    UARTx->FCR_b.RT = 1;
10000552:	0087c703          	lbu	a4,8(a5)
10000556:	03f77713          	andi	a4,a4,63
1000055a:	04076713          	ori	a4,a4,64
1000055e:	00e78423          	sb	a4,8(a5)
    uint8_t nlbits = (CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos;
10000562:	e08007b7          	lui	a5,0xe0800
10000566:	43dc                	lw	a5,4(a5)
    uint8_t clic_intcfg_prio_mask = (uint8_t)(0xff << (8 - nlbits));
10000568:	0ff00713          	li	a4,255
    uint8_t nlbits = (CLIC->CLICINFO & CLIC_INFO_CLICINTCTLBITS_Msk) >> CLIC_INFO_CLICINTCTLBITS_Pos;
1000056c:	83d5                	srli	a5,a5,0x15
    uint8_t clic_intcfg_prio_mask = (uint8_t)(0xff << (8 - nlbits));
1000056e:	8bbd                	andi	a5,a5,15
10000570:	8e1d                	sub	a2,a2,a5
    CLIC->CLICINT[IRQn].CTL = (CLIC->CLICINT[IRQn].CTL & (~clic_intcfg_prio_mask)) | (priority << (8 - nlbits));
10000572:	0636c783          	lbu	a5,99(a3) # e0801063 <__StackTop+0xc07fd063>
    uint8_t clic_intcfg_prio_mask = (uint8_t)(0xff << (8 - nlbits));
10000576:	00c71733          	sll	a4,a4,a2
    CLIC->CLICINT[IRQn].CTL = (CLIC->CLICINT[IRQn].CTL & (~clic_intcfg_prio_mask)) | (priority << (8 - nlbits));
1000057a:	fff74713          	not	a4,a4
1000057e:	8ff9                	and	a5,a5,a4
10000580:	470d                	li	a4,3
10000582:	00c71733          	sll	a4,a4,a2
10000586:	8fd9                	or	a5,a5,a4
10000588:	0ff7f793          	zext.b	a5,a5
1000058c:	06f681a3          	sb	a5,99(a3)
    CLIC->CLICINT[IRQn].IE |= CLIC_INTIE_IE_Msk;
10000590:	0616c783          	lbu	a5,97(a3)
10000594:	0017e793          	ori	a5,a5,1
10000598:	06f680a3          	sb	a5,97(a3)
1000059c:	3109                	jal	1000019e <log_printf>
#endif

    // ========== 初始化2.4G射频模块 ==========
    rf_2g4_init();
1000059e:	552020ef          	jal	10002af0 <rf_2g4_init>
    rf_2g4_set_tx_power(5); // 设置发射功率 0dBm
100005a2:	4515                	li	a0,5
100005a4:	510020ef          	jal	10002ab4 <rf_2g4_set_tx_power>
100005a8:	400107b7          	lui	a5,0x40010
 * @see ENUM_GPIO_MODE for available input modes
 */
void gpio_set_input(uint32_t gpio_bits,ENUM_GPIO_MODE mode)
{
	uint32_t cfg_val = (mode&0xE0)| 0x0;
    for (int i = 0; i < GPIO_MAX; i++)
100005ac:	4601                	li	a2,0
    {
		if(gpio_bits&(0x1<<i))
100005ae:	4685                	li	a3,1
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
100005b0:	20078793          	addi	a5,a5,512 # 40010200 <__StackTop+0x2000c200>
100005b4:	02000593          	li	a1,32
    for (int i = 0; i < GPIO_MAX; i++)
100005b8:	4761                	li	a4,24
		if(gpio_bits&(0x1<<i))
100005ba:	00c69533          	sll	a0,a3,a2
100005be:	01255313          	srli	t1,a0,0x12
100005c2:	00f37313          	andi	t1,t1,15
100005c6:	00030663          	beqz	t1,100005d2 <main+0x164>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
100005ca:	00f60533          	add	a0,a2,a5
100005ce:	00b50023          	sb	a1,0(a0)
    for (int i = 0; i < GPIO_MAX; i++)
100005d2:	0605                	addi	a2,a2,1
100005d4:	fee613e3          	bne	a2,a4,100005ba <main+0x14c>

        gpio_set_func(i, cfg_val);
    }

	GPIO_INOUT->GPIO_OE &=~gpio_bits;
100005d8:	400106b7          	lui	a3,0x40010
100005dc:	5a9c                	lw	a5,48(a3)
100005de:	ffc40737          	lui	a4,0xffc40
100005e2:	177d                	addi	a4,a4,-1 # ffc3ffff <__StackTop+0xdfc3bfff>
100005e4:	8ff9                	and	a5,a5,a4
100005e6:	c032                	sw	a2,0(sp)
    
    // 配置输入口：上拉输入
    gpio_set_input(input_bits, GPIO_MODE_IN_PULL_UP);
    
    // 配置输出口：输出模式，初始高电平
    gpio_set_output(output_bits, GPIO_HIGH);
100005e8:	6521                	lui	a0,0x8
100005ea:	da9c                	sw	a5,48(a3)
100005ec:	4585                	li	a1,1
100005ee:	1c350513          	addi	a0,a0,451 # 81c3 <log_dbg.c.59673f20+0xaa4>
100005f2:	3ce9                	jal	100000cc <gpio_set_output>
    
    // 配置指示灯：输出模式，初始关闭
    gpio_set_output((1 << SINGLE_LED_GPIO), GPIO_LOW);
100005f4:	4581                	li	a1,0
100005f6:	20000513          	li	a0,512
100005fa:	3cc9                	jal	100000cc <gpio_set_output>
    
    log_printf("Remoter GPIO initialized\n");
100005fc:	10003537          	lui	a0,0x10003
10000600:	eec50513          	addi	a0,a0,-276 # 10002eec <memset+0x90>
10000604:	3e69                	jal	1000019e <log_printf>
extern const uint8_t KEYS_FUNCTION_NUM;

/* 按键处理初始化 */
void key_process_init(void)
{
    memset((void*)&key_info, 0x0, sizeof(str_key_info));
10000606:	200027b7          	lui	a5,0x20002
1000060a:	8c078493          	addi	s1,a5,-1856 # 200018c0 <ble_viot_para>
1000060e:	0404a823          	sw	zero,80(s1)
10000612:	0404aa23          	sw	zero,84(s1)
10000616:	0404ac23          	sw	zero,88(s1)
/* ==================== 初始化函数==================== */
void ble_packet_init(void)
{
    // 兼容旧AK803 payload字段：广播中使用GROUP_ADDR低16位作为滚码。
    // CP8003上旧地址0x1FE0未确认可读，先沿用SDK已有MAC存储区作为稳定来源。
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
1000061a:	1003f737          	lui	a4,0x1003f
1000061e:	0404ae23          	sw	zero,92(s1)
10000622:	4300                	lw	s0,0(a4)
    
    // 初始化 VIOT 参数结构
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
10000624:	4602                	lw	a2,0(sp)
10000626:	4581                	li	a1,0
10000628:	8526                	mv	a0,s1
    GROUP_ADDR = *(uint32_t*)(MAC_ADDR_BASE);
1000062a:	d0a0                	sw	s0,96(s1)
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
1000062c:	031020ef          	jal	10002e5c <memset>
    
    log_printf("[BLE] Packet initialized, GROUP_ADDR=0x%08X\n", GROUP_ADDR);
10000630:	10003537          	lui	a0,0x10003
10000634:	85a2                	mv	a1,s0
10000636:	f0850513          	addi	a0,a0,-248 # 10002f08 <memset+0xac>
1000063a:	3695                	jal	1000019e <log_printf>
    ble_packet_init();
    log_printf("Key process init\n");
1000063c:	10003537          	lui	a0,0x10003
10000640:	f3850513          	addi	a0,a0,-200 # 10002f38 <memset+0xdc>
10000644:	3ea9                	jal	1000019e <log_printf>
    log_printf("KEYS_FUNCTION_NUM = %d (auto-calculated)\n", KEYS_FUNCTION_NUM);
10000646:	10003537          	lui	a0,0x10003
1000064a:	45f1                	li	a1,28
1000064c:	f4c50513          	addi	a0,a0,-180 # 10002f4c <memset+0xf0>
10000650:	36b9                	jal	1000019e <log_printf>

    // ========== 初始化遥控器GPIO和按键 ==========
    app_remoter_gpio_init();
    key_process_init();
    // VIOT协议初始化已在key_process_init()中调用ble_packet_init()完成
    log_printf("Remoter initialized (VIOT mode)\n");
10000652:	10003537          	lui	a0,0x10003
10000656:	f7850513          	addi	a0,a0,-136 # 10002f78 <memset+0x11c>
1000065a:	3691                	jal	1000019e <log_printf>

    // ========== 初始化BLE广播发送参数 ==========
    ble_adv_timer_init(); // 初始化广播发送参数（主循环模式）
1000065c:	3345                	jal	100003fc <ble_adv_timer_init>

void hal_clock_time_run(void)
{
	static uint32_t pre_tick = 0;

	uint32_t cur_tick = REG_RD(0x42000104);// (SYS_CTRL->AON_RTC);
1000065e:	42000737          	lui	a4,0x42000
10000662:	10472683          	lw	a3,260(a4) # 42000104 <__StackTop+0x21ffc104>
	
	if(cur_tick >= pre_tick)
10000666:	4c98                	lw	a4,24(s1)
10000668:	50f0                	lw	a2,100(s1)
1000066a:	9736                	add	a4,a4,a3
1000066c:	8f11                	sub	a4,a4,a2
		_u32_tick += (cur_tick - pre_tick);
		pre_tick = cur_tick;
	}
	else
	{
		_u32_tick += ( 0xFFFFFFFF- pre_tick + cur_tick);
1000066e:	fff70413          	addi	s0,a4,-1
	if(cur_tick >= pre_tick)
10000672:	00c6e363          	bltu	a3,a2,10000678 <main+0x20a>
		_u32_tick += (cur_tick - pre_tick);
10000676:	843a                	mv	s0,a4
    while (1) {

        hal_clock_time_run();

        /* ========== 按键扫描（5ms周期）========== */
        if (hal_clock_time_exceed(key_scan_timer, 5 * 1000)) {
10000678:	54a8                	lw	a0,104(s1)
1000067a:	54ec                	lw	a1,108(s1)
1000067c:	6605                	lui	a2,0x1
1000067e:	38860613          	addi	a2,a2,904 # 1388 <main.c.479021b4+0x2e0>
10000682:	cc80                	sw	s0,24(s1)
		pre_tick = cur_tick;
10000684:	d0f4                	sw	a3,100(s1)
10000686:	3c65                	jal	1000013e <hal_clock_time_exceed>
10000688:	12050663          	beqz	a0,100007b4 <main+0x346>
            key_scan_timer = hal_clock_get_system_tick();
1000068c:	10003637          	lui	a2,0x10003
10000690:	1ac60613          	addi	a2,a2,428 # 100031ac <output_pin>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
10000694:	400106b7          	lui	a3,0x40010
10000698:	d4a0                	sw	s0,104(s1)
1000069a:	0604a623          	sw	zero,108(s1)
{
    uint32_t scaned_key = 0x0;
    uint32_t gpio_state = 0;
    
    // 矩阵扫描
    for(uint8_t i = 0; i < OUTPUT_PIN_NUM; i++)
1000069e:	01860293          	addi	t0,a2,24
    uint32_t scaned_key = 0x0;
100006a2:	4701                	li	a4,0
    {
        // 输出口依次置低
        gpio_write((1 << output_pin[i]), GPIO_LOW);
100006a4:	4385                	li	t2,1
100006a6:	06c1                	addi	a3,a3,16 # 40010010 <__StackTop+0x2000c010>
100006a8:	420c                	lw	a1,0(a2)
100006aa:	0306a303          	lw	t1,48(a3)
100006ae:	00b395b3          	sll	a1,t2,a1
100006b2:	fff5c513          	not	a0,a1
100006b6:	00657533          	and	a0,a0,t1
100006ba:	da88                	sw	a0,48(a3)
        
        // 小延时，确保电平稳定
        for(volatile int d = 0; d < 20; d++);
100006bc:	c802                	sw	zero,16(sp)
100006be:	4542                	lw	a0,16(sp)
100006c0:	434d                	li	t1,19
100006c2:	08a35d63          	bge	t1,a0,1000075c <main+0x2ee>
 * @brief Read entire GPIO input register
 * @return uint32_t Current state of all GPIO inputs (bitmask)
 */
uint32_t gpio_read(void)
{
	return GPIO_INOUT->GPIO_I;
100006c6:	4a88                	lw	a0,16(a3)
100006c8:	8316                	mv	t1,t0
100006ca:	c02a                	sw	a0,0(sp)
        
        // 检查所有输入口
        for(uint8_t j = 0; j < INPUT_PIN_NUM; j++)
        {
            // 检测对应输入口是否为低电平（按键按下）
            if((gpio_state & (1 << input_pin[j])) == 0)
100006cc:	00032503          	lw	a0,0(t1)
100006d0:	4782                	lw	a5,0(sp)
100006d2:	00a39533          	sll	a0,t2,a0
100006d6:	8fe9                	and	a5,a5,a0
100006d8:	e399                	bnez	a5,100006de <main+0x270>
            {
                scaned_key |= ((1 << output_pin[i]) | (1 << input_pin[j]));
100006da:	8d4d                	or	a0,a0,a1
100006dc:	8f49                	or	a4,a4,a0
        for(uint8_t j = 0; j < INPUT_PIN_NUM; j++)
100006de:	100037b7          	lui	a5,0x10003
100006e2:	0311                	addi	t1,t1,4
100006e4:	1d478793          	addi	a5,a5,468 # 100031d4 <keys_func_table>
100006e8:	fe6792e3          	bne	a5,t1,100006cc <main+0x25e>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
100006ec:	5a88                	lw	a0,48(a3)
    for(uint8_t i = 0; i < OUTPUT_PIN_NUM; i++)
100006ee:	0611                	addi	a2,a2,4
100006f0:	8dc9                	or	a1,a1,a0
100006f2:	da8c                	sw	a1,48(a3)
100006f4:	fa561ae3          	bne	a2,t0,100006a8 <main+0x23a>
100006f8:	5a90                	lw	a2,48(a3)
100006fa:	65a1                	lui	a1,0x8
100006fc:	1c358593          	addi	a1,a1,451 # 81c3 <log_dbg.c.59673f20+0xaa4>
10000700:	8e4d                	or	a2,a2,a1
10000702:	da90                	sw	a2,48(a3)
    
    // 设置所有输出口为高电平
    gpio_write(all_output_bits, GPIO_HIGH);
    
    // 小延时，确保电平稳定
    for(volatile int d = 0; d < 20; d++);
10000704:	c602                	sw	zero,12(sp)
10000706:	464d                	li	a2,19
10000708:	46b2                	lw	a3,12(sp)
1000070a:	04d65d63          	bge	a2,a3,10000764 <main+0x2f6>
	return GPIO_INOUT->GPIO_I;
1000070e:	400106b7          	lui	a3,0x40010
10000712:	06c1                	addi	a3,a3,16 # 40010010 <__StackTop+0x2000c010>
10000714:	4a94                	lw	a3,16(a3)
    gpio_state = gpio_read();
    
    // 检查所有输入口，如果为低则表示连接到GND
    for(uint8_t j = 0; j < INPUT_PIN_NUM; j++)
    {
        if((gpio_state & (1 << input_pin[j])) == 0)
10000716:	00a69613          	slli	a2,a3,0xa
1000071a:	04065963          	bgez	a2,1000076c <main+0x2fe>
1000071e:	00b69613          	slli	a2,a3,0xb
10000722:	04065863          	bgez	a2,10000772 <main+0x304>
10000726:	00c69613          	slli	a2,a3,0xc
1000072a:	04065763          	bgez	a2,10000778 <main+0x30a>
1000072e:	00d69613          	slli	a2,a3,0xd
10000732:	04064663          	bltz	a2,1000077e <main+0x310>
10000736:	00040737          	lui	a4,0x40
        {
            // 输入口为低，表示GND按键按下
            // 注意：GND按键应该单独存在，不与矩阵扫描结果混合
            scaned_key = (GNDB | (1 << input_pin[j]));
1000073a:	004006b7          	lui	a3,0x400
1000073e:	8f55                	or	a4,a4,a3
            break; // 找到一个GND按键就退出，避免多个GND按键同时触发
        }
    }
    
    key_info.curr_key = scaned_key;
10000740:	c8b8                	sw	a4,80(s1)
    
    // 设置按键活动标志
    if(scaned_key != 0) {
        key_activity_flag = 1;  // 检测到按键按下
10000742:	4685                	li	a3,1
10000744:	06d48823          	sb	a3,112(s1)
10000748:	a82d                	j	10000782 <main+0x314>
	RESET_UART(uart_id);
1000074a:	47a2                	lw	a5,8(sp)
1000074c:	0785                	addi	a5,a5,1
1000074e:	c43e                	sw	a5,8(sp)
10000750:	bb91                	j	100004a4 <main+0x36>
        return 24000000;
10000752:	016e3737          	lui	a4,0x16e3
10000756:	60070713          	addi	a4,a4,1536 # 16e3600 <__ROM_SIZE+0x16a3600>
1000075a:	b3b5                	j	100004c6 <main+0x58>
        for(volatile int d = 0; d < 20; d++);
1000075c:	4542                	lw	a0,16(sp)
1000075e:	0505                	addi	a0,a0,1
10000760:	c82a                	sw	a0,16(sp)
10000762:	bfb1                	j	100006be <main+0x250>
    for(volatile int d = 0; d < 20; d++);
10000764:	46b2                	lw	a3,12(sp)
10000766:	0685                	addi	a3,a3,1 # 400001 <__ROM_SIZE+0x3c0001>
10000768:	c636                	sw	a3,12(sp)
1000076a:	bf79                	j	10000708 <main+0x29a>
        if((gpio_state & (1 << input_pin[j])) == 0)
1000076c:	00200737          	lui	a4,0x200
10000770:	b7e9                	j	1000073a <main+0x2cc>
10000772:	00100737          	lui	a4,0x100
10000776:	b7d1                	j	1000073a <main+0x2cc>
10000778:	00080737          	lui	a4,0x80
1000077c:	bf7d                	j	1000073a <main+0x2cc>
    key_info.curr_key = scaned_key;
1000077e:	c8b8                	sw	a4,80(s1)
    if(scaned_key != 0) {
10000780:	f369                	bnez	a4,10000742 <main+0x2d4>
    }
    
    // 按键状态处理
    if(key_info.curr_key && (key_info.curr_key == key_info.last_key))
10000782:	48b4                	lw	a3,80(s1)
10000784:	22068663          	beqz	a3,100009b0 <main+0x542>
10000788:	48b0                	lw	a2,80(s1)
1000078a:	48f4                	lw	a3,84(s1)
1000078c:	22d61263          	bne	a2,a3,100009b0 <main+0x542>
    {
        key_info.pressed_time += 5;  // 每5ms累加
10000790:	4cf4                	lw	a3,92(s1)
10000792:	0695                	addi	a3,a3,5
10000794:	ccf4                	sw	a3,92(s1)
        key_info.handle_flag = 0x01;
10000796:	4685                	li	a3,1
10000798:	04d48da3          	sb	a3,91(s1)
        
        no_keypress_50ms_cnt = 0;
1000079c:	06049923          	sh	zero,114(s1)
        
        // 按键按下时点亮指示灯
        if(led_blink_flag == 0) {
100007a0:	0744c683          	lbu	a3,116(s1)
100007a4:	e699                	bnez	a3,100007b2 <main+0x344>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
100007a6:	400106b7          	lui	a3,0x40010
100007aa:	42b0                	lw	a2,64(a3)
100007ac:	20066613          	ori	a2,a2,512
100007b0:	c2b0                	sw	a2,64(a3)
        if(led_blink_flag == 0) {
            gpio_write((1 << SINGLE_LED_GPIO), GPIO_LOW);
        }
    }
    
    key_info.last_key = scaned_key;
100007b2:	c8f8                	sw	a4,84(s1)
    if(send_packet_request == 0 || packet_tx_count == 0) {
100007b4:	01c4c703          	lbu	a4,28(s1)
100007b8:	c731                	beqz	a4,10000804 <main+0x396>
100007ba:	01e4d703          	lhu	a4,30(s1)
100007be:	c339                	beqz	a4,10000804 <main+0x396>
    if(last_send_time == 0 || hal_clock_time_exceed(last_send_time, send_interval_us)) {
100007c0:	5088                	lw	a0,32(s1)
100007c2:	50cc                	lw	a1,36(s1)
100007c4:	00b56733          	or	a4,a0,a1
100007c8:	c709                	beqz	a4,100007d2 <main+0x364>
100007ca:	0764d603          	lhu	a2,118(s1)
100007ce:	3a85                	jal	1000013e <hal_clock_time_exceed>
100007d0:	c915                	beqz	a0,10000804 <main+0x396>
        rf_2g4_tx_data(packet_buffer, packet_len, RF_CH37);
100007d2:	0784c583          	lbu	a1,120(s1)
100007d6:	4601                	li	a2,0
100007d8:	02848513          	addi	a0,s1,40
100007dc:	224020ef          	jal	10002a00 <rf_2g4_tx_data>
        packet_tx_count--;
100007e0:	01e4d703          	lhu	a4,30(s1)
    uint64_t current_time = hal_clock_get_system_tick();
100007e4:	d080                	sw	s0,32(s1)
100007e6:	0204a223          	sw	zero,36(s1)
        packet_tx_count--;
100007ea:	177d                	addi	a4,a4,-1 # 7ffff <__ROM_SIZE+0x3ffff>
100007ec:	0742                	slli	a4,a4,0x10
100007ee:	8341                	srli	a4,a4,0x10
100007f0:	00e49f23          	sh	a4,30(s1)
        if(packet_tx_count == 0) {
100007f4:	eb01                	bnez	a4,10000804 <main+0x396>
            log_printf("[ADV] 数据包发送完成\n");
100007f6:	10003537          	lui	a0,0x10003
100007fa:	f9c50513          	addi	a0,a0,-100 # 10002f9c <memset+0x140>
            send_packet_request = 0;
100007fe:	00048e23          	sb	zero,28(s1)
            log_printf("[ADV] 数据包发送完成\n");
10000802:	3a71                	jal	1000019e <log_printf>

        /* ========== BLE数据包发送处理 ========== */
        ble_adv_process(); // 在主循环中处理发包

        // ========== 看门狗喂狗（100ms） ==========
        if (hal_clock_time_exceed(watch_dog_T, 100 * 1000)) {
10000804:	0804a503          	lw	a0,128(s1)
10000808:	0844a583          	lw	a1,132(s1)
1000080c:	6661                	lui	a2,0x18
1000080e:	6a060613          	addi	a2,a2,1696 # 186a0 <ble_viot.c.543f92a8+0x10017>
10000812:	3235                	jal	1000013e <hal_clock_time_exceed>
10000814:	cd01                	beqz	a0,1000082c <main+0x3be>
            watch_dog_T = hal_clock_get_system_tick();
10000816:	4c98                	lw	a4,24(s1)
10000818:	0804a223          	sw	zero,132(s1)
            WDT_FEED();
1000081c:	0d800693          	li	a3,216
            watch_dog_T = hal_clock_get_system_tick();
10000820:	08e4a023          	sw	a4,128(s1)
            WDT_FEED();
10000824:	40000737          	lui	a4,0x40000
10000828:	10d72023          	sw	a3,256(a4) # 40000100 <__StackTop+0x1fffc100>
        }

        /* ========== 按键处理 ========== */
        // 按键扫描在主循环中完成，此处响应按键事件
        if (key_info.handle_flag) {
1000082c:	05b4c703          	lbu	a4,91(s1)
10000830:	1c070f63          	beqz	a4,10000a0e <main+0x5a0>

            key_process(key_info.curr_key, key_info.pressed_time, key_info.handle_flag);
10000834:	48ac                	lw	a1,80(s1)
10000836:	10003437          	lui	s0,0x10003
1000083a:	05c4a303          	lw	t1,92(s1)
1000083e:	05b4c683          	lbu	a3,91(s1)
10000842:	1ac40413          	addi	s0,s0,428 # 100031ac <output_pin>
10000846:	02840513          	addi	a0,s0,40
1000084a:	0ff6f693          	zext.b	a3,a3
1000084e:	4701                	li	a4,0
10000850:	862a                	mv	a2,a0
void key_process(uint32_t key_value, uint32_t press_time, uint8_t handle_flag)
{
    str_key_fun* p_key_fun = NULL;
    
    // 查找匹配的按键配置
    for(uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i)
10000852:	42f1                	li	t0,28
    {
        if(key_value == keys_func_table[i].key_value)
10000854:	00052383          	lw	t2,0(a0)
10000858:	18759e63          	bne	a1,t2,100009f4 <main+0x586>
        log_printf("No matching key found for 0x%08X\n", key_value);
        return;
    }
    
    // 按键处理逻辑：短按释放、长按、长按释放
    if(handle_flag == 0x02)
1000085c:	4589                	li	a1,2
1000085e:	30b69963          	bne	a3,a1,10000b70 <main+0x702>
    {
        // 短按释放
        p_key_fun->short_press_handler((str_fun_para*)&p_key_fun->short_press_para);
10000862:	02800693          	li	a3,40
10000866:	02d70733          	mul	a4,a4,a3
1000086a:	00870513          	addi	a0,a4,8
1000086e:	9722                	add	a4,a4,s0
10000870:	5758                	lw	a4,44(a4)
        key_info.pressed_time = 0x0;
    }
    else if(handle_flag == 0x03)
    {
        // 长按释放
        p_key_fun->long_release_handler((str_fun_para*)&p_key_fun->long_release_para);
10000872:	9532                	add	a0,a0,a2
10000874:	9702                	jalr	a4
        key_info.pressed_time = 0x0;
10000876:	0404ae23          	sw	zero,92(s1)
    uint8_t encoded_data[31];  // VIOT编码后的31字节payload
    uint8_t encoded_data_len;
    uint8_t index = 0x0;       // 广播索引
    uint8_t* group_index = &ret_mem_data.current_group_index;
    uint16_t rand_seed = ret_mem_data.rand_seed;
    uint16_t tx_count = ret_mem_data.tx_count++;
1000087a:	08a4d783          	lhu	a5,138(s1)
    // 填充VIOT参数
    ble_viot_para.relay = 0x54;           // 固定值
    ble_viot_para.type = 0x00;            // 类型
    ble_viot_para.version = 0x00;         // 版本
    ble_viot_para.count = tx_count;       // 递增计数
    ble_viot_para.addr = GROUP_ADDR;      // 设备地址
1000087e:	50b0                	lw	a2,96(s1)
	return crc16;
}

uint8_t ble_viot_encoder(str_ble_viot_para* opcode_para,uint8_t rand_seed,uint8_t* out_data,uint8_t* out_data_len)
{
	uint8_t ble_payload[BLE_ADV_PDU_MAX_LENGTH] = {0x0};
10000880:	4581                	li	a1,0
    uint16_t tx_count = ret_mem_data.tx_count++;
10000882:	00178713          	addi	a4,a5,1
10000886:	08e49523          	sh	a4,138(s1)
    *group_index = (*group_index > GROUP_INDEX_MAX) ? 0x00 : *group_index;
1000088a:	0894c703          	lbu	a4,137(s1)
    ble_viot_para.count = tx_count;       // 递增计数
1000088e:	0ff7f793          	zext.b	a5,a5
    ble_viot_para.addr = GROUP_ADDR;      // 设备地址
10000892:	c4d0                	sw	a2,12(s1)
    *group_index = (*group_index > GROUP_INDEX_MAX) ? 0x00 : *group_index;
10000894:	00573693          	sltiu	a3,a4,5
10000898:	40d006b3          	neg	a3,a3
1000089c:	8f75                	and	a4,a4,a3
    ble_viot_para.relay = 0x54;           // 固定值
1000089e:	05400693          	li	a3,84
100008a2:	00d482a3          	sb	a3,5(s1)
100008a6:	0604d683          	lhu	a3,96(s1)
100008aa:	467d                	li	a2,31
100008ac:	1848                	addi	a0,sp,52
    *group_index = (*group_index > GROUP_INDEX_MAX) ? 0x00 : *group_index;
100008ae:	08e484a3          	sb	a4,137(s1)
    ble_viot_para.count = tx_count;       // 递增计数
100008b2:	00f48423          	sb	a5,8(s1)
100008b6:	c23e                	sw	a5,4(sp)
100008b8:	c036                	sw	a3,0(sp)
    ble_viot_para.group_index = *group_index;  // 组索引
100008ba:	00e48823          	sb	a4,16(s1)
    ble_viot_para.type = 0x00;            // 类型
100008be:	00049323          	sh	zero,6(s1)
100008c2:	59a020ef          	jal	10002e5c <memset>
	*p_ble_payload++ = 0x1D;
	*p_ble_payload++ = 0x1E;

	//copy the encoded data to out buffer
	*out_data_len = BLE_ADV_PDU_MAX_LENGTH;
	memcpy(out_data,ble_payload,BLE_ADV_PDU_MAX_LENGTH);
100008c6:	1b020737          	lui	a4,0x1b020
100008ca:	10270713          	addi	a4,a4,258 # 1b020102 <__etext+0xb01ca5a>
100008ce:	da3a                	sw	a4,52(sp)
100008d0:	7779                	lui	a4,0xffffe
100008d2:	c0370713          	addi	a4,a4,-1021 # ffffdc03 <__StackTop+0xdfff9c03>
100008d6:	02e11c23          	sh	a4,56(sp)
100008da:	fdc00713          	li	a4,-36
100008de:	02e10d23          	sb	a4,58(sp)
100008e2:	fc300713          	li	a4,-61
100008e6:	02e10f23          	sb	a4,62(sp)
100008ea:	18171737          	lui	a4,0x18171
100008ee:	6c370713          	addi	a4,a4,1731 # 181716c3 <__etext+0x816e01b>
	*p_ble_payload++ = (uint8_t)opcode_para->para[0];
100008f2:	0124c603          	lbu	a2,18(s1)
	memcpy(out_data,ble_payload,BLE_ADV_PDU_MAX_LENGTH);
100008f6:	c0ba                	sw	a4,64(sp)
100008f8:	1c1b2737          	lui	a4,0x1c1b2
100008fc:	4792                	lw	a5,4(sp)
100008fe:	4682                	lw	a3,0(sp)
10000900:	a1970713          	addi	a4,a4,-1511 # 1c1b1a19 <__etext+0xc1ae371>
10000904:	c2ba                	sw	a4,68(sp)
10000906:	6709                	lui	a4,0x2
10000908:	e1d70713          	addi	a4,a4,-483 # 1e1d <main.c.479021b4+0xd75>
1000090c:	184c                	addi	a1,sp,52
1000090e:	02c10da3          	sb	a2,59(sp)
10000912:	0848                	addi	a0,sp,20
10000914:	467d                	li	a2,31
10000916:	02f10fa3          	sb	a5,63(sp)
1000091a:	02d11e23          	sh	a3,60(sp)
1000091e:	04e11423          	sh	a4,72(sp)
10000922:	522020ef          	jal	10002e44 <memcpy>
    
    // 使用旧AK803简化按键值编码
    ret = ble_viot_encoder(&ble_viot_para, rand_seed, encoded_data, &encoded_data_len);
    
    // 打印编码后的数据
    log_printf("\n=== 旧格式编码后数据 ===\n");
10000926:	10003537          	lui	a0,0x10003
1000092a:	fe050513          	addi	a0,a0,-32 # 10002fe0 <memset+0x184>
1000092e:	3885                	jal	1000019e <log_printf>
    log_printf("编码结果: %s (ret=0x%02X)\n", (ret == 0x00) ? "成功" : "失败", ret);
10000930:	100035b7          	lui	a1,0x10003
10000934:	10003537          	lui	a0,0x10003
10000938:	4601                	li	a2,0
1000093a:	00458593          	addi	a1,a1,4 # 10003004 <memset+0x1a8>
1000093e:	00c50513          	addi	a0,a0,12 # 1000300c <memset+0x1b0>
10000942:	38b1                	jal	1000019e <log_printf>
    log_printf("CMD: 0x%02X, Para: [0x%04X, 0x%04X, 0x%04X]\n", 
10000944:	0124d603          	lhu	a2,18(s1)
10000948:	0164d703          	lhu	a4,22(s1)
1000094c:	0144d683          	lhu	a3,20(s1)
10000950:	0114c583          	lbu	a1,17(s1)
10000954:	10003537          	lui	a0,0x10003
10000958:	02c50513          	addi	a0,a0,44 # 1000302c <memset+0x1d0>
1000095c:	3089                	jal	1000019e <log_printf>
               ble_viot_para.cmd,
               ble_viot_para.para[0],
               ble_viot_para.para[1],
               ble_viot_para.para[2]);
    log_printf("编码数据长度: %d字节\n", encoded_data_len);
1000095e:	10003537          	lui	a0,0x10003
10000962:	45fd                	li	a1,31
10000964:	05c50513          	addi	a0,a0,92 # 1000305c <memset+0x200>
10000968:	837ff0ef          	jal	1000019e <log_printf>
    log_printf("编码数据: ");
1000096c:	10003537          	lui	a0,0x10003
10000970:	07c50513          	addi	a0,a0,124 # 1000307c <memset+0x220>
10000974:	82bff0ef          	jal	1000019e <log_printf>
10000978:	4601                	li	a2,0
    for(uint8_t i = 0; i < encoded_data_len; i++) {
        log_printf("%02X ", encoded_data[i]);
1000097a:	085c                	addi	a5,sp,20
1000097c:	00c78733          	add	a4,a5,a2
10000980:	00074583          	lbu	a1,0(a4)
10000984:	10003537          	lui	a0,0x10003
10000988:	08c50513          	addi	a0,a0,140 # 1000308c <memset+0x230>
1000098c:	c032                	sw	a2,0(sp)
1000098e:	811ff0ef          	jal	1000019e <log_printf>
10000992:	4602                	lw	a2,0(sp)
10000994:	0605                	addi	a2,a2,1
        if((i + 1) % 16 == 0) log_printf("\n           ");  // 每16字节换行
10000996:	00f67713          	andi	a4,a2,15
1000099a:	20071963          	bnez	a4,10000bac <main+0x73e>
1000099e:	10003537          	lui	a0,0x10003
100009a2:	09450513          	addi	a0,a0,148 # 10003094 <memset+0x238>
100009a6:	c032                	sw	a2,0(sp)
100009a8:	ff6ff0ef          	jal	1000019e <log_printf>
100009ac:	4602                	lw	a2,0(sp)
100009ae:	b7f1                	j	1000097a <main+0x50c>
        if(scaned_key == 0 && key_info.last_key != 0 && key_info.pressed_time >= DEFAULT_SHORT_THRESHOLD)
100009b0:	e705                	bnez	a4,100009d8 <main+0x56a>
100009b2:	48f4                	lw	a3,84(s1)
100009b4:	c295                	beqz	a3,100009d8 <main+0x56a>
100009b6:	4cf0                	lw	a2,92(s1)
100009b8:	03100693          	li	a3,49
100009bc:	00c6fe63          	bgeu	a3,a2,100009d8 <main+0x56a>
            if(key_info.pressed_time < DEFAULT_LONG_THRESHOLD) {
100009c0:	4cf0                	lw	a2,92(s1)
100009c2:	7cf00693          	li	a3,1999
100009c6:	02c6e563          	bltu	a3,a2,100009f0 <main+0x582>
                key_info.handle_flag = 0x02;  // 短按释放
100009ca:	4689                	li	a3,2
                key_info.handle_flag = 0x03;  // 长按释放
100009cc:	04d48da3          	sb	a3,91(s1)
            no_keypress_50ms_cnt = 0;
100009d0:	06049923          	sh	zero,114(s1)
            key_info.curr_key = key_info.last_key;
100009d4:	48f4                	lw	a3,84(s1)
100009d6:	c8b4                	sw	a3,80(s1)
            key_info.pressed_time = 0x0;
100009d8:	0404ae23          	sw	zero,92(s1)
        if(led_blink_flag == 0) {
100009dc:	0744c683          	lbu	a3,116(s1)
100009e0:	dc0699e3          	bnez	a3,100007b2 <main+0x344>
100009e4:	400106b7          	lui	a3,0x40010
100009e8:	42b0                	lw	a2,64(a3)
100009ea:	dff67613          	andi	a2,a2,-513
100009ee:	b3c9                	j	100007b0 <main+0x342>
                key_info.handle_flag = 0x03;  // 长按释放
100009f0:	468d                	li	a3,3
100009f2:	bfe9                	j	100009cc <main+0x55e>
    for(uint8_t i = 0; i < KEYS_FUNCTION_NUM; ++i)
100009f4:	0705                	addi	a4,a4,1
100009f6:	02850513          	addi	a0,a0,40
100009fa:	e4571de3          	bne	a4,t0,10000854 <main+0x3e6>
        log_printf("No matching key found for 0x%08X\n", key_value);
100009fe:	10003537          	lui	a0,0x10003
10000a02:	fbc50513          	addi	a0,a0,-68 # 10002fbc <memset+0x160>
10000a06:	f98ff0ef          	jal	1000019e <log_printf>
            key_info.handle_flag = 0x0;
10000a0a:	04048da3          	sb	zero,91(s1)
        }

        /* ========== 休眠检查（50ms周期）========== */
        if (hal_clock_time_exceed(sleep_check_timer, 50 * 1000)) {
10000a0e:	0904a503          	lw	a0,144(s1)
10000a12:	0944a583          	lw	a1,148(s1)
10000a16:	6631                	lui	a2,0xc
10000a18:	35060613          	addi	a2,a2,848 # c350 <ble_viot.c.543f92a8+0x3cc7>
10000a1c:	f22ff0ef          	jal	1000013e <hal_clock_time_exceed>
10000a20:	0e050e63          	beqz	a0,10000b1c <main+0x6ae>
            sleep_check_timer = hal_clock_get_system_tick();
10000a24:	4c98                	lw	a4,24(s1)
10000a26:	0804aa23          	sw	zero,148(s1)
10000a2a:	08e4a823          	sw	a4,144(s1)

            // 检查按键活动标志
            if (key_activity_flag == 0) {
10000a2e:	0704c703          	lbu	a4,112(s1)
10000a32:	22071663          	bnez	a4,10000c5e <main+0x7f0>
                // 无按键活动，计数增加
                no_keypress_50ms_cnt++;
10000a36:	0724d703          	lhu	a4,114(s1)
10000a3a:	0705                	addi	a4,a4,1
10000a3c:	0742                	slli	a4,a4,0x10
10000a3e:	8341                	srli	a4,a4,0x10
10000a40:	06e49923          	sh	a4,114(s1)
                if (no_keypress_50ms_cnt >= 100) { // 5秒无操作
10000a44:	0724d683          	lhu	a3,114(s1)
10000a48:	06300713          	li	a4,99
10000a4c:	0cd77863          	bgeu	a4,a3,10000b1c <main+0x6ae>
                    log_printf("Ready to sleep (no action for 5s)\n");
10000a50:	10003537          	lui	a0,0x10003
10000a54:	0c850513          	addi	a0,a0,200 # 100030c8 <memset+0x26c>
10000a58:	f46ff0ef          	jal	1000019e <log_printf>
10000a5c:	40010737          	lui	a4,0x40010
                    no_keypress_50ms_cnt = 0;
10000a60:	06049923          	sh	zero,114(s1)
10000a64:	4334                	lw	a3,64(a4)
10000a66:	7661                	lui	a2,0xffff8
10000a68:	e3c60613          	addi	a2,a2,-452 # ffff7e3c <__StackTop+0xdfff3e3c>
10000a6c:	8ef1                	and	a3,a3,a2
10000a6e:	c334                	sw	a3,64(a4)
 *                   (active-low wake-up)
 */
void config_wakeup_gpio(uint32_t gpio_mask, uint8_t is_n_wakeup)
{
    /* Remove specified GPIOs from sleep unused mask to keep them active during sleep */
    unused_gpio_mask_when_sleep &= ~gpio_mask;
10000a70:	20002637          	lui	a2,0x20002
10000a74:	b6062703          	lw	a4,-1184(a2) # 20001b60 <unused_gpio_mask_when_sleep>
10000a78:	ffc406b7          	lui	a3,0xffc40
10000a7c:	16fd                	addi	a3,a3,-1 # ffc3ffff <__StackTop+0xdfc3bfff>
10000a7e:	8f75                	and	a4,a4,a3
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
10000a80:	400106b7          	lui	a3,0x40010
    unused_gpio_mask_when_sleep &= ~gpio_mask;
10000a84:	b6e62023          	sw	a4,-1184(a2)
    uint32_t func_val = is_n_wakeup ? 0x20 : 0x40;
    /* Iterate through all possible GPIO bits (0-23) to configure masked pins */
    for (int i = 0; i < 24; i++)
    {
        if ((gpio_mask >> i) & 0x1)
10000a88:	003c0537          	lui	a0,0x3c0
    for (int i = 0; i < 24; i++)
10000a8c:	4701                	li	a4,0
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
10000a8e:	20068693          	addi	a3,a3,512 # 40010200 <__StackTop+0x2000c200>
10000a92:	02000313          	li	t1,32
    for (int i = 0; i < 24; i++)
10000a96:	45e1                	li	a1,24
        if ((gpio_mask >> i) & 0x1)
10000a98:	00e55633          	srl	a2,a0,a4
10000a9c:	8a05                	andi	a2,a2,1
10000a9e:	c609                	beqz	a2,10000aa8 <main+0x63a>
	*(volatile uint8_t *)(GPIO_ATF_BASE + pin) = (func_code & 0xFF);
10000aa0:	00d70633          	add	a2,a4,a3
10000aa4:	00660023          	sb	t1,0(a2)
    for (int i = 0; i < 24; i++)
10000aa8:	0705                	addi	a4,a4,1 # 40010001 <__StackTop+0x2000c001>
10000aaa:	feb717e3          	bne	a4,a1,10000a98 <main+0x62a>
    {
        AON_CTRL->WAKEUP_CTRL0 = gpio_mask;  // Active-high wake-up configuration
    }
    else
    {
        AON_CTRL->WAKEUP_CTRL1 = gpio_mask;  // Active-low wake-up configuration
10000aae:	003c0737          	lui	a4,0x3c0
10000ab2:	40080437          	lui	s0,0x40080
                    for (uint8_t i = 0; i < INPUT_PIN_NUM; i++) {
                        wakeup_gpio_bits |= (1 << input_pin[i]);
                    }
                    config_wakeup_gpio(wakeup_gpio_bits, 1);

                    log_printf("Enter sleep mode\n");
10000ab6:	10003537          	lui	a0,0x10003
10000aba:	c858                	sw	a4,20(s0)
10000abc:	0ec50513          	addi	a0,a0,236 # 100030ec <memset+0x290>
10000ac0:	edeff0ef          	jal	1000019e <log_printf>

                    // ========== 4. 进入睡眠 ==========
                    enter_sleep_mode();
10000ac4:	1b0020ef          	jal	10002c74 <enter_sleep_mode>

                    // ========== 5. 唤醒后初始化 ==========
                    log_printf("\n=== Wakeup from sleep ===\n");
10000ac8:	10003537          	lui	a0,0x10003
10000acc:	10050513          	addi	a0,a0,256 # 10003100 <memset+0x2a4>
10000ad0:	eceff0ef          	jal	1000019e <log_printf>
                    log_printf("Wakeup IO: 0x%x\n", AON_CTRL->WAKEUP_RECORD);
10000ad4:	4c4c                	lw	a1,28(s0)
10000ad6:	10003537          	lui	a0,0x10003
10000ada:	11c50513          	addi	a0,a0,284 # 1000311c <memset+0x2c0>
10000ade:	ec0ff0ef          	jal	1000019e <log_printf>
    GPIO_INOUT->GPIO_O = state ? (GPIO_INOUT->GPIO_O | gpio_bits) : (GPIO_INOUT->GPIO_O & ~gpio_bits);
10000ae2:	40010737          	lui	a4,0x40010
10000ae6:	4334                	lw	a3,64(a4)
10000ae8:	6621                	lui	a2,0x8
10000aea:	1c360613          	addi	a2,a2,451 # 81c3 <log_dbg.c.59673f20+0xaa4>
10000aee:	8ed1                	or	a3,a3,a2
10000af0:	c334                	sw	a3,64(a4)

                    // 5.1 恢复输出口
                    gpio_write(output_bits, GPIO_HIGH);

                    // 5.2 重新初始化BLE广播发送
                    ble_adv_timer_init();
10000af2:	3229                	jal	100003fc <ble_adv_timer_init>

                    // 5.3 重置时钟计数器
                    watch_dog_T = hal_clock_get_system_tick();
10000af4:	4c98                	lw	a4,24(s1)
                    key_scan_timer = hal_clock_get_system_tick();
                    sleep_check_timer = hal_clock_get_system_tick();

                    key_activity_flag = 0;
                    log_printf("=== System resumed ===\n\n");
10000af6:	10003537          	lui	a0,0x10003
                    watch_dog_T = hal_clock_get_system_tick();
10000afa:	08048693          	addi	a3,s1,128
                    log_printf("=== System resumed ===\n\n");
10000afe:	13050513          	addi	a0,a0,304 # 10003130 <memset+0x2d4>
                    watch_dog_T = hal_clock_get_system_tick();
10000b02:	c298                	sw	a4,0(a3)
10000b04:	0804a223          	sw	zero,132(s1)
                    key_scan_timer = hal_clock_get_system_tick();
10000b08:	d4b8                	sw	a4,104(s1)
10000b0a:	0604a623          	sw	zero,108(s1)
                    sleep_check_timer = hal_clock_get_system_tick();
10000b0e:	ca98                	sw	a4,16(a3)
10000b10:	0804aa23          	sw	zero,148(s1)
                    key_activity_flag = 0;
10000b14:	06048823          	sb	zero,112(s1)
                    log_printf("=== System resumed ===\n\n");
10000b18:	e86ff0ef          	jal	1000019e <log_printf>
}

/* ==================== 指示灯闪烁处理 ==================== */
void app_remoter_led_blink(void)
{
    if(led_blink_flag) {
10000b1c:	0744c703          	lbu	a4,116(s1)
10000b20:	b2070fe3          	beqz	a4,1000065e <main+0x1f0>
        if(hal_clock_time_exceed(t_led_blink, 150*1000)) {  // 150ms
10000b24:	0984a503          	lw	a0,152(s1)
10000b28:	09c4a583          	lw	a1,156(s1)
10000b2c:	00025637          	lui	a2,0x25
10000b30:	9f060613          	addi	a2,a2,-1552 # 249f0 <ble_viot.c.543f92a8+0x1c367>
10000b34:	e0aff0ef          	jal	1000013e <hal_clock_time_exceed>
10000b38:	b20503e3          	beqz	a0,1000065e <main+0x1f0>
            t_led_blink = hal_clock_get_system_tick();
10000b3c:	4c98                	lw	a4,24(s1)
            
            static uint8_t led_sta = 0;
            if(!led_sta) {
10000b3e:	0a04c683          	lbu	a3,160(s1)
            t_led_blink = hal_clock_get_system_tick();
10000b42:	0804ae23          	sw	zero,156(s1)
10000b46:	08e4ac23          	sw	a4,152(s1)
10000b4a:	40010737          	lui	a4,0x40010
10000b4e:	0741                	addi	a4,a4,16 # 40010010 <__StackTop+0x2000c010>
            if(!led_sta) {
10000b50:	10069c63          	bnez	a3,10000c68 <main+0x7fa>
                led_sta = 1;
10000b54:	4685                	li	a3,1
10000b56:	0ad48023          	sb	a3,160(s1)
10000b5a:	5b14                	lw	a3,48(a4)
10000b5c:	2006e693          	ori	a3,a3,512
10000b60:	db14                	sw	a3,48(a4)
                led_sta = 0;
                led_blink_times--;
                gpio_write((1 << SINGLE_LED_GPIO), GPIO_LOW);
            }
            
            if(led_blink_times == 0) {
10000b62:	0a14c703          	lbu	a4,161(s1)
10000b66:	ae071ce3          	bnez	a4,1000065e <main+0x1f0>
                led_blink_flag = 0;
10000b6a:	06048a23          	sb	zero,116(s1)
10000b6e:	bcc5                	j	1000065e <main+0x1f0>
    else if(handle_flag == 0x03)
10000b70:	458d                	li	a1,3
10000b72:	00b69b63          	bne	a3,a1,10000b88 <main+0x71a>
        p_key_fun->long_release_handler((str_fun_para*)&p_key_fun->long_release_para);
10000b76:	02800693          	li	a3,40
10000b7a:	02d70733          	mul	a4,a4,a3
10000b7e:	02070513          	addi	a0,a4,32
10000b82:	9722                	add	a4,a4,s0
10000b84:	4378                	lw	a4,68(a4)
10000b86:	b1f5                	j	10000872 <main+0x404>
    }
    else if(handle_flag == 0x01 && press_time >= DEFAULT_LONG_THRESHOLD)
10000b88:	4585                	li	a1,1
10000b8a:	e8b690e3          	bne	a3,a1,10000a0a <main+0x59c>
    {
        // 长按触发（按键按下期间，达到长按阈值时触发，只触发一次）
        if(press_time == DEFAULT_LONG_THRESHOLD)
10000b8e:	7d000693          	li	a3,2000
10000b92:	e6d31ce3          	bne	t1,a3,10000a0a <main+0x59c>
        {
            p_key_fun->long_press_handler((str_fun_para*)&p_key_fun->long_press_para);
10000b96:	02800693          	li	a3,40
10000b9a:	02d70733          	mul	a4,a4,a3
10000b9e:	01470513          	addi	a0,a4,20
10000ba2:	9722                	add	a4,a4,s0
10000ba4:	5f18                	lw	a4,56(a4)
10000ba6:	9532                	add	a0,a0,a2
10000ba8:	9702                	jalr	a4
        if(press_time == DEFAULT_LONG_THRESHOLD)
10000baa:	b9c1                	j	1000087a <main+0x40c>
    for(uint8_t i = 0; i < encoded_data_len; i++) {
10000bac:	477d                	li	a4,31
10000bae:	dce616e3          	bne	a2,a4,1000097a <main+0x50c>
    }
    log_printf("\n");
10000bb2:	100037b7          	lui	a5,0x10003
10000bb6:	0a478513          	addi	a0,a5,164 # 100030a4 <memset+0x248>
10000bba:	c032                	sw	a2,0(sp)
10000bbc:	de2ff0ef          	jal	1000019e <log_printf>
    packet_len = 8 + data_len;  // 2字节头部 + 6字节MAC + 数据长度
10000bc0:	02700713          	li	a4,39
10000bc4:	06e48c23          	sb	a4,120(s1)
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
10000bc8:	22112737          	lui	a4,0x22112
    memcpy(&packet_buffer[8], data, data_len);
10000bcc:	4602                	lw	a2,0(sp)
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
10000bce:	54270713          	addi	a4,a4,1346 # 22112542 <__StackTop+0x210e542>
10000bd2:	d498                	sw	a4,40(s1)
10000bd4:	66554737          	lui	a4,0x66554
10000bd8:	43370713          	addi	a4,a4,1075 # 66554433 <__StackTop+0x46550433>
    memcpy(&packet_buffer[8], data, data_len);
10000bdc:	084c                	addi	a1,sp,20
10000bde:	03048513          	addi	a0,s1,48
    packet_buffer[0] = 0x42;  // PDU Type: ADV_NONCONN_IND
10000be2:	d4d8                	sw	a4,44(s1)
    memcpy(&packet_buffer[8], data, data_len);
10000be4:	260020ef          	jal	10002e44 <memcpy>
    log_printf("广播MAC地址: ");
10000be8:	10003537          	lui	a0,0x10003
10000bec:	0a850513          	addi	a0,a0,168 # 100030a8 <memset+0x24c>
10000bf0:	daeff0ef          	jal	1000019e <log_printf>
10000bf4:	4781                	li	a5,0
        log_printf("%02X", DEFAULT_BLE_MAC[i]);
10000bf6:	00f40733          	add	a4,s0,a5
10000bfa:	48874583          	lbu	a1,1160(a4)
10000bfe:	10003537          	lui	a0,0x10003
10000c02:	0bc50513          	addi	a0,a0,188 # 100030bc <memset+0x260>
10000c06:	c03e                	sw	a5,0(sp)
10000c08:	d96ff0ef          	jal	1000019e <log_printf>
        if(i < 5) log_printf(":");
10000c0c:	4782                	lw	a5,0(sp)
10000c0e:	4719                	li	a4,6
10000c10:	0785                	addi	a5,a5,1
10000c12:	02e79d63          	bne	a5,a4,10000c4c <main+0x7de>
    log_printf("\n");
10000c16:	100037b7          	lui	a5,0x10003
10000c1a:	0a478513          	addi	a0,a5,164 # 100030a4 <memset+0x248>
10000c1e:	d80ff0ef          	jal	1000019e <log_printf>
    packet_tx_count = tx_num;
10000c22:	04600713          	li	a4,70
10000c26:	00e49f23          	sh	a4,30(s1)
    send_interval_us = interval_ms * 1000;  // 转换为微秒
10000c2a:	3e800713          	li	a4,1000
10000c2e:	06e49b23          	sh	a4,118(s1)
    last_send_time = 0;
10000c32:	4701                	li	a4,0
10000c34:	4781                	li	a5,0
10000c36:	d098                	sw	a4,32(s1)
    
    // 发送编码后的数据包
    ble_adv_send(index, encoded_data, encoded_data_len, SEND_BEACON_MAX_TIMES, SEND_BEACON_INTERVAL, SEND_BEACON_CHANNEL);
    
    // 清空参数
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
10000c38:	4661                	li	a2,24
    send_packet_request = 1;
10000c3a:	4705                	li	a4,1
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
10000c3c:	4581                	li	a1,0
10000c3e:	8526                	mv	a0,s1
    last_send_time = 0;
10000c40:	d0dc                	sw	a5,36(s1)
    send_packet_request = 1;
10000c42:	00e48e23          	sb	a4,28(s1)
    memset(&ble_viot_para, 0x0, sizeof(str_ble_viot_para));
10000c46:	216020ef          	jal	10002e5c <memset>
    
    return ret;
10000c4a:	b3c1                	j	10000a0a <main+0x59c>
        if(i < 5) log_printf(":");
10000c4c:	10003537          	lui	a0,0x10003
10000c50:	0c450513          	addi	a0,a0,196 # 100030c4 <memset+0x268>
10000c54:	c03e                	sw	a5,0(sp)
10000c56:	d48ff0ef          	jal	1000019e <log_printf>
10000c5a:	4782                	lw	a5,0(sp)
10000c5c:	bf69                	j	10000bf6 <main+0x788>
                }
            } else {
                // 有按键活动，重置计数和标志
                no_keypress_50ms_cnt = 0;
10000c5e:	06049923          	sh	zero,114(s1)
                key_activity_flag = 0;
10000c62:	06048823          	sb	zero,112(s1)
10000c66:	bd5d                	j	10000b1c <main+0x6ae>
                led_blink_times--;
10000c68:	0a14c683          	lbu	a3,161(s1)
                led_sta = 0;
10000c6c:	0a048023          	sb	zero,160(s1)
                led_blink_times--;
10000c70:	16fd                	addi	a3,a3,-1
10000c72:	0ff6f693          	zext.b	a3,a3
10000c76:	0ad480a3          	sb	a3,161(s1)
10000c7a:	5b14                	lw	a3,48(a4)
10000c7c:	dff6f693          	andi	a3,a3,-513
10000c80:	b5c5                	j	10000b60 <main+0x6f2>

10000c82 <Default_Handler>:
10000c82:	400007b7          	lui	a5,0x40000
10000c86:	0f800713          	li	a4,248
10000c8a:	10e7a023          	sw	a4,256(a5) # 40000100 <__StackTop+0x1fffc100>
10000c8e:	a001                	j	10000c8e <Default_Handler+0xc>

10000c90 <clic_init>:
10000c90:	e0800737          	lui	a4,0xe0800
10000c94:	435c                	lw	a5,4(a4)
10000c96:	83d1                	srli	a5,a5,0x14
10000c98:	8bf9                	andi	a5,a5,30
10000c9a:	00f70023          	sb	a5,0(a4) # e0800000 <__StackTop+0xc07fc000>
10000c9e:	4701                	li	a4,0
10000ca0:	e0800537          	lui	a0,0xe0800
10000ca4:	6585                	lui	a1,0x1
10000ca6:	4685                	li	a3,1
10000ca8:	03000613          	li	a2,48
10000cac:	00271793          	slli	a5,a4,0x2
10000cb0:	97aa                	add	a5,a5,a0
10000cb2:	97ae                	add	a5,a5,a1
10000cb4:	00d78023          	sb	a3,0(a5)
10000cb8:	000780a3          	sb	zero,1(a5)
10000cbc:	00d78123          	sb	a3,2(a5)
10000cc0:	0705                	addi	a4,a4,1
10000cc2:	fec715e3          	bne	a4,a2,10000cac <clic_init+0x1c>
10000cc6:	8082                	ret

10000cc8 <t1100_rom_init>:
10000cc8:	8082                	ret

10000cca <ram_init>:
10000cca:	1171                	addi	sp,sp,-4
10000ccc:	c006                	sw	ra,0(sp)
10000cce:	10003737          	lui	a4,0x10003
10000cd2:	69470713          	addi	a4,a4,1684 # 10003694 <__exidx_end>
10000cd6:	100037b7          	lui	a5,0x10003
10000cda:	6a078793          	addi	a5,a5,1696 # 100036a0 <__copy_table_end__>
10000cde:	86ba                	mv	a3,a4
10000ce0:	853e                	mv	a0,a5
10000ce2:	04f76563          	bltu	a4,a5,10000d2c <ram_init+0x62>
10000ce6:	10003737          	lui	a4,0x10003
10000cea:	6a070713          	addi	a4,a4,1696 # 100036a0 <__copy_table_end__>
10000cee:	100037b7          	lui	a5,0x10003
10000cf2:	6a878793          	addi	a5,a5,1704 # 100036a8 <__etext>
10000cf6:	06f77063          	bgeu	a4,a5,10000d56 <ram_init+0x8c>
10000cfa:	86ba                	mv	a3,a4
10000cfc:	100035b7          	lui	a1,0x10003
10000d00:	6a758593          	addi	a1,a1,1703 # 100036a7 <__copy_table_end__+0x7>
10000d04:	8d99                	sub	a1,a1,a4
10000d06:	99e1                	andi	a1,a1,-8
10000d08:	05a1                	addi	a1,a1,8
10000d0a:	95ba                	add	a1,a1,a4
10000d0c:	a089                	j	10000d4e <ram_init+0x84>
10000d0e:	00279613          	slli	a2,a5,0x2
10000d12:	4298                	lw	a4,0(a3)
10000d14:	9732                	add	a4,a4,a2
10000d16:	430c                	lw	a1,0(a4)
10000d18:	42d8                	lw	a4,4(a3)
10000d1a:	9732                	add	a4,a4,a2
10000d1c:	c30c                	sw	a1,0(a4)
10000d1e:	0785                	addi	a5,a5,1
10000d20:	4698                	lw	a4,8(a3)
10000d22:	fee7e6e3          	bltu	a5,a4,10000d0e <ram_init+0x44>
10000d26:	06b1                	addi	a3,a3,12
10000d28:	faa6ffe3          	bgeu	a3,a0,10000ce6 <ram_init+0x1c>
10000d2c:	4698                	lw	a4,8(a3)
10000d2e:	4781                	li	a5,0
10000d30:	ff79                	bnez	a4,10000d0e <ram_init+0x44>
10000d32:	bfd5                	j	10000d26 <ram_init+0x5c>
10000d34:	4298                	lw	a4,0(a3)
10000d36:	00279613          	slli	a2,a5,0x2
10000d3a:	9732                	add	a4,a4,a2
10000d3c:	00072023          	sw	zero,0(a4)
10000d40:	0785                	addi	a5,a5,1
10000d42:	42d8                	lw	a4,4(a3)
10000d44:	fee7e8e3          	bltu	a5,a4,10000d34 <ram_init+0x6a>
10000d48:	06a1                	addi	a3,a3,8
10000d4a:	00b68663          	beq	a3,a1,10000d56 <ram_init+0x8c>
10000d4e:	42d8                	lw	a4,4(a3)
10000d50:	4781                	li	a5,0
10000d52:	f36d                	bnez	a4,10000d34 <ram_init+0x6a>
10000d54:	bfd5                	j	10000d48 <ram_init+0x7e>
10000d56:	3f8d                	jal	10000cc8 <t1100_rom_init>
10000d58:	4082                	lw	ra,0(sp)
10000d5a:	0111                	addi	sp,sp,4
10000d5c:	8082                	ret

10000d5e <sys_entry>:
10000d5e:	400007b7          	lui	a5,0x40000
10000d62:	4398                	lw	a4,0(a5)
10000d64:	6785                	lui	a5,0x1
10000d66:	10178793          	addi	a5,a5,257 # 1101 <main.c.479021b4+0x59>
10000d6a:	00f70363          	beq	a4,a5,10000d70 <sys_entry+0x12>
10000d6e:	8082                	ret
10000d70:	1141                	addi	sp,sp,-16
10000d72:	c606                	sw	ra,12(sp)
10000d74:	c422                	sw	s0,8(sp)
10000d76:	c226                	sw	s1,4(sp)
10000d78:	3f89                	jal	10000cca <ram_init>
10000d7a:	3f19                	jal	10000c90 <clic_init>
10000d7c:	40080437          	lui	s0,0x40080
10000d80:	4785                	li	a5,1
10000d82:	c83c                	sw	a5,80(s0)
10000d84:	42000737          	lui	a4,0x42000
10000d88:	6785                	lui	a5,0x1
10000d8a:	70178793          	addi	a5,a5,1793 # 1701 <main.c.479021b4+0x659>
10000d8e:	10f72023          	sw	a5,256(a4) # 42000100 <__StackTop+0x21ffc100>
10000d92:	2059                	jal	10000e18 <otp_load_cfg>
10000d94:	2195                	jal	100011f8 <otp_apply_cfg>
10000d96:	108010ef          	jal	10001e9e <PMU_OnChip_Init>
10000d9a:	400004b7          	lui	s1,0x40000
10000d9e:	50dc                	lw	a5,36(s1)
10000da0:	001007b7          	lui	a5,0x100
10000da4:	40078793          	addi	a5,a5,1024 # 100400 <__ROM_SIZE+0xc0400>
10000da8:	d0dc                	sw	a5,36(s1)
10000daa:	42002737          	lui	a4,0x42002
10000dae:	431c                	lw	a5,0(a4)
10000db0:	9bf5                	andi	a5,a5,-3
10000db2:	c31c                	sw	a5,0(a4)
10000db4:	11042783          	lw	a5,272(s0) # 40080110 <__StackTop+0x2007c110>
10000db8:	6721                	lui	a4,0x8
10000dba:	80070713          	addi	a4,a4,-2048 # 7800 <log_dbg.c.59673f20+0xe1>
10000dbe:	8fd9                	or	a5,a5,a4
10000dc0:	10f42823          	sw	a5,272(s0)
10000dc4:	00fcd537          	lui	a0,0xfcd
10000dc8:	bff50513          	addi	a0,a0,-1025 # fccbff <__ROM_SIZE+0xf8cbff>
10000dcc:	10000097          	auipc	ra,0x10000
10000dd0:	856080e7          	jalr	-1962(ra) # 20000622 <poweron_unused_gpio_mask_parse_and_set>
10000dd4:	12044783          	lbu	a5,288(s0)
10000dd8:	0047e793          	ori	a5,a5,4
10000ddc:	12f40023          	sb	a5,288(s0)
10000de0:	40000793          	li	a5,1024
10000de4:	c49c                	sw	a5,8(s1)
10000de6:	c002                	sw	zero,0(sp)
10000de8:	4702                	lw	a4,0(sp)
10000dea:	47a5                	li	a5,9
10000dec:	00e7c963          	blt	a5,a4,10000dfe <sys_entry+0xa0>
10000df0:	873e                	mv	a4,a5
10000df2:	4782                	lw	a5,0(sp)
10000df4:	0785                	addi	a5,a5,1
10000df6:	c03e                	sw	a5,0(sp)
10000df8:	4782                	lw	a5,0(sp)
10000dfa:	fef75ce3          	bge	a4,a5,10000df2 <sys_entry+0x94>
10000dfe:	400007b7          	lui	a5,0x40000
10000e02:	0007a423          	sw	zero,8(a5) # 40000008 <__StackTop+0x1fffc008>
10000e06:	300467f3          	csrrsi	a5,mstatus,8
10000e0a:	e64ff0ef          	jal	1000046e <main>
10000e0e:	40b2                	lw	ra,12(sp)
10000e10:	4422                	lw	s0,8(sp)
10000e12:	4492                	lw	s1,4(sp)
10000e14:	0141                	addi	sp,sp,16
10000e16:	8082                	ret

10000e18 <otp_load_cfg>:
10000e18:	1f8046b7          	lui	a3,0x1f804
10000e1c:	f3068713          	addi	a4,a3,-208 # 1f803f30 <__etext+0xf800888>
10000e20:	200027b7          	lui	a5,0x20002
10000e24:	96478793          	addi	a5,a5,-1692 # 20001964 <g_otp_cfg>
10000e28:	f7868693          	addi	a3,a3,-136
10000e2c:	00072383          	lw	t2,0(a4)
10000e30:	00472283          	lw	t0,4(a4)
10000e34:	00872303          	lw	t1,8(a4)
10000e38:	4748                	lw	a0,12(a4)
10000e3a:	4b0c                	lw	a1,16(a4)
10000e3c:	4b50                	lw	a2,20(a4)
10000e3e:	0077a023          	sw	t2,0(a5)
10000e42:	0057a223          	sw	t0,4(a5)
10000e46:	0067a423          	sw	t1,8(a5)
10000e4a:	c7c8                	sw	a0,12(a5)
10000e4c:	cb8c                	sw	a1,16(a5)
10000e4e:	cbd0                	sw	a2,20(a5)
10000e50:	0761                	addi	a4,a4,24
10000e52:	07e1                	addi	a5,a5,24
10000e54:	fcd71ce3          	bne	a4,a3,10000e2c <otp_load_cfg+0x14>
10000e58:	200027b7          	lui	a5,0x20002
10000e5c:	9647c703          	lbu	a4,-1692(a5) # 20001964 <g_otp_cfg>
10000e60:	0ff00793          	li	a5,255
10000e64:	00f71d63          	bne	a4,a5,10000e7e <otp_load_cfg+0x66>
10000e68:	20002737          	lui	a4,0x20002
10000e6c:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10000e70:	00074783          	lbu	a5,0(a4)
10000e74:	9bc1                	andi	a5,a5,-16
10000e76:	00a7e793          	ori	a5,a5,10
10000e7a:	00f70023          	sb	a5,0(a4)
10000e7e:	200027b7          	lui	a5,0x20002
10000e82:	9667c703          	lbu	a4,-1690(a5) # 20001966 <g_otp_cfg+0x2>
10000e86:	0ff00793          	li	a5,255
10000e8a:	10f70f63          	beq	a4,a5,10000fa8 <otp_load_cfg+0x190>
10000e8e:	200027b7          	lui	a5,0x20002
10000e92:	9687d703          	lhu	a4,-1688(a5) # 20001968 <g_otp_cfg+0x4>
10000e96:	67c1                	lui	a5,0x10
10000e98:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000e9a:	12f70363          	beq	a4,a5,10000fc0 <otp_load_cfg+0x1a8>
10000e9e:	200027b7          	lui	a5,0x20002
10000ea2:	96a7d703          	lhu	a4,-1686(a5) # 2000196a <g_otp_cfg+0x6>
10000ea6:	67c1                	lui	a5,0x10
10000ea8:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000eaa:	12f70263          	beq	a4,a5,10000fce <otp_load_cfg+0x1b6>
10000eae:	200027b7          	lui	a5,0x20002
10000eb2:	96c7d703          	lhu	a4,-1684(a5) # 2000196c <g_otp_cfg+0x8>
10000eb6:	67c1                	lui	a5,0x10
10000eb8:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000eba:	12f70163          	beq	a4,a5,10000fdc <otp_load_cfg+0x1c4>
10000ebe:	200027b7          	lui	a5,0x20002
10000ec2:	9707a703          	lw	a4,-1680(a5) # 20001970 <g_otp_cfg+0xc>
10000ec6:	57fd                	li	a5,-1
10000ec8:	12f70763          	beq	a4,a5,10000ff6 <otp_load_cfg+0x1de>
10000ecc:	200027b7          	lui	a5,0x20002
10000ed0:	9747a703          	lw	a4,-1676(a5) # 20001974 <g_otp_cfg+0x10>
10000ed4:	57fd                	li	a5,-1
10000ed6:	14f70263          	beq	a4,a5,1000101a <otp_load_cfg+0x202>
10000eda:	200027b7          	lui	a5,0x20002
10000ede:	9787a703          	lw	a4,-1672(a5) # 20001978 <g_otp_cfg+0x14>
10000ee2:	57fd                	li	a5,-1
10000ee4:	14f70d63          	beq	a4,a5,1000103e <otp_load_cfg+0x226>
10000ee8:	200027b7          	lui	a5,0x20002
10000eec:	97c7a703          	lw	a4,-1668(a5) # 2000197c <g_otp_cfg+0x18>
10000ef0:	57fd                	li	a5,-1
10000ef2:	16f70863          	beq	a4,a5,10001062 <otp_load_cfg+0x24a>
10000ef6:	200027b7          	lui	a5,0x20002
10000efa:	9807a703          	lw	a4,-1664(a5) # 20001980 <g_otp_cfg+0x1c>
10000efe:	57fd                	li	a5,-1
10000f00:	18f70363          	beq	a4,a5,10001086 <otp_load_cfg+0x26e>
10000f04:	200027b7          	lui	a5,0x20002
10000f08:	9847a703          	lw	a4,-1660(a5) # 20001984 <g_otp_cfg+0x20>
10000f0c:	57fd                	li	a5,-1
10000f0e:	18f70e63          	beq	a4,a5,100010aa <otp_load_cfg+0x292>
10000f12:	200027b7          	lui	a5,0x20002
10000f16:	9887a703          	lw	a4,-1656(a5) # 20001988 <g_otp_cfg+0x24>
10000f1a:	57fd                	li	a5,-1
10000f1c:	1af70963          	beq	a4,a5,100010ce <otp_load_cfg+0x2b6>
10000f20:	200027b7          	lui	a5,0x20002
10000f24:	98c7a703          	lw	a4,-1652(a5) # 2000198c <g_otp_cfg+0x28>
10000f28:	57fd                	li	a5,-1
10000f2a:	1cf70663          	beq	a4,a5,100010f6 <otp_load_cfg+0x2de>
10000f2e:	200027b7          	lui	a5,0x20002
10000f32:	9907d703          	lhu	a4,-1648(a5) # 20001990 <g_otp_cfg+0x2c>
10000f36:	67c1                	lui	a5,0x10
10000f38:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000f3a:	1ef70063          	beq	a4,a5,1000111a <otp_load_cfg+0x302>
10000f3e:	200027b7          	lui	a5,0x20002
10000f42:	9947d703          	lhu	a4,-1644(a5) # 20001994 <g_otp_cfg+0x30>
10000f46:	67c1                	lui	a5,0x10
10000f48:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000f4a:	1ef70363          	beq	a4,a5,10001130 <otp_load_cfg+0x318>
10000f4e:	200027b7          	lui	a5,0x20002
10000f52:	9967d703          	lhu	a4,-1642(a5) # 20001996 <g_otp_cfg+0x32>
10000f56:	67c1                	lui	a5,0x10
10000f58:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000f5a:	1ef70663          	beq	a4,a5,10001146 <otp_load_cfg+0x32e>
10000f5e:	200027b7          	lui	a5,0x20002
10000f62:	9987d703          	lhu	a4,-1640(a5) # 20001998 <g_otp_cfg+0x34>
10000f66:	67c1                	lui	a5,0x10
10000f68:	17fd                	addi	a5,a5,-1 # ffff <ble_viot.c.543f92a8+0x7976>
10000f6a:	1ef70963          	beq	a4,a5,1000115c <otp_load_cfg+0x344>
10000f6e:	200027b7          	lui	a5,0x20002
10000f72:	99c7a703          	lw	a4,-1636(a5) # 2000199c <g_otp_cfg+0x38>
10000f76:	57fd                	li	a5,-1
10000f78:	1ef70f63          	beq	a4,a5,10001176 <otp_load_cfg+0x35e>
10000f7c:	200027b7          	lui	a5,0x20002
10000f80:	9a07a703          	lw	a4,-1632(a5) # 200019a0 <g_otp_cfg+0x3c>
10000f84:	57fd                	li	a5,-1
10000f86:	20f70463          	beq	a4,a5,1000118e <otp_load_cfg+0x376>
10000f8a:	200027b7          	lui	a5,0x20002
10000f8e:	9a47a703          	lw	a4,-1628(a5) # 200019a4 <g_otp_cfg+0x40>
10000f92:	57fd                	li	a5,-1
10000f94:	20f70c63          	beq	a4,a5,100011ac <otp_load_cfg+0x394>
10000f98:	200027b7          	lui	a5,0x20002
10000f9c:	9a87a703          	lw	a4,-1624(a5) # 200019a8 <g_otp_cfg+0x44>
10000fa0:	57fd                	li	a5,-1
10000fa2:	22f70963          	beq	a4,a5,100011d4 <otp_load_cfg+0x3bc>
10000fa6:	8082                	ret
10000fa8:	20002737          	lui	a4,0x20002
10000fac:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10000fb0:	00274783          	lbu	a5,2(a4)
10000fb4:	9bc1                	andi	a5,a5,-16
10000fb6:	0037e793          	ori	a5,a5,3
10000fba:	00f70123          	sb	a5,2(a4)
10000fbe:	bdc1                	j	10000e8e <otp_load_cfg+0x76>
10000fc0:	200027b7          	lui	a5,0x20002
10000fc4:	f8d00713          	li	a4,-115
10000fc8:	96e78423          	sb	a4,-1688(a5) # 20001968 <g_otp_cfg+0x4>
10000fcc:	bdc9                	j	10000e9e <otp_load_cfg+0x86>
10000fce:	200027b7          	lui	a5,0x20002
10000fd2:	fb700713          	li	a4,-73
10000fd6:	96e78523          	sb	a4,-1686(a5) # 2000196a <g_otp_cfg+0x6>
10000fda:	bdd1                	j	10000eae <otp_load_cfg+0x96>
10000fdc:	20002737          	lui	a4,0x20002
10000fe0:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10000fe4:	00875783          	lhu	a5,8(a4)
10000fe8:	c007f793          	andi	a5,a5,-1024
10000fec:	1407e793          	ori	a5,a5,320
10000ff0:	00f71423          	sh	a5,8(a4)
10000ff4:	b5e9                	j	10000ebe <otp_load_cfg+0xa6>
10000ff6:	20002737          	lui	a4,0x20002
10000ffa:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10000ffe:	475c                	lw	a5,12(a4)
10001000:	76fd                	lui	a3,0xfffff
10001002:	8ff5                	and	a5,a5,a3
10001004:	2587e793          	ori	a5,a5,600
10001008:	fc0106b7          	lui	a3,0xfc010
1000100c:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1000100e:	8ff5                	and	a5,a5,a3
10001010:	02ab06b7          	lui	a3,0x2ab0
10001014:	8fd5                	or	a5,a5,a3
10001016:	c75c                	sw	a5,12(a4)
10001018:	bd55                	j	10000ecc <otp_load_cfg+0xb4>
1000101a:	20002737          	lui	a4,0x20002
1000101e:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10001022:	4b1c                	lw	a5,16(a4)
10001024:	76fd                	lui	a3,0xfffff
10001026:	8ff5                	and	a5,a5,a3
10001028:	0c87e793          	ori	a5,a5,200
1000102c:	fc0106b7          	lui	a3,0xfc010
10001030:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10001032:	8ff5                	and	a5,a5,a3
10001034:	00e406b7          	lui	a3,0xe40
10001038:	8fd5                	or	a5,a5,a3
1000103a:	cb1c                	sw	a5,16(a4)
1000103c:	bd79                	j	10000eda <otp_load_cfg+0xc2>
1000103e:	20002737          	lui	a4,0x20002
10001042:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10001046:	4b5c                	lw	a5,20(a4)
10001048:	76fd                	lui	a3,0xfffff
1000104a:	8ff5                	and	a5,a5,a3
1000104c:	4b07e793          	ori	a5,a5,1200
10001050:	fc0106b7          	lui	a3,0xfc010
10001054:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
10001056:	8ff5                	and	a5,a5,a3
10001058:	02ab06b7          	lui	a3,0x2ab0
1000105c:	8fd5                	or	a5,a5,a3
1000105e:	cb5c                	sw	a5,20(a4)
10001060:	b561                	j	10000ee8 <otp_load_cfg+0xd0>
10001062:	20002737          	lui	a4,0x20002
10001066:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
1000106a:	4f1c                	lw	a5,24(a4)
1000106c:	76fd                	lui	a3,0xfffff
1000106e:	8ff5                	and	a5,a5,a3
10001070:	1907e793          	ori	a5,a5,400
10001074:	fc0106b7          	lui	a3,0xfc010
10001078:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1000107a:	8ff5                	and	a5,a5,a3
1000107c:	00e406b7          	lui	a3,0xe40
10001080:	8fd5                	or	a5,a5,a3
10001082:	cf1c                	sw	a5,24(a4)
10001084:	bd8d                	j	10000ef6 <otp_load_cfg+0xde>
10001086:	20002737          	lui	a4,0x20002
1000108a:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
1000108e:	4f5c                	lw	a5,28(a4)
10001090:	76fd                	lui	a3,0xfffff
10001092:	8ff5                	and	a5,a5,a3
10001094:	7087e793          	ori	a5,a5,1800
10001098:	fc0106b7          	lui	a3,0xfc010
1000109c:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1000109e:	8ff5                	and	a5,a5,a3
100010a0:	02ab06b7          	lui	a3,0x2ab0
100010a4:	8fd5                	or	a5,a5,a3
100010a6:	cf5c                	sw	a5,28(a4)
100010a8:	bdb1                	j	10000f04 <otp_load_cfg+0xec>
100010aa:	20002737          	lui	a4,0x20002
100010ae:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
100010b2:	531c                	lw	a5,32(a4)
100010b4:	76fd                	lui	a3,0xfffff
100010b6:	8ff5                	and	a5,a5,a3
100010b8:	2587e793          	ori	a5,a5,600
100010bc:	fc0106b7          	lui	a3,0xfc010
100010c0:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100010c2:	8ff5                	and	a5,a5,a3
100010c4:	00e406b7          	lui	a3,0xe40
100010c8:	8fd5                	or	a5,a5,a3
100010ca:	d31c                	sw	a5,32(a4)
100010cc:	b599                	j	10000f12 <otp_load_cfg+0xfa>
100010ce:	20002737          	lui	a4,0x20002
100010d2:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
100010d6:	535c                	lw	a5,36(a4)
100010d8:	76fd                	lui	a3,0xfffff
100010da:	8ff5                	and	a5,a5,a3
100010dc:	6685                	lui	a3,0x1
100010de:	96068693          	addi	a3,a3,-1696 # 960 <__STACK_SIZE+0x660>
100010e2:	8fd5                	or	a5,a5,a3
100010e4:	fc0106b7          	lui	a3,0xfc010
100010e8:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100010ea:	8ff5                	and	a5,a5,a3
100010ec:	02ab06b7          	lui	a3,0x2ab0
100010f0:	8fd5                	or	a5,a5,a3
100010f2:	d35c                	sw	a5,36(a4)
100010f4:	b535                	j	10000f20 <otp_load_cfg+0x108>
100010f6:	20002737          	lui	a4,0x20002
100010fa:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
100010fe:	571c                	lw	a5,40(a4)
10001100:	76fd                	lui	a3,0xfffff
10001102:	8ff5                	and	a5,a5,a3
10001104:	3207e793          	ori	a5,a5,800
10001108:	fc0106b7          	lui	a3,0xfc010
1000110c:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
1000110e:	8ff5                	and	a5,a5,a3
10001110:	00e406b7          	lui	a3,0xe40
10001114:	8fd5                	or	a5,a5,a3
10001116:	d71c                	sw	a5,40(a4)
10001118:	bd19                	j	10000f2e <otp_load_cfg+0x116>
1000111a:	200027b7          	lui	a5,0x20002
1000111e:	96478793          	addi	a5,a5,-1692 # 20001964 <g_otp_cfg>
10001122:	02c7d703          	lhu	a4,44(a5)
10001126:	3ff76713          	ori	a4,a4,1023
1000112a:	02e79623          	sh	a4,44(a5)
1000112e:	bd01                	j	10000f3e <otp_load_cfg+0x126>
10001130:	200027b7          	lui	a5,0x20002
10001134:	96478793          	addi	a5,a5,-1692 # 20001964 <g_otp_cfg>
10001138:	0307d703          	lhu	a4,48(a5)
1000113c:	76fd                	lui	a3,0xfffff
1000113e:	8f75                	and	a4,a4,a3
10001140:	02e79823          	sh	a4,48(a5)
10001144:	b529                	j	10000f4e <otp_load_cfg+0x136>
10001146:	200027b7          	lui	a5,0x20002
1000114a:	96478793          	addi	a5,a5,-1692 # 20001964 <g_otp_cfg>
1000114e:	0327d703          	lhu	a4,50(a5)
10001152:	76fd                	lui	a3,0xfffff
10001154:	8f75                	and	a4,a4,a3
10001156:	02e79923          	sh	a4,50(a5)
1000115a:	b511                	j	10000f5e <otp_load_cfg+0x146>
1000115c:	20002737          	lui	a4,0x20002
10001160:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10001164:	03475783          	lhu	a5,52(a4)
10001168:	76fd                	lui	a3,0xfffff
1000116a:	8ff5                	and	a5,a5,a3
1000116c:	40c7e793          	ori	a5,a5,1036
10001170:	02f71a23          	sh	a5,52(a4)
10001174:	bbed                	j	10000f6e <otp_load_cfg+0x156>
10001176:	20002737          	lui	a4,0x20002
1000117a:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
1000117e:	5f1c                	lw	a5,56(a4)
10001180:	800006b7          	lui	a3,0x80000
10001184:	8ff5                	and	a5,a5,a3
10001186:	0357e793          	ori	a5,a5,53
1000118a:	df1c                	sw	a5,56(a4)
1000118c:	bbc5                	j	10000f7c <otp_load_cfg+0x164>
1000118e:	20002737          	lui	a4,0x20002
10001192:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10001196:	5f5c                	lw	a5,60(a4)
10001198:	800006b7          	lui	a3,0x80000
1000119c:	8ff5                	and	a5,a5,a3
1000119e:	0003b6b7          	lui	a3,0x3b
100011a2:	98068693          	addi	a3,a3,-1664 # 3a980 <ble_viot.c.543f92a8+0x322f7>
100011a6:	8fd5                	or	a5,a5,a3
100011a8:	df5c                	sw	a5,60(a4)
100011aa:	b3c5                	j	10000f8a <otp_load_cfg+0x172>
100011ac:	20002737          	lui	a4,0x20002
100011b0:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
100011b4:	433c                	lw	a5,64(a4)
100011b6:	76fd                	lui	a3,0xfffff
100011b8:	8ff5                	and	a5,a5,a3
100011ba:	6685                	lui	a3,0x1
100011bc:	bb868693          	addi	a3,a3,-1096 # bb8 <__STACK_SIZE+0x8b8>
100011c0:	8fd5                	or	a5,a5,a3
100011c2:	fc0106b7          	lui	a3,0xfc010
100011c6:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100011c8:	8ff5                	and	a5,a5,a3
100011ca:	035506b7          	lui	a3,0x3550
100011ce:	8fd5                	or	a5,a5,a3
100011d0:	c33c                	sw	a5,64(a4)
100011d2:	b3d9                	j	10000f98 <otp_load_cfg+0x180>
100011d4:	20002737          	lui	a4,0x20002
100011d8:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
100011dc:	437c                	lw	a5,68(a4)
100011de:	76fd                	lui	a3,0xfffff
100011e0:	8ff5                	and	a5,a5,a3
100011e2:	7d07e793          	ori	a5,a5,2000
100011e6:	fc0106b7          	lui	a3,0xfc010
100011ea:	16fd                	addi	a3,a3,-1 # fc00ffff <__StackTop+0xdc00bfff>
100011ec:	8ff5                	and	a5,a5,a3
100011ee:	023906b7          	lui	a3,0x2390
100011f2:	8fd5                	or	a5,a5,a3
100011f4:	c37c                	sw	a5,68(a4)
100011f6:	8082                	ret

100011f8 <otp_apply_cfg>:
100011f8:	400807b7          	lui	a5,0x40080
100011fc:	1047a603          	lw	a2,260(a5) # 40080104 <__StackTop+0x2007c104>
10001200:	fffc4737          	lui	a4,0xfffc4
10001204:	177d                	addi	a4,a4,-1 # fffc3fff <__StackTop+0xdffbffff>
10001206:	8e79                	and	a2,a2,a4
10001208:	20002737          	lui	a4,0x20002
1000120c:	96470713          	addi	a4,a4,-1692 # 20001964 <g_otp_cfg>
10001210:	00275683          	lhu	a3,2(a4)
10001214:	8abd                	andi	a3,a3,15
10001216:	06ba                	slli	a3,a3,0xe
10001218:	8ed1                	or	a3,a3,a2
1000121a:	10d7a223          	sw	a3,260(a5)
1000121e:	1087a603          	lw	a2,264(a5)
10001222:	76c1                	lui	a3,0xffff0
10001224:	0ff68693          	addi	a3,a3,255 # ffff00ff <__StackTop+0xdffec0ff>
10001228:	8e75                	and	a2,a2,a3
1000122a:	00474683          	lbu	a3,4(a4)
1000122e:	06a2                	slli	a3,a3,0x8
10001230:	8ed1                	or	a3,a3,a2
10001232:	10d7a423          	sw	a3,264(a5)
10001236:	10c7a603          	lw	a2,268(a5)
1000123a:	76e1                	lui	a3,0xffff8
1000123c:	07f68693          	addi	a3,a3,127 # ffff807f <__StackTop+0xdfff407f>
10001240:	8e75                	and	a2,a2,a3
10001242:	00674683          	lbu	a3,6(a4)
10001246:	069e                	slli	a3,a3,0x7
10001248:	8ed1                	or	a3,a3,a2
1000124a:	10d7a623          	sw	a3,268(a5)
1000124e:	1107a603          	lw	a2,272(a5)
10001252:	ff0406b7          	lui	a3,0xff040
10001256:	16fd                	addi	a3,a3,-1 # ff03ffff <__StackTop+0xdf03bfff>
10001258:	8e75                	and	a2,a2,a3
1000125a:	5f14                	lw	a3,56(a4)
1000125c:	06ca                	slli	a3,a3,0x12
1000125e:	8ed1                	or	a3,a3,a2
10001260:	10d7a823          	sw	a3,272(a5)
10001264:	42002637          	lui	a2,0x42002
10001268:	4614                	lw	a3,8(a2)
1000126a:	880007b7          	lui	a5,0x88000
1000126e:	17fd                	addi	a5,a5,-1 # 87ffffff <__StackTop+0x67ffbfff>
10001270:	8efd                	and	a3,a3,a5
10001272:	431c                	lw	a5,0(a4)
10001274:	8bbd                	andi	a5,a5,15
10001276:	07ee                	slli	a5,a5,0x1b
10001278:	8fd5                	or	a5,a5,a3
1000127a:	c61c                	sw	a5,8(a2)
1000127c:	8082                	ret

1000127e <omw_clkcal_delayus>:
1000127e:	41f55793          	srai	a5,a0,0x1f
10001282:	8bfd                	andi	a5,a5,31
10001284:	97aa                	add	a5,a5,a0
10001286:	40000737          	lui	a4,0x40000
1000128a:	0b072703          	lw	a4,176(a4) # 400000b0 <__StackTop+0x1fffc0b0>
1000128e:	8795                	srai	a5,a5,0x5
10001290:	4689                	li	a3,2
10001292:	00d7f363          	bgeu	a5,a3,10001298 <omw_clkcal_delayus+0x1a>
10001296:	4789                	li	a5,2
10001298:	97ba                	add	a5,a5,a4
1000129a:	400006b7          	lui	a3,0x40000
1000129e:	0b06a703          	lw	a4,176(a3) # 400000b0 <__StackTop+0x1fffc0b0>
100012a2:	fef76ee3          	bltu	a4,a5,1000129e <omw_clkcal_delayus+0x20>
100012a6:	8082                	ret

100012a8 <omw_clkcal_reset>:
100012a8:	1151                	addi	sp,sp,-12
100012aa:	c406                	sw	ra,8(sp)
100012ac:	c222                	sw	s0,4(sp)
100012ae:	40000437          	lui	s0,0x40000
100012b2:	07044783          	lbu	a5,112(s0) # 40000070 <__StackTop+0x1fffc070>
100012b6:	0ff7f793          	zext.b	a5,a5
100012ba:	0027e793          	ori	a5,a5,2
100012be:	06f40823          	sb	a5,112(s0)
100012c2:	06400513          	li	a0,100
100012c6:	3f65                	jal	1000127e <omw_clkcal_delayus>
100012c8:	07044783          	lbu	a5,112(s0)
100012cc:	0fd7f793          	andi	a5,a5,253
100012d0:	06f40823          	sb	a5,112(s0)
100012d4:	06400513          	li	a0,100
100012d8:	375d                	jal	1000127e <omw_clkcal_delayus>
100012da:	40a2                	lw	ra,8(sp)
100012dc:	4412                	lw	s0,4(sp)
100012de:	0131                	addi	sp,sp,12
100012e0:	8082                	ret

100012e2 <omw_clkcal_init>:
100012e2:	40000737          	lui	a4,0x40000
100012e6:	07074783          	lbu	a5,112(a4) # 40000070 <__StackTop+0x1fffc070>
100012ea:	0fe7f793          	andi	a5,a5,254
100012ee:	068a                	slli	a3,a3,0x2
100012f0:	8edd                	or	a3,a3,a5
100012f2:	0ff6f693          	zext.b	a3,a3
100012f6:	06d70823          	sb	a3,112(a4)
100012fa:	ffd57713          	andi	a4,a0,-3
100012fe:	4785                	li	a5,1
10001300:	00f70a63          	beq	a4,a5,10001314 <omw_clkcal_init+0x32>
10001304:	4785                	li	a5,1
10001306:	00a79533          	sll	a0,a5,a0
1000130a:	0522                	slli	a0,a0,0x8
1000130c:	00b795b3          	sll	a1,a5,a1
10001310:	8dc9                	or	a1,a1,a0
10001312:	a039                	j	10001320 <omw_clkcal_init+0x3e>
10001314:	00b795b3          	sll	a1,a5,a1
10001318:	05a2                	slli	a1,a1,0x8
1000131a:	00a79533          	sll	a0,a5,a0
1000131e:	8dc9                	or	a1,a1,a0
10001320:	05c2                	slli	a1,a1,0x10
10001322:	81c1                	srli	a1,a1,0x10
10001324:	400007b7          	lui	a5,0x40000
10001328:	06b79a23          	sh	a1,116(a5) # 40000074 <__StackTop+0x1fffc074>
1000132c:	dfb0                	sw	a2,120(a5)
1000132e:	8082                	ret

10001330 <omw_clkcal_enable>:
10001330:	400007b7          	lui	a5,0x40000
10001334:	0707c703          	lbu	a4,112(a5) # 40000070 <__StackTop+0x1fffc070>
10001338:	0ff77713          	zext.b	a4,a4
1000133c:	00176793          	ori	a5,a4,1
10001340:	e119                	bnez	a0,10001346 <omw_clkcal_enable+0x16>
10001342:	ffe77793          	andi	a5,a4,-2
10001346:	0ff7f793          	zext.b	a5,a5
1000134a:	40000737          	lui	a4,0x40000
1000134e:	06f70823          	sb	a5,112(a4) # 40000070 <__StackTop+0x1fffc070>
10001352:	8082                	ret

10001354 <omw_clkcal_calpol>:
10001354:	1151                	addi	sp,sp,-12
10001356:	c406                	sw	ra,8(sp)
10001358:	4681                	li	a3,0
1000135a:	3761                	jal	100012e2 <omw_clkcal_init>
1000135c:	37b1                	jal	100012a8 <omw_clkcal_reset>
1000135e:	4505                	li	a0,1
10001360:	3fc1                	jal	10001330 <omw_clkcal_enable>
10001362:	40000737          	lui	a4,0x40000
10001366:	07074783          	lbu	a5,112(a4) # 40000070 <__StackTop+0x1fffc070>
1000136a:	8bc1                	andi	a5,a5,16
1000136c:	dfed                	beqz	a5,10001366 <omw_clkcal_calpol+0x12>
1000136e:	400007b7          	lui	a5,0x40000
10001372:	5fe8                	lw	a0,124(a5)
10001374:	40a2                	lw	ra,8(sp)
10001376:	0131                	addi	sp,sp,12
10001378:	8082                	ret

1000137a <omw_clkcal_rc24m_calibration>:
1000137a:	1111                	addi	sp,sp,-28
1000137c:	cc06                	sw	ra,24(sp)
1000137e:	ca22                	sw	s0,20(sp)
10001380:	c826                	sw	s1,16(sp)
10001382:	400807b7          	lui	a5,0x40080
10001386:	1087a403          	lw	s0,264(a5) # 40080108 <__StackTop+0x2007c108>
1000138a:	8421                	srai	s0,s0,0x8
1000138c:	0ff47413          	zext.b	s0,s0
10001390:	0ff00493          	li	s1,255
10001394:	c002                	sw	zero,0(sp)
10001396:	100007b7          	lui	a5,0x10000
1000139a:	17fd                	addi	a5,a5,-1 # fffffff <__ROM_SIZE+0xffbffff>
1000139c:	c43e                	sw	a5,8(sp)
1000139e:	c63e                	sw	a5,12(sp)
100013a0:	fffc57b7          	lui	a5,0xfffc5
100013a4:	68078793          	addi	a5,a5,1664 # fffc5680 <__StackTop+0xdffc1680>
100013a8:	c23e                	sw	a5,4(sp)
100013aa:	a82d                	j	100013e4 <omw_clkcal_rc24m_calibration+0x6a>
100013ac:	4782                	lw	a5,0(sp)
100013ae:	40f40733          	sub	a4,s0,a5
100013b2:	01f75793          	srli	a5,a4,0x1f
100013b6:	97ba                	add	a5,a5,a4
100013b8:	8785                	srai	a5,a5,0x1
100013ba:	84a2                	mv	s1,s0
100013bc:	8c1d                	sub	s0,s0,a5
100013be:	c42a                	sw	a0,8(sp)
100013c0:	4782                	lw	a5,0(sp)
100013c2:	04f40663          	beq	s0,a5,1000140e <omw_clkcal_rc24m_calibration+0x94>
100013c6:	04940463          	beq	s0,s1,1000140e <omw_clkcal_rc24m_calibration+0x94>
100013ca:	400806b7          	lui	a3,0x40080
100013ce:	1086a783          	lw	a5,264(a3) # 40080108 <__StackTop+0x2007c108>
100013d2:	7741                	lui	a4,0xffff0
100013d4:	0ff70713          	addi	a4,a4,255 # ffff00ff <__StackTop+0xdffec0ff>
100013d8:	8f7d                	and	a4,a4,a5
100013da:	00841793          	slli	a5,s0,0x8
100013de:	8fd9                	or	a5,a5,a4
100013e0:	10f6a423          	sw	a5,264(a3)
100013e4:	0003b637          	lui	a2,0x3b
100013e8:	98060613          	addi	a2,a2,-1664 # 3a980 <ble_viot.c.543f92a8+0x322f7>
100013ec:	4585                	li	a1,1
100013ee:	450d                	li	a0,3
100013f0:	3795                	jal	10001354 <omw_clkcal_calpol>
100013f2:	4792                	lw	a5,4(sp)
100013f4:	953e                	add	a0,a0,a5
100013f6:	faa04be3          	bgtz	a0,100013ac <omw_clkcal_rc24m_calibration+0x32>
100013fa:	40848733          	sub	a4,s1,s0
100013fe:	01f75793          	srli	a5,a4,0x1f
10001402:	97ba                	add	a5,a5,a4
10001404:	8785                	srai	a5,a5,0x1
10001406:	c022                	sw	s0,0(sp)
10001408:	943e                	add	s0,s0,a5
1000140a:	c62a                	sw	a0,12(sp)
1000140c:	bf55                	j	100013c0 <omw_clkcal_rc24m_calibration+0x46>
1000140e:	4732                	lw	a4,12(sp)
10001410:	41f75793          	srai	a5,a4,0x1f
10001414:	8f3d                	xor	a4,a4,a5
10001416:	8f1d                	sub	a4,a4,a5
10001418:	47a2                	lw	a5,8(sp)
1000141a:	41f7d693          	srai	a3,a5,0x1f
1000141e:	8fb5                	xor	a5,a5,a3
10001420:	8f95                	sub	a5,a5,a3
10001422:	00e7c363          	blt	a5,a4,10001428 <omw_clkcal_rc24m_calibration+0xae>
10001426:	4482                	lw	s1,0(sp)
10001428:	06800793          	li	a5,104
1000142c:	02f487b3          	mul	a5,s1,a5
10001430:	6711                	lui	a4,0x4
10001432:	51070713          	addi	a4,a4,1296 # 4510 <__RAM_SIZE+0x510>
10001436:	97ba                	add	a5,a5,a4
10001438:	05a00713          	li	a4,90
1000143c:	02e7c7b3          	div	a5,a5,a4
10001440:	f5678793          	addi	a5,a5,-170
10001444:	0ff00713          	li	a4,255
10001448:	00f75463          	bge	a4,a5,10001450 <omw_clkcal_rc24m_calibration+0xd6>
1000144c:	0ff00793          	li	a5,255
10001450:	40080737          	lui	a4,0x40080
10001454:	10872703          	lw	a4,264(a4) # 40080108 <__StackTop+0x2007c108>
10001458:	0ff00693          	li	a3,255
1000145c:	0096d463          	bge	a3,s1,10001464 <omw_clkcal_rc24m_calibration+0xea>
10001460:	0ff00493          	li	s1,255
10001464:	fff4c693          	not	a3,s1
10001468:	86fd                	srai	a3,a3,0x1f
1000146a:	8cf5                	and	s1,s1,a3
1000146c:	04a2                	slli	s1,s1,0x8
1000146e:	ff0006b7          	lui	a3,0xff000
10001472:	0ff68693          	addi	a3,a3,255 # ff0000ff <__StackTop+0xdeffc0ff>
10001476:	8f75                	and	a4,a4,a3
10001478:	8cd9                	or	s1,s1,a4
1000147a:	fff7c713          	not	a4,a5
1000147e:	877d                	srai	a4,a4,0x1f
10001480:	8ff9                	and	a5,a5,a4
10001482:	07c2                	slli	a5,a5,0x10
10001484:	8cdd                	or	s1,s1,a5
10001486:	400807b7          	lui	a5,0x40080
1000148a:	1097a423          	sw	s1,264(a5) # 40080108 <__StackTop+0x2007c108>
1000148e:	4501                	li	a0,0
10001490:	3545                	jal	10001330 <omw_clkcal_enable>
10001492:	3d19                	jal	100012a8 <omw_clkcal_reset>
10001494:	40e2                	lw	ra,24(sp)
10001496:	4452                	lw	s0,20(sp)
10001498:	44c2                	lw	s1,16(sp)
1000149a:	0171                	addi	sp,sp,28
1000149c:	8082                	ret

1000149e <omw_clkcal_rc32k_calibration>:
1000149e:	1111                	addi	sp,sp,-28
100014a0:	cc06                	sw	ra,24(sp)
100014a2:	ca22                	sw	s0,20(sp)
100014a4:	c826                	sw	s1,16(sp)
100014a6:	400807b7          	lui	a5,0x40080
100014aa:	10c7d403          	lhu	s0,268(a5) # 4008010c <__StackTop+0x2007c10c>
100014ae:	801d                	srli	s0,s0,0x7
100014b0:	0ff47413          	zext.b	s0,s0
100014b4:	0ff00793          	li	a5,255
100014b8:	c03e                	sw	a5,0(sp)
100014ba:	4481                	li	s1,0
100014bc:	100007b7          	lui	a5,0x10000
100014c0:	17fd                	addi	a5,a5,-1 # fffffff <__ROM_SIZE+0xffbffff>
100014c2:	c43e                	sw	a5,8(sp)
100014c4:	c63e                	sw	a5,12(sp)
100014c6:	fffc57b7          	lui	a5,0xfffc5
100014ca:	68078793          	addi	a5,a5,1664 # fffc5680 <__StackTop+0xdffc1680>
100014ce:	c23e                	sw	a5,4(sp)
100014d0:	a081                	j	10001510 <omw_clkcal_rc32k_calibration+0x72>
100014d2:	40940733          	sub	a4,s0,s1
100014d6:	01f75793          	srli	a5,a4,0x1f
100014da:	97ba                	add	a5,a5,a4
100014dc:	8785                	srai	a5,a5,0x1
100014de:	c022                	sw	s0,0(sp)
100014e0:	8c1d                	sub	s0,s0,a5
100014e2:	c42a                	sw	a0,8(sp)
100014e4:	04940a63          	beq	s0,s1,10001538 <omw_clkcal_rc32k_calibration+0x9a>
100014e8:	4782                	lw	a5,0(sp)
100014ea:	04f40763          	beq	s0,a5,10001538 <omw_clkcal_rc32k_calibration+0x9a>
100014ee:	400806b7          	lui	a3,0x40080
100014f2:	10c6d783          	lhu	a5,268(a3) # 4008010c <__StackTop+0x2007c10c>
100014f6:	07c2                	slli	a5,a5,0x10
100014f8:	83c1                	srli	a5,a5,0x10
100014fa:	7761                	lui	a4,0xffff8
100014fc:	07f70713          	addi	a4,a4,127 # ffff807f <__StackTop+0xdfff407f>
10001500:	8f7d                	and	a4,a4,a5
10001502:	00741793          	slli	a5,s0,0x7
10001506:	8fd9                	or	a5,a5,a4
10001508:	07c2                	slli	a5,a5,0x10
1000150a:	83c1                	srli	a5,a5,0x10
1000150c:	10f69623          	sh	a5,268(a3)
10001510:	14700613          	li	a2,327
10001514:	4581                	li	a1,0
10001516:	450d                	li	a0,3
10001518:	3d35                	jal	10001354 <omw_clkcal_calpol>
1000151a:	4792                	lw	a5,4(sp)
1000151c:	953e                	add	a0,a0,a5
1000151e:	faa04ae3          	bgtz	a0,100014d2 <omw_clkcal_rc32k_calibration+0x34>
10001522:	4782                	lw	a5,0(sp)
10001524:	40878733          	sub	a4,a5,s0
10001528:	01f75793          	srli	a5,a4,0x1f
1000152c:	97ba                	add	a5,a5,a4
1000152e:	8785                	srai	a5,a5,0x1
10001530:	84a2                	mv	s1,s0
10001532:	943e                	add	s0,s0,a5
10001534:	c62a                	sw	a0,12(sp)
10001536:	b77d                	j	100014e4 <omw_clkcal_rc32k_calibration+0x46>
10001538:	4732                	lw	a4,12(sp)
1000153a:	41f75793          	srai	a5,a4,0x1f
1000153e:	8f3d                	xor	a4,a4,a5
10001540:	8f1d                	sub	a4,a4,a5
10001542:	47a2                	lw	a5,8(sp)
10001544:	41f7d693          	srai	a3,a5,0x1f
10001548:	8fb5                	xor	a5,a5,a3
1000154a:	8f95                	sub	a5,a5,a3
1000154c:	00e7c363          	blt	a5,a4,10001552 <omw_clkcal_rc32k_calibration+0xb4>
10001550:	c026                	sw	s1,0(sp)
10001552:	400806b7          	lui	a3,0x40080
10001556:	10c6d783          	lhu	a5,268(a3) # 4008010c <__StackTop+0x2007c10c>
1000155a:	07c2                	slli	a5,a5,0x10
1000155c:	83c1                	srli	a5,a5,0x10
1000155e:	7761                	lui	a4,0xffff8
10001560:	07f70713          	addi	a4,a4,127 # ffff807f <__StackTop+0xdfff407f>
10001564:	8f7d                	and	a4,a4,a5
10001566:	4782                	lw	a5,0(sp)
10001568:	079e                	slli	a5,a5,0x7
1000156a:	8fd9                	or	a5,a5,a4
1000156c:	07c2                	slli	a5,a5,0x10
1000156e:	83c1                	srli	a5,a5,0x10
10001570:	10f69623          	sh	a5,268(a3)
10001574:	4501                	li	a0,0
10001576:	3b6d                	jal	10001330 <omw_clkcal_enable>
10001578:	3b05                	jal	100012a8 <omw_clkcal_reset>
1000157a:	40e2                	lw	ra,24(sp)
1000157c:	4452                	lw	s0,20(sp)
1000157e:	44c2                	lw	s1,16(sp)
10001580:	0171                	addi	sp,sp,28
10001582:	8082                	ret

10001584 <cal_autolen_pkt_desc_offset>:
10001584:	200027b7          	lui	a5,0x20002
10001588:	9a078623          	sb	zero,-1620(a5) # 200019ac <autolen_pkt_desc_offset>
1000158c:	200027b7          	lui	a5,0x20002
10001590:	9d47c783          	lbu	a5,-1580(a5) # 200019d4 <rf_2g4_mgr+0x1c>
10001594:	cf9d                	beqz	a5,100015d2 <cal_autolen_pkt_desc_offset+0x4e>
10001596:	200027b7          	lui	a5,0x20002
1000159a:	9d57c783          	lbu	a5,-1579(a5) # 200019d5 <rf_2g4_mgr+0x1d>
1000159e:	c791                	beqz	a5,100015aa <cal_autolen_pkt_desc_offset+0x26>
100015a0:	200027b7          	lui	a5,0x20002
100015a4:	4705                	li	a4,1
100015a6:	9ae78623          	sb	a4,-1620(a5) # 200019ac <autolen_pkt_desc_offset>
100015aa:	200027b7          	lui	a5,0x20002
100015ae:	9ac78793          	addi	a5,a5,-1620 # 200019ac <autolen_pkt_desc_offset>
100015b2:	0007c703          	lbu	a4,0(a5)
100015b6:	00170693          	addi	a3,a4,1
100015ba:	00d78023          	sb	a3,0(a5)
100015be:	200027b7          	lui	a5,0x20002
100015c2:	9d77c783          	lbu	a5,-1577(a5) # 200019d7 <rf_2g4_mgr+0x1f>
100015c6:	c791                	beqz	a5,100015d2 <cal_autolen_pkt_desc_offset+0x4e>
100015c8:	0709                	addi	a4,a4,2
100015ca:	200027b7          	lui	a5,0x20002
100015ce:	9ae78623          	sb	a4,-1620(a5) # 200019ac <autolen_pkt_desc_offset>
100015d2:	8082                	ret

100015d4 <RF_2G4_DescInit_Mode>:
100015d4:	200027b7          	lui	a5,0x20002
100015d8:	a467c683          	lbu	a3,-1466(a5) # 20001a46 <rf_2g4_thld+0x2>
100015dc:	200027b7          	lui	a5,0x20002
100015e0:	a9c78793          	addi	a5,a5,-1380 # 20001a9c <rf_common_desc_modem_rx>
100015e4:	0af50563          	beq	a0,a5,1000168e <RF_2G4_DescInit_Mode+0xba>
100015e8:	42002737          	lui	a4,0x42002
100015ec:	0c072783          	lw	a5,192(a4) # 420020c0 <__StackTop+0x21ffe0c0>
100015f0:	07f7f793          	andi	a5,a5,127
100015f4:	0cf72023          	sw	a5,192(a4)
100015f8:	200027b7          	lui	a5,0x20002
100015fc:	9ba7c783          	lbu	a5,-1606(a5) # 200019ba <rf_2g4_mgr+0x2>
10001600:	4705                	li	a4,1
10001602:	4645                	li	a2,17
10001604:	0ae78f63          	beq	a5,a4,100016c2 <RF_2G4_DescInit_Mode+0xee>
10001608:	4705                	li	a4,1
1000160a:	02f77663          	bgeu	a4,a5,10001636 <RF_2G4_DescInit_Mode+0x62>
1000160e:	17f9                	addi	a5,a5,-2
10001610:	0ff7f713          	zext.b	a4,a5
10001614:	4585                	li	a1,1
10001616:	08000793          	li	a5,128
1000161a:	02e5ea63          	bltu	a1,a4,1000164e <RF_2G4_DescInit_Mode+0x7a>
1000161e:	200027b7          	lui	a5,0x20002
10001622:	a9c78793          	addi	a5,a5,-1380 # 20001a9c <rf_common_desc_modem_rx>
10001626:	04f50e63          	beq	a0,a5,10001682 <RF_2G4_DescInit_Mode+0xae>
1000162a:	02400693          	li	a3,36
1000162e:	08000793          	li	a5,128
10001632:	4655                	li	a2,21
10001634:	a829                	j	1000164e <RF_2G4_DescInit_Mode+0x7a>
10001636:	200027b7          	lui	a5,0x20002
1000163a:	a9c78793          	addi	a5,a5,-1380 # 20001a9c <rf_common_desc_modem_rx>
1000163e:	04f50063          	beq	a0,a5,1000167e <RF_2G4_DescInit_Mode+0xaa>
10001642:	200027b7          	lui	a5,0x20002
10001646:	a447c683          	lbu	a3,-1468(a5) # 20001a44 <rf_2g4_thld>
1000164a:	08000793          	li	a5,128
1000164e:	42001737          	lui	a4,0x42001
10001652:	00470593          	addi	a1,a4,4 # 42001004 <__StackTop+0x21ffd004>
10001656:	c10c                	sw	a1,0(a0)
10001658:	0642                	slli	a2,a2,0x10
1000165a:	6589                	lui	a1,0x2
1000165c:	8e4d                	or	a2,a2,a1
1000165e:	c150                	sw	a2,4(a0)
10001660:	08c70613          	addi	a2,a4,140
10001664:	c510                	sw	a2,8(a0)
10001666:	06c2                	slli	a3,a3,0x10
10001668:	8ecd                	or	a3,a3,a1
1000166a:	c554                	sw	a3,12(a0)
1000166c:	05070713          	addi	a4,a4,80
10001670:	c918                	sw	a4,16(a0)
10001672:	07c2                	slli	a5,a5,0x10
10001674:	8fcd                	or	a5,a5,a1
10001676:	0087e793          	ori	a5,a5,8
1000167a:	c95c                	sw	a5,20(a0)
1000167c:	8082                	ret
1000167e:	4605                	li	a2,1
10001680:	b7c9                	j	10001642 <RF_2G4_DescInit_Mode+0x6e>
10001682:	02400693          	li	a3,36
10001686:	08000793          	li	a5,128
1000168a:	4615                	li	a2,5
1000168c:	b7c9                	j	1000164e <RF_2G4_DescInit_Mode+0x7a>
1000168e:	42002737          	lui	a4,0x42002
10001692:	0c072783          	lw	a5,192(a4) # 420020c0 <__StackTop+0x21ffe0c0>
10001696:	07f7f793          	andi	a5,a5,127
1000169a:	0cf72023          	sw	a5,192(a4)
1000169e:	200027b7          	lui	a5,0x20002
100016a2:	9ba7c783          	lbu	a5,-1606(a5) # 200019ba <rf_2g4_mgr+0x2>
100016a6:	4705                	li	a4,1
100016a8:	4605                	li	a2,1
100016aa:	f4e79fe3          	bne	a5,a4,10001608 <RF_2G4_DescInit_Mode+0x34>
100016ae:	42002737          	lui	a4,0x42002
100016b2:	0c072783          	lw	a5,192(a4) # 420020c0 <__StackTop+0x21ffe0c0>
100016b6:	0807e793          	ori	a5,a5,128
100016ba:	0cf72023          	sw	a5,192(a4)
100016be:	460d                	li	a2,3
100016c0:	a811                	j	100016d4 <RF_2G4_DescInit_Mode+0x100>
100016c2:	420026b7          	lui	a3,0x42002
100016c6:	0c06a703          	lw	a4,192(a3) # 420020c0 <__StackTop+0x21ffe0c0>
100016ca:	08076713          	ori	a4,a4,128
100016ce:	0ce6a023          	sw	a4,192(a3)
100016d2:	863e                	mv	a2,a5
100016d4:	200027b7          	lui	a5,0x20002
100016d8:	a457c683          	lbu	a3,-1467(a5) # 20001a45 <rf_2g4_thld+0x1>
100016dc:	08400793          	li	a5,132
100016e0:	b7bd                	j	1000164e <RF_2G4_DescInit_Mode+0x7a>

100016e2 <RF_2G4_UpdateDesc_TxCommon>:
100016e2:	200026b7          	lui	a3,0x20002
100016e6:	a4c68693          	addi	a3,a3,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
100016ea:	200027b7          	lui	a5,0x20002
100016ee:	9f478793          	addi	a5,a5,-1548 # 200019f4 <rf_2g4_preamble>
100016f2:	c29c                	sw	a5,0(a3)
100016f4:	20002737          	lui	a4,0x20002
100016f8:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
100016fc:	00374783          	lbu	a5,3(a4)
10001700:	078e                	slli	a5,a5,0x3
10001702:	17fd                	addi	a5,a5,-1
10001704:	07c2                	slli	a5,a5,0x10
10001706:	6605                	lui	a2,0x1
10001708:	8fd1                	or	a5,a5,a2
1000170a:	c2dc                	sw	a5,4(a3)
1000170c:	00274783          	lbu	a5,2(a4)
10001710:	470d                	li	a4,3
10001712:	02e78f63          	beq	a5,a4,10001750 <RF_2G4_UpdateDesc_TxCommon+0x6e>
10001716:	4709                	li	a4,2
10001718:	04e78d63          	beq	a5,a4,10001772 <RF_2G4_UpdateDesc_TxCommon+0x90>
1000171c:	200027b7          	lui	a5,0x20002
10001720:	20002737          	lui	a4,0x20002
10001724:	9bc78793          	addi	a5,a5,-1604 # 200019bc <rf_2g4_mgr+0x4>
10001728:	a4f72a23          	sw	a5,-1452(a4) # 20001a54 <rf_2g4_tx_pkt_desc+0x8>
1000172c:	4601                	li	a2,0
1000172e:	6705                	lui	a4,0x1
10001730:	20002537          	lui	a0,0x20002
10001734:	a4c50513          	addi	a0,a0,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
10001738:	200026b7          	lui	a3,0x20002
1000173c:	9c46c783          	lbu	a5,-1596(a3) # 200019c4 <rf_2g4_mgr+0xc>
10001740:	078e                	slli	a5,a5,0x3
10001742:	97b2                	add	a5,a5,a2
10001744:	17fd                	addi	a5,a5,-1
10001746:	07c2                	slli	a5,a5,0x10
10001748:	8fd9                	or	a5,a5,a4
1000174a:	c55c                	sw	a5,12(a0)
1000174c:	0521                	addi	a0,a0,8
1000174e:	8082                	ret
10001750:	200027b7          	lui	a5,0x20002
10001754:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
10001758:	00078423          	sb	zero,8(a5)
1000175c:	000784a3          	sb	zero,9(a5)
10001760:	0791                	addi	a5,a5,4
10001762:	20002737          	lui	a4,0x20002
10001766:	a4f72a23          	sw	a5,-1452(a4) # 20001a54 <rf_2g4_tx_pkt_desc+0x8>
1000176a:	4615                	li	a2,5
1000176c:	6705                	lui	a4,0x1
1000176e:	0709                	addi	a4,a4,2 # 1002 <__STACK_SIZE+0xd02>
10001770:	b7c1                	j	10001730 <RF_2G4_UpdateDesc_TxCommon+0x4e>
10001772:	200027b7          	lui	a5,0x20002
10001776:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
1000177a:	4705                	li	a4,1
1000177c:	00e78423          	sb	a4,8(a5)
10001780:	000784a3          	sb	zero,9(a5)
10001784:	0791                	addi	a5,a5,4
10001786:	20002737          	lui	a4,0x20002
1000178a:	a4f72a23          	sw	a5,-1452(a4) # 20001a54 <rf_2g4_tx_pkt_desc+0x8>
1000178e:	4615                	li	a2,5
10001790:	6705                	lui	a4,0x1
10001792:	0709                	addi	a4,a4,2 # 1002 <__STACK_SIZE+0xd02>
10001794:	bf71                	j	10001730 <RF_2G4_UpdateDesc_TxCommon+0x4e>

10001796 <RF_2G4_UpdateDesc_TxPkt>:
10001796:	1141                	addi	sp,sp,-16
10001798:	c606                	sw	ra,12(sp)
1000179a:	c422                	sw	s0,8(sp)
1000179c:	c226                	sw	s1,4(sp)
1000179e:	200027b7          	lui	a5,0x20002
100017a2:	9c77c403          	lbu	s0,-1593(a5) # 200019c7 <rf_2g4_mgr+0xf>
100017a6:	00803433          	snez	s0,s0
100017aa:	041a                	slli	s0,s0,0x6
100017ac:	200027b7          	lui	a5,0x20002
100017b0:	9ca7c783          	lbu	a5,-1590(a5) # 200019ca <rf_2g4_mgr+0x12>
100017b4:	12079863          	bnez	a5,100018e4 <RF_2G4_UpdateDesc_TxPkt+0x14e>
100017b8:	c002                	sw	zero,0(sp)
100017ba:	4481                	li	s1,0
100017bc:	371d                	jal	100016e2 <RF_2G4_UpdateDesc_TxCommon>
100017be:	00850713          	addi	a4,a0,8
100017c2:	200026b7          	lui	a3,0x20002
100017c6:	9b868693          	addi	a3,a3,-1608 # 200019b8 <rf_2g4_mgr>
100017ca:	52dc                	lw	a5,36(a3)
100017cc:	0087d613          	srli	a2,a5,0x8
100017d0:	0236c583          	lbu	a1,35(a3)
100017d4:	0ff7f793          	zext.b	a5,a5
100017d8:	07a2                	slli	a5,a5,0x8
100017da:	8fcd                	or	a5,a5,a1
100017dc:	40f607b3          	sub	a5,a2,a5
100017e0:	20002637          	lui	a2,0x20002
100017e4:	a4f61423          	sh	a5,-1464(a2) # 20001a48 <rf_2g4_trans_len>
100017e8:	200027b7          	lui	a5,0x20002
100017ec:	a4c78793          	addi	a5,a5,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
100017f0:	40f707b3          	sub	a5,a4,a5
100017f4:	878d                	srai	a5,a5,0x3
100017f6:	20002637          	lui	a2,0x20002
100017fa:	9af60823          	sb	a5,-1616(a2) # 200019b0 <cur_whiten_desc_tx_st>
100017fe:	01c6c783          	lbu	a5,28(a3)
10001802:	c7a5                	beqz	a5,1000186a <RF_2G4_UpdateDesc_TxPkt+0xd4>
10001804:	200027b7          	lui	a5,0x20002
10001808:	9d57c783          	lbu	a5,-1579(a5) # 200019d5 <rf_2g4_mgr+0x1d>
1000180c:	c795                	beqz	a5,10001838 <RF_2G4_UpdateDesc_TxPkt+0xa2>
1000180e:	20002737          	lui	a4,0x20002
10001812:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
10001816:	01e70793          	addi	a5,a4,30
1000181a:	c51c                	sw	a5,8(a0)
1000181c:	01d74783          	lbu	a5,29(a4)
10001820:	17fd                	addi	a5,a5,-1
10001822:	07c2                	slli	a5,a5,0x10
10001824:	01174703          	lbu	a4,17(a4)
10001828:	8f45                	or	a4,a4,s1
1000182a:	8fd9                	or	a5,a5,a4
1000182c:	8fc1                	or	a5,a5,s0
1000182e:	6705                	lui	a4,0x1
10001830:	8fd9                	or	a5,a5,a4
10001832:	c55c                	sw	a5,12(a0)
10001834:	01050713          	addi	a4,a0,16
10001838:	200027b7          	lui	a5,0x20002
1000183c:	a4878793          	addi	a5,a5,-1464 # 20001a48 <rf_2g4_trans_len>
10001840:	c31c                	sw	a5,0(a4)
10001842:	200026b7          	lui	a3,0x20002
10001846:	9b868693          	addi	a3,a3,-1608 # 200019b8 <rf_2g4_mgr>
1000184a:	01c6c783          	lbu	a5,28(a3)
1000184e:	17fd                	addi	a5,a5,-1
10001850:	07c2                	slli	a5,a5,0x10
10001852:	0116c603          	lbu	a2,17(a3)
10001856:	8e45                	or	a2,a2,s1
10001858:	8fd1                	or	a5,a5,a2
1000185a:	8fc1                	or	a5,a5,s0
1000185c:	6605                	lui	a2,0x1
1000185e:	8fd1                	or	a5,a5,a2
10001860:	c35c                	sw	a5,4(a4)
10001862:	01f6c783          	lbu	a5,31(a3)
10001866:	e7c1                	bnez	a5,100018ee <RF_2G4_UpdateDesc_TxPkt+0x158>
10001868:	0721                	addi	a4,a4,8 # 1008 <__STACK_SIZE+0xd08>
1000186a:	200026b7          	lui	a3,0x20002
1000186e:	9b868693          	addi	a3,a3,-1608 # 200019b8 <rf_2g4_mgr>
10001872:	0236c603          	lbu	a2,35(a3)
10001876:	0246c783          	lbu	a5,36(a3)
1000187a:	07a2                	slli	a5,a5,0x8
1000187c:	8fd1                	or	a5,a5,a2
1000187e:	20002637          	lui	a2,0x20002
10001882:	9b462603          	lw	a2,-1612(a2) # 200019b4 <rf_2g4_fifo>
10001886:	97b2                	add	a5,a5,a2
10001888:	c31c                	sw	a5,0(a4)
1000188a:	200027b7          	lui	a5,0x20002
1000188e:	a487d783          	lhu	a5,-1464(a5) # 20001a48 <rf_2g4_trans_len>
10001892:	078e                	slli	a5,a5,0x3
10001894:	17fd                	addi	a5,a5,-1
10001896:	07c2                	slli	a5,a5,0x10
10001898:	0116c603          	lbu	a2,17(a3)
1000189c:	8cd1                	or	s1,s1,a2
1000189e:	8cdd                	or	s1,s1,a5
100018a0:	8c45                	or	s0,s0,s1
100018a2:	4782                	lw	a5,0(sp)
100018a4:	8c5d                	or	s0,s0,a5
100018a6:	6785                	lui	a5,0x1
100018a8:	8c5d                	or	s0,s0,a5
100018aa:	c340                	sw	s0,4(a4)
100018ac:	200027b7          	lui	a5,0x20002
100018b0:	a4c78793          	addi	a5,a5,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
100018b4:	40f707b3          	sub	a5,a4,a5
100018b8:	878d                	srai	a5,a5,0x3
100018ba:	20002637          	lui	a2,0x20002
100018be:	9af607a3          	sb	a5,-1617(a2) # 200019af <cur_whiten_desc_tx_ed>
100018c2:	0026c783          	lbu	a5,2(a3)
100018c6:	17f9                	addi	a5,a5,-2
100018c8:	0ff7f793          	zext.b	a5,a5
100018cc:	4685                	li	a3,1
100018ce:	04f6f563          	bgeu	a3,a5,10001918 <RF_2G4_UpdateDesc_TxPkt+0x182>
100018d2:	435c                	lw	a5,4(a4)
100018d4:	0087e793          	ori	a5,a5,8
100018d8:	c35c                	sw	a5,4(a4)
100018da:	40b2                	lw	ra,12(sp)
100018dc:	4422                	lw	s0,8(sp)
100018de:	4492                	lw	s1,4(sp)
100018e0:	0141                	addi	sp,sp,16
100018e2:	8082                	ret
100018e4:	47c1                	li	a5,16
100018e6:	c03e                	sw	a5,0(sp)
100018e8:	02000493          	li	s1,32
100018ec:	bdc1                	j	100017bc <RF_2G4_UpdateDesc_TxPkt+0x26>
100018ee:	200026b7          	lui	a3,0x20002
100018f2:	9b868693          	addi	a3,a3,-1608 # 200019b8 <rf_2g4_mgr>
100018f6:	02068793          	addi	a5,a3,32
100018fa:	c71c                	sw	a5,8(a4)
100018fc:	01f6c783          	lbu	a5,31(a3)
10001900:	17fd                	addi	a5,a5,-1
10001902:	07c2                	slli	a5,a5,0x10
10001904:	0116c683          	lbu	a3,17(a3)
10001908:	8ec5                	or	a3,a3,s1
1000190a:	8fd5                	or	a5,a5,a3
1000190c:	8fc1                	or	a5,a5,s0
1000190e:	6685                	lui	a3,0x1
10001910:	8fd5                	or	a5,a5,a3
10001912:	c75c                	sw	a5,12(a4)
10001914:	0741                	addi	a4,a4,16
10001916:	bf91                	j	1000186a <RF_2G4_UpdateDesc_TxPkt+0xd4>
10001918:	200027b7          	lui	a5,0x20002
1000191c:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
10001920:	00978693          	addi	a3,a5,9
10001924:	c714                	sw	a3,8(a4)
10001926:	0117c783          	lbu	a5,17(a5)
1000192a:	000216b7          	lui	a3,0x21
1000192e:	8fd5                	or	a5,a5,a3
10001930:	c75c                	sw	a5,12(a4)
10001932:	0721                	addi	a4,a4,8
10001934:	bf79                	j	100018d2 <RF_2G4_UpdateDesc_TxPkt+0x13c>

10001936 <reverse8>:
10001936:	00151793          	slli	a5,a0,0x1
1000193a:	8505                	srai	a0,a0,0x1
1000193c:	05557713          	andi	a4,a0,85
10001940:	0aa7f513          	andi	a0,a5,170
10001944:	8d59                	or	a0,a0,a4
10001946:	00251793          	slli	a5,a0,0x2
1000194a:	8509                	srai	a0,a0,0x2
1000194c:	03357513          	andi	a0,a0,51
10001950:	0cc7f793          	andi	a5,a5,204
10001954:	8d5d                	or	a0,a0,a5
10001956:	00451793          	slli	a5,a0,0x4
1000195a:	8111                	srli	a0,a0,0x4
1000195c:	8d5d                	or	a0,a0,a5
1000195e:	0ff57513          	zext.b	a0,a0
10001962:	8082                	ret

10001964 <omw_svc_2g4_set_phy_divisor>:
10001964:	87aa                	mv	a5,a0
10001966:	e111                	bnez	a0,1000196a <omw_svc_2g4_set_phy_divisor+0x6>
10001968:	4785                	li	a5,1
1000196a:	0ff7f793          	zext.b	a5,a5
1000196e:	20002737          	lui	a4,0x20002
10001972:	9ba74683          	lbu	a3,-1606(a4) # 200019ba <rf_2g4_mgr+0x2>
10001976:	4705                	li	a4,1
10001978:	04d77163          	bgeu	a4,a3,100019ba <omw_svc_2g4_set_phy_divisor+0x56>
1000197c:	00279713          	slli	a4,a5,0x2
10001980:	973e                	add	a4,a4,a5
10001982:	0746                	slli	a4,a4,0x11
10001984:	6695                	lui	a3,0x5
10001986:	06a1                	addi	a3,a3,8 # 5008 <__RAM_SIZE+0x1008>
10001988:	8f55                	or	a4,a4,a3
1000198a:	200006b7          	lui	a3,0x20000
1000198e:	28e6ae23          	sw	a4,668(a3) # 2000029c <rf_common_desc_tx_end_delay+0x4>
10001992:	4705                	li	a4,1
10001994:	02a77b63          	bgeu	a4,a0,100019ca <omw_svc_2g4_set_phy_divisor+0x66>
10001998:	0ff78693          	addi	a3,a5,255
1000199c:	42001737          	lui	a4,0x42001
100019a0:	06d71823          	sh	a3,112(a4) # 42001070 <__StackTop+0x21ffd070>
100019a4:	42000737          	lui	a4,0x42000
100019a8:	4685                	li	a3,1
100019aa:	0cd707a3          	sb	a3,207(a4) # 420000cf <__StackTop+0x21ffc0cf>
100019ae:	6741                	lui	a4,0x10
100019b0:	97ba                	add	a5,a5,a4
100019b2:	42000737          	lui	a4,0x42000
100019b6:	cf7c                	sw	a5,92(a4)
100019b8:	8082                	ret
100019ba:	00279713          	slli	a4,a5,0x2
100019be:	973e                	add	a4,a4,a5
100019c0:	0742                	slli	a4,a4,0x10
100019c2:	6695                	lui	a3,0x5
100019c4:	06a1                	addi	a3,a3,8 # 5008 <__RAM_SIZE+0x1008>
100019c6:	8f55                	or	a4,a4,a3
100019c8:	b7c9                	j	1000198a <omw_svc_2g4_set_phy_divisor+0x26>
100019ca:	42001737          	lui	a4,0x42001
100019ce:	06071823          	sh	zero,112(a4) # 42001070 <__StackTop+0x21ffd070>
100019d2:	42000737          	lui	a4,0x42000
100019d6:	0c0707a3          	sb	zero,207(a4) # 420000cf <__StackTop+0x21ffc0cf>
100019da:	bfd1                	j	100019ae <omw_svc_2g4_set_phy_divisor+0x4a>

100019dc <RF_2G4_PrepareStart>:
100019dc:	1151                	addi	sp,sp,-12
100019de:	c406                	sw	ra,8(sp)
100019e0:	c222                	sw	s0,4(sp)
100019e2:	c026                	sw	s1,0(sp)
100019e4:	20002437          	lui	s0,0x20002
100019e8:	9b840413          	addi	s0,s0,-1608 # 200019b8 <rf_2g4_mgr>
100019ec:	00244703          	lbu	a4,2(s0)
100019f0:	100037b7          	lui	a5,0x10003
100019f4:	63c78793          	addi	a5,a5,1596 # 1000363c <freq_ratios>
100019f8:	97ba                	add	a5,a5,a4
100019fa:	0007c503          	lbu	a0,0(a5)
100019fe:	379d                	jal	10001964 <omw_svc_2g4_set_phy_divisor>
10001a00:	4048                	lw	a0,4(s0)
10001a02:	0ffff097          	auipc	ra,0xffff
10001a06:	cf8080e7          	jalr	-776(ra) # 200006fa <omw_svc_2g4_set_access_word>
10001a0a:	01344783          	lbu	a5,19(s0)
10001a0e:	420004b7          	lui	s1,0x42000
10001a12:	ccdc                	sw	a5,28(s1)
10001a14:	485c                	lw	a5,20(s0)
10001a16:	d09c                	sw	a5,32(s1)
10001a18:	4c1c                	lw	a5,24(s0)
10001a1a:	d0dc                	sw	a5,36(s1)
10001a1c:	01c44783          	lbu	a5,28(s0)
10001a20:	04f48a23          	sb	a5,84(s1) # 42000054 <__StackTop+0x21ffc054>
10001a24:	20002537          	lui	a0,0x20002
10001a28:	ab450513          	addi	a0,a0,-1356 # 20001ab4 <rf_common_desc_modem_tx>
10001a2c:	3665                	jal	100015d4 <RF_2G4_DescInit_Mode>
10001a2e:	20002537          	lui	a0,0x20002
10001a32:	a9c50513          	addi	a0,a0,-1380 # 20001a9c <rf_common_desc_modem_rx>
10001a36:	3e79                	jal	100015d4 <RF_2G4_DescInit_Mode>
10001a38:	01044783          	lbu	a5,16(s0)
10001a3c:	00f49a23          	sh	a5,20(s1)
10001a40:	00045583          	lhu	a1,0(s0)
10001a44:	20000537          	lui	a0,0x20000
10001a48:	44050513          	addi	a0,a0,1088 # 20000440 <rf_common_desc_tx_setfreq>
10001a4c:	0ffff097          	auipc	ra,0xffff
10001a50:	2aa080e7          	jalr	682(ra) # 20000cf6 <RADIO_CommonDescInit_SetFreq>
10001a54:	00045583          	lhu	a1,0(s0)
10001a58:	20000537          	lui	a0,0x20000
10001a5c:	3b050513          	addi	a0,a0,944 # 200003b0 <rf_common_desc_rx_setfreq>
10001a60:	0ffff097          	auipc	ra,0xffff
10001a64:	296080e7          	jalr	662(ra) # 20000cf6 <RADIO_CommonDescInit_SetFreq>
10001a68:	200007b7          	lui	a5,0x20000
10001a6c:	12878793          	addi	a5,a5,296 # 20000128 <rf_2g4_common_desc_pll_delay>
10001a70:	0047d703          	lhu	a4,4(a5)
10001a74:	001e06b7          	lui	a3,0x1e0
10001a78:	8f55                	or	a4,a4,a3
10001a7a:	c3d8                	sw	a4,4(a5)
10001a7c:	20000737          	lui	a4,0x20000
10001a80:	200027b7          	lui	a5,0x20002
10001a84:	a4c78793          	addi	a5,a5,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
10001a88:	1cf72423          	sw	a5,456(a4) # 200001c8 <rf_call_desc_list_tx_process+0x38>
10001a8c:	20000737          	lui	a4,0x20000
10001a90:	200027b7          	lui	a5,0x20002
10001a94:	a0478793          	addi	a5,a5,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
10001a98:	16f72023          	sw	a5,352(a4) # 20000160 <rf_call_desc_list_rx_process+0x30>
10001a9c:	4cbc                	lw	a5,88(s1)
10001a9e:	83a1                	srli	a5,a5,0x8
10001aa0:	8b85                	andi	a5,a5,1
10001aa2:	00444703          	lbu	a4,4(s0)
10001aa6:	8b05                	andi	a4,a4,1
10001aa8:	05500693          	li	a3,85
10001aac:	04e78963          	beq	a5,a4,10001afe <RF_2G4_PrepareStart+0x122>
10001ab0:	200027b7          	lui	a5,0x20002
10001ab4:	9ba7c783          	lbu	a5,-1606(a5) # 200019ba <rf_2g4_mgr+0x2>
10001ab8:	17f9                	addi	a5,a5,-2
10001aba:	0ff7f793          	zext.b	a5,a5
10001abe:	4705                	li	a4,1
10001ac0:	04f77263          	bgeu	a4,a5,10001b04 <RF_2G4_PrepareStart+0x128>
10001ac4:	200027b7          	lui	a5,0x20002
10001ac8:	9bb7c703          	lbu	a4,-1605(a5) # 200019bb <rf_2g4_mgr+0x3>
10001acc:	cb19                	beqz	a4,10001ae2 <RF_2G4_PrepareStart+0x106>
10001ace:	200027b7          	lui	a5,0x20002
10001ad2:	9f478793          	addi	a5,a5,-1548 # 200019f4 <rf_2g4_preamble>
10001ad6:	973e                	add	a4,a4,a5
10001ad8:	00d78023          	sb	a3,0(a5)
10001adc:	0785                	addi	a5,a5,1
10001ade:	fee79de3          	bne	a5,a4,10001ad8 <RF_2G4_PrepareStart+0xfc>
10001ae2:	200027b7          	lui	a5,0x20002
10001ae6:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
10001aea:	4705                	li	a4,1
10001aec:	02e787a3          	sb	a4,47(a5)
10001af0:	02078823          	sb	zero,48(a5)
10001af4:	40a2                	lw	ra,8(sp)
10001af6:	4412                	lw	s0,4(sp)
10001af8:	4482                	lw	s1,0(sp)
10001afa:	0131                	addi	sp,sp,12
10001afc:	8082                	ret
10001afe:	0aa00693          	li	a3,170
10001b02:	b77d                	j	10001ab0 <RF_2G4_PrepareStart+0xd4>
10001b04:	03c00693          	li	a3,60
10001b08:	bf75                	j	10001ac4 <RF_2G4_PrepareStart+0xe8>

10001b0a <RF_2G4_UpdateDesc_RxCommon>:
10001b0a:	200027b7          	lui	a5,0x20002
10001b0e:	a0478793          	addi	a5,a5,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
10001b12:	0007a023          	sw	zero,0(a5)
10001b16:	0542                	slli	a0,a0,0x10
10001b18:	09056513          	ori	a0,a0,144
10001b1c:	c3c8                	sw	a0,4(a5)
10001b1e:	6711                	lui	a4,0x4
10001b20:	c7d8                	sw	a4,12(a5)
10001b22:	01078513          	addi	a0,a5,16
10001b26:	8082                	ret

10001b28 <RF_2G4_UpdateDesc_RxPkt>:
10001b28:	1131                	addi	sp,sp,-20
10001b2a:	c806                	sw	ra,16(sp)
10001b2c:	c622                	sw	s0,12(sp)
10001b2e:	c426                	sw	s1,8(sp)
10001b30:	200027b7          	lui	a5,0x20002
10001b34:	9c77c403          	lbu	s0,-1593(a5) # 200019c7 <rf_2g4_mgr+0xf>
10001b38:	00803433          	snez	s0,s0
10001b3c:	041a                	slli	s0,s0,0x6
10001b3e:	200027b7          	lui	a5,0x20002
10001b42:	9ca7c783          	lbu	a5,-1590(a5) # 200019ca <rf_2g4_mgr+0x12>
10001b46:	e7f5                	bnez	a5,10001c32 <RF_2G4_UpdateDesc_RxPkt+0x10a>
10001b48:	c202                	sw	zero,4(sp)
10001b4a:	c002                	sw	zero,0(sp)
10001b4c:	200024b7          	lui	s1,0x20002
10001b50:	9b848493          	addi	s1,s1,-1608 # 200019b8 <rf_2g4_mgr>
10001b54:	44c8                	lw	a0,12(s1)
10001b56:	8121                	srli	a0,a0,0x8
10001b58:	0542                	slli	a0,a0,0x10
10001b5a:	8141                	srli	a0,a0,0x10
10001b5c:	377d                	jal	10001b0a <RF_2G4_UpdateDesc_RxCommon>
10001b5e:	200027b7          	lui	a5,0x20002
10001b62:	a0478793          	addi	a5,a5,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
10001b66:	40f507b3          	sub	a5,a0,a5
10001b6a:	878d                	srai	a5,a5,0x3
10001b6c:	20002737          	lui	a4,0x20002
10001b70:	9af70723          	sb	a5,-1618(a4) # 200019ae <cur_whiten_desc_rx_st>
10001b74:	01c4c783          	lbu	a5,28(s1)
10001b78:	c7fd                	beqz	a5,10001c66 <RF_2G4_UpdateDesc_RxPkt+0x13e>
10001b7a:	200027b7          	lui	a5,0x20002
10001b7e:	9d57c783          	lbu	a5,-1579(a5) # 200019d5 <rf_2g4_mgr+0x1d>
10001b82:	c785                	beqz	a5,10001baa <RF_2G4_UpdateDesc_RxPkt+0x82>
10001b84:	20002737          	lui	a4,0x20002
10001b88:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
10001b8c:	01e70793          	addi	a5,a4,30
10001b90:	c11c                	sw	a5,0(a0)
10001b92:	01d74783          	lbu	a5,29(a4)
10001b96:	17fd                	addi	a5,a5,-1
10001b98:	07c2                	slli	a5,a5,0x10
10001b9a:	01174703          	lbu	a4,17(a4)
10001b9e:	8fd9                	or	a5,a5,a4
10001ba0:	8fc1                	or	a5,a5,s0
10001ba2:	4702                	lw	a4,0(sp)
10001ba4:	8fd9                	or	a5,a5,a4
10001ba6:	c15c                	sw	a5,4(a0)
10001ba8:	0521                	addi	a0,a0,8
10001baa:	200027b7          	lui	a5,0x20002
10001bae:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
10001bb2:	02578713          	addi	a4,a5,37
10001bb6:	c118                	sw	a4,0(a0)
10001bb8:	4482                	lw	s1,0(sp)
10001bba:	86a6                	mv	a3,s1
10001bbc:	8622                	mv	a2,s0
10001bbe:	01c7c703          	lbu	a4,28(a5)
10001bc2:	177d                	addi	a4,a4,-1
10001bc4:	0742                	slli	a4,a4,0x10
10001bc6:	0117c583          	lbu	a1,17(a5)
10001bca:	8dc5                	or	a1,a1,s1
10001bcc:	8f4d                	or	a4,a4,a1
10001bce:	8f41                	or	a4,a4,s0
10001bd0:	10076713          	ori	a4,a4,256
10001bd4:	c158                	sw	a4,4(a0)
10001bd6:	01f7c783          	lbu	a5,31(a5)
10001bda:	e3b5                	bnez	a5,10001c3e <RF_2G4_UpdateDesc_RxPkt+0x116>
10001bdc:	0521                	addi	a0,a0,8
10001bde:	200027b7          	lui	a5,0x20002
10001be2:	9b47a783          	lw	a5,-1612(a5) # 200019b4 <rf_2g4_fifo>
10001be6:	c11c                	sw	a5,0(a0)
10001be8:	20002737          	lui	a4,0x20002
10001bec:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
10001bf0:	01174783          	lbu	a5,17(a4)
10001bf4:	4592                	lw	a1,4(sp)
10001bf6:	8fcd                	or	a5,a5,a1
10001bf8:	5318                	lw	a4,32(a4)
10001bfa:	8321                	srli	a4,a4,0x8
10001bfc:	0742                	slli	a4,a4,0x10
10001bfe:	8fd9                	or	a5,a5,a4
10001c00:	8fd1                	or	a5,a5,a2
10001c02:	8fd5                	or	a5,a5,a3
10001c04:	2007e793          	ori	a5,a5,512
10001c08:	c15c                	sw	a5,4(a0)
10001c0a:	200027b7          	lui	a5,0x20002
10001c0e:	a0478793          	addi	a5,a5,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
10001c12:	40f507b3          	sub	a5,a0,a5
10001c16:	878d                	srai	a5,a5,0x3
10001c18:	20002737          	lui	a4,0x20002
10001c1c:	9af706a3          	sb	a5,-1619(a4) # 200019ad <cur_whiten_desc_rx_ed>
10001c20:	415c                	lw	a5,4(a0)
10001c22:	0087e793          	ori	a5,a5,8
10001c26:	c15c                	sw	a5,4(a0)
10001c28:	40c2                	lw	ra,16(sp)
10001c2a:	4432                	lw	s0,12(sp)
10001c2c:	44a2                	lw	s1,8(sp)
10001c2e:	0151                	addi	sp,sp,20
10001c30:	8082                	ret
10001c32:	47c1                	li	a5,16
10001c34:	c23e                	sw	a5,4(sp)
10001c36:	02000793          	li	a5,32
10001c3a:	c03e                	sw	a5,0(sp)
10001c3c:	bf01                	j	10001b4c <RF_2G4_UpdateDesc_RxPkt+0x24>
10001c3e:	20002737          	lui	a4,0x20002
10001c42:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
10001c46:	02070793          	addi	a5,a4,32
10001c4a:	c51c                	sw	a5,8(a0)
10001c4c:	01f74783          	lbu	a5,31(a4)
10001c50:	17fd                	addi	a5,a5,-1
10001c52:	07c2                	slli	a5,a5,0x10
10001c54:	01174703          	lbu	a4,17(a4)
10001c58:	8fd9                	or	a5,a5,a4
10001c5a:	8c5d                	or	s0,s0,a5
10001c5c:	4782                	lw	a5,0(sp)
10001c5e:	8c5d                	or	s0,s0,a5
10001c60:	c540                	sw	s0,12(a0)
10001c62:	0541                	addi	a0,a0,16
10001c64:	bfad                	j	10001bde <RF_2G4_UpdateDesc_RxPkt+0xb6>
10001c66:	200027b7          	lui	a5,0x20002
10001c6a:	9b47a783          	lw	a5,-1612(a5) # 200019b4 <rf_2g4_fifo>
10001c6e:	c11c                	sw	a5,0(a0)
10001c70:	20002737          	lui	a4,0x20002
10001c74:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
10001c78:	535c                	lw	a5,36(a4)
10001c7a:	83a1                	srli	a5,a5,0x8
10001c7c:	07c2                	slli	a5,a5,0x10
10001c7e:	83c1                	srli	a5,a5,0x10
10001c80:	078e                	slli	a5,a5,0x3
10001c82:	17fd                	addi	a5,a5,-1
10001c84:	07c2                	slli	a5,a5,0x10
10001c86:	01174703          	lbu	a4,17(a4)
10001c8a:	8fd9                	or	a5,a5,a4
10001c8c:	8c5d                	or	s0,s0,a5
10001c8e:	4792                	lw	a5,4(sp)
10001c90:	8c5d                	or	s0,s0,a5
10001c92:	4782                	lw	a5,0(sp)
10001c94:	8c5d                	or	s0,s0,a5
10001c96:	c140                	sw	s0,4(a0)
10001c98:	bf8d                	j	10001c0a <RF_2G4_UpdateDesc_RxPkt+0xe2>

10001c9a <omw_svc_2g4_init>:
10001c9a:	1151                	addi	sp,sp,-12
10001c9c:	c406                	sw	ra,8(sp)
10001c9e:	85aa                	mv	a1,a0
10001ca0:	200027b7          	lui	a5,0x20002
10001ca4:	a4478793          	addi	a5,a5,-1468 # 20001a44 <rf_2g4_thld>
10001ca8:	4709                	li	a4,2
10001caa:	00e78023          	sb	a4,0(a5)
10001cae:	00e780a3          	sb	a4,1(a5)
10001cb2:	00e78123          	sb	a4,2(a5)
10001cb6:	00e781a3          	sb	a4,3(a5)
10001cba:	03b00613          	li	a2,59
10001cbe:	20002537          	lui	a0,0x20002
10001cc2:	9b850513          	addi	a0,a0,-1608 # 200019b8 <rf_2g4_mgr>
10001cc6:	17e010ef          	jal	10002e44 <memcpy>
10001cca:	386d                	jal	10001584 <cal_autolen_pkt_desc_offset>
10001ccc:	40a2                	lw	ra,8(sp)
10001cce:	0131                	addi	sp,sp,12
10001cd0:	8082                	ret

10001cd2 <omw_rf_init>:
10001cd2:	1151                	addi	sp,sp,-12
10001cd4:	c406                	sw	ra,8(sp)
10001cd6:	420006b7          	lui	a3,0x42000
10001cda:	6605                	lui	a2,0x1
10001cdc:	70160793          	addi	a5,a2,1793 # 1701 <main.c.479021b4+0x659>
10001ce0:	10f69023          	sh	a5,256(a3) # 42000100 <__StackTop+0x21ffc100>
10001ce4:	478d                	li	a5,3
10001ce6:	06f68023          	sb	a5,96(a3)
10001cea:	e08007b7          	lui	a5,0xe0800
10001cee:	43d8                	lw	a4,4(a5)
10001cf0:	8355                	srli	a4,a4,0x15
10001cf2:	00f77793          	andi	a5,a4,15
10001cf6:	4721                	li	a4,8
10001cf8:	8f1d                	sub	a4,a4,a5
10001cfa:	e08015b7          	lui	a1,0xe0801
10001cfe:	04b5c783          	lbu	a5,75(a1) # e080104b <__StackTop+0xc07fd04b>
10001d02:	0ff7f513          	zext.b	a0,a5
10001d06:	0ff00793          	li	a5,255
10001d0a:	00e797b3          	sll	a5,a5,a4
10001d0e:	fff7c793          	not	a5,a5
10001d12:	8fe9                	and	a5,a5,a0
10001d14:	4511                	li	a0,4
10001d16:	00e51733          	sll	a4,a0,a4
10001d1a:	8fd9                	or	a5,a5,a4
10001d1c:	0ff7f793          	zext.b	a5,a5
10001d20:	04f585a3          	sb	a5,75(a1)
10001d24:	0495c783          	lbu	a5,73(a1)
10001d28:	0ff7f793          	zext.b	a5,a5
10001d2c:	0017e793          	ori	a5,a5,1
10001d30:	04f584a3          	sb	a5,73(a1)
10001d34:	02f00713          	li	a4,47
10001d38:	0ce6a623          	sw	a4,204(a3)
10001d3c:	77fd                	lui	a5,0xfffff
10001d3e:	70078793          	addi	a5,a5,1792 # fffff700 <__StackTop+0xdfffb700>
10001d42:	00f69423          	sh	a5,8(a3)
10001d46:	420017b7          	lui	a5,0x42001
10001d4a:	a0160613          	addi	a2,a2,-1535
10001d4e:	db90                	sw	a2,48(a5)
10001d50:	0ca68723          	sb	a0,206(a3)
10001d54:	02c00713          	li	a4,44
10001d58:	10e79023          	sh	a4,256(a5) # 42001100 <__StackTop+0x21ffd100>
10001d5c:	22c1                	jal	10001f1c <RF_OnChip_Init>
10001d5e:	40a2                	lw	ra,8(sp)
10001d60:	0131                	addi	sp,sp,12
10001d62:	8082                	ret

10001d64 <rf_get_ad_pll_counter>:
10001d64:	1131                	addi	sp,sp,-20
10001d66:	c806                	sw	ra,16(sp)
10001d68:	c622                	sw	s0,12(sp)
10001d6a:	c426                	sw	s1,8(sp)
10001d6c:	c02a                	sw	a0,0(sp)
10001d6e:	c22e                	sw	a1,4(sp)
10001d70:	4415                	li	s0,5
10001d72:	4481                	li	s1,0
10001d74:	400006b7          	lui	a3,0x40000
10001d78:	1846a783          	lw	a5,388(a3) # 40000184 <__StackTop+0x1fffc184>
10001d7c:	7741                	lui	a4,0xffff0
10001d7e:	8ff9                	and	a5,a5,a4
10001d80:	4712                	lw	a4,4(sp)
10001d82:	8fd9                	or	a5,a5,a4
10001d84:	18f6a223          	sw	a5,388(a3)
10001d88:	4502                	lw	a0,0(sp)
10001d8a:	0ffff097          	auipc	ra,0xffff
10001d8e:	0b0080e7          	jalr	176(ra) # 20000e3a <_rf_kvco_read_y>
10001d92:	94aa                	add	s1,s1,a0
10001d94:	147d                	addi	s0,s0,-1
10001d96:	fc79                	bnez	s0,10001d74 <rf_get_ad_pll_counter+0x10>
10001d98:	4515                	li	a0,5
10001d9a:	02a4d533          	divu	a0,s1,a0
10001d9e:	40c2                	lw	ra,16(sp)
10001da0:	4432                	lw	s0,12(sp)
10001da2:	44a2                	lw	s1,8(sp)
10001da4:	0151                	addi	sp,sp,20
10001da6:	8082                	ret

10001da8 <omw_rf_set_tx_pwr_lvl>:
10001da8:	200027b7          	lui	a5,0x20002
10001dac:	af578783          	lb	a5,-1291(a5) # 20001af5 <g_rf_cfg+0x9>
10001db0:	953e                	add	a0,a0,a5
10001db2:	57a5                	li	a5,-23
10001db4:	00f55363          	bge	a0,a5,10001dba <omw_rf_set_tx_pwr_lvl+0x12>
10001db8:	5525                	li	a0,-23
10001dba:	47b5                	li	a5,13
10001dbc:	00a7d363          	bge	a5,a0,10001dc2 <omw_rf_set_tx_pwr_lvl+0x1a>
10001dc0:	4535                	li	a0,13
10001dc2:	01750793          	addi	a5,a0,23
10001dc6:	0ff7f793          	zext.b	a5,a5
10001dca:	20002737          	lui	a4,0x20002
10001dce:	aee74683          	lbu	a3,-1298(a4) # 20001aee <g_rf_cfg+0x2>
10001dd2:	01968593          	addi	a1,a3,25
10001dd6:	0ff5f593          	zext.b	a1,a1
10001dda:	02100713          	li	a4,33
10001dde:	4601                	li	a2,0
10001de0:	00f77d63          	bgeu	a4,a5,10001dfa <omw_rf_set_tx_pwr_lvl+0x52>
10001de4:	fde78713          	addi	a4,a5,-34
10001de8:	00171613          	slli	a2,a4,0x1
10001dec:	20000737          	lui	a4,0x20000
10001df0:	52470713          	addi	a4,a4,1316 # 20000524 <rf_pwr_lvl_map_1>
10001df4:	9732                	add	a4,a4,a2
10001df6:	00075603          	lhu	a2,0(a4)
10001dfa:	00561713          	slli	a4,a2,0x5
10001dfe:	80077713          	andi	a4,a4,-2048
10001e02:	03f67613          	andi	a2,a2,63
10001e06:	8e59                	or	a2,a2,a4
10001e08:	00168713          	addi	a4,a3,1
10001e0c:	072e                	slli	a4,a4,0xb
10001e0e:	06be                	slli	a3,a3,0xf
10001e10:	8ecd                	or	a3,a3,a1
10001e12:	8ed9                	or	a3,a3,a4
10001e14:	00c68733          	add	a4,a3,a2
10001e18:	00179693          	slli	a3,a5,0x1
10001e1c:	200007b7          	lui	a5,0x20000
10001e20:	4d878793          	addi	a5,a5,1240 # 200004d8 <rf_pwr_lvl_map_0>
10001e24:	97b6                	add	a5,a5,a3
10001e26:	0007d783          	lhu	a5,0(a5)
10001e2a:	420026b7          	lui	a3,0x42002
10001e2e:	08c6a583          	lw	a1,140(a3) # 4200208c <__StackTop+0x21ffe08c>
10001e32:	03f7f613          	andi	a2,a5,63
10001e36:	fffc0537          	lui	a0,0xfffc0
10001e3a:	7c050513          	addi	a0,a0,1984 # fffc07c0 <__StackTop+0xdffbc7c0>
10001e3e:	8de9                	and	a1,a1,a0
10001e40:	8e4d                	or	a2,a2,a1
10001e42:	0796                	slli	a5,a5,0x5
10001e44:	8007f793          	andi	a5,a5,-2048
10001e48:	8fd1                	or	a5,a5,a2
10001e4a:	08f6a623          	sw	a5,140(a3)
10001e4e:	469c                	lw	a5,8(a3)
10001e50:	fff80637          	lui	a2,0xfff80
10001e54:	7c060613          	addi	a2,a2,1984 # fff807c0 <__StackTop+0xdff7c7c0>
10001e58:	8ff1                	and	a5,a5,a2
10001e5a:	8fd9                	or	a5,a5,a4
10001e5c:	c69c                	sw	a5,8(a3)
10001e5e:	200007b7          	lui	a5,0x20000
10001e62:	44078793          	addi	a5,a5,1088 # 20000440 <rf_common_desc_tx_setfreq>
10001e66:	00b75693          	srli	a3,a4,0xb
10001e6a:	8abd                	andi	a3,a3,15
10001e6c:	06ce                	slli	a3,a3,0x13
10001e6e:	5bcc                	lw	a1,52(a5)
10001e70:	ff010637          	lui	a2,0xff010
10001e74:	167d                	addi	a2,a2,-1 # ff00ffff <__StackTop+0xdf00bfff>
10001e76:	8df1                	and	a1,a1,a2
10001e78:	8ecd                	or	a3,a3,a1
10001e7a:	dbd4                	sw	a3,52(a5)
10001e7c:	00f75693          	srli	a3,a4,0xf
10001e80:	8a85                	andi	a3,a3,1
10001e82:	06de                	slli	a3,a3,0x17
10001e84:	5fcc                	lw	a1,60(a5)
10001e86:	8df1                	and	a1,a1,a2
10001e88:	8ecd                	or	a3,a3,a1
10001e8a:	dfd4                	sw	a3,60(a5)
10001e8c:	000706b7          	lui	a3,0x70
10001e90:	8f75                	and	a4,a4,a3
10001e92:	43f4                	lw	a3,68(a5)
10001e94:	8e75                	and	a2,a2,a3
10001e96:	8f51                	or	a4,a4,a2
10001e98:	c3f8                	sw	a4,68(a5)
10001e9a:	4501                	li	a0,0
10001e9c:	8082                	ret

10001e9e <PMU_OnChip_Init>:
10001e9e:	1151                	addi	sp,sp,-12
10001ea0:	c406                	sw	ra,8(sp)
10001ea2:	2b7d                	jal	10002460 <omw_rf_cal>
10001ea4:	400807b7          	lui	a5,0x40080
10001ea8:	1107a703          	lw	a4,272(a5) # 40080110 <__StackTop+0x2007c110>
10001eac:	00776713          	ori	a4,a4,7
10001eb0:	10e7a823          	sw	a4,272(a5)
10001eb4:	6725                	lui	a4,0x9
10001eb6:	64270713          	addi	a4,a4,1602 # 9642 <ble_viot.c.543f92a8+0xfb9>
10001eba:	d3b8                	sw	a4,96(a5)
10001ebc:	6719                	lui	a4,0x6
10001ebe:	bab70713          	addi	a4,a4,-1109 # 5bab <driver_uart.c.49586b71+0x1b9>
10001ec2:	10e7a623          	sw	a4,268(a5)
10001ec6:	21290737          	lui	a4,0x21290
10001eca:	177d                	addi	a4,a4,-1 # 2128ffff <__StackTop+0x128bfff>
10001ecc:	c798                	sw	a4,8(a5)
10001ece:	1107a703          	lw	a4,272(a5)
10001ed2:	ff0386b7          	lui	a3,0xff038
10001ed6:	7ff68693          	addi	a3,a3,2047 # ff0387ff <__StackTop+0xdf0347ff>
10001eda:	8f75                	and	a4,a4,a3
10001edc:	00d046b7          	lui	a3,0xd04
10001ee0:	8f55                	or	a4,a4,a3
10001ee2:	10e7a823          	sw	a4,272(a5)
10001ee6:	40a2                	lw	ra,8(sp)
10001ee8:	0131                	addi	sp,sp,12
10001eea:	8082                	ret

10001eec <Radio_OnChip_Set_Freq_Sw>:
10001eec:	0505                	addi	a0,a0,1
10001eee:	4719                	li	a4,6
10001ef0:	02e547b3          	div	a5,a0,a4
10001ef4:	0c878793          	addi	a5,a5,200
10001ef8:	07d2                	slli	a5,a5,0x14
10001efa:	02e56533          	rem	a0,a0,a4
10001efe:	0002b737          	lui	a4,0x2b
10001f02:	aaa70713          	addi	a4,a4,-1366 # 2aaaa <ble_viot.c.543f92a8+0x22421>
10001f06:	02e50533          	mul	a0,a0,a4
10001f0a:	8fc9                	or	a5,a5,a0
10001f0c:	8385                	srli	a5,a5,0x1
10001f0e:	80000737          	lui	a4,0x80000
10001f12:	8fd9                	or	a5,a5,a4
10001f14:	42001737          	lui	a4,0x42001
10001f18:	d35c                	sw	a5,36(a4)
10001f1a:	8082                	ret

10001f1c <RF_OnChip_Init>:
10001f1c:	fcc10113          	addi	sp,sp,-52
10001f20:	d806                	sw	ra,48(sp)
10001f22:	d622                	sw	s0,44(sp)
10001f24:	d426                	sw	s1,40(sp)
10001f26:	0ffff097          	auipc	ra,0xffff
10001f2a:	2bc080e7          	jalr	700(ra) # 200011e2 <RF_OnChip_Base_Init>
10001f2e:	20002637          	lui	a2,0x20002
10001f32:	aec60613          	addi	a2,a2,-1300 # 20001aec <g_rf_cfg>
10001f36:	00264703          	lbu	a4,2(a2)
10001f3a:	20000537          	lui	a0,0x20000
10001f3e:	3a050513          	addi	a0,a0,928 # 200003a0 <rf_common_desc_rftx_on>
10001f42:	4154                	lw	a3,4(a0)
10001f44:	ff0107b7          	lui	a5,0xff010
10001f48:	17fd                	addi	a5,a5,-1 # ff00ffff <__StackTop+0xdf00bfff>
10001f4a:	8efd                	and	a3,a3,a5
10001f4c:	01970593          	addi	a1,a4,25 # 42001019 <__StackTop+0x21ffd019>
10001f50:	0ff5f593          	zext.b	a1,a1
10001f54:	05c2                	slli	a1,a1,0x10
10001f56:	8ecd                	or	a3,a3,a1
10001f58:	c154                	sw	a3,4(a0)
10001f5a:	200005b7          	lui	a1,0x20000
10001f5e:	38858593          	addi	a1,a1,904 # 20000388 <rf_common_desc_rftx_off>
10001f62:	41d4                	lw	a3,4(a1)
10001f64:	8efd                	and	a3,a3,a5
10001f66:	00564503          	lbu	a0,5(a2)
10001f6a:	0542                	slli	a0,a0,0x10
10001f6c:	8ec9                	or	a3,a3,a0
10001f6e:	c1d4                	sw	a3,4(a1)
10001f70:	200004b7          	lui	s1,0x20000
10001f74:	44048413          	addi	s0,s1,1088 # 20000440 <rf_common_desc_tx_setfreq>
10001f78:	4474                	lw	a3,76(s0)
10001f7a:	8efd                	and	a3,a3,a5
10001f7c:	00664583          	lbu	a1,6(a2)
10001f80:	05c2                	slli	a1,a1,0x10
10001f82:	8ecd                	or	a3,a3,a1
10001f84:	c474                	sw	a3,76(s0)
10001f86:	00170313          	addi	t1,a4,1
10001f8a:	0ff37693          	zext.b	a3,t1
10001f8e:	584c                	lw	a1,52(s0)
10001f90:	8dfd                	and	a1,a1,a5
10001f92:	00168513          	addi	a0,a3,1 # d04001 <__ROM_SIZE+0xcc4001>
10001f96:	054e                	slli	a0,a0,0x13
10001f98:	8dc9                	or	a1,a1,a0
10001f9a:	d84c                	sw	a1,52(s0)
10001f9c:	5c48                	lw	a0,60(s0)
10001f9e:	8d7d                	and	a0,a0,a5
10001fa0:	01769293          	slli	t0,a3,0x17
10001fa4:	00ff05b7          	lui	a1,0xff0
10001fa8:	00b2f2b3          	and	t0,t0,a1
10001fac:	00556533          	or	a0,a0,t0
10001fb0:	dc48                	sw	a0,60(s0)
10001fb2:	4068                	lw	a0,68(s0)
10001fb4:	8d7d                	and	a0,a0,a5
10001fb6:	8285                	srli	a3,a3,0x1
10001fb8:	06c2                	slli	a3,a3,0x10
10001fba:	8ec9                	or	a3,a3,a0
10001fbc:	c074                	sw	a3,68(s0)
10001fbe:	200006b7          	lui	a3,0x20000
10001fc2:	3b068693          	addi	a3,a3,944 # 200003b0 <rf_common_desc_rx_setfreq>
10001fc6:	5ac8                	lw	a0,52(a3)
10001fc8:	8d7d                	and	a0,a0,a5
10001fca:	034e                	slli	t1,t1,0x13
10001fcc:	00656533          	or	a0,a0,t1
10001fd0:	dac8                	sw	a0,52(a3)
10001fd2:	5ec8                	lw	a0,60(a3)
10001fd4:	8d7d                	and	a0,a0,a5
10001fd6:	01771313          	slli	t1,a4,0x17
10001fda:	00b37333          	and	t1,t1,a1
10001fde:	00656533          	or	a0,a0,t1
10001fe2:	dec8                	sw	a0,60(a3)
10001fe4:	42e8                	lw	a0,68(a3)
10001fe6:	8d7d                	and	a0,a0,a5
10001fe8:	00175313          	srli	t1,a4,0x1
10001fec:	0342                	slli	t1,t1,0x10
10001fee:	00656533          	or	a0,a0,t1
10001ff2:	c2e8                	sw	a0,68(a3)
10001ff4:	1779                	addi	a4,a4,-2
10001ff6:	0ff77713          	zext.b	a4,a4
10001ffa:	200006b7          	lui	a3,0x20000
10001ffe:	36868693          	addi	a3,a3,872 # 20000368 <rf_common_desc_rfrx_on>
10002002:	46c8                	lw	a0,12(a3)
10002004:	8d7d                	and	a0,a0,a5
10002006:	01771313          	slli	t1,a4,0x17
1000200a:	00b37333          	and	t1,t1,a1
1000200e:	00656533          	or	a0,a0,t1
10002012:	c6c8                	sw	a0,12(a3)
10002014:	4ac8                	lw	a0,20(a3)
10002016:	8d7d                	and	a0,a0,a5
10002018:	8305                	srli	a4,a4,0x1
1000201a:	0742                	slli	a4,a4,0x10
1000201c:	8f49                	or	a4,a4,a0
1000201e:	cad8                	sw	a4,20(a3)
10002020:	00364703          	lbu	a4,3(a2)
10002024:	200006b7          	lui	a3,0x20000
10002028:	34868693          	addi	a3,a3,840 # 20000348 <rf_common_desc_rfrx_off>
1000202c:	42d0                	lw	a2,4(a3)
1000202e:	8e7d                	and	a2,a2,a5
10002030:	01771513          	slli	a0,a4,0x17
10002034:	8de9                	and	a1,a1,a0
10002036:	8dd1                	or	a1,a1,a2
10002038:	c2cc                	sw	a1,4(a3)
1000203a:	46d0                	lw	a2,12(a3)
1000203c:	8ff1                	and	a5,a5,a2
1000203e:	8305                	srli	a4,a4,0x1
10002040:	0742                	slli	a4,a4,0x10
10002042:	8f5d                	or	a4,a4,a5
10002044:	c6d8                	sw	a4,12(a3)
10002046:	09b000ef          	jal	100028e0 <omw_rf_dcoc_cal>
1000204a:	6785                	lui	a5,0x1
1000204c:	40778793          	addi	a5,a5,1031 # 1407 <main.c.479021b4+0x35f>
10002050:	02f11223          	sh	a5,36(sp)
10002054:	02100793          	li	a5,33
10002058:	02f10323          	sb	a5,38(sp)
1000205c:	420027b7          	lui	a5,0x42002
10002060:	60600713          	li	a4,1542
10002064:	cbd8                	sw	a4,20(a5)
10002066:	400006b7          	lui	a3,0x40000
1000206a:	1846a783          	lw	a5,388(a3) # 40000184 <__StackTop+0x1fffc184>
1000206e:	7701                	lui	a4,0xfffe0
10002070:	8ff9                	and	a5,a5,a4
10002072:	6741                	lui	a4,0x10
10002074:	20070713          	addi	a4,a4,512 # 10200 <ble_viot.c.543f92a8+0x7b77>
10002078:	8fd9                	or	a5,a5,a4
1000207a:	18f6a223          	sw	a5,388(a3)
1000207e:	8660b7b7          	lui	a5,0x8660b
10002082:	53878793          	addi	a5,a5,1336 # 8660b538 <__StackTop+0x66607538>
10002086:	c01c                	sw	a5,0(s0)
10002088:	44048513          	addi	a0,s1,1088
1000208c:	0ffff097          	auipc	ra,0xffff
10002090:	e4e080e7          	jalr	-434(ra) # 20000eda <start_await_dma>
10002094:	c002                	sw	zero,0(sp)
10002096:	c202                	sw	zero,4(sp)
10002098:	d002                	sw	zero,32(sp)
1000209a:	ce02                	sw	zero,28(sp)
1000209c:	cc02                	sw	zero,24(sp)
1000209e:	ca02                	sw	zero,20(sp)
100020a0:	200027b7          	lui	a5,0x20002
100020a4:	ad878793          	addi	a5,a5,-1320 # 20001ad8 <g_hp>
100020a8:	c83e                	sw	a5,16(sp)
100020aa:	a819                	j	100020c0 <RF_OnChip_Init+0x1a4>
100020ac:	47d2                	lw	a5,20(sp)
100020ae:	0785                	addi	a5,a5,1
100020b0:	ca3e                	sw	a5,20(sp)
100020b2:	4789                	li	a5,2
100020b4:	4712                	lw	a4,4(sp)
100020b6:	14e7cb63          	blt	a5,a4,1000220c <RF_OnChip_Init+0x2f0>
100020ba:	4752                	lw	a4,20(sp)
100020bc:	18e7ce63          	blt	a5,a4,10002258 <RF_OnChip_Init+0x33c>
100020c0:	103c                	addi	a5,sp,40
100020c2:	4582                	lw	a1,0(sp)
100020c4:	97ae                	add	a5,a5,a1
100020c6:	ffc7c503          	lbu	a0,-4(a5)
100020ca:	350d                	jal	10001eec <Radio_OnChip_Set_Freq_Sw>
100020cc:	42002437          	lui	s0,0x42002
100020d0:	00042c23          	sw	zero,24(s0) # 42002018 <__StackTop+0x21ffe018>
100020d4:	4785                	li	a5,1
100020d6:	cc1c                	sw	a5,24(s0)
100020d8:	470d                	li	a4,3
100020da:	cc18                	sw	a4,24(s0)
100020dc:	cc1c                	sw	a5,24(s0)
100020de:	0c800513          	li	a0,200
100020e2:	0fffe097          	auipc	ra,0xfffe
100020e6:	5a4080e7          	jalr	1444(ra) # 20000686 <delay_us>
100020ea:	4c5c                	lw	a5,28(s0)
100020ec:	0002c737          	lui	a4,0x2c
100020f0:	8fd9                	or	a5,a5,a4
100020f2:	cc5c                	sw	a5,28(s0)
100020f4:	67a5                	lui	a5,0x9
100020f6:	80278793          	addi	a5,a5,-2046 # 8802 <ble_viot.c.543f92a8+0x179>
100020fa:	0cf42a23          	sw	a5,212(s0)
100020fe:	4c5c                	lw	a5,28(s0)
10002100:	83b9                	srli	a5,a5,0xe
10002102:	8b8d                	andi	a5,a5,3
10002104:	6705                	lui	a4,0x1
10002106:	80070713          	addi	a4,a4,-2048 # 800 <__STACK_SIZE+0x500>
1000210a:	00f714b3          	sll	s1,a4,a5
1000210e:	01049713          	slli	a4,s1,0x10
10002112:	8341                	srli	a4,a4,0x10
10002114:	19c00593          	li	a1,412
10002118:	c43a                	sw	a4,8(sp)
1000211a:	853a                	mv	a0,a4
1000211c:	31a1                	jal	10001d64 <rf_get_ad_pll_counter>
1000211e:	c62a                	sw	a0,12(sp)
10002120:	26400593          	li	a1,612
10002124:	4522                	lw	a0,8(sp)
10002126:	393d                	jal	10001d64 <rf_get_ad_pll_counter>
10002128:	4c5c                	lw	a5,28(s0)
1000212a:	7701                	lui	a4,0xfffe0
1000212c:	177d                	addi	a4,a4,-1 # fffdffff <__StackTop+0xdffdbfff>
1000212e:	8ff9                	and	a5,a5,a4
10002130:	cc5c                	sw	a5,28(s0)
10002132:	67a5                	lui	a5,0x9
10002134:	81978793          	addi	a5,a5,-2023 # 8819 <ble_viot.c.543f92a8+0x190>
10002138:	0cf42a23          	sw	a5,212(s0)
1000213c:	47b2                	lw	a5,12(sp)
1000213e:	8d1d                	sub	a0,a0,a5
10002140:	00151793          	slli	a5,a0,0x1
10002144:	953e                	add	a0,a0,a5
10002146:	050a                	slli	a0,a0,0x2
10002148:	00549713          	slli	a4,s1,0x5
1000214c:	8f05                	sub	a4,a4,s1
1000214e:	070a                	slli	a4,a4,0x2
10002150:	9726                	add	a4,a4,s1
10002152:	02a75733          	divu	a4,a4,a0
10002156:	4582                	lw	a1,0(sp)
10002158:	0ff5f793          	zext.b	a5,a1
1000215c:	00179693          	slli	a3,a5,0x1
10002160:	96be                	add	a3,a3,a5
10002162:	4442                	lw	s0,16(sp)
10002164:	96a2                	add	a3,a3,s0
10002166:	4629                	li	a2,10
10002168:	02c777b3          	remu	a5,a4,a2
1000216c:	0057b793          	sltiu	a5,a5,5
10002170:	0017c793          	xori	a5,a5,1
10002174:	02c75733          	divu	a4,a4,a2
10002178:	973e                	add	a4,a4,a5
1000217a:	00e68123          	sb	a4,2(a3)
1000217e:	0fa00713          	li	a4,250
10002182:	02e48733          	mul	a4,s1,a4
10002186:	02a75733          	divu	a4,a4,a0
1000218a:	02c777b3          	remu	a5,a4,a2
1000218e:	0057b793          	sltiu	a5,a5,5
10002192:	0017c793          	xori	a5,a5,1
10002196:	02c75733          	divu	a4,a4,a2
1000219a:	973e                	add	a4,a4,a5
1000219c:	00e68023          	sb	a4,0(a3)
100021a0:	1f400793          	li	a5,500
100021a4:	02f487b3          	mul	a5,s1,a5
100021a8:	02a7d7b3          	divu	a5,a5,a0
100021ac:	02c7f733          	remu	a4,a5,a2
100021b0:	00573713          	sltiu	a4,a4,5
100021b4:	00174713          	xori	a4,a4,1
100021b8:	02c7d7b3          	divu	a5,a5,a2
100021bc:	97ba                	add	a5,a5,a4
100021be:	00f680a3          	sb	a5,1(a3)
100021c2:	00159793          	slli	a5,a1,0x1
100021c6:	97ae                	add	a5,a5,a1
100021c8:	97a2                	add	a5,a5,s0
100021ca:	0007c703          	lbu	a4,0(a5)
100021ce:	fc070793          	addi	a5,a4,-64
100021d2:	0ff7f793          	zext.b	a5,a5
100021d6:	03f00693          	li	a3,63
100021da:	ecf6e9e3          	bltu	a3,a5,100020ac <RF_OnChip_Init+0x190>
100021de:	47e2                	lw	a5,24(sp)
100021e0:	97ba                	add	a5,a5,a4
100021e2:	cc3e                	sw	a5,24(sp)
100021e4:	4702                	lw	a4,0(sp)
100021e6:	00171793          	slli	a5,a4,0x1
100021ea:	97ba                	add	a5,a5,a4
100021ec:	4742                	lw	a4,16(sp)
100021ee:	97ba                	add	a5,a5,a4
100021f0:	0017c703          	lbu	a4,1(a5)
100021f4:	46f2                	lw	a3,28(sp)
100021f6:	9736                	add	a4,a4,a3
100021f8:	ce3a                	sw	a4,28(sp)
100021fa:	0027c783          	lbu	a5,2(a5)
100021fe:	5702                	lw	a4,32(sp)
10002200:	97ba                	add	a5,a5,a4
10002202:	d03e                	sw	a5,32(sp)
10002204:	4792                	lw	a5,4(sp)
10002206:	0785                	addi	a5,a5,1
10002208:	c23e                	sw	a5,4(sp)
1000220a:	b565                	j	100020b2 <RF_OnChip_Init+0x196>
1000220c:	4789                	li	a5,2
1000220e:	4752                	lw	a4,20(sp)
10002210:	04e7c463          	blt	a5,a4,10002258 <RF_OnChip_Init+0x33c>
10002214:	4602                	lw	a2,0(sp)
10002216:	00161793          	slli	a5,a2,0x1
1000221a:	97b2                	add	a5,a5,a2
1000221c:	4742                	lw	a4,16(sp)
1000221e:	97ba                	add	a5,a5,a4
10002220:	470d                	li	a4,3
10002222:	46e2                	lw	a3,24(sp)
10002224:	02e6d6b3          	divu	a3,a3,a4
10002228:	00d78023          	sb	a3,0(a5)
1000222c:	46f2                	lw	a3,28(sp)
1000222e:	02e6d6b3          	divu	a3,a3,a4
10002232:	00d780a3          	sb	a3,1(a5)
10002236:	5682                	lw	a3,32(sp)
10002238:	02e6d733          	divu	a4,a3,a4
1000223c:	00e78123          	sb	a4,2(a5)
10002240:	00160793          	addi	a5,a2,1
10002244:	873e                	mv	a4,a5
10002246:	c03e                	sw	a5,0(sp)
10002248:	4789                	li	a5,2
1000224a:	04e7cd63          	blt	a5,a4,100022a4 <RF_OnChip_Init+0x388>
1000224e:	c202                	sw	zero,4(sp)
10002250:	d002                	sw	zero,32(sp)
10002252:	ce02                	sw	zero,28(sp)
10002254:	cc02                	sw	zero,24(sp)
10002256:	b5ad                	j	100020c0 <RF_OnChip_Init+0x1a4>
10002258:	200027b7          	lui	a5,0x20002
1000225c:	ad878793          	addi	a5,a5,-1320 # 20001ad8 <g_hp>
10002260:	06200713          	li	a4,98
10002264:	00e78023          	sb	a4,0(a5)
10002268:	fc000713          	li	a4,-64
1000226c:	00e780a3          	sb	a4,1(a5)
10002270:	02f00713          	li	a4,47
10002274:	00e78123          	sb	a4,2(a5)
10002278:	05e00693          	li	a3,94
1000227c:	00d781a3          	sb	a3,3(a5)
10002280:	fbe00693          	li	a3,-66
10002284:	00d78223          	sb	a3,4(a5)
10002288:	00e782a3          	sb	a4,5(a5)
1000228c:	05b00713          	li	a4,91
10002290:	00e78323          	sb	a4,6(a5)
10002294:	fb800713          	li	a4,-72
10002298:	00e783a3          	sb	a4,7(a5)
1000229c:	02d00713          	li	a4,45
100022a0:	00e78423          	sb	a4,8(a5)
100022a4:	20000537          	lui	a0,0x20000
100022a8:	38850513          	addi	a0,a0,904 # 20000388 <rf_common_desc_rftx_off>
100022ac:	0ffff097          	auipc	ra,0xffff
100022b0:	c2e080e7          	jalr	-978(ra) # 20000eda <start_await_dma>
100022b4:	40000737          	lui	a4,0x40000
100022b8:	18472783          	lw	a5,388(a4) # 40000184 <__StackTop+0x1fffc184>
100022bc:	7681                	lui	a3,0xfffe0
100022be:	8ff5                	and	a5,a5,a3
100022c0:	2007e793          	ori	a5,a5,512
100022c4:	18f72223          	sw	a5,388(a4)
100022c8:	420027b7          	lui	a5,0x42002
100022cc:	471d                	li	a4,7
100022ce:	cbd8                	sw	a4,20(a5)
100022d0:	0ffff097          	auipc	ra,0xffff
100022d4:	bbc080e7          	jalr	-1092(ra) # 20000e8c <trigger_gpadc_temp_sampling>
100022d8:	4529                	li	a0,10
100022da:	0fffe097          	auipc	ra,0xfffe
100022de:	3ac080e7          	jalr	940(ra) # 20000686 <delay_us>
100022e2:	400407b7          	lui	a5,0x40040
100022e6:	57f8                	lw	a4,108(a5)
100022e8:	200027b7          	lui	a5,0x20002
100022ec:	aee78a23          	sb	a4,-1292(a5) # 20001af4 <g_rf_cfg+0x8>
100022f0:	285d                	jal	100023a6 <disable_gpadc>
100022f2:	0ffff097          	auipc	ra,0xffff
100022f6:	fa6080e7          	jalr	-90(ra) # 20001298 <RF_OnChip_Cali_Cfg>
100022fa:	4501                	li	a0,0
100022fc:	3475                	jal	10001da8 <omw_rf_set_tx_pwr_lvl>
100022fe:	50c2                	lw	ra,48(sp)
10002300:	5432                	lw	s0,44(sp)
10002302:	54a2                	lw	s1,40(sp)
10002304:	03410113          	addi	sp,sp,52
10002308:	8082                	ret

1000230a <omw_clkcal_poll_corner>:
1000230a:	1151                	addi	sp,sp,-12
1000230c:	c406                	sw	ra,8(sp)
1000230e:	c222                	sw	s0,4(sp)
10002310:	c026                	sw	s1,0(sp)
10002312:	40000437          	lui	s0,0x40000
10002316:	07044783          	lbu	a5,112(s0) # 40000070 <__StackTop+0x1fffc070>
1000231a:	0fe7f793          	andi	a5,a5,254
1000231e:	06f40823          	sb	a5,112(s0)
10002322:	6785                	lui	a5,0x1
10002324:	07a1                	addi	a5,a5,8 # 1008 <__STACK_SIZE+0xd08>
10002326:	06f41a23          	sh	a5,116(s0)
1000232a:	47a9                	li	a5,10
1000232c:	dc3c                	sw	a5,120(s0)
1000232e:	583c                	lw	a5,112(s0)
10002330:	0027e793          	ori	a5,a5,2
10002334:	d83c                	sw	a5,112(s0)
10002336:	06400513          	li	a0,100
1000233a:	0fffe097          	auipc	ra,0xfffe
1000233e:	34c080e7          	jalr	844(ra) # 20000686 <delay_us>
10002342:	583c                	lw	a5,112(s0)
10002344:	9bf5                	andi	a5,a5,-3
10002346:	d83c                	sw	a5,112(s0)
10002348:	06400513          	li	a0,100
1000234c:	0fffe097          	auipc	ra,0xfffe
10002350:	33a080e7          	jalr	826(ra) # 20000686 <delay_us>
10002354:	583c                	lw	a5,112(s0)
10002356:	0017e793          	ori	a5,a5,1
1000235a:	d83c                	sw	a5,112(s0)
1000235c:	40000737          	lui	a4,0x40000
10002360:	07074783          	lbu	a5,112(a4) # 40000070 <__StackTop+0x1fffc070>
10002364:	8bc1                	andi	a5,a5,16
10002366:	dfed                	beqz	a5,10002360 <omw_clkcal_poll_corner+0x56>
10002368:	40000437          	lui	s0,0x40000
1000236c:	5c64                	lw	s1,124(s0)
1000236e:	583c                	lw	a5,112(s0)
10002370:	9bf9                	andi	a5,a5,-2
10002372:	d83c                	sw	a5,112(s0)
10002374:	583c                	lw	a5,112(s0)
10002376:	0027e793          	ori	a5,a5,2
1000237a:	d83c                	sw	a5,112(s0)
1000237c:	06400513          	li	a0,100
10002380:	0fffe097          	auipc	ra,0xfffe
10002384:	306080e7          	jalr	774(ra) # 20000686 <delay_us>
10002388:	583c                	lw	a5,112(s0)
1000238a:	9bf5                	andi	a5,a5,-3
1000238c:	d83c                	sw	a5,112(s0)
1000238e:	06400513          	li	a0,100
10002392:	0fffe097          	auipc	ra,0xfffe
10002396:	2f4080e7          	jalr	756(ra) # 20000686 <delay_us>
1000239a:	8526                	mv	a0,s1
1000239c:	40a2                	lw	ra,8(sp)
1000239e:	4412                	lw	s0,4(sp)
100023a0:	4482                	lw	s1,0(sp)
100023a2:	0131                	addi	sp,sp,12
100023a4:	8082                	ret

100023a6 <disable_gpadc>:
100023a6:	420027b7          	lui	a5,0x42002
100023aa:	0e87a703          	lw	a4,232(a5) # 420020e8 <__StackTop+0x21ffe0e8>
100023ae:	9b79                	andi	a4,a4,-2
100023b0:	0ee7a423          	sw	a4,232(a5)
100023b4:	40040737          	lui	a4,0x40040
100023b8:	00072023          	sw	zero,0(a4) # 40040000 <__StackTop+0x2003c000>
100023bc:	43d8                	lw	a4,4(a5)
100023be:	9b79                	andi	a4,a4,-2
100023c0:	c3d8                	sw	a4,4(a5)
100023c2:	8082                	ret

100023c4 <get_vtrim>:
100023c4:	c609                	beqz	a2,100023ce <get_vtrim+0xa>
100023c6:	479d                	li	a5,7
100023c8:	00a7d363          	bge	a5,a0,100023ce <get_vtrim+0xa>
100023cc:	1541                	addi	a0,a0,-16
100023ce:	952e                	add	a0,a0,a1
100023d0:	00c54663          	blt	a0,a2,100023dc <get_vtrim+0x18>
100023d4:	063d                	addi	a2,a2,15
100023d6:	00c55363          	bge	a0,a2,100023dc <get_vtrim+0x18>
100023da:	862a                	mv	a2,a0
100023dc:	0641                	addi	a2,a2,16
100023de:	41f65513          	srai	a0,a2,0x1f
100023e2:	8171                	srli	a0,a0,0x1c
100023e4:	962a                	add	a2,a2,a0
100023e6:	8a3d                	andi	a2,a2,15
100023e8:	40a60533          	sub	a0,a2,a0
100023ec:	8082                	ret

100023ee <get_corner_offset>:
100023ee:	1141                	addi	sp,sp,-16
100023f0:	c606                	sw	ra,12(sp)
100023f2:	c422                	sw	s0,8(sp)
100023f4:	c226                	sw	s1,4(sp)
100023f6:	c02a                	sw	a0,0(sp)
100023f8:	42002437          	lui	s0,0x42002
100023fc:	4044                	lw	s1,4(s0)
100023fe:	445c                	lw	a5,12(s0)
10002400:	1007e793          	ori	a5,a5,256
10002404:	c45c                	sw	a5,12(s0)
10002406:	405c                	lw	a5,4(s0)
10002408:	01c7e793          	ori	a5,a5,28
1000240c:	c05c                	sw	a5,4(s0)
1000240e:	405c                	lw	a5,4(s0)
10002410:	2007e793          	ori	a5,a5,512
10002414:	c05c                	sw	a5,4(s0)
10002416:	441c                	lw	a5,8(s0)
10002418:	87f7f793          	andi	a5,a5,-1921
1000241c:	2807e793          	ori	a5,a5,640
10002420:	c41c                	sw	a5,8(s0)
10002422:	35e5                	jal	1000230a <omw_clkcal_poll_corner>
10002424:	445c                	lw	a5,12(s0)
10002426:	eff7f793          	andi	a5,a5,-257
1000242a:	c45c                	sw	a5,12(s0)
1000242c:	c044                	sw	s1,4(s0)
1000242e:	0003b737          	lui	a4,0x3b
10002432:	98070713          	addi	a4,a4,-1664 # 3a980 <ble_viot.c.543f92a8+0x322f7>
10002436:	02a767b3          	rem	a5,a4,a0
1000243a:	01f55693          	srli	a3,a0,0x1f
1000243e:	96aa                	add	a3,a3,a0
10002440:	8685                	srai	a3,a3,0x1
10002442:	00d7a7b3          	slt	a5,a5,a3
10002446:	0017c793          	xori	a5,a5,1
1000244a:	02a74533          	div	a0,a4,a0
1000244e:	953e                	add	a0,a0,a5
10002450:	4782                	lw	a5,0(sp)
10002452:	40a78533          	sub	a0,a5,a0
10002456:	40b2                	lw	ra,12(sp)
10002458:	4422                	lw	s0,8(sp)
1000245a:	4492                	lw	s1,4(sp)
1000245c:	0141                	addi	sp,sp,16
1000245e:	8082                	ret

10002460 <omw_rf_cal>:
10002460:	1131                	addi	sp,sp,-20
10002462:	c806                	sw	ra,16(sp)
10002464:	c622                	sw	s0,12(sp)
10002466:	c426                	sw	s1,8(sp)
10002468:	14000513          	li	a0,320
1000246c:	3749                	jal	100023ee <get_corner_offset>
1000246e:	1f8047b7          	lui	a5,0x1f804
10002472:	f5c7a683          	lw	a3,-164(a5) # 1f803f5c <__etext+0xf8008b4>
10002476:	82a9                	srli	a3,a3,0xa
10002478:	002007b7          	lui	a5,0x200
1000247c:	17fd                	addi	a5,a5,-1 # 1fffff <__ROM_SIZE+0x1bffff>
1000247e:	8efd                	and	a3,a3,a5
10002480:	12f68c63          	beq	a3,a5,100025b8 <omw_rf_cal+0x158>
10002484:	200027b7          	lui	a5,0x20002
10002488:	9937c783          	lbu	a5,-1645(a5) # 20001993 <g_otp_cfg+0x2f>
1000248c:	8bbd                	andi	a5,a5,15
1000248e:	471d                	li	a4,7
10002490:	12f77163          	bgeu	a4,a5,100025b2 <omw_rf_cal+0x152>
10002494:	17c1                	addi	a5,a5,-16
10002496:	07e2                	slli	a5,a5,0x18
10002498:	87e1                	srai	a5,a5,0x18
1000249a:	20002737          	lui	a4,0x20002
1000249e:	aef70ba3          	sb	a5,-1289(a4) # 20001af7 <g_rf_cfg+0xb>
100024a2:	200025b7          	lui	a1,0x20002
100024a6:	aec58593          	addi	a1,a1,-1300 # 20001aec <g_rf_cfg>
100024aa:	00b58703          	lb	a4,11(a1)
100024ae:	0ff77793          	zext.b	a5,a4
100024b2:	00578613          	addi	a2,a5,5
100024b6:	0ff67613          	zext.b	a2,a2
100024ba:	00570313          	addi	t1,a4,5
100024be:	006581a3          	sb	t1,3(a1)
100024c2:	0f000313          	li	t1,240
100024c6:	4581                	li	a1,0
100024c8:	00c36963          	bltu	t1,a2,100024da <omw_rf_cal+0x7a>
100024cc:	85b2                	mv	a1,a2
100024ce:	433d                	li	t1,15
100024d0:	00c37363          	bgeu	t1,a2,100024d6 <omw_rf_cal+0x76>
100024d4:	45bd                	li	a1,15
100024d6:	0ff5f593          	zext.b	a1,a1
100024da:	20002637          	lui	a2,0x20002
100024de:	aeb60723          	sb	a1,-1298(a2) # 20001aee <g_rf_cfg+0x2>
100024e2:	00370613          	addi	a2,a4,3
100024e6:	0606                	slli	a2,a2,0x1
100024e8:	0ff67613          	zext.b	a2,a2
100024ec:	0f000313          	li	t1,240
100024f0:	4581                	li	a1,0
100024f2:	00c36963          	bltu	t1,a2,10002504 <omw_rf_cal+0xa4>
100024f6:	85b2                	mv	a1,a2
100024f8:	437d                	li	t1,31
100024fa:	00c37363          	bgeu	t1,a2,10002500 <omw_rf_cal+0xa0>
100024fe:	45fd                	li	a1,31
10002500:	0ff5f593          	zext.b	a1,a1
10002504:	20002637          	lui	a2,0x20002
10002508:	aec60613          	addi	a2,a2,-1300 # 20001aec <g_rf_cfg>
1000250c:	00b60223          	sb	a1,4(a2)
10002510:	0786                	slli	a5,a5,0x1
10002512:	0ff7f793          	zext.b	a5,a5
10002516:	00778593          	addi	a1,a5,7
1000251a:	00b602a3          	sb	a1,5(a2)
1000251e:	00c70593          	addi	a1,a4,12
10002522:	0586                	slli	a1,a1,0x1
10002524:	00b60323          	sb	a1,6(a2)
10002528:	0795                	addi	a5,a5,5
1000252a:	00f603a3          	sb	a5,7(a2)
1000252e:	002007b7          	lui	a5,0x200
10002532:	17fd                	addi	a5,a5,-1 # 1fffff <__ROM_SIZE+0x1bffff>
10002534:	0af68e63          	beq	a3,a5,100025f0 <omw_rf_cal+0x190>
10002538:	200027b7          	lui	a5,0x20002
1000253c:	9907a783          	lw	a5,-1648(a5) # 20001990 <g_otp_cfg+0x2c>
10002540:	83d1                	srli	a5,a5,0x14
10002542:	8bbd                	andi	a5,a5,15
10002544:	471d                	li	a4,7
10002546:	0af77263          	bgeu	a4,a5,100025ea <omw_rf_cal+0x18a>
1000254a:	17c1                	addi	a5,a5,-16
1000254c:	07e2                	slli	a5,a5,0x18
1000254e:	87e1                	srai	a5,a5,0x18
10002550:	20002737          	lui	a4,0x20002
10002554:	aef70b23          	sb	a5,-1290(a4) # 20001af6 <g_rf_cfg+0xa>
10002558:	20002437          	lui	s0,0x20002
1000255c:	aec40413          	addi	s0,s0,-1300 # 20001aec <g_rf_cfg>
10002560:	00a40703          	lb	a4,10(s0)
10002564:	200027b7          	lui	a5,0x20002
10002568:	96478793          	addi	a5,a5,-1692 # 20001964 <g_otp_cfg>
1000256c:	c23e                	sw	a5,4(sp)
1000256e:	4384                	lw	s1,0(a5)
10002570:	4601                	li	a2,0
10002572:	c03a                	sw	a4,0(sp)
10002574:	85ba                	mv	a1,a4
10002576:	00f4f513          	andi	a0,s1,15
1000257a:	35a9                	jal	100023c4 <get_vtrim>
1000257c:	00a40023          	sb	a0,0(s0)
10002580:	0104d513          	srli	a0,s1,0x10
10002584:	5661                	li	a2,-8
10002586:	4582                	lw	a1,0(sp)
10002588:	893d                	andi	a0,a0,15
1000258a:	3d2d                	jal	100023c4 <get_vtrim>
1000258c:	00a400a3          	sb	a0,1(s0)
10002590:	478d                	li	a5,3
10002592:	00f404a3          	sb	a5,9(s0)
10002596:	4792                	lw	a5,4(sp)
10002598:	5bd0                	lw	a2,52(a5)
1000259a:	0652                	slli	a2,a2,0x14
1000259c:	8251                	srli	a2,a2,0x14
1000259e:	100037b7          	lui	a5,0x10003
100025a2:	64878793          	addi	a5,a5,1608 # 10003648 <rssi_thresholds>
100025a6:	00c78593          	addi	a1,a5,12
100025aa:	4501                	li	a0,0
100025ac:	470d                	li	a4,3
100025ae:	4305                	li	t1,1
100025b0:	a049                	j	10002632 <omw_rf_cal+0x1d2>
100025b2:	07e2                	slli	a5,a5,0x18
100025b4:	87e1                	srai	a5,a5,0x18
100025b6:	b5d5                	j	1000249a <omw_rf_cal+0x3a>
100025b8:	4661                	li	a2,24
100025ba:	02c54733          	div	a4,a0,a2
100025be:	41f55593          	srai	a1,a0,0x1f
100025c2:	00a5c7b3          	xor	a5,a1,a0
100025c6:	8f8d                	sub	a5,a5,a1
100025c8:	02c7e7b3          	rem	a5,a5,a2
100025cc:	45ad                	li	a1,11
100025ce:	4601                	li	a2,0
100025d0:	00f5d663          	bge	a1,a5,100025dc <omw_rf_cal+0x17c>
100025d4:	41f55613          	srai	a2,a0,0x1f
100025d8:	00166613          	ori	a2,a2,1
100025dc:	00c707b3          	add	a5,a4,a2
100025e0:	20002737          	lui	a4,0x20002
100025e4:	aef70ba3          	sb	a5,-1289(a4) # 20001af7 <g_rf_cfg+0xb>
100025e8:	bd6d                	j	100024a2 <omw_rf_cal+0x42>
100025ea:	07e2                	slli	a5,a5,0x18
100025ec:	87e1                	srai	a5,a5,0x18
100025ee:	b78d                	j	10002550 <omw_rf_cal+0xf0>
100025f0:	00271793          	slli	a5,a4,0x2
100025f4:	8f1d                	sub	a4,a4,a5
100025f6:	070e                	slli	a4,a4,0x3
100025f8:	953a                	add	a0,a0,a4
100025fa:	4699                	li	a3,6
100025fc:	02d54733          	div	a4,a0,a3
10002600:	41f55613          	srai	a2,a0,0x1f
10002604:	00a647b3          	xor	a5,a2,a0
10002608:	8f91                	sub	a5,a5,a2
1000260a:	02d7e7b3          	rem	a5,a5,a3
1000260e:	4609                	li	a2,2
10002610:	4681                	li	a3,0
10002612:	00f65663          	bge	a2,a5,1000261e <omw_rf_cal+0x1be>
10002616:	41f55693          	srai	a3,a0,0x1f
1000261a:	0016e693          	ori	a3,a3,1
1000261e:	00d707b3          	add	a5,a4,a3
10002622:	20002737          	lui	a4,0x20002
10002626:	aef70b23          	sb	a5,-1290(a4) # 20001af6 <g_rf_cfg+0xa>
1000262a:	b73d                	j	10002558 <omw_rf_cal+0xf8>
1000262c:	0789                	addi	a5,a5,2
1000262e:	00b78b63          	beq	a5,a1,10002644 <omw_rf_cal+0x1e4>
10002632:	0007d683          	lhu	a3,0(a5)
10002636:	fed64be3          	blt	a2,a3,1000262c <omw_rf_cal+0x1cc>
1000263a:	177d                	addi	a4,a4,-1
1000263c:	0762                	slli	a4,a4,0x18
1000263e:	8761                	srai	a4,a4,0x18
10002640:	851a                	mv	a0,t1
10002642:	b7ed                	j	1000262c <omw_rf_cal+0x1cc>
10002644:	c509                	beqz	a0,1000264e <omw_rf_cal+0x1ee>
10002646:	200027b7          	lui	a5,0x20002
1000264a:	aee78aa3          	sb	a4,-1291(a5) # 20001af5 <g_rf_cfg+0x9>
1000264e:	d2dfe0ef          	jal	1000137a <omw_clkcal_rc24m_calibration>
10002652:	e4dfe0ef          	jal	1000149e <omw_clkcal_rc32k_calibration>
10002656:	40c2                	lw	ra,16(sp)
10002658:	4432                	lw	s0,12(sp)
1000265a:	44a2                	lw	s1,8(sp)
1000265c:	0151                	addi	sp,sp,20
1000265e:	8082                	ret

10002660 <start_adc_cap>:
10002660:	1161                	addi	sp,sp,-8
10002662:	400007b7          	lui	a5,0x40000
10002666:	4705                	li	a4,1
10002668:	16e7a223          	sw	a4,356(a5) # 40000164 <__StackTop+0x1fffc164>
1000266c:	420007b7          	lui	a5,0x42000
10002670:	1047a783          	lw	a5,260(a5) # 42000104 <__StackTop+0x21ffc104>
10002674:	c23e                	sw	a5,4(sp)
10002676:	42000637          	lui	a2,0x42000
1000267a:	46cd                	li	a3,19
1000267c:	10462783          	lw	a5,260(a2) # 42000104 <__StackTop+0x21ffc104>
10002680:	4712                	lw	a4,4(sp)
10002682:	8f99                	sub	a5,a5,a4
10002684:	fef6fce3          	bgeu	a3,a5,1000267c <start_adc_cap+0x1c>
10002688:	400007b7          	lui	a5,0x40000
1000268c:	470d                	li	a4,3
1000268e:	16e7a223          	sw	a4,356(a5) # 40000164 <__StackTop+0x1fffc164>
10002692:	420007b7          	lui	a5,0x42000
10002696:	1047a783          	lw	a5,260(a5) # 42000104 <__StackTop+0x21ffc104>
1000269a:	c03e                	sw	a5,0(sp)
1000269c:	42000637          	lui	a2,0x42000
100026a0:	46cd                	li	a3,19
100026a2:	10462783          	lw	a5,260(a2) # 42000104 <__StackTop+0x21ffc104>
100026a6:	4702                	lw	a4,0(sp)
100026a8:	8f99                	sub	a5,a5,a4
100026aa:	fef6fce3          	bgeu	a3,a5,100026a2 <start_adc_cap+0x42>
100026ae:	400007b7          	lui	a5,0x40000
100026b2:	4705                	li	a4,1
100026b4:	16e7a223          	sw	a4,356(a5) # 40000164 <__StackTop+0x1fffc164>
100026b8:	40000737          	lui	a4,0x40000
100026bc:	16872783          	lw	a5,360(a4) # 40000168 <__StackTop+0x1fffc168>
100026c0:	8b9d                	andi	a5,a5,7
100026c2:	ffed                	bnez	a5,100026bc <start_adc_cap+0x5c>
100026c4:	40000737          	lui	a4,0x40000
100026c8:	16072223          	sw	zero,356(a4) # 40000164 <__StackTop+0x1fffc164>
100026cc:	000907b7          	lui	a5,0x90
100026d0:	079d                	addi	a5,a5,7 # 90007 <__ROM_SIZE+0x50007>
100026d2:	16f72823          	sw	a5,368(a4)
100026d6:	0121                	addi	sp,sp,8
100026d8:	8082                	ret

100026da <get_dc_info_iq>:
100026da:	fcc10113          	addi	sp,sp,-52
100026de:	d806                	sw	ra,48(sp)
100026e0:	d622                	sw	s0,44(sp)
100026e2:	d426                	sw	s1,40(sp)
100026e4:	200007b7          	lui	a5,0x20000
100026e8:	0007a283          	lw	t0,0(a5) # 20000000 <__VECTOR_TABLE>
100026ec:	0047a303          	lw	t1,4(a5)
100026f0:	4788                	lw	a0,8(a5)
100026f2:	47cc                	lw	a1,12(a5)
100026f4:	4b90                	lw	a2,16(a5)
100026f6:	4bd4                	lw	a3,20(a5)
100026f8:	4f98                	lw	a4,24(a5)
100026fa:	4fdc                	lw	a5,28(a5)
100026fc:	c416                	sw	t0,8(sp)
100026fe:	c61a                	sw	t1,12(sp)
10002700:	c82a                	sw	a0,16(sp)
10002702:	ca2e                	sw	a1,20(sp)
10002704:	cc32                	sw	a2,24(sp)
10002706:	ce36                	sw	a3,28(sp)
10002708:	d03a                	sw	a4,32(sp)
1000270a:	d23e                	sw	a5,36(sp)
1000270c:	400007b7          	lui	a5,0x40000
10002710:	00110737          	lui	a4,0x110
10002714:	16e7a023          	sw	a4,352(a5) # 40000160 <__StackTop+0x1fffc160>
10002718:	01090737          	lui	a4,0x1090
1000271c:	071d                	addi	a4,a4,7 # 1090007 <__ROM_SIZE+0x1050007>
1000271e:	16e7a823          	sw	a4,368(a5)
10002722:	53d8                	lw	a4,36(a5)
10002724:	6689                	lui	a3,0x2
10002726:	8f55                	or	a4,a4,a3
10002728:	d3d8                	sw	a4,36(a5)
1000272a:	47a1                	li	a5,8
1000272c:	c23e                	sw	a5,4(sp)
1000272e:	4401                	li	s0,0
10002730:	4481                	li	s1,0
10002732:	200007b7          	lui	a5,0x20000
10002736:	02078793          	addi	a5,a5,32 # 20000020 <__VECTOR_TABLE+0x20>
1000273a:	c03e                	sw	a5,0(sp)
1000273c:	a82d                	j	10002776 <get_dc_info_iq+0x9c>
1000273e:	943a                	add	s0,s0,a4
10002740:	0691                	addi	a3,a3,4 # 2004 <main.c.479021b4+0xf5c>
10002742:	4782                	lw	a5,0(sp)
10002744:	02f68563          	beq	a3,a5,1000276e <get_dc_info_iq+0x94>
10002748:	429c                	lw	a5,0(a3)
1000274a:	00a7d713          	srli	a4,a5,0xa
1000274e:	3ff77613          	andi	a2,a4,1023
10002752:	20077713          	andi	a4,a4,512
10002756:	c319                	beqz	a4,1000275c <get_dc_info_iq+0x82>
10002758:	c0060613          	addi	a2,a2,-1024
1000275c:	94b2                	add	s1,s1,a2
1000275e:	3ff7f713          	andi	a4,a5,1023
10002762:	2007f793          	andi	a5,a5,512
10002766:	dfe1                	beqz	a5,1000273e <get_dc_info_iq+0x64>
10002768:	c0070713          	addi	a4,a4,-1024
1000276c:	bfc9                	j	1000273e <get_dc_info_iq+0x64>
1000276e:	4792                	lw	a5,4(sp)
10002770:	17fd                	addi	a5,a5,-1
10002772:	c23e                	sw	a5,4(sp)
10002774:	c789                	beqz	a5,1000277e <get_dc_info_iq+0xa4>
10002776:	35ed                	jal	10002660 <start_adc_cap>
10002778:	200006b7          	lui	a3,0x20000
1000277c:	b7f1                	j	10002748 <get_dc_info_iq+0x6e>
1000277e:	200007b7          	lui	a5,0x20000
10002782:	42b2                	lw	t0,12(sp)
10002784:	4342                	lw	t1,16(sp)
10002786:	4552                	lw	a0,20(sp)
10002788:	45e2                	lw	a1,24(sp)
1000278a:	4672                	lw	a2,28(sp)
1000278c:	5682                	lw	a3,32(sp)
1000278e:	5712                	lw	a4,36(sp)
10002790:	43a2                	lw	t2,8(sp)
10002792:	0077a023          	sw	t2,0(a5) # 20000000 <__VECTOR_TABLE>
10002796:	0057a223          	sw	t0,4(a5)
1000279a:	0067a423          	sw	t1,8(a5)
1000279e:	c7c8                	sw	a0,12(a5)
100027a0:	cb8c                	sw	a1,16(a5)
100027a2:	cbd0                	sw	a2,20(a5)
100027a4:	cf94                	sw	a3,24(a5)
100027a6:	cfd8                	sw	a4,28(a5)
100027a8:	41f4d513          	srai	a0,s1,0x1f
100027ac:	03f57513          	andi	a0,a0,63
100027b0:	9526                	add	a0,a0,s1
100027b2:	8519                	srai	a0,a0,0x6
100027b4:	0542                	slli	a0,a0,0x10
100027b6:	41f45793          	srai	a5,s0,0x1f
100027ba:	03f7f793          	andi	a5,a5,63
100027be:	97a2                	add	a5,a5,s0
100027c0:	8799                	srai	a5,a5,0x6
100027c2:	07c2                	slli	a5,a5,0x10
100027c4:	83c1                	srli	a5,a5,0x10
100027c6:	8d5d                	or	a0,a0,a5
100027c8:	50c2                	lw	ra,48(sp)
100027ca:	5432                	lw	s0,44(sp)
100027cc:	54a2                	lw	s1,40(sp)
100027ce:	03410113          	addi	sp,sp,52
100027d2:	8082                	ret

100027d4 <rf_dcoc_calib_iq_bq>:
100027d4:	1101                	addi	sp,sp,-32
100027d6:	ce06                	sw	ra,28(sp)
100027d8:	cc22                	sw	s0,24(sp)
100027da:	ca26                	sw	s1,20(sp)
100027dc:	10801737          	lui	a4,0x10801
100027e0:	81070713          	addi	a4,a4,-2032 # 10800810 <__etext+0x7fd168>
100027e4:	8f09                	sub	a4,a4,a0
100027e6:	00271793          	slli	a5,a4,0x2
100027ea:	c83e                	sw	a5,16(sp)
100027ec:	47a1                	li	a5,8
100027ee:	8f89                	sub	a5,a5,a0
100027f0:	0792                	slli	a5,a5,0x4
100027f2:	42001737          	lui	a4,0x42001
100027f6:	10f72223          	sw	a5,260(a4) # 42001104 <__StackTop+0x21ffd104>
100027fa:	35c5                	jal	100026da <get_dc_info_iq>
100027fc:	41055493          	srai	s1,a0,0x10
10002800:	01051413          	slli	s0,a0,0x10
10002804:	8441                	srai	s0,s0,0x10
10002806:	0c000793          	li	a5,192
1000280a:	c23e                	sw	a5,4(sp)
1000280c:	fc000793          	li	a5,-64
10002810:	c03e                	sw	a5,0(sp)
10002812:	02905163          	blez	s1,10002834 <rf_dcoc_calib_iq_bq+0x60>
10002816:	0c000793          	li	a5,192
1000281a:	c63e                	sw	a5,12(sp)
1000281c:	fc000793          	li	a5,-64
10002820:	c43e                	sw	a5,8(sp)
10002822:	00805e63          	blez	s0,1000283e <rf_dcoc_calib_iq_bq+0x6a>
10002826:	04d1                	addi	s1,s1,20
10002828:	0294b493          	sltiu	s1,s1,41
1000282c:	0451                	addi	s0,s0,20
1000282e:	02943413          	sltiu	s0,s0,41
10002832:	a0b1                	j	1000287e <rf_dcoc_calib_iq_bq+0xaa>
10002834:	04000793          	li	a5,64
10002838:	c23e                	sw	a5,4(sp)
1000283a:	c03e                	sw	a5,0(sp)
1000283c:	bfe9                	j	10002816 <rf_dcoc_calib_iq_bq+0x42>
1000283e:	04000793          	li	a5,64
10002842:	c63e                	sw	a5,12(sp)
10002844:	c43e                	sw	a5,8(sp)
10002846:	b7c5                	j	10002826 <rf_dcoc_calib_iq_bq+0x52>
10002848:	46c2                	lw	a3,16(sp)
1000284a:	429c                	lw	a5,0(a3)
1000284c:	fff01737          	lui	a4,0xfff01
10002850:	177d                	addi	a4,a4,-1 # fff00fff <__StackTop+0xdfefcfff>
10002852:	8f7d                	and	a4,a4,a5
10002854:	4792                	lw	a5,4(sp)
10002856:	07b2                	slli	a5,a5,0xc
10002858:	8fd9                	or	a5,a5,a4
1000285a:	c29c                	sw	a5,0(a3)
1000285c:	ec0d                	bnez	s0,10002896 <rf_dcoc_calib_iq_bq+0xc2>
1000285e:	a01d                	j	10002884 <rf_dcoc_calib_iq_bq+0xb0>
10002860:	4592                	lw	a1,4(sp)
10002862:	95b6                	add	a1,a1,a3
10002864:	c22e                	sw	a1,4(sp)
10002866:	c036                	sw	a3,0(sp)
10002868:	a8b9                	j	100028c6 <rf_dcoc_calib_iq_bq+0xf2>
1000286a:	46b2                	lw	a3,12(sp)
1000286c:	96b2                	add	a3,a3,a2
1000286e:	c636                	sw	a3,12(sp)
10002870:	c432                	sw	a2,8(sp)
10002872:	0751                	addi	a4,a4,20
10002874:	02973493          	sltiu	s1,a4,41
10002878:	07d1                	addi	a5,a5,20
1000287a:	0297b413          	sltiu	s0,a5,41
1000287e:	d4e9                	beqz	s1,10002848 <rf_dcoc_calib_iq_bq+0x74>
10002880:	04041b63          	bnez	s0,100028d6 <rf_dcoc_calib_iq_bq+0x102>
10002884:	46c2                	lw	a3,16(sp)
10002886:	429c                	lw	a5,0(a3)
10002888:	777d                	lui	a4,0xfffff
1000288a:	073d                	addi	a4,a4,15 # fffff00f <__StackTop+0xdfffb00f>
1000288c:	8f7d                	and	a4,a4,a5
1000288e:	47b2                	lw	a5,12(sp)
10002890:	0792                	slli	a5,a5,0x4
10002892:	8fd9                	or	a5,a5,a4
10002894:	c29c                	sw	a5,0(a3)
10002896:	3591                	jal	100026da <get_dc_info_iq>
10002898:	41055713          	srai	a4,a0,0x10
1000289c:	01051793          	slli	a5,a0,0x10
100028a0:	87c1                	srai	a5,a5,0x10
100028a2:	4602                	lw	a2,0(sp)
100028a4:	40165693          	srai	a3,a2,0x1
100028a8:	02c68763          	beq	a3,a2,100028d6 <rf_dcoc_calib_iq_bq+0x102>
100028ac:	45a2                	lw	a1,8(sp)
100028ae:	4015d613          	srai	a2,a1,0x1
100028b2:	02b60263          	beq	a2,a1,100028d6 <rf_dcoc_calib_iq_bq+0x102>
100028b6:	00049863          	bnez	s1,100028c6 <rf_dcoc_calib_iq_bq+0xf2>
100028ba:	fa0743e3          	bltz	a4,10002860 <rf_dcoc_calib_iq_bq+0x8c>
100028be:	4592                	lw	a1,4(sp)
100028c0:	8d95                	sub	a1,a1,a3
100028c2:	c22e                	sw	a1,4(sp)
100028c4:	c036                	sw	a3,0(sp)
100028c6:	f455                	bnez	s0,10002872 <rf_dcoc_calib_iq_bq+0x9e>
100028c8:	fa07c1e3          	bltz	a5,1000286a <rf_dcoc_calib_iq_bq+0x96>
100028cc:	46b2                	lw	a3,12(sp)
100028ce:	8e91                	sub	a3,a3,a2
100028d0:	c636                	sw	a3,12(sp)
100028d2:	c432                	sw	a2,8(sp)
100028d4:	bf79                	j	10002872 <rf_dcoc_calib_iq_bq+0x9e>
100028d6:	40f2                	lw	ra,28(sp)
100028d8:	4462                	lw	s0,24(sp)
100028da:	44d2                	lw	s1,20(sp)
100028dc:	6105                	addi	sp,sp,32
100028de:	8082                	ret

100028e0 <omw_rf_dcoc_cal>:
100028e0:	1151                	addi	sp,sp,-12
100028e2:	c406                	sw	ra,8(sp)
100028e4:	c222                	sw	s0,4(sp)
100028e6:	c026                	sw	s1,0(sp)
100028e8:	20000737          	lui	a4,0x20000
100028ec:	8660b7b7          	lui	a5,0x8660b
100028f0:	53878793          	addi	a5,a5,1336 # 8660b538 <__StackTop+0x66607538>
100028f4:	3af72823          	sw	a5,944(a4) # 200003b0 <rf_common_desc_rx_setfreq>
100028f8:	20000537          	lui	a0,0x20000
100028fc:	54450513          	addi	a0,a0,1348 # 20000544 <rf_desc_dcoc_calib_rx_on>
10002900:	0fffe097          	auipc	ra,0xfffe
10002904:	5da080e7          	jalr	1498(ra) # 20000eda <start_await_dma>
10002908:	200027b7          	lui	a5,0x20002
1000290c:	4709                	li	a4,2
1000290e:	aee78c23          	sb	a4,-1288(a5) # 20001af8 <g_rf_cfg+0xc>
10002912:	42002737          	lui	a4,0x42002
10002916:	0c472783          	lw	a5,196(a4) # 420020c4 <__StackTop+0x21ffe0c4>
1000291a:	f40006b7          	lui	a3,0xf4000
1000291e:	16fd                	addi	a3,a3,-1 # f3ffffff <__StackTop+0xd3ffbfff>
10002920:	8ff5                	and	a5,a5,a3
10002922:	080006b7          	lui	a3,0x8000
10002926:	8fd5                	or	a5,a5,a3
10002928:	0cf72223          	sw	a5,196(a4)
1000292c:	420016b7          	lui	a3,0x42001
10002930:	1006a783          	lw	a5,256(a3) # 42001100 <__StackTop+0x21ffd100>
10002934:	0017e793          	ori	a5,a5,1
10002938:	10f6a023          	sw	a5,256(a3)
1000293c:	0c072783          	lw	a5,192(a4)
10002940:	9bbd                	andi	a5,a5,-17
10002942:	0cf72023          	sw	a5,192(a4)
10002946:	4401                	li	s0,0
10002948:	44a5                	li	s1,9
1000294a:	0ff47513          	zext.b	a0,s0
1000294e:	3559                	jal	100027d4 <rf_dcoc_calib_iq_bq>
10002950:	0405                	addi	s0,s0,1
10002952:	fe941ce3          	bne	s0,s1,1000294a <omw_rf_dcoc_cal+0x6a>
10002956:	200026b7          	lui	a3,0x20002
1000295a:	aec68693          	addi	a3,a3,-1300 # 20001aec <g_rf_cfg>
1000295e:	420027b7          	lui	a5,0x42002
10002962:	02078793          	addi	a5,a5,32 # 42002020 <__StackTop+0x21ffe020>
10002966:	42002637          	lui	a2,0x42002
1000296a:	04460613          	addi	a2,a2,68 # 42002044 <__StackTop+0x21ffe044>
1000296e:	4398                	lw	a4,0(a5)
10002970:	8311                	srli	a4,a4,0x4
10002972:	00e69723          	sh	a4,14(a3)
10002976:	0791                	addi	a5,a5,4
10002978:	0689                	addi	a3,a3,2
1000297a:	fec79ae3          	bne	a5,a2,1000296e <omw_rf_dcoc_cal+0x8e>
1000297e:	42002737          	lui	a4,0x42002
10002982:	0c072783          	lw	a5,192(a4) # 420020c0 <__StackTop+0x21ffe0c0>
10002986:	0107e793          	ori	a5,a5,16
1000298a:	0cf72023          	sw	a5,192(a4)
1000298e:	42001737          	lui	a4,0x42001
10002992:	10072783          	lw	a5,256(a4) # 42001100 <__StackTop+0x21ffd100>
10002996:	9bf9                	andi	a5,a5,-2
10002998:	10f72023          	sw	a5,256(a4)
1000299c:	20000537          	lui	a0,0x20000
100029a0:	52c50513          	addi	a0,a0,1324 # 2000052c <rf_desc_dcoc_calib_rx_off>
100029a4:	0fffe097          	auipc	ra,0xfffe
100029a8:	536080e7          	jalr	1334(ra) # 20000eda <start_await_dma>
100029ac:	40a2                	lw	ra,8(sp)
100029ae:	4412                	lw	s0,4(sp)
100029b0:	4482                	lw	s1,0(sp)
100029b2:	0131                	addi	sp,sp,12
100029b4:	8082                	ret

100029b6 <adv_channel_idx_to_channel_num>:
100029b6:	02500793          	li	a5,37
100029ba:	c905                	beqz	a0,100029ea <adv_channel_idx_to_channel_num+0x34>
100029bc:	fff50793          	addi	a5,a0,-1
100029c0:	0ff7f793          	zext.b	a5,a5
100029c4:	4729                	li	a4,10
100029c6:	02f77263          	bgeu	a4,a5,100029ea <adv_channel_idx_to_channel_num+0x34>
100029ca:	47b1                	li	a5,12
100029cc:	02f50763          	beq	a0,a5,100029fa <adv_channel_idx_to_channel_num+0x44>
100029d0:	ff350793          	addi	a5,a0,-13
100029d4:	0ff7f793          	zext.b	a5,a5
100029d8:	4765                	li	a4,25
100029da:	00f77a63          	bgeu	a4,a5,100029ee <adv_channel_idx_to_channel_num+0x38>
100029de:	02700713          	li	a4,39
100029e2:	02500793          	li	a5,37
100029e6:	00e50863          	beq	a0,a4,100029f6 <adv_channel_idx_to_channel_num+0x40>
100029ea:	853e                	mv	a0,a5
100029ec:	8082                	ret
100029ee:	1579                	addi	a0,a0,-2
100029f0:	0ff57793          	zext.b	a5,a0
100029f4:	bfdd                	j	100029ea <adv_channel_idx_to_channel_num+0x34>
100029f6:	87aa                	mv	a5,a0
100029f8:	bfcd                	j	100029ea <adv_channel_idx_to_channel_num+0x34>
100029fa:	02600793          	li	a5,38
100029fe:	b7f5                	j	100029ea <adv_channel_idx_to_channel_num+0x34>

10002a00 <rf_2g4_tx_data>:
10002a00:	1131                	addi	sp,sp,-20
10002a02:	c806                	sw	ra,16(sp)
10002a04:	c622                	sw	s0,12(sp)
10002a06:	c426                	sw	s1,8(sp)
10002a08:	c02a                	sw	a0,0(sp)
10002a0a:	c22e                	sw	a1,4(sp)
10002a0c:	8432                	mv	s0,a2
10002a0e:	200027b7          	lui	a5,0x20002
10002a12:	b187c783          	lbu	a5,-1256(a5) # 20001b18 <current_tx_rx_switch_flag>
10002a16:	0ff7f793          	zext.b	a5,a5
10002a1a:	c7d9                	beqz	a5,10002aa8 <rf_2g4_tx_data+0xa8>
10002a1c:	200027b7          	lui	a5,0x20002
10002a20:	4485                	li	s1,1
10002a22:	b0978c23          	sb	s1,-1256(a5) # 20001b18 <current_tx_rx_switch_flag>
10002a26:	200027b7          	lui	a5,0x20002
10002a2a:	b4078823          	sb	zero,-1200(a5) # 20001b50 <rx_restart_flag>
10002a2e:	86a2                	mv	a3,s0
10002a30:	0ff47793          	zext.b	a5,s0
10002a34:	0786                	slli	a5,a5,0x1
10002a36:	02678793          	addi	a5,a5,38
10002a3a:	20000737          	lui	a4,0x20000
10002a3e:	5d670413          	addi	s0,a4,1494 # 200005d6 <adv_channel_idx>
10002a42:	00f41023          	sh	a5,0(s0)
10002a46:	0ff6f513          	zext.b	a0,a3
10002a4a:	37b5                	jal	100029b6 <adv_channel_idx_to_channel_num>
10002a4c:	200007b7          	lui	a5,0x20000
10002a50:	5da78793          	addi	a5,a5,1498 # 200005da <whiten_chl>
10002a54:	00a78023          	sb	a0,0(a5)
10002a58:	20002737          	lui	a4,0x20002
10002a5c:	b49708a3          	sb	s1,-1199(a4) # 20001b51 <tx_restart_flag>
10002a60:	4502                	lw	a0,0(sp)
10002a62:	00054683          	lbu	a3,0(a0)
10002a66:	20002737          	lui	a4,0x20002
10002a6a:	9cd70b23          	sb	a3,-1578(a4) # 200019d6 <rf_2g4_mgr+0x1e>
10002a6e:	00045603          	lhu	a2,0(s0)
10002a72:	0007c683          	lbu	a3,0(a5)
10002a76:	4792                	lw	a5,4(sp)
10002a78:	ffe78593          	addi	a1,a5,-2
10002a7c:	0ff6f693          	zext.b	a3,a3
10002a80:	0642                	slli	a2,a2,0x10
10002a82:	8241                	srli	a2,a2,0x10
10002a84:	05c2                	slli	a1,a1,0x10
10002a86:	81c1                	srli	a1,a1,0x10
10002a88:	0509                	addi	a0,a0,2
10002a8a:	0fffe097          	auipc	ra,0xfffe
10002a8e:	fe8080e7          	jalr	-24(ra) # 20000a72 <omw_svc_2g4_tx_data>
10002a92:	1f400513          	li	a0,500
10002a96:	0fffe097          	auipc	ra,0xfffe
10002a9a:	bf0080e7          	jalr	-1040(ra) # 20000686 <delay_us>
10002a9e:	40c2                	lw	ra,16(sp)
10002aa0:	4432                	lw	s0,12(sp)
10002aa2:	44a2                	lw	s1,8(sp)
10002aa4:	0151                	addi	sp,sp,20
10002aa6:	8082                	ret
10002aa8:	0fffe097          	auipc	ra,0xfffe
10002aac:	0b4080e7          	jalr	180(ra) # 20000b5c <omw_svc_2g4_set_idle>
10002ab0:	b7b5                	j	10002a1c <rf_2g4_tx_data+0x1c>

10002ab2 <rf_2g4_rx_handler>:
10002ab2:	8082                	ret

10002ab4 <rf_2g4_set_tx_power>:
10002ab4:	01950713          	addi	a4,a0,25
10002ab8:	02500793          	li	a5,37
10002abc:	00e7f363          	bgeu	a5,a4,10002ac2 <rf_2g4_set_tx_power+0xe>
10002ac0:	8082                	ret
10002ac2:	1151                	addi	sp,sp,-12
10002ac4:	c406                	sw	ra,8(sp)
10002ac6:	c222                	sw	s0,4(sp)
10002ac8:	842a                	mv	s0,a0
10002aca:	adeff0ef          	jal	10001da8 <omw_rf_set_tx_pwr_lvl>
10002ace:	200027b7          	lui	a5,0x20002
10002ad2:	b487a623          	sw	s0,-1204(a5) # 20001b4c <rf_current_power>
10002ad6:	40a2                	lw	ra,8(sp)
10002ad8:	4412                	lw	s0,4(sp)
10002ada:	0131                	addi	sp,sp,12
10002adc:	8082                	ret

10002ade <rf_set_rx_timeout_val>:
10002ade:	1151                	addi	sp,sp,-12
10002ae0:	c406                	sw	ra,8(sp)
10002ae2:	0fffe097          	auipc	ra,0xfffe
10002ae6:	c02080e7          	jalr	-1022(ra) # 200006e4 <omw_svc_2g4_update_rx_to>
10002aea:	40a2                	lw	ra,8(sp)
10002aec:	0131                	addi	sp,sp,12
10002aee:	8082                	ret

10002af0 <rf_2g4_init>:
10002af0:	fa810113          	addi	sp,sp,-88
10002af4:	ca86                	sw	ra,84(sp)
10002af6:	c8a2                	sw	s0,80(sp)
10002af8:	30047073          	csrci	mstatus,8
10002afc:	9d6ff0ef          	jal	10001cd2 <omw_rf_init>
10002b00:	20002737          	lui	a4,0x20002
10002b04:	200027b7          	lui	a5,0x20002
10002b08:	b2478793          	addi	a5,a5,-1244 # 20001b24 <rf_2g4_rx_data_buf>
10002b0c:	9af72a23          	sw	a5,-1612(a4) # 200019b4 <rf_2g4_fifo>
10002b10:	20002437          	lui	s0,0x20002
10002b14:	9b840413          	addi	s0,s0,-1608 # 200019b8 <rf_2g4_mgr>
10002b18:	200027b7          	lui	a5,0x20002
10002b1c:	b287a023          	sw	s0,-1248(a5) # 20001b20 <rf_2g4_para>
10002b20:	04a00613          	li	a2,74
10002b24:	4581                	li	a1,0
10002b26:	850a                	mv	a0,sp
10002b28:	2e15                	jal	10002e5c <memset>
10002b2a:	03c00793          	li	a5,60
10002b2e:	00f11023          	sh	a5,0(sp)
10002b32:	4785                	li	a5,1
10002b34:	00f101a3          	sb	a5,3(sp)
10002b38:	8e89c737          	lui	a4,0x8e89c
10002b3c:	ed670713          	addi	a4,a4,-298 # 8e89bed6 <__StackTop+0x6e897ed6>
10002b40:	c23a                	sw	a4,4(sp)
10002b42:	4711                	li	a4,4
10002b44:	00e10623          	sb	a4,12(sp)
10002b48:	02000713          	li	a4,32
10002b4c:	00e106a3          	sb	a4,13(sp)
10002b50:	04e00713          	li	a4,78
10002b54:	00e10723          	sb	a4,14(sp)
10002b58:	00f107a3          	sb	a5,15(sp)
10002b5c:	02500713          	li	a4,37
10002b60:	00e10823          	sb	a4,16(sp)
10002b64:	00f10923          	sb	a5,18(sp)
10002b68:	478d                	li	a5,3
10002b6a:	00f109a3          	sb	a5,19(sp)
10002b6e:	005557b7          	lui	a5,0x555
10002b72:	55578793          	addi	a5,a5,1365 # 555555 <__ROM_SIZE+0x515555>
10002b76:	ca3e                	sw	a5,20(sp)
10002b78:	010007b7          	lui	a5,0x1000
10002b7c:	65b78793          	addi	a5,a5,1627 # 100065b <__ROM_SIZE+0xfc065b>
10002b80:	cc3e                	sw	a5,24(sp)
10002b82:	47a1                	li	a5,8
10002b84:	00f10e23          	sb	a5,28(sp)
10002b88:	00f10ea3          	sb	a5,29(sp)
10002b8c:	04200793          	li	a5,66
10002b90:	00f10f23          	sb	a5,30(sp)
10002b94:	02700793          	li	a5,39
10002b98:	02f102a3          	sb	a5,37(sp)
10002b9c:	850a                	mv	a0,sp
10002b9e:	8fcff0ef          	jal	10001c9a <omw_svc_2g4_init>
10002ba2:	4501                	li	a0,0
10002ba4:	a04ff0ef          	jal	10001da8 <omw_rf_set_tx_pwr_lvl>
10002ba8:	e35fe0ef          	jal	100019dc <RF_2G4_PrepareStart>
10002bac:	bebfe0ef          	jal	10001796 <RF_2G4_UpdateDesc_TxPkt>
10002bb0:	f79fe0ef          	jal	10001b28 <RF_2G4_UpdateDesc_RxPkt>
10002bb4:	400807b7          	lui	a5,0x40080
10002bb8:	07a00713          	li	a4,122
10002bbc:	c398                	sw	a4,0(a5)
10002bbe:	4505                	li	a0,1
10002bc0:	0fffe097          	auipc	ra,0xfffe
10002bc4:	f76080e7          	jalr	-138(ra) # 20000b36 <omw_svc_2g4_en_whiten_rx>
10002bc8:	4505                	li	a0,1
10002bca:	0fffe097          	auipc	ra,0xfffe
10002bce:	f46080e7          	jalr	-186(ra) # 20000b10 <omw_svc_2g4_en_whiten_tx>
10002bd2:	30046073          	csrsi	mstatus,8
10002bd6:	02040fa3          	sb	zero,63(s0)
10002bda:	200027b7          	lui	a5,0x20002
10002bde:	b0078c23          	sb	zero,-1256(a5) # 20001b18 <current_tx_rx_switch_flag>
10002be2:	200027b7          	lui	a5,0x20002
10002be6:	b4078823          	sb	zero,-1200(a5) # 20001b50 <rx_restart_flag>
10002bea:	200027b7          	lui	a5,0x20002
10002bee:	b40788a3          	sb	zero,-1199(a5) # 20001b51 <tx_restart_flag>
10002bf2:	200027b7          	lui	a5,0x20002
10002bf6:	b4078923          	sb	zero,-1198(a5) # 20001b52 <tx_rx_cfg_mode>
10002bfa:	40d6                	lw	ra,84(sp)
10002bfc:	4446                	lw	s0,80(sp)
10002bfe:	05810113          	addi	sp,sp,88
10002c02:	8082                	ret

10002c04 <t1001_sleep_restore_uart_reg_info>:
10002c04:	200006b7          	lui	a3,0x20000
10002c08:	5e068693          	addi	a3,a3,1504 # 200005e0 <uart_addr_idx_list>
10002c0c:	4701                	li	a4,0
10002c0e:	4615                	li	a2,5
10002c10:	431d                	li	t1,7
10002c12:	42a1                	li	t0,8
10002c14:	a835                	j	10002c50 <t1001_sleep_restore_uart_reg_info+0x4c>
10002c16:	5d7c                	lw	a5,124(a0)
10002c18:	8b85                	andi	a5,a5,1
10002c1a:	c791                	beqz	a5,10002c26 <t1001_sleep_restore_uart_reg_info+0x22>
10002c1c:	5d7c                	lw	a5,124(a0)
10002c1e:	8b85                	andi	a5,a5,1
10002c20:	dbfd                	beqz	a5,10002c16 <t1001_sleep_restore_uart_reg_info+0x12>
10002c22:	5d7c                	lw	a5,124(a0)
10002c24:	bfcd                	j	10002c16 <t1001_sleep_restore_uart_reg_info+0x12>
10002c26:	455c                	lw	a5,12(a0)
10002c28:	0807e793          	ori	a5,a5,128
10002c2c:	c55c                	sw	a5,12(a0)
10002c2e:	0006c783          	lbu	a5,0(a3)
10002c32:	078a                	slli	a5,a5,0x2
10002c34:	97aa                	add	a5,a5,a0
10002c36:	0005a383          	lw	t2,0(a1)
10002c3a:	0077a023          	sw	t2,0(a5)
10002c3e:	0705                	addi	a4,a4,1
10002c40:	0685                	addi	a3,a3,1
10002c42:	0591                	addi	a1,a1,4
10002c44:	a031                	j	10002c50 <t1001_sleep_restore_uart_reg_info+0x4c>
10002c46:	0705                	addi	a4,a4,1
10002c48:	0685                	addi	a3,a3,1
10002c4a:	0591                	addi	a1,a1,4
10002c4c:	02570363          	beq	a4,t0,10002c72 <t1001_sleep_restore_uart_reg_info+0x6e>
10002c50:	fcc703e3          	beq	a4,a2,10002c16 <t1001_sleep_restore_uart_reg_info+0x12>
10002c54:	0006c783          	lbu	a5,0(a3)
10002c58:	078a                	slli	a5,a5,0x2
10002c5a:	97aa                	add	a5,a5,a0
10002c5c:	0005a383          	lw	t2,0(a1)
10002c60:	0077a023          	sw	t2,0(a5)
10002c64:	fe6711e3          	bne	a4,t1,10002c46 <t1001_sleep_restore_uart_reg_info+0x42>
10002c68:	455c                	lw	a5,12(a0)
10002c6a:	f7f7f793          	andi	a5,a5,-129
10002c6e:	c55c                	sw	a5,12(a0)
10002c70:	8082                	ret
10002c72:	8082                	ret

10002c74 <enter_sleep_mode>:
10002c74:	f9410113          	addi	sp,sp,-108
10002c78:	d486                	sw	ra,104(sp)
10002c7a:	d2a2                	sw	s0,100(sp)
10002c7c:	d0a6                	sw	s1,96(sp)
10002c7e:	200027b7          	lui	a5,0x20002
10002c82:	4705                	li	a4,1
10002c84:	b0e78823          	sb	a4,-1264(a5) # 20001b10 <has_flash>
10002c88:	200007b7          	lui	a5,0x20000
10002c8c:	4729                	li	a4,10
10002c8e:	5ce78a23          	sb	a4,1492(a5) # 200005d4 <gpio_vdd_pin1>
10002c92:	200007b7          	lui	a5,0x20000
10002c96:	577d                	li	a4,-1
10002c98:	5ce78aa3          	sb	a4,1493(a5) # 200005d5 <gpio_vdd_pin2>
10002c9c:	200027b7          	lui	a5,0x20002
10002ca0:	b00788a3          	sb	zero,-1263(a5) # 20001b11 <has_otp>
10002ca4:	20002737          	lui	a4,0x20002
10002ca8:	200026b7          	lui	a3,0x20002
10002cac:	a819                	j	10002cc2 <enter_sleep_mode+0x4e>
10002cae:	b5174783          	lbu	a5,-1199(a4) # 20001b51 <tx_restart_flag>
10002cb2:	0ff7f793          	zext.b	a5,a5
10002cb6:	e38d                	bnez	a5,10002cd8 <enter_sleep_mode+0x64>
10002cb8:	b506c783          	lbu	a5,-1200(a3) # 20001b50 <rx_restart_flag>
10002cbc:	0ff7f793          	zext.b	a5,a5
10002cc0:	e3c9                	bnez	a5,10002d42 <enter_sleep_mode+0xce>
10002cc2:	b5174783          	lbu	a5,-1199(a4)
10002cc6:	0ff7f793          	zext.b	a5,a5
10002cca:	f3f5                	bnez	a5,10002cae <enter_sleep_mode+0x3a>
10002ccc:	b506c783          	lbu	a5,-1200(a3)
10002cd0:	0ff7f793          	zext.b	a5,a5
10002cd4:	ffe9                	bnez	a5,10002cae <enter_sleep_mode+0x3a>
10002cd6:	a039                	j	10002ce4 <enter_sleep_mode+0x70>
10002cd8:	19000513          	li	a0,400
10002cdc:	0fffe097          	auipc	ra,0xfffe
10002ce0:	9aa080e7          	jalr	-1622(ra) # 20000686 <delay_us>
10002ce4:	0fffe097          	auipc	ra,0xfffe
10002ce8:	e78080e7          	jalr	-392(ra) # 20000b5c <omw_svc_2g4_set_idle>
10002cec:	30047073          	csrci	mstatus,8
10002cf0:	1018                	addi	a4,sp,32
10002cf2:	200027b7          	lui	a5,0x20002
10002cf6:	b4e7aa23          	sw	a4,-1196(a5) # 20001b54 <g_save_buf>
10002cfa:	200027b7          	lui	a5,0x20002
10002cfe:	000336b7          	lui	a3,0x33
10002d02:	b6d7a023          	sw	a3,-1184(a5) # 20001b60 <unused_gpio_mask_when_sleep>
10002d06:	200027b7          	lui	a5,0x20002
10002d0a:	b427ae23          	sw	sp,-1188(a5) # 20001b5c <uart0_save_buf>
10002d0e:	100037b7          	lui	a5,0x10003
10002d12:	65478413          	addi	s0,a5,1620 # 10003654 <addr_list>
10002d16:	04040493          	addi	s1,s0,64
10002d1a:	65478793          	addi	a5,a5,1620
10002d1e:	4394                	lw	a3,0(a5)
10002d20:	4294                	lw	a3,0(a3)
10002d22:	c314                	sw	a3,0(a4)
10002d24:	0791                	addi	a5,a5,4
10002d26:	0711                	addi	a4,a4,4
10002d28:	fe979be3          	bne	a5,s1,10002d1e <enter_sleep_mode+0xaa>
10002d2c:	20000637          	lui	a2,0x20000
10002d30:	5e060613          	addi	a2,a2,1504 # 200005e0 <uart_addr_idx_list>
10002d34:	858a                	mv	a1,sp
10002d36:	4685                	li	a3,1
10002d38:	4519                	li	a0,6
10002d3a:	41001737          	lui	a4,0x41001
10002d3e:	431d                	li	t1,7
10002d40:	a081                	j	10002d80 <enter_sleep_mode+0x10c>
10002d42:	0c800513          	li	a0,200
10002d46:	3b61                	jal	10002ade <rf_set_rx_timeout_val>
10002d48:	19000513          	li	a0,400
10002d4c:	0fffe097          	auipc	ra,0xfffe
10002d50:	93a080e7          	jalr	-1734(ra) # 20000686 <delay_us>
10002d54:	bf41                	j	10002ce4 <enter_sleep_mode+0x70>
10002d56:	5f7c                	lw	a5,124(a4)
10002d58:	8b85                	andi	a5,a5,1
10002d5a:	c791                	beqz	a5,10002d66 <enter_sleep_mode+0xf2>
10002d5c:	5f7c                	lw	a5,124(a4)
10002d5e:	8b85                	andi	a5,a5,1
10002d60:	dbfd                	beqz	a5,10002d56 <enter_sleep_mode+0xe2>
10002d62:	5f7c                	lw	a5,124(a4)
10002d64:	bfcd                	j	10002d56 <enter_sleep_mode+0xe2>
10002d66:	475c                	lw	a5,12(a4)
10002d68:	0807e793          	ori	a5,a5,128
10002d6c:	c75c                	sw	a5,12(a4)
10002d6e:	00064783          	lbu	a5,0(a2)
10002d72:	078a                	slli	a5,a5,0x2
10002d74:	97ba                	add	a5,a5,a4
10002d76:	439c                	lw	a5,0(a5)
10002d78:	c19c                	sw	a5,0(a1)
10002d7a:	0685                	addi	a3,a3,1 # 33001 <ble_viot.c.543f92a8+0x2a978>
10002d7c:	0605                	addi	a2,a2,1
10002d7e:	0591                	addi	a1,a1,4
10002d80:	fca68be3          	beq	a3,a0,10002d56 <enter_sleep_mode+0xe2>
10002d84:	00064783          	lbu	a5,0(a2)
10002d88:	078a                	slli	a5,a5,0x2
10002d8a:	97ba                	add	a5,a5,a4
10002d8c:	439c                	lw	a5,0(a5)
10002d8e:	c19c                	sw	a5,0(a1)
10002d90:	fed375e3          	bgeu	t1,a3,10002d7a <enter_sleep_mode+0x106>
10002d94:	400807b7          	lui	a5,0x40080
10002d98:	3ff00713          	li	a4,1023
10002d9c:	08e79223          	sh	a4,132(a5) # 40080084 <__StackTop+0x2007c084>
10002da0:	01000737          	lui	a4,0x1000
10002da4:	cf98                	sw	a4,24(a5)
10002da6:	0fffe097          	auipc	ra,0xfffe
10002daa:	71a080e7          	jalr	1818(ra) # 200014c0 <T1001_ChipSleepCriticalWork>
10002dae:	30047073          	csrci	mstatus,8
10002db2:	200027b7          	lui	a5,0x20002
10002db6:	b5c7a583          	lw	a1,-1188(a5) # 20001b5c <uart0_save_buf>
10002dba:	41001537          	lui	a0,0x41001
10002dbe:	3599                	jal	10002c04 <t1001_sleep_restore_uart_reg_info>
10002dc0:	200027b7          	lui	a5,0x20002
10002dc4:	b547a783          	lw	a5,-1196(a5) # 20001b54 <g_save_buf>
10002dc8:	4394                	lw	a3,0(a5)
10002dca:	4018                	lw	a4,0(s0)
10002dcc:	c314                	sw	a3,0(a4)
10002dce:	0411                	addi	s0,s0,4
10002dd0:	0791                	addi	a5,a5,4
10002dd2:	fe941be3          	bne	s0,s1,10002dc8 <enter_sleep_mode+0x154>
10002dd6:	40080737          	lui	a4,0x40080
10002dda:	08075783          	lhu	a5,128(a4) # 40080080 <__StackTop+0x2007c080>
10002dde:	07c2                	slli	a5,a5,0x10
10002de0:	83c1                	srli	a5,a5,0x10
10002de2:	200026b7          	lui	a3,0x20002
10002de6:	b4f6ac23          	sw	a5,-1192(a3) # 20001b58 <sleep_wakeup_reason>
10002dea:	3ff00793          	li	a5,1023
10002dee:	08f71223          	sh	a5,132(a4)
10002df2:	30046073          	csrsi	mstatus,8
10002df6:	0fffe097          	auipc	ra,0xfffe
10002dfa:	d66080e7          	jalr	-666(ra) # 20000b5c <omw_svc_2g4_set_idle>
10002dfe:	4701                	li	a4,0
10002e00:	e08005b7          	lui	a1,0xe0800
10002e04:	4605                	li	a2,1
10002e06:	03000693          	li	a3,48
10002e0a:	40070793          	addi	a5,a4,1024
10002e0e:	078a                	slli	a5,a5,0x2
10002e10:	97ae                	add	a5,a5,a1
10002e12:	00c78123          	sb	a2,2(a5)
10002e16:	0705                	addi	a4,a4,1
10002e18:	fed719e3          	bne	a4,a3,10002e0a <enter_sleep_mode+0x196>
10002e1c:	200027b7          	lui	a5,0x20002
10002e20:	b4078823          	sb	zero,-1200(a5) # 20001b50 <rx_restart_flag>
10002e24:	200027b7          	lui	a5,0x20002
10002e28:	b40788a3          	sb	zero,-1199(a5) # 20001b51 <tx_restart_flag>
10002e2c:	30046073          	csrsi	mstatus,8
10002e30:	400807b7          	lui	a5,0x40080
10002e34:	4fc8                	lw	a0,28(a5)
10002e36:	50a6                	lw	ra,104(sp)
10002e38:	5416                	lw	s0,100(sp)
10002e3a:	5486                	lw	s1,96(sp)
10002e3c:	06c10113          	addi	sp,sp,108
10002e40:	8082                	ret
	...

10002e44 <memcpy>:
10002e44:	832a                	mv	t1,a0
10002e46:	ca09                	beqz	a2,10002e58 <memcpy+0x14>
10002e48:	0005c383          	lbu	t2,0(a1) # e0800000 <__StackTop+0xc07fc000>
10002e4c:	00730023          	sb	t2,0(t1)
10002e50:	167d                	addi	a2,a2,-1
10002e52:	0305                	addi	t1,t1,1
10002e54:	0585                	addi	a1,a1,1
10002e56:	fa6d                	bnez	a2,10002e48 <memcpy+0x4>
10002e58:	8082                	ret
	...

10002e5c <memset>:
10002e5c:	832a                	mv	t1,a0
10002e5e:	c611                	beqz	a2,10002e6a <memset+0xe>
10002e60:	00b30023          	sb	a1,0(t1)
10002e64:	167d                	addi	a2,a2,-1
10002e66:	0305                	addi	t1,t1,1
10002e68:	fe65                	bnez	a2,10002e60 <memset+0x4>
10002e6a:	8082                	ret
10002e6c:	0000                	unimp
10002e6e:	0000                	unimp
10002e70:	0020                	addi	s0,sp,8
10002e72:	0000                	unimp
10002e74:	3130                	.insn	2, 0x3130
10002e76:	3332                	.insn	2, 0x3332
10002e78:	3534                	.insn	2, 0x3534
10002e7a:	3736                	.insn	2, 0x3736
10002e7c:	3938                	.insn	2, 0x3938
10002e7e:	6261                	lui	tp,0x18
10002e80:	66656463          	bltu	a0,t1,100034e8 <keys_func_table+0x314>
10002e84:	0000                	unimp
10002e86:	0000                	unimp
10002e88:	3130                	.insn	2, 0x3130
10002e8a:	3332                	.insn	2, 0x3332
10002e8c:	3534                	.insn	2, 0x3534
10002e8e:	3736                	.insn	2, 0x3736
10002e90:	3938                	.insn	2, 0x3938
10002e92:	4241                	li	tp,16
10002e94:	46454443          	.insn	4, 0x46454443
10002e98:	0000                	unimp
10002e9a:	0000                	unimp
10002e9c:	5245                	li	tp,-15
10002e9e:	4f52                	lw	t5,20(sp)
10002ea0:	0052                	c.slli	zero,0x14
10002ea2:	0000                	unimp
10002ea4:	5644415b          	.insn	4, 0x5644415b
10002ea8:	205d                	jal	10002f4e <memset+0xf2>
10002eaa:	b9e5                	j	10002ba2 <rf_2g4_init+0xb2>
10002eac:	ad92e6bf e9918fe5 	.insn	8, 0xe9918fe5ad92e6bf
10002eb4:	8180                	.insn	2, 0x8180
10002eb6:	88e5                	andi	s1,s1,25
10002eb8:	e59d                	bnez	a1,10002ee6 <memset+0x8a>
10002eba:	8ce58ba7          	.insn	4, 0x8ce58ba7
10002ebe:	e596                	.insn	2, 0xe596
10002ec0:	8cae                	mv	s9,a1
10002ec2:	88e6                	mv	a7,s9
10002ec4:	ef90                	.insn	2, 0xef90
10002ec6:	88bc                	.insn	2, 0x88bc
10002ec8:	b8e4                	.insn	2, 0xb8e4
10002eca:	aabee5bb          	.insn	4, 0xaabee5bb
10002ece:	e6af8ee7          	jalr	t4,-406(t6)
10002ed2:	a1a8                	.insn	2, 0xa1a8
10002ed4:	bce5                	j	100029cc <adv_channel_idx_to_channel_num+0x16>
10002ed6:	89bcef8f          	.insn	4, 0x89bcef8f
10002eda:	000a                	c.slli	zero,0x2
10002edc:	88e5                	andi	s1,s1,25
10002ede:	e59d                	bnez	a1,10002f0c <memset+0xb0>
10002ee0:	8ce58ba7          	.insn	4, 0x8ce58ba7
10002ee4:	e596                	.insn	2, 0xe596
10002ee6:	8cae                	mv	s9,a1
10002ee8:	88e6                	mv	a7,s9
10002eea:	0090                	addi	a2,sp,64
10002eec:	6552                	.insn	2, 0x6552
10002eee:	6f6d                	lui	t5,0x1b
10002ef0:	6574                	.insn	2, 0x6574
10002ef2:	2072                	.insn	2, 0x2072
10002ef4:	4f495047          	.insn	4, 0x4f495047
10002ef8:	6920                	.insn	2, 0x6920
10002efa:	696e                	.insn	2, 0x696e
10002efc:	6974                	.insn	2, 0x6974
10002efe:	6c61                	lui	s8,0x18
10002f00:	7a69                	lui	s4,0xffffa
10002f02:	6465                	lui	s0,0x19
10002f04:	000a                	c.slli	zero,0x2
10002f06:	0000                	unimp
10002f08:	454c425b          	.insn	4, 0x454c425b
10002f0c:	205d                	jal	10002fb2 <memset+0x156>
10002f0e:	6150                	.insn	2, 0x6150
10002f10:	74656b63          	bltu	a0,t1,10003666 <addr_list+0x12>
10002f14:	6920                	.insn	2, 0x6920
10002f16:	696e                	.insn	2, 0x696e
10002f18:	6974                	.insn	2, 0x6974
10002f1a:	6c61                	lui	s8,0x18
10002f1c:	7a69                	lui	s4,0xffffa
10002f1e:	6465                	lui	s0,0x19
10002f20:	202c                	.insn	2, 0x202c
10002f22:	554f5247          	.insn	4, 0x554f5247
10002f26:	5f50                	lw	a2,60(a4)
10002f28:	4441                	li	s0,16
10002f2a:	5244                	lw	s1,36(a2)
10002f2c:	303d                	jal	1000275a <get_dc_info_iq+0x80>
10002f2e:	2578                	.insn	2, 0x2578
10002f30:	3830                	.insn	2, 0x3830
10002f32:	0a58                	addi	a4,sp,276
10002f34:	0000                	unimp
10002f36:	0000                	unimp
10002f38:	2079654b          	.insn	4, 0x2079654b
10002f3c:	7270                	.insn	2, 0x7270
10002f3e:	7365636f          	jal	t1,10059674 <__etext+0x55fcc>
10002f42:	6e692073          	.insn	4, 0x6e692073
10002f46:	7469                	lui	s0,0xffffa
10002f48:	000a                	c.slli	zero,0x2
10002f4a:	0000                	unimp
10002f4c:	5359454b          	.insn	4, 0x5359454b
10002f50:	465f 4e55 5443      	.insn	6, 0x54434e55465f
10002f56:	4f49                	li	t5,18
10002f58:	5f4e                	lw	t5,240(sp)
10002f5a:	554e                	lw	a0,240(sp)
10002f5c:	204d                	jal	10002ffe <memset+0x1a2>
10002f5e:	203d                	jal	10002f8c <memset+0x130>
10002f60:	6425                	lui	s0,0x9
10002f62:	2820                	.insn	2, 0x2820
10002f64:	7561                	lui	a0,0xffff8
10002f66:	6f74                	.insn	2, 0x6f74
10002f68:	632d                	lui	t1,0xb
10002f6a:	6c61                	lui	s8,0x18
10002f6c:	616c7563          	bgeu	s8,s6,10003576 <keys_func_table+0x3a2>
10002f70:	6574                	.insn	2, 0x6574
10002f72:	2964                	.insn	2, 0x2964
10002f74:	000a                	c.slli	zero,0x2
10002f76:	0000                	unimp
10002f78:	6552                	.insn	2, 0x6552
10002f7a:	6f6d                	lui	t5,0x1b
10002f7c:	6574                	.insn	2, 0x6574
10002f7e:	2072                	.insn	2, 0x2072
10002f80:	6e69                	lui	t3,0x1a
10002f82:	7469                	lui	s0,0xffffa
10002f84:	6169                	addi	sp,sp,208
10002f86:	696c                	.insn	2, 0x696c
10002f88:	657a                	.insn	2, 0x657a
10002f8a:	2064                	.insn	2, 0x2064
10002f8c:	5628                	lw	a0,104(a2)
10002f8e:	4f49                	li	t5,18
10002f90:	2054                	.insn	2, 0x2054
10002f92:	6f6d                	lui	t5,0x1b
10002f94:	6564                	.insn	2, 0x6564
10002f96:	0a29                	addi	s4,s4,10 # ffffa00a <__StackTop+0xdfff600a>
10002f98:	0000                	unimp
10002f9a:	0000                	unimp
10002f9c:	5644415b          	.insn	4, 0x5644415b
10002fa0:	205d                	jal	10003046 <memset+0x1ea>
10002fa2:	95e6                	add	a1,a1,s9
10002fa4:	e6b0                	.insn	2, 0xe6b0
10002fa6:	ae8d                	j	10003318 <keys_func_table+0x144>
10002fa8:	8ce5                	and	s1,s1,s1
10002faa:	e585                	bnez	a1,10002fd2 <memset+0x176>
10002fac:	80e9918f          	.insn	4, 0x80e9918f
10002fb0:	e581                	bnez	a1,10002fb8 <memset+0x15c>
10002fb2:	8cae                	mv	s9,a1
10002fb4:	88e6                	mv	a7,s9
10002fb6:	0a90                	addi	a2,sp,336
10002fb8:	0000                	unimp
10002fba:	0000                	unimp
10002fbc:	6f4e                	.insn	2, 0x6f4e
10002fbe:	6d20                	.insn	2, 0x6d20
10002fc0:	7461                	lui	s0,0xffff8
10002fc2:	6e696863          	bltu	s2,t1,100036b2 <__etext+0xa>
10002fc6:	656b2067          	.insn	4, 0x656b2067
10002fca:	2079                	jal	10003058 <memset+0x1fc>
10002fcc:	6f66                	.insn	2, 0x6f66
10002fce:	6e75                	lui	t3,0x1d
10002fd0:	2064                	.insn	2, 0x2064
10002fd2:	6f66                	.insn	2, 0x6f66
10002fd4:	2072                	.insn	2, 0x2072
10002fd6:	7830                	.insn	2, 0x7830
10002fd8:	3025                	jal	10002800 <rf_dcoc_calib_iq_bq+0x2c>
10002fda:	5838                	lw	a4,112(s0)
10002fdc:	000a                	c.slli	zero,0x2
10002fde:	0000                	unimp
10002fe0:	3d0a                	.insn	2, 0x3d0a
10002fe2:	3d3d                	jal	10002e20 <enter_sleep_mode+0x1ac>
10002fe4:	e620                	.insn	2, 0xe620
10002fe6:	a0e6a797          	auipc	a5,0xa0e6a
10002fea:	e5bc                	.insn	2, 0xe5bc
10002fec:	8fbc                	.insn	2, 0x8fbc
10002fee:	e796bce7          	.insn	4, 0xe796bce7
10002ff2:	81a0                	.insn	2, 0x81a0
10002ff4:	90e5                	srli	s1,s1,0x39
10002ff6:	e68e                	.insn	2, 0xe68e
10002ff8:	b095                	j	1000285c <rf_dcoc_calib_iq_bq+0x88>
10002ffa:	8de6                	mv	s11,s9
10002ffc:	20ae                	.insn	2, 0x20ae
10002ffe:	3d3d                	jal	10002e3c <enter_sleep_mode+0x1c8>
10003000:	0a3d                	addi	s4,s4,15
10003002:	0000                	unimp
10003004:	88e6                	mv	a7,s9
10003006:	e590                	.insn	2, 0xe590
10003008:	9f8a                	add	t6,t6,sp
1000300a:	0000                	unimp
1000300c:	e796bce7          	.insn	4, 0xe796bce7
10003010:	81a0                	.insn	2, 0x81a0
10003012:	e693bbe7          	.insn	4, 0xe693bbe7
10003016:	9c9e                	add	s9,s9,t2
10003018:	203a                	.insn	2, 0x203a
1000301a:	7325                	lui	t1,0xfffe9
1000301c:	2820                	.insn	2, 0x2820
1000301e:	6572                	.insn	2, 0x6572
10003020:	3d74                	.insn	2, 0x3d74
10003022:	7830                	.insn	2, 0x7830
10003024:	3025                	jal	1000284c <rf_dcoc_calib_iq_bq+0x78>
10003026:	5832                	lw	a6,44(sp)
10003028:	0a29                	addi	s4,s4,10
1000302a:	0000                	unimp
1000302c:	3a444d43          	.insn	4, 0x3a444d43
10003030:	3020                	.insn	2, 0x3020
10003032:	2578                	.insn	2, 0x2578
10003034:	3230                	.insn	2, 0x3230
10003036:	2c58                	.insn	2, 0x2c58
10003038:	5020                	lw	s0,96(s0)
1000303a:	7261                	lui	tp,0xffff8
1000303c:	3a61                	jal	100029d4 <adv_channel_idx_to_channel_num+0x1e>
1000303e:	5b20                	lw	s0,112(a4)
10003040:	7830                	.insn	2, 0x7830
10003042:	3025                	jal	1000286a <rf_dcoc_calib_iq_bq+0x96>
10003044:	5834                	lw	a3,112(s0)
10003046:	202c                	.insn	2, 0x202c
10003048:	7830                	.insn	2, 0x7830
1000304a:	3025                	jal	10002872 <rf_dcoc_calib_iq_bq+0x9e>
1000304c:	5834                	lw	a3,112(s0)
1000304e:	202c                	.insn	2, 0x202c
10003050:	7830                	.insn	2, 0x7830
10003052:	3025                	jal	1000287a <rf_dcoc_calib_iq_bq+0xa6>
10003054:	5834                	lw	a3,112(s0)
10003056:	0a5d                	addi	s4,s4,23
10003058:	0000                	unimp
1000305a:	0000                	unimp
1000305c:	e796bce7          	.insn	4, 0xe796bce7
10003060:	81a0                	.insn	2, 0x81a0
10003062:	95e6                	add	a1,a1,s9
10003064:	e6b0                	.insn	2, 0xe6b0
10003066:	ae8d                	j	100033d8 <keys_func_table+0x204>
10003068:	95e9                	srai	a1,a1,0x3a
1000306a:	a6bae5bf 6425203a 	.insn	8, 0x6425203aa6bae5bf
10003072:	ade5                	j	1000376a <__etext+0xc2>
10003074:	828ae897          	auipc	a7,0x828ae
10003078:	000a                	c.slli	zero,0x2
1000307a:	0000                	unimp
1000307c:	e796bce7          	.insn	4, 0xe796bce7
10003080:	81a0                	.insn	2, 0x81a0
10003082:	95e6                	add	a1,a1,s9
10003084:	e6b0                	.insn	2, 0xe6b0
10003086:	ae8d                	j	100033f8 <keys_func_table+0x224>
10003088:	203a                	.insn	2, 0x203a
1000308a:	0000                	unimp
1000308c:	3025                	jal	100028b4 <rf_dcoc_calib_iq_bq+0xe0>
1000308e:	5832                	lw	a6,44(sp)
10003090:	0020                	addi	s0,sp,8
10003092:	0000                	unimp
10003094:	200a                	.insn	2, 0x200a
10003096:	2020                	.insn	2, 0x2020
10003098:	2020                	.insn	2, 0x2020
1000309a:	2020                	.insn	2, 0x2020
1000309c:	2020                	.insn	2, 0x2020
1000309e:	2020                	.insn	2, 0x2020
100030a0:	0000                	unimp
100030a2:	0000                	unimp
100030a4:	000a                	c.slli	zero,0x2
100030a6:	0000                	unimp
100030a8:	b9e5                	j	10002da0 <enter_sleep_mode+0x12c>
100030aa:	ad92e6bf e543414d 	.insn	8, 0xe543414dad92e6bf
100030b2:	b09c                	.insn	2, 0xb09c
100030b4:	9de5                	.insn	2, 0x9de5
100030b6:	3a80                	.insn	2, 0x3a80
100030b8:	0020                	addi	s0,sp,8
100030ba:	0000                	unimp
100030bc:	3025                	jal	100028e4 <omw_rf_dcoc_cal+0x4>
100030be:	5832                	lw	a6,44(sp)
100030c0:	0000                	unimp
100030c2:	0000                	unimp
100030c4:	003a                	c.slli	zero,0xe
100030c6:	0000                	unimp
100030c8:	6552                	.insn	2, 0x6552
100030ca:	6461                	lui	s0,0x18
100030cc:	2079                	jal	1000315a <memset+0x2fe>
100030ce:	6f74                	.insn	2, 0x6f74
100030d0:	7320                	.insn	2, 0x7320
100030d2:	656c                	.insn	2, 0x656c
100030d4:	7065                	c.lui	zero,0xffff9
100030d6:	2820                	.insn	2, 0x2820
100030d8:	6f6e                	.insn	2, 0x6f6e
100030da:	6120                	.insn	2, 0x6120
100030dc:	6f697463          	bgeu	s2,s6,100037c4 <__etext+0x11c>
100030e0:	206e                	.insn	2, 0x206e
100030e2:	6f66                	.insn	2, 0x6f66
100030e4:	2072                	.insn	2, 0x2072
100030e6:	7335                	lui	t1,0xfffed
100030e8:	0a29                	addi	s4,s4,10
100030ea:	0000                	unimp
100030ec:	6e45                	lui	t3,0x11
100030ee:	6574                	.insn	2, 0x6574
100030f0:	2072                	.insn	2, 0x2072
100030f2:	65656c73          	.insn	4, 0x65656c73
100030f6:	2070                	.insn	2, 0x2070
100030f8:	6f6d                	lui	t5,0x1b
100030fa:	6564                	.insn	2, 0x6564
100030fc:	000a                	c.slli	zero,0x2
100030fe:	0000                	unimp
10003100:	3d0a                	.insn	2, 0x3d0a
10003102:	3d3d                	jal	10002f40 <memset+0xe4>
10003104:	5720                	lw	s0,104(a4)
10003106:	6b61                	lui	s6,0x18
10003108:	7565                	lui	a0,0xffff9
1000310a:	2070                	.insn	2, 0x2070
1000310c:	7266                	.insn	2, 0x7266
1000310e:	73206d6f          	jal	s10,10009840 <__etext+0x6198>
10003112:	656c                	.insn	2, 0x656c
10003114:	7065                	c.lui	zero,0xffff9
10003116:	3d20                	.insn	2, 0x3d20
10003118:	3d3d                	jal	10002f56 <memset+0xfa>
1000311a:	000a                	c.slli	zero,0x2
1000311c:	656b6157          	.insn	4, 0x656b6157
10003120:	7075                	c.lui	zero,0xffffd
10003122:	4920                	lw	s0,80(a0)
10003124:	30203a4f          	.insn	4, 0x30203a4f
10003128:	2578                	.insn	2, 0x2578
1000312a:	0a78                	addi	a4,sp,284
1000312c:	0000                	unimp
1000312e:	0000                	unimp
10003130:	3d3d                	jal	10002f6e <memset+0x112>
10003132:	203d                	jal	10003160 <memset+0x304>
10003134:	74737953          	.insn	4, 0x74737953
10003138:	6d65                	lui	s10,0x19
1000313a:	7220                	.insn	2, 0x7220
1000313c:	7365                	lui	t1,0xffff9
1000313e:	6d75                	lui	s10,0x1d
10003140:	6465                	lui	s0,0x19
10003142:	3d20                	.insn	2, 0x3d20
10003144:	3d3d                	jal	10002f82 <memset+0x126>
10003146:	0a0a                	slli	s4,s4,0x2
10003148:	0000                	unimp
1000314a:	0000                	unimp
1000314c:	02ec                	addi	a1,sp,332
1000314e:	1000                	addi	s0,sp,32
10003150:	0302                	c.slli64	t1
10003152:	1000                	addi	s0,sp,32
10003154:	03ee                	slli	t2,t2,0x1b
10003156:	1000                	addi	s0,sp,32
10003158:	03ee                	slli	t2,t2,0x1b
1000315a:	1000                	addi	s0,sp,32
1000315c:	03ee                	slli	t2,t2,0x1b
1000315e:	1000                	addi	s0,sp,32
10003160:	03ee                	slli	t2,t2,0x1b
10003162:	1000                	addi	s0,sp,32
10003164:	03ee                	slli	t2,t2,0x1b
10003166:	1000                	addi	s0,sp,32
10003168:	03ee                	slli	t2,t2,0x1b
1000316a:	1000                	addi	s0,sp,32
1000316c:	03ee                	slli	t2,t2,0x1b
1000316e:	1000                	addi	s0,sp,32
10003170:	02e8                	addi	a0,sp,332
10003172:	1000                	addi	s0,sp,32
10003174:	03ee                	slli	t2,t2,0x1b
10003176:	1000                	addi	s0,sp,32
10003178:	03ee                	slli	t2,t2,0x1b
1000317a:	1000                	addi	s0,sp,32
1000317c:	03ee                	slli	t2,t2,0x1b
1000317e:	1000                	addi	s0,sp,32
10003180:	0362                	slli	t1,t1,0x18
10003182:	1000                	addi	s0,sp,32
10003184:	03ee                	slli	t2,t2,0x1b
10003186:	1000                	addi	s0,sp,32
10003188:	03ee                	slli	t2,t2,0x1b
1000318a:	1000                	addi	s0,sp,32
1000318c:	0316                	slli	t1,t1,0x5
1000318e:	1000                	addi	s0,sp,32
10003190:	03ee                	slli	t2,t2,0x1b
10003192:	1000                	addi	s0,sp,32
10003194:	0358                	addi	a4,sp,388
10003196:	1000                	addi	s0,sp,32
10003198:	03ee                	slli	t2,t2,0x1b
1000319a:	1000                	addi	s0,sp,32
1000319c:	03ee                	slli	t2,t2,0x1b
1000319e:	1000                	addi	s0,sp,32
100031a0:	0362                	slli	t1,t1,0x18
100031a2:	1000                	addi	s0,sp,32
100031a4:	03ee                	slli	t2,t2,0x1b
100031a6:	1000                	addi	s0,sp,32
100031a8:	0302                	c.slli64	t1
100031aa:	1000                	addi	s0,sp,32

100031ac <output_pin>:
100031ac:	0008 0000 0000 0000 0007 0000 000f 0000     ................
100031bc:	0006 0000 0001 0000                         ........

100031c4 <input_pin>:
100031c4:	0015 0000 0014 0000 0013 0000 0012 0000     ................

100031d4 <keys_func_table>:
100031d4:	0000 0060 00b4 1000 0011 0000 0000 0000     ..`.............
100031e4:	00b4 1000 0011 0000 0000 0000 00b4 1000     ................
100031f4:	0011 0000 0000 0000 0000 0050 00b4 1000     ..........P.....
10003204:	0012 0000 0000 0000 00b4 1000 0012 0000     ................
10003214:	0000 0000 00b4 1000 0012 0000 0000 0000     ................
10003224:	0000 0048 00b4 1000 0013 0000 0000 0000     ..H.............
10003234:	00b4 1000 0013 0000 0000 0000 00b4 1000     ................
10003244:	0013 0000 0000 0000 0000 0044 00b4 1000     ..........D.....
10003254:	0014 0000 0000 0000 00b4 1000 0014 0000     ................
10003264:	0000 0000 00b4 1000 0014 0000 0000 0000     ................
10003274:	8000 0020 00b4 1000 0021 0000 0000 0000     .. .....!.......
10003284:	00b4 1000 0021 0000 0000 0000 00b4 1000     ....!...........
10003294:	0021 0000 0000 0000 8000 0010 00b4 1000     !...............
100032a4:	0022 0000 0000 0000 00b4 1000 0022 0000     "..........."...
100032b4:	0000 0000 00b4 1000 0022 0000 0000 0000     ........".......
100032c4:	0001 0008 00b4 1000 0023 0000 0000 0000     ........#.......
100032d4:	00b4 1000 0023 0000 0000 0000 00b4 1000     ....#...........
100032e4:	0023 0000 0000 0000 0001 0004 00b4 1000     #...............
100032f4:	0024 0000 0000 0000 00b4 1000 0024 0000     $...........$...
10003304:	0000 0000 00b4 1000 0024 0000 0000 0000     ........$.......
10003314:	0002 0020 00b4 1000 0031 0000 0000 0000     .. .....1.......
10003324:	00b4 1000 0031 0000 0000 0000 00b4 1000     ....1...........
10003334:	0031 0000 0000 0000 0002 0010 00b4 1000     1...............
10003344:	0032 0000 0000 0000 00b4 1000 0032 0000     2...........2...
10003354:	0000 0000 00b4 1000 0032 0000 0000 0000     ........2.......
10003364:	0002 0008 00b4 1000 0033 0000 0000 0000     ........3.......
10003374:	00b4 1000 0033 0000 0000 0000 00b4 1000     ....3...........
10003384:	0033 0000 0000 0000 0002 0004 00b4 1000     3...............
10003394:	0034 0000 0000 0000 00b4 1000 0034 0000     4...........4...
100033a4:	0000 0000 00b4 1000 0034 0000 0000 0000     ........4.......
100033b4:	0100 0020 00b4 1000 0041 0000 0000 0000     .. .....A.......
100033c4:	00b4 1000 0041 0000 0000 0000 00b4 1000     ....A...........
100033d4:	0041 0000 0000 0000 0100 0010 00b4 1000     A...............
100033e4:	0042 0000 0000 0000 00b4 1000 0042 0000     B...........B...
100033f4:	0000 0000 00b4 1000 0042 0000 0000 0000     ........B.......
10003404:	0100 0008 00b4 1000 0043 0000 0000 0000     ........C.......
10003414:	00b4 1000 0043 0000 0000 0000 00b4 1000     ....C...........
10003424:	0043 0000 0000 0000 0100 0004 00b4 1000     C...............
10003434:	0044 0000 0000 0000 00b4 1000 0044 0000     D...........D...
10003444:	0000 0000 00b4 1000 0044 0000 0000 0000     ........D.......
10003454:	0080 0020 00b4 1000 0051 0000 0000 0000     .. .....Q.......
10003464:	00b4 1000 0051 0000 0000 0000 00b4 1000     ....Q...........
10003474:	0051 0000 0000 0000 0080 0010 00b4 1000     Q...............
10003484:	0052 0000 0000 0000 00b4 1000 0052 0000     R...........R...
10003494:	0000 0000 00b4 1000 0052 0000 0000 0000     ........R.......
100034a4:	0080 0008 00b4 1000 0053 0000 0000 0000     ........S.......
100034b4:	00b4 1000 0053 0000 0000 0000 00b4 1000     ....S...........
100034c4:	0053 0000 0000 0000 0080 0004 00b4 1000     S...............
100034d4:	0054 0000 0000 0000 00b4 1000 0054 0000     T...........T...
100034e4:	0000 0000 00b4 1000 0054 0000 0000 0000     ........T.......
100034f4:	0040 0020 00b4 1000 0061 0000 0000 0000     @. .....a.......
10003504:	00b4 1000 0061 0000 0000 0000 00b4 1000     ....a...........
10003514:	0061 0000 0000 0000 0040 0010 00b4 1000     a.......@.......
10003524:	0062 0000 0000 0000 00b4 1000 0062 0000     b...........b...
10003534:	0000 0000 00b4 1000 0062 0000 0000 0000     ........b.......
10003544:	0040 0008 00b4 1000 0063 0000 0000 0000     @.......c.......
10003554:	00b4 1000 0063 0000 0000 0000 00b4 1000     ....c...........
10003564:	0063 0000 0000 0000 0040 0004 00b4 1000     c.......@.......
10003574:	0064 0000 0000 0000 00b4 1000 0064 0000     d...........d...
10003584:	0000 0000 00b4 1000 0064 0000 0000 0000     ........d.......
10003594:	0001 0020 00b4 1000 0001 0000 0000 0000     .. .............
100035a4:	00b4 1000 0001 0000 0000 0000 00b4 1000     ................
100035b4:	0001 0000 0000 0000 0001 0010 00b4 1000     ................
100035c4:	0002 0000 0000 0000 00b4 1000 0002 0000     ................
100035d4:	0000 0000 00b4 1000 0002 0000 0000 0000     ................
100035e4:	8000 0008 00b4 1000 0003 0000 0000 0000     ................
100035f4:	00b4 1000 0003 0000 0000 0000 00b4 1000     ................
10003604:	0003 0000 0000 0000 8000 0004 00b4 1000     ................
10003614:	0004 0000 0000 0000 00b4 1000 0004 0000     ................
10003624:	0000 0000 00b4 1000 0004 0000 0000 0000     ................

10003634 <DEFAULT_BLE_MAC>:
10003634:	2211 4433 6655 0000                         ."3DUf..

1000363c <freq_ratios>:
1000363c:	0101 0101 0402 1408 6428 00fa               ........(d..

10003648 <rssi_thresholds>:
10003648:	0309 0368 03d2 0449 04cf 0566               ..h...I...f.

10003654 <addr_list>:
10003654:	0200 4001 0204 4001 0208 4001 020c 4001     ...@...@...@...@
10003664:	0210 4001 0214 4001 0300 4001 0304 4001     ...@...@...@...@
10003674:	0010 4001 0030 4001 0040 4001 0170 4001     ...@0..@@..@p..@
10003684:	0180 4001 0190 4001 01a0 4001 0140 4001     ...@...@...@@..@

Disassembly of section .data:

20000000 <__VECTOR_TABLE>:
	...
2000000c:	0c82 1000 0000 0000 0000 0000 0000 0000     ................
2000001c:	0c82 1000 0000 0000 0000 0000 0000 0000     ................
2000002c:	0c82 1000 0000 0000 0000 0000 0000 0000     ................
2000003c:	0000 0000 0c82 1000 0c82 1000 05ec 2000     ............... 
2000004c:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
2000005c:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
2000006c:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
2000007c:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
2000008c:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
2000009c:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
200000ac:	0c82 1000 0c82 1000 0c82 1000 0c82 1000     ................
200000bc:	0c82 1000                                   ....

200000c0 <is_rx>:
200000c0:	0001 0000                                   ....

200000c4 <reversed_access>:
200000c4:	19c0 2000                                   ... 

200000c8 <rf_2g4_call_desc_list_rx>:
200000c8:	0000 0000 5000 0001 19b1 2000 2000 0001     .....P..... . ..
200000d8:	03b0 2000 6000 0000 0128 2000 6000 0000     ... .`..(.. .`..
200000e8:	19b1 2000 2000 0000 0130 2000 6008 0000     ... . ..0.. .`..

200000f8 <rf_2g4_call_desc_list_tx>:
200000f8:	0000 0000 5000 0001 19b1 2000 2000 0001     .....P..... . ..
20000108:	0440 2000 6000 0000 0128 2000 6000 0000     @.. .`..(.. .`..
20000118:	19b1 2000 2000 0000 0190 2000 6008 0000     ... . ..... .`..

20000128 <rf_2g4_common_desc_pll_delay>:
20000128:	0000 0000 5008 001e                         .....P..

20000130 <rf_call_desc_list_rx_process>:
20000130:	0238 2000 6000 0000 0368 2000 6000 0000     8.. .`..h.. .`..
20000140:	0210 2000 6000 0000 1a9c 2000 6000 0000     ... .`..... .`..
20000150:	0248 2000 6000 0000 0228 2000 6000 0000     H.. .`..(.. .`..
20000160:	0000 0000 6000 0000 0220 2000 6000 0000     .....`.. .. .`..
20000170:	0240 2000 6000 0000 19b1 2000 2000 0001     @.. .`..... . ..
20000180:	0348 2000 6000 0000 19b1 2000 2008 0000     H.. .`..... . ..

20000190 <rf_call_desc_list_tx_process>:
20000190:	0238 2000 6000 0000 03a0 2000 6000 0000     8.. .`..... .`..
200001a0:	1ab4 2000 6000 0000 0260 2000 6000 0000     ... .`..`.. .`..
200001b0:	0270 2000 6000 0000 0290 2000 6000 0000     p.. .`..... .`..
200001c0:	02a8 2000 6000 0000 0000 0000 6000 0000     ... .`.......`..
200001d0:	19b1 2000 2000 0001 0298 2000 6000 0000     ... . ..... .`..
200001e0:	0268 2000 6000 0000 0230 2000 6000 0000     h.. .`..0.. .`..
200001f0:	0250 2000 6000 0000 0220 2000 6000 0000     P.. .`.. .. .`..
20000200:	0388 2000 6000 0000 19b1 2000 2008 0000     ... .`..... . ..

20000210 <rf_common_desc_coded_recal>:
20000210:	0000 0000 5008 0001 0000 0000 0000 0000     .....P..........

20000220 <rf_common_desc_mdm_off>:
20000220:	1000 4200 2008 0000                         ...B. ..

20000228 <rf_common_desc_mdm_rxon>:
20000228:	1000 4200 2008 000c                         ...B. ..

20000230 <rf_common_desc_mdm_txoff>:
20000230:	1000 4200 2008 0001                         ...B. ..

20000238 <rf_common_desc_resetmdm>:
20000238:	0000 4200 2008 0006                         ...B. ..

20000240 <rf_common_desc_rf_off>:
20000240:	0084 4200 2008 0000                         ...B. ..

20000248 <rf_common_desc_rf_rxon>:
20000248:	0084 4200 2008 0001                         ...B. ..

20000250 <rf_common_desc_rf_tx_dac_off>:
20000250:	2015 4200 3040 0200 0084 4200 3048 0200     . .B@0.....BH0..

20000260 <rf_common_desc_rf_tx_dac_on>:
20000260:	0084 4200 3048 0202                         ...BH0..

20000268 <rf_common_desc_rf_tx_pa_off>:
20000268:	2015 4200 3048 0500                         . .BH0..

20000270 <rf_common_desc_rf_tx_pa_on>:
20000270:	2015 4200 3048 0101                         . .BH0..

20000278 <rf_common_desc_setfreq>:
20000278:	1000 4200 2000 0000 0000 4200 2000 0006     ...B. .....B. ..
20000288:	0000 0000 5008 0001                         .....P..

20000290 <rf_common_desc_tx_carrier>:
20000290:	1acc 2000 1008 0007                         ... ....

20000298 <rf_common_desc_tx_end_delay>:
20000298:	0000 0000 5008 0005                         .....P..

200002a0 <dynamic_agc_ctrl_status>:
200002a0:	0001 0000                                   ....

200002a4 <g_lp>:
200002a4:	2b15 000b                                   .+..

200002a8 <rf_common_desc_mdm_txon_ext>:
200002a8:	1000 4200 2000 0003 0000 0000 5080 0002     ...B. .......P..
200002b8:	1027 4200 3048 8000                         '..BH0..

200002c0 <rf_common_desc_pll_on_3>:
200002c0:	200c 4200 2080 00ff 0000 0000 5000 000a     . .B. .......P..
200002d0:	2004 4200 3040 0400 200c 4200 3040 0100     . .B@0... .B@0..
200002e0:	2018 4200 3040 0100 2018 4200 3040 0101     . .B@0... .B@0..
200002f0:	2018 4200 3040 0200 2018 4200 3040 0202     . .B@0... .B@0..
20000300:	2018 4200 3040 0200 0278 2000 6008 0000     . .B@0..x.. .`..

20000310 <rf_common_desc_rfpll_off>:
20000310:	2018 4200 3040 0100 2000 4200 3040 0100     . .B@0... .B@0..
20000320:	200c 4200 2080 0000 2004 4200 3040 0100     . .B. ... .B@0..
20000330:	2004 4200 3040 0200 2004 4200 3040 fc00     . .B@0... .B@0..
20000340:	2005 4200 3048 0100                         . .BH0..

20000348 <rf_common_desc_rfrx_off>:
20000348:	2008 4200 3040 8080 2009 4200 3040 0702     . .B@0... .B@0..
20000358:	2010 4200 2080 0000 0310 2000 6008 0000     . .B. ..... .`..

20000368 <rf_common_desc_rfrx_on>:
20000368:	20d2 4200 3040 0f0f 2008 4200 3040 8080     . .B@0... .B@0..
20000378:	2009 4200 3040 0701 2010 4200 2088 01ff     . .B@0... .B. ..

20000388 <rf_common_desc_rftx_off>:
20000388:	0105 4008 3040 1f05 2008 4200 3040 3f00     ...@@0... .B@0.?
20000398:	0310 2000 6008 0000                         ... .`..

200003a0 <rf_common_desc_rftx_on>:
200003a0:	2008 4200 3040 3f1e 20d2 4200 3048 0f03     . .B@0.?. .BH0..

200003b0 <rf_common_desc_rx_setfreq>:
200003b0:	0000 0000 2020 1024 20dc 4200 3040 c080     ....  $.. .B@0..
200003c0:	20dd 4200 3040 0701 20dc 4200 3040 3c3c     . .B@0... .B@0<<
200003d0:	20e4 4200 3040 1c0c 20de 4200 3040 0404     . .B@0... .B@0..
200003e0:	2009 4200 3040 7820 2009 4200 3040 8000     . .B@0 x. .B@0..
200003f0:	200a 4200 3040 0702 20dd 4200 3040 0800     . .B@0... .B@0..
20000400:	20e2 4200 3040 8000 20e3 4200 3040 0300     . .B@0... .B@0..
20000410:	2000 4200 3040 0101 2004 4200 3040 0101     . .B@0... .B@0..
20000420:	2004 4200 3040 fcfc 2005 4200 3040 0101     . .B@0... .B@0..
20000430:	201c 4200 3040 1000 02c0 2000 6008 0000     . .B@0..... .`..

20000440 <rf_common_desc_tx_setfreq>:
20000440:	0000 0000 2020 1024 20dc 4200 3040 c000     ....  $.. .B@0..
20000450:	20dd 4200 3040 0700 20dc 4200 3040 3c3c     . .B@0... .B@0<<
20000460:	20e4 4200 3040 1c08 20de 4200 3040 0404     . .B@0... .B@0..
20000470:	2009 4200 3040 7830 2009 4200 3040 8080     . .B@00x. .B@0..
20000480:	200a 4200 3040 0702 0105 4008 3040 1f10     . .B@0.....@@0..
20000490:	20dd 4200 3040 0808 20e2 4200 3040 8080     . .B@0... .B@0..
200004a0:	20e3 4200 3040 0303 2000 4200 3040 0101     . .B@0... .B@0..
200004b0:	2004 4200 2080 03ff 2015 4200 3040 0606     . .B. ... .B@0..
200004c0:	201c 4200 3040 1010 1027 4200 3040 8080     . .B@0..'..B@0..
200004d0:	02c0 2000 6008 0000                         ... .`..

200004d8 <rf_pwr_lvl_map_0>:
200004d8:	100e 101a 101d 1029 102b 102d 1039 103a     ......).+.-.9.:.
200004e8:	103b 103d 184d 1888 1889 188a 188b 188c     ;.=.M...........
200004f8:	188d 18ca 18cb 18cc 18ce 190c 190d 194c     ..............L.
20000508:	194d 198d 19cd 1a0d 1a4d 1a8d 1acd 1b4d     M.......M.....M.
20000518:	1bcd 1ccd 1e4d 1fce 1fce 0000               ....M.......

20000524 <rf_pwr_lvl_map_1>:
20000524:	0080 0082 008a                              ......

2000052a <rf_wb_sat_th>:
2000052a:	0070                                        p.

2000052c <rf_desc_dcoc_calib_rx_off>:
2000052c:	0220 2000 6000 0000 0240 2000 6000 0000      .. .`..@.. .`..
2000053c:	0348 2000 6008 0000                         H.. .`..

20000544 <rf_desc_dcoc_calib_rx_on>:
20000544:	03b0 2000 6000 0000 0000 0000 5000 0032     ... .`.......P2.
20000554:	0238 2000 6000 0000 0368 2000 6000 0000     8.. .`..h.. .`..
20000564:	1004 4200 2000 0001 0248 2000 6000 0000     ...B. ..H.. .`..
20000574:	0228 2000 6008 0000                         (.. .`..

2000057c <cr_regs_addr_list>:
2000057c:	0104 4000 0000 e080 1048 e080 0008 4200     ...@....H......B
2000058c:	001c 4200 0024 4200 0060 4200 0100 4200     ...B$..B`..B...B
2000059c:	0080 4200 0020 4200 0024 4200 000c 4200     ...B ..B$..B...B
200005ac:	1030 4200 1100 4200 114c 4200 2008 4200     0..B...BL..B. .B
200005bc:	20a8 4200 208c 4200 0020 4000 0024 4000     . .B. .B ..@$..@
200005cc:	0028 4000 002c 4000                         (..@,..@

200005d4 <gpio_vdd_pin1>:
200005d4:	                                             .

200005d5 <gpio_vdd_pin2>:
200005d5:	                                             .

200005d6 <adv_channel_idx>:
200005d6:	0026                                        &.

200005d8 <rf_2g4_rx_data_length>:
200005d8:	0027                                        '.

200005da <whiten_chl>:
200005da:	0025                                        %.

200005dc <otp_init>:
200005dc:	02f9 0000                                   ....

200005e0 <uart_addr_idx_list>:
200005e0:	3303 0402 0001 3001                         .3.....0

200005e8 <sleep_wakeup_handler>:
}
200005e8:	4505                	li	a0,1
200005ea:	8082                	ret

200005ec <RADIO_DMA_Handler>:

extern void RF_2G4_RADIO_Handler(void);


__RAM_CODE_SECTION ATTRIBUTE_ISR void  RADIO_DMA_Handler(void)
{
200005ec:	fd810113          	addi	sp,sp,-40
200005f0:	d206                	sw	ra,36(sp)
200005f2:	d016                	sw	t0,32(sp)
200005f4:	ce1a                	sw	t1,28(sp)
200005f6:	cc1e                	sw	t2,24(sp)
200005f8:	ca2a                	sw	a0,20(sp)
200005fa:	c82e                	sw	a1,16(sp)
200005fc:	c632                	sw	a2,12(sp)
200005fe:	c436                	sw	a3,8(sp)
20000600:	c23a                	sw	a4,4(sp)
20000602:	c03e                	sw	a5,0(sp)
    RF_2G4_RADIO_Handler();
20000604:	22d9                	jal	200007ca <RF_2G4_RADIO_Handler>
}
20000606:	5092                	lw	ra,36(sp)
20000608:	5282                	lw	t0,32(sp)
2000060a:	4372                	lw	t1,28(sp)
2000060c:	43e2                	lw	t2,24(sp)
2000060e:	4552                	lw	a0,20(sp)
20000610:	45c2                	lw	a1,16(sp)
20000612:	4632                	lw	a2,12(sp)
20000614:	46a2                	lw	a3,8(sp)
20000616:	4712                	lw	a4,4(sp)
20000618:	4782                	lw	a5,0(sp)
2000061a:	02810113          	addi	sp,sp,40
2000061e:	30200073          	mret

20000622 <poweron_unused_gpio_mask_parse_and_set>:
20000622:	1171                	addi	sp,sp,-4
20000624:	c022                	sw	s0,0(sp)
20000626:	40010337          	lui	t1,0x40010
2000062a:	03032703          	lw	a4,48(t1) # 40010030 <__StackTop+0x2000c030>
2000062e:	fff54793          	not	a5,a0
20000632:	8ff9                	and	a5,a5,a4
20000634:	02f32823          	sw	a5,48(t1)
20000638:	20030313          	addi	t1,t1,512
2000063c:	4291                	li	t0,4
2000063e:	40010437          	lui	s0,0x40010
20000642:	21840413          	addi	s0,s0,536 # 40010218 <__StackTop+0x2000c218>
20000646:	a025                	j	2000066e <poweron_unused_gpio_mask_parse_and_set+0x4c>
20000648:	8105                	srli	a0,a0,0x1
2000064a:	0722                	slli	a4,a4,0x8
2000064c:	06a2                	slli	a3,a3,0x8
2000064e:	0785                	addi	a5,a5,1 # b0e6cfe7 <__StackTop+0x90e68fe7>
20000650:	00578a63          	beq	a5,t0,20000664 <poweron_unused_gpio_mask_parse_and_set+0x42>
20000654:	00157593          	andi	a1,a0,1
20000658:	d9e5                	beqz	a1,20000648 <poweron_unused_gpio_mask_parse_and_set+0x26>
2000065a:	fff74593          	not	a1,a4
2000065e:	8e6d                	and	a2,a2,a1
20000660:	8e55                	or	a2,a2,a3
20000662:	b7dd                	j	20000648 <poweron_unused_gpio_mask_parse_and_set+0x26>
20000664:	00c3a023          	sw	a2,0(t2)
20000668:	0311                	addi	t1,t1,4
2000066a:	00830b63          	beq	t1,s0,20000680 <poweron_unused_gpio_mask_parse_and_set+0x5e>
2000066e:	839a                	mv	t2,t1
20000670:	00032603          	lw	a2,0(t1)
20000674:	0a000693          	li	a3,160
20000678:	0ff00713          	li	a4,255
2000067c:	4781                	li	a5,0
2000067e:	bfd9                	j	20000654 <poweron_unused_gpio_mask_parse_and_set+0x32>
20000680:	4402                	lw	s0,0(sp)
20000682:	0111                	addi	sp,sp,4
20000684:	8082                	ret

20000686 <delay_us>:
20000686:	1171                	addi	sp,sp,-4
20000688:	420007b7          	lui	a5,0x42000
2000068c:	1047a783          	lw	a5,260(a5) # 42000104 <__StackTop+0x21ffc104>
20000690:	c03e                	sw	a5,0(sp)
20000692:	420006b7          	lui	a3,0x42000
20000696:	1046a783          	lw	a5,260(a3) # 42000104 <__StackTop+0x21ffc104>
2000069a:	4702                	lw	a4,0(sp)
2000069c:	8f99                	sub	a5,a5,a4
2000069e:	fea7ece3          	bltu	a5,a0,20000696 <delay_us+0x10>
200006a2:	0111                	addi	sp,sp,4
200006a4:	8082                	ret

200006a6 <delay_ms>:
200006a6:	1171                	addi	sp,sp,-4
200006a8:	c006                	sw	ra,0(sp)
200006aa:	3e800793          	li	a5,1000
200006ae:	02f50533          	mul	a0,a0,a5
200006b2:	3fd1                	jal	20000686 <delay_us>
200006b4:	4082                	lw	ra,0(sp)
200006b6:	0111                	addi	sp,sp,4
200006b8:	8082                	ret

200006ba <omw_svc_2g4_mdf_whiten_desc>:
200006ba:	00359793          	slli	a5,a1,0x3
200006be:	953e                	add	a0,a0,a5
200006c0:	00b67c63          	bgeu	a2,a1,200006d8 <omw_svc_2g4_mdf_whiten_desc+0x1e>
200006c4:	8082                	ret
200006c6:	0407e793          	ori	a5,a5,64
200006ca:	c15c                	sw	a5,4(a0)
200006cc:	0521                	addi	a0,a0,8 # ffff9008 <__StackTop+0xdfff5008>
200006ce:	0585                	addi	a1,a1,1
200006d0:	0ff5f593          	zext.b	a1,a1
200006d4:	feb668e3          	bltu	a2,a1,200006c4 <omw_svc_2g4_mdf_whiten_desc+0xa>
200006d8:	415c                	lw	a5,4(a0)
200006da:	fbf7f793          	andi	a5,a5,-65
200006de:	f6e5                	bnez	a3,200006c6 <omw_svc_2g4_mdf_whiten_desc+0xc>
200006e0:	c15c                	sw	a5,4(a0)
200006e2:	b7ed                	j	200006cc <omw_svc_2g4_mdf_whiten_desc+0x12>

200006e4 <omw_svc_2g4_update_rx_to>:
200006e4:	200027b7          	lui	a5,0x20002
200006e8:	a0478793          	addi	a5,a5,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
200006ec:	0007a023          	sw	zero,0(a5)
200006f0:	0542                	slli	a0,a0,0x10
200006f2:	09056513          	ori	a0,a0,144
200006f6:	c3c8                	sw	a0,4(a5)
200006f8:	8082                	ret

200006fa <omw_svc_2g4_set_access_word>:
200006fa:	1131                	addi	sp,sp,-20
200006fc:	c806                	sw	ra,16(sp)
200006fe:	c622                	sw	s0,12(sp)
20000700:	c426                	sw	s1,8(sp)
20000702:	200027b7          	lui	a5,0x20002
20000706:	9aa7ae23          	sw	a0,-1604(a5) # 200019bc <rf_2g4_mgr+0x4>
2000070a:	420007b7          	lui	a5,0x42000
2000070e:	4fbc                	lw	a5,88(a5)
20000710:	83a1                	srli	a5,a5,0x8
20000712:	8b85                	andi	a5,a5,1
20000714:	c7d1                	beqz	a5,200007a0 <omw_svc_2g4_set_access_word+0xa6>
20000716:	4401                	li	s0,0
20000718:	200004b7          	lui	s1,0x20000
2000071c:	200027b7          	lui	a5,0x20002
20000720:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
20000724:	c23e                	sw	a5,4(sp)
20000726:	0c44a783          	lw	a5,196(s1) # 200000c4 <reversed_access>
2000072a:	97a2                	add	a5,a5,s0
2000072c:	c03e                	sw	a5,0(sp)
2000072e:	4712                	lw	a4,4(sp)
20000730:	008707b3          	add	a5,a4,s0
20000734:	0047c503          	lbu	a0,4(a5)
20000738:	f0001097          	auipc	ra,0xf0001
2000073c:	1fe080e7          	jalr	510(ra) # 10001936 <reverse8>
20000740:	4782                	lw	a5,0(sp)
20000742:	00a78023          	sb	a0,0(a5)
20000746:	0405                	addi	s0,s0,1
20000748:	4791                	li	a5,4
2000074a:	fcf41ee3          	bne	s0,a5,20000726 <omw_svc_2g4_set_access_word+0x2c>
2000074e:	200007b7          	lui	a5,0x20000
20000752:	0c47a783          	lw	a5,196(a5) # 200000c4 <reversed_access>
20000756:	4398                	lw	a4,0(a5)
20000758:	420007b7          	lui	a5,0x42000
2000075c:	08e7a023          	sw	a4,128(a5) # 42000080 <__StackTop+0x21ffc080>
20000760:	200027b7          	lui	a5,0x20002
20000764:	9bc7c783          	lbu	a5,-1604(a5) # 200019bc <rf_2g4_mgr+0x4>
20000768:	8b85                	andi	a5,a5,1
2000076a:	40f007b3          	neg	a5,a5
2000076e:	fab7f793          	andi	a5,a5,-85
20000772:	0aa78793          	addi	a5,a5,170
20000776:	200026b7          	lui	a3,0x20002
2000077a:	9f468693          	addi	a3,a3,-1548 # 200019f4 <rf_2g4_preamble>
2000077e:	0ff7f793          	zext.b	a5,a5
20000782:	00879713          	slli	a4,a5,0x8
20000786:	97ba                	add	a5,a5,a4
20000788:	01079713          	slli	a4,a5,0x10
2000078c:	97ba                	add	a5,a5,a4
2000078e:	c29c                	sw	a5,0(a3)
20000790:	c2dc                	sw	a5,4(a3)
20000792:	c69c                	sw	a5,8(a3)
20000794:	c6dc                	sw	a5,12(a3)
20000796:	40c2                	lw	ra,16(sp)
20000798:	4432                	lw	s0,12(sp)
2000079a:	44a2                	lw	s1,8(sp)
2000079c:	0151                	addi	sp,sp,20
2000079e:	8082                	ret
200007a0:	420007b7          	lui	a5,0x42000
200007a4:	08a7a023          	sw	a0,128(a5) # 42000080 <__StackTop+0x21ffc080>
200007a8:	bf65                	j	20000760 <omw_svc_2g4_set_access_word+0x66>

200007aa <omw_svc_2g4_get_sync_time>:
200007aa:	420007b7          	lui	a5,0x42000
200007ae:	5fc8                	lw	a0,60(a5)
200007b0:	8082                	ret

200007b2 <omw_svc_2g4_get_pend_time>:
200007b2:	420007b7          	lui	a5,0x42000
200007b6:	43a8                	lw	a0,64(a5)
200007b8:	8082                	ret

200007ba <omw_svc_24g_is_txrx_idle>:
200007ba:	420007b7          	lui	a5,0x42000
200007be:	43c8                	lw	a0,4(a5)
200007c0:	8909                	andi	a0,a0,2
200007c2:	8082                	ret
200007c4:	8082                	ret
200007c6:	8082                	ret

200007c8 <omw_svc_24g_sync_end>:
200007c8:	8082                	ret

200007ca <RF_2G4_RADIO_Handler>:
200007ca:	1131                	addi	sp,sp,-20
200007cc:	c806                	sw	ra,16(sp)
200007ce:	c622                	sw	s0,12(sp)
200007d0:	c426                	sw	s1,8(sp)
200007d2:	420007b7          	lui	a5,0x42000
200007d6:	4705                	li	a4,1
200007d8:	06e78223          	sb	a4,100(a5) # 42000064 <__StackTop+0x21ffc064>
200007dc:	43c0                	lw	s0,4(a5)
200007de:	01041793          	slli	a5,s0,0x10
200007e2:	83c1                	srli	a5,a5,0x10
200007e4:	c23e                	sw	a5,4(sp)
200007e6:	00847493          	andi	s1,s0,8
200007ea:	00447793          	andi	a5,s0,4
200007ee:	c03e                	sw	a5,0(sp)
200007f0:	200007b7          	lui	a5,0x20000
200007f4:	0c07c783          	lbu	a5,192(a5) # 200000c0 <is_rx>
200007f8:	0ff7f793          	zext.b	a5,a5
200007fc:	c3e1                	beqz	a5,200008bc <RF_2G4_RADIO_Handler+0xf2>
200007fe:	200027b7          	lui	a5,0x20002
20000802:	9b27c783          	lbu	a5,-1614(a5) # 200019b2 <is_sync>
20000806:	0ff7f793          	zext.b	a5,a5
2000080a:	ebcd                	bnez	a5,200008bc <RF_2G4_RADIO_Handler+0xf2>
2000080c:	04049a63          	bnez	s1,20000860 <RF_2G4_RADIO_Handler+0x96>
20000810:	200027b7          	lui	a5,0x20002
20000814:	a807a823          	sw	zero,-1392(a5) # 20001a90 <rf_stop_desc>
20000818:	42001737          	lui	a4,0x42001
2000081c:	1e074783          	lbu	a5,480(a4) # 420011e0 <__StackTop+0x21ffd1e0>
20000820:	0ff7f793          	zext.b	a5,a5
20000824:	20002637          	lui	a2,0x20002
20000828:	a8f62a23          	sw	a5,-1388(a2) # 20001a94 <rssi>
2000082c:	1ec74783          	lbu	a5,492(a4)
20000830:	0ff7f793          	zext.b	a5,a5
20000834:	200026b7          	lui	a3,0x20002
20000838:	a8f6ac23          	sw	a5,-1384(a3) # 20001a98 <rx_gain>
2000083c:	00070023          	sb	zero,0(a4)
20000840:	420007b7          	lui	a5,0x42000
20000844:	08078223          	sb	zero,132(a5) # 42000084 <__StackTop+0x21ffc084>
20000848:	200027b7          	lui	a5,0x20002
2000084c:	a8c7c783          	lbu	a5,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
20000850:	4705                	li	a4,1
20000852:	0ae79863          	bne	a5,a4,20000902 <RF_2G4_RADIO_Handler+0x138>
20000856:	200027b7          	lui	a5,0x20002
2000085a:	a8078623          	sb	zero,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
2000085e:	a8f1                	j	2000093a <RF_2G4_RADIO_Handler+0x170>
20000860:	37a5                	jal	200007c8 <omw_svc_24g_sync_end>
20000862:	200027b7          	lui	a5,0x20002
20000866:	4705                	li	a4,1
20000868:	9ae78923          	sb	a4,-1614(a5) # 200019b2 <is_sync>
2000086c:	4792                	lw	a5,4(sp)
2000086e:	8b89                	andi	a5,a5,2
20000870:	10078163          	beqz	a5,20000972 <RF_2G4_RADIO_Handler+0x1a8>
20000874:	200027b7          	lui	a5,0x20002
20000878:	a807a823          	sw	zero,-1392(a5) # 20001a90 <rf_stop_desc>
2000087c:	42001737          	lui	a4,0x42001
20000880:	1e074783          	lbu	a5,480(a4) # 420011e0 <__StackTop+0x21ffd1e0>
20000884:	0ff7f793          	zext.b	a5,a5
20000888:	20002637          	lui	a2,0x20002
2000088c:	a8f62a23          	sw	a5,-1388(a2) # 20001a94 <rssi>
20000890:	1ec74783          	lbu	a5,492(a4)
20000894:	0ff7f793          	zext.b	a5,a5
20000898:	200026b7          	lui	a3,0x20002
2000089c:	a8f6ac23          	sw	a5,-1384(a3) # 20001a98 <rx_gain>
200008a0:	00070023          	sb	zero,0(a4)
200008a4:	420007b7          	lui	a5,0x42000
200008a8:	08078223          	sb	zero,132(a5) # 42000084 <__StackTop+0x21ffc084>
200008ac:	200027b7          	lui	a5,0x20002
200008b0:	a8c7c783          	lbu	a5,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
200008b4:	4705                	li	a4,1
200008b6:	04e79663          	bne	a5,a4,20000902 <RF_2G4_RADIO_Handler+0x138>
200008ba:	a0ad                	j	20000924 <RF_2G4_RADIO_Handler+0x15a>
200008bc:	200027b7          	lui	a5,0x20002
200008c0:	a807a823          	sw	zero,-1392(a5) # 20001a90 <rf_stop_desc>
200008c4:	42001737          	lui	a4,0x42001
200008c8:	1e074783          	lbu	a5,480(a4) # 420011e0 <__StackTop+0x21ffd1e0>
200008cc:	0ff7f793          	zext.b	a5,a5
200008d0:	20002637          	lui	a2,0x20002
200008d4:	a8f62a23          	sw	a5,-1388(a2) # 20001a94 <rssi>
200008d8:	1ec74783          	lbu	a5,492(a4)
200008dc:	0ff7f793          	zext.b	a5,a5
200008e0:	200026b7          	lui	a3,0x20002
200008e4:	a8f6ac23          	sw	a5,-1384(a3) # 20001a98 <rx_gain>
200008e8:	00070023          	sb	zero,0(a4)
200008ec:	420007b7          	lui	a5,0x42000
200008f0:	08078223          	sb	zero,132(a5) # 42000084 <__StackTop+0x21ffc084>
200008f4:	200027b7          	lui	a5,0x20002
200008f8:	a8c7c783          	lbu	a5,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
200008fc:	4705                	li	a4,1
200008fe:	02e78263          	beq	a5,a4,20000922 <RF_2G4_RADIO_Handler+0x158>
20000902:	4709                	li	a4,2
20000904:	06e78c63          	beq	a5,a4,2000097c <RF_2G4_RADIO_Handler+0x1b2>
20000908:	470d                	li	a4,3
2000090a:	08e78763          	beq	a5,a4,20000998 <RF_2G4_RADIO_Handler+0x1ce>
2000090e:	200027b7          	lui	a5,0x20002
20000912:	9ca7c783          	lbu	a5,-1590(a5) # 200019ca <rf_2g4_mgr+0x12>
20000916:	c7dd                	beqz	a5,200009c4 <RF_2G4_RADIO_Handler+0x1fa>
20000918:	0a048e63          	beqz	s1,200009d4 <RF_2G4_RADIO_Handler+0x20a>
2000091c:	4782                	lw	a5,0(sp)
2000091e:	ebdd                	bnez	a5,200009d4 <RF_2G4_RADIO_Handler+0x20a>
20000920:	a05d                	j	200009c6 <RF_2G4_RADIO_Handler+0x1fc>
20000922:	d895                	beqz	s1,20000856 <RF_2G4_RADIO_Handler+0x8c>
20000924:	200027b7          	lui	a5,0x20002
20000928:	a8078623          	sb	zero,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
2000092c:	200027b7          	lui	a5,0x20002
20000930:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
20000934:	4705                	li	a4,1
20000936:	02e78823          	sb	a4,48(a5)
2000093a:	200027b7          	lui	a5,0x20002
2000093e:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
20000942:	020787a3          	sb	zero,47(a5)
20000946:	200007b7          	lui	a5,0x20000
2000094a:	0c07c783          	lbu	a5,192(a5) # 200000c0 <is_rx>
2000094e:	0ff7f793          	zext.b	a5,a5
20000952:	cba1                	beqz	a5,200009a2 <RF_2G4_RADIO_Handler+0x1d8>
20000954:	200007b7          	lui	a5,0x20000
20000958:	0c078023          	sb	zero,192(a5) # 200000c0 <is_rx>
2000095c:	00847513          	andi	a0,s0,8
20000960:	147000ef          	jal	200012a6 <dynamic_agc_info_get2>
20000964:	4505                	li	a0,1
20000966:	c481                	beqz	s1,2000096e <RF_2G4_RADIO_Handler+0x1a4>
20000968:	4782                	lw	a5,0(sp)
2000096a:	00f03533          	snez	a0,a5
2000096e:	569000ef          	jal	200016d6 <omw_svc_24g_rx_end>
20000972:	40c2                	lw	ra,16(sp)
20000974:	4432                	lw	s0,12(sp)
20000976:	44a2                	lw	s1,8(sp)
20000978:	0151                	addi	sp,sp,20
2000097a:	8082                	ret
2000097c:	200027b7          	lui	a5,0x20002
20000980:	9ca7c783          	lbu	a5,-1590(a5) # 200019ca <rf_2g4_mgr+0x12>
20000984:	c395                	beqz	a5,200009a8 <RF_2G4_RADIO_Handler+0x1de>
20000986:	00048463          	beqz	s1,2000098e <RF_2G4_RADIO_Handler+0x1c4>
2000098a:	4782                	lw	a5,0(sp)
2000098c:	cf99                	beqz	a5,200009aa <RF_2G4_RADIO_Handler+0x1e0>
2000098e:	200027b7          	lui	a5,0x20002
20000992:	a8078623          	sb	zero,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
20000996:	b755                	j	2000093a <RF_2G4_RADIO_Handler+0x170>
20000998:	200027b7          	lui	a5,0x20002
2000099c:	a8078623          	sb	zero,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
200009a0:	bf69                	j	2000093a <RF_2G4_RADIO_Handler+0x170>
200009a2:	521000ef          	jal	200016c2 <omw_svc_24g_tx_end>
200009a6:	b7f1                	j	20000972 <RF_2G4_RADIO_Handler+0x1a8>
200009a8:	d0fd                	beqz	s1,2000098e <RF_2G4_RADIO_Handler+0x1c4>
200009aa:	200027b7          	lui	a5,0x20002
200009ae:	470d                	li	a4,3
200009b0:	a8e78623          	sb	a4,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
200009b4:	200027b7          	lui	a5,0x20002
200009b8:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
200009bc:	4705                	li	a4,1
200009be:	02e78823          	sb	a4,48(a5)
200009c2:	b751                	j	20000946 <RF_2G4_RADIO_Handler+0x17c>
200009c4:	c881                	beqz	s1,200009d4 <RF_2G4_RADIO_Handler+0x20a>
200009c6:	200027b7          	lui	a5,0x20002
200009ca:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
200009ce:	4705                	li	a4,1
200009d0:	02e78823          	sb	a4,48(a5)
200009d4:	200027b7          	lui	a5,0x20002
200009d8:	a8c7c783          	lbu	a5,-1396(a5) # 20001a8c <rf_2g4_wait_ack>
200009dc:	f7ad                	bnez	a5,20000946 <RF_2G4_RADIO_Handler+0x17c>
200009de:	bfb1                	j	2000093a <RF_2G4_RADIO_Handler+0x170>

200009e0 <omw_svc_2g4_rx_data>:
200009e0:	1151                	addi	sp,sp,-12
200009e2:	c406                	sw	ra,8(sp)
200009e4:	c222                	sw	s0,4(sp)
200009e6:	c026                	sw	s1,0(sp)
200009e8:	87ae                	mv	a5,a1
200009ea:	4405                	li	s0,1
200009ec:	20002737          	lui	a4,0x20002
200009f0:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
200009f4:	028707a3          	sb	s0,47(a4)
200009f8:	20000737          	lui	a4,0x20000
200009fc:	0c870023          	sb	s0,192(a4) # 200000c0 <is_rx>
20000a00:	20002737          	lui	a4,0x20002
20000a04:	9a070923          	sb	zero,-1614(a4) # 200019b2 <is_sync>
20000a08:	20002737          	lui	a4,0x20002
20000a0c:	9ac74703          	lbu	a4,-1620(a4) # 200019ac <autolen_pkt_desc_offset>
20000a10:	0709                	addi	a4,a4,2
20000a12:	0ff77713          	zext.b	a4,a4
20000a16:	00371593          	slli	a1,a4,0x3
20000a1a:	20002737          	lui	a4,0x20002
20000a1e:	a0470713          	addi	a4,a4,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
20000a22:	972e                	add	a4,a4,a1
20000a24:	c308                	sw	a0,0(a4)
20000a26:	078e                	slli	a5,a5,0x3
20000a28:	17fd                	addi	a5,a5,-1
20000a2a:	07c2                	slli	a5,a5,0x10
20000a2c:	00475583          	lhu	a1,4(a4)
20000a30:	8fcd                	or	a5,a5,a1
20000a32:	c35c                	sw	a5,4(a4)
20000a34:	06c2                	slli	a3,a3,0x10
20000a36:	82c1                	srli	a3,a3,0x10
20000a38:	420004b7          	lui	s1,0x42000
20000a3c:	00d49a23          	sh	a3,20(s1) # 42000014 <__StackTop+0x21ffc014>
20000a40:	85b2                	mv	a1,a2
20000a42:	20000537          	lui	a0,0x20000
20000a46:	3b050513          	addi	a0,a0,944 # 200003b0 <rf_common_desc_rx_setfreq>
20000a4a:	2475                	jal	20000cf6 <RADIO_CommonDescInit_SetFreq>
20000a4c:	20002737          	lui	a4,0x20002
20000a50:	200007b7          	lui	a5,0x20000
20000a54:	16878793          	addi	a5,a5,360 # 20000168 <rf_call_desc_list_rx_process+0x38>
20000a58:	a8f72823          	sw	a5,-1392(a4) # 20001a90 <rf_stop_desc>
20000a5c:	200007b7          	lui	a5,0x20000
20000a60:	0c878793          	addi	a5,a5,200 # 200000c8 <rf_2g4_call_desc_list_rx>
20000a64:	c4dc                	sw	a5,12(s1)
20000a66:	c080                	sw	s0,0(s1)
20000a68:	40a2                	lw	ra,8(sp)
20000a6a:	4412                	lw	s0,4(sp)
20000a6c:	4482                	lw	s1,0(sp)
20000a6e:	0131                	addi	sp,sp,12
20000a70:	8082                	ret

20000a72 <omw_svc_2g4_tx_data>:
20000a72:	1151                	addi	sp,sp,-12
20000a74:	c406                	sw	ra,8(sp)
20000a76:	c222                	sw	s0,4(sp)
20000a78:	c026                	sw	s1,0(sp)
20000a7a:	8436                	mv	s0,a3
20000a7c:	4485                	li	s1,1
20000a7e:	20002737          	lui	a4,0x20002
20000a82:	9b870713          	addi	a4,a4,-1608 # 200019b8 <rf_2g4_mgr>
20000a86:	029707a3          	sb	s1,47(a4)
20000a8a:	20000737          	lui	a4,0x20000
20000a8e:	0c070023          	sb	zero,192(a4) # 200000c0 <is_rx>
20000a92:	20002737          	lui	a4,0x20002
20000a96:	9ac74703          	lbu	a4,-1620(a4) # 200019ac <autolen_pkt_desc_offset>
20000a9a:	0709                	addi	a4,a4,2
20000a9c:	0ff77713          	zext.b	a4,a4
20000aa0:	200026b7          	lui	a3,0x20002
20000aa4:	a4b69423          	sh	a1,-1464(a3) # 20001a48 <rf_2g4_trans_len>
20000aa8:	00371693          	slli	a3,a4,0x3
20000aac:	20002737          	lui	a4,0x20002
20000ab0:	a4c70713          	addi	a4,a4,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
20000ab4:	9736                	add	a4,a4,a3
20000ab6:	c308                	sw	a0,0(a4)
20000ab8:	00359793          	slli	a5,a1,0x3
20000abc:	17fd                	addi	a5,a5,-1
20000abe:	07c2                	slli	a5,a5,0x10
20000ac0:	00475683          	lhu	a3,4(a4)
20000ac4:	8fd5                	or	a5,a5,a3
20000ac6:	c35c                	sw	a5,4(a4)
20000ac8:	85b2                	mv	a1,a2
20000aca:	20000537          	lui	a0,0x20000
20000ace:	44050513          	addi	a0,a0,1088 # 20000440 <rf_common_desc_tx_setfreq>
20000ad2:	2415                	jal	20000cf6 <RADIO_CommonDescInit_SetFreq>
20000ad4:	20002737          	lui	a4,0x20002
20000ad8:	200007b7          	lui	a5,0x20000
20000adc:	1d878793          	addi	a5,a5,472 # 200001d8 <rf_call_desc_list_tx_process+0x48>
20000ae0:	a8f72823          	sw	a5,-1392(a4) # 20001a90 <rf_stop_desc>
20000ae4:	0442                	slli	s0,s0,0x10
20000ae6:	8041                	srli	s0,s0,0x10
20000ae8:	420007b7          	lui	a5,0x42000
20000aec:	00879a23          	sh	s0,20(a5) # 42000014 <__StackTop+0x21ffc014>
20000af0:	20000737          	lui	a4,0x20000
20000af4:	0f870713          	addi	a4,a4,248 # 200000f8 <rf_2g4_call_desc_list_tx>
20000af8:	c7d8                	sw	a4,12(a5)
20000afa:	30047473          	csrrci	s0,mstatus,8
20000afe:	c384                	sw	s1,0(a5)
20000b00:	2119                	jal	20000f06 <calc_hp_offset_at_curr_temp>
20000b02:	30041073          	csrw	mstatus,s0
20000b06:	40a2                	lw	ra,8(sp)
20000b08:	4412                	lw	s0,4(sp)
20000b0a:	4482                	lw	s1,0(sp)
20000b0c:	0131                	addi	sp,sp,12
20000b0e:	8082                	ret

20000b10 <omw_svc_2g4_en_whiten_tx>:
20000b10:	1151                	addi	sp,sp,-12
20000b12:	c406                	sw	ra,8(sp)
20000b14:	86aa                	mv	a3,a0
20000b16:	200027b7          	lui	a5,0x20002
20000b1a:	9af7c603          	lbu	a2,-1617(a5) # 200019af <cur_whiten_desc_tx_ed>
20000b1e:	200027b7          	lui	a5,0x20002
20000b22:	9b07c583          	lbu	a1,-1616(a5) # 200019b0 <cur_whiten_desc_tx_st>
20000b26:	20002537          	lui	a0,0x20002
20000b2a:	a4c50513          	addi	a0,a0,-1460 # 20001a4c <rf_2g4_tx_pkt_desc>
20000b2e:	3671                	jal	200006ba <omw_svc_2g4_mdf_whiten_desc>
20000b30:	40a2                	lw	ra,8(sp)
20000b32:	0131                	addi	sp,sp,12
20000b34:	8082                	ret

20000b36 <omw_svc_2g4_en_whiten_rx>:
20000b36:	1151                	addi	sp,sp,-12
20000b38:	c406                	sw	ra,8(sp)
20000b3a:	86aa                	mv	a3,a0
20000b3c:	200027b7          	lui	a5,0x20002
20000b40:	9ad7c603          	lbu	a2,-1619(a5) # 200019ad <cur_whiten_desc_rx_ed>
20000b44:	200027b7          	lui	a5,0x20002
20000b48:	9ae7c583          	lbu	a1,-1618(a5) # 200019ae <cur_whiten_desc_rx_st>
20000b4c:	20002537          	lui	a0,0x20002
20000b50:	a0450513          	addi	a0,a0,-1532 # 20001a04 <rf_2g4_rx_pkt_desc>
20000b54:	369d                	jal	200006ba <omw_svc_2g4_mdf_whiten_desc>
20000b56:	40a2                	lw	ra,8(sp)
20000b58:	0131                	addi	sp,sp,12
20000b5a:	8082                	ret

20000b5c <omw_svc_2g4_set_idle>:
20000b5c:	30047073          	csrci	mstatus,8
20000b60:	20002737          	lui	a4,0x20002
20000b64:	9b170793          	addi	a5,a4,-1615 # 200019b1 <is_dma_busy>
20000b68:	0007c783          	lbu	a5,0(a5)
20000b6c:	0ff7f793          	zext.b	a5,a5
20000b70:	fbf5                	bnez	a5,20000b64 <omw_svc_2g4_set_idle+0x8>
20000b72:	420007b7          	lui	a5,0x42000
20000b76:	4709                	li	a4,2
20000b78:	c398                	sw	a4,0(a5)
20000b7a:	4705                	li	a4,1
20000b7c:	06e78223          	sb	a4,100(a5) # 42000064 <__StackTop+0x21ffc064>
20000b80:	200027b7          	lui	a5,0x20002
20000b84:	a907a503          	lw	a0,-1392(a5) # 20001a90 <rf_stop_desc>
20000b88:	c50d                	beqz	a0,20000bb2 <omw_svc_2g4_set_idle+0x56>
20000b8a:	1151                	addi	sp,sp,-12
20000b8c:	c406                	sw	ra,8(sp)
20000b8e:	26b1                	jal	20000eda <start_await_dma>
20000b90:	200027b7          	lui	a5,0x20002
20000b94:	a807a823          	sw	zero,-1392(a5) # 20001a90 <rf_stop_desc>
20000b98:	30046073          	csrsi	mstatus,8
20000b9c:	200027b7          	lui	a5,0x20002
20000ba0:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
20000ba4:	020787a3          	sb	zero,47(a5)
20000ba8:	02078823          	sb	zero,48(a5)
20000bac:	40a2                	lw	ra,8(sp)
20000bae:	0131                	addi	sp,sp,12
20000bb0:	8082                	ret
20000bb2:	30046073          	csrsi	mstatus,8
20000bb6:	200027b7          	lui	a5,0x20002
20000bba:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
20000bbe:	020787a3          	sb	zero,47(a5)
20000bc2:	02078823          	sb	zero,48(a5)
20000bc6:	8082                	ret

20000bc8 <RADIO_DescInit_Freq>:
20000bc8:	1141                	addi	sp,sp,-16
20000bca:	c606                	sw	ra,12(sp)
20000bcc:	c422                	sw	s0,8(sp)
20000bce:	c226                	sw	s1,4(sp)
20000bd0:	84aa                	mv	s1,a0
20000bd2:	00b5d713          	srli	a4,a1,0xb
20000bd6:	06400793          	li	a5,100
20000bda:	02f707b3          	mul	a5,a4,a5
20000bde:	e399                	bnez	a5,20000be4 <RADIO_DescInit_Freq+0x1c>
20000be0:	3e800793          	li	a5,1000
20000be4:	7ff5f593          	andi	a1,a1,2047
20000be8:	02f58533          	mul	a0,a1,a5
20000bec:	670d                	lui	a4,0x3
20000bee:	ee070713          	addi	a4,a4,-288 # 2ee0 <app_remoter.c.bf7187db+0x3b2>
20000bf2:	02e54433          	div	s0,a0,a4
20000bf6:	0c540413          	addi	s0,s0,197
20000bfa:	0442                	slli	s0,s0,0x10
20000bfc:	8041                	srli	s0,s0,0x10
20000bfe:	02f74733          	div	a4,a4,a5
20000c02:	02e5e5b3          	rem	a1,a1,a4
20000c06:	02f585b3          	mul	a1,a1,a5
20000c0a:	67d5                	lui	a5,0x15
20000c0c:	55578793          	addi	a5,a5,1365 # 15555 <ble_viot.c.543f92a8+0xcecc>
20000c10:	02f585b3          	mul	a1,a1,a5
20000c14:	3e800793          	li	a5,1000
20000c18:	02f5c7b3          	div	a5,a1,a5
20000c1c:	c03e                	sw	a5,0(sp)
20000c1e:	200007b7          	lui	a5,0x20000
20000c22:	3b078793          	addi	a5,a5,944 # 200003b0 <rf_common_desc_rx_setfreq>
20000c26:	04f48c63          	beq	s1,a5,20000c7e <RADIO_DescInit_Freq+0xb6>
20000c2a:	200027b7          	lui	a5,0x20002
20000c2e:	9ba7c703          	lbu	a4,-1606(a5) # 200019ba <rf_2g4_mgr+0x2>
20000c32:	7d000793          	li	a5,2000
20000c36:	02f54533          	div	a0,a0,a5
20000c3a:	ffe70793          	addi	a5,a4,-2
20000c3e:	0ff7f793          	zext.b	a5,a5
20000c42:	4685                	li	a3,1
20000c44:	4581                	li	a1,0
20000c46:	00f6f963          	bgeu	a3,a5,20000c58 <RADIO_DescInit_Freq+0x90>
20000c4a:	85ba                	mv	a1,a4
20000c4c:	4789                	li	a5,2
20000c4e:	00e7f363          	bgeu	a5,a4,20000c54 <RADIO_DescInit_Freq+0x8c>
20000c52:	4589                	li	a1,2
20000c54:	0ff5f593          	zext.b	a1,a1
20000c58:	0ff57513          	zext.b	a0,a0
20000c5c:	2e61                	jal	20000ff4 <RF_OnChip_Cfg_KVCO_Cal_val>
20000c5e:	4681                	li	a3,0
20000c60:	4701                	li	a4,0
20000c62:	01441793          	slli	a5,s0,0x14
20000c66:	4602                	lw	a2,0(sp)
20000c68:	8fd1                	or	a5,a5,a2
20000c6a:	8f99                	sub	a5,a5,a4
20000c6c:	8385                	srli	a5,a5,0x1
20000c6e:	8fd5                	or	a5,a5,a3
20000c70:	c09c                	sw	a5,0(s1)
20000c72:	8526                	mv	a0,s1
20000c74:	40b2                	lw	ra,12(sp)
20000c76:	4422                	lw	s0,8(sp)
20000c78:	4492                	lw	s1,4(sp)
20000c7a:	0141                	addi	sp,sp,16
20000c7c:	8082                	ret
20000c7e:	200027b7          	lui	a5,0x20002
20000c82:	9ba7c703          	lbu	a4,-1606(a5) # 200019ba <rf_2g4_mgr+0x2>
20000c86:	4785                	li	a5,1
20000c88:	02f70f63          	beq	a4,a5,20000cc6 <RADIO_DescInit_Freq+0xfe>
20000c8c:	420026b7          	lui	a3,0x42002
20000c90:	0cc6a783          	lw	a5,204(a3) # 420020cc <__StackTop+0x21ffe0cc>
20000c94:	ffd00737          	lui	a4,0xffd00
20000c98:	cff70713          	addi	a4,a4,-769 # ffcffcff <__StackTop+0xdfcfbcff>
20000c9c:	8ff9                	and	a5,a5,a4
20000c9e:	00300737          	lui	a4,0x300
20000ca2:	30070713          	addi	a4,a4,768 # 300300 <__ROM_SIZE+0x2c0300>
20000ca6:	8fd9                	or	a5,a5,a4
20000ca8:	0cf6a623          	sw	a5,204(a3)
20000cac:	200027b7          	lui	a5,0x20002
20000cb0:	9ba7c703          	lbu	a4,-1606(a5) # 200019ba <rf_2g4_mgr+0x2>
20000cb4:	4785                	li	a5,1
20000cb6:	02f70963          	beq	a4,a5,20000ce8 <RADIO_DescInit_Freq+0x120>
20000cba:	800006b7          	lui	a3,0x80000
20000cbe:	6755                	lui	a4,0x15
20000cc0:	55570713          	addi	a4,a4,1365 # 15555 <ble_viot.c.543f92a8+0xcecc>
20000cc4:	bf79                	j	20000c62 <RADIO_DescInit_Freq+0x9a>
20000cc6:	420026b7          	lui	a3,0x42002
20000cca:	0cc6a783          	lw	a5,204(a3) # 420020cc <__StackTop+0x21ffe0cc>
20000cce:	ffd00737          	lui	a4,0xffd00
20000cd2:	cff70713          	addi	a4,a4,-769 # ffcffcff <__StackTop+0xdfcfbcff>
20000cd6:	8ff9                	and	a5,a5,a4
20000cd8:	00300737          	lui	a4,0x300
20000cdc:	30070713          	addi	a4,a4,768 # 300300 <__ROM_SIZE+0x2c0300>
20000ce0:	8fd9                	or	a5,a5,a4
20000ce2:	0cf6a623          	sw	a5,204(a3)
20000ce6:	b7d9                	j	20000cac <RADIO_DescInit_Freq+0xe4>
20000ce8:	800006b7          	lui	a3,0x80000
20000cec:	0002b737          	lui	a4,0x2b
20000cf0:	aab70713          	addi	a4,a4,-1365 # 2aaab <ble_viot.c.543f92a8+0x22422>
20000cf4:	b7bd                	j	20000c62 <RADIO_DescInit_Freq+0x9a>

20000cf6 <RADIO_CommonDescInit_SetFreq>:
20000cf6:	1151                	addi	sp,sp,-12
20000cf8:	c406                	sw	ra,8(sp)
20000cfa:	4601                	li	a2,0
20000cfc:	35f1                	jal	20000bc8 <RADIO_DescInit_Freq>
20000cfe:	40a2                	lw	ra,8(sp)
20000d00:	0131                	addi	sp,sp,12
20000d02:	8082                	ret

20000d04 <omw_rf_set_high_perf_apply>:
20000d04:	200027b7          	lui	a5,0x20002
20000d08:	ae97c783          	lbu	a5,-1303(a5) # 20001ae9 <is_high_perf>
20000d0c:	0ff7f793          	zext.b	a5,a5
20000d10:	c7c5                	beqz	a5,20000db8 <omw_rf_set_high_perf_apply+0xb4>
20000d12:	200027b7          	lui	a5,0x20002
20000d16:	ae87c783          	lbu	a5,-1304(a5) # 20001ae8 <is_add_rf_aon_adda_vc>
20000d1a:	ef99                	bnez	a5,20000d38 <omw_rf_set_high_perf_apply+0x34>
20000d1c:	200027b7          	lui	a5,0x20002
20000d20:	aec78793          	addi	a5,a5,-1300 # 20001aec <g_rf_cfg>
20000d24:	0057c703          	lbu	a4,5(a5)
20000d28:	0709                	addi	a4,a4,2
20000d2a:	00e782a3          	sb	a4,5(a5)
20000d2e:	200027b7          	lui	a5,0x20002
20000d32:	4705                	li	a4,1
20000d34:	aee78423          	sb	a4,-1304(a5) # 20001ae8 <is_add_rf_aon_adda_vc>
20000d38:	420027b7          	lui	a5,0x42002
20000d3c:	57b8                	lw	a4,104(a5)
20000d3e:	9b41                	andi	a4,a4,-16
20000d40:	00476713          	ori	a4,a4,4
20000d44:	d7b8                	sw	a4,104(a5)
20000d46:	57f8                	lw	a4,108(a5)
20000d48:	9b41                	andi	a4,a4,-16
20000d4a:	00776713          	ori	a4,a4,7
20000d4e:	d7f8                	sw	a4,108(a5)
20000d50:	5bb8                	lw	a4,112(a5)
20000d52:	9b41                	andi	a4,a4,-16
20000d54:	00776713          	ori	a4,a4,7
20000d58:	dbb8                	sw	a4,112(a5)
20000d5a:	5bf8                	lw	a4,116(a5)
20000d5c:	9b41                	andi	a4,a4,-16
20000d5e:	00776713          	ori	a4,a4,7
20000d62:	dbf8                	sw	a4,116(a5)
20000d64:	5fb8                	lw	a4,120(a5)
20000d66:	9b41                	andi	a4,a4,-16
20000d68:	00776713          	ori	a4,a4,7
20000d6c:	dfb8                	sw	a4,120(a5)
20000d6e:	5ff0                	lw	a2,124(a5)
20000d70:	76fd                	lui	a3,0xfffff
20000d72:	0ff68693          	addi	a3,a3,255 # fffff0ff <__StackTop+0xdfffb0ff>
20000d76:	8e75                	and	a2,a2,a3
20000d78:	6705                	lui	a4,0x1
20000d7a:	80070713          	addi	a4,a4,-2048 # 800 <__STACK_SIZE+0x500>
20000d7e:	8e59                	or	a2,a2,a4
20000d80:	dff0                	sw	a2,124(a5)
20000d82:	0807a603          	lw	a2,128(a5) # 42002080 <__StackTop+0x21ffe080>
20000d86:	8e75                	and	a2,a2,a3
20000d88:	8e59                	or	a2,a2,a4
20000d8a:	08c7a023          	sw	a2,128(a5)
20000d8e:	0847a603          	lw	a2,132(a5)
20000d92:	8e75                	and	a2,a2,a3
20000d94:	8e59                	or	a2,a2,a4
20000d96:	08c7a223          	sw	a2,132(a5)
20000d9a:	0887a603          	lw	a2,136(a5)
20000d9e:	8ef1                	and	a3,a3,a2
20000da0:	8f55                	or	a4,a4,a3
20000da2:	08e7a423          	sw	a4,136(a5)
20000da6:	0c87a703          	lw	a4,200(a5)
20000daa:	8ff77713          	andi	a4,a4,-1793
20000dae:	20076713          	ori	a4,a4,512
20000db2:	0ce7a423          	sw	a4,200(a5)
20000db6:	8082                	ret
20000db8:	420027b7          	lui	a5,0x42002
20000dbc:	57b8                	lw	a4,104(a5)
20000dbe:	9b41                	andi	a4,a4,-16
20000dc0:	00476713          	ori	a4,a4,4
20000dc4:	d7b8                	sw	a4,104(a5)
20000dc6:	57f8                	lw	a4,108(a5)
20000dc8:	9b41                	andi	a4,a4,-16
20000dca:	00776713          	ori	a4,a4,7
20000dce:	d7f8                	sw	a4,108(a5)
20000dd0:	5bb8                	lw	a4,112(a5)
20000dd2:	9b41                	andi	a4,a4,-16
20000dd4:	00776713          	ori	a4,a4,7
20000dd8:	dbb8                	sw	a4,112(a5)
20000dda:	5bf8                	lw	a4,116(a5)
20000ddc:	9b41                	andi	a4,a4,-16
20000dde:	00776713          	ori	a4,a4,7
20000de2:	dbf8                	sw	a4,116(a5)
20000de4:	5fb8                	lw	a4,120(a5)
20000de6:	9b41                	andi	a4,a4,-16
20000de8:	00776713          	ori	a4,a4,7
20000dec:	dfb8                	sw	a4,120(a5)
20000dee:	5ff4                	lw	a3,124(a5)
20000df0:	777d                	lui	a4,0xfffff
20000df2:	0ff70713          	addi	a4,a4,255 # fffff0ff <__StackTop+0xdfffb0ff>
20000df6:	8ef9                	and	a3,a3,a4
20000df8:	2006e693          	ori	a3,a3,512
20000dfc:	dff4                	sw	a3,124(a5)
20000dfe:	0807a683          	lw	a3,128(a5) # 42002080 <__StackTop+0x21ffe080>
20000e02:	8ef9                	and	a3,a3,a4
20000e04:	2006e693          	ori	a3,a3,512
20000e08:	08d7a023          	sw	a3,128(a5)
20000e0c:	0847a683          	lw	a3,132(a5)
20000e10:	8ef9                	and	a3,a3,a4
20000e12:	2006e693          	ori	a3,a3,512
20000e16:	08d7a223          	sw	a3,132(a5)
20000e1a:	0887a683          	lw	a3,136(a5)
20000e1e:	8f75                	and	a4,a4,a3
20000e20:	20076713          	ori	a4,a4,512
20000e24:	08e7a423          	sw	a4,136(a5)
20000e28:	0c87a703          	lw	a4,200(a5)
20000e2c:	8ff77713          	andi	a4,a4,-1793
20000e30:	20076713          	ori	a4,a4,512
20000e34:	0ce7a423          	sw	a4,200(a5)
20000e38:	8082                	ret

20000e3a <_rf_kvco_read_y>:
20000e3a:	1151                	addi	sp,sp,-12
20000e3c:	c406                	sw	ra,8(sp)
20000e3e:	c222                	sw	s0,4(sp)
20000e40:	42002437          	lui	s0,0x42002
20000e44:	0cc42783          	lw	a5,204(s0) # 420020cc <__StackTop+0x21ffe0cc>
20000e48:	10000737          	lui	a4,0x10000
20000e4c:	8fd9                	or	a5,a5,a4
20000e4e:	0cf42623          	sw	a5,204(s0)
20000e52:	0cc42783          	lw	a5,204(s0)
20000e56:	f0000737          	lui	a4,0xf0000
20000e5a:	177d                	addi	a4,a4,-1 # efffffff <__StackTop+0xcfffbfff>
20000e5c:	8ff9                	and	a5,a5,a4
20000e5e:	0cf42623          	sw	a5,204(s0)
20000e62:	4785                	li	a5,1
20000e64:	cc1c                	sw	a5,24(s0)
20000e66:	4795                	li	a5,5
20000e68:	cc1c                	sw	a5,24(s0)
20000e6a:	03000793          	li	a5,48
20000e6e:	02f55533          	divu	a0,a0,a5
20000e72:	0515                	addi	a0,a0,5
20000e74:	0542                	slli	a0,a0,0x10
20000e76:	8141                	srli	a0,a0,0x10
20000e78:	80fff0ef          	jal	20000686 <delay_us>
20000e7c:	0f042503          	lw	a0,240(s0)
20000e80:	052e                	slli	a0,a0,0xb
20000e82:	812d                	srli	a0,a0,0xb
20000e84:	40a2                	lw	ra,8(sp)
20000e86:	4412                	lw	s0,4(sp)
20000e88:	0131                	addi	sp,sp,12
20000e8a:	8082                	ret

20000e8c <trigger_gpadc_temp_sampling>:
20000e8c:	1151                	addi	sp,sp,-12
20000e8e:	c406                	sw	ra,8(sp)
20000e90:	c222                	sw	s0,4(sp)
20000e92:	420027b7          	lui	a5,0x42002
20000e96:	43d8                	lw	a4,4(a5)
20000e98:	00176713          	ori	a4,a4,1
20000e9c:	c3d8                	sw	a4,4(a5)
20000e9e:	40040437          	lui	s0,0x40040
20000ea2:	4709                	li	a4,2
20000ea4:	c018                	sw	a4,0(s0)
20000ea6:	0e87a703          	lw	a4,232(a5) # 420020e8 <__StackTop+0x21ffe0e8>
20000eaa:	00176713          	ori	a4,a4,1
20000eae:	0ee7a423          	sw	a4,232(a5)
20000eb2:	08800793          	li	a5,136
20000eb6:	c05c                	sw	a5,4(s0)
20000eb8:	6791                	lui	a5,0x4
20000eba:	0789                	addi	a5,a5,2 # 4002 <__RAM_SIZE+0x2>
20000ebc:	d03c                	sw	a5,96(s0)
20000ebe:	30f00793          	li	a5,783
20000ec2:	d83c                	sw	a5,112(s0)
20000ec4:	4511                	li	a0,4
20000ec6:	fc0ff0ef          	jal	20000686 <delay_us>
20000eca:	800047b7          	lui	a5,0x80004
20000ece:	0789                	addi	a5,a5,2 # 80004002 <__StackTop+0x60000002>
20000ed0:	d03c                	sw	a5,96(s0)
20000ed2:	40a2                	lw	ra,8(sp)
20000ed4:	4412                	lw	s0,4(sp)
20000ed6:	0131                	addi	sp,sp,12
20000ed8:	8082                	ret

20000eda <start_await_dma>:
20000eda:	420007b7          	lui	a5,0x42000
20000ede:	06078023          	sb	zero,96(a5) # 42000060 <__StackTop+0x21ffc060>
20000ee2:	c7c8                	sw	a0,12(a5)
20000ee4:	4705                	li	a4,1
20000ee6:	c398                	sw	a4,0(a5)
20000ee8:	42000737          	lui	a4,0x42000
20000eec:	06474783          	lbu	a5,100(a4) # 42000064 <__StackTop+0x21ffc064>
20000ef0:	0ff7f793          	zext.b	a5,a5
20000ef4:	dfe5                	beqz	a5,20000eec <start_await_dma+0x12>
20000ef6:	420007b7          	lui	a5,0x42000
20000efa:	4705                	li	a4,1
20000efc:	06e78223          	sb	a4,100(a5) # 42000064 <__StackTop+0x21ffc064>
20000f00:	06e78023          	sb	a4,96(a5)
20000f04:	8082                	ret

20000f06 <calc_hp_offset_at_curr_temp>:
20000f06:	200027b7          	lui	a5,0x20002
20000f0a:	ad07a783          	lw	a5,-1328(a5) # 20001ad0 <aon_tick.0>
20000f0e:	cb99                	beqz	a5,20000f24 <calc_hp_offset_at_curr_temp+0x1e>
20000f10:	40000737          	lui	a4,0x40000
20000f14:	0b072703          	lw	a4,176(a4) # 400000b0 <__StackTop+0x1fffc0b0>
20000f18:	8f1d                	sub	a4,a4,a5
20000f1a:	000287b7          	lui	a5,0x28
20000f1e:	17ed                	addi	a5,a5,-5 # 27ffb <ble_viot.c.543f92a8+0x1f972>
20000f20:	0ce7f963          	bgeu	a5,a4,20000ff2 <calc_hp_offset_at_curr_temp+0xec>
20000f24:	1101                	addi	sp,sp,-32
20000f26:	ce06                	sw	ra,28(sp)
20000f28:	cc22                	sw	s0,24(sp)
20000f2a:	ca26                	sw	s1,20(sp)
20000f2c:	400807b7          	lui	a5,0x40080
20000f30:	47d4                	lw	a3,12(a5)
20000f32:	40040437          	lui	s0,0x40040
20000f36:	4018                	lw	a4,0(s0)
20000f38:	c03a                	sw	a4,0(sp)
20000f3a:	4050                	lw	a2,4(s0)
20000f3c:	c232                	sw	a2,4(sp)
20000f3e:	502c                	lw	a1,96(s0)
20000f40:	c42e                	sw	a1,8(sp)
20000f42:	47d8                	lw	a4,12(a5)
20000f44:	00876713          	ori	a4,a4,8
20000f48:	c7d8                	sw	a4,12(a5)
20000f4a:	5828                	lw	a0,112(s0)
20000f4c:	c62a                	sw	a0,12(sp)
20000f4e:	40000637          	lui	a2,0x40000
20000f52:	560c                	lw	a1,40(a2)
20000f54:	5838                	lw	a4,112(s0)
20000f56:	00176713          	ori	a4,a4,1
20000f5a:	d838                	sw	a4,112(s0)
20000f5c:	420024b7          	lui	s1,0x42002
20000f60:	3ff00713          	li	a4,1023
20000f64:	c0d8                	sw	a4,4(s1)
20000f66:	6721                	lui	a4,0x8
20000f68:	c82e                	sw	a1,16(sp)
20000f6a:	8f4d                	or	a4,a4,a1
20000f6c:	d618                	sw	a4,40(a2)
20000f6e:	c7d4                	sw	a3,12(a5)
20000f70:	3f31                	jal	20000e8c <trigger_gpadc_temp_sampling>
20000f72:	4521                	li	a0,8
20000f74:	f12ff0ef          	jal	20000686 <delay_us>
20000f78:	547c                	lw	a5,108(s0)
20000f7a:	20002737          	lui	a4,0x20002
20000f7e:	af474703          	lbu	a4,-1292(a4) # 20001af4 <g_rf_cfg+0x8>
20000f82:	8f99                	sub	a5,a5,a4
20000f84:	0791                	addi	a5,a5,4 # 40080004 <__StackTop+0x2007c004>
20000f86:	4037d713          	srai	a4,a5,0x3
20000f8a:	200027b7          	lui	a5,0x20002
20000f8e:	9907a783          	lw	a5,-1648(a5) # 20001990 <g_otp_cfg+0x2c>
20000f92:	83bd                	srli	a5,a5,0xf
20000f94:	8bfd                	andi	a5,a5,31
20000f96:	02e787b3          	mul	a5,a5,a4
20000f9a:	0795                	addi	a5,a5,5
20000f9c:	4729                	li	a4,10
20000f9e:	02e7c7b3          	div	a5,a5,a4
20000fa2:	20002737          	lui	a4,0x20002
20000fa6:	aef72223          	sw	a5,-1308(a4) # 20001ae4 <g_hp_offset>
20000faa:	400006b7          	lui	a3,0x40000
20000fae:	0b06a703          	lw	a4,176(a3) # 400000b0 <__StackTop+0x1fffc0b0>
20000fb2:	200027b7          	lui	a5,0x20002
20000fb6:	ace7a823          	sw	a4,-1328(a5) # 20001ad0 <aon_tick.0>
20000fba:	0e84a783          	lw	a5,232(s1) # 420020e8 <__StackTop+0x21ffe0e8>
20000fbe:	9bf9                	andi	a5,a5,-2
20000fc0:	0ef4a423          	sw	a5,232(s1)
20000fc4:	06042023          	sw	zero,96(s0) # 40040060 <__StackTop+0x2003c060>
20000fc8:	06042823          	sw	zero,112(s0)
20000fcc:	40dc                	lw	a5,4(s1)
20000fce:	9bf9                	andi	a5,a5,-2
20000fd0:	c0dc                	sw	a5,4(s1)
20000fd2:	4702                	lw	a4,0(sp)
20000fd4:	c018                	sw	a4,0(s0)
20000fd6:	4612                	lw	a2,4(sp)
20000fd8:	c050                	sw	a2,4(s0)
20000fda:	47a2                	lw	a5,8(sp)
20000fdc:	d03c                	sw	a5,96(s0)
20000fde:	4532                	lw	a0,12(sp)
20000fe0:	d828                	sw	a0,112(s0)
20000fe2:	45c2                	lw	a1,16(sp)
20000fe4:	d68c                	sw	a1,40(a3)
20000fe6:	547c                	lw	a5,108(s0)
20000fe8:	40f2                	lw	ra,28(sp)
20000fea:	4462                	lw	s0,24(sp)
20000fec:	44d2                	lw	s1,20(sp)
20000fee:	6105                	addi	sp,sp,32
20000ff0:	8082                	ret
20000ff2:	8082                	ret

20000ff4 <RF_OnChip_Cfg_KVCO_Cal_val>:
20000ff4:	1171                	addi	sp,sp,-4
20000ff6:	6785                	lui	a5,0x1
20000ff8:	80478793          	addi	a5,a5,-2044 # 804 <__STACK_SIZE+0x504>
20000ffc:	00f11023          	sh	a5,0(sp)
20001000:	4789                	li	a5,2
20001002:	00f10123          	sb	a5,2(sp)
20001006:	832e                	mv	t1,a1
20001008:	005c                	addi	a5,sp,4
2000100a:	97ae                	add	a5,a5,a1
2000100c:	ffc78603          	lb	a2,-4(a5)
20001010:	47c9                	li	a5,18
20001012:	06a7e263          	bltu	a5,a0,20001076 <RF_OnChip_Cfg_KVCO_Cal_val+0x82>
20001016:	47a1                	li	a5,8
20001018:	00a7e763          	bltu	a5,a0,20001026 <RF_OnChip_Cfg_KVCO_Cal_val+0x32>
2000101c:	00161713          	slli	a4,a2,0x1
20001020:	01871613          	slli	a2,a4,0x18
20001024:	8661                	srai	a2,a2,0x18
20001026:	4785                	li	a5,1
20001028:	10f58d63          	beq	a1,a5,20001142 <RF_OnChip_Cfg_KVCO_Cal_val+0x14e>
2000102c:	4581                	li	a1,0
2000102e:	00159793          	slli	a5,a1,0x1
20001032:	97ae                	add	a5,a5,a1
20001034:	200025b7          	lui	a1,0x20002
20001038:	ad858593          	addi	a1,a1,-1320 # 20001ad8 <g_hp>
2000103c:	95be                	add	a1,a1,a5
2000103e:	959a                	add	a1,a1,t1
20001040:	0005c703          	lbu	a4,0(a1)
20001044:	200027b7          	lui	a5,0x20002
20001048:	ae47a683          	lw	a3,-1308(a5) # 20001ae4 <g_hp_offset>
2000104c:	96ba                	add	a3,a3,a4
2000104e:	420015b7          	lui	a1,0x42001
20001052:	5188                	lw	a0,32(a1)
20001054:	77c1                	lui	a5,0xffff0
20001056:	8d7d                	and	a0,a0,a5
20001058:	20000737          	lui	a4,0x20000
2000105c:	2a470713          	addi	a4,a4,676 # 200002a4 <g_lp>
20001060:	971a                	add	a4,a4,t1
20001062:	00074783          	lbu	a5,0(a4)
20001066:	07a2                	slli	a5,a5,0x8
20001068:	00d60733          	add	a4,a2,a3
2000106c:	8fd9                	or	a5,a5,a4
2000106e:	8fc9                	or	a5,a5,a0
20001070:	d19c                	sw	a5,32(a1)
20001072:	0111                	addi	sp,sp,4
20001074:	8082                	ret
20001076:	03a00793          	li	a5,58
2000107a:	02a7f563          	bgeu	a5,a0,200010a4 <RF_OnChip_Cfg_KVCO_Cal_val+0xb0>
2000107e:	04400793          	li	a5,68
20001082:	00a7f763          	bgeu	a5,a0,20001090 <RF_OnChip_Cfg_KVCO_Cal_val+0x9c>
20001086:	00161713          	slli	a4,a2,0x1
2000108a:	01871613          	slli	a2,a4,0x18
2000108e:	8661                	srai	a2,a2,0x18
20001090:	40c00733          	neg	a4,a2
20001094:	01871613          	slli	a2,a4,0x18
20001098:	8661                	srai	a2,a2,0x18
2000109a:	4785                	li	a5,1
2000109c:	04f58963          	beq	a1,a5,200010ee <RF_OnChip_Cfg_KVCO_Cal_val+0xfa>
200010a0:	4589                	li	a1,2
200010a2:	b771                	j	2000102e <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
200010a4:	fed50793          	addi	a5,a0,-19
200010a8:	0ff7f793          	zext.b	a5,a5
200010ac:	4735                	li	a4,13
200010ae:	00f77b63          	bgeu	a4,a5,200010c4 <RF_OnChip_Cfg_KVCO_Cal_val+0xd0>
200010b2:	4769                	li	a4,26
200010b4:	0af76463          	bltu	a4,a5,2000115c <RF_OnChip_Cfg_KVCO_Cal_val+0x168>
200010b8:	4705                	li	a4,1
200010ba:	00e58f63          	beq	a1,a4,200010d8 <RF_OnChip_Cfg_KVCO_Cal_val+0xe4>
200010be:	4601                	li	a2,0
200010c0:	4585                	li	a1,1
200010c2:	b7b5                	j	2000102e <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
200010c4:	4705                	li	a4,1
200010c6:	00e58563          	beq	a1,a4,200010d0 <RF_OnChip_Cfg_KVCO_Cal_val+0xdc>
200010ca:	4601                	li	a2,0
200010cc:	4581                	li	a1,0
200010ce:	b785                	j	2000102e <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
200010d0:	4711                	li	a4,4
200010d2:	06f77563          	bgeu	a4,a5,2000113c <RF_OnChip_Cfg_KVCO_Cal_val+0x148>
200010d6:	4581                	li	a1,0
200010d8:	fdf50513          	addi	a0,a0,-33
200010dc:	0ff57513          	zext.b	a0,a0
200010e0:	470d                	li	a4,3
200010e2:	4601                	li	a2,0
200010e4:	06a77063          	bgeu	a4,a0,20001144 <RF_OnChip_Cfg_KVCO_Cal_val+0x150>
200010e8:	a031                	j	200010f4 <RF_OnChip_Cfg_KVCO_Cal_val+0x100>
200010ea:	4589                	li	a1,2
200010ec:	b7f5                	j	200010d8 <RF_OnChip_Cfg_KVCO_Cal_val+0xe4>
200010ee:	02800793          	li	a5,40
200010f2:	4589                	li	a1,2
200010f4:	fe578713          	addi	a4,a5,-27 # fffeffe5 <__StackTop+0xdffebfe5>
200010f8:	0ff77713          	zext.b	a4,a4
200010fc:	468d                	li	a3,3
200010fe:	04e6f363          	bgeu	a3,a4,20001144 <RF_OnChip_Cfg_KVCO_Cal_val+0x150>
20001102:	ff678713          	addi	a4,a5,-10
20001106:	0ff77713          	zext.b	a4,a4
2000110a:	468d                	li	a3,3
2000110c:	00e6fc63          	bgeu	a3,a4,20001124 <RF_OnChip_Cfg_KVCO_Cal_val+0x130>
20001110:	fe978713          	addi	a4,a5,-23
20001114:	0ff77713          	zext.b	a4,a4
20001118:	00e6f663          	bgeu	a3,a4,20001124 <RF_OnChip_Cfg_KVCO_Cal_val+0x130>
2000111c:	02300713          	li	a4,35
20001120:	f0f777e3          	bgeu	a4,a5,2000102e <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>
20001124:	00159793          	slli	a5,a1,0x1
20001128:	97ae                	add	a5,a5,a1
2000112a:	200025b7          	lui	a1,0x20002
2000112e:	ad858593          	addi	a1,a1,-1320 # 20001ad8 <g_hp>
20001132:	95be                	add	a1,a1,a5
20001134:	0015c703          	lbu	a4,1(a1)
20001138:	1779                	addi	a4,a4,-2
2000113a:	b729                	j	20001044 <RF_OnChip_Cfg_KVCO_Cal_val+0x50>
2000113c:	4601                	li	a2,0
2000113e:	4581                	li	a1,0
20001140:	a011                	j	20001144 <RF_OnChip_Cfg_KVCO_Cal_val+0x150>
20001142:	4581                	li	a1,0
20001144:	00159793          	slli	a5,a1,0x1
20001148:	97ae                	add	a5,a5,a1
2000114a:	200025b7          	lui	a1,0x20002
2000114e:	ad858593          	addi	a1,a1,-1320 # 20001ad8 <g_hp>
20001152:	95be                	add	a1,a1,a5
20001154:	0015c703          	lbu	a4,1(a1)
20001158:	0709                	addi	a4,a4,2
2000115a:	b5ed                	j	20001044 <RF_OnChip_Cfg_KVCO_Cal_val+0x50>
2000115c:	4705                	li	a4,1
2000115e:	f8e586e3          	beq	a1,a4,200010ea <RF_OnChip_Cfg_KVCO_Cal_val+0xf6>
20001162:	4601                	li	a2,0
20001164:	4589                	li	a1,2
20001166:	b5e1                	j	2000102e <RF_OnChip_Cfg_KVCO_Cal_val+0x3a>

20001168 <RF_OnChip_Corner_Cal_Cfg>:
20001168:	1151                	addi	sp,sp,-12
2000116a:	c406                	sw	ra,8(sp)
2000116c:	249d                	jal	200013d2 <omw_rf_cal_apply_core>
2000116e:	40a2                	lw	ra,8(sp)
20001170:	0131                	addi	sp,sp,12
20001172:	8082                	ret

20001174 <RF_OnChip_DCOC_Cal_Bw_Cfg>:
20001174:	200027b7          	lui	a5,0x20002
20001178:	ad47c783          	lbu	a5,-1324(a5) # 20001ad4 <cur_bw>
2000117c:	00a78663          	beq	a5,a0,20001188 <RF_OnChip_DCOC_Cal_Bw_Cfg+0x14>
20001180:	200027b7          	lui	a5,0x20002
20001184:	aca78a23          	sb	a0,-1324(a5) # 20001ad4 <cur_bw>
20001188:	8082                	ret

2000118a <RF_OnChip_DCOC_Cal_Cfg>:
2000118a:	200027b7          	lui	a5,0x20002
2000118e:	577d                	li	a4,-1
20001190:	ace78a23          	sb	a4,-1324(a5) # 20001ad4 <cur_bw>
20001194:	20002637          	lui	a2,0x20002
20001198:	aec60613          	addi	a2,a2,-1300 # 20001aec <g_rf_cfg>
2000119c:	420026b7          	lui	a3,0x42002
200011a0:	02068693          	addi	a3,a3,32 # 42002020 <__StackTop+0x21ffe020>
200011a4:	4701                	li	a4,0
200011a6:	45a5                	li	a1,9
200011a8:	00e65783          	lhu	a5,14(a2)
200011ac:	0792                	slli	a5,a5,0x4
200011ae:	97ba                	add	a5,a5,a4
200011b0:	c29c                	sw	a5,0(a3)
200011b2:	0705                	addi	a4,a4,1
200011b4:	0609                	addi	a2,a2,2
200011b6:	0691                	addi	a3,a3,4
200011b8:	feb718e3          	bne	a4,a1,200011a8 <RF_OnChip_DCOC_Cal_Cfg+0x1e>
200011bc:	420026b7          	lui	a3,0x42002
200011c0:	0c46a783          	lw	a5,196(a3) # 420020c4 <__StackTop+0x21ffe0c4>
200011c4:	f4000737          	lui	a4,0xf4000
200011c8:	177d                	addi	a4,a4,-1 # f3ffffff <__StackTop+0xd3ffbfff>
200011ca:	8f7d                	and	a4,a4,a5
200011cc:	200027b7          	lui	a5,0x20002
200011d0:	af87c783          	lbu	a5,-1288(a5) # 20001af8 <g_rf_cfg+0xc>
200011d4:	07ea                	slli	a5,a5,0x1a
200011d6:	8fd9                	or	a5,a5,a4
200011d8:	0cf6a223          	sw	a5,196(a3)
200011dc:	8082                	ret

200011de <RF_OnChip_RC_Cal_Cfg>:
200011de:	8082                	ret

200011e0 <RF_OnChip_KVCO_Cal_Cfg>:
200011e0:	8082                	ret

200011e2 <RF_OnChip_Base_Init>:
200011e2:	1151                	addi	sp,sp,-12
200011e4:	c406                	sw	ra,8(sp)
200011e6:	c222                	sw	s0,4(sp)
200011e8:	c026                	sw	s1,0(sp)
200011ea:	42002437          	lui	s0,0x42002
200011ee:	441c                	lw	a5,8(s0)
200011f0:	fc07f793          	andi	a5,a5,-64
200011f4:	c41c                	sw	a5,8(s0)
200011f6:	479d                	li	a5,7
200011f8:	c85c                	sw	a5,20(s0)
200011fa:	4c5c                	lw	a5,28(s0)
200011fc:	7771                	lui	a4,0xffffc
200011fe:	0741                	addi	a4,a4,16 # ffffc010 <__StackTop+0xdfff8010>
20001200:	8ff9                	and	a5,a5,a4
20001202:	6711                	lui	a4,0x4
20001204:	f8870713          	addi	a4,a4,-120 # 3f88 <driver_gpio.c.6c5ad779+0x2f7>
20001208:	8fd9                	or	a5,a5,a4
2000120a:	cc5c                	sw	a5,28(s0)
2000120c:	420014b7          	lui	s1,0x42001
20001210:	509c                	lw	a5,32(s1)
20001212:	ff010737          	lui	a4,0xff010
20001216:	177d                	addi	a4,a4,-1 # ff00ffff <__StackTop+0xdf00bfff>
20001218:	8ff9                	and	a5,a5,a4
2000121a:	00140737          	lui	a4,0x140
2000121e:	8fd9                	or	a5,a5,a4
20001220:	d09c                	sw	a5,32(s1)
20001222:	47b1                	li	a5,12
20001224:	14f4a823          	sw	a5,336(s1) # 42001150 <__StackTop+0x21ffd150>
20001228:	405c                	lw	a5,4(s0)
2000122a:	2007e793          	ori	a5,a5,512
2000122e:	c05c                	sw	a5,4(s0)
20001230:	400007b7          	lui	a5,0x40000
20001234:	470d                	li	a4,3
20001236:	30e7a023          	sw	a4,768(a5) # 40000300 <__StackTop+0x1fffc300>
2000123a:	0e042783          	lw	a5,224(s0) # 420020e0 <__StackTop+0x21ffe0e0>
2000123e:	e3f7f793          	andi	a5,a5,-449
20001242:	0c07e793          	ori	a5,a5,192
20001246:	0ef42023          	sw	a5,224(s0)
2000124a:	0e442783          	lw	a5,228(s0)
2000124e:	e1f7f793          	andi	a5,a5,-481
20001252:	1607e793          	ori	a5,a5,352
20001256:	0ef42223          	sw	a5,228(s0)
2000125a:	0d442783          	lw	a5,212(s0)
2000125e:	6705                	lui	a4,0x1
20001260:	80070713          	addi	a4,a4,-2048 # 800 <__STACK_SIZE+0x500>
20001264:	8fd9                	or	a5,a5,a4
20001266:	0cf42a23          	sw	a5,212(s0)
2000126a:	3c69                	jal	20000d04 <omw_rf_set_high_perf_apply>
2000126c:	0ac42783          	lw	a5,172(s0)
20001270:	eff7f793          	andi	a5,a5,-257
20001274:	0af42623          	sw	a5,172(s0)
20001278:	200007b7          	lui	a5,0x20000
2000127c:	52a7c783          	lbu	a5,1322(a5) # 2000052a <rf_wb_sat_th>
20001280:	10f4ac23          	sw	a5,280(s1)
20001284:	6711                	lui	a4,0x4
20001286:	fff70793          	addi	a5,a4,-1 # 3fff <driver_gpio.c.6c5ad779+0x36e>
2000128a:	12f4a823          	sw	a5,304(s1)
2000128e:	40a2                	lw	ra,8(sp)
20001290:	4412                	lw	s0,4(sp)
20001292:	4482                	lw	s1,0(sp)
20001294:	0131                	addi	sp,sp,12
20001296:	8082                	ret

20001298 <RF_OnChip_Cali_Cfg>:
20001298:	1151                	addi	sp,sp,-12
2000129a:	c406                	sw	ra,8(sp)
2000129c:	35f1                	jal	20001168 <RF_OnChip_Corner_Cal_Cfg>
2000129e:	35f5                	jal	2000118a <RF_OnChip_DCOC_Cal_Cfg>
200012a0:	40a2                	lw	ra,8(sp)
200012a2:	0131                	addi	sp,sp,12
200012a4:	8082                	ret

200012a6 <dynamic_agc_info_get2>:
200012a6:	200007b7          	lui	a5,0x20000
200012aa:	2a07c783          	lbu	a5,672(a5) # 200002a0 <dynamic_agc_ctrl_status>
200012ae:	cb9d                	beqz	a5,200012e4 <dynamic_agc_info_get2+0x3e>
200012b0:	0a050a63          	beqz	a0,20001364 <dynamic_agc_info_get2+0xbe>
200012b4:	42001737          	lui	a4,0x42001
200012b8:	10072703          	lw	a4,256(a4) # 42001100 <__StackTop+0x21ffd100>
200012bc:	8b05                	andi	a4,a4,1
200012be:	e305                	bnez	a4,200012de <dynamic_agc_info_get2+0x38>
200012c0:	420017b7          	lui	a5,0x42001
200012c4:	1ec7a703          	lw	a4,492(a5) # 420011ec <__StackTop+0x21ffd1ec>
200012c8:	1007a683          	lw	a3,256(a5)
200012cc:	0016e693          	ori	a3,a3,1
200012d0:	10d7a023          	sw	a3,256(a5)
200012d4:	0ff77713          	zext.b	a4,a4
200012d8:	10e7a223          	sw	a4,260(a5)
200012dc:	8082                	ret
200012de:	4705                	li	a4,1
200012e0:	00e78363          	beq	a5,a4,200012e6 <dynamic_agc_info_get2+0x40>
200012e4:	8082                	ret
200012e6:	420017b7          	lui	a5,0x42001
200012ea:	1e07a683          	lw	a3,480(a5) # 420011e0 <__StackTop+0x21ffd1e0>
200012ee:	0ff6f713          	zext.b	a4,a3
200012f2:	1e47a783          	lw	a5,484(a5)
200012f6:	0ff7f593          	zext.b	a1,a5
200012fa:	07f6f613          	andi	a2,a3,127
200012fe:	0407f793          	andi	a5,a5,64
20001302:	c3cd                	beqz	a5,200013a4 <dynamic_agc_info_get2+0xfe>
20001304:	04077713          	andi	a4,a4,64
20001308:	e319                	bnez	a4,2000130e <dynamic_agc_info_get2+0x68>
2000130a:	07f00613          	li	a2,127
2000130e:	420017b7          	lui	a5,0x42001
20001312:	1ec7a683          	lw	a3,492(a5) # 420011ec <__StackTop+0x21ffd1ec>
20001316:	0ff6f693          	zext.b	a3,a3
2000131a:	0046d793          	srli	a5,a3,0x4
2000131e:	00f6f713          	andi	a4,a3,15
20001322:	07600513          	li	a0,118
20001326:	08b56b63          	bltu	a0,a1,200013bc <dynamic_agc_info_get2+0x116>
2000132a:	06b00513          	li	a0,107
2000132e:	00b56c63          	bltu	a0,a1,20001346 <dynamic_agc_info_get2+0xa0>
20001332:	8aa1                	andi	a3,a3,8
20001334:	ea89                	bnez	a3,20001346 <dynamic_agc_info_get2+0xa0>
20001336:	0705                	addi	a4,a4,1
20001338:	0ff77713          	zext.b	a4,a4
2000133c:	cbb9                	beqz	a5,20001392 <dynamic_agc_info_get2+0xec>
2000133e:	17fd                	addi	a5,a5,-1
20001340:	0ff7f793          	zext.b	a5,a5
20001344:	a0b9                	j	20001392 <dynamic_agc_info_get2+0xec>
20001346:	07600693          	li	a3,118
2000134a:	02c6ef63          	bltu	a3,a2,20001388 <dynamic_agc_info_get2+0xe2>
2000134e:	06b00693          	li	a3,107
20001352:	04c6e063          	bltu	a3,a2,20001392 <dynamic_agc_info_get2+0xec>
20001356:	469d                	li	a3,7
20001358:	02f6ed63          	bltu	a3,a5,20001392 <dynamic_agc_info_get2+0xec>
2000135c:	0785                	addi	a5,a5,1
2000135e:	0ff7f793          	zext.b	a5,a5
20001362:	a805                	j	20001392 <dynamic_agc_info_get2+0xec>
20001364:	42001737          	lui	a4,0x42001
20001368:	10072783          	lw	a5,256(a4) # 42001100 <__StackTop+0x21ffd100>
2000136c:	9bf9                	andi	a5,a5,-2
2000136e:	10f72023          	sw	a5,256(a4)
20001372:	8082                	ret
20001374:	420017b7          	lui	a5,0x42001
20001378:	1ec7a703          	lw	a4,492(a5) # 420011ec <__StackTop+0x21ffd1ec>
2000137c:	0ff77713          	zext.b	a4,a4
20001380:	00475793          	srli	a5,a4,0x4
20001384:	8b3d                	andi	a4,a4,15
20001386:	ef05                	bnez	a4,200013be <dynamic_agc_info_get2+0x118>
20001388:	00078563          	beqz	a5,20001392 <dynamic_agc_info_get2+0xec>
2000138c:	17fd                	addi	a5,a5,-1
2000138e:	0ff7f793          	zext.b	a5,a5
20001392:	0792                	slli	a5,a5,0x4
20001394:	973e                	add	a4,a4,a5
20001396:	0ff77713          	zext.b	a4,a4
2000139a:	420017b7          	lui	a5,0x42001
2000139e:	10e7a223          	sw	a4,260(a5) # 42001104 <__StackTop+0x21ffd104>
200013a2:	8082                	ret
200013a4:	04077713          	andi	a4,a4,64
200013a8:	d771                	beqz	a4,20001374 <dynamic_agc_info_get2+0xce>
200013aa:	420017b7          	lui	a5,0x42001
200013ae:	1ec7a703          	lw	a4,492(a5) # 420011ec <__StackTop+0x21ffd1ec>
200013b2:	0ff77713          	zext.b	a4,a4
200013b6:	00475793          	srli	a5,a4,0x4
200013ba:	8b3d                	andi	a4,a4,15
200013bc:	d749                	beqz	a4,20001346 <dynamic_agc_info_get2+0xa0>
200013be:	177d                	addi	a4,a4,-1
200013c0:	0ff77713          	zext.b	a4,a4
200013c4:	469d                	li	a3,7
200013c6:	fcf6e6e3          	bltu	a3,a5,20001392 <dynamic_agc_info_get2+0xec>
200013ca:	0785                	addi	a5,a5,1
200013cc:	0ff7f793          	zext.b	a5,a5
200013d0:	b7c9                	j	20001392 <dynamic_agc_info_get2+0xec>

200013d2 <omw_rf_cal_apply_core>:
200013d2:	400806b7          	lui	a3,0x40080
200013d6:	1046a603          	lw	a2,260(a3) # 40080104 <__StackTop+0x2007c104>
200013da:	20002737          	lui	a4,0x20002
200013de:	aec70713          	addi	a4,a4,-1300 # 20001aec <g_rf_cfg>
200013e2:	00474783          	lbu	a5,4(a4)
200013e6:	078e                	slli	a5,a5,0x3
200013e8:	00574583          	lbu	a1,5(a4)
200013ec:	05a2                	slli	a1,a1,0x8
200013ee:	8fcd                	or	a5,a5,a1
200013f0:	00174583          	lbu	a1,1(a4)
200013f4:	05ba                	slli	a1,a1,0xe
200013f6:	8fcd                	or	a5,a5,a1
200013f8:	fffc05b7          	lui	a1,0xfffc0
200013fc:	8e6d                	and	a2,a2,a1
200013fe:	8fd1                	or	a5,a5,a2
20001400:	6609                	lui	a2,0x2
20001402:	0609                	addi	a2,a2,2 # 2002 <main.c.479021b4+0xf5a>
20001404:	8fd1                	or	a5,a5,a2
20001406:	10f6a223          	sw	a5,260(a3)
2000140a:	1106a783          	lw	a5,272(a3)
2000140e:	87f7f613          	andi	a2,a5,-1921
20001412:	00774783          	lbu	a5,7(a4)
20001416:	17f9                	addi	a5,a5,-2
20001418:	079e                	slli	a5,a5,0x7
2000141a:	8fd1                	or	a5,a5,a2
2000141c:	10f6a823          	sw	a5,272(a3)
20001420:	42002637          	lui	a2,0x42002
20001424:	460c                	lw	a1,8(a2)
20001426:	800807b7          	lui	a5,0x80080
2000142a:	87f78793          	addi	a5,a5,-1921 # 8007f87f <__StackTop+0x6007b87f>
2000142e:	8dfd                	and	a1,a1,a5
20001430:	00274683          	lbu	a3,2(a4)
20001434:	0685                	addi	a3,a3,1
20001436:	00374783          	lbu	a5,3(a4)
2000143a:	079e                	slli	a5,a5,0x7
2000143c:	00074703          	lbu	a4,0(a4)
20001440:	076e                	slli	a4,a4,0x1b
20001442:	8fd9                	or	a5,a5,a4
20001444:	01369713          	slli	a4,a3,0x13
20001448:	8fd9                	or	a5,a5,a4
2000144a:	06de                	slli	a3,a3,0x17
2000144c:	8fd5                	or	a5,a5,a3
2000144e:	8fcd                	or	a5,a5,a1
20001450:	c61c                	sw	a5,8(a2)
20001452:	8082                	ret

20001454 <System_Pwr_Cfg>:
20001454:	400007b7          	lui	a5,0x40000
20001458:	4725                	li	a4,9
2000145a:	c3d8                	sw	a4,4(a5)
2000145c:	4775                	li	a4,29
2000145e:	d398                	sw	a4,32(a5)
20001460:	471d                	li	a4,7
20001462:	d798                	sw	a4,40(a5)
20001464:	6705                	lui	a4,0x1
20001466:	30270713          	addi	a4,a4,770 # 1302 <main.c.479021b4+0x25a>
2000146a:	d7d8                	sw	a4,44(a5)
2000146c:	8082                	ret

2000146e <t1001_sleep_restore_reg_info>:
2000146e:	0ff57793          	zext.b	a5,a0
20001472:	0ff57513          	zext.b	a0,a0
20001476:	02b57863          	bgeu	a0,a1,200014a6 <t1001_sleep_restore_reg_info+0x38>
2000147a:	20002737          	lui	a4,0x20002
2000147e:	b0c72603          	lw	a2,-1268(a4) # 20001b0c <g_save_buf>
20001482:	200006b7          	lui	a3,0x20000
20001486:	57c68693          	addi	a3,a3,1404 # 2000057c <cr_regs_addr_list>
2000148a:	050a                	slli	a0,a0,0x2
2000148c:	9532                	add	a0,a0,a2
2000148e:	4108                	lw	a0,0(a0)
20001490:	00279713          	slli	a4,a5,0x2
20001494:	9736                	add	a4,a4,a3
20001496:	4318                	lw	a4,0(a4)
20001498:	c308                	sw	a0,0(a4)
2000149a:	0785                	addi	a5,a5,1 # 40000001 <__StackTop+0x1fffc001>
2000149c:	0ff7f793          	zext.b	a5,a5
200014a0:	853e                	mv	a0,a5
200014a2:	feb7e4e3          	bltu	a5,a1,2000148a <t1001_sleep_restore_reg_info+0x1c>
200014a6:	8082                	ret

200014a8 <omw_sleep_set_sleep_len>:
200014a8:	3e800793          	li	a5,1000
200014ac:	02f50533          	mul	a0,a0,a5
200014b0:	8115                	srli	a0,a0,0x5
200014b2:	200027b7          	lui	a5,0x20002
200014b6:	b0a7aa23          	sw	a0,-1260(a5) # 20001b14 <slp_tm_rtc_cyls>
200014ba:	8082                	ret
200014bc:	4501                	li	a0,0
200014be:	8082                	ret

200014c0 <T1001_ChipSleepCriticalWork>:
200014c0:	f9810113          	addi	sp,sp,-104
200014c4:	d286                	sw	ra,100(sp)
200014c6:	d0a2                	sw	s0,96(sp)
200014c8:	cea6                	sw	s1,92(sp)
200014ca:	0058                	addi	a4,sp,4
200014cc:	200027b7          	lui	a5,0x20002
200014d0:	b0e7a623          	sw	a4,-1268(a5) # 20001b0c <g_save_buf>
200014d4:	200007b7          	lui	a5,0x20000
200014d8:	57c78793          	addi	a5,a5,1404 # 2000057c <cr_regs_addr_list>
200014dc:	05878613          	addi	a2,a5,88
200014e0:	4394                	lw	a3,0(a5)
200014e2:	4294                	lw	a3,0(a3)
200014e4:	c314                	sw	a3,0(a4)
200014e6:	0791                	addi	a5,a5,4
200014e8:	0711                	addi	a4,a4,4
200014ea:	fec79be3          	bne	a5,a2,200014e0 <T1001_ChipSleepCriticalWork+0x20>
200014ee:	400807b7          	lui	a5,0x40080
200014f2:	00c7d703          	lhu	a4,12(a5) # 4008000c <__StackTop+0x2007c00c>
200014f6:	40076713          	ori	a4,a4,1024
200014fa:	00e79623          	sh	a4,12(a5)
200014fe:	20002737          	lui	a4,0x20002
20001502:	88470713          	addi	a4,a4,-1916 # 20001884 <CS_contextRestore>
20001506:	d398                	sw	a4,32(a5)
20001508:	200027b7          	lui	a5,0x20002
2000150c:	b607a503          	lw	a0,-1184(a5) # 20001b60 <unused_gpio_mask_when_sleep>
20001510:	24c1                	jal	200017d0 <unused_gpio_mask_parse_and_set>
20001512:	200027b7          	lui	a5,0x20002
20001516:	b107c783          	lbu	a5,-1264(a5) # 20001b10 <has_flash>
2000151a:	c38d                	beqz	a5,2000153c <T1001_ChipSleepCriticalWork+0x7c>
2000151c:	200007b7          	lui	a5,0x20000
20001520:	5d47c503          	lbu	a0,1492(a5) # 200005d4 <gpio_vdd_pin1>
20001524:	0ff00793          	li	a5,255
20001528:	04f51463          	bne	a0,a5,20001570 <T1001_ChipSleepCriticalWork+0xb0>
2000152c:	200007b7          	lui	a5,0x20000
20001530:	5d57c503          	lbu	a0,1493(a5) # 200005d5 <gpio_vdd_pin2>
20001534:	0ff00793          	li	a5,255
20001538:	02f51e63          	bne	a0,a5,20001574 <T1001_ChipSleepCriticalWork+0xb4>
2000153c:	40080437          	lui	s0,0x40080
20001540:	04c44783          	lbu	a5,76(s0) # 4008004c <__StackTop+0x2007c04c>
20001544:	0017e793          	ori	a5,a5,1
20001548:	04f40623          	sb	a5,76(s0)
2000154c:	447c                	lw	a5,76(s0)
2000154e:	eff7f793          	andi	a5,a5,-257
20001552:	c47c                	sw	a5,76(s0)
20001554:	12442783          	lw	a5,292(s0)
20001558:	9bdd                	andi	a5,a5,-9
2000155a:	12f42223          	sw	a5,292(s0)
2000155e:	4509                	li	a0,2
20001560:	926ff0ef          	jal	20000686 <delay_us>
20001564:	12442783          	lw	a5,292(s0)
20001568:	9bed                	andi	a5,a5,-5
2000156a:	12f42223          	sw	a5,292(s0)
2000156e:	a835                	j	200015aa <T1001_ChipSleepCriticalWork+0xea>
20001570:	2421                	jal	20001778 <flash_power_off>
20001572:	bf6d                	j	2000152c <T1001_ChipSleepCriticalWork+0x6c>
20001574:	2411                	jal	20001778 <flash_power_off>
20001576:	b7d9                	j	2000153c <T1001_ChipSleepCriticalWork+0x7c>
20001578:	3df1                	jal	20001454 <System_Pwr_Cfg>
2000157a:	40080437          	lui	s0,0x40080
2000157e:	10442783          	lw	a5,260(s0) # 40080104 <__StackTop+0x2007c104>
20001582:	7779                	lui	a4,0xffffe
20001584:	0ff70713          	addi	a4,a4,255 # ffffe0ff <__StackTop+0xdfffa0ff>
20001588:	8ff9                	and	a5,a5,a4
2000158a:	6007e793          	ori	a5,a5,1536
2000158e:	10f42223          	sw	a5,260(s0)
20001592:	45c9                	li	a1,18
20001594:	4501                	li	a0,0
20001596:	3de1                	jal	2000146e <t1001_sleep_restore_reg_info>
20001598:	31a9                	jal	200011e2 <RF_OnChip_Base_Init>
2000159a:	39fd                	jal	20001298 <RF_OnChip_Cali_Cfg>
2000159c:	4c48                	lw	a0,28(s0)
2000159e:	2469                	jal	20001828 <omw_sleep_wkup_worker>
200015a0:	e535                	bnez	a0,2000160c <T1001_ChipSleepCriticalWork+0x14c>
200015a2:	3e800513          	li	a0,1000
200015a6:	8e0ff0ef          	jal	20000686 <delay_us>
200015aa:	400007b7          	lui	a5,0x40000
200015ae:	0b07a783          	lw	a5,176(a5) # 400000b0 <__StackTop+0x1fffc0b0>
200015b2:	20002737          	lui	a4,0x20002
200015b6:	b1470493          	addi	s1,a4,-1260 # 20001b14 <slp_tm_rtc_cyls>
200015ba:	4098                	lw	a4,0(s1)
200015bc:	97ba                	add	a5,a5,a4
200015be:	40080437          	lui	s0,0x40080
200015c2:	c05c                	sw	a5,4(s0)
200015c4:	10442783          	lw	a5,260(s0) # 40080104 <__StackTop+0x2007c104>
200015c8:	7779                	lui	a4,0xffffe
200015ca:	0ff70713          	addi	a4,a4,255 # ffffe0ff <__StackTop+0xdfffa0ff>
200015ce:	8ff9                	and	a5,a5,a4
200015d0:	6705                	lui	a4,0x1
200015d2:	8fd9                	or	a5,a5,a4
200015d4:	10f42223          	sw	a5,260(s0)
200015d8:	2495                	jal	2000183c <CS_contextSave>
200015da:	04040423          	sb	zero,72(s0)
200015de:	4098                	lw	a4,0(s1)
200015e0:	57fd                	li	a5,-1
200015e2:	f8f71be3          	bne	a4,a5,20001578 <T1001_ChipSleepCriticalWork+0xb8>
200015e6:	400807b7          	lui	a5,0x40080
200015ea:	4fdc                	lw	a5,28(a5)
200015ec:	f7d1                	bnez	a5,20001578 <T1001_ChipSleepCriticalWork+0xb8>
200015ee:	c002                	sw	zero,0(sp)
200015f0:	4702                	lw	a4,0(sp)
200015f2:	6785                	lui	a5,0x1
200015f4:	bb778793          	addi	a5,a5,-1097 # bb7 <__STACK_SIZE+0x8b7>
200015f8:	fae7c9e3          	blt	a5,a4,200015aa <T1001_ChipSleepCriticalWork+0xea>
200015fc:	873e                	mv	a4,a5
200015fe:	4782                	lw	a5,0(sp)
20001600:	0785                	addi	a5,a5,1
20001602:	c03e                	sw	a5,0(sp)
20001604:	4782                	lw	a5,0(sp)
20001606:	fef75ce3          	bge	a4,a5,200015fe <T1001_ChipSleepCriticalWork+0x13e>
2000160a:	b745                	j	200015aa <T1001_ChipSleepCriticalWork+0xea>
2000160c:	45d9                	li	a1,22
2000160e:	4549                	li	a0,18
20001610:	3db9                	jal	2000146e <t1001_sleep_restore_reg_info>
20001612:	200027b7          	lui	a5,0x20002
20001616:	b107c783          	lbu	a5,-1264(a5) # 20001b10 <has_flash>
2000161a:	ebc1                	bnez	a5,200016aa <T1001_ChipSleepCriticalWork+0x1ea>
2000161c:	2a69                	jal	200017b6 <gpio_regs_restore_before_rel_gpio_hold>
2000161e:	40080437          	lui	s0,0x40080
20001622:	12442783          	lw	a5,292(s0) # 40080124 <__StackTop+0x2007c124>
20001626:	0047e793          	ori	a5,a5,4
2000162a:	12f42223          	sw	a5,292(s0)
2000162e:	4509                	li	a0,2
20001630:	856ff0ef          	jal	20000686 <delay_us>
20001634:	12442783          	lw	a5,292(s0)
20001638:	0087e793          	ori	a5,a5,8
2000163c:	12f42223          	sw	a5,292(s0)
20001640:	04c44783          	lbu	a5,76(s0)
20001644:	9bf9                	andi	a5,a5,-2
20001646:	04f40623          	sb	a5,76(s0)
2000164a:	447c                	lw	a5,76(s0)
2000164c:	1007e793          	ori	a5,a5,256
20001650:	c47c                	sw	a5,76(s0)
20001652:	200027b7          	lui	a5,0x20002
20001656:	b117c783          	lbu	a5,-1263(a5) # 20001b11 <has_otp>
2000165a:	cbb1                	beqz	a5,200016ae <T1001_ChipSleepCriticalWork+0x1ee>
2000165c:	200007b7          	lui	a5,0x20000
20001660:	5dc7a783          	lw	a5,1500(a5) # 200005dc <otp_init>
20001664:	9782                	jalr	a5
20001666:	200027b7          	lui	a5,0x20002
2000166a:	b117c783          	lbu	a5,-1263(a5) # 20001b11 <has_otp>
2000166e:	c3a1                	beqz	a5,200016ae <T1001_ChipSleepCriticalWork+0x1ee>
20001670:	200027b7          	lui	a5,0x20002
20001674:	b0c7a783          	lw	a5,-1268(a5) # 20001b0c <g_save_buf>
20001678:	47f8                	lw	a4,76(a5)
2000167a:	200007b7          	lui	a5,0x20000
2000167e:	5c87a783          	lw	a5,1480(a5) # 200005c8 <cr_regs_addr_list+0x4c>
20001682:	c398                	sw	a4,0(a5)
20001684:	200027b7          	lui	a5,0x20002
20001688:	b107c783          	lbu	a5,-1264(a5) # 20001b10 <has_flash>
2000168c:	c789                	beqz	a5,20001696 <T1001_ChipSleepCriticalWork+0x1d6>
2000168e:	400007b7          	lui	a5,0x40000
20001692:	4721                	li	a4,8
20001694:	c3d8                	sw	a4,4(a5)
20001696:	400807b7          	lui	a5,0x40080
2000169a:	0207a023          	sw	zero,32(a5) # 40080020 <__StackTop+0x2007c020>
2000169e:	5096                	lw	ra,100(sp)
200016a0:	5406                	lw	s0,96(sp)
200016a2:	44f6                	lw	s1,92(sp)
200016a4:	06810113          	addi	sp,sp,104
200016a8:	8082                	ret
200016aa:	20d5                	jal	2000178e <qspi_regs_restore>
200016ac:	bf85                	j	2000161c <T1001_ChipSleepCriticalWork+0x15c>
200016ae:	200027b7          	lui	a5,0x20002
200016b2:	b107c783          	lbu	a5,-1264(a5) # 20001b10 <has_flash>
200016b6:	dfcd                	beqz	a5,20001670 <T1001_ChipSleepCriticalWork+0x1b0>
200016b8:	1f400513          	li	a0,500
200016bc:	fcbfe0ef          	jal	20000686 <delay_us>
200016c0:	bf45                	j	20001670 <T1001_ChipSleepCriticalWork+0x1b0>

200016c2 <omw_svc_24g_tx_end>:
200016c2:	200027b7          	lui	a5,0x20002
200016c6:	b40788a3          	sb	zero,-1199(a5) # 20001b51 <tx_restart_flag>
200016ca:	200027b7          	lui	a5,0x20002
200016ce:	4705                	li	a4,1
200016d0:	b0e78c23          	sb	a4,-1256(a5) # 20001b18 <current_tx_rx_switch_flag>
200016d4:	8082                	ret

200016d6 <omw_svc_24g_rx_end>:
200016d6:	200027b7          	lui	a5,0x20002
200016da:	9b878793          	addi	a5,a5,-1608 # 200019b8 <rf_2g4_mgr>
200016de:	02078fa3          	sb	zero,63(a5)
200016e2:	200027b7          	lui	a5,0x20002
200016e6:	b4078823          	sb	zero,-1200(a5) # 20001b50 <rx_restart_flag>
200016ea:	e551                	bnez	a0,20001776 <omw_svc_24g_rx_end+0xa0>
200016ec:	200027b7          	lui	a5,0x20002
200016f0:	b1c7a783          	lw	a5,-1252(a5) # 20001b1c <ptr_rx_data>
200016f4:	c3c9                	beqz	a5,20001776 <omw_svc_24g_rx_end+0xa0>
200016f6:	1151                	addi	sp,sp,-12
200016f8:	c406                	sw	ra,8(sp)
200016fa:	c222                	sw	s0,4(sp)
200016fc:	200027b7          	lui	a5,0x20002
20001700:	b527c783          	lbu	a5,-1198(a5) # 20001b52 <tx_rx_cfg_mode>
20001704:	0ff7f793          	zext.b	a5,a5
20001708:	eba1                	bnez	a5,20001758 <omw_svc_24g_rx_end+0x82>
2000170a:	200027b7          	lui	a5,0x20002
2000170e:	b1c78793          	addi	a5,a5,-1252 # 20001b1c <ptr_rx_data>
20001712:	4398                	lw	a4,0(a5)
20001714:	20002437          	lui	s0,0x20002
20001718:	9b840413          	addi	s0,s0,-1608 # 200019b8 <rf_2g4_mgr>
2000171c:	01e44683          	lbu	a3,30(s0)
20001720:	00d70023          	sb	a3,0(a4) # 1000 <__STACK_SIZE+0xd00>
20001724:	4398                	lw	a4,0(a5)
20001726:	02544683          	lbu	a3,37(s0)
2000172a:	00d700a3          	sb	a3,1(a4)
2000172e:	4388                	lw	a0,0(a5)
20001730:	439c                	lw	a5,0(a5)
20001732:	0017c583          	lbu	a1,1(a5)
20001736:	0589                	addi	a1,a1,2 # fffc0002 <__StackTop+0xdffbc002>
20001738:	0ff5f593          	zext.b	a1,a1
2000173c:	f0001097          	auipc	ra,0xf0001
20001740:	376080e7          	jalr	886(ra) # 10002ab2 <rf_2g4_rx_handler>
20001744:	00040f23          	sb	zero,30(s0)
20001748:	020402a3          	sb	zero,37(s0)
2000174c:	02040323          	sb	zero,38(s0)
20001750:	40a2                	lw	ra,8(sp)
20001752:	4412                	lw	s0,4(sp)
20001754:	0131                	addi	sp,sp,12
20001756:	8082                	ret
20001758:	200027b7          	lui	a5,0x20002
2000175c:	b1c7a503          	lw	a0,-1252(a5) # 20001b1c <ptr_rx_data>
20001760:	200007b7          	lui	a5,0x20000
20001764:	5d87d583          	lhu	a1,1496(a5) # 200005d8 <rf_2g4_rx_data_length>
20001768:	0ff5f593          	zext.b	a1,a1
2000176c:	f0001097          	auipc	ra,0xf0001
20001770:	346080e7          	jalr	838(ra) # 10002ab2 <rf_2g4_rx_handler>
20001774:	bff1                	j	20001750 <omw_svc_24g_rx_end+0x7a>
20001776:	8082                	ret

20001778 <flash_power_off>:
20001778:	40010737          	lui	a4,0x40010
2000177c:	4334                	lw	a3,64(a4)
2000177e:	4785                	li	a5,1
20001780:	00a797b3          	sll	a5,a5,a0
20001784:	fff7c793          	not	a5,a5
20001788:	8ff5                	and	a5,a5,a3
2000178a:	c33c                	sw	a5,64(a4)
2000178c:	8082                	ret

2000178e <qspi_regs_restore>:
2000178e:	400107b7          	lui	a5,0x40010
20001792:	6709                	lui	a4,0x2
20001794:	12170713          	addi	a4,a4,289 # 2121 <main.c.479021b4+0x1079>
20001798:	20e7a623          	sw	a4,524(a5) # 4001020c <__StackTop+0x2000c20c>
2000179c:	20e7a823          	sw	a4,528(a5)
200017a0:	40000713          	li	a4,1024
200017a4:	db98                	sw	a4,48(a5)
200017a6:	c3b8                	sw	a4,64(a5)
200017a8:	ff325737          	lui	a4,0xff325
200017ac:	41070713          	addi	a4,a4,1040 # ff325410 <__StackTop+0xdf321410>
200017b0:	30e7a023          	sw	a4,768(a5)
200017b4:	8082                	ret

200017b6 <gpio_regs_restore_before_rel_gpio_hold>:
200017b6:	200027b7          	lui	a5,0x20002
200017ba:	b5478793          	addi	a5,a5,-1196 # 20001b54 <g_save_buf>
200017be:	4398                	lw	a4,0(a5)
200017c0:	5354                	lw	a3,36(a4)
200017c2:	40010737          	lui	a4,0x40010
200017c6:	db14                	sw	a3,48(a4)
200017c8:	439c                	lw	a5,0(a5)
200017ca:	579c                	lw	a5,40(a5)
200017cc:	c33c                	sw	a5,64(a4)
200017ce:	8082                	ret

200017d0 <unused_gpio_mask_parse_and_set>:
200017d0:	40010337          	lui	t1,0x40010
200017d4:	03032683          	lw	a3,48(t1) # 40010030 <__StackTop+0x2000c030>
200017d8:	fff54793          	not	a5,a0
200017dc:	8ff5                	and	a5,a5,a3
200017de:	02f32823          	sw	a5,48(t1)
200017e2:	20030313          	addi	t1,t1,512
200017e6:	400103b7          	lui	t2,0x40010
200017ea:	21838393          	addi	t2,t2,536 # 40010218 <__StackTop+0x2000c218>
200017ee:	a01d                	j	20001814 <unused_gpio_mask_parse_and_set+0x44>
200017f0:	8105                	srli	a0,a0,0x1
200017f2:	0722                	slli	a4,a4,0x8
200017f4:	06a2                	slli	a3,a3,0x8
200017f6:	17fd                	addi	a5,a5,-1
200017f8:	cb89                	beqz	a5,2000180a <unused_gpio_mask_parse_and_set+0x3a>
200017fa:	00157593          	andi	a1,a0,1
200017fe:	d9ed                	beqz	a1,200017f0 <unused_gpio_mask_parse_and_set+0x20>
20001800:	fff74593          	not	a1,a4
20001804:	8e6d                	and	a2,a2,a1
20001806:	8e55                	or	a2,a2,a3
20001808:	b7e5                	j	200017f0 <unused_gpio_mask_parse_and_set+0x20>
2000180a:	00c2a023          	sw	a2,0(t0)
2000180e:	0311                	addi	t1,t1,4
20001810:	00730b63          	beq	t1,t2,20001826 <unused_gpio_mask_parse_and_set+0x56>
20001814:	829a                	mv	t0,t1
20001816:	00032603          	lw	a2,0(t1)
2000181a:	4791                	li	a5,4
2000181c:	0a000693          	li	a3,160
20001820:	0ff00713          	li	a4,255
20001824:	bfd9                	j	200017fa <unused_gpio_mask_parse_and_set+0x2a>
20001826:	8082                	ret

20001828 <omw_sleep_wkup_worker>:
20001828:	c119                	beqz	a0,2000182e <omw_sleep_wkup_worker+0x6>
2000182a:	4505                	li	a0,1
2000182c:	8082                	ret
2000182e:	1151                	addi	sp,sp,-12
20001830:	c406                	sw	ra,8(sp)
20001832:	db7fe0ef          	jal	200005e8 <sleep_wakeup_handler>
20001836:	40a2                	lw	ra,8(sp)
20001838:	0131                	addi	sp,sp,12
2000183a:	8082                	ret

2000183c <CS_contextSave>:
2000183c:	715d                	addi	sp,sp,-80
2000183e:	c006                	sw	ra,0(sp)
20001840:	c20a                	sw	sp,4(sp)
20001842:	c40e                	sw	gp,8(sp)
20001844:	c612                	sw	tp,12(sp)
20001846:	c816                	sw	t0,16(sp)
20001848:	ca1a                	sw	t1,20(sp)
2000184a:	cc1e                	sw	t2,24(sp)
2000184c:	ce22                	sw	s0,28(sp)
2000184e:	d026                	sw	s1,32(sp)
20001850:	d22a                	sw	a0,36(sp)
20001852:	d42e                	sw	a1,40(sp)
20001854:	d632                	sw	a2,44(sp)
20001856:	d836                	sw	a3,48(sp)
20001858:	da3a                	sw	a4,52(sp)
2000185a:	dc3e                	sw	a5,56(sp)
2000185c:	307024f3          	csrr	s1,mtvt
20001860:	30502573          	csrr	a0,mtvec
20001864:	c0a6                	sw	s1,64(sp)
20001866:	c2aa                	sw	a0,68(sp)
20001868:	40080537          	lui	a0,0x40080
2000186c:	02450513          	addi	a0,a0,36 # 40080024 <__StackTop+0x2007c024>
20001870:	00252023          	sw	sp,0(a0)
20001874:	40080537          	lui	a0,0x40080
20001878:	04850513          	addi	a0,a0,72 # 40080048 <__StackTop+0x2007c048>
2000187c:	4585                	li	a1,1
2000187e:	c10c                	sw	a1,0(a0)
20001880:	10500073          	wfi

20001884 <CS_contextRestore>:
20001884:	40080537          	lui	a0,0x40080
20001888:	02450513          	addi	a0,a0,36 # 40080024 <__StackTop+0x2007c024>
2000188c:	410c                	lw	a1,0(a0)
2000188e:	812e                	mv	sp,a1
20001890:	4486                	lw	s1,64(sp)
20001892:	4516                	lw	a0,68(sp)
20001894:	30749073          	csrw	mtvt,s1
20001898:	30551073          	csrw	mtvec,a0
2000189c:	4082                	lw	ra,0(sp)
2000189e:	4112                	lw	sp,4(sp)
200018a0:	41a2                	lw	gp,8(sp)
200018a2:	4232                	lw	tp,12(sp)
200018a4:	42c2                	lw	t0,16(sp)
200018a6:	4352                	lw	t1,20(sp)
200018a8:	43e2                	lw	t2,24(sp)
200018aa:	4472                	lw	s0,28(sp)
200018ac:	5482                	lw	s1,32(sp)
200018ae:	5512                	lw	a0,36(sp)
200018b0:	55a2                	lw	a1,40(sp)
200018b2:	5632                	lw	a2,44(sp)
200018b4:	56c2                	lw	a3,48(sp)
200018b6:	5752                	lw	a4,52(sp)
200018b8:	57e2                	lw	a5,56(sp)
200018ba:	6161                	addi	sp,sp,80
200018bc:	8082                	ret
	...
