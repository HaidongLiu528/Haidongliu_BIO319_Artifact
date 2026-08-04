\# BIO319 FYP Artifact: Topiramate-BSA Study



\*\*Author\*\*: Haidong Liu (ID: 2147592)

\*\*Supervisor\*\*: Dr. Faez Iqbal Khan

\*\*Repository\*\*: https://github.com/HaidongLiu528/BIO319_Artifact





\## 1. What is this artifact?



This artifact contains all files required to reproduce the computational workflow that evaluates Topiramate as a potential glycation blocker for Bovine Serum Albumin (BSA). The workflow consists of three main components:



\- Molecular docking using AutoDock Vina to determine binding affinity at the Sudlow site I

\- 500 nanosecond molecular dynamics simulation using GROMACS 2023.2

\- Post-simulation analysis including RMSD, RMSF, Radius of Gyration, and Solvent Accessible Surface Area



All simulations were performed on the XJTLU High-Performance Computing cluster.





\## 2. System requirements



| Component | Version |

|-----------|---------|

| GROMACS | 2023.2 (GPU-accelerated) |

| AutoDock Vina | 1.2.3 (via PyRx 0.8) |

| PDBFixer | 1.8 |

| ACPYPE | 2022.7.27 |

| Python | 3.9.13 |

| numpy | 1.23.5 |

| matplotlib | 3.6.2 |



\*\*Force field\*\*: AMBER99SB-ILDN

\*\*Water model\*\*: SPC

\*\*Random seed\*\*: 2147592





\## 3. Directory structure



BIO319\_Artifact/

├── README.md

├── 01\_inputs/

│   ├── receptor/

│   │   ├── 3V03.pdb

│   │   └── receptor\_processed.pdb

│   ├── ligand/

│   │   ├── topiramate.sdf

│   │   └── topiramate.pdbqt

│   └── mdp\_files/

│       ├── minim.mdp

│       ├── nvt.mdp

│       ├── npt.mdp

│       └── md.mdp

├── 02\_docking/

│   ├── docking\_config.txt

│   ├── docking\_results.pdbqt

│   └── best\_pose.pdb

├── 03\_md\_simulation/

│   ├── topology/

│   │   ├── topol\_apo.top

│   │   ├── topol\_complex.top

│   │   └── posre.itp

│   ├── scripts/

│   │   ├── 01\_pdb2gmx.sh

│   │   ├── 02\_solvate.sh

│   │   ├── 03\_ions.sh

│   │   ├── 04\_em.sh

│   │   ├── 05\_nvt.slurm

│   │   ├── 06\_npt.slurm

│   │   ├── 07\_md.slurm

│   │   ├── 08\_analysis.sh

│   │   └── 09\_plot\_results.py

│   └── logs/

│       ├── em\_complex.log

│       ├── md\_apo.log

│       ├── md\_complex.log

│       ├── minim\_apo.log

│       ├── npt\_apo.log

│       ├── npt\_complex.log

│       ├── nvt\_apo.log

│       └── nvt\_complex.log

├── 04\_analysis/

│   ├── raw\_data/

│   │   ├── rg\_apo.xvg

│   │   ├── rg\_complex.xvg

│   │   ├── rmsd\_apo.xvg

│   │   ├── rmsd\_complex.xvg

│   │   ├── rmsf\_apo.xvg

│   │   ├── rmsf\_complex.xvg

│   │   ├── sasa\_apo.xvg

│   │   └── sasa\_complexxvg

│   └── figures/

│       ├── rmsd\_plot.png

│       ├── rmsf\_plot.png

│       ├── rg\_plot.png

│       └── sasa\_plot.png

└── 05\_documentation/

&#x20;   └── environment.txt





\## 4. Step-by-step reproduction



\### 4.1 Receptor preparation



The BSA crystal structure (PDB ID: 3V03) was repaired using PDBFixer to restore missing atoms and add hydrogens at pH 7.4. Only Chain A was retained.



python3 << EOF

from pdbfixer import PDBFixer

fixer = PDBFixer('3V03.pdb')

fixer.findMissingResidues()

fixer.findMissingAtoms()

fixer.addMissingAtoms()

fixer.addMissingHydrogens(pH=7.4)

with open('receptor\_processed.pdb', 'w') as f:

&#x20;   f.write(fixer.report())

EOF



grep "^ATOM" receptor\_processed.pdb | grep " A " > receptor\_chainA.pdb





\### 4.2 Ligand preparation



Topiramate (PubChem CID: 5284627) was downloaded and optimized using Open Babel. The PDBQT format was generated for docking, and GROMACS topology was generated using ACPYPE.





wget "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/5284627/record/SDF/?record\_type=3d" -O topiramate.sdf

obabel topiramate.sdf -O topiramate.pdb --gen3d --minimize --ff mmff94

prepare\_ligand4.py -l topiramate.pdb -o topiramate.pdbqt

acpype -i topiramate.pdb -c gas -n 0 -o gmx

cp topiramate\_GMX.itp ../03\_md\_simulation/topology/topiramate.itp





\### 4.3 Molecular docking



Docking was performed using AutoDock Vina via PyRx 0.8. The search space was centered at Sudlow site I (X=28.5, Y=23.0, Z=43.3 Å) with box dimensions 20.5 × 25.7 × 23.0 Å.



vina --config docking\_config.txt --out docking\_results.pdbqt

grep -A 1000 "MODEL 1" docking\_results.pdbqt > best\_pose.pdb





\### 4.4 MD simulation pipeline



