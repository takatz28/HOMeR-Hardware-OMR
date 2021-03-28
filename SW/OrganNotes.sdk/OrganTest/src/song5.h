#include "notes.h"

#define TEMPO	775000

int noteArray[][9] = 
{
	/* intro */
	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{A4, E4, Bb3, C3, 0, 0, 0, 0, 0},
	{G4, E4, Bb3, C3, 0, 0, 0, 0, 0},

	/* verse 1 */
	{F4, F2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, F2, 0, 0, 0, 0, 0, 0},
	{F4, A3, F2, 0, 0, 0, 0, 0, 0},
	{F4, F3, F2, 0, 0, 0, 0, 0, 0},
	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, A4, A2, 0, 0, 0, 0, 0, 0},
	{C5, E4, A2, 0, 0, 0, 0, 0, 0},
	{C5, C4, A2, 0, 0, 0, 0, 0, 0},

	{F4, D2, 0, 0, 0, 0, 0, 0, 0},
	{F4, D4, D2, 0, 0, 0, 0, 0, 0},
	{F4, A3, D2, 0, 0, 0, 0, 0, 0},
	{F4, F3, D2, 0, 0, 0, 0, 0, 0},
	{D3, 0, 0, 0, 0, 0, 0, 0, 0},
	{A2, 0, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, A3, F2, 0, 0, 0, 0, 0},
	{A4, F4, A2, D2, 0, 0, 0, 0, 0},

	{Bb4, Bb1, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, F4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, Bb3, Bb1, 0, 0, 0, 0, 0, 0},
	{A4, C2, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C2, 0, 0, 0, 0, 0, 0},
	{A4, C4, C2, 0, 0, 0, 0, 0, 0},
	{A4, A3, C2, 0, 0, 0, 0, 0, 0},

	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	{G4, G3, 0, 0, 0, 0, 0, 0, 0},
	{G4, E3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{C4, Bb3, G3, C3, 0, 0, 0, 0, 0},

	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, F3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},

	{F4, F2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, F2, 0, 0, 0, 0, 0, 0},
	{F4, A3, F2, 0, 0, 0, 0, 0, 0},
	{F4, F3, F2, 0, 0, 0, 0, 0, 0},
	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, A4, A2, 0, 0, 0, 0, 0, 0},
	{C5, E4, A2, 0, 0, 0, 0, 0, 0},
	{C5, C4, A2, 0, 0, 0, 0, 0, 0},

	{F4, D2, 0, 0, 0, 0, 0, 0, 0},
	{F4, D4, D2, 0, 0, 0, 0, 0, 0},
	{F4, A3, D2, 0, 0, 0, 0, 0, 0},
	{F4, F3, D2, 0, 0, 0, 0, 0, 0},
	{D3, 0, 0, 0, 0, 0, 0, 0, 0},
	{A2, 0, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, A3, F2, 0, 0, 0, 0, 0},
	{A4, F4, A2, D2, 0, 0, 0, 0, 0},

	{Bb4, Bb1, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, F4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, Bb3, Bb1, 0, 0, 0, 0, 0, 0},
	{A4, C2, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C2, 0, 0, 0, 0, 0, 0},
	{A4, C4, C2, 0, 0, 0, 0, 0, 0},
	{A4, A3, C2, 0, 0, 0, 0, 0, 0},

	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	{G4, G3, 0, 0, 0, 0, 0, 0, 0},
	{G4, E3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{C4, Bb3, G3, C3, 0, 0, 0, 0, 0},

	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, F3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},

	/* chorus */
	{E4, C4, A2, 0, 0, 0, 0, 0, 0},
	{A4, E4, C4, A2, 0, 0, 0, 0, 0},
	{C5, A4, E4, E3, 0, 0, 0, 0, 0},
	{E5, C5, A4, E4, E3, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, E2, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, Gs2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, B2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, E3, 0, 0, 0, 0},

	{E4, C4, A2, 0, 0, 0, 0, 0, 0},
	{A4, E4, C4, A2, 0, 0, 0, 0, 0},
	{C5, A4, E4, E3, 0, 0, 0, 0, 0},
	{E5, C5, A4, E4, E3, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, E2, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, Gs2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, B2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, E3, 0, 0, 0, 0},

	{E4, C4, A2, 0, 0, 0, 0, 0, 0},
	{A4, E4, C4, A2, 0, 0, 0, 0, 0},
	{C5, A4, E4, E3, 0, 0, 0, 0, 0},
	{E5, C5, A4, E4, E3, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, E2, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, Gs2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, B2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, E3, 0, 0, 0, 0},

	{C5, A4, E4, C4, A2, 0, 0, 0, 0},
	{C5, A4, E4, C4, C3, 0, 0, 0, 0},
	{C5, G4, E4, C4, E3, 0, 0, 0, 0},
	{C5, G4, E4, C4, A2, 0, 0, 0, 0},
	{C5, Fs4, C4, D3, 0, 0, 0, 0, 0},
	{A4, Fs4, C4, D3, 0, 0, 0, 0, 0},
	{C5, Fs4, C4, D3, 0, 0, 0, 0, 0},
	{A4, Fs4, C4, D3, 0, 0, 0, 0, 0},

	{Bb4, G2, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, G4, D4, Bb3, D3, 0, 0, 0, 0},
	{Bb4, G4, Eb4, Bb3, Cs3, 0, 0, 0, 0},
	{Bb4, G4, Eb4, Bb3, Cs3, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, C3, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, C3, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, Bb2, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, A2, 0, 0, 0, 0},

	/* verse 2 */
	{F4, F2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, F2, 0, 0, 0, 0, 0, 0},
	{F4, A3, F2, 0, 0, 0, 0, 0, 0},
	{F4, F3, F2, 0, 0, 0, 0, 0, 0},
	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, A4, A2, 0, 0, 0, 0, 0, 0},
	{C5, E4, A2, 0, 0, 0, 0, 0, 0},
	{C5, C4, A2, 0, 0, 0, 0, 0, 0},

	{F4, D2, 0, 0, 0, 0, 0, 0, 0},
	{F4, D4, D2, 0, 0, 0, 0, 0, 0},
	{F4, A3, D2, 0, 0, 0, 0, 0, 0},
	{F4, F3, D2, 0, 0, 0, 0, 0, 0},
	{D3, 0, 0, 0, 0, 0, 0, 0, 0},
	{A2, 0, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, A3, F2, 0, 0, 0, 0, 0},
	{A4, F4, A2, D2, 0, 0, 0, 0, 0},

	{Bb4, Bb1, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, F4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, Bb3, Bb1, 0, 0, 0, 0, 0, 0},
	{A4, C2, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C2, 0, 0, 0, 0, 0, 0},
	{A4, C4, C2, 0, 0, 0, 0, 0, 0},
	{A4, A3, C2, 0, 0, 0, 0, 0, 0},

	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	{G4, G3, 0, 0, 0, 0, 0, 0, 0},
	{G4, E3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{C4, Bb3, G3, C3, 0, 0, 0, 0, 0},

	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{A4, E4, Bb3, C3, 0, 0, 0, 0, 0},
	{G4, E4, Bb3, C3, 0, 0, 0, 0, 0},

	/********* repeat *********/
	/* verse 1 */
	{F4, F2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, F2, 0, 0, 0, 0, 0, 0},
	{F4, A3, F2, 0, 0, 0, 0, 0, 0},
	{F4, F3, F2, 0, 0, 0, 0, 0, 0},
	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, A4, A2, 0, 0, 0, 0, 0, 0},
	{C5, E4, A2, 0, 0, 0, 0, 0, 0},
	{C5, C4, A2, 0, 0, 0, 0, 0, 0},

	{F4, D2, 0, 0, 0, 0, 0, 0, 0},
	{F4, D4, D2, 0, 0, 0, 0, 0, 0},
	{F4, A3, D2, 0, 0, 0, 0, 0, 0},
	{F4, F3, D2, 0, 0, 0, 0, 0, 0},
	{D3, 0, 0, 0, 0, 0, 0, 0, 0},
	{A2, 0, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, A3, F2, 0, 0, 0, 0, 0},
	{A4, F4, A2, D2, 0, 0, 0, 0, 0},

	{Bb4, Bb1, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, F4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, Bb3, Bb1, 0, 0, 0, 0, 0, 0},
	{A4, C2, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C2, 0, 0, 0, 0, 0, 0},
	{A4, C4, C2, 0, 0, 0, 0, 0, 0},
	{A4, A3, C2, 0, 0, 0, 0, 0, 0},

	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	{G4, G3, 0, 0, 0, 0, 0, 0, 0},
	{G4, E3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{C4, Bb3, G3, C3, 0, 0, 0, 0, 0},

	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, F3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},

	{F4, F2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, F2, 0, 0, 0, 0, 0, 0},
	{F4, A3, F2, 0, 0, 0, 0, 0, 0},
	{F4, F3, F2, 0, 0, 0, 0, 0, 0},
	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, A4, A2, 0, 0, 0, 0, 0, 0},
	{C5, E4, A2, 0, 0, 0, 0, 0, 0},
	{C5, C4, A2, 0, 0, 0, 0, 0, 0},

	{F4, D2, 0, 0, 0, 0, 0, 0, 0},
	{F4, D4, D2, 0, 0, 0, 0, 0, 0},
	{F4, A3, D2, 0, 0, 0, 0, 0, 0},
	{F4, F3, D2, 0, 0, 0, 0, 0, 0},
	{D3, 0, 0, 0, 0, 0, 0, 0, 0},
	{A2, 0, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, A3, F2, 0, 0, 0, 0, 0},
	{A4, F4, A2, D2, 0, 0, 0, 0, 0},

	{Bb4, Bb1, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, F4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, Bb3, Bb1, 0, 0, 0, 0, 0, 0},
	{A4, C2, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C2, 0, 0, 0, 0, 0, 0},
	{A4, C4, C2, 0, 0, 0, 0, 0, 0},
	{A4, A3, C2, 0, 0, 0, 0, 0, 0},

	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	{G4, G3, 0, 0, 0, 0, 0, 0, 0},
	{G4, E3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{C4, Bb3, G3, C3, 0, 0, 0, 0, 0},

	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, F3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},

	/* chorus */
	{E4, C4, A2, 0, 0, 0, 0, 0, 0},
	{A4, E4, C4, A2, 0, 0, 0, 0, 0},
	{C5, A4, E4, E3, 0, 0, 0, 0, 0},
	{E5, C5, A4, E4, E3, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, E2, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, Gs2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, B2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, E3, 0, 0, 0, 0},

	{E4, C4, A2, 0, 0, 0, 0, 0, 0},
	{A4, E4, C4, A2, 0, 0, 0, 0, 0},
	{C5, A4, E4, E3, 0, 0, 0, 0, 0},
	{E5, C5, A4, E4, E3, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, E2, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, Gs2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, B2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, E3, 0, 0, 0, 0},

	{E4, C4, A2, 0, 0, 0, 0, 0, 0},
	{A4, E4, C4, A2, 0, 0, 0, 0, 0},
	{C5, A4, E4, E3, 0, 0, 0, 0, 0},
	{E5, C5, A4, E4, E3, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, E2, 0, 0, 0, 0},
	{D5, B4, Gs4, F4, Gs2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, B2, 0, 0, 0, 0},
	{D5, B4, Gs4, E4, E3, 0, 0, 0, 0},

	{C5, A4, E4, C4, A2, 0, 0, 0, 0},
	{C5, A4, E4, C4, C3, 0, 0, 0, 0},
	{C5, G4, E4, C4, E3, 0, 0, 0, 0},
	{C5, G4, E4, C4, A2, 0, 0, 0, 0},
	{C5, Fs4, C4, D3, 0, 0, 0, 0, 0},
	{A4, Fs4, C4, D3, 0, 0, 0, 0, 0},
	{C5, Fs4, C4, D3, 0, 0, 0, 0, 0},
	{A4, Fs4, C4, D3, 0, 0, 0, 0, 0},

	{Bb4, G2, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, G4, D4, Bb3, D3, 0, 0, 0, 0},
	{Bb4, G4, Eb4, Bb3, Cs3, 0, 0, 0, 0},
	{Bb4, G4, Eb4, Bb3, Cs3, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, C3, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, C3, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, Bb2, 0, 0, 0, 0},
	{Bb4, G4, E4, Bb3, A2, 0, 0, 0, 0},

	/* verse 2 */
	{F4, F2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, F2, 0, 0, 0, 0, 0, 0},
	{F4, A3, F2, 0, 0, 0, 0, 0, 0},
	{F4, F3, F2, 0, 0, 0, 0, 0, 0},
	{C5, A2, 0, 0, 0, 0, 0, 0, 0},
	{C5, A4, A2, 0, 0, 0, 0, 0, 0},
	{C5, E4, A2, 0, 0, 0, 0, 0, 0},
	{C5, C4, A2, 0, 0, 0, 0, 0, 0},

	{F4, D2, 0, 0, 0, 0, 0, 0, 0},
	{F4, D4, D2, 0, 0, 0, 0, 0, 0},
	{F4, A3, D2, 0, 0, 0, 0, 0, 0},
	{F4, F3, D2, 0, 0, 0, 0, 0, 0},
	{D3, 0, 0, 0, 0, 0, 0, 0, 0},
	{A2, 0, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, A3, F2, 0, 0, 0, 0, 0},
	{A4, F4, A2, D2, 0, 0, 0, 0, 0},

	{Bb4, Bb1, 0, 0, 0, 0, 0, 0, 0},
	{Bb4, F4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb1, 0, 0, 0, 0, 0, 0},
	{Bb4, Bb3, Bb1, 0, 0, 0, 0, 0, 0},
	{A4, C2, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C2, 0, 0, 0, 0, 0, 0},
	{A4, C4, C2, 0, 0, 0, 0, 0, 0},
	{A4, A3, C2, 0, 0, 0, 0, 0, 0},

	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	{G4, G3, 0, 0, 0, 0, 0, 0, 0},
	{G4, E3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{C4, Bb3, G3, C3, 0, 0, 0, 0, 0},

	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},
	
	/* ending */
	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{F4, C4, A3, C3, 0, 0, 0, 0, 0},
	{F4, C4, A3, F3, 0, 0, 0, 0, 0},
	{F4, C4, A3, E3, 0, 0, 0, 0, 0},
	{F4, C4, A3, D3, 0, 0, 0, 0, 0},
	{C4, A3, F3, C3, 0, 0, 0, 0, 0},
	
	{D4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, F3, Bb2, 0, 0, 0, 0, 0, 0},
	{D4, Bb3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, Bb2, 0, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, G3, Bb2, 0, 0, 0, 0, 0, 0},
	{E4, C4, Bb2, 0, 0, 0, 0, 0, 0},

	{F4, A2, 0, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{F4, F3, A2, 0, 0, 0, 0, 0, 0},
	{F4, C4, A2, 0, 0, 0, 0, 0, 0},
	{G4, D4, Bb3, Bb2, 0, 0, 0, 0, 0},
	{A4, D4, Bb3, A2, 0, 0, 0, 0, 0},
	{Bb4, D4, Bb3, G2, 0, 0, 0, 0, 0},

	{A4, C3, 0, 0, 0, 0, 0, 0, 0},
	{A4, F4, C3, 0, 0, 0, 0, 0, 0},
	{A4, C4, C3, 0, 0, 0, 0, 0, 0},
	{A4, A3, C3, 0, 0, 0, 0, 0, 0},
	{G4, C2, 0, 0, 0, 0, 0, 0, 0},
	{G4, E4, C2, 0, 0, 0, 0, 0, 0},
	{G4, C4, C2, 0, 0, 0, 0, 0, 0},
	{G4, Bb3, C2, 0, 0, 0, 0, 0, 0},

	{F4, C4, A3, F2, 0, 0, 0, 0, 0},
	{F4, C4, A3, E3, F2, 0, 0, 0, 0},
	{F4, C4, A3, D3, F2, 0, 0, 0, 0},
	{F4, C4, A3, C3, F2, 0, 0, 0, 0},

	{F2, 0, 0, 0, 0, 0, 0, 0, 0},
	{F2, C3, 0, 0, 0, 0, 0, 0, 0},
	{F2, C3, A3, 0, 0, 0, 0, 0, 0},
	{F2, C3, A3, F4, 0, 0, 0, 0, 0},
	{F2, C3, A3, F4, A4, 0, 0, 0, 0},
	{F2, C3, A3, F4, F5, 0, 0, 0, 0},
};

double beatArray[] = 
{
	/* intro */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 1,

	/* verse 1 */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 0.5, 0.5,

	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 0.5, 0.5,

	/* chorus */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,

	/* verse 2 */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 1,

	/********* repeat *********/
	/* verse 1 */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 0.5, 0.5,

	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 0.5, 0.5,

	/* chorus */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,

	/* verse 2 */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,

	/* ending */
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.66, 0.66, 0.66,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 1, 1, 1,
	0.1, 0.1, 0.1, 0.1, 0.1, 4
};