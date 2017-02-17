function [d] = mould(partXY, tileXY)

%clear all
%clc



if nargin < 1
   tileXY = [1 3];
   partXY=[2 2;2 3;2 4]; 
end

partXYt = [partXY;tileXY];
part_length = abs(max(partXYt(:,2) - min(partXYt(:,2))))+1; %length of part
part_width = abs(max(partXYt(:,1)) - min(partXYt(:,1)))+1; %width of part

min_col = min(partXYt(:,2));
max_row = max(partXYt(:,1));
d = 10000*ones(part_width,1);
cnt = 1;
for i=max(partXYt(:,1)):-1:min(partXYt(:,1))
    for j=1:size(partXYt(:,1))
        if partXYt(j,1) == i
           %if partXYt(j,2) ~= min_col
              t =  partXYt(j,2) - min_col;
              if t< d(cnt,1)
                 d(cnt,1) = t; 
              end
           %end
        end    
    end
    cnt = cnt + 1;
end
end