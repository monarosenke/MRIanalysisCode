

addpath('/Users/rosenke/Dropbox/MatlabCodes/permutationQuentin/');


%% alignment with N = 10 for main paper, pairwise comparisons
% data: /.../Results/dc_singleValuesPermutations.mat

for ind = 1:3 % for all threshold levels
    temp(:,:,1) = ANTSlh(:,:,ind);
    temp(:,:,2) = ANTSrh(:,:,ind);
    ants = mean(temp,3);
    
    temp(:,:,1) = MNIlh(:,:,ind);
    temp(:,:,2) = MNIrh(:,:,ind);
    mni = mean(temp,3);
    
    temp(:,:,1) = FSlh(:,:,ind);
    temp(:,:,2) = FSrh(:,:,ind);
    cba = mean(temp,3);
    
    %  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
    disp(['now for threshold: ' ind]);
    for i = 1:8
        ants_cba(i) = permutest(cba(:,i),ants(:,i),10000);
        mni_cba(i) = permutest(cba(:,i),mni(:,i),10000);
        mni_ants(i) = permutest(ants(:,i),mni(:,i),10000);
    end
    
    ants_cba
    mni_cba
    mni_ants
    
end

%% alignment with N = 10 comparisons against chance
% (1) data: /.../Results/dc_singleValuesPermutations.mat
% (2) data: /.../Results/dcSimN10_new_singleValsThreshold0and2.mat &
% K(3) same as (2) with: _vol.mat

% CBA vs Chance CBA
% for thres 0 and 2
temp(:,:,1) = FSlh(:,:,1);
temp(:,:,2) = FSrh(:,:,1);
cba = mean(temp,3);
c = CBAchance(:,:,1);
%  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
disp(['now for threshold: 0']);
for i = 1:8
    chancecba_cba(i) = permutestpaired(cba(:,i),c(:,i),10000);
    
end
chancecba_cba

temp(:,:,1) = FSlh(:,:,3);
temp(:,:,2) = FSrh(:,:,3);
cba = mean(temp,3);
c = CBAchance(:,:,2);
%  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
disp(['now for threshold: 2' ]);
for i = 1:8
    chancecba_cba(i) = permutestpaired(cba(:,i),c(:,i),10000);
    
end
chancecba_cba


% NVA vs Chance Vol
% for thres 0 and 2
temp(:,:,1) = ANTSlh(:,:,1);
temp(:,:,2) = ANTSrh(:,:,1);
ants = mean(temp,3);
c = VOLchance(:,:,1);
%  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
disp(['now for threshold: 0']);
for i = 1:8
    chancevol_ants(i) = permutestpaired(ants(:,i),c(:,i),10000);
    
end
chancevol_ants

temp(:,:,1) = ANTSlh(:,:,3);
temp(:,:,2) = ANTSrh(:,:,3);
cba = mean(temp,3);
c = VOLchance(:,:,2);
%  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
disp(['now for threshold: 2' ]);
for i = 1:8
    chancevol_ants(i) = permutestpaired(ants(:,i),c(:,i),10000);
    
end
chancevol_ants


% AVA vs Chance Vol
% for thres 0 and 2
temp(:,:,1) = MNIlh(:,:,1);
temp(:,:,2) = MNIrh(:,:,1);
mni = mean(temp,3);
c = VOLchance(:,:,1);
%  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
disp(['now for threshold: 0']);
for i = 1:8
    chancevol_mni(i) = permutestpaired(mni(:,i),c(:,i),10000);
    
end
chancevol_mni

temp(:,:,1) = MNIlh(:,:,3);
temp(:,:,2) = MNIrh(:,:,3);
mni = mean(temp,3);
c = VOLchance(:,:,2);
%  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
disp(['now for threshold: 2']);
for i = 1:8
    chancevol_mni(i) = permutestpaired(mni(:,i),c(:,i),10000);
    
end
chancevol_mni

%% alignment with N = 9, CBApm vs CBAfs

% projects/Mona/ventralcROIatlas/Results/dc_single_CBA_FS_N9_forDiB.mat

for ind = 1:3 % for all threshold levels
    temp(:,:,1) = diceCsingle_all_cbalh(:,:,ind);
    temp(:,:,2) = diceCsingle_all_cbarh(:,:,ind);
    cbapm9 = mean(temp,3);
    cbapm9(10,:) = [];
    
    
    temp(:,:,1) = diceCsingle_all_fslh(:,:,ind);
    temp(:,:,2) =diceCsingle_all_fsrh(:,:,ind);
    cbafs9 = mean(temp,3);
    cbafs9(10,:) = [];
    
    %  10000 permutations, in the order of ROIs( hOc1, hOc2, hOc3v, hOc4v, FG1, FG2, FG3, FG4)
    disp(['now for threshold: ' mat2str(ind)]);
    for i = 1:8
        cbapm9_cbafs9(i) = permutest(cbafs9(:,i),cbapm9(:,i),10000);
        
    end
    
    cbapm9_cbafs9
    
end


%% permutation Kastner overlap vs chance
% data: projects/Mona/ventralcROIatlas/Results/overlapWithFunction/ (1)
% Kastner_chance_single.mat & (2) Kastner_single.mat


for f = 1:9
    
    for ind = 1:8
        c = chance(:,f);
        p = squeeze(proportionsKsingle(ind,f,:));
        pval = permutest(p,c,10000);
        disp(['result for ' mat2str(ind) '.cROI with ' mat2str(f) '.fROI ']);
        disp(pval);
    end
    disp(' ');
end

%% permutation Glasser overlap vs chance
% data: projects/Mona/ventralcROIatlas/Results/overlapWithFunction/ (1)
% Glasser_chance_single.mat & (2) Glasser_single.mat


for h = 1:2 % hemispheres
    disp(['hemisphere (1 = lh, 2 = rh): ' mat2str(h)]);
    for f = 1:15 % Glasser regions
        for ind = 1:8 % cROIs
            c = chanceG(:,f);
            p = squeeze(proportionsGsingle(ind,f,:,h));
            pval = permutest(p,c,10000);
            disp(['result for ' mat2str(ind) '.cROI with ' mat2str(f) '.fROI ']);
            disp(pval);
        end
        disp(' ');
    end
end
