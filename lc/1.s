	@MSPM0L1306
	@编译器ARM-NONE-EABI

	.thumb
	.syntax unified
	.section .text
vectors:
	.word zhanding
	.word kaishi + 1
	.word _nmi	+1
	.word _Hard_Fault +1
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word _svc_handler +1
	.word 0
	.word 0
	.word _pendsv_handler +1
	.word _systickzhongduan +1  @ 15
	.word aaa +1		@INT_GROUP0	@0 
	.word aaa +1		@INT_GROUP1	@1
	.word aaa +1		@TIMG1		@2
	.word aaa +1				@3
	.word aaa +1				@4
	.word aaa +1				@5
	.word aaa +1				@6
	.word aaa +1				@7
	.word aaa +1				@8
	.word aaa +1		@SPI0		@9
	.word aaa +1				@10
        .word aaa +1				@11
        .word aaa +1				@12
        .word aaa +1		@UART1		@13
        .word aaa +1				@14
        .word aaa +1		@UART0		@15		
        .word aaa +1		@TIMG0		@16
        .word aaa +1				@17
        .word aaa +1		@TIMG2		@18
        .word aaa +1				@19
        .word aaa +1		@TIMG4		@20
        .word aaa +1				@21
        .word aaa +1				@22
        .word aaa +1				@23
        .word aaa +1		@I2C0		@24
        .word aaa +1		@I2C1		@25
        .word aaa +1				@26
        .word aaa +1				@27
        .word aaa +1				@28
        .word aaa +1				@29
	.word aaa +1				@30
	.word aaa +1		@DMA		@31
	.word aaa +1

kaishi:
	bkpt # 1
_neicunqingling:
	ldr r0, = 0x20001000
	ldr r2, = 0x20000000
	movs r1, # 0
_neicunqinglingxunhuan:
	subs r0, r0, # 4
	str r1, [r0]
	cmp r0, r2
	bne _neicunqinglingxunhuan
__IOMUX_she_zhi:
	@复用功能选择
	ldr r0, = 0x40428000
	movs r1, # 0x10		@pa3	@LCD_A0
	movs r2, # 0x81		@GPIO	
	str r2, [r0, r1]

	movs r1, # 0x14		@pa4   @LCD_RST
	movs r2, # 0x81		@gpio
	str r2, [r0, r1]	
	
	movs r1, # 0x18		@pa5	@LCD_MOSI
	movs r2, # 0x83		@SPI_PICO
	str r2, [r0, r1]

	movs r1, # 0x1c		@pa6	@LCD_SCK
	movs r2, # 0x83		@SPI_SCK
	str r2, [r0, r1]


	movs r1, # 0x38		@pa13
	ldr r2, =   0x83	@PA13 TIMG0_C1
	str r2, [r0, r1]

		
__spi0:
	ldr r0, = 0x40468000	@spi0基地址
	ldr r1, = 0x800
        ldr r2, = 0x26000001
        str r2, [r0, r1]        @开电源

	ldr r1, = 0x1000	@CLKDIV 时钟分频
	movs r2, # 0x00		@8分频
	str r2, [r0, r1]

	ldr r1, = 0x1004	@CLKSEL 时钟选择
	movs r2, # 0x08		@0x08=SYSCLK
	str r2, [r0, r1]

	ldr r1, = 0x1100	@CTL0 控制寄存器0
	ldr r2, = 0x07		@传输8位
	str r2, [r0, r1]

	ldr r1, = 0x1104	@CTL1 控制寄存器1
	ldr r2, = 0x15		@开SPI MSB在前
	str r2, [r0, r1]

__GPIO_she_zhi:
	@+12c0 = 输入输出设置
	@+1290 = 写1高
	@+12a0 = 写1低
	ldr r0, = 0x400a0000
	ldr r1, = 0x800		@寄存器偏移
	ldr r2, = 0x26000001	
	str r2, [r0, r1]	@开电源
	
	ldr r1, = 0x12c0	@寄存器偏移
	ldr r2, = 0x18		@pa3,pa4
	str r2, [r0, r1]	@使能输出


__opa0:
        ldr r0, = 0x40020000    @OPA0基地址
        ldr r1, = 0x800
        ldr r2, = 0x26000001
        str r2, [r0, r1]        @开电源

	ldr r1, = 0x1108        @CFG
	ldr r2, = 0x28c
        			@PA25=OPA+ @0x28c缓冲,0x260c=2倍，
				@0x460c=4倍@0x660c=8倍
				@0x860C=16倍，0xA60C=32倍

	str r2, [r0, r1]


	ldr r1, = 0x1100        @CTL
        movs r2, # 0x01
        str r2, [r0, r1]        @OPA0开


	
__opa1:
	ldr r0, = 0x40022000	@OPA1基地址
	ldr r1, = 0x800
	ldr r2, = 0x26000001
	str r2, [r0, r1]	@开电源

	ldr r1, = 0x1108	@CFG
	ldr r2, = 0x28c
	@ @PA18=OPA+ @0x28c缓冲,0x260c=2倍，0x460c=4倍，
	@0x660c=8倍，0x860C=16倍，0xA60C=32倍
	
	str r2, [r0, r1]


	ldr r1, = 0x1100	@CTL
	movs r2, # 0x01
	str r2, [r0, r1]	@OPA1开

__TIMG4:
	@ADC触发源
	ldr r0, = 0x4008c000	@寄存器基址
	ldr r1, = 0x800		@寄存器偏移
	ldr r2, = 0x26000001	
	str r2, [r0, r1]	@开电源

	
	ldr r1, = 0x1008	@CLKSEL
	movs r2, # 0x08
	str r2, [r0, r1]	@时钟选择

	
	ldr r1, = 0x1058	@IMASK
				@GEN_EVENT0
	movs r2, # 0x01
	str r2, [r0, r1]	@触发ADC

	ldr r1, = 0x444		@FPUB_0
	movs r2, # 0x01
	str r2, [r0, r1]	@发布事件1

	
	ldr r1, = 0x1808	@LOAD寄存器
	ldr r2, = 399		@触发频率80KHZ
	str r2, [r0, r1]	@写入定时器最大计数值
	
	ldr r1, = 0x1804	@CTRCTL
	movs r2, # 0x03
	str r2, [r0, r1]	@ 开定时器

	b __dma1		@跳过DMA0
	
