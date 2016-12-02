clear all
clc

%{
%partXY=[7 6;9 6;6 7;7 7;8 7;9 7;10 7;7 8];
partXY = [5 3;4 3;4 2;3 2;2 2;1 2];

%}

partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
%partXY = [5 3;4 3;3 3;2 3;1 3];
[IsPossible, sequenceXY, dirs, partColoredArray]=FindBuildPath(partXY);

tmpAssembly = partColoredArray;  
G.fig = figure;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])   
G.colormap = [  1,1,1; %Empty = white  
    0,0,0; %obstacle
    hsv(numel(unique(tmpAssembly))-1);];
colormap(G.colormap);
G.axis=imagesc(tmpAssembly); 
axis equal
for k = 1:size(sequenceXY(:,1))
    %s = Seq(k);
    s = k;
    ht = text(sequenceXY(k,2),sequenceXY(k,1),num2str(s));
    set(ht, 'color','k')
end



partXY1 = [4 2;3 2;2 2;1 2];
partXY2 = [5 3;4 3];

[IsPossible, sequenceXY1, dirs, partColoredArray1]=FindBuildPath(partXY1);
[IsPossible, sequenceXY2, dirs, partColoredArray2]=FindBuildPath(partXY2);

tileXY1 = [4 2]; %mention these values when in partColoredArray1, not from partXY1
tileXY2 = [4 3]; %mention these values when in partColoredArray2, not from partXY2


[r1 c1] = size(partColoredArray1);
[r2 c2] = size(partColoredArray2);

dis2 = r2 - tileXY2(1,1);
dis1 = r1 - tileXY1(1,1);

tmppartXY1 = partColoredArray1;
tmppartXY2 = partColoredArray2;

rows_chg1 = 0;
rows_chg2 = 0;
cols_chg1 = 0;
cols_chg2 = 0;


if dis2>dis1 %if part2 is longer at the bottom
   tmppartXY1 = vertcat(tmppartXY1, zeros(dis2-dis1,c1));
    
elseif dis1 > dis2 %if part1 is longer at the bottom
    tmppartXY2 = vertcat(tmpaprtXY2, zeros(dis1-dis2,c2));
end

if tileXY2(1,1) > tileXY1(1,1) %if part2 is longer at the top
   tmppartXY1 = vertcat(zeros(tileXY2-tileXY1,c1), tmppartXY1 );
   rows_chg1 = rows_chg1 + (tileXY2-tileXY1);
   
elseif tileXY1(1,1) > tileXY2(1,1) %if part1 is longer at the top
    tmppartXY2 = vertcat(zeros(tileXY1-tileXY2,c2), tmppartXY2 );
    rows_chg2 = rows_chg2 + (tileXY2-tileXY1);
end


tileXY1(1,1) = tileXY1(1,1) + rows_chg1;
tileXY2(1,1) = tileXY2(1,1) + rows_chg2;

tmppartXY1 = horzcat(tmppartXY1, zeros(size(tmppartXY2,1),size(tmppartXY2,2)));

cnt=0;
for i=1:size(tmppartXY2,1)
    for j=1:size(tmppartXY2,2)
       if tmppartXY2(i,j) ~= 0
           cnt = cnt+1;
            non_zeroXY2(cnt,:) = [i j];  
       end
    end 
end

col_transform = 0;
row_transform = 0;

if tileXY2(1,1) > tileXY1(1,1)
   row_transform = tileXY1(1,1) - tileXY2(1,1) ;
   
elseif tileXY2(1,1) < tileXY1(1,1)
   row_transform = tileXY1(1,1) - tileXY2(1,1);
end

if tileXY2(1,2) > tileXY1(1,2)
   col_transform = tileXY1(1,2) - tileXY2(1,2) ;
   
elseif tileXY2(1,2) < tileXY1(1,2)
   col_transform = tileXY1(1,2) - tileXY2(1,2);
end

col_transform = col_transform + 1;

for i=1:size(non_zeroXY2,1)
   tmppartXY1(non_zeroXY2(i,1)+row_transform, non_zeroXY2(i,2)+ col_transform) = ...
       tmppartXY2(non_zeroXY2(i,1),non_zeroXY2(i,2));
end


%%%%%%%%%%%plotting PartXY1%%%%%%%%%%%%%%%%%
tmpAssembly1 = partColoredArray1;  
G.fig = figure;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY1,1)),' tiles'])   
G.colormap = [  1,1,1; %Empty = white  
    0,0,0; %obstacle
    hsv(numel(unique(tmpAssembly1))-1);];
colormap(G.colormap);
G.axis=imagesc(tmpAssembly1); 
axis equal
for k = 1:size(sequenceXY1(:,1))
    %s = Seq(k);
    s = k;
    ht = text(sequenceXY1(k,2),sequenceXY1(k,1),num2str(s));
    set(ht, 'color','k')
end

%%%%%%%%%%%%%Plotting PartXY2%%%%%%%%%%%%%%
tmpAssembly2 = partColoredArray2;  
G.fig = figure;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY2,1)),' tiles'])   
G.colormap = [  1,1,1; %Empty = white  
    0,0,0; %obstacle
    hsv(numel(unique(tmpAssembly2))-1);];
colormap(G.colormap);
G.axis=imagesc(tmpAssembly2); 
axis equal
for k = 1:size(sequenceXY2(:,1))
    %s = Seq(k);
    s = k;
    ht = text(sequenceXY2(k,2),sequenceXY2(k,1),num2str(s));
    set(ht, 'color','k')
end

%%%%%%%%%%%plotting Combined PartXY1 + PartXY2%%%%%%%%%%%
tmpAssembly2 = tmppartXY1;  
G.fig = figure;
%set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY1partXY2,1)),' tiles'])   
G.colormap = [  1,1,1; %Empty = white  
    0,0,0; %obstacle
    hsv(numel(unique(tmpAssembly2))-1);];
colormap(G.colormap);
G.axis=imagesc(tmpAssembly2); 
axis equal
% for k = 1:size(sequenceXY2(:,1))
%     %s = Seq(k);
%     s = k;
%     ht = text(sequenceXY2(k,2),sequenceXY2(k,1),num2str(s));
%     set(ht, 'color','k')
% end




