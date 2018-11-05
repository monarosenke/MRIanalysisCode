% bringing an ROI that is a freesurfer label on the fsaverage brain into
% subject space and then transforming it into mrVista file format to be a
% Gray ROI there
% MR Aug 2017



%% initialization 
%this script loops over all subjects, labels and both hemispheres to align
%an fsaverage-bkup label to the target subjects specified in "targets"
FSdir = '/biac2/kgs/3Danat/FreesurferSegmentations/';   % subject directory for the source labels
ProjectDir = '/biac2/kgs/projects/facehandsNew/'; % the directory where the label that should be converted lives
hem = {'lh','rh'};
source = 'fsaverage-bkup';
% savetargets = {'s4_kw_new' } %,'s5_kgs', 's6_nd_new', 's10_mh_new','s12_mf_new','s13_mt_new','s14_gt_new', 's15_mu_new','s16_mw_new','s17_mp_new','s18_xw_new', 's19_jw_new', 's20_gtg_new','s21_kk_new'};
targets = {'kevin_2013', 'kalanit_2013', 'nick','manuel','makiko','moqian','grace','melina','michaelw','michaelp','xiaoting','winawer','gami','kendrick'} % 'name in anatomy folder (in FreesurferSegmentations)
area = {'Wang_V02','MPM_FG2'}; % list of  labels that will be aligned, without the hemisphere as prefix

%% prepare freesurfer files to be ready for script that transforms the ROI into a mrVista ROI - run on server
for h = 1:length(hem)
    for s = 1:length(targets)
        dir = [FSdir targets{s} '/'];
        
        for a = 1:length(area)
             
            % bring label from fsaverage space to subject space
            targetlabel =  [hem{h} '.' area{a} '.alignedTo.' targets{s} '.label']; % name it will have
            command = [ 'mri_label2label  --srcsubject ' source ' --srclabel ' FSdir '/' source '/label/' hem{h} '.' area{a}  '.label  --trgsubject ' targets{s} ' --trglabel ' targetlabel ' --regmethod surface --hemi ' hem{h}];
            unix(command);
            
            % convert the label to a nifti file
            outname = [hem{h} '.' area{a} '.alignedTo.' targets{s} '.nii.gz'];
            % convert label to volume
            command = ['mri_label2vol --label ', dir, 'label/', targetlabel ' --temp ', FSdir, targets{s}, '/mri/orig.mgz', ' --reg ', dir, 'label/register.dat --proj frac 0 1 .1  --fillthresh 0.1  --subject ', targets{s}, ' --hemi ', hem{h}, ' --o ', ProjectDir, outname ] ;
            system(command);
            
            % reslice like mrVista anatomy
             toConvert = [ProjectDir outname];
             fileToBe = [ProjectDir hem{h} '.' area{a} '.alignedTo.' targets{s} '_resampled.nii.gz' ];
             reffile = ['/biac2/kgs/3Danat/' targets{s} '/t1.nii.gz'];

            command = ['mri_convert -ns 1 -rt nearest -rl  ',reffile, ' ', toConvert, ' ', fileToBe ];
             unix(command)
        end
    end
end

%% save out as mrVista ROI 

%cd /Volumes/rosenke/projects/facehandsNew
 addpath(genpath('/Volumes/rosenke/projects/facehandsNew/code/'))
subj = {'s4_kw_new','s5_kgs', 's6_nd_new', 's10_mh_new','s12_mf_new','s13_mt_new','s14_gt_new', 's15_mu_new','s16_mw_new','s17_mp_new','s18_xw_new', 's19_jw_new', 's20_gtg_new','s21_kk_new'}; %,'s16_mw_new'};  

cd /Volumes/rosenke/projects/facehandsNew/


for s = 1:length(subj)
   % dir = [FSdir targets{s} '/'];
    cd(subj{s})
    for h = 1:length(hem)
        for a = 1:length(area)
            % read in nifti file
            ni = readFileNifti(['/Volumes/rosenke/projects/facehandsNew/' hem{h} '.' area{a} '.alignedTo.' targets{s} '_resampled.nii.gz']);
            
            fname = [hem{h} '_' area{a} '.mat' ];

                    
            spath = ['/Volumes/rosenke/projects/facehandsNew/' subj{s} '/Anat/ROIs/'];
            ROI = niftiROI2mrVistaROI(ni, 'name', fname, 'spath', spath, 'color', 'm', 'layer', 2);   % function lives in: /projects/CytoArchitecture/segmentations/code.
            
            h3 = initHiddenGray('GLM',1,fname);
            
            hI = initHiddenInplane('GLMs',1);
            hI = vol2ipCurROI(h3,hI);
            saveROI(hI)
            
            
        end
    end
    cd ..
end

%%

%mrVista
%INPLANE{1} = loadROI(INPLANE{1}, 'lh_Kastner_hV4'); INPLANE{1} = refreshScreen(INPLANE{1});
%INPLANE{1} = loadROI(INPLANE{1}, 'lh_CoS_Weiner'); INPLANE{1} = refreshScreen(INPLANE{1});


