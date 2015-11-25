% SVM Decoding

%change the current directory to the project
%cd \dataslow\sheng\example codes\project_classifiers_exam

%initialize
clear all;
addpath(genpath('Functions'));
disp(pwd);
nSubjects = 1;

SubjectNames = {'Camera_06'}; %for more subjects use SubjectNames = {'Subject01' 'Subject02'}; etc

%parameters
param.brainstorm_db = [pwd '/brainstorm_db/camera/data/']; %directory of 'data' folder
param.data_type = 'MEG';
param.f_lowpass = 30;
param.num_permutations = 100;
param.trial_bin_size = 27;

condA = {'Session1_All_t1'}; %use brackets to support multiple conditions, say condA = {'faces','houses'};
condB = {'Session1_All_t2'};

%Run SVM analysis
for i = 1:length(SubjectNames) %for all subjects

    [accuracy,Time] = svm_contrast_conditions_perm(SubjectNames{i},condA,condB,param);
    Accuracy(i,:) = accuracy; %store decoding accuracy for all subjects
end
save('Results/Accuracy','Accuracy','Time','param');

%plot results
load('Results/Accuracy')
figure; 
plot(Time, mean(Accuracy,1));
set(gca,'fontsize',12);
ylabel('Accuracy (%)','fontsize',14)
xlabel('Time (sec)','fontsize',14)
print(gcf,['Results/AverageAccuracy.png'],'-dpng','-r300');