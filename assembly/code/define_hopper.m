function [hopper] = define_hopper(tileColor, numCopies,cols)
% TODO: comments, maybe add input cols,  then use the matlab commands
% commented out below
%This function defines hopper

obs = 9;

if nargin<1
   tileColor = 1;
   numCopies = 10; 
end



%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
% rows = ceil(numCopies/cols);
%  hopper = obs*ones(rows+2,cols+4) ; % build boundary for hopper
%  hopper(2:1+rows,2:1+cols) = tileColor %fillhopper with components
% hopper(2:end,end-1) = 0 % build output shoot for hopper
% hopper(2,end-2) = 0 %connect output shoot to tiles
%  replace some tiels with 0s to match numCopies

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

hopper = vertcat(ones(1,4)*obs,zeros(1,4),hopper,ones(1,4)*obs);
hopper = horzcat(ones(size(hopper,1),1)*obs,hopper,ones(size(hopper,1),1)*obs,zeros(size(hopper,1),1)...
    ,ones(size(hopper,1),1)*obs);
hopper(1,7) = obs;
hopper(2,6) = 0;
end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%