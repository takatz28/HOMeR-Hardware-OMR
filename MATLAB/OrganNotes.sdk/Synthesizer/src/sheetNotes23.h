#include "notes.h"

int noteArray[][9] = 
{
	{A4, F2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 1},
	{A4, F3, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 1},

	{A4, F2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 1},
	{A4, F3, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 1},
	{G4, A2, 0, 0, 0, 0, 0, 0, 1},

	{E4, A2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C3, 0, 0, 0, 0, 0, 0, 0},
	{E4, E3, 0, 0, 0, 0, 0, 0, 1},
	{E4, A3, 0, 0, 0, 0, 0, 0, 0},
	{E4, E3, 0, 0, 0, 0, 0, 0, 0},
	{E4, C3, 0, 0, 0, 0, 0, 0, 1},

	{E4, A2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C3, 0, 0, 0, 0, 0, 0, 0},
	{E4, E3, 0, 0, 0, 0, 0, 0, 1},
	{E4, A3, 0, 0, 0, 0, 0, 0, 0},
	{E4, E3, 0, 0, 0, 0, 0, 0, 1},
	{G4, C3, 0, 0, 0, 0, 0, 0, 1},

	{A4, F2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 1},
	{A4, F3, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 1},

	{A4, F2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 1},
	{A4, F3, 0, 0, 0, 0, 0, 0, 0},
	{A4, C3, 0, 0, 0, 0, 0, 0, 1},
	{G4, A2, 0, 0, 0, 0, 0, 0, 1},

	{E4, C3, 0, 0, 0, 0, 0, 0, 0},
	{E4, E3, 0, 0, 0, 0, 0, 0, 0},
	{E4, G3, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, 0, 0, 0, 0, 0, 0, 0},
	{E4, G3, 0, 0, 0, 0, 0, 0, 0},
	{E4, E3, 0, 0, 0, 0, 0, 0, 1},

	{D4, G2, 0, 0, 0, 0, 0, 0, 0},
	{D4, B2, 0, 0, 0, 0, 0, 0, 0},
	{D4, D3, 0, 0, 0, 0, 0, 0, 0},
	{D4, G3, 0, 0, 0, 0, 0, 0, 0},
	{D4, D3, 0, 0, 0, 0, 0, 0, 0},
	{D4, B2, 0, 0, 0, 0, 0, 0, 1},

	{C4, C3, 0, 0, 0, 0, 0, 0, 0},
	{C4, E3, 0, 0, 0, 0, 0, 0, 0},
	{C4, G3, 0, 0, 0, 0, 0, 0, 0},
	{C4, C4, 0, 0, 0, 0, 0, 0, 0},
	{C4, G3, 0, 0, 0, 0, 0, 0, 0},
	{C4, E3, 0, 0, 0, 0, 0, 0, 1},

	{A2, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

	{C3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{C4, 0, 0, 0, 0, 0, 0, 0, 1},
	{G3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},

	{A2, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{A3, 0, 0, 0, 0, 0, 0, 0, 1},
	{E3, 0, 0, 0, 0, 0, 0, 0, 1},
	{C3, 0, 0, 0, 0, 0, 0, 0, 1},

};