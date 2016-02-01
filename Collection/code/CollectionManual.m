function CollectionManual
% Allows user to use arrow keys to collect a swarm of robots initialized on
% a unit grid. This version of the problem allows robots to overlap
%  Aaron T. Becker
%     atbecker@uh.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global G MAKE_MOVIE
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = false;
G.fig = figure(1);
G.mapnum = 4;
G.alg = 4;
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