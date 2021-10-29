#include "notes.h"

int noteArray[][9] = 
{
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{E4, 0, 0, 0, 0, 0, 0, 0, 1},
	{Fs4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{C5, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{E4, 0, 0, 0, 0, 0, 0, 0, 1},
	{Fs4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{C5, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{G5, 0, 0, 0, 0, 0, 0, 0, 1},
	{G5, 0, 0, 0, 0, 0, 0, 0, 1},
	{G5, 0, 0, 0, 0, 0, 0, 0, 1},

	{Fs5, 0, 0, 0, 0, 0, 0, 0, 1},
	{E5, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},

	{E5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{D5, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{C5, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{E4, 0, 0, 0, 0, 0, 0, 0, 1},
	{Fs4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G4, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{D5, 0, 0, 0, 0, 0, 0, 0, 1},
	{C5, 0, 0, 0, 0, 0, 0, 0, 1},
	{B4, 0, 0, 0, 0, 0, 0, 0, 1},

	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},
	{A4, 0, 0, 0, 0, 0, 0, 0, 1},

	{G4, 0, 0, 0, 0, 0, 0, 0, 1},

};