function [] = Run_SPM_PSC(subj_num)
%everything has to be SINGLE QUOTES
%make sure images have the structure 
%make sure to change this directory 
addpath ./spm12/
spm_jobman('initcfg')
PSC_run("step03",subj_num);
PSC_run("step04",subj_num);
PSC_run("step05",subj_num);
PSC_run("step06",subj_num);
PSC_run("step07",subj_num);