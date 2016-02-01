function collectingByPairwiseCombinationv2map
% Key difference:  this does not store the data as a binary string
% hopefully this will be easier to develop with.
%
%  I implemented picking the first two, picking the furthest two
%
%  collectingByPairwiseCombination.m:
% pick two robots, A and B.
% pA = position (A), pB = position(B)
% use BFS to find moveSeq that moves robot A to pB
% apply moveSeq to all the robots.
% if robots A and B do not overlap return to step 2
% if all robots overlap (are at one position) end
% else, return to step 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global G MAKE_MOVIE
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = false;
G.fig = figure(1);
G.mapnum = 13;
G.alg = 10;  %BFS is 10
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name','SwarmCollection','color',[1,1,1]); %#ok<UNRCH>
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end

[G.obstacle_pos,G.free,G.robvec,G.Moves,G.ri,G.ci] = SetupWorld(G.mapnum);

G.movecount = 0;

figure(1)
clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.5,1,0.5; %robot
    ];

im = G.obstacle_pos;
im(G.free) = 2*G.robvec;
if numel(unique(im))<3
    colormap(G.colormap(2:end,:));
else
    colormap(G.colormap);
end
G.axis=imagesc(im);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','on');

%set(G.axis,'edgealpha',.08)
axis equal
axis tight
updateTitle()
hold on
%
tic
G.pairwisePath = [];
cRobVec = G.robvec;
while sum(cRobVec)>1
    [cRobVec, pathSeg] =  pairwiseCombine(cRobVec);
    G.pairwisePath  = [G.pairwisePath,pathSeg];
end
shortpath = G.pairwisePath;
display('KEY: l,r,u,d = 1,2,3,4')
display(['(',num2str(length(shortpath)),' steps): ',num2str(shortpath)])
%idea: we will save files as Map##Alg##Sec##Nodes######.mat
save(['Map',num2str(G.mapnum,'%03d'),'Alg',num2str(G.alg,'%03d'),'Sec',num2str(round(toc),'%06d'),'Path',num2str(numel(shortpath),'%03d'),'.mat'], 'shortpath','G');

