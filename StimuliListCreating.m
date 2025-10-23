% Stimuli List Creating
% Save all stimuli video data in a mat files in order
% 
% By Qihao He, 2025 February

clear all
clc;

CodePath = '/Users/Shared/D/1PKU北大_______/PengLab/FaceAU/FaceAU_PilotCode2_v3.0';
emoType = {'Angry','Happy'};
Parameters = readtable('StimuliParameters.xlsx');

s = 0;
for emo = 1:2 % two emotions
    % female
    female_info = dir(fullfile([CodePath,'/TestStimuli/',emoType{emo},'/Female/'],'*.mp4'));
    for fe = 1:length(female_info)
        s = s + 1;
        Stimuli(s).num = Parameters.num(s);
        Stimuli(s).video = female_info(fe).name;
        Stimuli(s).emoType = emoType{emo};
        Stimuli(s).gender = 'female';
        % AU_Angry_Happy
        Stimuli(s).P_AU5_AU6 = Parameters.P_AU5_AU6(s);
        Stimuli(s).P_AU9_AU12 = Parameters.P_AU9_AU12(s);
        Stimuli(s).P_AU10_AU25 = Parameters.P_AU10_AU25(s);
        Stimuli(s).A_AU5_AU6 = Parameters.A_AU5_AU6(s);
        Stimuli(s).A_AU9_AU12 = Parameters.A_AU9_AU12(s);
        Stimuli(s).A_AU10_AU25 = Parameters.A_AU10_AU25(s);
        
    end

    % male
    male_info = dir(fullfile([CodePath,'/TestStimuli/',emoType{emo},'/Male/'],'*.mp4'));
    for ma = 1:length(male_info)
        s = s + 1;
        Stimuli(s).num = Parameters.num(s);
        Stimuli(s).video = male_info(ma).name;
        Stimuli(s).emoType = emoType{emo};
        Stimuli(s).gender = 'male';
        Stimuli(s).P_AU5_AU6 = Parameters.P_AU5_AU6(s);
        Stimuli(s).P_AU9_AU12 = Parameters.P_AU9_AU12(s);
        Stimuli(s).P_AU10_AU25 = Parameters.P_AU10_AU25(s);
        Stimuli(s).A_AU5_AU6 = Parameters.A_AU5_AU6(s);
        Stimuli(s).A_AU9_AU12 = Parameters.A_AU9_AU12(s);
        Stimuli(s).A_AU10_AU25 = Parameters.A_AU10_AU25(s);
        

    end
end


% % shuffle the sequence
% random_seq = randperm(length(FaceStimuli_sequence));
% for ii = 1 : length(random_seq)
%     FaceStimuli_shuffle(ii).image = FaceStimuli_sequence(random_seq(1,ii)).image;
%     FaceStimuli_shuffle(ii).emoType = FaceStimuli_sequence(random_seq(1,ii)).emoType;
%     FaceStimuli_shuffle(ii).gender = FaceStimuli_sequence(random_seq(1,ii)).gender;
% end

% save the Learning stimuli pathlist
save(fullfile(CodePath, 'StimuliList.mat'), 'Stimuli');
