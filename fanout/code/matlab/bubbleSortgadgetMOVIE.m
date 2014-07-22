function bubbleSortgadgetMOVIE
% specialized for plotting a gadget for doing Bubble Sort.
% Repeated application of two base permutations can generate any 
% permutation.  The obstacles above generate the base permutation $p=(12)$ 
% in the CW direction \{u,r,d,l\} and $q=(12...N)$ in the CCW direction 
%     \{r,u,l,d\}.

% program that permutes any given ar*ac matrix A into the br*bc B.
% [ensure (ar*ac == br*bc)], where each element of A is assigned a
% destination in B.
%
% Note that this is both a permutation  (changing the order of pixels) and
% a reshaping of the matrix dimensions.  There are (n!) permutations and
% (n) reshapes possible.  You can reapply the permutation and (permutation
% power to get the identity.
%
% This code also shows the history of each block by drawing a trace behind
% them.
%
global G MAKE_MOVIE RobotPts
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = true;
FrameCount = 1;
MOVIE_NAME = 'BubbleSort';
G.fig = figure(1);
set(G.fig,'Units','normalized','outerposition',[0 0 1 1],'NumberTitle','off');%'MenuBar','none',
if MAKE_MOVIE
    writerObj = VideoWriter(MOVIE_NAME,'MPEG-4');%http://www.mathworks.com/help/matlab/ref/videowriterclass.html
    set(writerObj,'Quality',100)
    %set(writerObj, 'CompressionRatio', 2);
    open(writerObj);
end
%create obstacle map and draw it
%G.obstacle_pos = flipud(NOTGate());


if nargin < 2
    % A =[0,0,0,1;
    %     0,1,1,0;
    %     0,0,0,0;
    %     0,1,1,0;
    %     0,1,1,0];
    % B =[0,0,0,1;
    %     0,1,1,0;
    %     0,0,0,1;
    %     0,1,1,0;
    %     0,0,0,1];
    % C =[0,0,0,0;
    %     0,1,1,0;
    %     0,1,1,1;
    %     0,1,1,0;
    %     0,0,0,0];
    
    Am =[1,3;
         2,4];
    Bm =[2,3;
         1,4];
    Cm =flipud([1,2;
         4,3]);
    
    
    Am =[1,4,7;
        2,5,8;
        3,6,9];
    Bm =[1,4,7;
        3,5,8;
        2,6,9];
    Cm =[1,2,3;
        4,5,6;
        7,8,9];  %this is the null move
    Cm =[8,9,7;
        1,2,3;
        4,5,6];
    
    %for all:
    G.A =  flipud(Am);
    G.B = Bm;
    G.C = Cm;
    G.Ai = G.A;
    G.Bi = G.B;
    G.Ci = G.C;
end

G.EMPTY = 0;
G.OBST = 1;
%assignCorrespondencies(A,B);
setupObstacles();

G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

%create vector of robots and draw them.  A robot vector consists of an xy
%position and a color.
% RobotPts = [3,11,1;
%             6,11,2;
%             3,4,3];
%numRobots = size(RobotPts,1);
numRobots = numel(G.A);
clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.5,0.5,0.5;
  %  1,0,0;
    ];

colormap(G.colormap);
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
%set(G.axis,'edgealpha',.08)
axis equal
axis tight
G.title = title('press arrows keys to move');


%end

G.hRobotsPast4 = zeros(1, numRobots);
G.hRobotsPast3 = zeros(1, numRobots);
G.hRobotsPast2 = zeros(1, numRobots);
G.hRobotsPast = zeros(1, numRobots);
G.hRobots = zeros(1, numRobots);
G.hRobotTexts = zeros(1, numRobots);
colors = hsv(numel(unique(RobotPts(:,4)))+1);

for hi = 1: numRobots
    G.hRobotsPast4(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.25);
    G.hRobotsPast3(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.4);
    G.hRobotsPast2(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.5);
    G.hRobotsPast(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.7);
    G.hRobots(RobotPts(hi,3)) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
    G.hRobotTexts(RobotPts(hi,3)) = text( RobotPts(hi,1),RobotPts(hi,2), num2str(RobotPts(hi,3)),'fontsize',14,'HorizontalAlignment','center');
    
end


