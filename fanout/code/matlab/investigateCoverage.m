function investigateCoverage
% Two relevant problems in controlling many agents inside body
%
% 1.) COVERAGE:  can we guarantee that a robot visits every location?  (passes
% within distance $r$ of every point int he workspace?/ visits every cell)
% Extensions: can we guarantee a robots spends atleast $\tau$ time in every
% cell?
%
%  WHY: we want to ensure coverage of the entire spinal canal by a
%  biomarker or a contact drug.
%
%
%
% 2.) CONVERGENCE:  can we collect $k$ robots at a given location?
%  Extensions:  is there a motion plan that finishes with all the cells at
%  the same location?  At the desired location?  NOT in bad locations?
%
% Each problem is hard (how hard?). The inverse problem may be easy.
% Coverage of nxn world with k=n robots requries no obstacles & 2 moves if robots enter
% linearly
% if k < n, we need obstacles to make this work, as in Ricochet Robots.
% Problem:  minimize the number of obstacles $b$ or minimize the number of
% robots $k$.
%
% Convergence of robots to one corner of a rectangular free space requires
% no obstacles and 2 moves.
%

global G MAKE_MOVIE RobotPts
%close all; clc;
clear all
clc
format compact
MAKE_MOVIE = false;
G.fig = figure(1);
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name','Massive Control','color',[1,1,1]); %#ok<UNRCH>
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end
strTitle = '';
%%%%% COVERAGE
%[G.obstacle_pos,RobotPts] = simpleCoverage(15);
%[G.obstacle_pos,RobotPts] = multiPassCoverage(15);
%[G.obstacle_pos,RobotPts] = multiPassCoverageX(50);
%[G.obstacle_pos,RobotPts] = multiPassCoverageSpiral(50);


%%%%% CONVERGENCE (aggregation?)
bruteForceCalc();
%[G.obstacle_pos,RobotPts] = simpleConverge(15,20);
[G.obstacle_pos,RobotPts] = ConvergeCenter();

G.EMPTY = 0;
G.OBST = 1;


G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.

numRobots = size(RobotPts,1);
initP = RobotPts;
figure(1)
clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    0.5,0.5,0.5;
    ];
colormap(G.colormap(1:numel(unique(G.obstacle_pos)),:));
G.axis=imagesc(G.obstacle_pos); 
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');

%set(G.axis,'edgealpha',.08)
axis equal
%axis tight
hold on
%set(G.fig,'Units','normalized','outerposition',[0 0 1 1]);%'MenuBar','none',
% % %%% USEFUL FOR PRINTING A GRIDDED ARRAY:
% figure
% Ggrid.colormap = [  1,1,1; %Empty = white
%     0.5,0.5,0.5; %obstacle
%     0.5,0.5,0.5;
%     ];
% ObsGrid = [G.obstacle_pos;zeros(size(G.obstacle_pos(1,:)))]
% ObsGrid = [ObsGrid,zeros(size(ObsGrid(:,1)))]
% pcolor(ObsGrid)
% G.title = title({'press arrows keys to move';strTitle});  %TODO: why no title?
% axis equal
% axis tight
% hold on
% colormap(Ggrid.colormap(1:numel(unique(G.obstacle_pos)),:));
% return

