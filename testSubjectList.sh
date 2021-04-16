#!/bin/bash

mkdir -p ./logs/slurm
mapfile -t subjectArr < subjects.txt
echo ${subjectArr[10]}
files=${#subjectArr[@]}
for (( i=0; i<$files; i++ )); do
    queuing_command="sbatch \
        --job-name=ADNI_SPM_${i} \
        --partition=$partition \
        --exclude=$exclude \
        --nodes=1 \
        --time=$time \
        --ntasks=1 \
        --export=$export \
        --ntasks-per-node=1
        --mail-type=$mailType \
        --mail-user=$mailUser "

    #${queuing_command} matlab -nodisplay -nosplash -softwareopengl -r "Run_SPM_PSC('${subjectArr[$i]}')" > ./logs/slurm/${subjectArr[$i]}_log.txt
    echo ${subjectArr[$i]}
done