function trial_rhythm = trial2trial_g(trial_raw,Time,OPTIONS,RhythmMode)

% trial{conditions}{trials}{nchannels*times}
% % for example
% clear
% load temp1.mat;
% RhythmMode = 'gamma';

n_trials = length(trial_raw{1});

baseline_range = 1:numel(find(Time<0));

for i_trial = 1:n_trials
    if rem(i_trial,10)==1
        disp(['Time-Frequency transform: ' num2str(i_trial) ' / ' num2str(n_trials)]);
    end
    
    for i_cond = 1:length(trial_raw)
        trial_rhythm{i_cond}{i_trial} = grating_timefreq(trial_raw{i_cond}{i_trial}, Time, OPTIONS, RhythmMode);
        trial_rhythm{i_cond}{i_trial} = single(trial_rhythm{i_cond}{i_trial});
    end
end
end

