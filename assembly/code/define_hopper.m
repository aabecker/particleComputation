function [hopper] = define_hopper(tileColor, numCopies)

%This function defines hopper


if nargin<1
   tileColor = 1;
   numCopies = 10; 
end



%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
rows = ceil(numCopies/4);
hopper = zeros(rows,4);
cnt_numCopies = 0;
for i=1:rows
   for j=1:4
       if cnt_numCopies < numCopies
            hopper(i,j)= tileColor; 
            cnt_numCopies = cnt_numCopies + 1;
       end
   end
end

hopper = vertcat(ones(1,4)*3,zeros(1,4),hopper,ones(1,4)*3);
hopper = horzcat(ones(size(hopper,1),1)*3,hopper,ones(size(hopper,1),1)*3,zeros(size(hopper,1),1)...
    ,ones(size(hopper,1),1)*3);
hopper(1,7) = 3;
hopper(2,6) = 0;
end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%