<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This contains the implementation of sha 256 algo 
implemented as follows:-

It is divided into three stages of pipeline 

1st stage :- W and K calculation

 K calculation is based on the look up table info retrieval. for each phase 0-63 we have a counter running and that is used as address to the look up tab le to get the data 
 W calculation - We use the input 16 32 bit registers as a fifo wherein the current w word would be the first 32 bit register while every cycle we calculate the new 32 bit value and append it at the end 
 Here we are using the small sigma instantiation - sigma 0 and sigma 1  and 3 adders + 1 adder to add the content of W and K and send it forward  
2ns stage :- A,B,C,D,E,F,G,H calculation 

 Here we instantiate the majority , Big Sigma instantiations - 0 and 1 and choice instances and have 6 adders 

3rd stage - 

We calculate the final values of hash register 

On top of it a wrapper is built to make it compatible to TINYTAPEOUT recommended input output reference 

## How to test

Drive uio_in[6] to activate the wrapper and drive uio_in[5:0] as counter address to load the input bytes for sha message digest. The counter has to run till 64 to load 64 bytes of input data. Wait for uio_out[7] to become 1 and once it becomes one again drive uio_in[6] = 0 and uio_in[4:0] 32 times to get 32 bytes as the output

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
