/*************************************************************************
 * File name:		init.h
 * Description:		Declares function prototypes and global variables;
 *					defines and redefines parameters
 *************************************************************************/
#ifndef SRC_INIT_H_
#define SRC_INIT_H_

//----------------------------------------------------
// header files
//----------------------------------------------------
#include "xparameters.h"
#include "xgpio.h"
#include "xtmrctr.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "stdio.h"
#include "xiicps.h"
#include "sleep.h"
#include <stdbool.h>
#include "notes.h"

//----------------------------------------------------
// Function prototypes
//----------------------------------------------------
int Gpio_Init();
int Timer_Init();
int InterruptSystemSetup(XScuGic *XScuGicInstancePtr);
int IntcInitFunction(u16 DeviceId, XTmrCtr *TmrInstancePtr, XGpio *BtnInstancePtr,
		XGpio *SWInstancePtr);

//----------------------------------------------------
// Parameter definitions/re-definitions 
//----------------------------------------------------
#define INTC_DEVICE_ID 		XPAR_PS7_SCUGIC_0_DEVICE_ID
#define TMR_DEVICE_ID		XPAR_TMRCTR_0_DEVICE_ID

#define BTN_DEV_ID			XPAR_AXI_GPIO_BTN_DEVICE_ID
#define SW_DEV_ID			XPAR_AXI_GPIO_SW_DEVICE_ID
#define LEDS_DEV_ID			XPAR_AXI_GPIO_LEDS_DEVICE_ID
#define MUTEN_DEV_ID		XPAR_AXI_GPIO_MUTEN_DEVICE_ID

#define INTC_TMR_INTERRUPT_ID XPAR_FABRIC_AXI_TIMER_0_INTERRUPT_INTR
#define INTC_BTN_INTERRUPT_ID XPAR_FABRIC_AXI_GPIO_BTN_IP2INTC_IRPT_INTR
#define INTC_SW_INTERRUPT_ID XPAR_FABRIC_AXI_GPIO_SW_IP2INTC_IRPT_INTR

#define BTN_INT 			XGPIO_IR_CH1_MASK
#define SW_INT 				XGPIO_IR_CH1_MASK

#define TMR_LOAD			0xFFFF0000
#define ARR_LEN 9

//----------------------------------------------------
// Global variables
//----------------------------------------------------
XGpio BTNInst, SWInst, LEDInst, MUTENInst;
XScuGic INTCInst;
XTmrCtr TMRInst;
XIicPs Iic;


#endif /* SRC_INIT_H_ */