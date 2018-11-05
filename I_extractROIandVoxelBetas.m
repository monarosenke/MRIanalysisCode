% facehands morphing study, MR Jul 2017
%
% extract betas from the facehands GLM based on (1) the rois as a whole,
% and (2) all voxels of each ROI separately. Script searches for the GLM
% called 'facehands'. Variables rois, subj, voxel_glm and roi_glm are saved
% with filename specified in line 12

clearvars
subj = {''};
rois = {'lh_MPM_FG2','lh_Wang_V02','rh_MPM_FG2','rh_Wang_V02'};
savename = '/Volumes/rosenke/projects/facehandsNew/results/voxelBetas_control.mat';


roi_glm = [];
voxel_glm = [];

cd /Volumes/rosenke/projects/facehandsNew/

for s = 1:length(subj)
    disp(subj{s})
    % clear all mrVista files
    clearvars -except subj rois roi_glm s voxel_glm savename
    
    cd(subj{s})
    hI = initHiddenInplane('GLMs',1,rois); % open an hidden inplane view with the GLM datatype
    
    % find the correct GLM
    temp = extractfield(dataTYPES(hI.curDataType).scanParams,'annotation');
    IndexC = strfind(temp, 'facehands');
    Index = find(not(cellfun('isempty', IndexC)));
    hI.curScan = Index;
    % loop over ROIs that are present for current subject
    r_hI = 1; % counter for the original ROI list
    for r = 1:length(rois)
        if(length(hI.ROIs)>=r_hI)
            if(strcmp(hI.ROIs(r_hI).name,rois{r}))
                disp(rois{r}); disp(hI.ROIs(r_hI).name); disp(' ');
                hI.selectedROI = r_hI;
                
                % load time course data and apply GLM
                
                
                [scans,dts] = er_getScanGroup(hI,hI.curScan);
                
                tc = tc_init(hI, rois{r}, scans, dts,0); %view, roi, scans, dt, queryFlag
                
                
                tc = tc_applyGlm(tc);
                
                
                % save betas for all ROIs and subjects
                roi_glm(s,r).betas = tc.glm.betas(1:5); % (subj, morphing level, roi)
                roi_glm(s,r).std = tc.glm.stdevs(1:5);
                roi_glm(s,r).sems = tc.glm.sems(1:5);
                roi_glm(s,r).trial_count = tc.glm.trial_count(1:5);
                roi_glm(s,r).varexplained = tc.glm.varianceExplained;
                roi_glm(s,r).subj_roi = [subj{s} ' ' rois{r}];
                % roi_glm(s,r).df = tc.glm.dof;
                % roi_glm(s,r).residuals = tc.glm.residual;
                
                
                % extract voxeldata
                mv = mv_init(hI, rois{r},scans,dts, 0);
                
                % mv_plotScans(hI,1);
                % mv_selectPlotType(2); mv_plotAmps([],[2 3]);
                mv = mv_applyGlm(mv);
                voxel_glm(s,r).betas = squeeze(mv.glm.betas(:,1:5,:))';
                voxel_glm(s,r).stdev = squeeze(mv.glm.stdevs(:,1:5,:))';
                voxel_glm(s,r).sems = squeeze(mv.glm.sems(:,1:5,:))';
                voxel_glm(s,r).residuals = mv.glm.residual';
                voxel_glm(s,r).df = mv.glm.dof;
                voxel_glm(s,r).trial_count = mv.glm.trial_count(1:5);
                voxel_glm(s,r).varexplained = mv.glm.varianceExplained;
                voxel_glm(s,r).subj_roi = [subj{s} ' ' rois{r}];
                voxel_glm(s,r).coordsAnat = mv.coordsAnatomy';
                voxel_glm(s,r).coordsInpl = mv.coordsInplane';
                
                r_hI = r_hI+1;
            end
        end
    end
    cd ..
    close all
end

close all

subj = subj;

save([savename '.mat'],'rois','subj','roi_glm','voxel_glm');

clearvars -except subj rois roi_glm voxel_glm savename