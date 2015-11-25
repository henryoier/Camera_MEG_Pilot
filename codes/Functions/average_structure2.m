function Ave = average_structure2(Struct)
%function Ave = average_structure2(Struct)
%  Average structured arrays
%
% Author: Dimitrios Pantazis

Ave = zeros([size(Struct,1) size(Struct{1})]);
for i = 1:size(Struct,1)
    for j = 1:size(Struct,2)
        Ave(i,:,:) = squeeze(Ave(i,:,:)) + Struct{i,j};
    end
end
Ave = Ave/size(Struct,2);    
    






