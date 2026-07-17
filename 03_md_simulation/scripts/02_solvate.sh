#!/bin/bash
# ============================================
# Step 02: Define box and add solvent
# Input:  ../data/PROTEIN.gro, topol.top
# Output: solv.gro
# ============================================

# Load GROMACS module
module load gromacs/2023.2-gcc-9.5.0-jzxesel

echo "Defining simulation box..."
gmx_mpi editconf \
    -f ../data/PROTEIN.gro \
    -o PROTEIN_newbox.gro \
    -bt cubic \
    -c \
    -d 1.0

echo "Adding solvent..."
gmx_mpi solvate \
    -cp PROTEIN_newbox.gro \
    -cs spc216.gro \
    -p topol.top \
    -o solv.gro

echo "Step 02 complete: solvent added"