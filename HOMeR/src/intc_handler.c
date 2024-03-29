/*************************************************************************
 * File name:		intc_handler.c
 * Description:		Defines the interrupt handlers for pushbuttons, 
 *					switches, and timers
 *************************************************************************/
 #ifndef SRC_INTC_HANDLER_C_
#define SRC_INTC_HANDLER_C_

#include "intc_handler.h"
#include "audio.h"
#include "sheetBeat.h"
#include "sheetNotes.h"

#define LENGTH 	sizeof(beatArray)/sizeof(beatArray[0])
#define TEMPO 1750000

static int tempo = TEMPO;

//----------------------------------------------------
// PUSHBUTTON INTERRUPT HANDLER
// - Represent music player controller
//   8: Start tune from the beginning
//   4: Pause
//   2: Play
//   1: Forward to next note/rest
//----------------------------------------------------
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
	if (btn_value == 8)
	{
		XGpio_DiscreteWrite(&LEDInst, 1, 0x8);
		note_count = 0;
		XTmrCtr_Stop(&TMRInst, 0);
		XTmrCtr_Reset(&TMRInst, 0);
	}
	else if (btn_value == 4) {
		XGpio_DiscreteWrite(&LEDInst, 1, 0x4);
		XGpio_DiscreteWrite(&MUTENInst, 1, 0x0);
		XTmrCtr_Stop(&TMRInst, 0);
	}
	else if (btn_value == 2) {
		sw_value = XGpio_DiscreteRead(&SWInst, 1);
		if (sw_value == 8)
			tempo = TEMPO * 1.5;
		else if (sw_value == 4)
			tempo = TEMPO * 1.25;
		else if (sw_value == 12)
			tempo = TEMPO * 2;
		else if (sw_value == 2)
			tempo = TEMPO * 0.75;
		else if (sw_value == 1)
			tempo = TEMPO * 0.5;
		else
			tempo = TEMPO;
		XGpio_DiscreteWrite(&LEDInst, 1, 0x2);
		XGpio_DiscreteWrite(&MUTENInst, 1, 0x1);
		XTmrCtr_Start(&TMRInst, 0);
	}
	else if (btn_value == 1) {
		XGpio_DiscreteWrite(&LEDInst, 1, 0x1);
		note_count += 1;
	}
	else
		XGpio_DiscreteWrite(&LEDInst, 1, 0x0);

    (void)XGpio_InterruptClear(&BTNInst, BTN_INT);
    // Enable GPIO interrupts
    XGpio_InterruptEnable(&BTNInst, BTN_INT);
}

//----------------------------------------------------
// SWITCH INTERRUPT HANDLER
// - Represent playback tempo controller
//	 	12: tempo is twice as slow
//     	 8: 0.5x speed
//    	 4: 0.75x speed
//    	 2: 1.25x speed
//   	 1: 1.5x speed
//   other: default
//----------------------------------------------------
void TempoControl(void *InstancePtr)
{
	// Disable GPIO interrupts
	XGpio_InterruptDisable(&SWInst, SW_INT);
	// Ignore additional switch changes
	if ((XGpio_InterruptGetStatus(&SWInst) & SW_INT) !=
			SW_INT) {
		return;
	}
	sw_value = XGpio_DiscreteRead(&SWInst, 1);
	if (sw_value == 8)
		tempo = TEMPO * 1.5;
	else if (sw_value == 4)
		tempo = TEMPO * 1.25;
	else if (sw_value == 12)
		tempo = TEMPO * 2;
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

//----------------------------------------------------
// TIMER INTERRUPT HANDLER
// - Contains the music playback function
//----------------------------------------------------
void TMR_Intr_Handler(void *data)
{
	if (XTmrCtr_IsExpired(&TMRInst,0)) {
		if (tmr_count == 2) {
			XTmrCtr_Stop(&TMRInst, 0);
			HarmonizerPlay(noteArray, beatArray, tempo, note_count);
			XTmrCtr_Reset(&TMRInst,0);
			if (note_count == LENGTH - 1) {
				XTmrCtr_Stop(&TMRInst, 0);
				note_count = 0;
			}
			else {
				XTmrCtr_Start(&TMRInst,0);
				note_count++;
			}
		}
		else tmr_count++;
	}
}

#endif /* SRC_INTC_HANDLER_C_ */
