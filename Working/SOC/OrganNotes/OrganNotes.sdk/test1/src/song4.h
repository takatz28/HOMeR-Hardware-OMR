#define TEMPO		775000

int noteArray[][9] =
{
	{D4, Fs4, D3, 0, 0, 0, 0, 0, 1},
	{Cs4, E4, A2, 0, 0, 0, 0, 0, 1},
	{B3, D4, B2, 0, 0, 0, 0, 0, 1},
	{A3, Cs4, Fs2, 0, 0, 0, 0, 0, 1},
	{G3, B3, G2, 0, 0, 0, 0, 0, 1},
	{Fs3, A3, D2, 0, 0, 0, 0, 0, 1},
	{G3, B3, G2, 0, 0, 0, 0, 0, 1},
	{A3, Cs4, A2, 0, 0, 0, 0, 0, 1},
	///////////////////////

	{Fs4, D5, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, D5, Fs3, 0, 0, 0, 0, 0, 0},
	{A4, Cs5, A3, 0, 0, 0, 0, 0, 0},
	{A4, Cs5, G3, 0, 0, 0, 0, 0, 0},
	{D4, B4, Fs3, 0, 0, 0, 0, 0, 0},
	{D4, B4, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, Fs3, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, E3, 0, 0, 0, 0, 0, 0},

	{B3, G4, D3, 0, 0, 0, 0, 0, 0},
	{B3, G4, B2, 0, 0, 0, 0, 0, 0},
	{D4, Fs4, D3, 0, 0, 0, 0, 0, 0},
	{D4, Fs4, A2, 0, 0, 0, 0, 0, 0},
	{B3, G4, G2, 0, 0, 0, 0, 0, 0},
	{B3, G4, B2, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, Cs3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, A2, 0, 0, 0, 0, 0, 0},
	///////////////////////

	{Fs4, D5, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, D5, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, D5, Fs3, 0, 0, 0, 0, 0, 0},
	{Fs4, D5, A3, 0, 0, 0, 0, 0, 0},
	{E4, Cs5, A3, 0, 0, 0, 0, 0, 0},
	{E4, Cs5, A2, 0, 0, 0, 0, 0, 0},
	{E4, Cs5, E3, 0, 0, 0, 0, 0, 0},
	{E4, Cs5, A3, 0, 0, 0, 0, 0, 0},

	{D4, B4, A3, 0, 0, 0, 0, 0, 0},
	{D4, B4, B2, 0, 0, 0, 0, 0, 0},
	{D4, B4, D3, 0, 0, 0, 0, 0, 0},
	{D4, B4, Fs3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, Fs3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, Fs2, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, Cs3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, Fs3, 0, 0, 0, 0, 0, 0},

	{B3, G4, Fs3, 0, 0, 0, 0, 0, 0},
	{B3, G4, G2, 0, 0, 0, 0, 0, 0},
	{B3, G4, B2, 0, 0, 0, 0, 0, 0},
	{B3, G4, D3, 0, 0, 0, 0, 0, 0},
	{A3, Fs4, D3, 0, 0, 0, 0, 0, 0},
	{A3, Fs4, D2, 0, 0, 0, 0, 0, 0},
	{A3, Fs4, A2, 0, 0, 0, 0, 0, 0},
	{A3, Fs4, D3, 0, 0, 0, 0, 0, 0},

	{B3, G4, D3, 0, 0, 0, 0, 0, 0},
	{B3, G4, G2, 0, 0, 0, 0, 0, 0},
	{B3, G4, B2, 0, 0, 0, 0, 0, 0},
	{B3, G4, D3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, E3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, A2, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, Cs3, 0, 0, 0, 0, 0, 0},
	{Cs4, A4, E3, 0, 0, 0, 0, 0, 0},
	///////////////////////

	{D5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{D5, D3, 0, 0, 0, 0, 0, 0, 0},
	{D4, D3, 0, 0, 0, 0, 0, 0, 0},
	{Cs4, A3, 0, 0, 0, 0, 0, 0, 0},
	{A4, A3, 0, 0, 0, 0, 0, 0, 0},
	{E4, G3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, G3, 0, 0, 0, 0, 0, 0, 0},

	{D4, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{D5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{B4, D3, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{A5, E3, 0, 0, 0, 0, 0, 0, 0},
	{B5, E3, 0, 0, 0, 0, 0, 0, 0},

	{G5, D3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{E5, B2, 0, 0, 0, 0, 0, 0, 0},
	{G5, B2, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{E5, D3, 0, 0, 0, 0, 0, 0, 0},
	{D5, A2, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, A2, 0, 0, 0, 0, 0, 0, 0},

	{B4, B2, 0, 0, 0, 0, 0, 0, 0},
	{A4, B2, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, D3, 0, 0, 0, 0, 0, 0, 0},
	{E4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{G4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, A2, 0, 0, 0, 0, 0, 0, 0},
	{E4, A2, 0, 0, 0, 0, 0, 0, 0},
	//////////////////////

	{D4, D3, 0, 0, 0, 0, 0, 0, 0},
	{D4, E3, 0, 0, 0, 0, 0, 0, 0},
	{D5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{D5, G3, 0, 0, 0, 0, 0, 0, 0},
	{A4, A3, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, A3, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, G3, 0, 0, 0, 0, 0, 0, 0},

	{Fs4, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, B3, 0, 0, 0, 0, 0, 0, 0},
	{B4, A3, 0, 0, 0, 0, 0, 0, 0},
	{B4, G3, 0, 0, 0, 0, 0, 0, 0},
	{E4, A3, 0, 0, 0, 0, 0, 0, 0},
	{E4, G3, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{A4, E3, 0, 0, 0, 0, 0, 0, 0},

	{B3, D3, 0, 0, 0, 0, 0, 0, 0},
	{B3, B2, 0, 0, 0, 0, 0, 0, 0},
	{G4, B3, 0, 0, 0, 0, 0, 0, 0},
	{G4, Cs4, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, D4, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, Cs4, 0, 0, 0, 0, 0, 0, 0},
	{A4, B3, 0, 0, 0, 0, 0, 0, 0},
	{A4, A3, 0, 0, 0, 0, 0, 0, 0},

	{E4, G3, 0, 0, 0, 0, 0, 0, 0},
	{E4, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{E4, D5, E3, 0, 0, 0, 0, 0, 0},
	{E4, D5, B3, 0, 0, 0, 0, 0, 0},
	{A4, D5, A3, 0, 0, 0, 0, 0, 0},
	{A4, D5, B3, 0, 0, 0, 0, 0, 0},
	{A4, Cs5, A3, 0, 0, 0, 0, 0, 0},
	{A4, Cs5, G3, 0, 0, 0, 0, 0, 0},
	////////////////////////

	{A5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{G5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{A5, D3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{G5, D3, 0, 0, 0, 0, 0, 0, 0},
	{A5, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{B4, A2, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, A2, 0, 0, 0, 0, 0, 0, 0},
	{D5, A2, 0, 0, 0, 0, 0, 0, 0},
	{E5, A2, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, A2, 0, 0, 0, 0, 0, 0, 0},
	{G5, A2, 0, 0, 0, 0, 0, 0, 0},

	{Fs5, B2, 0, 0, 0, 0, 0, 0, 0},
	{D5, B2, 0, 0, 0, 0, 0, 0, 0},
	{E5, B2, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, D3, 0, 0, 0, 0, 0, 0, 0},
	{G4, D3, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{B4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{G4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{G4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs2, 0, 0, 0, 0, 0, 0, 0},

	{G4, G2, 0, 0, 0, 0, 0, 0, 0},
	{B4, G2, 0, 0, 0, 0, 0, 0, 0},
	{A4, G2, 0, 0, 0, 0, 0, 0, 0},
	{G4, B2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, B2, 0, 0, 0, 0, 0, 0, 0},
	{E4, B2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, D2, 0, 0, 0, 0, 0, 0, 0},
	{E4, D2, 0, 0, 0, 0, 0, 0, 0},
	{D4, D2, 0, 0, 0, 0, 0, 0, 0},
	{E4, D2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, A2, 0, 0, 0, 0, 0, 0, 0},
	{G4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{B4, A2, 0, 0, 0, 0, 0, 0, 0},

	{G4, G2, 0, 0, 0, 0, 0, 0, 0},
	{B4, G2, 0, 0, 0, 0, 0, 0, 0},
	{A4, G2, 0, 0, 0, 0, 0, 0, 0},
	{B4, B2, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, B2, 0, 0, 0, 0, 0, 0, 0},
	{D5, B2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{B4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{D5, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{E5, A2, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, A2, 0, 0, 0, 0, 0, 0, 0},
	{G5, A2, 0, 0, 0, 0, 0, 0, 0},
	{A5, A2, 0, 0, 0, 0, 0, 0, 0},

	{A5, D3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, A3, 0, 0, 0, 0, 0, 0, 0},
	{G5, A3, 0, 0, 0, 0, 0, 0, 0},
	{A5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{G5, D3, 0, 0, 0, 0, 0, 0, 0},
	{A5, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{B4, A2, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, A2, 0, 0, 0, 0, 0, 0, 0},
	{D5, E3, 0, 0, 0, 0, 0, 0, 0},
	{E5, E3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, E3, 0, 0, 0, 0, 0, 0, 0},
	{G5, E3, 0, 0, 0, 0, 0, 0, 0},

	{Fs5, B2, 0, 0, 0, 0, 0, 0, 0},
	{D5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{E5, Fs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, D3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, B2, 0, 0, 0, 0, 0, 0, 0},
	{G4, B2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{B4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{G4, Fs2, 0, 0, 0, 0, 0, 0, 0},
	{A4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{G4, Cs3, 0, 0, 0, 0, 0, 0, 0},
	{A4, Cs3, 0, 0, 0, 0, 0, 0, 0},

	{G4, G2, 0, 0, 0, 0, 0, 0, 0},
	{B4, D3, 0, 0, 0, 0, 0, 0, 0},
	{A4, D3, 0, 0, 0, 0, 0, 0, 0},
	{G4, B2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, G2, 0, 0, 0, 0, 0, 0, 0},
	{E4, G2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, D2, 0, 0, 0, 0, 0, 0, 0},
	{E4, D2, 0, 0, 0, 0, 0, 0, 0},
	{D4, D2, 0, 0, 0, 0, 0, 0, 0},
	{E4, D2, 0, 0, 0, 0, 0, 0, 0},
	{Fs4, A2, 0, 0, 0, 0, 0, 0, 0},
	{G4, A2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{B4, A2, 0, 0, 0, 0, 0, 0, 0},

	{G4, G2, 0, 0, 0, 0, 0, 0, 0},
	{B4, G2, 0, 0, 0, 0, 0, 0, 0},
	{A4, G2, 0, 0, 0, 0, 0, 0, 0},
	{B4, B2, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, B2, 0, 0, 0, 0, 0, 0, 0},
	{D5, B2, 0, 0, 0, 0, 0, 0, 0},
	{A4, A2, 0, 0, 0, 0, 0, 0, 0},
	{B4, A2, 0, 0, 0, 0, 0, 0, 0},
	{Cs5, A2, 0, 0, 0, 0, 0, 0, 0},
	{D5, A2, 0, 0, 0, 0, 0, 0, 0},
	{E5, E3, 0, 0, 0, 0, 0, 0, 0},
	{Fs5, E3, 0, 0, 0, 0, 0, 0, 0},
	{G5, E3, 0, 0, 0, 0, 0, 0, 0},
	{A5, E3, 0, 0, 0, 0, 0, 0, 0},

	{D5, Fs5, D3, 0, 0, 0, 0, 0, 0},
	{D5, Fs5, D3, Fs3, 0, 0, 0, 0, 0},
	{D5, Fs5, D3, A3, 0, 0, 0, 0, 0},
	{D5, Fs5, D3, A3, 0, 0, 0, 0, 0},
	{Cs5, Fs5, A2, 0, 0, 0, 0, 0, 0},
	{Cs5, G5, A2, E3, 0, 0, 0, 0, 0},
	{Cs5, Fs5, A2, A3, 0, 0, 0, 0, 0},
	{Cs5, E5, A2, A3, 0, 0, 0, 0, 0},

	{B4, D5, B2, 0, 0, 0, 0, 0, 0},
	{B4, D5, B2, D3, 0, 0, 0, 0, 0},
	{B4, D5, B2, Fs3, 0, 0, 0, 0, 0},
	{B4, D5, B2, Fs3, 0, 0, 0, 0, 0},
	{A4, D5, Fs2, 0, 0, 0, 0, 0, 0},
	{A4, E5, Fs2, Cs3, 0, 0, 0, 0, 0},
	{A4, D5, Fs2, Fs3, 0, 0, 0, 0, 0},
	{A4, Cs5, Fs2, Fs3, 0, 0, 0, 0, 0},

	{G4, B4, G2, 0, 0, 0, 0, 0, 0},
	{G4, B4, G2, B2, 0, 0, 0, 0, 0},
	{G4, B4, G2, D3, 0, 0, 0, 0, 0},
	{G4, B4, G2, D3, 0, 0, 0, 0, 0},
	{Fs4, A4, D2, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, D2, A2, 0, 0, 0, 0, 0},
	{Fs4, A4, D2, D3, 0, 0, 0, 0, 0},
	{Fs4, A4, D2, D3, 0, 0, 0, 0, 0},

	{G4, D5, G2, 0, 0, 0, 0, 0, 0},
	{G4, C5, G2, B2, 0, 0, 0, 0, 0},
	{G4, B4, G2, D3, 0, 0, 0, 0, 0},
	{G4, C5, G2, D3, 0, 0, 0, 0, 0},
	{E4, A4, A2, 0, 0, 0, 0, 0, 0},
	{E4, A4, A2, Cs3, 0, 0, 0, 0, 0},
	{E4, A4, A2, E3, 0, 0, 0, 0, 0},

	{Fs4, A4, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, A3, 0, 0, 0, 0, 0, 1},
	{Fs4, A4, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, A2, 0, 0, 0, 0, 0, 0},
	{G4, B4, A2, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, A3, 0, 0, 0, 0, 0, 0},
	{E4, G4, A3, 0, 0, 0, 0, 0, 0},

	{D4, Fs4, B2, 0, 0, 0, 0, 0, 0},
	{D4, Fs4, Fs3, 0, 0, 0, 0, 0, 1},
	{D4, Fs4, B2, 0, 0, 0, 0, 0, 0},
	{D4, Fs4, Fs2, 0, 0, 0, 0, 0, 0},
	{E4, G4, Fs2, 0, 0, 0, 0, 0, 0},
	{D4, Fs4, Fs3, 0, 0, 0, 0, 0, 0},
	{Cs4, E4, Fs3, 0, 0, 0, 0, 0, 0},

	{B3, D4, G2, 0, 0, 0, 0, 0, 0},
	{B3, D4, D3, 0, 0, 0, 0, 0, 0},
	{G4, B4, D3, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, D2, 0, 0, 0, 0, 0, 0},
	{Fs4, A4, D3, 0, 0, 0, 0, 0, 0},

	{B4, D5, G2, 0, 0, 0, 0, 0, 0},
	{A4, C5, G2, 0, 0, 0, 0, 0, 0},
	{G4, B4, G3, 0, 0, 0, 0, 0, 0},
	{C5, G3, 0, 0, 0, 0, 0, 0},
	{A4, Cs5, A2, 0, 0, 0, 0, 0, 0},
	{A4, Cs5, A3, 0, 0, 0, 0, 0, 0},
	///////////////////////////////

	{A4, D5, Fs5, D3, 0, 0, 0, 0, 0},
	{A4, D5, Fs5, D4, 0, 0, 0, 0, 0},
	{A4, Cs5, E5, Cs4, 0, 0, 0, 0, 0},
	{A4, Cs5, E5, A3, 0, 0, 0, 0, 0},
	{Fs4, B4, D5, B2, 0, 0, 0, 0, 0},
	{Fs4, B4, D5, B3, 0, 0, 0, 0, 0},
	{Fs4, A4, Cs5, A3, 0, 0, 0, 0, 0},
	{Fs4, A4, Cs5, Fs3, 0, 0, 0, 0, 0},

	{D4, G4, B4, G2, 0, 0, 0, 0, 0},
	{D4, G4, B4, G3, 0, 0, 0, 0, 0},
	{D4, Fs4, A4, Fs3, 0, 0, 0, 0, 0},
	{D4, Fs4, A4, D3, 0, 0, 0, 0, 0},
	{B3, D4, G4, G3, 0, 0, 0, 0, 0},
	{B3, D4, G4, G2, 0, 0, 0, 0, 0},
	{A3, Cs4, E4, A2, 0, 0, 0, 0, 0},
	{A3, Cs4, E4, E3, 0, 0, 0, 0, 0},
	/////////////////////////////

	{D4, Fs4, D3, 0, 0, 0, 0, 0, 0},
	{D4, Fs4, D3, A3, 0, 0, 0, 0, 0},
	{Cs4, E4, D3, A3, 0, 0, 0, 0, 0},
	{Cs4, E4, A2, A3, 0, 0, 0, 0, 0},
	{B3, D4, B2, 0, 0, 0, 0, 0, 0},
	{B3, D4, B2, Fs3, 0, 0, 0, 0, 0},
	{A3, Cs4, B2, Fs3, 0, 0, 0, 0, 0},
	{A3, Cs4, Fs2, Fs3, 0, 0, 0, 0, 0},

	{G3, B3, G2, 0, 0, 0, 0, 0, 0},
	{G3, B3, G2, D3, 0, 0, 0, 0, 0},
	{Fs3, A3, G2, D3, 0, 0, 0, 0, 0},
	{Fs3, A3, D2, D3, 0, 0, 0, 0, 0},
	{G3, B3, G2, 0, 0, 0, 0, 0, 0},
	{G3, B3, G2, D3, 0, 0, 0, 0, 1},
	{A3, Cs4, A2, E3, 0, 0, 0, 0, 0},
	{Fs3, D4, D2, D3, 0, 0, 0, 0, 0}
};

double beatArray[] =
{
	2, 2, 2, 2, 2, 2, 2, 2,
	1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1,

	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,

	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,

	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
		0.5, 0.5,

	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,

	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
	0.5, 0.25, 0.25, 0.5, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,
		0.25, 0.25, 0.25, 0.25,

	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1,

	1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	1, 0.5, 0.5, 1, 1,
	0.5, 0.5, 0.5, 0.5, 1, 1,

	1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1,

	1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 2, 4
};
