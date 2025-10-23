% Practice Stimuli List Creating
% Save all stimuli video data in a mat files in order
% By Qihao He, 2024 July

clear all
clc;

CodePath = '/Users/Shared/D/1PKU北大_______/PengLab/FaceAU/FaceAU_PilotCode_v4.0';

videoFiles = {'Happy_M.mp4', 'Happy_F.mp4', 'Angry_M.mp4', 'Angry_F.mp4'};
emoType = {'Happy', 'Happy', 'Angry', 'Angry'};
gender = {'male', 'female', 'male', 'female'};


for i=1:length(videoFiles)
    PracticeStimuli(i).video = videoFiles{i};
    PracticeStimuli(i).emoType = emoType{i};
    PracticeStimuli(i).gender = gender{i};
end


% save the Learning stimuli pathlist
save(fullfile(CodePath, 'PracticeStimuliList.mat'), 'PracticeStimuli');