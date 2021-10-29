/*
 * AudioOut.c
 *
 *  Created on: Nov 9, 2015
 *      Author: Andrwew Powell (scdl)
 */

#include "AudioOut.h"

int audio_out_setup(audio_out* audio_out_obj,
		uint32_t* config_address,
		audio_out_buffer* audio_out_buffer_address,
		int left_vol,int right_vol,
		audio_i2c i2c_obj,audio_i2c_set_reg i2c_set_reg,
		audio_delay_ms delay_ms) {

	int32_t Status;

	/* Set private data. */
	audio_out_obj->config_address = config_address;
	audio_out_obj ->audio_out_buffer_address = audio_out_buffer_address;

	/* Configure AudioOut in fabric. */
	audio_out_reg(audio_out_obj,AUDIO_OUT_START_ADDR_REG) =
			(uint32_t)(&audio_out_buffer_sample(audio_out_buffer_address,0));
	audio_out_reg(audio_out_obj,AUDIO_OUT_SIZE_REG) =
			audio_out_buffer_size(audio_out_buffer_address)*
			sizeof(audio_word)/sizeof(audio_sample);

	/* Clear buffer. */
	audio_out_buffer_clear(audio_out_buffer_address);

	/*
	 * Configure SSM2603.
	 * It should be noted, the following procedure for enabling the SSM2603
	 * is taken from the SSM2603 data sheet under the section entitled
	 * "Control Register Sequencing".
	 **/

	/**
	 * Power up the DAC, but power down components not in usage. The output
	 * is also powered down until all other configurations have been made.
	 ***/
	Status = i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x06,0x057);

	/** Perform software reset to ensure all registers are in the their default settings. **/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x0F,0x00);

	/**
	 * Set volume of audio out channels. Plus, disable automatic loading
	 * of opposite channels.
	 ***/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x02,left_vol); /** Left **/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x03,right_vol); /** Right **/

	/**
	 * Ensure DAC connects to the analog audio output and DAC is un-muted.
	 ***/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x04,0x010);
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x05,0x000);

	/**
	 * Make sure the sample width is 24 bits and the data is right-justified.
	 * CRITICAL: How alignment is explained in the data sheet is confusing;
	 * the data from the AudioOut IP is actually left-justified, however only
	 * configuring register 0x07 to right-justified appears to work.
	 ***/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x07,0x008);

	/**
	 * Configure core clock to master clock and normal mode
	 * with 256 fs based clock.
	 ***/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x08,0x000);

	/**
	 * Set active bit of digital core. Before setting the active bit,
	 * a delay needs to take place. The delay is computed as the following.
	 * Please know that this formula was acquired from the Zybo schematic
	 * and the SSM2603's data sheet.
	 *
	 * Delay (seconds) = 0.072 = C*25e3/3.5
	 * C = 100 nF + 10 uF
	 * (100e-9+100e-6)*25e3/3.5
	 ***/
	delay_ms(72);
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,0x09,0x001);

	/** Finally, the output path is powered up to enable SSM2603. **/
	Status |= i2c_set_reg(i2c_obj,AUDIO_IIC_SLAVE_ADDR,6,0x047);

	return Status;
}

void audio_out_set_mode(audio_out* audio_obj,audio_out_mode mode) {
	audio_out_reg(audio_obj,AUDIO_OUT_MODE_REG) = (audio_out_mode)mode;
}

audio_out_mode audio_out_get_mode(audio_out* audio_obj) {
	return (audio_out_mode)audio_out_reg(audio_obj,AUDIO_OUT_MODE_REG);
}
