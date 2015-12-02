% SVM Decoding

%change the current directory to the project
%cd \dataslow\sheng\example codes\project_classifiers_exam

%initialize
clear all;
addpath(genpath('Functions'));
disp(pwd);
nSubjects = 1;

SubjectNames = {'Camera_07'}; %for more subjects use SubjectNames = {'Subject01' 'Subject02'}; etc

%parameters
param.brainstorm_db = [pwd '/brainstorm_db/camera/data/']; %directory of 'data' folder
param.data_type = 'MEG';
param.f_lowpass = 30;
param.num_permutations = 100;
param.trial_bin_size = 27;

condA = {{'S1_t1'},{'S1_Red'},{'S2_t1'},{'S2_Red'},{'S1_Easy_10_28'},{'S2_Easy_10_28'}}; %use brackets to support multiple conditions, say condA = {'faces','houses'};
condB = {{'S1_t2'},{'S1_Blue'},{'S2_t2'},{'S2_Blue'},{'S1_Hard_30_34'},{'S2_Hard_30_36'}};

%Run SVM analysis
for i = 1:length(SubjectNames) %for all subjects
        for cond = 5:6
            [accuracy,Time] = svm_contrast_conditions_perm(SubjectNames{i},condA{cond},condB{cond},param);
            Accuracy(i,:) = accuracy; %store decoding accuracy for all subjects
            save(char(strcat('Results/Mat_DecodingAccuracy/',...
                 SubjectNames{i},'_',condA{cond},'_versus_',condB{cond})),'Accuracy','Time','param');
        end
end
