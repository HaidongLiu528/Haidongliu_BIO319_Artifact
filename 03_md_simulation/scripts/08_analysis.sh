#!/bin/bash
# ============================================
# Step 08: MD analysis
# Input:  md.tpr, md.xtc, md.edr
# Output: rmsd.xvg, BACKBONErmsf.xvg, sasa.xvg,
#         gyrate.xvg, energy.xvg
# ============================================

# Load GROMACS module
module load gromacs/2023.2-gcc-9.5.0-jzxesel

# ------------------------------
# Preprocessing: center and fit
# ------------------------------
echo "Centering trajectory..."
echo 1 0 | gmx_mpi trjconv \
    -s md.tpr \
    -f md.xtc \
    -center \
    -ur compact \
    -pbc nojump \
    -o md_center.xtc

echo "Fitting trajectory..."
echo 1 0 | gmx_mpi trjconv \
    -s md.tpr \
    -f md_center.xtc \
    -fit rot+trans \
    -o md_fit.xtc

# ------------------------------
# 1. RMSD
# ------------------------------
echo "Calculating RMSD..."
echo 4 4 | gmx_mpi rms \
    -s md.tpr \
    -f md_fit.xtc \
    -o ../results/rmsd.xvg \
    -tu ns

# ------------------------------
# 2. RMSF
# ------------------------------
echo "Calculating RMSF..."
echo 4 | gmx_mpi rmsf \
    -s md.tpr \
    -f md_fit.xtc \
    -o ../results/BACKBONErmsf.xvg \
    -res

# ------------------------------
# 3. SASA
# ------------------------------
echo "Calculating SASA..."
echo 4 | gmx_mpi sasa \
    -s md.tpr \
    -f md_fit.xtc \
    -o ../results/sasa.xvg \
    -tu ns

# ------------------------------
# 4. Radius of gyration
# ------------------------------
echo "Calculating radius of gyration..."
echo 5 | gmx_mpi gyrate \
    -s md.tpr \
    -f md_fit.xtc \
    -o ../results/gyrate.xvg

# ------------------------------
# 5. Energy terms (Temperature, Potential, Kinetic)
# ------------------------------
echo "Extracting energy terms..."
echo 11 12 13 0 | gmx_mpi energy \
    -f md.edr \
    -o ../results/energy.xvg

echo "Step 08 complete: all analyses done"