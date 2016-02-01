function solveCollectionWithOverlapBin
% 1.) This version is using brute force to search. It quickly runs into
% problems with size
% We should try 2.) using a greedy policy
% or
%  3.) picking two points that have the greatest diameter, and searching
%  for strategies to bring them together, then repeat the process
%
%  before that, I want to run and time this algorithm and learn where we
%  are loosing the most time.
% and Aaron T. Becker
%  Plan:  have 2 arrays, one sort, one not.  
% http://stackoverflow.com/questions/20166847/faster-version-of-find-for-sorted-vectors-matlab
%
% ismembc  assumes a sorted array: http://stackoverflow.com/questions/20166847/faster-version-of-find-for-sorted-vectors-matlab
% bit packing?  - can only handle 52 items.
%
% how to insert into sort array.  I think we should have two arrays, one
% for the arrangements and one for searching.  The searching one should be
% sorted: http://stackoverflow.com/questions/13013750/how-to-reindex-a-sparse-associative-array/13026058#13026058
%                    atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global G MAKE_MOVIE
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = false;
G.mapnum = 3;
G.alg = 3;
G.fig = figure(1);
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

% %%%%  FIND THE SHORTEST PATH TO GET ALL ROBOTS TO ONE PLACE
% % I have a vector:  LeavesToExpand
tic
phead = 1;
G.ptail = 1;
G.mxSize = 1000;
G.LeafRobots = zeros(G.mxSize,1);
G.LeafPath = zeros(G.mxSize,1);
G.LeafPrev = zeros(G.mxSize,1);
%TODO: try bit packing: d =bi2de(b)
G.LeafRobots(phead) = bi2de(G.robvec');
while phead <= G.ptail
    rvec = de2bi(G.LeafRobots(phead));
    %  display([num2str(phead), ', and ', num2str(sum(rvec))])
    %   add up, Left, Right, Down to LeavesToExpand
    for mvi = 1:4
        if expandLeaf(mvi,rvec,phead);
            phead = G.ptail+1;
            break
        end
    end
    phead = phead+1;
end
toc  % simple map took 14.351126 seconds
figure(1)

%%%%%%%%automatic code  (TODO)
% mvs = ['w','d','d','d','x','a'];
% for myc = 1:numel(mvs)
%     pause(.25)
%     %   moveto(mvs(myc))
% end
%%%%%%%%%
    function isFinished = expandLeaf(mv,rvec,phead)
        isFinished = false;
        rvecT = applyMove(mv, rvec);
        brvecT = bi2de(rvecT);
        %     base case: are robots collected?
        if sum(rvecT)==1 %     return success!
            ptr = phead;
            shortpath = mv;
            while G.LeafPath(ptr)>0
                shortpath(end+1) = G.LeafPath(ptr); %#ok<AGROW>
                ptr = G.LeafPrev(ptr);
            end
            shortpath = fliplr(shortpath);
            display(['Success:',num2str(shortpath)])
            %phead = G.ptail+1;
            %idea:  we will save files as Map##Alg##Sec##Nodes######.mat
            save(['Map',num2str(G.mapnum,'%03d'),'Alg',num2str(G.alg,'%03d'),'Sec',num2str(round(toc),'%06d'),'Nodes',num2str(G.ptail,'%08d'),'Path',num2str(numel(shortpath),'%03d'),'.mat'], 'shortpath', 'phead','G');       
            isFinished = true;
        elseif sum(ismember(G.LeafRobots,brvecT)) == 0
            G.ptail = G.ptail+1;
            
            if G.ptail>G.mxSize
                %20000 nodes, 5.7881s
                display([num2str(G.mxSize),' nodes, ',num2str(toc),'s'])
                G.mxSize = G.mxSize + 1000;
                G.LeafRobots(G.mxSize) = 0;
                G.LeafPath(G.mxSize) = 0;
                G.LeafPrev(G.mxSize) = 0;
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
                Moves(i,1) = world(r,c-1);
            end
            if blk(r,c+1) == 0
                Moves(i,2) = world(r,c+1);
            end
            if blk(r+1,c) == 0
                Moves(i,3) = world(r+1,c);
            end
            if blk(r-1,c) == 0
                Moves(i,4) = world(r-1,c);
            end
        end
        
    end
end