Navigate to `03\_md\_simulation/scripts/` and run the following scripts in order:



ml gromacs/2023.2-gcc-9.5.0-jzxesel



\# Step 1: Convert pdb to GROMACS format  bash 01\_pdb2gmx.sh

gmx\_mpi pdb2gmx -f PROTEIN.pdb -o PROTEIN.gro -water spc -ignh

Select AMBER99SB-ILDN



\# Step 2: Add solvent box bash 02\_solvate.sh

gmx\_mpi editconf -f PROTEIN.gro -o PROTEIN\_newbox.gro -bt cubic -c -d 1.0

gmx\_mpi solvate -cp PROTEIN\_newbox.gro -cs spc216.gro -p topol.top -o solv.gro



\# Step 3: Add ions (0.15 M NaCl) bash 03\_ions.sh

gmx\_mpi grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr -maxwarn 1

gmx\_mpi genion -s ions.tpr -o solv\_ions.gro -p topol.top -pname NA -nname CL -conc 0.150

Select SOL



\# Step 4: Energy minimization

gmx\_mpi grompp -f minim.mdp -c solv\_ions.gro -p topol.top -o em.tpr -maxwarn 1

gmx\_mpi mdrun -v -deffnm em



\# Step 5-7: Equilibration and production (submit to SLURM)

sbatch\_nvt.slurm

sbatch\_npt.slurm

sbatch\_md.slurm



\# Step 8: Extract analysis data bash 08\_analysis.sh

ml gromacs/2023.2-gcc-9.5.0-jzxesel



\[1] RMSD

echo 4 4 | gmx\_mpi rms -s md.tpr -f md.xtc -o rmsd.xvg -tu ns



\[2] RMSF

echo 4 | gmx\_mpi rmsf -s md.tpr -f md.xtc -o BACKBONErmsf.xvg -res



\[3] SASA:

echo 4 | gmx\_mpi sasa -s md.tpr -f md.xtc -o sasa.xvg -tu ns



\[4] RG

echo 5 | gmx\_mpi gyrate -s md.tpr -f md.xtc -o gyrate.xvg



\# Step 9: Generate figures

python 09\_plot\_results.py



\### 4.5 Script details



\*\*01\_pdb2gmx.sh\*\*: Converts the processed BSA structure to GROMACS format using the AMBER99SB-ILDN force field and SPC water model.



\*\*02\_solvate.sh\*\*: Defines a cubic simulation box with a 1.0 nm buffer distance between the protein and box edges, then fills the box with SPC water molecules.



\*\*03\_ions.sh\*\*: Adds Na+ and Cl- ions to neutralize the system and reach a physiological salt concentration of 0.15 M.



\*\*04\_em.sh\*\*: Performs steepest descent energy minimization until the maximum force is below 1000 kJ/mol/nm.



\*\*05\_nvt.slurm\*\*: Runs 100 ps NVT equilibration at 310 K with position restraints on heavy atoms.



\*\*06\_npt.slurm\*\*: Runs 100 ps NPT equilibration at 310 K and 1 bar with position restraints.



\*\*07\_md.slurm\*\*: Runs 500 ns production MD with a 2 fs timestep under periodic boundary conditions.



\*\*08\_analysis.sh\*\*: Extracts RMSD, RMSF, Rg, and SASA data from the trajectory.



\*\*09\_plot\_results.py\*\*: Generates publication-quality figures from the extracted data.





\## 5. Analysis details



\### 5.1 RMSD (Root Mean Square Deviation)



Measures global structural stability of the protein backbone.





echo "4 4" | gmx\_mpi rms -s md.tpr -f md\_fit.xtc -o rmsd.xvg -tu ns





\### 5.2 RMSF (Root Mean Square Fluctuation)



Measures per-residue flexibility.





echo "4" | gmx\_mpi rmsf -s md.tpr -f md\_fit.xtc -o rmsf.xvg -res





\### 5.3 Radius of Gyration (Rg)



Measures protein compactness.





echo "5" | gmx\_mpi gyrate -s md.tpr -f md\_fit.xtc -o rg.xvg





\### 5.4 SASA (Solvent Accessible Surface Area)



Measures surface exposure of the protein.





echo "4" | gmx\_mpi sasa -s md.tpr -f md\_fit.xtc -o sasa.xvg -tu ns







\## 6. Key results



| Metric | Apo BSA | BSA-Topiramate Complex |

|--------|---------|------------------------|

| Binding affinity | N/A | -6.2 kcal/mol |

| RMSD (nm) | 0.55 | 0.20 - 0.35 |

| Radius of Gyration (nm) | 2.80 | 2.72 |

| SASA (nm²) | 335 | 318 |



\*\*Key hydrogen bonds\*\*: Gln220 and Val342 stabilize the complex at Sudlow site I.



\*\*Conclusion\*\*: Topiramate binding promotes a more compact BSA fold, effectively shielding glycation hotspots (Arg194, Lys439) from sugar attack.





\## 7. Data access



The full trajectory file (`complex\_50ps.xtc.gz`, \~2.3 GB) is hosted externally due to GitHub file size limitations. Please contact the author for download access.



All other files are available in the GitHub repository:

https://github.com/HaidongLiu528/BIO319_Artifact




\## 8. AI declaration



AI tools were used only for script debugging and copy-editing assistance. All raw simulation data were generated through personal execution on the XJTLU HPC cluster. No data was fabricated or generated by AI.





\##9. Contact



Haidong Liu

Email: haidong.liu21@student.xjtlu.edu.cn

