function [] = GPN_segment(study_dir,subject_list,images,ngaus,biasFWHM,save_path,spm='')
%% -------- DESCRIPTION --------
% Function creates a segment batch for each subject.
% This batch segments using all the information from the hires and other
% images.

%% -------- INPUTS --------
% study_dir = study directory [string, full path]
% subject_list = subject list [string, full path and name]
% images = images to segment (MPRAGE first) [cell string, partial path]
% ngaus = number of gaussians for each tissue, put 0 for defaults [vector]
% biasFWHM = window for bias correction (default = 60mm; 30mm is best for 7T) [double]
% save_path = directory to save batches [string, full path]

%% -------- OUTPUTS --------
% Generates a single segment batch for each subject. Performs
% multi-spectral segmentation if multiple images given.

%% -------- EXAMPLE --------
% study_dir = '/Volumes/HelmetKarim5/Study/data/';
% subject_list = '/Volumes/HelmetKarim5/Study/misc/subjectlist.txt';
% proc_dir = '/step01_structural_processing/';
% images = {[proc_dir '*Hires.nii']
%     [proc_dir 'r*FLAIR.nii']fileparts(which('SPM'))
%     [proc_dir 'r*PD.nii']
%     [proc_dir 'r*T2.nii']};
% ngaus = [0 0 0 0 0 0];
% biasFWHM = 60mm; %(default)
% save_path = '/Volumes/HelmetKarim5/Study/analysis/step01_structural_processing/step03_segment/';
% GPN_segment(study_dir,subject_list,images,ngaus,biasFWHM,save_path);

%% -------- FUNCTION --------
% set spm directory if needed
spm_dir = fileparts(which('SPM'));
if  strcmp(spm,'')
    spm_dir = spm;
end
% get list of subjects
subjlist = importdata(subject_list);
for subj = 1:length(subjlist)
    % Get subject and scan ID
    if iscellstr(subjlist)
        subjID = subjlist{subj};
    else
        subjID = num2str(subjlist(subj));
    end
    subjID = strsplit(subjID,'/');
    if size(subjID,2) == 2
        scanID = subjID{2};
        scanID = strrep(scanID,' ','');
    elseif size(subjID,2) == 1
        scanID = subjID{1};
    end
    subjID = subjID{1};
    clear matlabbatch;

    images_subj = strrep(images,'*',[scanID '_']); % get subject specific paths
    
    % set parameters
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001; % bias regularization parameter
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = biasFWHM;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[spm_dir '/tpm/TPM.nii,1']}; % TPM to use
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1; % number of gaussians (default)
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 1]; % native images to output
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [1 1]; % warped images to output
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[spm_dir '/tpm/TPM.nii,2']};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[spm_dir '/tpm/TPM.nii,3']};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[spm_dir '/tpm/TPM.nii,4']};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[spm_dir '/tpm/TPM.nii,5']};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[spm_dir '/tpm/TPM.nii,6']};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [1 1];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];

    % change gaussians (if needed)
    for i = 1:length(ngaus)
        if ngaus(i) ~= 0
            matlabbatch{1}.spm.spatial.preproc.tissue(i).ngaus = ngaus(i);
        end
    end
    
    % input each imaging type into segmentation
    for segidx = 1:length(images_subj)
        matlabbatch{1}.spm.spatial.preproc.channel(segidx) = matlabbatch{1}.spm.spatial.preproc.channel(1);
        matlabbatch{1}.spm.spatial.preproc.channel(segidx).vols{1} = [study_dir subjID '/' scanID images_subj{segidx}];
    end
    
    save([save_path subjID '_' scanID '.mat'],'matlabbatch'); % save the batch
end