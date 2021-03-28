#include "notes.h"

int noteArray[][9] = 
{
	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{C3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 0},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{Bb3, 0, 0, 0, 0, 0, 0, 0, 1},
	{Fs3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{C3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{Gs3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 0},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{Bb3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{F3, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{A3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},

	{F3, 0, 0, 0, 0, 0, 0, 0, 1},
	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 0},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{A2, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{F3, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{B2, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 0},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{Eb3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},

	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{C3, 0, 0, 0, 0, 0, 0, 0, 0},

	{C3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{A2, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{F3, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{B2, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 0},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{F3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{Bb3, 0, 0, 0, 0, 0, 0, 0, 1},
	{A3, 0, 0, 0, 0, 0, 0, 0, 1},

	{D3, 0, 0, 0, 0, 0, 0, 0, 1},

	{E3, 0, 0, 0, 0, 0, 0, 0, 1},

	{F3, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

	{0, 0, 0, 0, 0, 0, 0, 0, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 1},

};