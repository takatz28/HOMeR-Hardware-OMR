# HOMeR: Hardware Optical Music Recognition
For a complete description of the overall design, click [here].


## Abstract
From the thesis "Hardware/Software Co-design of an Optical Music Recognition System":

> The objective of the project presented herein is to provide a co-design approach to the general optical music recognition (OMR) framework. The proposed system aims to be the first step towards a full-fledged hardware implementation of a music recognizer.

> The OMR system is partitioned into two subsystems: software and hardware. Utilizing a combination of morphological and template matching techniques, the HOMeR software subsystem processes and converts simple monophonic, homophonic, and piano sheet music images to two numeric arrays corresponding to notes and beats through a graphical user interface. Subsequently, the hardware subsystem applies these array outputs into a custom synthesizer core written for the Zybo Z7 development board, which produces an organ-like audible equivalent of the initial input images through the onboard audio codec. 

> HOMeR was able to process sheet music images of different types and sizes with high accuracy and fast run times, both for pre- and post- correction.
---------------------------------------
## Requirements
* Software
  * [MATLAB] R2019a or later 
  * [Vivado] Design Suite 2019.1 (primarily Xilinx SDK and Vivado)
  * Digilent Support [Board Files] for Vivado
* Hardware
  * [Zybo] Z7: Zynq-7000 ARM/FPGA SoC Development Board (Z7-20 variant)
  * Speaker with an AUX connection

## Setup Instructions
1. Download the required software.
2. Clone the repository.
3. Open the _HOMeR.mlapp_ within the HOMeR folder. Ensure that the current workspace is the HOMeR folder.
4. Select sheet music image(s) to be read, then click on the _Read_ _Score_ button.
5. Once the processing is complete, open Xilinx SDK. When prompted for the workspace, select the _OrganNotes.sdk_ folder.
6. Connect the Zybo board to the computer using a micro-USB cord. Insert one end of an AUX cord to the HPH OUT port of the board, and the other to the speaker.
7. Program the FPGA.
8. Click on _Run_ _As_ &gt; _Launch_ _On_ _Hardware_ _(GDB)_.
9. Push the BTN1 button on the board to listen to the audio version of the images.

## Notes
<details><summary>If the Synthesizer IP core is to be modified, follow these instructions:</summary>
1. Delete the contents of the *OrganNotes.sdk* folder under _HOMeR_.
2. Open Vivado 2019.1.
3. Using the tcl console, type the following:
```tcl
cd <change to extracted_folder>/Synthesizer/
source ./OrganNotes.tcl
```
4. Once the project is created, Modify the IP through the Block Design section.
5. Create a new HDL wrapper for the block design, then generate the bitstream.
6. Go to File &gt; Export &gt ;Export Hardware. Make sure that the "Include Bitstream" box is marked, and the "Export to" location is the *OrganNotes.sdk* folder.
7. Go to File &gt; Launch SDK. Change both "Exported location" and "Workspace" to *OrganNotes.sdk*, then click OK.
</details>
* Launch On Hardware must be performed after every image read.
* The board need not to be re-programmed every read, unless the audio produces undesirable results.

## Demonstrations
* _Synthesizer_: The tune files being read by the synthesizer were hardcoded to test its capabilities before final integration.
  * [Flight of the Bumblebee]
  * [Tetris Theme Song]
  * [The Girl From Ipanema]
  * [You Are The Sunshine of my Life]
* _HOMeR App_: The following videos demonstrate various test cases for the app.
  * Single image:
	* [Greensleeves]
    * [In the Hall of the Mountain King]
	* [You Are My Sunshine]
  * Multiple images:
    * [Amazing Grace]

## Other Resources
  <details><summary>System Setup</summary>
	<p align="center">
	  <img width="600" height="600" src="https://github.com/takatz28/HOMeR-Hardware-OMR/blob/master/docs/Setup.jpg">
	</p>
  </details>
  
  <details><summary>Block Diagram</summary>
	<p align="center">
	  <img width="400" height="150" src="https://github.com/takatz28/HOMeR-Hardware-OMR/blob/master/docs/HOMeR.jpg">
	</p>
  </details>
  
  <details><summary>HOMeR Sample Output</summary>
	<p align="center">
	  <img width="600" height="400" src="https://github.com/takatz28/HOMeR-Hardware-OMR/blob/master/docs/minuet.jpg">
	</p>
  </details>
  
  
[here]:
https://drive.google.com/file/d/1sfMDNLTtfQq3ZvBRsBOUUY3n6wHFgWAe/view?usp=sharing
[MATLAB]:
https://www.mathworks.com/products/matlab/student.html?s_tid=htb_learn_gtwy_cta3
[Vivado]:
https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html
[Zybo]:
https://digilent.com/shop/zybo-z7-zynq-7000-arm-fpga-soc-development-board/
[Board Files]:
https://digilent.com/reference/programmable-logic/guides/install-board-files
[Greensleeves]:
https://drive.google.com/file/d/14uhCoezqQO5v1ydMc-PGA70H_gl-lwgg/view?usp=sharing
[In the Hall of the Mountain King]:
https://drive.google.com/file/d/1inY15nAcpwpulG6GEa-EEbANPE5pXs2x/view?usp=sharing
[You Are My Sunshine]:
https://drive.google.com/file/d/1sL9n_EVkKScEoXfHMqU1KZrMXq_a1d0v/view?usp=sharing
[Amazing Grace]:
https://drive.google.com/file/d/1pv0Ghh1rKgaRMufB96hQwcvFTqPTBlgw/view?usp=sharing
[Flight of the Bumblebee]:
https://drive.google.com/file/d/1bX15-7DolUZvAkDcviW_WpkBffbX5UmK/view?usp=sharing
[Tetris Theme Song]:
https://drive.google.com/file/d/1VbuS7QhAdDdBe_8DlKGI6_5K2n84xQ28/view?usp=sharing
[The Girl From Ipanema]:
https://drive.google.com/file/d/14gtuzIP55wYlUJ-fh8lDUJaByMgvlCX-/view?usp=sharing
[You Are The Sunshine of my Life]:
https://drive.google.com/file/d/1xnBoizPs20fYIUJMBPO8VAIRHUKl-ZFI/view?usp=sharing
