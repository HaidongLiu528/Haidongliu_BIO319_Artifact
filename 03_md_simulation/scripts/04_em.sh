#!/bin/bash
# ============================================
# Step 04: Energy minimization
# Input:  solv_ions.gro, topol.top, ../mdp/minim.mdp
# Output: em.gro, em.tpr
# ============================================

# Load GROMACS module
module load gromacs/2023.2-gcc-9.5.0-jzxesel

echo "Preparing energy minimization..."
gmx_mpi grompp \
    -f ../mdp/minim.mdp \
    -c solv_ions.gro \
    -p topol.top \
    -o em.tpr \
    -maxwarn 1

echo "Running energy minimization..."
gmx_mpi mdrun -v -deffnm em

echo "Step 04 complete: energy minimization done"