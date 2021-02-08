#ifndef SRC_INTC_HANDLER_C_
#define SRC_INTC_HANDLER_C_

#include "intc_handler.h"
#include "audio.h"
#include "sheetBeat.h"
#include "sheetNotes.h"
//#include "song3.h"

#define LENGTH 	sizeof(beatArray)/sizeof(beatArray[0])
#define TEMPO 375000

static int tempo = TEMPO; //= 10500000;//9500000


void PlayerControl(void *InstancePtr)
{
	// Disable GPIO interrupts
	XGpio_InterruptDisable(&BTNInst, BTN_INT);
	// Ignore additional button presses
	if ((XGpio_InterruptGetStatus(&BTNInst) & BTN_INT) !=
			BTN_INT) {
			return;
		}
	btn_value = XGpio_DiscreteRead(&BTNInst, 1);
//	note_count = 0;
	// Increment counter based on button value
	// Reset if centre button pressed
	if (btn_value == 8)
	{
		XGpio_DiscreteWrite(&LEDInst, 1, 0x8);
		note_count = 0;
		XTmrCtr_Stop(&TMRInst, 0);
		XTmrCtr_Reset(&TMRInst, 0);
	}
	else if (btn_value == 4) {
//		HarmonizerConfig();
		XGpio_DiscreteWrite(&LEDInst, 1, 0x4);
		XGpio_DiscreteWrite(&MUTENInst, 1, 0x0);
		XTmrCtr_Stop(&TMRInst, 0);
	}
	else if (btn_value == 2) {
//		tempo = 9500000;
		XGpio_DiscreteWrite(&LEDInst, 1, 0x2);
		XGpio_DiscreteWrite(&MUTENInst, 1, 0x1);
		XTmrCtr_Start(&TMRInst, 0);
	}
	else if (btn_value == 1) {
//		tempo = 6500000;
		XGpio_DiscreteWrite(&LEDInst, 1, 0x1);
		note_count += 1;
		printf("Current note: %2x\n", note_count);
	}
	else
		XGpio_DiscreteWrite(&LEDInst, 1, 0x0);

    (void)XGpio_InterruptClear(&BTNInst, BTN_INT);
    // Enable GPIO interrupts
    XGpio_InterruptEnable(&BTNInst, BTN_INT);
}

void TempoControl(void *InstancePtr)
{
	// Disable GPIO interrupts
	XGpio_InterruptDisable(&SWInst, SW_INT);
	// Ignore additional button presses
	if ((XGpio_InterruptGetStatus(&SWInst) & SW_INT) !=
			SW_INT) {
			return;
		}
	sw_value = XGpio_DiscreteRead(&SWInst, 1);
//	note_count = 0;
	// Increment counter based on button value
	// Reset if centre button pressed
	if (sw_value == 8)
		tempo = TEMPO * 1.5;
	else if (sw_value == 4)
		tempo = TEMPO * 1.25;
	else if (sw_value == 2)
		tempo = TEMPO * 0.75;
	else if (sw_value == 1)
		tempo = TEMPO * 0.5;
	else
		tempo = TEMPO;

    (void)XGpio_InterruptClear(&SWInst, SW_INT);
    // Enable GPIO interrupts
    XGpio_InterruptEnable(&SWInst, SW_INT);
}

void TMR_Intr_Handler(void *data)
{
	if (XTmrCtr_IsExpired(&TMRInst,0))
	{
		if (tmr_count == 2)
		{
			XTmrCtr_Stop(&TMRInst, 0);

			// 475000
			// 355000
			HarmonizerPlay(noteArray, beatArray, tempo, note_count);

			XTmrCtr_Reset(&TMRInst,0);
			if (note_count == LENGTH - 1)
			{
				XTmrCtr_Stop(&TMRInst, 0);
				note_count = 0;
			}
			else
			{
				XTmrCtr_Start(&TMRInst,0);
				note_count++;
			}
		}
		else tmr_count++;
	}
}

#endif /* SRC_INTC_HANDLER_C_ */
