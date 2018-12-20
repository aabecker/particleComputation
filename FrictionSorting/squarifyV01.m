
%SPACE REQUIRED: 2X THE NUMBER OF ROWS +3, 1*NUMBER OF COLUMNS + 3
%  TODO: we have a problem if a row or column is initially full
% if you are on the last row, we can wrap  particles around the top and
% fold them under. Sometimes this requires less time than switching top and
% bottom.
function totalMoves = squarifyV01(User_PosGoal,User_PosObstacles)
% Aaron Becker, atbecker@uh.edu
% takes a random placement of n^2 particles in a bounded workspace with
% wall with friction that prevents lsiding along them, and compacts the
% particles into an n x n square using global inputs (all particles move
% simultaneously in the same direction).


image = imread('Mona_Lisa25x25.png');
%image = imread('Mona_Lisa6x6.png');
rows = size(image,1);
cols = size(image,1);
gM = reshape(1:rows*cols,rows,cols);

%arrange by gradient
imgGray = rgb2gray(image);
[~,I] = sort(imgGray(:));
iM = flipud(reshape(I,rows,cols))';

%random permutation of the numbers
%iM =  flipud(reshape(randperm(rows*cols),rows,cols))';


%image(2,:,1) = 255; %MAKE A COLUMN RED
%image(:,5,2) = 255; % MAKE A ROW GREEN



saveMovie = false;
manual = false;
totalMoves=0;
%close all; clc;
pauseTs = 0.01;
clc
format compact
global G
G.fig = figure(1);
clf
if saveMovie
    MOVIE_NAME = 'Friction_bots'; %to make a movie 'Friction_bots.mp4'
    writerObj = VideoWriter(MOVIE_NAME,'MPEG-4');%http://www.mathworks.com/help/matlab/ref/videowriterclass.html
    set(writerObj,'Quality',100);
    writerObj.FrameRate=30;
    open(writerObj);
end
    function makemymovie()% each frame has to be added. So a function is made and called whenever an image needs to be added
        for ni = 1:numel(G.hRobots)
            set(G.hRobots(PosCurrent(ni,3)),'Position',[PosCurrent(ni,1)-1/2,PosCurrent(ni,2)-1/2,1,1]);
        end
        
        if  saveMovie
            figure(G.fig)
            F = getframe;
            writeVideo(writerObj,F.cdata);
            %  writeVideo(writerObj,F.cdata);
        else
            drawnow
            pause(pauseTs)
        end
    end
switch nargin
    case 2
        [~,G.PosObstacles,PosCurrent] = SetupWorld(User_PosGoal,User_PosObstacles,3);
    otherwise
        [~,G.PosObstacles,PosCurrent] = SetupWorld();
end
G.EMPTY = 0;
G.OBST = 1;
G.maxX = size(G. PosObstacles,2);
G.maxY = size(G. PosObstacles,1);
%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.
numRobots = size(PosCurrent,1);
%figure(1)
clf
G.colormap = [  1,1,1; %Empty = white
    0,0,.7; %obstacle
    1,1,1;
    ];
colormap(G.colormap(1:numel(unique(G. PosObstacles)),:));
G.axis=imagesc(G. PosObstacles);
%set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
set(gca,'box','off','ydir','normal','Visible','on');
axis equal
hold on
rectangle('Position',[3.5,2.5,rows,rows],'FaceColor',[.9,1,.9],'EdgeColor','none')   %staging area
rectangle('Position',[3.5,rows+3.5,rows,rows],'FaceColor',[1,.9,.9],'EdgeColor','none') %build area
G.hRobots = zeros(1, numRobots);


PosCurrent(:,3) = iM(:);
for hi = 1: numRobots
    item = PosCurrent(hi,3);
    [i,j] = find(gM==iM(item));
    G.hRobots(PosCurrent(item,3)) = rectangle('Position',[PosCurrent(item,1)-1/2,PosCurrent(item,2)-1/2,1,1],'Curvature',[0,0],'FaceColor',image(i,j,:)); %init
    %set(G.hRobots(PosCurrent(ni,3)),'Position',[PosCurrent(ni,1)-1/2,PosCurrent(ni,2)-1/2,1,1]);
end
%%%%%%%automatic code
Flag3=0 ;%Signals the completion of the algorithm

if manual
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','press arrows keys to move'); %#ok<UNRCH>
end

