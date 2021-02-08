#include "intc_handler.h"
#include "audio.h"

u32 *(baseaddr_mus) = (u32 *)XPAR_ORGANHARMONIZER_0_S00_AXI_BASEADDR;
int temp = 0;
int volume;
static bool done = false;

/* ---------------------------------------------------------------------------- *
 * 									IicConfig()									*
 * ---------------------------------------------------------------------------- *
 * Initialises the IIC driver by looking up the configuration in the config
 * table and then initialising it. Also sets the IIC serial clock rate.
 * ---------------------------------------------------------------------------- */
unsigned char IicConfig(unsigned int DeviceIdPS)
{
	XIicPs_Config *Config;
	int Status;

	/* Initialise the IIC driver so that it's ready to use */

	// Look up the configuration in the config table
	Config = XIicPs_LookupConfig(DeviceIdPS);
	if(NULL == Config) {
		return XST_FAILURE;
	}

	// Initialise the IIC driver configuration
	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform a self-test to ensure that the hardware was built correctly.
	 */
	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		xil_printf("IIC FAILED \r\n");
		return XST_FAILURE;

	}
	xil_printf("IIC Passed\r\n");


	//Set the IIC serial clock rate.
	Status = XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/* ---------------------------------------------------------------------------- *
 * 								AudioPllConfig()								*
 * ---------------------------------------------------------------------------- *
 * Reset CODEC Software and power-up. Set default ADC and DAC volumes and enable
 * the correct signal path to the DSP unit. Set a 48 kHz sampling rate and
 * activate the SSM CODEC.
 * ---------------------------------------------------------------------------- */
void AudioPllConfig() {


	AudioWriteToReg(R15_SOFTWARE_RESET, 				0b000000000); //Perform Reset
	usleep(75000);
	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000110000); //Power Up
	AudioWriteToReg(R0_LEFT_CHANNEL_ADC_INPUT_VOLUME, 	0b000011111); //Default Volume
	AudioWriteToReg(R1_RIGHT_CHANNEL_ADC_INPUT_VOLUME, 	0b000011111); //Default Volume
	AudioWriteToReg(R2_LEFT_CHANNEL_DAC_VOLUME, 		0b101111111);
	AudioWriteToReg(R3_RIGHT_CHANNEL_DAC_VOLUME, 		0b101111111);
	AudioWriteToReg(R4_ANALOG_AUDIO_PATH, 				0b000010010); //Allow Mixed DAC, Mute MIC
	AudioWriteToReg(R5_DIGITAL_AUDIO_PATH, 				0b000000110); //48 kHz Sampling Rate emphasis, no high pass
	AudioWriteToReg(R7_DIGITAL_AUDIO_I_F, 				0b000001010); //I2S Mode, set-up 32 bits
	AudioWriteToReg(R8_SAMPLING_RATE, 					0b000000000);
	usleep(75000);
	AudioWriteToReg(R9_ACTIVE, 							0b000000001); //Activate digital core
	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000100010); //Output Power Up

//	AudioWriteToReg(R15_SOFTWARE_RESET, 				0b000000000); //Perform Reset
//	usleep(75000);
//	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000110000); //Power Up
//	AudioWriteToReg(R0_LEFT_CHANNEL_ADC_INPUT_VOLUME, 	0b000011111); //Default Volume
//	AudioWriteToReg(R1_RIGHT_CHANNEL_ADC_INPUT_VOLUME, 	0b000011111); //Default Volume
//	AudioWriteToReg(R2_LEFT_CHANNEL_DAC_VOLUME, 		0b001111111);
//	AudioWriteToReg(R3_RIGHT_CHANNEL_DAC_VOLUME, 		0b001111111);
//	AudioWriteToReg(R4_ANALOG_AUDIO_PATH, 				0b000010010); //Allow Mixed DAC, Mute MIC
//	AudioWriteToReg(R5_DIGITAL_AUDIO_PATH, 				0b000000111); //48 kHz Sampling Rate emphasis, no high pass
//	AudioWriteToReg(R7_DIGITAL_AUDIO_I_F, 				0b000001010); //I2S Mode, set-up 32 bits
//	AudioWriteToReg(R8_SAMPLING_RATE, 					0b000000000);
//	usleep(75000);
//	AudioWriteToReg(R9_ACTIVE, 							0b000000001); //Activate digital core
//	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000100010); //Output Power Up

}


