# Ions add
module load gromacs/2023.2-gcc-9.5.0-jzxesel
gmx_mpi grompp \
    -f ions.mdp \
    -c solv.gro \
    -p topol.top \
    -o ions.tpr \
    -maxwarn 1
echo SOL | gmx_mpi genion \
    -s ions.tpr \
    -o solv_ions.gro \
    -p topol.top \
    -pname NA \
    -nname CL \
    -conc 0.150