%end
G.hRobotsPast11 = zeros(1, numRobots);
G.hRobotsPast10 = zeros(1, numRobots);
G.hRobotsPast9 = zeros(1, numRobots);
G.hRobotsPast8 = zeros(1, numRobots);
G.hRobotsPast7 = zeros(1, numRobots);
G.hRobotsPast6 = zeros(1, numRobots);
G.hRobotsPast5 = zeros(1, numRobots);
G.hRobotsPast4 = zeros(1, numRobots);
G.hRobotsPast3 = zeros(1, numRobots);
G.hRobotsPast2 = zeros(1, numRobots);
G.hRobotsPast = zeros(1, numRobots);
G.hRobots = zeros(1, numRobots);
colors = jet(numel(unique(RobotPts(:,4)))+1);
%colors = [1,0,0;0,0,1; 1,.5,1; .5,0,.5;];
 
 
for hi = 1: numRobots
    %     G.hRobotsPast11(hi) =  createRobotPath( RobotPts(hi,:), 0.20);
        G.hRobotsPast10(hi) =  createRobotPath( RobotPts(hi,:), 0.25);
        G.hRobotsPast9(hi) =  createRobotPath( RobotPts(hi,:), 0.3);
        G.hRobotsPast8(hi) =  createRobotPath( RobotPts(hi,:), 0.35);
        G.hRobotsPast7(hi) =  createRobotPath( RobotPts(hi,:), 0.4);
        G.hRobotsPast6(hi) =  createRobotPath( RobotPts(hi,:), 0.45);
    G.hRobotsPast5(hi) =  createRobotPath( RobotPts(hi,:), 0.5);
    G.hRobotsPast4(hi) =  createRobotPath( RobotPts(hi,:), 0.55);
    G.hRobotsPast3(hi) =  createRobotPath( RobotPts(hi,:), 0.6);
    G.hRobotsPast2(hi) =  createRobotPath( RobotPts(hi,:), 0.7);
    G.hRobotsPast(hi) =  createRobotPath( RobotPts(hi,:), 0.8);
    
    %G.hRobotsPast4(hi) =  BLUEcreateRobotPath( RobotPts(hi,:), 0.6);
    
    %     G.hRobotsPast10(hi) =  createRobotPath( RobotPts(hi,:), 0.03);
    %     G.hRobotsPast9(hi) =  createRobotPath( RobotPts(hi,:), 0.05);
    %     G.hRobotsPast8(hi) =  createRobotPath( RobotPts(hi,:), 0.10);
    %     G.hRobotsPast7(hi) =  createRobotPath( RobotPts(hi,:), 0.15);
    %     G.hRobotsPast6(hi) =  createRobotPath( RobotPts(hi,:), 0.2);
    %     G.hRobotsPast5(hi) =  createRobotPath( RobotPts(hi,:), 0.3);
    %     G.hRobotsPast4(hi) =  createRobotPath( RobotPts(hi,:), 0.4);
    %     G.hRobotsPast3(hi) =  createRobotPath( RobotPts(hi,:), 0.5);
    %     G.hRobotsPast2(hi) =  createRobotPath( RobotPts(hi,:), 0.6);
    %     G.hRobotsPast(hi) =  createRobotPath( RobotPts(hi,:), 0.7);
    if numel( RobotPts(hi,:))>5
        G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,RobotPts(hi,5),RobotPts(hi,6)],'Curvature',[1/RobotPts(hi,5),1/RobotPts(hi,6)],'FaceColor',colors(RobotPts(hi,4),:));
    else
        G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
    end
