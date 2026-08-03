BIO319 FYP Artifact: Topiramate-BSA Study

Author: Haidong Liu (ID: 2147592)

Supervisor: Dr. Faez Iqbal Khan

Repo: https://github.com/HaidongLiu528/BIO319\_Artifact



Software versions provided (GROMACS 2023.2, Vina 1.2.3, etc.), force field (AMBER99SB-ILDN), water model (SPC), complete command history.



All files to reproduce the computational workflow evaluating Topiramate as a glycation blocker for BSA: docking, 500 ns MD simulation, and analysis.



Navigate to 03\_md\_simulation and run scripts 01 through 09 in order (pdb2gmx, solvation, ions, minimization, NVT, NPT, production, analysis, plotting).



Six directories. 01\_inputs contains PDB, ligand, and .mdp files. 02\_docking contains docking results. 03\_md\_simulation contains topology, 9 scripts, and logs. 04\_analysis contains .xvg data and .png figures. 05\_trajectories contains trajectory externally hosted. 06\_documentation contains environment, commands, and checklists.



.xvg raw data in 04\_analysis/raw\_data. RMSD/RMSF/Rg/SASA figures in 04\_analysis/figures. 



Binding affinity -6.2 kcal/mol with hydrogen bonds to Gln220/Val342. 500 ns MD shows complex RMSD stable at 0.20-0.35 nm (apo BSA reaches 0.55 nm). Rg decreases from 2.80 to 2.72 nm. SASA from 335 to 318 nm squared. 

