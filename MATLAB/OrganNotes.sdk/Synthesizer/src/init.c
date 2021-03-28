/*************************************************************************
 * File name:		init.c
 * Description:		Contains necessary initialization functions 
 *************************************************************************/
#include "init.h"
#include "intc_handler.h"

//----------------------------------------------------
// GPIO INITIALIATION FUNCTION
// - all GPIOs are configured and initialized
//----------------------------------------------------
int Gpio_Init()
{
	int Status;

	// initialize buttons to inputs
	Status = XGpio_Initialize(&BTNInst, BTN_DEV_ID);
	if(Status != XST_SUCCESS) return XST_FAILURE;
	XGpio_SetDataDirection(&BTNInst, 1, 0xF);

	// initialize switches to inputs
	Status = XGpio_Initialize(&SWInst, SW_DEV_ID);
	if(Status != XST_SUCCESS) return XST_FAILURE;
	XGpio_SetDataDirection(&SWInst, 1, 0xF);

	// initialize LEDs to outputs
	Status = XGpio_Initialize(&LEDInst, LEDS_DEV_ID);
	if(Status != XST_SUCCESS) return XST_FAILURE;
	XGpio_SetDataDirection(&LEDInst, 1, 0x0);

	// initialize MUTE control to output
	Status = XGpio_Initialize(&MUTENInst, MUTEN_DEV_ID);
	if(Status != XST_SUCCESS) return XST_FAILURE;
	XGpio_SetDataDirection(&MUTENInst, 1, 0x0);
	return XST_SUCCESS;
}

//----------------------------------------------------
// TIMER INITIALIZATION FUNCTION
// - initializes the timer and interrupt controllers
//----------------------------------------------------
int Timer_Init()
{
	int status;

	status = XTmrCtr_Initialize(&TMRInst, TMR_DEVICE_ID);
	if(status != XST_SUCCESS) return XST_FAILURE;
	XTmrCtr_SetHandler(&TMRInst, TMR_Intr_Handler, &TMRInst);
	XTmrCtr_SetResetValue(&TMRInst, 0, TMR_LOAD);
	XTmrCtr_SetOptions(&TMRInst, 0, XTC_INT_MODE_OPTION | XTC_AUTO_RELOAD_OPTION);

	// Initialize interrupt controller
	status = IntcInitFunction(INTC_DEVICE_ID, &TMRInst, &BTNInst, &SWInst);
	if(status != XST_SUCCESS) return XST_FAILURE;

	return XST_SUCCESS;
}

//----------------------------------------------------
// INITIAL SETUP FUNCTIONS
//----------------------------------------------------
int InterruptSystemSetup(XScuGic *XScuGicInstancePtr)
{
	// Enable interrupt
	XGpio_InterruptEnable(&BTNInst, BTN_INT);
	XGpio_InterruptGlobalEnable(&BTNInst);

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 	 	 	 	 	 (Xil_ExceptionHandler)XScuGic_InterruptHandler,
			 	 	 	 	 	 XScuGicInstancePtr);
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}
int IntcInitFunction(u16 DeviceId, XTmrCtr *TmrInstancePtr,  XGpio *BtnInstancePtr,
		XGpio *SwInstancePtr)
{
	XScuGic_Config *IntcConfig;
	int status;

	// Interrupt controller initialisation
	IntcConfig = XScuGic_LookupConfig(DeviceId);
	status = XScuGic_CfgInitialize(&INTCInst, IntcConfig, IntcConfig->CpuBaseAddress);
	if(status != XST_SUCCESS) return XST_FAILURE;

	// Call to interrupt setup
	status = InterruptSystemSetup(&INTCInst);
	if(status != XST_SUCCESS) return XST_FAILURE;

	// Connect timer interrupt to handler
	status = XScuGic_Connect(&INTCInst,
							 INTC_TMR_INTERRUPT_ID,
							 (Xil_ExceptionHandler)TMR_Intr_Handler,
							 (void *)TmrInstancePtr);
	if(status != XST_SUCCESS) return XST_FAILURE;

	// Connect button interrupt to handler
	status = XScuGic_Connect(&INTCInst,
					  	  	 INTC_BTN_INTERRUPT_ID,
					  	  	 (Xil_ExceptionHandler)PlayerControl,
					  	  	 (void *)BtnInstancePtr);
	if(status != XST_SUCCESS) return XST_FAILURE;

	// Connect button interrupt to handler
	status = XScuGic_Connect(&INTCInst,
					  	  	 INTC_SW_INTERRUPT_ID,
					  	  	 (Xil_ExceptionHandler)TempoControl,
					  	  	 (void *)SwInstancePtr);
	if(status != XST_SUCCESS) return XST_FAILURE;

	// Enable button interrupt
	XGpio_InterruptEnable(BtnInstancePtr, 1);
	XGpio_InterruptGlobalEnable(BtnInstancePtr);

	// Enable switch interrupt
	XGpio_InterruptEnable(SwInstancePtr, 1);
	XGpio_InterruptGlobalEnable(SwInstancePtr);

	// Enable button, timer, and switch interrupts in the controller
	XScuGic_Enable(&INTCInst, INTC_TMR_INTERRUPT_ID);
	XScuGic_Enable(&INTCInst, INTC_BTN_INTERRUPT_ID);
	XScuGic_Enable(&INTCInst, INTC_SW_INTERRUPT_ID);

	return XST_SUCCESS;
}

