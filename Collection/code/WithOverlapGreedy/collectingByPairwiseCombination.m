function collectingByPairwiseCombination
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
G.mapnum = 12;
G.alg = 10;  %BFS is 10
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name','SwarmCollection','color',[1,1,1]); %#ok<UNRCH>
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end

[G.obstacle_pos,G.free,G.robvec,G.Moves] = SetupWorld(G.mapnum);

G.movecount = 0;

G.EMPTY = 0;
G.OBST = 1;

G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.

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
% % %%%%  FIND THE SHORTEST PATH TO GET ALL ROBOTS TO ONE PLACE
% % % I have a vector:  LeavesToExpand
tic
G.pairwisePath = [];
Leafsorted = [];
cRobVec = G.robvec;
while sum(cRobVec)>1
  [cRobVec, pathSeg] =  pairwiseCombine(cRobVec);
  G.pairwisePath  = [G.pairwisePath,pathSeg];
end
shortpath = G.pairwisePath;
display('KEY: l,r,u,d = 1,2,3,4')
display(['(',num2str(length(shortpath)),' steps): ',num2str(shortpath)])
%idea:  we will save files as Map##Alg##Sec##Nodes######.mat
save(['Map',num2str(G.mapnum,'%03d'),'Alg',num2str(G.alg,'%03d'),'Sec',num2str(round(toc),'%06d'),'Nodes',num2str(G.ptail,'%08d'),'Path',num2str(numel(shortpath),'%03d'),'.mat'], 'shortpath', 'phead','G');
        

% phead = 1;
% G.ptail = 1;
% G.mxSize = 1000;
% G.minsepPoints = 10^10;
% G.LeafRobots = uint32(zeros(G.mxSize,1));
% Leafsorted = uint32(zeros(G.mxSize,1));
% G.LeafPath = uint8(zeros(G.mxSize,1));
% G.LeafPrev = uint32(zeros(G.mxSize,1));
% %TODO: try bit packing: d =bi2de(b)
% G.LeafRobots(phead) = bi2de(G.robvec');
% Leafsorted(1) = bi2de(G.robvec');
% while phead <= G.ptail
%     rvec = de2bi(G.LeafRobots(phead));
%     %  display([num2str(phead), ', and ', num2str(sum(rvec))])
%     %   add up, Left, Right, Down to LeavesToExpand
%     for mvi = 1:4
%         if expandLeaf(mvi,rvec,phead);
%             phead = G.ptail+1;
%             break
%         end
%     end
%     phead = phead+1;
% end
toc  % simple map took 14.351126 seconds
figure(1)

    function [cRobVec, pathSeg] = pairwiseCombine(cRobVec)
    % 1. pick two robots, A and B.  How about the first ones?
    Irob = find(cRobVec == 1,2,'first');
    % 2. pA = position (A), pB = position(B)
    pA = Irob(1);
    pB = Irob(2);
    %pB = find(cRobVec == 1,1,'last');  for tree, 72 steps vs 41 with other method
    pathSeg = [];
    while pA ~= pB %  if robots A and B do not overlap try again
    % 3. use BFS to find moveSeq that moves robot A to pB
    phead = 1;
    G.ptail = 1;
    G.mxSize = 1000;
    G.minsepPoints = 10^10;
    G.LeafRobots = uint64(zeros(G.mxSize,1));
    Leafsorted = uint64(zeros(G.mxSize,1));
    G.LeafPath = uint8(zeros(G.mxSize,1));
    G.LeafPrev = uint64(zeros(G.mxSize,1));
    VecA = zeros(size(cRobVec)); VecA(pA) = 1;
    VecB = zeros(size(cRobVec)); VecB(pB) = 1; brvecB = bi2de(VecB');
    G.LeafRobots(phead) = bi2de(VecA');
    Leafsorted(1) = bi2de(VecA');
    while phead <= G.ptail
        rvec = de2bi(G.LeafRobots(phead));
        %  display([num2str(phead), ', and ', num2str(sum(rvec))])
        %   add up, Left, Right, Down to LeavesToExpand
        for mvi = 1:4
            if expandLeaf(mvi,rvec,phead,brvecB);
                phead = G.ptail+1;
                break
            end
        end
        phead = phead+1;
    end
    moveSeq = G.comboPath;
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


    function isFinished = expandLeaf(mv,rvec,phead,brvecB)
        isFinished = false;
        rvecT = applyMove(mv, rvec);
        brvecT = bi2de(rvecT);
        % base case: is the robot at VecB?
        if brvecB == brvecT %     return success!
            ptr = phead;
            shortpath = mv;
            while G.LeafPath(ptr)>0
                shortpath(end+1) = G.LeafPath(ptr); %#ok<AGROW>
                ptr = G.LeafPrev(ptr);
            end
            shortpath = fliplr(shortpath);
            display(['Combination Success:',num2str(shortpath)])
            G.comboPath = shortpath;
            isFinished = true;
        elseif IsNewLeaf(brvecT)
            %sum(ismember(G.LeafRobots,brvecT)) == 0
            G.ptail = G.ptail+1;
            
            if G.ptail>G.mxSize-1
                display([num2str(G.mxSize),' nodes, ',num2str(toc),'s, ', num2str( G.minsepPoints),' min'])
                save(['Map',num2str(G.mapnum,'%03d'),'Alg',num2str(G.alg,'%03d'),'temp.mat'],...
                     'phead','G','Leafsorted');

                G.mxSize = G.mxSize + 1000;
                G.LeafRobots(G.mxSize) = 0;
                G.LeafPath(G.mxSize) = 0;
                G.LeafPrev(G.mxSize) = 0;
                Leafsorted(G.mxSize) = 0;
            end
            G.LeafRobots(G.ptail) = brvecT;
            G.LeafPath(G.ptail) = mv;
            G.LeafPrev(G.ptail) = phead;
        end
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

    function isNew = IsNewLeaf(brvecT)
        % returns false if brvecT has already been found
        % else, adds brvecT to a sorted vector and returns true
        %        %do a binary search through G.Leafsorted
        %if found, return true.
        
        isNew = true;
        imin = 1;
        imax = G.ptail;
        while imin<imax
            imid = floor(imin + ((imax - imin) / 2));
            %if imid>=imax
            %    break;%code must guarantee the interval is reduced at each iteration
            %end
            % reduce the search
            if Leafsorted(imid) < brvecT
                imin = imid + 1;
            else
                imax = imid;
            end
        end
        imid = floor(imin + ((imax - imin) / 2));
        if ((imax == imin) && (Leafsorted(imid) == brvecT))
            isNew = false;
            return;
        else
           % display([imin,imid,imax,brvecT])
            Leafsorted(1:G.ptail+1) = [Leafsorted(1:imid-1); brvecT; Leafsorted(imid:G.ptail)];
           
           % Leafsorted
            return;
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

    function [blk,free,robvec,Moves] = SetupWorld(mapnum)
        %  blk is the position of obstacles
        % free is the index of the free spaces in blk
        % robvec is a binary vector where the ith element is true if there
        % is a robot at free(i).
        blk = blockMaps(mapnum);
        free = uint16(find(blk==0));
        robvec = ones(size(free));
        [ri,ci] = find(blk==0);
        %Mu gives the index in robvec after applying an up move.
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