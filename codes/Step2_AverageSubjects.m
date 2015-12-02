% Average subjects in different conditions

clear all;

Key_word = {{'t1'},{'Red'},{'Easy'}};

Mat_location = '/dataslow/sheng/Camera/Results/Mat_DecodingAccuracy/';

for i=1:3
    AccuracyAll = zeros(1,2301);
    Files = dir(char(strcat(Mat_location,'*',Key_word{i},'*.mat')));
    for j=1:length(Files)
        load([Mat_location Files(j).name]);
        AccuracyAll = AccuracyAll + Accuracy;
    end
    AccuracyAll = AccuracyAll / 4;
    Accuracy = AccuracyAll;
    save([Mat_location '2Camera06_07_' char(Key_word{i}) '.mat'],'Accuracy','Time','param');
end