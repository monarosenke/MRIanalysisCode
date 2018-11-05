
%cd '/biac2/kgs/projects/Mona/ventralcROIatlas/ANTsAlignment/';
%pathresults = '/biac2/kgs/projects/Mona/ventralcROIatlas/Results/';

subject = {'newpm295','pm14686', 'pm1696', 'pm18992','pm20784','pm28193','pm38281','pm54491','pm5694','pm6895'};

area =  {'hOcv1','hOcv2','hOcv3v','hOcv4_ns','FG1_ns','FG2_ns','FG3','FG4'};

hemi = {'l_','r_'};


thres = [0.1, 0.2 ,0.3 ,0.4 ,0.5 ,0.6 ,0.7 ,0.8 ,0.9,1];

combs = nchoosek(1:length(subject),length(subject)-1);

for h = 1:length(hemi) % lh/rh
    
    dc_single = NaN(length(subject),length(area),length(thres));
    for a = 2:length(area)
        Gmap = [];
        datacollect = [];
        
        % read in all data of all 10 subjects for the given ROI
        for s = 1:length(subject) % collect all subjects
            namenow = [hemi{h}, area{a},'_', subject{s},'_3dAllin.nii.gz'];
            niinow = readFileNifti(namenow);
            datacollect(s,:,:,:) = niinow.data;
        end
        
        
        for c = 1:size(combs,1)
            
            index_A = setdiff(1:length(subject),combs(c,:));
            Graw = datacollect;
            A = squeeze(Graw(index_A,:,:,:));
            Graw(index_A,:,:,:) = [];
            Gsum = squeeze(sum(Graw,1));
            Gmap = Gsum/size(combs,2);
            
            
            for t = 1:length(thres)
                G =  Gmap>= (thres(t)/(length(subject)-1));
                G = double(G);
                
                both = A+G; % sum of the two binary ROIs will result in 2 indicating overlap
                common = length(both(both==2));
                dc_single(c,a,t) = (2*common)/(length(A(A==1))+length(G(G==1))); % every column one ROI, rows for permuted combinations of leave-one-out
            end
        end
    end
    
    if(h ==1)
        LH_diceC_ANTs_N11 = squeeze(nanmean(dc_single))';
        LH_se_ANTs_N11 = nanstd(dc_single)./sqrt(length(subject)-1)';
    elseif(h==2)
        RH_diceC_ANTs_N11 = squeeze(nanmean(dc_single))';
        RH_se_ANTs_N11 = nanstd(dc_single)./sqrt(length(subject)-1)';
    end
end

%clearvars -except  LH_diceC_ANTs_N11  RH_diceC_ANTs_N11 LH_se_ANTs_N11 RH_se_ANTs_N11
