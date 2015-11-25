function [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataA,dataB,nResample,alpha,tail,PermMatrix)
% function [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(dataA,dataB,nResample,alpha,tail,PermMatrix)
%
% Performs permutations between conditions A and B and finds thresholds 
% that control for false positives. Conditions A and B are assumed unpaired, 
% and therefore can have different number of trials (observations)
%
% The statistic used is an unpaired t-test. 
%
% nResample (typically 1000) permutation samples are created by
% randomly exchanging conditions A and B. t-statistic maps 
% are created for the permuted data similarly to the original data.
%
% For the permutation threshold, we use the maximum statistic approach. 
% The maximum t-statistic over variables is calculated for each
% permutation sample. This results in nResample maximum statistic values 
% (returned in the variable Perm.MaxStatistic), which are then used to build
% an empirical histogram of the maximum statistic. The value that leaves alpha
% percent of the histogram on the right side is the threshold which is applied
% to the original statistical map, to produce Perm.StatMapTh.
%
% For the False Discovery Rate (FDR) procedure, the same permutation
% samples are used to estimate the local distribution of each variable
% in the StatMap. Using this distribution, we convert the
% t-statistics into p-values, returned in the StatMapPv matrix. The FDR
% procedure is applied to the p-value map to estimate a threshold
% FDR.Threshold, which is applied to the data.
%
% One-tail or two-tail tests can be used. The difference is that in the
% latter case the absolute value of the t-statistics is used for all
% calculations. The one-tail test has as alternative hypothesis condition
% A > condition B.
%
% The t-statistics are estimated by calculating the standard deviation
% separately for each variable using the multiple observations.
% Therefore, it the data consist of too few observations
% (less than 10), this function is not suitable. For example, if the
% data are provided as a single averaged trial, this function cannot be
% used. 
%
% For more information of the permutation approach, see: Pantazis et al.
% "A comparison of random field theory and permutation methods for the 
% statistical analysis of MEG data", Neuroimage 25(2):383-394 
%
% INPUTS:
%   dataA              Matrix with dimensions nObservations x nVariables. For example, measuring 100 trials from 10 electrodes will have nObservations = 100, nVariables = 10.
%   dataB              Same as above, for condition B. It is assumed that A and B are paired measurements, so condition A row 1 corresponds to condition B row 1 etc.
%   nResample          (default 1000) Number of permutation samples 
%   alpha              (default 0.05) Control level of false positives
%   tail               (default 'twotail' String with values 'onetail' or 'twotail'. Defines whether to use one-tail (A>B) or two-tail test.
%                      For the two-tail test, abs(t-statistic) is used.
%   PermMatrix         (optional) Structure in the form PermMatrix{nResample} = [nTrialsA+nTrialsB x 1] containing random assignments of data in conditions A and B.
%
% OUTPUTS:
%   StatMap            Vector (nVariables x 1) of the t-statistic map
%   StatMapPv          Vector (nVariables x 1) of the uncorrected p-values
%   Perm.Threshold     Permutation threshold (in t-test units)
%       .StatMapTh     Thresholded statistical map
%       .MaxStatistic  Vector (nResample x 1) of the maximum statistic for each permutation sample
%   FDR.Threshold      False Discovery Rate threshold (in pvalue units)
%   FDR.StatMapTh      Thresholded statistical map
%   PermMatrix         Permutations used to create thresholds 
%
% EXAMPLE:
%   
%   nResample = 100;
%   alpha = 0.05;
%   tail = 'twotail';
%   dataA = rand(200,10); %null data, 100 trials, 10 electrodes
%   dataB = rand(100,10);
%   [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_unpaired(dataA,dataB,nResample,alpha,tail);
%
% Author: Dimitrios Pantazis, March 2014

%initialize
nTrialsA = length(dataA);
nTrialsB = length(dataB);
if ~exist('nResample')  
    nResample = 1000;  
end
if ~exist('alpha','var')
    alpha = 0.05;
end
if ~exist('tail') || strcmp(tail,'twotail') %if two tail t-test
    func = 'abs';
else %if one tail t-test
    func = '';
end
%Create PermMatrix (1: keep original, -1: exchange group A and group B)
if ~exist('PermMatrix')
    for i=1:nResample
        PermMatrix{i} = randperm(nTrialsA+nTrialsB);
    end
end
PermMatrix{1} = 1:(nTrialsA+nTrialsB); %make sure first sample is the original data
MaxS = zeros(nResample,1); %maximum statistic in space and time

%statistic of original data
M = mean(dataA) - mean(dataB);
VarA = var(dataA);
VarB = var(dataB);
Std = sqrt( VarA/nTrialsA + VarB/nTrialsB );
StatMap = M./Std;

%combine data
dataAB = [dataB; dataA];
clear dataB dataA;

%maximum of original data (to be included in the permutation samples)
eval(['MaxS(1) = max(' func '(StatMap(:)));'])
StatMapPv = ones(size(StatMap)); % statistic map of pvalues

for i = 2:nResample %for all permutation samples

    %permute A and B
    dataA_perm = dataAB(PermMatrix{i}(1:nTrialsA),:);
    dataB_perm = dataAB(PermMatrix{i}(1+nTrialsA:nTrialsA + nTrialsB),:);

    %compute unpaired t statistic
    M = mean(dataA_perm) - mean(dataB_perm);
    VarA = var(dataA_perm);
    VarB = var(dataB_perm);
    Std = sqrt( VarA/nTrialsA + VarB/nTrialsB );
    StatPerm = M./Std;

    %Pvalues for each source (number of counts for now)
    eval(['StatMapPv = StatMapPv + (' func '(StatPerm) >= ' func '(StatMap));']);

    %maximum of permutation
    MaxS(i) = eval(['max(' func '(StatPerm))']);
    
end

%Fix Pvalues
StatMapPv = StatMapPv / nResample;

%FDR threshold
pv = sort(StatMapPv(:)); %sorted pvalues
N = length(pv); %number of tests
l = (1:N)'/N * alpha; %FDR line
%plot(pv);hold on;plot(l);
crossings = find( pv>l == 0); 
if ~isempty(crossings) %if the two lines cross
    FDR.Threshold = l(max(find( pv>l == 0))); %highest crossing point
else
    FDR.Threshold = 0;
end

%Permutation threshold
Perm.MaxStatistic = sort(MaxS);
Perm.Threshold = Perm.MaxStatistic(floor(nResample*(1-alpha)+1));

%Find significant activation
eval([ 'exceedTh = ' func '(StatMap) > Perm.Threshold;' ]);
Perm.StatMapTh = exceedTh .* StatMap;
eval([ 'exceedTh = ' func '(StatMapPv) <= FDR.Threshold;' ]);
FDR.StatMapTh = exceedTh .* StatMap;






