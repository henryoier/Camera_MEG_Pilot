% SVM Decoding

%change the current directory to the project
%cd \dataslow\sheng\example codes\project_classifiers_exam

%initialize
clear;clc;
addpath(genpath('Functions'));
ProjectName = 'camera';
SubjectName = 'Camera_07'; %for more subjects use SubjectName = {'Subject01' 'Subject02'}; etc
RhythmMode = 'evoked';      % 'evoked' 'vectorlow' 'vectorhigh' 'single30'
SensorMode = 'all';         % 'all' 'test7' 'batch' 'scouts'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
permutations = 'p100';       % 'p10'
group = 'groupall';    	% 'groupall' 'grouptest' 'group1'
clusterflag = '0';          % '0' for single pc, '1' for cluster

addpath(genpath('Functions')); % add path of functions

param.trial_bin_size = 27;  % SVM parameter, group size
nSubjects = 1;

%% parameters
parameters_classifer;
parameters_analysis;

condA = {{'S1_t1'},{'S1_Red'},{'S2_t1'},{'S2_Red'},{'S1_Easy_10_28'},{'S2_Easy_10_28'}}; %use brackets to support multiple conditions, say condA = {'faces','houses'};
condB = {{'S1_t2'},{'S1_Blue'},{'S2_t2'},{'S2_Blue'},{'S1_Hard_30_34'},{'S2_Hard_30_36'}};

%% Run SVM clissifer
tic;
disp(['Subject = ' SubjectName]);

for cond = 1:6
    [Accuracy,Weight,Time] = svm_contrast_conditions_perm(SubjectName,condA{cond},condB{cond},param);
    save(char(strcat('Results/Mat_DecodingAccuracy/',...
         SubjectName,'_',condA{cond},'_versus_',condB{cond})),'Accuracy','Weight','Time','param');
end

toc;
