# MD analysis
module load gromacs/2023.2-gcc-9.5.0-jzxesel
# RMSD
echo 4 4 | gmx_mpi rms \
    -s md.tpr \
    -f md_fit.xtc \
    -o rmsd.xvg \
    -tu ns
# RMSF
echo 4 | gmx_mpi rmsf \
    -s md.tpr \
    -f md_fit.xtc \
    -o rmsf.xvg \
    -res
# SASA
echo 4 | gmx_mpi sasa \
    -s md.tpr \
    -f md_fit.xtc \
    -o sasa.xvg \
    -tu ns
# Rg
echo 5 | gmx_mpi gyrate \
    -s md.tpr \
    -f md_fit.xtc \
    -o gyrate.xvg