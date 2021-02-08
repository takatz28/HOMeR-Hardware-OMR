#include "intc_handler.h"
#include "audio.h"

//----------------------------------------------------
// MAIN FUNCTION
//----------------------------------------------------
int main (void)
{
	xil_printf("Entering Main\r\n");
	//Configure the IIC data structure
	IicConfig(XPAR_XIICPS_0_DEVICE_ID);

	//Configure the Audio Codec's PLL
	AudioPllConfig();

	xil_printf("SSM2603 configured\n\r");

	/* Initialise GPIO and NCO peripherals */
	Gpio_Init();
	xil_printf("GPIO peripheral configured\r\n");

	//	Mute audio codec at startup
	XGpio_DiscreteWrite(&MUTENInst, 1, 0x1);

	HarmonizerConfig();
	print("Harmonizer inputs cleared.\n");

	Timer_Init();

	while(1);

	return 0;
}
