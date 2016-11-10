function [hopper] = hopper_ml(tileColor, numCopies,cols,pos)

%This function defines hopper

obs = 3;

if nargin<1
   tileColor = 1;
   numCopies = 10; 
   cols = 4;
end



%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%
rows = ceil(numCopies/cols);
hopper = obs*ones(rows+2,cols+4) ; % build boundary for hopper
hopper(2:1+rows,2:1+cols) = tileColor; %fillhopper with components
hopper(2:end,end-1) = 0; % build output shoot for hopper
hopper(2,end-2) = 0; %connect output shoot to tiles
hopper(end-1,2:cols-mod(numCopies,cols)+1) = 0;
%  replace some tiles with 0s to match numCopies    


if pos>1
   n = pos - 1; 
   for i=1:n
       [r, c] = size(hopper);
       tmp_hopper = obs*ones(r+4,c+4) ; %define new hopper
       tmp_hopper(3:end-2,3:end-2) = hopper; %fillhopper with prev hopper
       tmp_hopper(2:end,end-1) = 0; % build output shoot for hopper
       tmp_hopper(2,2:end-1) = 0; %connect top shoot to tiles
       tmp_hopper(2:end-1,2) = 0; %connect left shoot to tiles
       tmp_hopper(end-1,2:end-2) = 0; %connect bottom shoot to tiles       
       
       hopper = tmp_hopper;
       clear tmp_hopper;
   end
   
end

end
%%%%%%%%%%%%define a hopper%%%%%%%%%%%%%