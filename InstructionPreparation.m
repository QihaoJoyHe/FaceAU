% Instructions Preparation

clear all
clc;

CodePath = pwd;
cd '/Users/Shared/D/1PKU北大_______/PengLab/FaceAU/FaceAU_PilotCode2_v3.0/Instructions'

% Instruction Images Location

Instruction.Start = imread('Start1.PNG');
% Instruction.Start = imread('Start2.PNG');

Instruction.Practice = imread('Practice1.PNG');
% Instruction.Practice = imread('Practice2.PNG');

Instruction.Test = imread('Test1.PNG');
% Instruction.Test = imread('Test2.PNG');

Instruction.Rest = imread('Rest1.PNG');
% Instruction.Rest = imread('Rest2.PNG');

Instruction.Redo = imread('Redo1.PNG');
% Instruction.Redo = imread('Redo2.PNG');

Instruction.CorrectHH = imread('CorrectHH1.PNG');
% Instruction.CorrectHH = imread('CorrectHH2.PNG');

Instruction.CorrectAA = imread('CorrectAA1.PNG');
% Instruction.CorrectAA = imread('CorrectAA2.PNG');

Instruction.WrongAH = imread('WrongAH1.PNG');
% Instruction.WrongAH = imread('WrongAH2.PNG');

Instruction.WrongHA = imread('WrongHA1.PNG');
% Instruction.WrongHA = imread('WrongHA2.PNG');

Instruction.WrongUH = imread('WrongUH1.PNG');
% Instruction.WrongUH = imread('WrongUH2.PNG');

Instruction.WrongUA = imread('WrongUA1.PNG');
% Instruction.WrongUA = imread('WrongUA2.PNG');

Instruction.PracMiss = imread('PracMiss1.PNG');
% Instruction.PracMiss = imread('PracMiss2.PNG');

Instruction.Fail = imread('Fail.PNG');
Instruction.Pass = imread('Pass.PNG');
Instruction.Miss = imread('Miss.PNG');
Instruction.End = imread('End.PNG');
Instruction.Adjust = imread('FixAdjust.PNG');


save(fullfile(CodePath, 'Instructions1.mat'),'Instruction');
% save(fullfile(CodePath, 'Instructions2.mat'),'Instruction');