%%%%%% MAKE MOVIE!
updateDrawing;
mvs = ['+y';'+x';'-y';'-x';  '+y';'+x';'-y';'-x';  '+x';'+y';'-x';'-y';  '+x';'+y';'-x';'-y';  '+x';'+y';'-x';'-y';];
for myc = 1:size(mvs,1)
   moveto(mvs(myc,:) )
   if mod(myc,4) == 0
       for myci = 1:30
           updateDrawing;
       end
   end
end
close(writerObj);




    function handleRobotPath = createRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
    end

    function keyhandler(src,evnt) %#ok<INUSL>
        if strcmp(evnt.Key,'s')
            imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
        else
            moveto(evnt.Key)
        end
    end
    function updatePastPath( hOldPath, hOlderPath)
        for ni = 1:size(RobotPts,1)
            set(hOlderPath(ni),'Position', get(hOldPath(ni),'Position'), ...
                'Curvature', get(hOldPath(ni),'Curvature'));
            uistack(hOlderPath(RobotPts(ni,3)),'top');
        end
    end
    function moveto(key)
        updatePastPath(G.hRobotsPast3,G.hRobotsPast4);
        updatePastPath(G.hRobotsPast2,G.hRobotsPast3);
        updatePastPath(G.hRobotsPast,G.hRobotsPast2);
        % Maps keypresses to moving pixels
        step = [0,0];
        if strcmp(key,'leftarrow') || strcmp(key,'-x') %-x
            RobotPts = sortrows(RobotPts,1);
            step = -[1,0];
        elseif strcmp(key,'rightarrow')|| strcmp(key,'+x') %+x
            RobotPts = sortrows(RobotPts,-1);
            step = [1,0];
        elseif strcmp(key,'uparrow')|| strcmp(key,'+y') %+y
            RobotPts = sortrows(RobotPts,-2);
            step = [0,1];
        elseif strcmp(key,'downarrow')|| strcmp(key,'-y') %-y
            RobotPts = sortrows(RobotPts,2);
            step = -[0,1];
        end
         % implement the move on every robot
        keepMoving = true;
        stValG = RobotPts(:,1:2);
        while keepMoving == true
            keepMoving = false;
            for ni = 1:size(RobotPts,1)
                stVal = stValG(ni,1:2);
                desVal = RobotPts(ni,1:2)+step;
                
                % move there if no robot in the way and space is free
                if  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
                        && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
                        && G.obstacle_pos( desVal(2),desVal(1) )==0
                    
                    RobotPts(ni,1:2) = desVal;
                    desVal = RobotPts(ni,1:2)+step;
                    keepMoving = true;
                end
                if ~isequal( stVal, RobotPts(ni,1:2) )
                    x = min(stVal(1), RobotPts(ni,1));
                    y = min(stVal(2), RobotPts(ni,2));
                    xd = abs(stVal(1)- RobotPts(ni,1));
                    yd = abs(stVal(2)- RobotPts(ni,2));
                    set(G.hRobotsPast(RobotPts(ni,3)),'Position',[x-1/2,y-1/2,xd+1,yd+1],'Curvature',[1/(1+xd),1/(1+yd)]);
                    uistack(G.hRobotsPast(RobotPts(ni,3)),'top');
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                else
                    set(G.hRobotsPast(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1],'Curvature',[1,1]);
                end
                
                
            end
           
            for ni = 1:size(RobotPts,1)
                    uistack(G.hRobots(RobotPts(ni,3)),'top');
                    set(G.hRobotTexts(RobotPts(ni,3)), 'Position', [RobotPts(ni,1),RobotPts(ni,2)]);
                    uistack(G.hRobotTexts(RobotPts(ni,3)),'top');
            end
            updateDrawing;  % update movie frame here
            %drawnow
            %title('moving')
        end
        for ctr = 1:10
            updateDrawing;  % update movie frame here
            %drawnow
            %title('finished move')
        end
    end

    function setupObstacles()
        [ar,ac] = size(G.A);
        [br,bc] = size(G.B);
        [cr,cc] = size(G.C);
        offsetY =  max(br+1, ar +1); %height of move 4 stoppers
        G.r = offsetY+ar*ac+1;%how tall?
        offsetX =  max(bc,ac);
        G.c = offsetX + 2*ar*ac  +1;  %how wide?
        % we want 16/9 = 1.7778
        %display([G.c,G.r])
        if G.r/G.c < 9/16
            desiredHeight     = ceil(G.c*9/16);
            desiredWidth= ceil(desiredHeight/9*16);
        else
            desiredWidth = ceil(G.r*16/9);
            desiredHeight = ceil(desiredWidth/16*9);
        end
        exWd = desiredWidth-G.c;
        exHt = desiredHeight-G.r;
        G.c = desiredWidth+5;
        G.r = desiredHeight+5;

        %robot_pos=G.EMPTY*ones(G.r,G.c); %initialize grid to be empty
        G.obstacle_pos=G.EMPTY*ones(G.r,G.c);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% place the robots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %robot_pos(1+(1:ar)+exHt,1+(1:ac)+exWd)=G.OBST+ G.A;
        [xind,yind] = meshgrid(1+(1:ar)+exHt,1+(1:ac)+exWd);
        RobotPts = [ reshape(yind,numel(G.A),1), reshape(xind,numel(G.A),1),  reshape( (G.A'),numel(G.A),1), reshape( (G.A'),numel(G.A),1)]; %(1:numel(G.A))'
        %place the obstacles%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = ac
            G.obstacle_pos(offsetY + 3*ar*i+2+exHt,1+i+exWd ) =G.OBST;  %move 1 (horizontal stops) needs ar blocks, move (offsetY-ar) + ar*ac
        end
        for i = cr
            G.obstacle_pos(1+i+exHt,offsetX+3*cc*i+2+exWd ) =G.OBST;  %move 1 (horizontal stops) needs ar blocks, move (offsetY-ar) + ar*ac
        end
        G.m1 = (offsetY-ar) + 3*ar*ac;
        
        for n = 1:numel(G.Ai)  %move 2: stop at correct width  (this is the only section that changes), needs ar*ac blocks, move offsetX+(bc-1)*(2*br)+2*(bc)
            [Br,Bc] = find( G.Bi == n);%Bc is the desired column to end up in,Br is the desired row to end in
            % vertical                  , horiz
            G.obstacle_pos(offsetY+ 2*ar*floor((n-1)/ar+1)+1+ n+exHt,  1+offsetX+(Br-1)*(3*bc)+2*(Bc)+exWd) = G.OBST+1;
        end
        G.AiF = reshape(1:numel(G.A),size(G.A'))';
        for n = 1:numel(G.Ci)  %move 2: stop at correct width  (this is the only section that changes), needs ar*ac blocks, move offsetX+(bc-1)*(2*br)+2*(bc)
            [Br,Bc] = find( G.Ci == n);%Cc is the desired column to end up in,Cr is the desired row to end in
            % vertical                  , horiz
            G.obstacle_pos( 1+offsetY+(Bc-1)*(3*br)+2*(Br)+exHt, 1+offsetX+ 2*ac*floor((n-1)/ac+1)+ n +exWd) = G.OBST;
            %G.obstacle_pos(1+offsetY+(Bc-1)*(2*br)+2*(Br),offsetX+n) =G.OBST;
        end
        G.m2 = offsetX+(bc-1)*(3*br)+2*(bc);
        for Br = 1:br%move 3 (step stones), needs ar*ac blocks, move offsetY + ar*ac  -1
            for Bc = 1:bc      % vertical      , horiz
                G.obstacle_pos( Br+exHt,   Bc*2 +  offsetX + (Br-1)*(3*bc)+exWd) = G.OBST;
            end
        end
        
        for Cr = 1:cr%move 3b (step stones), needs ar*ac blocks, move offsetY + ar*ac  -1
            for Cc = 1:cc      % vertical      , horiz
                G.obstacle_pos(    Cr*2 + (Cc-1)*(3*cr)+exHt+offsetY, Cc+exWd  ) = G.OBST;
            end
        end
        
        G.m3 = offsetY + 3*ar*ac  -1;
        
        G.obstacle_pos(1+(1:br)+exHt,1+exWd) =G.OBST; %move 4 (vertical line) %needs br blocks, move offsetX+(bc-1)*(2*br)+br
        G.m4 =offsetX+(bc-1)*(3*br)+br+1;
        G.obstacle_pos(1+exHt,1+(1:bc)+exWd) =G.OBST; %move 5 (horizontal line)  %(not a move, but looks nice) needs bc blocs,
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    function updateDrawing
        drawnow
        if(MAKE_MOVIE)
            FrameCount=FrameCount+1;
            F = getframe_nosteal_focus; %getframe;
            writeVideo(writerObj,F.cdata);
            while(FrameCount < 10)
                updateDrawing
            end
            
        end
    end

end