function [trial,Time] = load_trials(brainstorm_db,subject,conditionA,conditionB,data_type,f_lowpass)
%function trial = load_trials(brainstorm_db,subject,conditionA,conditionB,data_type,smooth_size)
%
% brainstorm_db: brainstorm database
% subject: subject name
% conditionA/B: conditions in brainstorm database, eg: groupA = {'11a' '13a'};
%  (the function forces equal number of trials in each group)
% data_type: 'MEG','GRAD','MAG','EEG', or 'MEG EEG' etc
% f_lowpass: low pass frequency for data filtering

%get channel index (assume common channel structure per subject)
channelfile = [brainstorm_db subject '/@default_study/channel_vectorview306_acc1.mat'];
load(channelfile)

%find proper channels
channel_index = [];
if strfind(data_type,'MEG')
    ndx = find_channels(Channel,'MEG');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'GRAD')
    ndx = find_channels(Channel,'GRAD');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'MAG')
    ndx = find_channels(Channel,'MAG');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'EEG')
    ndx = find_channels(Channel,'EEG');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'MAGr74')
    ndx = find_channels(Channel,'MAG');
    ndx = sort(ndx(randperm(102,74))); %select only 74 sensors randomly
    channel_index = ndx; %do not keep any other values (aka MAG)
end
if strfind(data_type,'GRADr74')
    ndx = find_channels(Channel,'GRAD');
    ndx = sort(ndx(randperm(204,74))); %select only 74 sensors randomly
    channel_index = ndx %do not keep any other values (aka MAG)
end
if strfind(data_type,'GRADr74spaceopt')
    ndx = find_channels(Channel,'GRAD');
    if rand>0.5
        ndx = ndx(1:2:end);
    else
        ndx = ndx(2:2:end);
    end
    ndx = sort(ndx(randperm(102,74))); %select only 74 sensors randomly
    channel_index = ndx; %do not keep any other values (aka MAG)
end
channel_index = unique(channel_index);

%get filenames
n_conditions = length(conditionA);
filesA = [];
filesB = [];
for c = 1:n_conditions
    fA = dir([brainstorm_db subject '/' conditionA{c} '/*trial*.mat']);
    fB = dir([brainstorm_db subject '/' conditionB{c} '/*trial*.mat']);
    n(c) = min([length(fA) length(fB)]); %force number of files to be the same
    for i = 1:n(c)
        fA(i).dir = [brainstorm_db subject '/' conditionA{c} '/'];
        fB(i).dir = [brainstorm_db subject '/' conditionB{c} '/'];
    end
    filesA = [filesA ; fA(1:n(c))];
    filesB = [filesB ; fB(1:n(c))];     
end

%design low pass filter
tempA = load([filesA(1).dir filesA(1).name]);
order = max(100,round(size(tempA.F(channel_index,:),2)/10)); %keep one 10th of the timepoints as model order
Fs = 1000; %hard set sampling frequency 1kHz
h = filter_design('lowpass',f_lowpass,order,Fs,0);

%load data
for f = 1:length(filesA)
    %disp(['Loading file ' num2str(f) ' of ' num2str(length(filesA))]);
    tempA=load([filesA(f).dir filesA(f).name]);
    tempB=load([filesB(f).dir filesB(f).name]);
    trial{1}{f} = filter_apply(tempA.F(channel_index,:),h); %smooth over time
    trial{2}{f} = filter_apply(tempB.F(channel_index,:),h); %smooth over time
end
Time = tempA.Time;