end


    function bruteForceCalc()
       % how many starting configurations are possible?
       n = 2:50;
       searches = zeros(size(n));
       for i = 1:numel(searches)
           searches(i) =   nchoosek(n(i)^2,4);
       end
       figure(2)
       semilogy(n,searches)
       
       %plot((n),searches./n.^8)
       xlabel('width of square workspace')
       ylabel('combinations')
       title('Initial positions for $k=4$ robots')
        
    end

    function handleRobotPath = createRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
    end

    function handleRobotPath = BLUEcreateRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-[0,0,1])*fractionColor,'LineStyle','none');
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
function savePastPath( hOldPath)
        for ni = 1:size(RobotPts,1)
            rectangle('Position',get(hOldPath(ni),'Position'),'Curvature',get(hOldPath(ni),'Curvature'),'FaceColor',get(hOldPath(ni),'FaceColor'),'LineStyle',get(hOldPath(ni),'LineStyle'));
            uistack(hOldPath(ni),'bottom');
        end
    end

    function retVal = spaceFreeWithNoRobot(desVal, RobotPts, G)
        % move there if no robot in the way and space is free
        retVal =  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
            && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
            && G.obstacle_pos( desVal(2),desVal(1) )==0;
    end

    function moveto(key)
        savePastPath(G.hRobotsPast10)
        try        updatePastPath(G.hRobotsPast10,G.hRobotsPast11); end
        try        updatePastPath(G.hRobotsPast9,G.hRobotsPast10); end
        try        updatePastPath(G.hRobotsPast8,G.hRobotsPast9); end
        try        updatePastPath(G.hRobotsPast7,G.hRobotsPast8); end
        try        updatePastPath(G.hRobotsPast6,G.hRobotsPast7); end
        try        updatePastPath(G.hRobotsPast5,G.hRobotsPast6); end
        try        updatePastPath(G.hRobotsPast4,G.hRobotsPast5); end
        try        updatePastPath(G.hRobotsPast3,G.hRobotsPast4); end
        try        updatePastPath(G.hRobotsPast2,G.hRobotsPast3); end
        try        updatePastPath(G.hRobotsPast,G.hRobotsPast2); end
        % Maps keypresses to moving pixels
        step = [0,0];
        if strcmp(key,'r')  %RESET
            RobotPts = initP;
            for ni = 1:size(RobotPts,1)
                set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                uistack(G.hRobots(RobotPts(ni,3)),'top');
            end
            return
        end
        
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
        for ni = 1:size(RobotPts,1)
            stVal = RobotPts(ni,1:2);
            desVal = RobotPts(ni,1:2)+step;
            
            % move there if no robot in the way and space is free
            if numel( RobotPts(ni,:))>5
                
                %1 augment RobotPts to include all additional blocks except
                %this moving block
                sRobotPts =  [];
                for i1 = [1:ni-1,ni+1:numel(RobotPts(:,1))]
                    for i2 = 1:RobotPts(i1,5)
                        for i3 = 1:RobotPts(i1,6)
                            sRobotPts(end+1,:) = [RobotPts(i1,1)+i2-1, RobotPts(i1,2)+i3-1];
                        end
                    end
                end
                moveOk = true;
                while moveOk
                    %2.) create a list of coordinates for each section of the
                    %moved block
                    for i2 = 1:RobotPts(ni,5)
                        for i3 = 1:RobotPts(ni,6)
                            %3.) do any of the moving block hit?
                            moveOk = moveOk & spaceFreeWithNoRobot([RobotPts(ni,1)+i2-1+step(1), RobotPts(ni,2)+i3-1+step(2)], sRobotPts, G);
                        end
                    end
                    if moveOk
                        RobotPts(ni,1:2) = desVal;
                        desVal = RobotPts(ni,1:2)+step;
                    end
                end
                
            else
                while spaceFreeWithNoRobot(desVal, RobotPts, G)
                    RobotPts(ni,1:2) = desVal;
                    desVal = RobotPts(ni,1:2)+step;
                end
            end
            if ~isequal( stVal, RobotPts(ni,1:2) )
                x = min(stVal(1), RobotPts(ni,1));
                y = min(stVal(2), RobotPts(ni,2));
                xd = abs(stVal(1)- RobotPts(ni,1));
                yd = abs(stVal(2)- RobotPts(ni,2));
                if numel( RobotPts(ni,:))>5
                    xd = xd + RobotPts(ni,5)-1;
                    yd = yd + RobotPts(ni,6)-1;
                end
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[x-1/2,y-1/2,xd+1,yd+1],'Curvature',[1/(1+xd),1/(1+yd)]);
                uistack(G.hRobotsPast(RobotPts(ni,3)),'top');
                if numel( RobotPts(hi,:))>5
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,RobotPts(ni,5),RobotPts(ni,6)]);
                else
                    set(G.hRobots(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1]);
                end
            else
                set(G.hRobotsPast(RobotPts(ni,3)),'Position',[RobotPts(ni,1)-1/2,RobotPts(ni,2)-1/2,1,1],'Curvature',[1,1]);
            end
            
        end
        for ni = 1:size(RobotPts,1)
            uistack(G.hRobots(RobotPts(ni,3)),'top');
        end
        
    end
    function [blk,RobotPts] = possible() %#ok<DEFNU>
        % Figure 2: possible cell
        RobotPts = [
            5,3,1,1;
            6,3,2,2;
            ];
        blk=[1 1 1 1 1 1 1 1 1
            1 1 1 1 1 1 1 1 1
            1 1 0 0 0 0 0 1 1
            1 1 1 1 1 1 0 1 1
            1 1 1 1 1 1 1 1 1];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = simpleCoverage(n)
        % an nxn world with n robots that can cover it in 2 moves
        RobotPts = [(n+1+(1:n))',(n+1)*ones(n,1),(1:n)',(1:n)'];
        
        %             x   x'
        blk=ones(n+2,2*n+2);  %edges
        blk(2:n+1,2:n+1) = 0; %white space
        blk(2,n+1:2*n+1) = 0;  %starting points for robots
        
        blk = flipud(blk);
    end

%  function [blk,RobotPts] = multiPassCoverage(n)
%         % an nxn world with 5 robots  where should I put the obstacles?
%         m = 5;
%         RobotPts = [(n+1+n+1-(1:m))',(n+1)*ones(m,1),(1:m)',(1:m)'];
%
%         %             x   x'
%         blk=ones(n+2,2*n+2);  %edges
%         blk(2:n+1,2:n+1) = 0; %white space
%         %blk(2:n+1,n:n+5+1) = 0; %white space
%         blk(2,n+1:2*n+1) = 0;  %starting points for robots
%
%         blk = flipud(blk);
%        blk(n+1,1+2*m) = 2;
%        blk(2,m+1) = 2;
%        blk(n+1,2) = 2;
%  end
    function [blk,RobotPts] = multiPassCoverage(n)
        % an nxn world with 5 robots  where should I put the obstacles?
        m = 5;
        RobotPts = [(n+1+n+1-(1:m))',(n+1)*ones(m,1),(1:m)',(1:m)'];
        %             x   x'
        blk=ones(n+2,2*n+2);  %edges
        blk(2:n+1,2:n+1) = 0; %white space
        %blk(2:n+1,n:n+5+1) = 0; %white space
        blk(2,n+1:2*n+1) = 0;  %starting points for robots
        blk = flipud(blk);
        %place blocks to make coverage possible/easy, works for m=5, n=15
        % this Style results in (n/m)^2 blocks.
         for i = 1:floor(n/m)
             c = ceil(i/2);
             x = 1+n-i*m;
             if mod(i,2) == 1
               %for j = 1:c
                if(i>1) 
                    blk(n+2-(1:c-1),1+x) = 2;
                end
                if x >1
                    blk(n+2-(1:c),x) = 2;
                end
               
             else
               if(i>2) 
                    blk(1+(1:c-1),1+x) = 2;
               end
                if x >1
                blk(1+(1:c),x) = 2;
                end
             end
         end
         
%         %%% , lots of little triangles  not great either -- takes more and more
%                 blk(n+1,1+n-1*m) = 2;
%         
%                 for i =2:m %dr
%                    blk(0+i,1+n-1*m+i) = 2;
%                 end
%                 for i =1:m %dl
%                    blk(1+i,1+n-1*m-i) = 2;
%                 end
%                 for i =2:m %ur
%                    blk(n-m+i+1,3+n-1*m-i) = 2;
%                 end
%                 for i =1:m %ul
%                    blk(n-m+i+1,0+n-3*m+i) = 2;
%                 end
    end

    function [blk,RobotPts] = multiPassCoverageX(n)
        % an nxn world with 5 robots  where should I put the obstacles?
        m = 1;
        RobotPts = [(n+1+n+1-(1:m))',(n+1)*ones(m,1),(1:m)',(1:m)'];
        %             x   x'
        blk=ones(n+2,2*n+2);  %edges
        blk(2:n+1,2:n+1) = 0; %white space
        %blk(2:n+1,n:n+5+1) = 0; %white space
        blk(2,n+1:2*n+1) = 0;  %starting points for robots
        blk = flipud(blk);
        %place blocks to make coverage possible/easy, works for m=5, n=15
        % this Style results in (n/m)^2 blocks.
         for i = 1:floor(n/m)
             c = ceil(i/2);
             x = 1+n-i*m;
             yof = 0;
             if x<n/2
                 yof = 1;
             end
             if mod(i,2) == 1
               %for j = 1:c
                if(i>1) 
                    %blk(n+2-(c-1),1+x) = 2;
                end
                if x >1
                    blk(n+2-i-(0:1)+yof,x) = 2;
                    blk(n+2-i-(0:1)+yof,x-1) = 2;
                end
               
             else
               if(i>2) 
                    %blk(1+(c-1),1+x) = 2;
               end
                if x >1
                blk(1+i-(0:1)+yof,x) = 2;
                blk(1+i-(0:1)+yof,x-1) = 2;
                end
             end
         end
         blk( ceil(n/2)+1,ceil(n/2)+(1)) = 0;
         blk( ceil(n/2)+1,ceil(n/2)+(0)) = 0;
         blk( ceil(n/2)+2,ceil(n/2)+(0)) = 0;
    end

function [blk,RobotPts] = multiPassCoverageSpiral(n)
        % an nxn world with 5 robots  where should I put the obstacles?
        m = 5;
        RobotPts = [(n+1+n+1-(1:m))',(n+1)*ones(m,1),(1:m)',(1:m)'];   
        %             x   x'
        blk=ones(n+2,2*n+2);  %edges
        blk(2:n+1,2:n+1) = 0; %white space
        %blk(2:n+1,n:n+5+1) = 0; %white space
        blk(2,n+1:2*n+1) = 0;  %starting points for robots
        blk = flipud(blk);
        % spiral pattern  -- covers m/(m+1) of the free space, requires 
        % (1+(n/(4*m)))*4*m blocks
        rm = n+2;
        lm = 1;
        um = 1;
        dm = n;
        for j = 0:ceil(n/(4*m))
            ost = j*(m+1);

            for i =1:m %dl    bl(y,x)
                x = 1+i+ost;
                y = 1+m-i+ost;
                 if y<dm && x<rm-1 && y>1
                    blk(y,x) = 2;
                    if y>um
                        um = y;
                    end
                    if x>lm
                         lm = x;
                     end
                 end
                
            end
            for i =1:m %dr
                y = i+ost+1;
                x = n-m+i+1-ost+1;
                if x<n+2 && x>lm
                   blk(y,x) = 2;
                   if x < rm
                       rm = x;
                   end
                end
                
            end
            for i =1:m %ur
                x = n-m+i+1-ost;
                y = n-i+1-ost;
                if x > floor(n/2) && y > floor(n/2)
                     blk(y,x) = 2;
                     if x<rm
                         rm = x;
                     end
                end
               
            end
            for i =1:m %ul
                y = n-i-ost;
                x = 2+2*m-i+ost;
                if y>um %y > floor(n/2)  && x <= floor(n/2)
                    if x>rm
                        for k =1:m %ur
                            x = n-2*m+k+1-ost;
                            y = n+k-m-ost;
                            if x>lm+1%x > floor(n/2) %&& y > floor(n/2)
                                 blk(y,x) = 2;
                            end
                        end
                        
                        
                        return
                    end
                    blk(y,x) = 2;
                    if y<dm
                        dm = y;
                    end
                    if x>lm
                        lm = x;
                    end
                end
                
            end
        end
    end


    function [blk,RobotPts] = simpleConverge(n,k)
        % an nxn world with k robots that can converge in 2 moves
        pos = randperm(n^2,k);
        RobotPts = [2+floor((pos-1)/n)',2+mod(pos,n)',(1:k)',(1:k)'];
        
        %             x   x'
        blk=ones(n+2,n+2);  %edges
        blk(2:n+1,2:n+1) = 0; %white space
        
        blk = flipud(blk);
    end

    function [blk,RobotPts] = ConvergeCenter()
        % an nxn world with k robots that can converge all robots to center
        %
        
        numrobots = 4;
        
        %             blk=[1 1 1 1 1 1 1 1 1 1 1 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 0 0 0 0 0 0 0 0 0 0 1;
        %              1 1 1 1 1 1 1 1 1 1 1 1;];
        
        %I need an arrangement and an input sequence of moves that is guaranteed to
        %place robots in correct place.
        %
        %   15 moves:
        % (move all particles to top right): r,u, r,u,r
        % (move all particles horizontal line from left top): l,u,l,u,l,u,l
        % (separate the row into individual columns): d
        % (form final block): r
        % (move up): u
        
        blk=[1 1 1 1 1 1 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 2 0 0 0 0 1;
            1 0 0 0 0 0 2 0 0 0 0 1;
            1 0 0 0 0 2 2 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 2 0 0 0 1;
            1 2 2 0 0 0 0 2 0 0 0 1;
            1 1 1 1 1 1 1 1 1 1 1 1;];
        blk = flipud(blk);
        
        pos = zeros(numrobots,2);
        %randomly place robots not on obstacles and not overlapping
        for i=1:numrobots
            p = randi(10,[1,2]) + [1,1];
            while (blk(p(2),p(1)) ~= 0) || sum(ismember(pos,p,'rows'))
                display(['Block:',num2str(blk(p(1),p(2)))])
                p = randi(10,[1,2]) + [1,1];
            end
            pos(i,:) = p;
        end
        RobotPts = [pos,(1:numrobots)',(1:numrobots)'];
    end
end