% function RStep3A_plot_ii(RhythmMode)
% % plot decoding accuracy

% cd C:\Users\Mingtong\OneDrive\Mingtong\RhythmClassifier
clear;clc; close all;
addpath(genpath('Functions'));
ProjectName = 'camera';   %%%%%
RhythmMode = 'evoked'; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all' 'scouts'
iitt = 'iitt';

flag_save = 1;
flag_all = 1;
flag_weight = 0;
flag_weight_movie = 0;
flag_diff = 0;
flag_Cardinal = 0;
flag_CO = 0;

in_time = [210:30:901];
flag_smooth = 1;
smooth_vector = ones(1,50)/50;
% x = rand(1,100);xsm = conv(x,ones(1,10)/10,'same');figure;hold on;plot(x);plot(xsm,'r')
stimulate_end_time = 0.8;

YMIN = 20; YMAX = 100; YMIN_CO = -25; YMAX_CO = 40;
%for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; YMIN = 20; YMAX = 100; YMIN_CO = -50; YMAX_CO = 60;
    
%% load file
load('/dataslow/sheng/Camera/Results/Mat_DecodingAccuracy/Camera_06_Hard_versus_Easy.mat');

%% mean of all conditions
jpg_file_name = 'Results/Fig_DecodingAccuracy/Camera_06_Hard_versus_Easy';
clear Data;
Data{1}.mean = Accuracy;
Data{1}.color = 'k';
title_text = ['Camera 06 Hard versus Easy'];
h = RStep3Z_subfunction_plot(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);

[max_accuracy, max_index] = max(Data{1}.mean);
display([ 'AccyAll_max: ' num2str(max_accuracy,3) '% , ' num2str(max_index+min(Time)*1000) 'ms' ]);

if (flag_save)
    %         saveas(h_AccyAll,[jpg_file_name 'AccyAll__' num2str(max_accuracy,3) '%_' num2str(max_index+min(Time)*1000) 'ms.tiff'])
    print(h,[jpg_file_name 'AccyAll__' num2str(max_accuracy,3) '%_' num2str(max_index+min(Time)*1000) 'ms.jpg'],'-djpeg','-r0');
    %close(h);
end
        