while Flag3~=1
    if manual
        pause(.2)%#ok<UNRCH>
    else
        drawnow
        pause(.2)
        % first set of moves makes the set into a triangle of width rows.
        %TODO: what if we start with a few rows completely filled?
        % move right 3 times
        moveto('d');moveto('d');moveto('d');
        % move leff
        moveto('a');
        % IF ANY ROW IS WIDER THAN row (doesn't have 2 spaces on left and 1
        % space on right), than we need to do something here.
        % TODO: ARUN
        
        % move down till nothing changes
        while moveto('x')
        end
        
        % move up one
        moveto('w');
        
        % move right till nothing changes
        while moveto('d')
        end
        
        %move left two
        moveto('a'); moveto('a');
        %now the robots are in a triangle!
        
        PosCurrent = sortrows(PosCurrent,[-2,1]);
        while PosCurrent(1,2) - PosCurrent(end,2)>=rows
            
            flagMoveUp = true;
            while flagMoveUp
                %move up till top right cell touches
                PosCurrent = sortrows(PosCurrent,[-2,-1]);
                height = PosCurrent(1,2);
                
                for ci =1: 2*rows+4-height
                    moveto('w'); %move up until it touches
                end
                
                PosCurrent = sortrows(PosCurrent,[-2,1]);
                
                indLastTop = find(PosCurrent(:,2) == PosCurrent(1,2),1,'last');
                indFirst2nd = find(PosCurrent(:,2) == PosCurrent(1,2)-1,1,'first');
                in2ndRow = PosCurrent(indLastTop,1)-PosCurrent(indFirst2nd,1)+1;
                
                if in2ndRow >= PosCurrent(1,1)-3
                    flagMoveUp = false;
                end
                
                dlMoves = min( in2ndRow, PosCurrent(1,1)-3 );
                for j = 1:dlMoves
                    moveto('d');
                    moveto('x');
                    moveto('a');
                    if j<dlMoves
                        moveto('w');
                    end
                end
                if flagMoveUp
                    moveto('w');moveto('w');
                    moveto('x');
                else
                    % flatten top
                    while moveto('w')
                    end
                end
            end
            
            %%%%%% FIX BOTTOM
            flagMoveDown = true;
            while flagMoveDown
                %move down till top right cell touches
                PosCurrent = sortrows(PosCurrent,[2,-1]);
                height = PosCurrent(1,2);
                
                for ci =1: height-2
                    moveto('x'); %move down until it touches
                end
                
                PosCurrent = sortrows(PosCurrent,[2,1]);
                
                indLastBottom = find(PosCurrent(:,2) == PosCurrent(1,2),1,'last');
                indFirst2nd = find(PosCurrent(:,2) == PosCurrent(1,2)+1,1,'first');
                in2ndRow = PosCurrent(indLastBottom,1)-PosCurrent(indFirst2nd,1)+1;
                
                if in2ndRow >= PosCurrent(1,1)-3
                    flagMoveDown = false;
                end
                
                dlMoves = min( in2ndRow, PosCurrent(1,1)-3 );
                for j = 1:dlMoves
                    moveto('d');
                    moveto('w');
                    moveto('a');
                    if j<dlMoves
                        moveto('x');
                    end
                end
                if flagMoveDown
                    moveto('x');moveto('x');
                    moveto('w');
                else
                    % flatten bottom
                    while moveto('x')
                    end
                end
            end
            PosCurrent = sortrows(PosCurrent,[-2,1]);
        end
        
        Flag3=1;
    end %end manual/auto
end %end while
if Flag3==1
    for im=1:20
        makemymovie()
    end
