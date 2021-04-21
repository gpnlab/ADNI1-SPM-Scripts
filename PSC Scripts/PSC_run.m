function [] = PSC_run(step,subj_num)
%everything has to be SINGLE QUOTES
switch step
    case "step03"
        if isfile(strcat('./step03_coregister/',subj_num,'.mat'))
            spm_jobman('run',strcat('./step03_coregister/',subj_num,'.mat'))
        end
    case "step04"
        spm_jobman('run',strcat('./step04_segment/',subj_num,'.mat'))
    case "step05"
        spm_jobman('run',strcat('./step05_mask_ICV_auto/',subj_num,'.mat'))
    case "step06"
        spm_jobman('run',strcat('./step06_apply_mask/',subj_num,'.mat'))
    case "step07"
        spm_jobman('run',strcat('./step07_normalize/',subj_num,'.mat'))
end