/*
 * intc_handler.h
 *
 *  Created on: Aug 2, 2020
 *      Author: tacat
 */

#ifndef SRC_INTC_HANDLER_H_
#define SRC_INTC_HANDLER_H_

#include "init.h"
//#include "song1.h"

void PlayerControl(void *baseaddr_p);
void TempoControl(void *baseaddr_p);
void TMR_Intr_Handler(void *baseaddr_p);

// test function


int btn_value, sw_value;
int note_count;// = 0;
int tmr_count; //= 0;
//static int tempo;

#endif /* SRC_INTC_HANDLER_H_ */
