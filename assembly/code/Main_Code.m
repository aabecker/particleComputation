function []=Main_Code()
%%Main part code.
% Initialize a part with yx positions
% Passes the part and start node to Depth_firstsearch function to find 
% possible sequence of joining the items
% The output is then passed to CheckPath function 
% to check if the item can join the assembly from l,r,u,d direction
% Authors: Sheryl Manzoor and Aaron T. Becker, Sep 27, 2016



clc

% part = [1 2 3;2 2 3;3 2 3;4 3 3;5 3 3;4 2 3]; %contains the item positions for the Part
% part=[7 6;
%       9 6;
%       6 7;
%       7 7;
%       8 7;
%       9 7;
%       10 7;
%       7 8;
%       9 8;
%       6 9;
%       7 9;
%       8 9;
%       9 9;
%       10 9;
%       7 10;
%       9 10];
 
part=[4 2;
      5 2; % Spiral part inner node [5 5]
      6 2
      7 2;
      8 2;
      8 3;
      8 4;
      8 5;
      8 6;
      8 7;
      7 7;
      6 7;
      5 7;
      4 7;
      4 3;
      4 4;
      4 5;
      5 5];
      
start = [5 5];  

[output,seq,tmp_part] = Depth_firstsearch(part,start); %depth first search on part
partColored = labelColor(tmp_part(:,:,1)); %label color to each item in part
partialAssembly = zeros(size(tmp_part(:,:,1),1),size(tmp_part(:,:,1),2));
partialAssembly(output(1,1),output(1,2)) = 1;

dirs_final=size(part)-1; %Array saves the directions of the items
dirs2 = ['l';'r';'u';'d'];
for i=2:size(output,1)
    for j=1:4
        move = CheckPath(partialAssembly,output(i,:),dirs2(j,:),partColored);
        if strcmp(move,'true')
           partialAssembly(output(i,1),output(i,2)) = 1;
           dirs_final(i-1,:) = dirs2(j,:);
           break;
        end
    end
    if strcmp(move,'false')
        break;
    end

end

figure
h = plot(output(:,2),-output(:,1),'s');
set(h, 'markersize', 30,'MarkerFaceColor','b')
for k = 1:i
    s = seq(k);
    ht = text(output(k,2),-output(k,1),num2str(s));
    set(ht, 'color','w')
end
axis([0,10,-15,0])
axis equal


tmpAssembly = flipud(partialAssembly.*partColored);  
G.fig = figure;
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    hsv(numel(unique(tmpAssembly))-1);];
colormap(G.colormap);
G.axis=imagesc(tmpAssembly);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off','color',0.8*[1,1,1]);
%set(G.axis,'edgealpha',.08)
axis equal

