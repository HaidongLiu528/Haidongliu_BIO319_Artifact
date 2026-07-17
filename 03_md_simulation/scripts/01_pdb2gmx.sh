#!/bin/bash
# ============================================
# Step 01: Generate topology from PDB
# Input:  ../data/PROTEIN.pdb
# Output: ../data/PROTEIN.gro, topol.top, posre.itp
# ============================================

# Load GROMACS module
module load gromacs/2023.2-gcc-9.5.0-jzxesel

echo "Running pdb2gmx..."

gmx_mpi pdb2gmx \
    -f ../data/PROTEIN.pdb \
    -o ../data/PROTEIN.gro \
    -water spc \
    -ignh \
    -ff amber99sb-ildn

echo "Step 01 complete: topology generated"