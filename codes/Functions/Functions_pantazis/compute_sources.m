function sFiles = compute_sources(sFiles,sensortypes)
% function sFiles = compute_sources(sFiles,sensortypes)
%
% sensortypes can be: 'MEG, MEG MAG, MEG GRAD, EEG'
%

% Process: Compute sources
sFiles = bst_process(...
    'CallProcess', 'process_inverse', ...
    sFiles, [], ...
    'comment', '', ...
    'method', 1, ...  % Minimum norm estimates (wMNE)
    'wmne', struct(...
         'NoiseCov', [], ...
         'InverseMethod', 'wmne', ...
         'ChannelTypes', {{}}, ...
         'SNR', 3, ...
         'diagnoise', 0, ...
         'SourceOrient', {{'fixed'}}, ...
         'loose', 0.2, ...
         'depth', 1, ...
         'weightexp', 0.5, ...
         'weightlimit', 10, ...
         'regnoise', 1, ...
         'magreg', 0.1, ...
         'gradreg', 0.1, ...
         'eegreg', 0.1, ...
         'ecogreg', 0.1, ...
         'seegreg', 0.1, ...
         'fMRI', [], ...
         'fMRIthresh', [], ...
         'fMRIoff', 0.1, ...
         'pca', 1), ...
    'sensortypes', sensortypes, ...
    'output', 1);  % Kernel only: shared
