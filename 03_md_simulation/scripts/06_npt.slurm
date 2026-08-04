#!/bin/bash
#SBATCH --job-name=npt        # Job name
#SBATCH --partition=gpu4090
#SBATCH --qos=2gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus=1
#SBATCH -e %j.err         # Error output
#SBATCH -o %j.out

module load gromacs/2023.2-gcc-9.5.0-jzxesel

gmx_mpi grompp -f npt.mdp \
               -c nvt.gro \
               -r nvt.gro \
               -t nvt.cpt \
               -p topol.top \
               -o npt.tpr \
               -maxwarn 1
gmx_mpi mdrun -deffnm npt -v

