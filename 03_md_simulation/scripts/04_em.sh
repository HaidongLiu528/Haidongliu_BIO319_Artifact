# Energy minimization
module load gromacs/2023.2-gcc-9.5.0-jzxesel
gmx_mpi grompp \
    -f minim.mdp \
    -c solv_ions.gro \
    -p topol.top \
    -o em.tpr \
    -maxwarn 1
gmx_mpi mdrun -v -deffnm em