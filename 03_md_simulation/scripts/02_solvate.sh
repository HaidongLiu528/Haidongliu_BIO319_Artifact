# Add box and solvent
module load gromacs/2023.2-gcc-9.5.0-jzxesel
gmx_mpi editconf \
    -f PROTEIN.gro \
    -o PROTEIN_newbox.gro \
    -bt cubic \
    -c \
    -d 1.0
gmx_mpi solvate \
    -cp PROTEIN_newbox.gro \
    -cs spc216.gro \
    -p topol.top \
    -o solv.gro