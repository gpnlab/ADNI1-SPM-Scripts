study_dir = '/Volumes/cerebro/Studies/ADNI_2020/Public/Analysis/data/ADNI1/ADNI1_data/';
subject_list = '/Volumes/cerebro/Studies/ADNI_2020/Public/Analysis/processing/step01_ADNI1/step01_structural_processing/step01_copy_data/subjectlist_MPRAGE_T2FSE_2021_04_07.txt';
proc_dir = '/step01_structural_processing/';
save_dir = '/Volumes/cerebro/Studies/ADNI_2020/Public/Analysis/processing/step01_ADNI1/step01_structural_processing/';
hires_fname = 'MPRAGE.nii';
other1_fname = 'T2_FSE.nii';

% coregister
ref = [proc_dir hires_fname];
source = {[proc_dir other1_fname]};
other = {['']};
interp = 4;
save_path = [save_dir 'step03_coregister/']; mkdir(save_path);
GPN_coregister(study_dir,subject_list,ref,source,other,interp,save_path);

% segment
clearvars -except study_dir subject_list proc_dir save_dir hires_fname other1_fname;
images = {[proc_dir hires_fname]};
ngaus = [0 2 0 0 0 0];
save_path = [save_dir 'step04_segment/']; mkdir(save_path);
biasFWHM = 60;
My_GPN_segment(study_dir,subject_list,images,ngaus,biasFWHM,save_path,'../spm12');

% mask_ICV_auto
clearvars -except study_dir subject_list proc_dir save_dir hires_fname other1_fname;
input = {[proc_dir 'c1' hires_fname]
    [proc_dir 'c2' hires_fname]
    [proc_dir 'c3' hires_fname]};
save_path = [save_dir 'step05_mask_ICV_auto/']; mkdir(save_path);
GPN_create_mask_ICV_auto(study_dir,subject_list,input,save_path);

% apply mask
clearvars -except study_dir subject_list proc_dir save_dir hires_fname other1_fname;
images = {[proc_dir 'm' hires_fname]
    [proc_dir 'r' other1_fname]};
mask = [proc_dir 'mask_ICV_auto.nii'];
save_path = [save_dir 'step06_apply_mask/']; mkdir(save_path);
GPN_apply_mask(study_dir,subject_list,images,mask,save_path);

% normalize
clearvars -except study_dir subject_list proc_dir save_dir hires_fname other1_fname;
images = {[proc_dir 'm' hires_fname]
    [proc_dir 'r' other1_fname]
    [proc_dir 'strip_m' hires_fname]
    [proc_dir 'strip_r' other1_fname]};
deformation = [proc_dir 'y_' hires_fname];
iso_resolution = 1;
interp = 4;
save_path = [save_dir 'step07_normalize/']; mkdir(save_path);
GPN_normalize(study_dir,subject_list,images,deformation,iso_resolution,interp,save_path);