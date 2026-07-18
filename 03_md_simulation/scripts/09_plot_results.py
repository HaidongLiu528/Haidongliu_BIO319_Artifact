#MD Plotting Graphs
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
rmsf   = load('rmsf.xvg')
sasa   = load('sasa.xvg')
gyrate = load('rg.xvg')
fig, axes = plt.subplots(2, 3, figsize=(16, 10))
# RMSD 
ax = axes[0, 0]
ax.plot(rmsd[:, 0], rmsd[:, 1], color='#2c3e50', linewidth=1.0)
ax.set_xlabel('Time (ns)'); ax.set_ylabel('RMSD (nm)')
ax.set_title('RMSD', fontweight='bold')
# RMSF
ax = axes[0, 1]
ax.plot(rmsf[:, 0], rmsf[:, 1], color='#c0392b', linewidth=0.8)
ax.set_xlabel('Residue number'); ax.set_ylabel('RMSF (nm)')
ax.set_title('RMSF', fontweight='bold')
# SASA
ax = axes[0, 2]
ax.plot(sasa[:, 0], sasa[:, 1], color='#27ae60', linewidth=1.0)
ax.set_xlabel('Time (ns)'); ax.set_ylabel('SASA (nm²)')
ax.set_title('Solvent Accessible Surface Area', fontweight='bold')
# Rg
ax = axes[1, 0]
ax.plot(gyrate[:, 0], gyrate[:, 1], color='#e67e22', linewidth=1.0)
ax.set_xlabel('Time (ns)'); ax.set_ylabel('Rg (nm)')
ax.set_title('Radius of Gyration', fontweight='bold')
