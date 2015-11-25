function [SignificantTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_2sample(data1,data2, nperm, cluster_th, significance_th,StatMapPermPV)
% function [SignificantTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_2sample(data1,data2, nperm, cluster_th, significance_th,StatMapPermPV)
%
% Performs *one-sided* (data1>data2) cluster-size test on data1 vs data2 values. 
%
% Author: Dimitrios Pantazis


ComputerCluster = 0;
if ComputerCluster
    matlabpool(5);
end

%if pvalues have not been precomputed
if ~exist('StatMapPermPV')

    %initialize
    [nsamples1 ntimes] = size(data1);
    [nsamples2 ntimes] = size(data2);
    StatMapPerm = single(zeros(nperm,ntimes));
    
    %first permutation sample is original data
    M = mean(data1,1) - mean(data2,1);
    var1 = var(data1);
    var2 = var(data2);
    Std = sqrt( var1/nsamples1 + var2/nsamples2 );
    StatMapPerm(1,:) = M./Std;
    
    %combine data
    data12 = [data1 ; data2];
    clear data1 data2;
    
    %perform permutations
    parfor i = 2:nperm
        if ~rem(i,1000)
            disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
        end
        permndx = randperm(nsamples1 + nsamples2);
        data1_perm = data12(permndx(1:nsamples1),:);
        data2_perm = data12(permndx(1 + nsamples1:nsamples1 + nsamples2),:);
        
        %compute unpaired t-statistic
        M = mean(data1_perm,1) - mean(data2_perm,1);
        var1 = var(data1_perm);
        var2 = var(data2_perm);
        Std = sqrt( var1/nsamples1 + var2/nsamples2 );
        StatMapPerm(i,:) = M./Std;
    end
    %convert to pvalues
    StatMapPermPV = (nperm+1 - tiedrank(StatMapPerm))/nperm;
    
end

%find maximum statistic (cluster size)
[clustermax(1),nclusters,clusters,clustersize] = find_clusters_alld(StatMapPermPV(1,:)<=cluster_th,cluster_th);
parfor i = 2:nperm
    if ~rem(i,1000)
        disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
    end
    [clustermax(i)] = find_clusters_alld(StatMapPermPV(i,:)<=cluster_th,cluster_th);
end
    
clustermax_sorted = sort(clustermax);
th = clustermax_sorted(nperm*(1-significance_th));

SignificantTimes = [clusters{clustersize>th}];

if ComputerCluster
    matlabpool close
end




