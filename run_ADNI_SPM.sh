#!/bin/bash

module purge
module load matlab

matlab -nodisplay -nosplash -softwareopengl -r "Run_SPM_PSC('$1')" > ./logs/slurm/$1_log.txt