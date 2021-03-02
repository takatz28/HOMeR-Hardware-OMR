/*************************************************************************
 * File name:		intc_handler.h
 * Description:		Declares interrupt handler function prototypes and 
 *					necessary variables
 *************************************************************************/
#ifndef SRC_INTC_HANDLER_H_
#define SRC_INTC_HANDLER_H_

#include "init.h"

// function prototypes 
void PlayerControl(void *baseaddr_p);
void TempoControl(void *baseaddr_p);
void TMR_Intr_Handler(void *baseaddr_p);

// variable definitions
int btn_value, sw_value;
int note_count;
int tmr_count; 

#endif /* SRC_INTC_HANDLER_H_ */