/* ---------------------------------------------------------------------------- *
 * 								AudioWriteToReg									*
 * ---------------------------------------------------------------------------- *
 * Function to write to one of the registers from the audio
 * controller.
 * ---------------------------------------------------------------------------- */
void AudioWriteToReg(u8 u8RegAddr, u16 u16Data) {

	unsigned char u8TxData[2];

	u8TxData[0] = u8RegAddr << 1;
	u8TxData[0] = u8TxData[0] | ((u16Data >> 8) & 0b1);

	u8TxData[1] = u16Data & 0xFF;

	XIicPs_MasterSendPolled(&Iic, u8TxData, 2, IIC_SLAVE_ADDR);
	while(XIicPs_BusIsBusy(&Iic));
}


/* ---------------------------------------------------------------------------- *
 * 							   HarmonizerConfig									*
 * ---------------------------------------------------------------------------- *
 * Function to write to one of the registers from the audio
 * controller.
 * ---------------------------------------------------------------------------- */
void HarmonizerConfig()
{
	*(baseaddr_mus + 0) = 0x00000032;
	*(baseaddr_mus + 1) = 0x00000000;

	for(int i = 0; i < 50000; i++) {
		Xil_Out32(I2S_DATA_TX_L_REG, *(baseaddr_mus + 2));
		Xil_Out32(I2S_DATA_TX_R_REG, *(baseaddr_mus + 2));
	}

	*(baseaddr_mus + 0) = 0x00000000;
	*(baseaddr_mus + 1) = 0x00000032;
	for(int i = 0; i < 50000; i++) {
		Xil_Out32(I2S_DATA_TX_L_REG, *(baseaddr_mus + 2));
		Xil_Out32(I2S_DATA_TX_R_REG, *(baseaddr_mus + 2));
	}
}


/* ---------------------------------------------------------------------------- *
 * 							   HarmonizerPlay									*
 * ---------------------------------------------------------------------------- *
 * Function to send note(s) to harmonizer to play sound
 * ---------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------- *
 * 								tonal_noise()									*
 * ---------------------------------------------------------------------------- */
//void tonal_noise(int N0, int N1, int N2, int N3, int N4, int N5, int N6, int N7,
//	double beat, int space)
void HarmonizerPlay(int noteArray[][ARR_LEN], double beatArray[], int tempo, int index)
{
	done = false;
	temp = 0;
	u32 out_left, out_right;
	int space = noteArray[index][8];

	*(baseaddr_mus + 0) = 0x00000000 + noteArray[index][0] +
		(noteArray[index][1] << 8) +
		(noteArray[index][2] << 16) +
		(noteArray[index][3] << 24);
	*(baseaddr_mus + 1) = 0x00000000 + noteArray[index][4] +
		(noteArray[index][5] << 8) +
		(noteArray[index][6] << 16) +
		(noteArray[index][7] << 24);

	while (!done)
	{
		out_left =  (u32)(*(baseaddr_mus + 2));
		out_right =  out_left;

		Xil_Out32(I2S_DATA_TX_L_REG, out_left);
		Xil_Out32(I2S_DATA_TX_R_REG, out_right);

		temp++;

		if(temp == (int)(tempo * beatArray[index]))	// sunshine
		{
			if (space == 1) {
				*(baseaddr_mus + 0) = 0x00000000;
				*(baseaddr_mus + 1) = 0x00000000;
				for(int i = 0; i < (space * 125000); i++);
//				for(int i = 0; i < (1000000); i++);
			}
			else {
				*(baseaddr_mus + 0) = *(baseaddr_mus + 0);
				*(baseaddr_mus + 1) = *(baseaddr_mus + 1);
				for(int i = 0; i < 1; i++);
			}
			done = true;
		}
	} // while
	return;
}