__dma0:
	ldr r0, = 0x4042a000	@DMA寄存器基址
	ldr r1, = 0x1110	@DMATCTL寄存器偏移地址
	movs r2, # 0x03		@adc0 触发通道选择
	str r2, [r0, r1]


	ldr r1, = 0x1204	@DMASA寄存器偏移地址
	ldr r2, = 0x4055a280	@0x4055a280	@传输源地址，ADC别名区
	str r2, [r0, r1]

	ldr r1, = 0x1208	@DMADA寄存器偏移地址
	ldr r2, = dianyabiao    @传输目标地址
	str r2, [r0, r1]

	ldr r1, = 0x120c	@DMASZ寄存器偏移地址
	ldr r2, = 800		@传输数量
	str r2, [r0, r1]

	ldr r1, = 0x1200	@DACCTL控制寄存器偏移地址
	ldr r2, = 0x20301102	@0x20303302	@0x20301102	
	str r2, [r0, r1]	@开DMA，设置传输模式


__dma1:	
	ldr r0, = 0x4042a000    @DMA寄存器基址
        ldr r1, = 0x1114        @DMATCTL寄存器偏移地址
        movs r2, # 0x03         @adc0 触发通道选择
        str r2, [r0, r1]

        ldr r1, = 0x1214        @DMASA寄存器偏移地址
        ldr r2, = 0x4055a280    @0x4055a280     @传输源地址，ADC别名区
        str r2, [r0, r1]

        ldr r1, = 0x1218        @DMADA寄存器偏移地址
        ldr r2, = dianyabiao    @传输目标地址
        str r2, [r0, r1]

        ldr r1, = 0x121c        @DMASZ寄存器偏移地址
        ldr r2, = 800          @传输数量
        str r2, [r0, r1]

        ldr r1, = 0x1210        @DACCTL控制寄存器偏移地址
        ldr r2, = 0x301102    @0x20303302     @0x20301102
        str r2, [r0, r1]        @开DMA，设置传输模式

__dma2:
        ldr r0, = 0x4042a000    @DMA寄存器基址
        ldr r1, = 0x1118        @DMATCTL寄存器偏移地址
	movs r2, # 0x03         @adc0 触发通道选择
	str r2, [r0, r1]

        ldr r1, = 0x1224        @DMASA寄存器偏移地址
	ldr r2, = 0x4055a284    @0x4055a280     @传输源地址，ADC别名区
        str r2, [r0, r1]

        ldr r1, = 0x1228        @DMADA寄存器偏移地址
        ldr r2, = dianyabiao1    @传输目标地址
        str r2, [r0, r1]

	ldr r1, = 0x122c        @DMASZ寄存器偏移地址
        ldr r2, = 800          @传输数量
        str r2, [r0, r1]

	ldr r1, = 0x1220        @DACCTL控制寄存器偏移地址
        ldr r2, = 0x301102    @0x20303302     @0x20301102
        str r2, [r0, r1]        @开DMA，设置传输模式


	
