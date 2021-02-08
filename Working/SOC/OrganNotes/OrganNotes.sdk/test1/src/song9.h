#include "notes.h"

#define TEMPO 475000

int noteArray[][9] = 
{
	// part 1 
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},

	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},
	{D5, 0, 0, 0, 0, 0, 0, 0, 0},
	{C5, 0, 0, 0, 0, 0, 0, 0, 0},

	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},
	{A3, 0, 0, 0, 0, 0, 0, 0},
	{C4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{A4, 0, 0, 0, 0, 0, 0, 0, 0},

	{B4, E2, 0, 0, 0, 0, 0, 0, 0},
	{B4, E3, 0, 0, 0, 0, 0, 0, 0},
	{Gs3, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{Gs4, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},

	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, E3, 0, 0, 0, 0, 0, 0, 0},
	{A3, 0, 0, 0, 0, 0, 0, 0},
	{C4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},

	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},
	{D5, 0, 0, 0, 0, 0, 0, 0, 0},
	{C5, 0, 0, 0, 0, 0, 0, 0, 0},

	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},
	{A3, 0, 0, 0, 0, 0, 0, 0},
	{C4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{A4, 0, 0, 0, 0, 0, 0, 0, 0},

	{B4, E2, 0, 0, 0, 0, 0, 0, 0},
	{B4, E3, 0, 0, 0, 0, 0, 0, 0},
	{Gs3, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{C5, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},

	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},
	{A4, A3, 0, 0, 0, 0, 0, 0, 0},
	{A4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},

	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},
	{D5, 0, 0, 0, 0, 0, 0, 0, 0},
	{C5, 0, 0, 0, 0, 0, 0, 0, 0},

	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},
	{A3, 0, 0, 0, 0, 0, 0, 0},
	{C4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{A4, 0, 0, 0, 0, 0, 0, 0, 0},

	{B4, E2, 0, 0, 0, 0, 0, 0, 0},
	{B4, E3, 0, 0, 0, 0, 0, 0, 0},
	{Gs3, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{Gs4, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},

	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, E3, 0, 0, 0, 0, 0, 0, 0},
	{A3, 0, 0, 0, 0, 0, 0, 0},
	{C4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},

	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{Eb5, 0, 0, 0, 0, 0, 0, 0, 0},
	{E5, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},
	{D5, 0, 0, 0, 0, 0, 0, 0, 0},
	{C5, 0, 0, 0, 0, 0, 0, 0, 0},

	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},
	{A3, 0, 0, 0, 0, 0, 0, 0},
	{C4, 0, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{A4, 0, 0, 0, 0, 0, 0, 0, 0},

	{B4, E2, 0, 0, 0, 0, 0, 0, 0},
	{B4, E3, 0, 0, 0, 0, 0, 0, 0},
	{Gs3, 0, 0, 0, 0, 0, 0, 0},
	{E4, 0, 0, 0, 0, 0, 0, 0, 0},
	{C5, 0, 0, 0, 0, 0, 0, 0, 0},
	{B4, 0, 0, 0, 0, 0, 0, 0, 0},
};

double beatArray[] = 
{
	// part 1
	0.25, 0.25, 
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25,

	0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25,

	// part 2
};
