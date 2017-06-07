function [partXY_new2] = SortPartXY(partXY)
%This function sorts the partXY array on the basis of the neighbors of each
%tile. Tiles with one neighbor are on the top and the ones with four
%neighbors are at the end
if nargin<1
%    partXY = [5 3;4 3;4 2;3 2;2 2;1 2]; 
%  partXY=[5 11;7 8;8 8;8 7;8 6;7 6;6 6;5 6;4 6;4 7;4 8;4 9;5 9;5 10;6 10;6 11;5 12;6 12;5 13;5 14;5 15;4 15;3 15;2 15;2 14;2 13;3 13];
% partXY =[6 11;4 8;3 8;3 7;3 6;4 6;5 6;6 6;7 6;7 7;7 8;7 9;6 9;6 10;6 12;6 13;6 14;6 15;7 15;8 15;9 15;9 14;9 13;8 13;5 10;5 11;5 12];
 partXY=[6 10;8 8;9 8;9 7;9 6;8 6;7 6;6 6;6 7;6 8;6 9;5 9;5 10;5 11;6 11;6 12;7 13;7 14;7 15;6 15;5 15;4 15;3 15;3 14;3 13;4 13;7 12];
end

partXY_new = [0 0];
one_n = [0 0];
two_n = [0 0];
three_n = [0 0];
four_n = [0 0];

for i=1:size(partXY(:,1),1)
%for i=2:2
   right = [partXY(i,1) partXY(i,2)+1];   % Find right,left,down and up neighbors for each tile
   left = [partXY(i,1) partXY(i,2)-1];
   up = [partXY(i,1)-1 partXY(i,2)];
   down = [partXY(i,1)+1 partXY(i,2)];
   
   neighbors = 0;
   for j=1:size(partXY(:,1),1)
       if right(1,1)==partXY(j,1)
           if right(1,2)==partXY(j,2)
               neighbors = neighbors+1;
           end
       end
       
       if left(1,1)==partXY(j,1)
           if left(1,2)==partXY(j,2)
               neighbors = neighbors+1;
           end
       end
       
       if up(1,1)==partXY(j,1)
           if up(1,2)==partXY(j,2)
               neighbors = neighbors+1;
           end
       end
       
       if down(1,1)==partXY(j,1)
           if down(1,2)==partXY(j,2)
               neighbors = neighbors+1;
           end
       end
   end
   
   if neighbors == 1
      one_n = vertcat(one_n, partXY(i,:));    %Make arrays of tiles with one neighbor, two neighbor and so on
   end
   if neighbors == 2
      two_n = vertcat(two_n, partXY(i,:)); 
   end
   if neighbors == 3
      three_n = vertcat(three_n, partXY(i,:)); 
   end
   if neighbors == 4
      four_n = vertcat(four_n, partXY(i,:)); 
   end
end

if size(one_n(:,1),1) > 1                                   %In the end concatenate the neigbor arrays in the order: One-neighbor, two neighbor, three neighbor
   partXY_new = vertcat(partXY_new,one_n(2:end,:)); 
end
if size(two_n(:,1),1) > 1
   partXY_new = vertcat(partXY_new,two_n(2:end,:)); 
end
if size(three_n(:,1),1) > 1
   partXY_new = vertcat(partXY_new,three_n(2:end,:)); 
end
if size(four_n(:,1),1) > 1
   partXY_new = vertcat(partXY_new,four_n(2:end,:)); 
end

partXY_new2 = partXY_new(2:end,:); %Sorted array
% display('Sorted');
end