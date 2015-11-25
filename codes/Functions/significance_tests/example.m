

%simulate data
Data = randn(14,300)+51; %random decoding results (50% accuracy) (subjects x time)
Data1 = randn(14,300)+61; %decoding results, condition 1
Data2 = randn(14,300)+60; %decoding results, condition 2

%perform cluster size tests
nperm = 1000;
cluster_th = 0.01;
significance_th = 0.01;
[SignificantTimes, clusters,clustersize,StatMapPermpv] = permutation_cluster_1sample(Data-50, nperm, cluster_th, significance_th); %test against 50
[SignificantTimes, clusters,clustersize,StatMapPermpv] = permutation_cluster_2sample(Data1, Data2, nperm, cluster_th, significance_th);

%perform max statistic tests
nResample = 1100;
alpha = 0.001;
tail = 'twotail';
[StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_1sample(Data-50,nResample,alpha,tail); %test against 50
[StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_2sample(Data.between,Data.within,nResample,alpha,tail);

%Results:
Perm.StatMapTh
FDR.StatMapTh

