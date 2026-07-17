#!/bin/bash
# ============================================
# Step 03: Add ions
# Input:  solv.gro, topol.top, ../mdp/ions.mdp
# Output: solv_ions.gro
# ============================================

# Load GROMACS module
module load gromacs/2023.2-gcc-9.5.0-jzxesel

echo "Preparing ion addition..."
gmx_mpi grompp \
    -f ../mdp/ions.mdp \
    -c solv.gro \
    -p topol.top \
    -o ions.tpr \
    -maxwarn 1

echo "Adding ions at 0.15 M NaCl..."
echo SOL | gmx_mpi genion \
    -s ions.tpr \
    -o solv_ions.gro \
    -p topol.top \
    -pname NA \
    -nname CL \
    -conc 0.150

echo "Step 03 complete: ions added"