end
    function retVal = frictionOK(stVal, step, G)
        frictionBad = (stVal(2)==2 && step(2) <1 ) ... %friction if on bottom row and not trying to move up
            || (stVal(1) == G.maxX-1 && step(1) >-1)...%friction if on right wall and not trying to move left
            ||(stVal(2)==G.maxY-1 && step(2) >-1 )...%friction if on top wall and not trying to move down
            ||(stVal(1)==2 && step(1) <1 ); %friction if on left wall and not trying to move right
        retVal = ~frictionBad;
    end
    function retVal = spaceFreeWithNoRobot(desVal, PosCurrent, G)
        % move there if no robot in the way and space is free
        retVal =  desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ... %check that we are not hitting the boundary
            && G. PosObstacles( desVal(2),desVal(1) )~=1 ...
            &&  ~any(PosCurrent(:,1) == desVal(1) & PosCurrent(:,2)==desVal(2)); %~ismember(desVal,PosCurrent(:,1:2),'rows')  ...; %check we are not hitting the obstacle
        
    end
    function change = moveto(Direction)
        totalMoves=totalMoves+1;
        change = false;
        % Maps key to moving pixels
        if strcmp(Direction,'a') %-x
            PosCurrent = sortrows(PosCurrent,1);
            step = -[1,0];
        elseif  strcmp(Direction,'d') %+x
            PosCurrent = sortrows(PosCurrent,-1);
            step = [1,0];
        elseif  strcmp(Direction,'w') %+y
            PosCurrent = sortrows(PosCurrent,-2);
            step = [0,1];
        elseif  strcmp(Direction,'x') %-y
            PosCurrent = sortrows(PosCurrent,2);
            step = -[0,1];
        end
        % implement the move on every robot
        for ni = 1:size(PosCurrent,1)
            stVal = PosCurrent(ni,1:2);
            desVal = PosCurrent(ni,1:2)+step;
            % move there if no robot in the way and space is free
            if spaceFreeWithNoRobot(desVal, PosCurrent, G) && frictionOK(stVal, step, G)
                PosCurrent(ni,1:2) = desVal;
                change = true;
            end
        end
        PosCurrent= sortrows(PosCurrent,[2 1]);
        makemymovie()
    end
    function [Goalmap,map,PosCurrent] = SetupWorld(Goalmap,ObstacleExtra) %function that has data set of the gameboard, initial points,final points and obstacles
        
        map = ones(5+2*rows,5+rows); %border
        map( 2:4+2*rows,2:4+rows) = 0;  %workspace
        map( 3:2+rows,4:3+rows) = 2; %
        
        map = flipud(map); %has to be done to make the gameboard look like the matrix above
        d=size(map);
        switch nargin
            case 2
                q = size(Goalmap,1);
                numrobots=q(1,1);
                map(ObstacleExtra(:,1),ObstacleExtra(:,2))=1;
                for io=1:d(1,1)
                    for i2=1:d(1,2)
                        if map(io,i2)==2
                            map(io,i2)=0;
                        end
                    end
                end
                for io=1:q
                    map(Goalmap(io,2),Goalmap(io,1))=2;
                end
            otherwise
                numrobots =sum(map(:) == 2);
                
                count1=1;
                for io=1:d(1,1)
                    for i2=1:d(1,2)
                        if map(io,i2)==2
                            Q1(count1,2)=io; %#ok<AGROW>
                            Q1(count1,1)=i2; %#ok<AGROW>
                            count1=count1+1;
                        end
                    end
                end
                Goalmap=sortrows(Q1,[-1 -2]);
        end
        pos = zeros(numrobots,2);
        %place robots on defined location in the staging zone away from obstacles and not overlapping
        %         for i=1:numrobots
        %             pos(i,:) = [2+i-rows*floor((i-1)/rows), floor((i-1)/rows)+3];
        %         end
        
        % %%% Place robots in several rows (this is a corner case the current code cannot handle
        %         for io=1:numrobots
        %             yval = floor((io-1)/(3+rows));
        %             pos(io,:) = [1+io-(3+rows)*yval, 2*yval+3];
        %         end
        
        % randomly position robots (since robots can never be in a corner,
        % exclude the first and last rows)
        rp =  -1+randperm( (rows*2+1)*(rows+3), rows*rows);
        %rp = [95    25    48    41    49    31    28   113    79    81   110    16   117    40    80    96    20    58    86    32     9    82    93    50    63    68   104     5    61    45    69   109   116    18    14    73];
        for io=1:numrobots
            yVal = floor((rp(io))/(rows+3));
            pos(io,:) = [rp(io)-(rows+3)*yVal+2, yVal+3];
        end
        %
        PosCurrent = [pos,(1:numrobots)',(1:numrobots)'];
    end

    function keyhandler(src,evnt) %#ok<INUSL>
        
        if strcmp(evnt.Key,'leftarrow')
            moveto('a');
        elseif strcmp(evnt.Key,'rightarrow')
            moveto( 'd');
        elseif strcmp(evnt.Key,'uparrow')
            moveto('w');
        elseif strcmp(evnt.Key,'downarrow')
            moveto('x');
        end
        
        
        % if strcmp(evnt.Key,'s')
        %     imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
        if strcmp(evnt.Key,'x') ||strcmp(evnt.Key,'w') || strcmp(evnt.Key,'d') || strcmp(evnt.Key,'a')
            moveto(evnt.Key)
        end
    end

end