__adc0:
	ldr r0, = 0x40004000	@寄存器基址
	ldr r1, = 0x800		@寄存器偏移
	ldr r2, = 0x26000001	
	str r2, [r0, r1]	@开电源

	ldr r1, = 0x400		@FSUB_0
	movs r2, # 0x01
	str r2, [r0, r1]	@订阅TIM发布的事件1

	ldr r1, = 0x808		@CLKCFG  ADC时钟配置寄存器
	ldr r2, = 0xa9000001	@0xa9000002
	str r2, [r0, r1]

	ldr r1, = 0x1088	@IMASK
				@DMA_TRIG
	ldr r2, = 0x200
	str r2, [r0, r1]	@那个通道触发DMA

	ldr r1, = 0x1110	@CLKFREQ 采样时钟范围
	movs r2, # 5
	str r2, [r0, r1]

	ldr r1, = 0x1104  	@CTL1 控制寄存器1
	ldr r2, = 0x30001	@硬件触发
	str r2, [r0, r1]	@序列重复转换

	ldr r1, = 0x1108	@CTL2控制寄存器2
	ldr r2, = 0x1000900	@0x3000900
	str r2, [r0, r1] 	@转换序列选择

	ldr r1, = 0x1180        @MEMCTL 转换存储器控制寄存器
        ldr r2, = 0x100000c     @通道12_OPA0
	str r2, [r0, r1]	@


	
	ldr r1, = 0x1184	@MEMCTL 转换存储器控制寄存器
	ldr r2, = 0x100000d	@通道13_OPA1
	str r2, [r0, r1]	@
	
	ldr r1, = 0x1100  	@CTL0 控制寄存器 0
	ldr r2, = 0x3010001	@ 0x3010001	
	str r2, [r0, r1]	@开ADC，8分频

	ldr r4, = 0xe000e010
	ldr r3, = 399999			
	str r3, [r4, # 4]
	str r3, [r4, # 8]
	movs r3, # 0x07
	str r3, [r4]    @systick 开
	
	bl __lcd_chushihua
	bl __lcd_qingping

__TIMG0:
	ldr r0, = 0x40084000	@寄存器基址
	ldr r1, = 0x800		@寄存器偏移
	ldr r2, = 0x26000001	
	str r2, [r0, r1]	@开电源

	
	ldr r1, = 0x1008	@CLKSEL
	movs r2, # 0x08
	str r2, [r0, r1]	@时钟选择

	
	ldr r1, = 0x1100	@CCPD
	movs r2, # 0x02
	str r2, [r0, r1]	@c1输出

	
	ldr r1, = 0x1808	@LOAD寄存器
	ldr r2, = 1599
	str r2, [r0, r1]	@写入定时器最大计数值

@	ldr r1, = 0x1814	@CC_01[y]
@	ldr r2, = 0x7fff	@PWM占空比
@	str r2, [r0, r1]	@比较寄存器


	ldr r1, = 0x1874	@CCACT
	movs r2, # 0x03		@ZACT = 3
@	ldr r2, = 0x50		@CDACT=1,LACT=2
       str r2, [r0, r1]		@设置比较模式


	
	ldr r1, = 0x1804	@CTRCTL
	movs r2, # 0x03
	str r2, [r0, r1]	@ 开定时器
	
ting:
	bl __xianshi_shangxia_bi
	b ting
	
	ldr r1, = 1000000
	ldr r2, = ji_shu
	ldr r0, [r2]
	adds r0, r0, # 1
	str r0, [r2]
	cmp r0, r1
	bne __xianshi_ji_shu
	movs r0, # 0
	str r0, [r2]
__xianshi_ji_shu:
	@ldr r0, = 654321
        movs r1, # 6
        ldr r2, = asciibiao
        movs r3, # 0xff            @小数点位置
        bl _zhuanascii
        movs r0, # 6            @写几个字
        movs r1, # 48           @字库单字长度
        movs r2, # 3            @宽度
        ldr r3, = 0x1102              @lcd位置
        bl __xie_lcd_ascii
	b ting
	.ltorg




__xianshi_shangxia_bi:
	push {r0-r7,lr}
	ldr r0, = cos_r
	ldr r1, = cos_i
	ldr r0, [r0]
	ldr r7, [r1]
	movs r6, r0
	bmi __shangbi_r_shi_fu
__shangbi_r_bushi_fu:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	movs r2, # 0x00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_shangbi_r
__shangbi_r_shi_fu:
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	movs r2, # 0x00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	mvns r6, r6
	adds r6, r6, # 1
__xianshi_shangbi_r:
	mov r0, r6
	movs r1, # 8             @转换几个字符
	ldr r2, = asciibiao
	movs r3, # 0xff             @小数点位置
	bl __zhuanascii
	ldr r0, = asciibiao
	movs r1, # 8           @显示几个字符
	ldr r2, = 0x800         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii

        movs r6, r7
	bmi __shangbi_i_shi_fu
__shangbi_i_bushi_fu:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x4200         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_shangbi_i
__shangbi_i_shi_fu:
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x4200         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	mvns r6, r6
	adds r6, r6, # 1
__xianshi_shangbi_i:
	mov r0, r6
	movs r1, # 8             @转换几个字符
	ldr r2, = asciibiao
	movs r3, # 0xff             @小数点位置
	bl __zhuanascii
	ldr r0, = asciibiao
	movs r1, # 8           @显示几个字符
	ldr r2, = 0x4a00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii

        ldr r0, = sin_r
	ldr r1, = sin_i
	ldr r0, [r0]
	ldr r7, [r1]
	movs r6, r0
	bmi __xiabi_r_shi_fu
__xiabi_r_bushi_fu:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	movs r2, # 0x01         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_xiabi_r
__xiabi_r_shi_fu:
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	movs r2, # 0x01         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	mvns r6, r6
	adds r6, r6, # 1
__xianshi_xiabi_r:
	mov r0, r6
	movs r1, # 8             @转换几个字符
	ldr r2, = asciibiao
	movs r3, # 0xff             @小数点位置
	bl __zhuanascii
	ldr r0, = asciibiao
	movs r1, # 8           @显示几个字符
	ldr r2, = 0x801         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii

	movs r6, r7
	bmi __xiabi_i_shi_fu
__xiabi_i_bushi_fu:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x4201         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_xiabi_i
__xiabi_i_shi_fu:
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x4201         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	mvns r6, r6
	adds r6, r6, # 1
__xianshi_xiabi_i:
	mov r0, r6
	movs r1, # 8             @转换几个字符
	ldr r2, = asciibiao
	movs r3, # 0xff             @小数点位置
	bl __zhuanascii
	ldr r0, = asciibiao
	movs r1, # 8           @显示几个字符
	ldr r2, = 0x4a01         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	pop {r0-r7,pc}
	

	


__dft:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	mov r6, r10
	mov r7, r12
	push {r4-r7}
	ldr r0, = cos_sin_biao
	ldr r1, = dianyabiao
	ldr r2, = dianyabiao1
	movs r6, # 0
	mov r7, r6
	mov r8, r6
	mov r9, r6
	mov r12, sp
	mov r10, r1
	mov r14, r2
	mov sp, r0
	b __dft_xunhuan
	.ltorg
__dft_xunhuan:
	@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm1
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm2
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm3
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm4
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm5
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm6
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm7
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm8
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm9
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	


	ldr r0, = 0x20000740
	cmp r10, r0
	beq __dft_fanhuile
	ldr r0, = __dft_xunhuan
	adds r0, r0, # 1
	mov pc, r0
__dft_fanhuile:
	mov r0, r6	@cos_r
	mov r1, r7	@cos_i
	mov r2, r8	@sin_r
	mov r3, r9	@sin_i
	asrs r0, r0, # 9	@dfdf
	asrs r1, r1, # 9
	asrs r2, r2, # 9
	asrs r3, r3, # 9
	mov sp, r12
	pop {r4-r7}
	mov r8, r4
	mov r9, r5
	mov r10, r6
	mov r12, r7
	pop {r4-r7,pc}
	.ltorg








	
	
__lcd_chushihua:
	push {r0-r2,lr}
	ldr r0,  = 0x400a1290	@pa基地址+0x1290
	movs r1, # 0x10
	str r1, [r0]            @RST=1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	str r1, [r0, 0x10]            @RST=0
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	str r1, [r0]            @RST=1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi
	
	movs r1, # 0x08
	str r1, [r0, # 0x10]		@A0=0
	
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	movs r0, # 0xa2         @ 偏置选择
	bl __xie_spi1
	movs r0, # 0xa0         @SEG方向（横 0=0到131，1=131到0）
	bl __xie_spi1
	movs r0, # 0xc8         @选择COM方向（竖 0=0到63, 1=63到1）
	bl __xie_spi1
	movs r0, # 0x2f         @选择调节率
	bl __xie_spi1
	movs r0, # 0x81         @设置EV命令
	bl __xie_spi1
	movs r0, # 0x25         @设置EV（0x00-0x3f 对比度）
	bl __xie_spi1
	movs r0, # 0x2f         @助推器开启
	bl __xie_spi1           @调节器开、追踪器开
	movs r0, # 0xaf         @显示开
	bl __xie_spi1
	pop {r0-r2,pc}

__lcd_yanshi:
	subs r2, r2, # 1
	bne __lcd_yanshi
	bx lr
	
__xie_spi1:
	@入口R0要写的数据
	push {r1-r2}
	ldr r1, = 0x40469110
__deng_huan_chong_kong:
	ldr r2, [r1]
	lsls r2, r2, # 31
	bpl __deng_huan_chong_kong
	str r0, [r1, # 0x30]
__deng_huan_chong_kong1:
	ldr r2, [r1]
	lsls r2, r2, # 31
	bpl __deng_huan_chong_kong1
__busy_zong_xian_mang:
	ldr r2, [r1]
	lsls r2, r2, # 23
	bmi __busy_zong_xian_mang
	pop {r1-r2}
	bx lr

	
__xie_lcd_ye:
	@入口R0=数据首地址
	push {r1-r4,lr}
	movs r3, # 0xb0
	subs r3, r3, # 1
	mov r4, r0
__ye_jia:
        ldr r0, = 0x400a1290
	movs r1, # 0x08
	str r1, [r0]            @A0=1
	ldr r2, = 0xff
	bl __lcd_yanshi
	adds r3, r3, # 1
	cmp r3, # 0xb9
	bne __xie_ye_dizhi
	pop {r1-r4,pc}
	
__xie_ye_dizhi:
	movs r0, # 0x10
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	mov r0, r3
	bl __xie_spi1
	
        ldr r0, = 0x400a1290
        movs r1, # 0x08
        str r1, [r0]            @A0=1
	
	ldr r2, = 0xff
	bl __lcd_yanshi

	movs r1, # 132
__heng_sao:
	ldrb r0, [r4]
	bl __xie_spi1
	adds r4, r4, # 1
	subs r1, r1, # 1
	bne __heng_sao
	b __ye_jia

__lcd_qingping:
	push {r0-r4,lr}
	movs r3, # 0xb0
	subs r3, r3, # 1
	movs r4, # 0
__ye_jia1:
        ldr r0, = 0x400a1290
	movs r1, # 0x08
	str r1, [r0, # 0x10]            @A0=0
	ldr r2, = 0xff
	bl __lcd_yanshi
	adds r3, r3, # 1
	cmp r3, # 0xb9
	bne __xie_ye_dizhi1
	pop {r0-r4,pc}
__xie_ye_dizhi1:
	movs r0, # 0x10
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	mov r0, r3
	bl __xie_spi1
	movs r2, # 0xff
	bl __lcd_yanshi

        ldr r0, = 0x400a1290
        movs r1, # 0x08
	str r1, [r0]            @A0=1

	
	ldr r2, = 0xff
	bl __lcd_yanshi
	movs r1, # 133
__heng_sao1:
	mov r0, r4
	bl __xie_spi1
	subs r1, r1, # 1
	bne __heng_sao1
	b __ye_jia1


__xie_lcd_weizhi:
	@入口R0=要写的地址(低8=X，高8=Y=（0-131(r5=高4,R4=低4))
	push {r1-r5,lr}
	mov r5, r0
	mov r4, r0
	lsls r0, r0, # 24
	lsrs r0, r0, # 24
	lsrs r5, r5, # 12	@高4
	lsls r4, r4, # 20
	lsrs r4, r4, # 28
        ldr r1, = 0x400a1290
	movs r3, # 0x08
	str r3, [r1, # 0x10]            @A0=0
	ldr r2, = 0xff
	bl __lcd_yanshi
	adds r0, r0, # 0xb0     @写页命令0XB0
	bl __xie_spi1		@写页地址0-8页

	movs r0, # 0x10
	orrs r0, r0, r5
	bl __xie_spi1

	mov r0, r4
	bl __xie_spi1

	movs r3, # 0x08
	strh r3, [r1]            @A0=1
	ldr r2, = 0xff
	bl __lcd_yanshi
	pop {r1-r5,pc}


__xie_ascii:
	push {r3-r7,lr}
	@入口r0=ascii地址
	@r1=写几个字
	@r2=要写的地址
	mov r6, r9
	push {r6}
	mov r9, r2
	mov r7, r1
	movs r1, # 6
	movs r2, # 1
	mov r5, r0
	movs r6, # 0
__xie_lcd_dizhi2:
	mov r0, r9
	bl __xie_lcd_weizhi
__du_ascii2:
	ldrb r0, [r5, r6]
	subs r0, r0, # 32
	muls r0, r0, r1
	ldr r3, = ascii_biao
	add r3, r3, r0
__du_ziku_chushihua2:
	movs r4, # 0
__du_ziku1:
	ldrb r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_ziku1
	bl __xie_spi1
	b __du_ziku1
__duwan_ziku1:
	adds r6, r6, # 1
	cmp r6, r7
	bne __du_ascii2
	pop {r6}
	mov r6, r9
	pop {r3-r7,pc}

__xie_alabo:
	push {r5-r7,lr}
	@入口r0=写几个字
	@r1=字库单字长度
	@r2=y宽（几行）
	@r3=要写的地址
	mov r5, r9
	mov r6, r10
	mov r7, r11
	push {r5-r7}
	mov r5, r12
	push {r5}
	ldr r5, = asciibiao
	mov r12, r4
	mov r9, r3
	movs r6, # 0
	mov r7, r6
	mov r10, r0
	mov r11, r2
__xie_lcd_dizhi1:
	mov r0, r9
	bl __xie_lcd_weizhi
__du_ascii1:
	ldrb r0, [r5, r6]
	muls r0, r0, r1
	mov r3, r12
	add r3, r3, r0
	adds r3, r3, r7
__du_ziku_chushihua1:
	movs r4, # 0
__du_ziku:
	ldrb r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_ziku
	bl __xie_spi1
	b __du_ziku
__duwan_ziku:
	adds r6, r6, # 1
	cmp r6, r10
	bne __du_ascii1
	movs r6, # 0
	adds r7, r7, # 1        @字库地址偏移
	mov r0, r9
	adds r0, r0, # 1        @Y偏移
	mov r9, r0
	cmp r7, r11
	bne __xie_lcd_dizhi1
	pop {r5}
	mov r12, r5
	pop {r5-r7}
	mov r9, r5
	mov r10, r6
	mov r11, r7
	pop {r5-r7,pc}



__xie_lcd_ascii:
	push {r4-r7,lr}
	@入口r0=写几个字
	@r1=字库单字长度
	@r2=y宽（几行）
	@r3=要写的地址
	mov r4, r9
	mov r5, r10
	mov r6, r11
	mov r7, r12
	push {r4-r7}
	ldr r5, = asciibiao
	mov r9, r3
	movs r6, # 0
	mov r7, r6
	mov r12, r6
	mov r10, r0
	mov r11, r2
__xie_lcd_dizhi:
	mov r0, r9
	bl __xie_lcd_weizhi
__du_ascii:
	ldrb r0, [r5, r6]
	cmp r0, # 0x2e
	beq __xie_ascii_xiaoshudian
	muls r0, r0, r1

	ldr r3, = da_a_labo_hack  @da_a_labo_shuzi
	add r3, r3, r0
	adds r3, r3, r7
__du_ziku_16_chushihua:
	movs r4, # 0
__du_ziku_16:
	ldrb r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_16
	bl __xie_spi1
	b __du_ziku_16
__duwan_16:
	adds r6, r6, # 1
	cmp r6, r10
	bne __du_ascii
	movs r6, # 0
	adds r7, r7, # 1	@字库地址偏移
	mov r0, r9
	adds r0, r0, # 1	@Y偏移
	mov r9, r0
	cmp r7, r11
	bne __xie_lcd_dizhi
	pop {r4-r7}
	mov r9, r4
	mov r10, r5
	mov r11, r6
	mov r12, r7
	pop {r4-r7,pc}

__xie_ascii_xiaoshudian:
	mov r0, r12
	adds r0, r0, # 1
	mov r12, r0
	cmp r12, r2
	beq __xie_ru_xiaoshudian
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1

	b __duwan_16
__xie_ru_xiaoshudian:
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0x70
	bl __xie_spi1
	movs r0, # 0x70
	bl __xie_spi1
	movs r0, # 0x70
	bl __xie_spi1
	b __duwan_16

_zhuanascii:														@ 16进制转ASCII
	@ R0要转的数据， R1长度，R2结果表首地址, r3=小数点位置
	push {r4-r7,lr}
	mov r7, r3
	mov r5, r0
	mov r6, r1
	movs r1, # 10
_xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	@	adds r3, r3, # 0x30	@ascii偏移
	mov r5, r0
	subs r6, r6, # 1
	beq _qiumafanhui
	cmp r6, r7
	bne _meidaoxiaoshudian
	movs r4, # 0x2e		@小数点
	strb r4, [r2,r6]	@插入小数点
	subs r6, r6, # 1
_meidaoxiaoshudian:
	strb r3, [r2,r6]
	movs r6, r6
	bne _xunhuanqiuma
	pop {r4-r7,pc}
_qiumafanhui:
	strb r3, [r2, r6]
	pop {r4-r7,pc}

__zhuanascii:								              @ 转ASCII
	@ R0要转的数据， R1长度，R2结果表首地址, r3=小数点位置
	push {r4-r7,lr}
	mov r7, r3
	mov r5, r0
	mov r6, r1
	movs r1, # 10
__xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	adds r3, r3, # 0x30     @ascii偏移
	mov r5, r0
	subs r6, r6, # 1
	beq __qiumafanhui
	cmp r6, r7
	bne __meidaoxiaoshudian
	movs r4, # 0x2e         @小数点
	strb r4, [r2,r6]        @插入小数点
	subs r6, r6, # 1
__meidaoxiaoshudian:
	strb r3, [r2,r6]
	movs r6, r6
	bne __xunhuanqiuma
	pop {r4-r7,pc}
__qiumafanhui:
	strb r3, [r2, r6]
	pop {r4-r7,pc}
	.ltorg

_chufa:						@软件除法
	@ r0 除以 r1 等于 商(r0)
	push {r1-r4,lr}
	cmp r0, # 0
	beq _chufafanhui
	cmp r1, # 0
	beq _chufafanhui
	mov r2, r0
	movs r3, # 1
	lsls r3, r3, # 31
	movs r0, # 0
	mov r4, r0
_chufaxunhuan:
	lsls r2, r2, # 1
	adcs r4, r4, r4
	cmp r4, r1
	bcc _chufaweishubudao0
	adds r0, r0, r3
	subs r4, r4, r1
_chufaweishubudao0:
	lsrs r3, r3, # 1
	bne _chufaxunhuan
_chufafanhui:
	pop {r1-r4,pc}
	.ltorg
_nmi:
_Hard_Fault:
_svc_handler:
_pendsv_handler:	
_systickzhongduan:
	push {r0-r5,lr}
        ldr r0, = 0x4042b210    @DMA寄存器基址
        @DMADA寄存器偏移地址
        ldr r2, = dianyabiao    @传输目标地址
        str r2, [r0, # 0x08]
	ldr r2, = dianyabiao1
	str r2, [r0, # 0x18]
        @DMASZ寄存器偏移地址
        ldr r2, = 800          @传输数量
        str r2, [r0, # 0x0c]
	str r2, [r0, # 0x1c]
        @DACCTL控制寄存器偏移地址
        ldr r2, = 0x301102   
        str r2, [r0]        @开DMA，设置传输模式
	str r2, [r0, # 0x10]


	bl __dft
	asrs r0, r0, # 7
	asrs r1, r1, # 7
	asrs r2, r2, # 7
	asrs r3, r3, # 7
	
	ldr r4, = cos_r
	str r0, [r4]
	str r1, [r4, # 0x04]
	str r2, [r4, # 0x08]
	str r3, [r4, # 0x0c]
__systick_fanhui:
	ldr r0, = 0xe0000d04
	ldr r1, = 0x02000000
	str r1, [r0]	@ 清除SYSTICK中断

	pop {r0-r5,pc}


	
aaa:
	bx lr
	
	.section .data
	.equ zhanding,		0x20000100
	.equ dianyabiao,	0x20000100
	.equ dianyabiao1,	0x20000740
	.equ cos_r,		0x20000fcc
	.equ cos_i,		0x20000fd0
	.equ sin_r,		0x20000fd4
	.equ sin_i,		0x20000fd8
	.equ ji_shu,		0x20000fdc
	.equ asciibiao,		0x20000fe0




	@@@ascii_码表@@@@
kong:
	.int 0x20202020
fu:
	.ascii "!!"
_fu:
	.ascii "-"
	











	
	.align 4
cos_sin_biao:
	.int 0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0xFFFFFFFF,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0001,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFD,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0002,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0002,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0003,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0xFFFFFFFE,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0002,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0001,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0001,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0002,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0001,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0001,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0xFFFFFFFE,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0xFFFFFFFF,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0002,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0003,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0003,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFD,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFE,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFE,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFD,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0xFFFFFFFF,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0003,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0xFFFFFFFF,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0xFFFFFFFF,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0001,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0001,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0001,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0001,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0002,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0002,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0003,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0002,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0003,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0003,0x0001,0x8000,0x8000,0x0000,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0002,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFD,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0001,0x0001,0x8000,0x8000,0xFFFFFFFF,0xFFFFFFFF,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFE,0xFFFFFFFE,0xFFFF8000,0xFFFF8000,0x0002,0x0002,0x8000,0x8000,0xFFFFFFFD,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000,0x8000,0x0000,0x0000,0xFFFF8000,0xFFFF8000,0x0000,0x0000,0x8000

	
	.align 4
da_a_labo_hack:			 @16*24
	.byte 0x00, 0x00, 0x00, 0x80, 0xFF, 0x01, 0xF0, 0xFF, 0x0F, 0xF8, 0xFF, 0x1F, 0x7C, 0x00, 0x3E, 0x1E, 0x00, 0x78, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x1E, 0x00, 0x78, 0x7C, 0x00, 0x3E, 0xF8, 0xFF, 0x1F, 0xF0, 0xFF, 0x0F, 0x80, 0xFF, 0x01, 0x00, 0x00, 0x00 @ 0
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x00, 0x70, 0x70, 0x00, 0x70, 0x70, 0x00, 0x70, 0x78, 0x00, 0x70, 0xFC, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @ 1
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x78, 0x1C, 0x00, 0x7C, 0x1C, 0x00, 0x7E, 0x0E, 0x00, 0x77, 0x0E, 0x00, 0x77, 0x0E, 0x80, 0x73, 0x0E, 0xC0, 0x71, 0x0E, 0xE0, 0x70, 0x1E, 0x78, 0x70, 0x1E, 0x3C, 0x70, 0xFC, 0x1F, 0x70, 0xF8, 0x07, 0x70, 0xF0, 0x03, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00 @ 2
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x1C, 0x00, 0x38, 0x1C, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x3E, 0x78, 0x1C, 0x37, 0x3C, 0xFC, 0xF3, 0x3F, 0xF8, 0xE3, 0x1F, 0xF0, 0xC0, 0x07, 0x00, 0x00, 0x00 @ 3
	.byte 0x00, 0xE0, 0x01, 0x00, 0xF0, 0x01, 0x00, 0xFC, 0x01, 0x00, 0xFE, 0x01, 0x00, 0xDF, 0x01, 0x80, 0xCF, 0x01, 0xE0, 0xC3, 0x01, 0xF0, 0xC1, 0x01, 0xF8, 0xC0, 0x01, 0x7C, 0xC0, 0x01, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01 @ 4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0xFE, 0x1F, 0x38, 0xFE, 0x0F, 0x70, 0xFE, 0x0F, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x1E, 0x78, 0x0E, 0x3C, 0x3C, 0x0E, 0xFC, 0x1F, 0x0E, 0xF8, 0x0F, 0x0E, 0xE0, 0x07, 0x00, 0x00, 0x00 @ 5
	.byte 0x00, 0x00, 0x00, 0x00, 0xFE, 0x03, 0xC0, 0xFF, 0x0F, 0xF0, 0xFF, 0x1F, 0xF8, 0x1C, 0x3E, 0x3C, 0x0C, 0x78, 0x1C, 0x0E, 0x70, 0x1E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x1E, 0x78, 0x0E, 0x3C, 0x3C, 0x1E, 0xFC, 0x1F, 0x00, 0xF8, 0x0F, 0x00, 0xE0, 0x07, 0x00, 0x00, 0x00 @ 6
	.byte 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x0E, 0x00, 0x40, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x7C, 0x0E, 0x00, 0x7F, 0x0E, 0xC0, 0x1F, 0x0E, 0xF0, 0x07, 0x0E, 0xFC, 0x00, 0x0E, 0x3F, 0x00, 0xCE, 0x0F, 0x00, 0xFE, 0x03, 0x00, 0xFE, 0x00, 0x00, 0x3E, 0x00, 0x00, 0x00, 0x00, 0x00 @ 7
	.byte 0x00, 0x00, 0x00, 0x00, 0xC0, 0x07, 0xF0, 0xE1, 0x1F, 0xF8, 0xF3, 0x3F, 0xFC, 0x3F, 0x3C, 0x1E, 0x1F, 0x78, 0x0E, 0x0E, 0x70, 0x0E, 0x0C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x18, 0x70, 0x1E, 0x3C, 0x78, 0xFC, 0x7F, 0x3C, 0xF8, 0xF3, 0x3F, 0xF0, 0xE1, 0x1F, 0x00, 0xC0, 0x07, 0x00, 0x00, 0x00 @ 8
	.byte 0x00, 0x00, 0x00, 0xE0, 0x07, 0x00, 0xF0, 0x1F, 0x00, 0xF8, 0x3F, 0x78, 0x3C, 0x3C, 0x70, 0x1E, 0x78, 0x70, 0x0E, 0x70, 0x70, 0x0E, 0x70, 0x70, 0x0E, 0x70, 0x78, 0x0E, 0x70, 0x38, 0x1E, 0x30, 0x3C, 0x7C, 0x38, 0x1F, 0xF8, 0xFF, 0x0F, 0xF0, 0xFF, 0x03, 0xC0, 0x7F, 0x00, 0x00, 0x00, 0x00 @ 9
	.align 4
ascii_biao:				@6*8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @
	@	.byte 0x00, 0x00, 0x00, 0x4F, 0x00, 0x00 @ !	
	.byte 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c @ !		@上面是对的
	.byte 0x00, 0x00, 0x07, 0x00, 0x07, 0x00 @ "
	.byte 0x00, 0x14, 0x7F, 0x14, 0x7F, 0x14 @ #
	.byte 0x00, 0x24, 0x2A, 0x7F, 0x2A, 0x12 @ $
	.byte 0x00, 0x23, 0x13, 0x08, 0x64, 0x62 @ %
	.byte 0x00, 0x36, 0x49, 0x55, 0x22, 0x50 @ &
	.byte 0x00, 0x00, 0x05, 0x03, 0x00, 0x00 @ '
	.byte 0x00, 0x00, 0x1C, 0x22, 0x41, 0x00 @ (
	.byte 0x00, 0x00, 0x41, 0x22, 0x1C, 0x00 @ )
	.byte 0x00, 0x14, 0x08, 0x3E, 0x08, 0x14 @ *
	.byte 0x00, 0x08, 0x08, 0x3E, 0x08, 0x08 @ +
	.byte 0x00, 0x00, 0x50, 0x30, 0x00, 0x00 @ ,
	.byte 0x00, 0x08, 0x08, 0x08, 0x08, 0x08 @ -
	.byte 0x00, 0x00, 0x60, 0x60, 0x00, 0x00 @ .
	.byte 0x00, 0x20, 0x10, 0x08, 0x04, 0x02 @ /
	.byte 0x00, 0x3E, 0x51, 0x49, 0x45, 0x3E @ 0
	.byte 0x00, 0x00, 0x42, 0x7F, 0x40, 0x00 @ 1
	.byte 0x00, 0x42, 0x61, 0x51, 0x49, 0x46 @ 2
	.byte 0x00, 0x21, 0x41, 0x45, 0x4B, 0x31 @ 3
	.byte 0x00, 0x18, 0x14, 0x12, 0x7F, 0x10 @ 4
	.byte 0x00, 0x27, 0x45, 0x45, 0x45, 0x39 @ 5
	.byte 0x00, 0x3C, 0x4A, 0x49, 0x49, 0x30 @ 6
	.byte 0x00, 0x01, 0x01, 0x79, 0x05, 0x03 @ 7
	.byte 0x00, 0x36, 0x49, 0x49, 0x49, 0x36 @ 8
	.byte 0x00, 0x06, 0x49, 0x49, 0x29, 0x1E @ 9
	.byte 0x00, 0x00, 0x36, 0x36, 0x00, 0x00 @ :
	.byte 0x00, 0x00, 0x56, 0x36, 0x00, 0x00 @ ;
	.byte 0x00, 0x08, 0x14, 0x22, 0x41, 0x00 @ <
	.byte 0x00, 0x14, 0x14, 0x14, 0x14, 0x14 @ =
	.byte 0x00, 0x00, 0x41, 0x22, 0x14, 0x08 @ >
	.byte 0x02, 0x01, 0x51, 0x09, 0x06, 0x00 @ ?
	.byte 0x00, 0x32, 0x49, 0x79, 0x41, 0x3E @ @
	.byte 0x00, 0x7E, 0x11, 0x11, 0x11, 0x7E @ A
	.byte 0x00, 0x41, 0x7F, 0x49, 0x49, 0x36 @ B
	.byte 0x00, 0x3E, 0x41, 0x41, 0x41, 0x22 @ C
	.byte 0x00, 0x41, 0x7F, 0x41, 0x41, 0x3E @ D
	.byte 0x00, 0x7F, 0x49, 0x49, 0x49, 0x49 @ E
	.byte 0x00, 0x7F, 0x09, 0x09, 0x09, 0x09 @ F
	.byte 0x00, 0x3E, 0x41, 0x41, 0x51, 0x72 @ G
	.byte 0x00, 0x7F, 0x08, 0x08, 0x08, 0x7F @ H
	.byte 0x00, 0x00, 0x41, 0x7F, 0x41, 0x00 @ I
	.byte 0x00, 0x20, 0x40, 0x41, 0x3F, 0x01 @ J
	.byte 0x00, 0x7F, 0x08, 0x14, 0x22, 0x41 @ K
	.byte 0x00, 0x7F, 0x40, 0x40, 0x40, 0x40 @ L
	.byte 0x00, 0x7F, 0x02, 0x0C, 0x02, 0x7F @ M
	.byte 0x81, 0x7F, 0x06, 0x08, 0x30, 0x7F @ N
	.byte 0x00, 0x3E, 0x41, 0x41, 0x41, 0x3E @ O
	.byte 0x00, 0x7F, 0x09, 0x09, 0x09, 0x06 @ P
	.byte 0x00, 0x3E, 0x41, 0x51, 0x21, 0x5E @ Q
	.byte 0x00, 0x7F, 0x09, 0x19, 0x29, 0x46 @ R
	.byte 0x00, 0x26, 0x49, 0x49, 0x49, 0x32 @ S
	.byte 0x00, 0x01, 0x01, 0x7F, 0x01, 0x01 @ T
	.byte 0x00, 0x3F, 0x40, 0x40, 0x40, 0x3F @ U
	.byte 0x00, 0x1F, 0x20, 0x40, 0x20, 0x1F @ V
	.byte 0x00, 0x7F, 0x20, 0x18, 0x20, 0x7F @ W
	.byte 0x00, 0x63, 0x14, 0x08, 0x14, 0x63 @ X
	.byte 0x00, 0x07, 0x08, 0x70, 0x08, 0x07 @ Y
	.byte 0x00, 0x61, 0x51, 0x49, 0x45, 0x43 @ Z
	.byte 0x00, 0x00, 0x7F, 0x41, 0x41, 0x00 @ [
	.byte 0x00, 0x02, 0x04, 0x08, 0x10, 0x20 @ BackSlash
	.byte 0x00, 0x00, 0x41, 0x41, 0x7F, 0x00 @ ]
	.byte 0x00, 0x04, 0x02, 0x01, 0x02, 0x04 @ ^
	.byte 0x00, 0x40, 0x40, 0x40, 0x40, 0x40 @ _
	.byte 0x00, 0x01, 0x02, 0x04, 0x00, 0x00 @ `
	.byte 0x00, 0x20, 0x54, 0x54, 0x54, 0x78 @ a
	.byte 0x00, 0x7F, 0x48, 0x44, 0x44, 0x38 @ b
	.byte 0x00, 0x38, 0x44, 0x44, 0x44, 0x28 @ c
	.byte 0x00, 0x38, 0x44, 0x44, 0x48, 0x7F @ d
	.byte 0x00, 0x38, 0x54, 0x54, 0x54, 0x18 @ e
	.byte 0x00, 0x00, 0x08, 0x7E, 0x09, 0x02 @ f
	.byte 0x00, 0x0C, 0x52, 0x52, 0x4C, 0x3E @ g
	.byte 0x00, 0x7F, 0x08, 0x04, 0x04, 0x78 @ h
	.byte 0x00, 0x00, 0x44, 0x7D, 0x40, 0x00 @ i
	.byte 0x00, 0x20, 0x40, 0x44, 0x3D, 0x00 @ j
	.byte 0x00, 0x00, 0x7F, 0x10, 0x28, 0x44 @ k
	.byte 0x00, 0x00, 0x41, 0x7F, 0x40, 0x00 @ l
	.byte 0x00, 0x78, 0x04, 0x78, 0x04, 0x78 @ m
	.byte 0x00, 0x7C, 0x08, 0x04, 0x04, 0x78 @ n
	.byte 0x00, 0x38, 0x7C, 0x7C, 0x7C, 0x38 @ o
	.byte 0x00, 0x7E, 0x0C, 0x12, 0x12, 0x0C @ p
	.byte 0x00, 0x0C, 0x12, 0x12, 0x0C, 0x7E @ q
	.byte 0x00, 0x7C, 0x08, 0x04, 0x04, 0x08 @ r
	.byte 0x00, 0x58, 0x54, 0x54, 0x54, 0x64 @ s
	.byte 0x00, 0x04, 0x3F, 0x44, 0x40, 0x20 @ t
	.byte 0x00, 0x3C, 0x40, 0x40, 0x3C, 0x40 @ u
	.byte 0x00, 0x1C, 0x20, 0x40, 0x20, 0x1C @ v
	.byte 0x00, 0x3C, 0x40, 0x30, 0x40, 0x3C @ w
	.byte 0x00, 0x44, 0x28, 0x10, 0x28, 0x44 @ x
	.byte 0x00, 0x1C, 0xA0, 0xA0, 0x90, 0x7C @ y
	.byte 0x00, 0x44, 0x64, 0x54, 0x4C, 0x44 @ z
	.byte 0x00, 0x00, 0x08, 0x36, 0x41, 0x00 @ {
	.byte 0x00, 0x00, 0x00, 0x77, 0x00, 0x00 @ |
	.byte 0x00, 0x00, 0x41, 0x36, 0x08, 0x00 @ }
	.byte 0x00, 0x02, 0x01, 0x02, 0x04, 0x02 @ ~
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @

	.align 4

danweibiao:			 @15*24
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0xC0, 0x00, 0x00, 0x80, 0x01, 0x00, 0x80, 0x03, 0x00, 0x80, 0x03, 0x00, 0x80, 0x03, 0x00, 0xE0, 0x01, 0xFE, 0x7F, 0x00, 0xFE, 0xFF, 0x01, 0xFE, 0xFF, 0x03, 0x00, 0x80, 0x03, 0x00, 0x80, 0x01 @ µ
	.byte 0x00, 0x7F, 0x70, 0xE0, 0xFF, 0x73, 0xF0, 0xFF, 0x77, 0xF8, 0x00, 0x7F, 0x38, 0x00, 0x7C, 0x3C, 0x00, 0x70, 0x1C, 0x00, 0x60, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x60, 0x3C, 0x00, 0x70, 0x38, 0x00, 0x7C, 0xF8, 0x00, 0x7F, 0xF0, 0xFF, 0x77, 0xE0, 0xFF, 0x73, 0x00, 0x7F, 0x70 @Ω
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x00, 0x00 @ F
	.byte 0x00, 0xF8, 0x7F, 0x00, 0xFC, 0x7F, 0x00, 0x1E, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0xF8, 0x7F, 0x00, 0xF8, 0x7F, 0x00, 0x1C, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x1E, 0x00, 0x00, 0xFC, 0x7F, 0x00, 0xF8, 0x7F, 0x00, 0x00, 0x00 @ m
	.byte 0x00, 0x00, 0x00, 0xFC, 0xFF, 0x0F, 0xFC, 0xFF, 0x0F, 0x3C, 0x00, 0x00, 0xF0, 0x01, 0x00, 0x80, 0x0F, 0x00, 0x00, 0x3C, 0x00, 0x00, 0x3C, 0x00, 0x80, 0x0F, 0x00, 0xF0, 0x01, 0x00, 0x3C, 0x00, 0x00, 0xFC, 0xFF, 0x0F, 0xFC, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @ M
	.byte 0x00, 0x00, 0x00, 0x80, 0xFF, 0x7F, 0x80, 0xFF, 0x7F, 0x80, 0xFF, 0x7F, 0x00, 0x07, 0x00, 0x80, 0x03, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x03, 0x00, 0xC0, 0xFF, 0x7F, 0x80, 0xFF, 0x7F, 0x00, 0xFE, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @ n
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x1C, 0xE0, 0x00, 0x0E, 0xC0, 0x00, 0x06, 0x80, 0x01, 0x06, 0x80, 0x01, 0x06, 0x80, 0x01, 0x0E, 0xC0, 0x01, 0x1C, 0xE0, 0x00, 0xFC, 0xFF, 0x00, 0xF8, 0x7F, 0x00, 0xE0, 0x1F, 0x00, 0x00, 0x00, 0x00   @ p
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F @ H
	.byte 0x00, 0x00, 0x00, 0xFC, 0xFF, 0x7F, 0xFC, 0xFF, 0x7F, 0xFC, 0xFF, 0x7F, 0x00, 0x7C, 0x00, 0x00, 0xFE, 0x00, 0x00, 0xEF, 0x01, 0x80, 0xC7, 0x03, 0xC0, 0x83, 0x07, 0xE0, 0x01, 0x0F, 0xF0, 0x00, 0x1E, 0x78, 0x00, 0x3C, 0x3C, 0x00, 0x78, 0x1C, 0x00, 0x70, 0x0C, 0x00, 0x60	@ K
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	@空
	
