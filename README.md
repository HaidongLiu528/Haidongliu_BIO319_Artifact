\# BIO319 FYP Artifact: Topiramate-BSA Study



Author: Haidong Liu (ID: 2147592) | \*\*Supervisor\*\*: Dr. Faez Iqbal Khan  

Repo: https://github.com/HaidongLiu528/BIO319\_Artifact



This artifact contains all files to reproduce the computational workflow evaluating Topiramate as a glycation blocker for Bovine Serum Albumin. The workflow includes molecular docking using AutoDock Vina to determine binding affinity at the Sudlow site I, a 500 nanosecond molecular dynamics simulation using GROMACS 2023.2, and post-simulation analysis of RMSD, RMSF, Radius of Gyration, and Solvent Accessible Surface Area. All simulations were performed on the XJTLU HPC cluster.



The computational environment requires GROMACS 2023.2 with GPU acceleration, AutoDock Vina 1.2.3, PDBFixer 1.8, ACPYPE 2022.7.27, and Python 3.9 with numpy and matplotlib. The protein force field is AMBER99SB-ILDN with SPC water, and the random seed is set to 2147592.



The artifact is organized into six directories. The 01\_inputs folder contains PDB structures, ligand files, and all .mdp parameters. The 02\_docking folder stores Vina configuration and results. The 03\_md\_simulation directory contains topology files, nine executable scripts covering the full pipeline, and simulation logs. The 04\_analysis folder holds raw .xvg data and .png figures. The 05\_trajectories directory contains the processed trajectory hosted externally. The 06\_documentation folder provides environment specs, command history, and validation checklists.



To reproduce the workflow, navigate to 03\_md\_simulation and run scripts 01 through 09 in numerical order: pdb2gmx conversion, solvation, ion addition, energy minimization, NVT equilibration, NPT equilibration, 500 ns production, analysis extraction, and figure generation. All SLURM submission scripts are included for HPC execution.



The docking results showed a binding affinity of -6.2 kcal/mol with hydrogen bonds to Gln 220 and Val 342. The 500 ns simulation demonstrated that Topiramate stabilizes BSA significantly. The complex maintained RMSD between 0.20-0.35 nm while apo BSA reached 0.55 nm. The Radius of Gyration decreased from 2.80 to 2.72 nm, and SASA reduced from 335 to 318 nm², confirming that Topiramate promotes a compact fold and shields glycation hotspots.



All professor-required components are provided: input files, .mdp parameters, topology with ligand ITP, complete scripts, environment specs, command history, random seed, processed trajectory, raw .xvg data, figures, and documentation.



The trajectory file complex\_50ps.xtc.gz (\~2.3 GB) is hosted externally due to GitHub limits. Contact the author for access. The repository is available at the link above. AI was used only for script debugging and copy-editing; all simulation data were generated through personal HPC execution with no fabrication.





Contact: haidong.liu21@student.xjtlu.edu.cn

