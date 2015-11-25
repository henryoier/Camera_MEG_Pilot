function [accuracy,Time] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
% function [accuracy,Time] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
%
% Apply SVM classifier on MEG trials with supervised learning. Uses trial
% subaverages and permutations
%
% Example:
%   %parameters
%   param.brainstorm_db = 'D:\MYPROJECTS11\project_rapid_images_Molly_Carl\Data\HagmannRSVP\data\';
%   param.data_type = 'MEG';
%   param.smooth_size = 15;
%   param.num_permutations = 30;
%   param.trial_bin_size = 5;
%
%
% Author: Dimitrios Pantazis

%initialize
num_permutations = param.num_permutations;
trial_bin_size = param.trial_bin_size;
f_lowpass = param.f_lowpass;
brainstorm_db = param.brainstorm_db;
data_type = param.data_type;

%load data (force equal number of trials per condition)
[trial,Time] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,data_type,f_lowpass);
ntimes = size(trial{1}{1},2);
ntrials = min([length(trial{1}) length(trial{2})]);
nchannels = size(trial{1}{1},1);

%re-reference:average channel (only for EEG)
if strfind(data_type,'EEG')
    channelfile = [brainstorm_db subject '/@default_study/channel_vectorview306.mat'];
    load(channelfile)
    ndx = find_channels(Channel,'EEG');
    for i = 1:2 %for both groups
        for j = 1:ntrials
            trial{i}{j}(ndx,:) = trial{i}{j}(ndx,:) - repmat(mean(trial{i}{j}(ndx,:)),length(ndx),1);
        end
    end
end

%correct for baseline std
tndx = Time<0;
for i = 1:2 %for both groups
    for j = 1:ntrials
        trial{i}{j} = trial{i}{j} ./ repmat( std(trial{i}{j}(:,tndx)')',1,ntimes );
    end
end

%get labels for train and test groups
nsamples = floor(ntrials/trial_bin_size);
samples = reshape([1:nsamples*trial_bin_size],trial_bin_size,nsamples)';
train_label = [ones(1,nsamples-1) 2*ones(1,nsamples-1)];
test_label = [1 2];

%perform decoding
%matlabpool(2);
Accuracy = zeros(num_permutations,ntimes);
train_trialsA = zeros(nsamples-1,nchannels,ntimes);
train_trialsB = zeros(nsamples-1,nchannels,ntimes);
for p = 1:num_permutations
    
    if ~rem(p,10)
        disp(['p = ' num2str(p)]);
    end

    %randomize samples
    perm_ndx = randperm(nsamples*trial_bin_size);
    perm_samples = perm_ndx(samples);
    
    %create samples
    train_trialsA = average_structure2(trial{1}(perm_samples(1:nsamples-1,:)));
    train_trialsB = average_structure2(trial{2}(perm_samples(1:nsamples-1,:)));
    train_trials = [train_trialsA;train_trialsB];
    
    test_trialsA = average_structure(trial{1}(perm_samples(end,:)));
    test_trialsB = average_structure(trial{2}(perm_samples(end,:)));
    test_trials = reshape([test_trialsA test_trialsB],[nchannels,ntimes,2]);
    test_trials = permute(test_trials,[3 1 2]);
    
    for tndx = 1:ntimes
        
        %model = svmtrain(train_trials(:,:,tndx), train_label','method','LS');
        %group = svmclassify(model,test_trials(:,:,tndx));
        
        
        %accuracy = sum([test_label - group']==0)/2 * 100;
        %Accuracy(p,tndx) = accuracy;
        
        model = svmtrain(train_label',train_trials(:,:,tndx),'-s 0 -t 0 -q');
        [predicted_label, accuracy, decision_values] = svmpredict(test_label', test_trials(:,:,tndx), model);
        Accuracy(p,tndx) = accuracy(1);
    end

end
%matlabpool close

%save and plot results
accuracy = mean(Accuracy,1);
