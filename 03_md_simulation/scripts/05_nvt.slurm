#!/bin/bash
#SBATCH --job-name=nvt          # Job name
#SBATCH --partition=gpu4090
#SBATCH --qos=2gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus=1
#SBATCH -e %j.err               # Error output
#SBATCH -o %j.out               # Standard output

module load gromacs/2023.2-gcc-9.5.0-jzxesel

# Step 1: Preprocessing (create binary input file)
gmx_mpi grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -maxwarn 1

# Step 2: Run NVT equilibration
gmx_mpi mdrun -deffnm nvt -v
