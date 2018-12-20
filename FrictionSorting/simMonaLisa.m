
%SPACE REQUIRED: 2X THE NUMBER OF ROWS +3, 1*NUMBER OF COLUMNS + 3
% TODO: only show the first set of drift moves.
function totalMoves = simMonaLisa(User_PosGoal,User_PosObstacles)


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


image(2,:,1) = 255; %MAKE A COLUMN RED
image(:,5,2) = 255; % MAKE A ROW GREEN



saveMovie = false;
manual = false;
totalMoves=0;
%close all; clc;
pauseTs = 0.01; %#ok<NASGU>
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
    function makemymovie(showFrame)% each frame has to be added. So a function is made and called whenever an image needs to be added
        if showFrame
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
                %pause(pauseTs)
            end
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
figure(1)
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
        pause(.2)  %#ok<UNRCH>
    else
        makemymovie(true)
        for iR = 1:numRobots  % pass 1 on the tiles
            % move next tile on the bottom row to the side. What is the
            % number of the tile in the bottom row with the lowest index?
            PosCurrent = sortrows(PosCurrent,[2,1]);
            currTile = PosCurrent(1,3);
            %set(G.hRobots(currTile),'FaceColor',[0,0,1]);
            
            while PosCurrent(1,2)>3
                moveto('x'); %move down until 1 row above the obstacles
                makemymovie(iR==1);
            end
            % drift right
            drMoves = PosCurrent(1,1)-2;
            %display(['Drift ',num2str(drMoves),' moves right'])
            for j = 1:drMoves
                if j>1
                    moveto('a');  makemymovie(iR<6);
                end
                moveto('x'); makemymovie(iR==1);
                moveto('d'); makemymovie(iR==1);
                moveto('w'); makemymovie(iR==1);
            end
            
            % move tile up to correct row
            [~,rowGoal] = find(gM==currTile);
            [~,rowCur] = find(iM==currTile);
            
            drMoves = rows-rowGoal+1+rows - rowCur;
            %display(['Drift ',num2str(drMoves),' moves up'])
            
            for j = 1:drMoves
                moveto('w'); makemymovie(iR==1);
                moveto('a'); makemymovie(iR==1);
                moveto('x'); makemymovie(iR<6);
                moveto('d'); makemymovie(iR==1);
            end
            
            % move left two
            moveto('a'); makemymovie(iR==1);
            moveto('a'); makemymovie(iR==1);
            %move right one
            moveto('d');
            makemymovie(true);
            
            
        end%end pass 1:  take the next item, and place it in the row of s1M corresponding to the column.\
        moveto('x');
        for ci = 1:numRobots  % pass 2 on the tiles
            PosCurrent = sortrows(PosCurrent,[2,1]);
            currTile = PosCurrent(1,3);
            while PosCurrent(1,2)>3
                moveto('x'); %move down until 1 row above the obstacles
            end
            % drift right
            drMoves = PosCurrent(1,1)-2;
            %display(['Drift ',num2str(drMoves),' moves right'])
            for j = 1:drMoves
                if j>1
                    moveto('a');
                end
                moveto('x');
                moveto('d');
                moveto('w');
            end
            
            % move tile up to correct row
            [colGoal,rowGoal] = find(gM==currTile);
            %[~,rowCur] = find(iM==currTile);
            
            drMoves = rows-colGoal+1+rows - (rows-rowGoal)-1;
            %display(['Drift ',num2str(drMoves),' moves up'])
            
            for j = 1:drMoves
                moveto('w');
                moveto('a');
                moveto('x');
                moveto('d');
            end
            
            % move left two
            moveto('a');
            moveto('a');
            %move right one
            moveto('d');
            makemymovie(true);
        end%end pass 2
        
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
        % TODO SPEED: lazy evaluation AND replace ismembber with my own code.
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
        else
            return
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
        %        m=PosCurrent(1,3);
        %         if m==1
        %             for movieti=1:3
        %                 makemymovie()
        %             end
        %         elseif m~=1
        %             makemymovie()
        %         end
    end
    function [Goalmap,map,PosCurrent] = SetupWorld(Goalmap,ObstacleExtra) %function that has data set of the gameboard, initial points,final points and obstacles
        %         map=[1 1 1 1 1 1 1 1;
        %             1 0 0 0 0 0 0 1;
        %             1 0 0 2 2 2 0 1;
        %             1 0 0 2 2 2 0 1;
        %             1 0 0 2 2 2 0 1;
        %             1 0 0 0 0 0 0 1;
        %             1 0 0 0 0 0 0 1;
        %             1 0 0 0 0 0 0 1;
        %             1 0 0 0 0 0 0 1;
        %             1 0 0 0 0 0 0 1;
        %             1 1 1 1 1 1 1 1;];
        map = ones(5+2*rows,5+rows);
        map( 2:4+2*rows,2:4+rows) = 0;
        map( 3:2+rows,4:3+rows) = 2;
        
        
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
        
        for io=1:numrobots
            yval = floor((io-1)/rows);
            pos(io,:) = [2+io-rows*yval, yval+3];
        end
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



