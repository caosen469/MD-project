dimension    3
boundary    p p p
units metal

atom_style    atomic

neighbor    2.0 bin
neigh_modify delay 5
#neigh_modify    every 1 delay 0 check yes   

# create geometry

lattice        diamond 4
region        box block 0 2 0 2 0 6
create_box    1 box
create_atoms    1 box

mass        1 28.0855

# Stillinger-Weber potential for Si
pair_style sw
pair_coeff * * Si.sw Si

timestep 0.01
 
#Print
thermo          100
thermo_style custom step temp pe etotal press vol density

# minimize
dump 101 all xyz 10 si_min.xyz
fix 1 all box/relax iso 0.0
minimize 1.0e-6 1.0e-8 1000000 10000000

unfix 1 
undump 101

#---------------------------------NPT-----------------------------------------
dump 102 all xyz 10 npt.xyz
reset_timestep 0

thermo 10
#Relaxation
fix 1 all npt temp 300 300 0.1 iso 0 0 1
run 50
unfix 1
undump 102

#----------------------------NVT-----------------------------------------

reset_timestep 0
# Calculate potential energy at different distances
#compute 1 all pressure c_ID
compute test all temp 
compute 1 all pressure test



#variable      sigmazz equal c_ID[i]
#variable      sigmazz equal c_ID[3]
variable        sigmazz equal c_1[3]
variable        st equal step
variable        index loop 50

timestep 0.1

dump 103 all xyz 10 nvt.xyz

#loop starts
label loop
next            index

#change_box all xy final -0.1 z final 0.0 0.5 boundary p p f remap units box \
#change_box all xy scale -0.1 z boundary p p f remap units box 
change_box all z delta 0 0.1 boundary p p s remap units box
#change_box all xy final -0.1 z boundary p p f remap units box
#run 0



thermo 10
thermo_style custom step temp pe etotal press vol density c_1[3]
# NVT relaxation
fix 1 all nvt temp 300 300 1 

unfix 1 

fix 2 all print 100 "${st} ${sigmazz}" append thermo.out screen no title "# step stress "
#dump 103 all xyz 100 si_min_relaxation.xyz

run 50

jump            in.lj.for loop
#loop ends