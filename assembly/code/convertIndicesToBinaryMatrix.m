function partAr = convertIndicesToBinaryMatrix(partXY)
IND = sub2ind(max(partXY),partXY(:,1),partXY(:,2));
partAr = zeros(max(partXY));
partAr(IND) = 1;