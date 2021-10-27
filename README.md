# HOMeR: Hardware Optical Music Recognition
For a complete description of the overall design, click [here].

From the Abstract section of the thesis "Hardware/Software Co-design of an Optical Music Recognition System":

> The objective of the project presented herein is to provide a co-design approach to the general optical music recognition (OMR) framework. The proposed system aims to be the first step towards a full-fledged hardware implementation of a music recognizer.

> The OMR system is partitioned into two subsystems: software and hardware. Utilizing a combination of morphological and template matching techniques, the HOMeR software subsystem processes and converts simple monophonic, homophonic, and piano sheet music images to two numeric arrays corresponding to notes and beats through a graphical user interface. Subsequently, the hardware subsystem applies these array outputs into a custom synthesizer core written for the Zybo Z7 development board, which produces an organ-like audible equivalent of the initial input images through the onboard audio codec. 

> HOMeR was able to process sheet music images of different types and sizes with high accuracy and fast run times, both for pre- and post- correction.
---------------------------------------
### Requirements
* Software
* Hardware


### Video Demonstrations
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


  
[here]:
https://drive.google.com/file/d/1sfMDNLTtfQq3ZvBRsBOUUY3n6wHFgWAe/view?usp=sharing
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
