# Generate topology
module load gromacs/2023.2-gcc-9.5.0-jzxesel
gmx_mpi pdb2gmx \
    -f PROTEIN.pdb \
    -o PROTEIN.gro \
    -water spc \
    -ignh \
    -ff amber99sb-ildn