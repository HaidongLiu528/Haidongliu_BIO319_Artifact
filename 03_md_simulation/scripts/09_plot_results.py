#!/usr/bin/env python3
"""
=============================================================================
MD Analysis Plotting Script (Extended)
Generates a 2x3 panel summary figure:
  RMSD, RMSF, SASA, Rg, Temperature, Potential Energy

Input:  ../results/*.xvg
Output: ../results/md_analysis_summary.png
=============================================================================
"""

import matplotlib.pyplot as plt
import numpy as np
import os

plt.rcParams.update({
    'font.family': 'Arial',
    'font.size': 10,
    'axes.linewidth': 1.0,
    'xtick.direction': 'in',
    'ytick.direction': 'in',
    'xtick.major.width': 1.0,
    'ytick.major.width': 1.0,
})

results_dir = '../results'

def load(path):
    return np.loadtxt(os.path.join(results_dir, path), comments=('#', '@'))

rmsd   = load('rmsd.xvg')
rmsf   = load('BACKBONErmsf.xvg')
sasa   = load('sasa.xvg')
gyrate = load('gyrate.xvg')
energy = load('energy.xvg')

fig, axes = plt.subplots(2, 3, figsize=(16, 10))

# ---- RMSD ----
ax = axes[0, 0]
ax.plot(rmsd[:, 0], rmsd[:, 1], color='#2c3e50', linewidth=1.0)
ax.set_xlabel('Time (ns)'); ax.set_ylabel('RMSD (nm)')
ax.set_title('Backbone RMSD', fontweight='bold')

# ---- RMSF ----
ax = axes[0, 1]
ax.plot(rmsf[:, 0], rmsf[:, 1], color='#c0392b', linewidth=0.8)
ax.set_xlabel('Residue number'); ax.set_ylabel('RMSF (nm)')
ax.set_title('Backbone RMSF', fontweight='bold')

# ---- SASA ----
ax = axes[0, 2]
ax.plot(sasa[:, 0], sasa[:, 1], color='#27ae60', linewidth=1.0)
ax.set_xlabel('Time (ns)'); ax.set_ylabel('SASA (nm²)')
ax.set_title('Solvent Accessible Surface Area', fontweight='bold')

# ---- Rg ----
ax = axes[1, 0]
ax.plot(gyrate[:, 0], gyrate[:, 1], color='#e67e22', linewidth=1.0)
ax.set_xlabel('Time (ns)'); ax.set_ylabel('Rg (nm)')
ax.set_title('Radius of Gyration', fontweight='bold')

# ---- Temperature ----
ax = axes[1, 1]
ax.plot(energy[:, 0], energy[:, 1], color='#8e44ad', linewidth=1.0)
ax.axhline(y=310, color='grey', linestyle='--', alpha=0.6, label='Target 310 K')
ax.set_xlabel('Time (ps)'); ax.set_ylabel('Temperature (K)')
ax.set_title('Temperature', fontweight='bold')
ax.legend(frameon=False, fontsize=8)

# ---- Potential Energy ----
ax = axes[1, 2]
ax.plot(energy[:, 0], energy[:, 2], color='#2980b9', linewidth=1.0)
ax.set_xlabel('Time (ps)'); ax.set_ylabel('Potential Energy (kJ/mol)')
ax.set_title('Potential Energy', fontweight='bold')

plt.tight_layout()
output_path = os.path.join(results_dir, 'md_analysis_summary.png')
plt.savefig(output_path, dpi=300, bbox_inches='tight')
print(f'Figure saved to: {output_path}')
plt.show()