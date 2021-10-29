/*************************************************************************
 * File name:		audio.c
 * Description:		Function definitions for audio configuration and 
 *					music generation
 *************************************************************************/
#include "intc_handler.h"
#include "audio.h"

//----------------------------------------------------
// Variable definitions
//----------------------------------------------------
u32 *(baseaddr_mus) = (u32 *)XPAR_ORGANSYNTH_0_S00_AXI_BASEADDR;
int temp = 0;
int volume;
static bool done = false;

//----------------------------------------------------
// I2C CONFIGURATION FUNCTION
// - Initializes the I2C driver and sets the I2C
//   serial clock rate
//----------------------------------------------------
unsigned char IicConfig(unsigned int DeviceIdPS)
{
	XIicPs_Config *Config;
	int Status;

	// Look up the configuration in the config table
	Config = XIicPs_LookupConfig(DeviceIdPS);
	if(NULL == Config) {
		return XST_FAILURE;
	}

	// Initialize the IIC driver configuration
	Status = XIicPs_CfgInitialize(&Iic, Config, Config->BaseAddress);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Perform a self-test to ensure that the hardware functions
	// correctly.
	Status = XIicPs_SelfTest(&Iic);
	if (Status != XST_SUCCESS) {
		xil_printf("IIC FAILED \r\n");
		return XST_FAILURE;
	}
	xil_printf("IIC Passed\r\n");

	// Set the IIC serial clock rate.
	Status = XIicPs_SetSClk(&Iic, IIC_SCLK_RATE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

//----------------------------------------------------
// AUDIO PLL CONFIGURATION FUNCTION
// - Performs various functions such as resetting 
//   codec software, setting ADC/DAC volumes, and 
//   setting sampling rate at 48kHz
//----------------------------------------------------
void AudioPllConfig() {

	// Perform Reset
	AudioWriteToReg(R15_SOFTWARE_RESET, 				0b000000000); 
	usleep(75000);
	// Power Up
	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000110000); 
	// Default Volume
	AudioWriteToReg(R0_LEFT_CHANNEL_ADC_INPUT_VOLUME, 	0b000011111);
	// Default Volume
	AudioWriteToReg(R1_RIGHT_CHANNEL_ADC_INPUT_VOLUME, 	0b000011111);	
	AudioWriteToReg(R2_LEFT_CHANNEL_DAC_VOLUME, 		0b101111111);
	AudioWriteToReg(R3_RIGHT_CHANNEL_DAC_VOLUME, 		0b101111111);
	// Allow Mixed DAC, Mute MIC
	AudioWriteToReg(R4_ANALOG_AUDIO_PATH, 				0b000010010); 
	// 48 kHz Sampling Rate emphasis, no high pass
	AudioWriteToReg(R5_DIGITAL_AUDIO_PATH, 				0b000000110); 
	// I2S Mode, set-up 32 bits
	AudioWriteToReg(R7_DIGITAL_AUDIO_I_F, 				0b000001010); 
	AudioWriteToReg(R8_SAMPLING_RATE, 					0b000000000);
	usleep(75000);
	// Activate digital core
	AudioWriteToReg(R9_ACTIVE, 							0b000000001); 
	// Output Power Up
	AudioWriteToReg(R6_POWER_MANAGEMENT, 				0b000100010); 
}


//----------------------------------------------------
// REGISTER WRITE FUNCTION
// - Allows writing to one of the audio controller's
//	 registers
//----------------------------------------------------
void AudioWriteToReg(u8 u8RegAddr, u16 u16Data) {

	unsigned char u8TxData[2];

	u8TxData[0] = u8RegAddr << 1;
	u8TxData[0] = u8TxData[0] | ((u16Data >> 8) & 0b1);

	u8TxData[1] = u16Data & 0xFF;

	XIicPs_MasterSendPolled(&Iic, u8TxData, 2, IIC_SLAVE_ADDR);
	while(XIicPs_BusIsBusy(&Iic));
}


//----------------------------------------------------
// AUDIO GENERATION FUNCTION
// - Receives notes and beats and turn them to audible
//   sounds
//----------------------------------------------------
void HarmonizerPlay(int noteArray[][ARR_LEN], double beatArray[], int tempo, 
	int index)
{
	done = false;
	temp = 0;
	u32 out_left, out_right;
	int space = noteArray[index][8];

	// Sends four of the input notes to slave register 0
	*(baseaddr_mus + 0) = 0x00000000 + noteArray[index][0] +
		(noteArray[index][1] << 8) +
		(noteArray[index][2] << 16) +
		(noteArray[index][3] << 24);
	// Sends four of the input notes to slave register 1
	*(baseaddr_mus + 1) = 0x00000000 + noteArray[index][4] +
		(noteArray[index][5] << 8) +
		(noteArray[index][6] << 16) +
		(noteArray[index][7] << 24);

	// Play sound for the duration of the beat
	while (!done)
	{
		out_left =  (u32)(*(baseaddr_mus + 2));
		out_right =  out_left;

		Xil_Out32(I2S_DATA_TX_L_REG, out_left);
		Xil_Out32(I2S_DATA_TX_R_REG, out_right);

		temp++;

		if(temp == (int)(tempo * beatArray[index]))	{
			// If note break is 1, add a little space in between
			// plays
			if (space == 1) {
				*(baseaddr_mus + 0) = 0x00000000;
				*(baseaddr_mus + 1) = 0x00000000;
				for(int i = 0; i < (space * 225000); i++);
			}
			else {
				*(baseaddr_mus + 0) = *(baseaddr_mus + 0);
				*(baseaddr_mus + 1) = *(baseaddr_mus + 1);
				for(int i = 0; i < 1; i++);
			}
			done = true;
		}
	}
	return;
}
