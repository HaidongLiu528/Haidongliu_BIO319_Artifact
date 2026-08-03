#!/bin/bash
#SBATCH --job-name=md        # Job name
#SBATCH --partition=gpu4090
#SBATCH --qos=2gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gpus=1
#SBATCH -e %j.err         # Error output
#SBATCH -o %j.out

module load gromacs/2023.2-gcc-9.5.0-jzxesel

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
gmx_mpi grompp -f md.mdp \
               -c npt.gro \
               -t npt.cpt \
               -p topol.top \
               -r npt.gro \
               -o md.tpr \
               -maxwarn 1

gmx_mpi mdrun -deffnm md -v
