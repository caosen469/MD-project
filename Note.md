**Note for CEE298: Multiscale Modeling**
Construct a **silicon** nanowire, and lattice dimensions of (2 2 6). This simulation box is periodic in x and y directions and **non-periodic in Z direction**.

The first goal of our simulation is to **minimize and relax structure at 300K and zero pressure**. 

Then, apply **incremental strain  in the z direction** and **Calculate the resulting stress in that direction**. To do so, increse the length of wire by 0.1 A at each 
iteration of the loop, and relax your system NVT ensemble for 50 ps with relaxation time of 0.1p ps. When the simulation is done, average the resulting stress in the z 
direction and plot the stress-strain diagram.

Use Stillinger-Weber potential. To change the cell dimensions, you can use the 'change_box' command. To calculate stress, use 'compute pressure' command. This compute
calculates a global scalar (the pressure) and a global vector of length 6