toc  % simple map took 14.351126 seconds
figure(1)

    function [cRobVec, pathSeg] = pairwiseCombine(cRobVec)
        % 1. pick two robots, A and B.  How about the first ones?
        [pA,pB] = choosepApB(cRobVec, G.obstacle_pos,G.ri,G.ci);
        pathSeg = [];
        while pA ~= pB %  if robots A and B do not overlap try again
            % 3. use BFS to find moveSeq that moves robot A to pB
            map_dist =BFSdistmap(G.obstacle_pos, G.ri(pA),G.ci(pA));
            moveSeq  = BFSshortestRoute(map_dist,G.ri(pB),G.ci(pB));
            %display([pA,pB]); plot(G.ci(pA),G.ri(pA),'bo',G.ci(pB),G.ri(pB),'ro')
            % 4. apply moveSeq to all the robots.
            for mvIn =1:numel(moveSeq)
                cRobVec = applyMove(moveSeq(mvIn), cRobVec);
            end
            pathSeg = [pathSeg, moveSeq]; %#ok<AGROW>
            % 5. calculate the new positions of robot A and robot B.
            VecA = zeros(size(cRobVec)); VecA(pA) = 1;
            VecB = zeros(size(cRobVec)); VecB(pB) = 1;
            
            for mvIn =1:numel(moveSeq)
                VecA = applyMove(moveSeq(mvIn), VecA);
                VecB = applyMove(moveSeq(mvIn), VecB);
            end
            pA = find(VecA == 1,1,'first');
            pB = find(VecB == 1,1,'first');
        end
    end

    function moveSeq  = BFSshortestRoute(map_dist,r_start, c_start)
        % returns an array giving the shortest distanct from [r_start,
        % c_start] to the location with distance 0 on the map map_dist
        %display('KEY: l,r,u,d = 1,2,3,4')
        r = r_start;
        c = c_start;
        d = map_dist(r, c);
        plen = d;
        moveSeq = zeros(1,map_dist(r, c));
        rOffsets = [0,0,1,-1]; %move l,r,u,d 
        cOffsets = [-1,1,0,0]; %move l,r,u,d 
        for i = 1:plen
            d = map_dist(r, c);
            for j = 1:4
                if map_dist(r+rOffsets(j), c+cOffsets(j)) == d - 1;
                    moveSeq(i) = j;
                    r = r+rOffsets(j); c = c+cOffsets(j);
                    break;
                end
            end
        end
    end

    function map_dist = BFSdistmap(map_obst, r_start, c_start)
        %determines BFS distance on map_obst  from freespace at [r_start, c_start] to
        %all other freespaces. Assumes map_obst is a 2D grid map of ones
        %and zeros. Zeros represent freespaces.  
        numfree = sum(map_obst(:) == 0);
        map_dist = -2+int32(map_obst); %-1 is obstacle, -2 is unexplored
        map_dist(r_start, c_start) = 0;
        leafNodes = zeros(numfree,2);
        leafptr = 1;
        leafNodes(leafptr,:)  = [r_start, c_start];
        rOffsets = [0,0,1,-1]; %move l,r,u,d 
        cOffsets = [-1,1,0,0]; %move l,r,u,d 
        for ct = 1:numfree
            rl = leafNodes(ct,1);
            cl = leafNodes(ct,2);
            d = map_dist(rl,cl);
            for dir = 1:4
                ro = rl+rOffsets(dir); co = cl+cOffsets(dir);
                if map_dist(ro,co) == -2
                    map_dist(ro,co) = d+1; %put shortest distance on map
                    leafptr = leafptr+1; %add this to the leaf pointers
                    leafNodes(leafptr,:)  = [ro,co];
                    if leafptr >= numfree
                        break;
                    end
                end
            end
            if leafptr >= numfree
                break;
            end
        end  %end for loop
    end

    function [pA,pB] = choosepApB(cRobVec, obstacle_pos,ri,ci)
        %connecting furthest is sometimes terrible.
        
        % 1. pick two robots, A and B.  How about the first ones?
        % Irob = find(cRobVec == 1,2,'first');
        % 2. pA = position (A), pB = position(B)
        % pA = Irob(1);pB = Irob(2); %65
        
        %[pA,pB] = twoCloseNodes(cRobVec, obstacle_pos,ri,ci); %65
        [pA,pB] = twoFurthestNodes(cRobVec, obstacle_pos,ri,ci); %92
        %pB = find(cRobVec == 1,1,'last'); % for tree (map 12), 72 steps vs 41 with other method
    end

    function [pA,pB] = twoCloseNodes(cRobVec, obstacle_pos,ri,ci) %#ok<DEFNU>
        %start with any starting node, find the furthest node, then start
        %at that node and find the furthest away
        robPos = -ones(size(obstacle_pos));
        robPos(sub2ind(size(obstacle_pos),ri(cRobVec==1),ci(cRobVec==1))) = 1;
        robPos(sub2ind(size(obstacle_pos),ri(cRobVec==0),ci(cRobVec==0))) = 0;
        pA = find(cRobVec == 1,1,'first');
        map_dist = BFSdistmap(obstacle_pos, ri(pA),ci(pA));
        %onlymap_dist = map_dist.*int32(1-obstacle_pos);
        map_dist(robPos==0)=0; % remove all spaces with no robots
        map_dist(map_dist==0) = 10000;
        [~,pB] = min(map_dist(map_dist>=0));
       % display([pA,pB])
    end

    function [pA,pB] = twoFurthestNodes(cRobVec, obstacle_pos,ri,ci)
        %THIS IS TERRIBLE: how about picking the two furthest nodes?
        %start with any starting node, find the furthest node, then start
        %at that node and find the furthest away
        robPos = -ones(size(obstacle_pos));
        robPos(sub2ind(size(obstacle_pos),ri(cRobVec==1),ci(cRobVec==1))) = 1;
        robPos(sub2ind(size(obstacle_pos),ri(cRobVec==0),ci(cRobVec==0))) = 0;
        pA = find(cRobVec == 1,1,'first');
        map_dist = BFSdistmap(obstacle_pos, ri(pA),ci(pA));
        %onlymap_dist = map_dist.*int32(1-obstacle_pos);
        map_dist(robPos==0)=0; % remove all spaces with no robots
        [~,pA] = max(map_dist(map_dist>=0));
        map_dist = BFSdistmap(obstacle_pos, ri(pA),ci(pA));
        map_dist(robPos==0)=0; % remove all spaces with no robots
        [~,pB] = max(map_dist(map_dist>=0));
       % display([pA,pB])
    end

    function rvec2 = applyMove(mv, rvecIn)
        rvec2 = zeros(size(rvecIn));
        % implement the move on every robot
        for ni = 1:numel(rvecIn)
            if rvecIn(ni)
                rvec2(G.Moves(ni,mv)) = rvecIn(ni);
            end
        end
    end

    
    function keyhandler(src,evnt) %#ok<INUSL>
        if strcmp(evnt.Key,'s')
            imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
        else
            moveto(evnt.Key)
        end
    end

    function moveto(key)
        % Maps keypresses to moving pixels
        if strcmp(key,'r')  %RESET
            [G.obstacle_pos,G.free,G.robvec,G.Moves] = SetupWorld();
            return
        end
        mv=0;
        if strcmp(key,'leftarrow') || strcmp(key,'a')|| strcmp(key,'1') %-x
            mv = 1;
        elseif strcmp(key,'rightarrow')|| strcmp(key,'d')|| strcmp(key,'2')  %+x
            mv = 2;
        elseif strcmp(key,'uparrow')|| strcmp(key,'w')|| strcmp(key,'3')  %+y
            mv = 3;
        elseif strcmp(key,'downarrow')|| strcmp(key,'x') || strcmp(key,'4') %-y
            mv = 4;
        end
        if mv>0
            G.movecount = G.movecount+1;
            G.robvec = applyMove(mv, G.robvec);
            im = G.obstacle_pos;
            im(G.free) = 2*G.robvec;
            if numel(unique(im))<3
                colormap(G.colormap(2:end,:));
            else
                colormap(G.colormap);
            end
            G.axis=imagesc(im);
            updateTitle()
        end
    end

    function updateTitle()
        title([num2str(G.movecount), ' moves, ',num2str(sum(G.robvec)),' poses'])
    end

    function [blk,free,robvec,Moves,ri,ci] = SetupWorld(mapnum)
        %  blk is the position of obstacles
        % free is the index of the free spaces in blk
        % robvec is a binary vector where the ith element is true if there
        % is a robot at free(i).
        blk = blockMaps(mapnum);
        free = uint16(find(blk==0));
        robvec = ones(size(free));
        [ri,ci] = find(blk==0);
        %Moves(i,3) gives the index in robvec after applying an up move.
        Moves = repmat( (1:numel(free))',1,4);
        world = -blk;
        world(free) = 1:numel(free);
        % hardcode mapping: if I move up, what does that map to in world?
        % I could do this as a vector multiplication
        %l,r,u,d
        for i = 1:numel(free)
            r = ri(i);
            c = ci(i);
            if blk(r,c-1) == 0
                Moves(i,1) = world(r,c-1); %left
            end
            if blk(r,c+1) == 0
                Moves(i,2) = world(r,c+1); %right
            end
            if blk(r+1,c) == 0
                Moves(i,3) = world(r+1,c); %up
            end
            if blk(r-1,c) == 0
                Moves(i,4) = world(r-1,c); %down
            end
        end
    end
end