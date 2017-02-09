function [foundPath, sequence, dirs, partColoredArray]=FindBuildPathATBstack(partXY)
% SEARCHES ALL POSSIBLE BUILD PATHS.  VERY INEFFICIENT
% DON'T USE
% Given a polyomino part, searches for a valid build path described by
% order sequence and move direcions dirs.
% returns foundPath == true if a path is found, false else.
%Initialize a part with yx
% positions Passes the part and start node to Depth_firstsearch function to
% find possible sequence of joining the items The output is then passed to
% CheckPath function to check if the item can join the assembly from
% l,r,u,d direction
%
%Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu, Sep 27, 2016

clc
%clear all

format compact
if nargin <1
    partXY = TestFindBuildPath();
    % partXY=BigPartTry();
    % partXY = [5 3;4 3;4 2;3 2;2 2;1 2];
    
end

% Returned variables
foundPath = false;  % no valid path has been found yet
sequence = [];
dirs = [];

% try all possible start nodes until we get a  path
% that generates the part with no errors

% color the part
IND = sub2ind(max(partXY),partXY(:,1),partXY(:,2));
partAr = zeros(max(partXY));
partAr(IND) = 1;
partColoredArray = labelColor(partAr); %label color to each item in part
dirs2 = ['d';'l';'u';'r'];

count = 0;
m=0;

G.fig = figure(52);clf;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    1,0,0;
    %     0.4,0.4,1
    0,0,1];
colormap(G.colormap);
%G.axis=imagesc(tmpAssembly);
set(gca,'Ydir','reverse');
axis equal
axis([ min(partXY(:,2))-2,max(partXY(:,2))+2,min(partXY(:,1))-2,max(partXY(:,1))+2])

    for k = 1:size(partXY,1)
        x = partXY(k,1);
        y = partXY(k,2);
        clr = partColoredArray(x,y);
        rectangle('Position',[y-1/2,x-1/2,1,1],...
            'FaceColor',G.colormap(clr+2,:),'linewidth',1);

            ht = text(y,x,num2str(k) ,'HorizontalAlignment','center');

        set(ht, 'color','k')
    end
drawnow

while foundPath == false && m< size(partXY,1)
    m=m+1;
    Start = partXY(m,:); %select seed particle
    partialXY = Start;
    restOfParticles = setdiff(partXY,partialXY,'rows') ;
    potentialParticles = findNeighbors(restOfParticles,Start);
    restOfParticles = setdiff(restOfParticles,potentialParticles,'rows') ;
    badNextParticles = [];
    % do a DFS in configration space to build the particle.
    % Q =  each entry is [ particlesAttached, potential_particles,
    % bad_particles to attach, restOfParticles]
    path = [];
    
    cellArrSz = 10;
    Q = cell(cellArrSz,5);
    ptr = 1;
    Q(ptr,:) = {partialXY,potentialParticles,badNextParticles,restOfParticles,path};


    while foundPath == false && ptr > 0
        
        % pop last element from list
        elem = Q(ptr,:);  
        ptr = ptr-1; 
        
        %%%% DEBUGGING CODE
        count = count+1;
        if mod(count, 1000) == 0
            display('m,count,ptr,cellArrSz=')
            partialAssembly;
            display([m,count,ptr,cellArrSz,size(elem{1},1),size(elem{2},1),size(elem{3},1),size(elem{4},1)])
            % m,count,ptr,cellArrSz=[1,1798000,72,100          38           1           1           2]
        end
        %%%% DEBUGGING CODE
        
        partialXY = elem{1};
        % base case:  if size(partXY,1) == size(partialXY,1), we are  done!
        if size(partXY,1) == size(partialXY,1)
            foundPath = true;
            sequence = elem{1};
            dirs = elem{5};
            break;
        end
        %assume adding first particle is not possible, and add to stack
        if size(elem{2},1) > 1
            ptr = ptr+1;
            if ptr > cellArrSz % double size of stack if current stack fills up (this is never called)
                display(cellArrSz);
                cellArrSz = round(2*cellArrSz);
                Q(cellArrSz,:)={[],[],[],[],[]};
            end 
            potentialParticles = elem{2}(2:end,:);
            badNextParticles = [elem{2}(1,:);elem{3}];
            Q(ptr,:) = {partialXY,potentialParticles,badNextParticles,elem{4},elem{5}};
        end
        % try to add the first particle in potentialParticles.
        nextPart = elem{2}(1,:);
        
        %generate a partial assembly
        IND = sub2ind(size(partColoredArray),partialXY(:,1),partialXY(:,2));
        partialAssembly = zeros(size(partColoredArray));
        partialAssembly(IND) = 1;
        for j=1:4
            moveOK = CheckPath1Tile(partialAssembly,nextPart,dirs2(j),partColoredArray);
            if moveOK
                %add the new item to the stack
                potentialParticles = findNeighbors(elem{4},nextPart);
                restOfParticles = setdiff(elem{4},potentialParticles,'rows') ;
                
                if ptr > cellArrSz % double size of stack if current stack fills up
                    display(cellArrSz);
                    cellArrSz = round(2*cellArrSz);
                    Q(cellArrSz,:)={[],[],[],[],[]};
                end
                potentialParticles = union([elem{2}(2:end,:);elem{3}],potentialParticles,'rows');

                    ptr = ptr+1;
                Q(ptr,:) = {[partialXY;nextPart],...
                    potentialParticles,...%[elem{2}(2:end,:);elem{3};potentialParticles],...%
                    [],restOfParticles,[elem{5},dirs2(j)]};

                break
            end %endif
        end %endfor
    end %endwhile
end %end for

            display('m,count,ptr,cellArrSz=')
            display([m,count,ptr,cellArrSz])

G.fig = figure(51);clf;
set(G.fig,'Name',['Colored Part with n = ',num2str(size(partXY,1)),' tiles'])
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    1,0,0;
    %     0.4,0.4,1
    0,0,1];
colormap(G.colormap);
%G.axis=imagesc(tmpAssembly);
set(gca,'Ydir','reverse');
axis equal
axis([ min(partXY(:,2))-2,max(partXY(:,2))+2,min(partXY(:,1))-2,max(partXY(:,1))+2])

if foundPath
    for k = 1:size(partXY,1)
        x = sequence(k,1);
        y = sequence(k,2);
        clr = partColoredArray(x,y);
        rectangle('Position',[y-1/2,x-1/2,1,1],...
            'FaceColor',G.colormap(clr+2,:),'linewidth',1);
        if k > 1
            ht = text(y,x,[num2str(k),textarrow( dirs(k-1) )],'HorizontalAlignment','center');
        else
            ht = text(y,x,num2str(k) ,'HorizontalAlignment','center');
        end
        set(ht, 'color','k')
    end
else
    text(0,0, 'No path found')
end
end

    function dirText = textarrow(dir)
        if dir == 'd'
            dirText = '\downarrow';
        elseif dir == 'u'
            dirText = '\uparrow';
        elseif dir == 'r'
            dirText = '\rightarrow';
        else
            dirText = '\leftarrow';
        end
    end

    function neighbors = findNeighbors(restOfParticles,nextPart)
        % returns all locations in XY grid restOfParticles that are 1 unit away
        % from nextPart
        neighbors = intersect(restOfParticles,repmat(nextPart,4,1) + [-1,0;0,1;1,0;0,-1],'rows');
    end



