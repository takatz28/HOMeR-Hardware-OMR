/*
 * AudioOut.h
 *
 *  Created on: Nov 9, 2015
 *      Author: Andrew Powell (scdl)
 */

#ifndef AUDIOOUT_H_
#define AUDIOOUT_H_

#include <stdint.h>
#include <string.h>

/* Registers defined in the AudioOut IP. */
#define AUDIO_OUT_MODE_REG 0
#define AUDIO_OUT_START_ADDR_REG 1
#define AUDIO_OUT_SIZE_REG 2
#define AUDIO_OUT_ERROR_REG 3

/*
 * I2C related constants for configuring
 * the SSM2603.
 */
#define AUDIO_IIC_SLAVE_ADDR 0x1A
#define AUDIO_IIC_SCLK_RATE	100000

/*
 * Basic data types of the audio driver.
 */
typedef int16_t audio_sample;
typedef uint32_t audio_word;

/*
 * This driver attempts to abstract away the i2c interface
 * necessary to configure the SSM2603.
 */
typedef void* audio_i2c;
typedef void(*audio_delay_ms)(int milliseconds);
typedef int(*audio_i2c_set_reg)(audio_i2c i2c,
		int slav_addr,int reg,int data);

typedef enum audio_out_mode {
	audio_out_mode_NOTHING, /* The AudioOut IP won't output new samples. */
	audio_out_mode_START, /* The AudioOut IP will read from buffer then go into NOTHING mode. */
	audio_out_mode_RELOAD /* The AudioOut IP will read from buffer and then repeat. */
} audio_out_mode;

/*
 * Structure that defines the memory reserved for audio samples.
 * It is critical to remember sample_total must be a multiple of
 * sizeof(audio_word).
 */
typedef struct audio_out_buffer {
	audio_sample* samples; /* Address to the first sample in the bufer. */
	size_t sample_total; /* The number of samples in the buffer. */
} audio_out_buffer;

/*
 * Structure that defines the configuration and buffer
 * addresses associated with each AudioOut IP.
 */
typedef struct audio_out {
	uint32_t* config_address; /* Address to AudioOut IP's configuration port. */
	audio_out_buffer* audio_out_buffer_address; /* Address to the buffer associated with the AudioOut IP. */
} audio_out;

/*
 * Configures the audio buffer.
 *
 * inputs:
 * buff_obj = Address to the audio_out_buffer object being configured.
 * samples_0 = Address to the array of samples.
 * total = The size of the array of samples.
 */
#define audio_out_buffer_setup(buff_obj,samples_0,total) \
	({(buff_obj)->samples = (samples_0); (buff_obj)->sample_total = (total);})

/*
 * Returns a sample given buff_obj, address to the audio_out_buffer object, and
 * index, which selects the particular sample from the buffer's array.
 */
#define audio_out_buffer_sample(buff_obj,index) (buff_obj)->samples[(index)]

/*
 * Returns the size of the buffer's array, given buff_obj, the address of
 * the audio_out_buffer object.
 */
#define audio_out_buffer_size(buff_obj) (buff_obj)->sample_total

/*
 * Clears buffer, given buff_obj, the address to the audio_out_buffer object.
 */
#define audio_out_buffer_clear(buff_obj) \
	memset((buff_obj)->samples,0,(buff_obj)->sample_total*sizeof(audio_sample));

/*
 * Updates the audio_out_buffer of audio_obj with buff_obj.
 */
#define audio_out_buffer_update(buff_obj,audio_obj) \
	memcpy((audio_obj)->audio_out_buffer_address->samples,\
			(buff_obj)->samples,(buff_obj)->sample_total*sizeof(audio_sample))

/*
 * Configure the audio driver.
 *
 * inputs:
 * audio_out_obj = audio driver object.
 * config_address = The address to the AudioOut's configuration port.
 * audio_out_buffer_address = The address to the buffer from where the AudioOut will read.
 * left_vol and right_vol = Adjust the initial volume of SSM2603. This is important so as 
 * to prevent saturation. Range is 0 to (2^5)-1.
 * i2c_obj = I2C driver object.
 * i2c_set_reg = I2C driver function to set the registers in SSM2603.
 * delay_ms = function to delay for a specified amount of milliseconds.
 *
 * Returns the status of i2c_set_reg.
 */
int audio_out_setup(audio_out* audio_out_obj,
		uint32_t* config_address,
		audio_out_buffer* audio_out_buffer_address,
		int left_vol,int right_vol,
		audio_i2c i2c_obj,audio_i2c_set_reg i2c_set_reg,
		audio_delay_ms delay_ms);

/* Sets/gets a register in the AudioOut IP. */
#define audio_out_reg(audio_obj,reg) (audio_obj)->config_address[(reg)]

/* Sets the operational mode. */
void audio_out_set_mode(audio_out* audio_obj,audio_out_mode mode);

/* Gets the operational mode. */
audio_out_mode audio_out_get_mode(audio_out* audio_obj);

#endif /* AUDIOOUT_H_ */
