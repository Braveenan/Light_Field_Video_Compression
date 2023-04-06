clc;
clear variables;

myFolder = 'C:/Users/Braveenan/Downloads/test';
baseFileName = 'LFVR_new2.mat';

lfvName = sprintf('%s/%s', myFolder ,baseFileName);
load(lfvName);

size(lfv)
max(lfv(:))
min(lfv(:))
