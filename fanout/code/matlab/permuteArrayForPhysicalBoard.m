function permuteArrayForPhysicalBoard(A,B)
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
    % Author: Aaron Becker, Summer 2013
    %
    % Sample Video output: http://www.youtube.com/watch?v=3tJdRrNShXM
    % Hardware Experiment: http://www.youtube.com/watch?v=eExZO0HrWRQ
    % Companion to ICRA 2014 paper:
    %"Particle Computation: Designing Worlds to Control Robot Swarms with only Global Signals"
    % by  Aaron Becker, Erik D. Demaine, Sa ?ndor P. Fekete, James McLurkin
    % Paper Abstract—Micro- and nanorobots are often controlled by global input signals, such as an electromagnetic or gravitational field. These fields move each robot maximally until it hits a stationary obstacle or another stationary robot. This paper investigates 2D motion-planning complexity for large swarms of simple mobile robots (such as bacteria, sensors, or smart building material).
    % In previous work we proved it is NP-hard to decide whether a given initial configuration can be transformed into a desired target configuration; in this paper we prove a stronger result: the problem of finding an optimal control sequence is PSPACE-complete. On the positive side, we show we can build useful systems by designing obstacles. We present a reconfigurable hardware platform and demonstrate how to form arbitrary permutations and build a compact absolute encoder. We then take the same platform and use dual-rail logic to build a universal logic gate that concurrently evaluates AND, NAND, NOR and OR operations. Using many of these gates and appropriate interconnects we can evaluate any logical expression.
    % ICRA video: http://youtu.be/mJWl-Pgfos0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global G MAKE_MOVIE RobotPts
    
    format compact
    MAKE_MOVIE = false;
    G.fig = figure(1);
    clf
    G.numCommands = 0;
    G.totalMoves = 0;
    set(G.fig ,'Name','(Particle Computation) Designing Worlds to Control Robot Swarms with only Global Signals','color',[1,1,1]);
    if ~MAKE_MOVIE
        set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
    end
    axes('position', [0 0 1 1]) %remove margins
    %create obstacle map and draw it
    if nargin < 2
        outputSym = 7; % three pre-programmed arrangements
        if outputSym ==6
            % % Capital '+','x'
            A =[0,1,0;
                1,0,1;
                0,1,0,];
            B =[1,0,1;
                0,0,0;
                1,0,1];
        elseif outputSym ==7
            % % Capital '+','x'
            A =[1,2,3;
                4,5,6;
                7,8,9,];
            B =[4,1,2;
                7,5,3;
                8,9,6];
    elseif outputSym ==1
            % % Capital 'A' -> 'B'
            A =[1,1,0,1,1;
                1,0,1,0,1;
                1,0,0,0,1;
                1,0,1,0,1;
                1,0,1,0,1];
            B =[1,0,0,1,1;
                1,0,1,0,1;
                1,0,0,1,1;
                1,0,1,0,1;
                1,0,0,1,1];
        elseif outputSym == 2
            % Changes 'A' -> 'b'
            A =[1,0,1;
                0,1,0;
                0,0,0;
                0,1,0;
                0,1,0];
            B =[0,1,1;
                0,1,1;
                0,0,0;
                0,1,0;
                0,0,0];
        elseif outputSym == 3
            % Changes 'A' -> 'b'
            A =[0 0 1 1 1 1 0 0
                0 1 0 0 0 0 1 0
                1 0 1 0 1 0 0 1
                1 0 1 0 1 0 0 1
                1 0 0 0 0 1 0 1
                1 0 1 1 1 0 0 1
                0 1 0 0 0 0 1 0
                0 0 1 1 1 1 0 0
                ];
            B =[0 0 1 1 1 1 0 0
                0 1 0 0 0 0 1 0
                1 0 1 0 0 1 0 1
                1 0 0 0 0 0 0 1
                1 0 1 1 1 1 0 1
                1 0 0 1 1 0 0 1
                0 1 0 0 0 0 1 0
                0 0 1 1 1 1 0 0
                ];
        else
            %'R'->'D', repeates every 740 iterations
            A =[4,4,4,4,4,4,4,4,4,4;
                4,2,2,2,2,2,2,4,4,1;
                4,2,3,4,4,4,4,2,3,1;
                4,2,3,4,4,4,4,2,3,1;
                4,2,2,2,2,2,2,1,1,1;
                4,2,2,4,2,3,1,1,1,1;
                4,2,3,4,1,2,3,1,1,1;
                4,2,3,1,1,1,2,3,1,1;
                4,2,3,1,1,1,1,2,2,1;
                1,1,1,1,1,1,1,1,1,1];
            B =[1,1,1,1,1,1,1,1,1,1;
                1,2,2,2,2,2,2,1,1,4;
                1,2,3,1,1,1,2,2,4,4;
                1,2,3,1,1,1,1,2,3,4;
                1,2,3,1,1,1,4,2,3,4;
                1,2,3,1,1,4,4,2,3,4;
                1,2,3,1,4,4,4,2,3,4;
                1,2,3,4,4,4,2,2,4,4;
                1,2,2,2,2,2,2,4,4,4;
                1,4,4,4,4,4,4,4,4,4];
        end
        %for all:
        A = flipud(A);
        B = flipud(B);
    end
    G.EMPTY = 0;
    G.OBST = 1;
    assignCorrespondencies(A,B);
    setupObstacles();
    r = sum(G.obstacle_pos,2); %rows
    c = sum(G.obstacle_pos); %cols
    G.rmax = find(r>0,1,'last')-find(r>0,1,'first');
    G.cmax = find(c>0,1,'last')-find(c>0,1,'first');
    display(['height=', num2str(G.rmax),...
        ' width=',num2str(G.cmax)])
    
        G.maxX = size(G.obstacle_pos,2);
    G.maxY = size(G.obstacle_pos,1);
   
    numRobots = size(RobotPts,1);
    G.colormap = [  1,1,1; %Empty = white
        0,0,0; %obstacle
        ];
    
    colormap(G.colormap);
    G.axis=imagesc(G.obstacle_pos);
    set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','on','xcolor',get(gcf,'color'),'ycolor',get(gcf,'color'))
    if MAKE_MOVIE == true
        set(gca,'Visible','off')
    end
    %set(G.axis,'edgealpha',.08)
    axis equal
    axis tight
    
    G.title = title('press arrow keys (\leftarrow,\uparrow,\downarrow,\rightarrow) to move');
    
    G.hRobotsPast2 = zeros(1, numRobots);
    G.hRobotsPast = zeros(1, numRobots);
    G.hRobots = zeros(1, numRobots);
    uniqueRobots = numel(unique(RobotPts(:,4)));
    if uniqueRobots ~=2
        %colors = hsv(uniqueRobots);
        colors = [1,0,0; 0,0,1; 0,0,1; 0,1,0; 0,0,1; 0,0,1; 0,1,0; 0,0,1; 0,0,1;];
    else
        colors = [1,0,0; 0,0,1; .5,0,.5;];
    end
    for hi = 1: numRobots
        G.hRobotsPast2(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(RobotPts(hi,4),:))*.2,'LineStyle','none');
        G.hRobotsPast(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(RobotPts(hi,4),:))*.5,'LineStyle','none');
        G.hRobots(hi) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
    end
    
    function keyhandler(src,evnt) %#ok<INUSL>
        if strcmp(evnt.Key,'s')
            imwrite(flipud(get(G.axis,'CData')+1), G.colormap, '../../pictures/png/MatrixPermutePic.png');
        else
            moveto(evnt.Key)
        end
    end
    
    function moveto(key)
        % update past
        for ni = 1:size(RobotPts,1)
            set(G.hRobotsPast2(ni),'Position', get(G.hRobotsPast(ni),'Position'), ...
                'Curvature', get(G.hRobotsPast(ni),'Curvature'));
            uistack(G.hRobotsPast2(RobotPts(ni,3)),'top');
        end
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
        for ni = 1:size(RobotPts,1)
            stVal = RobotPts(ni,1:2);
            desVal = RobotPts(ni,1:2)+step;
            
            % move there if no robot in the way and space is free
            while  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
                    && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
                    && G.obstacle_pos( desVal(2),desVal(1) )==0
                
                RobotPts(ni,1:2) = desVal;
                desVal = RobotPts(ni,1:2)+step;
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
        end
        
    end
    
    function assignCorrespondencies(A,B)
        
        %assign correspondences between A and B
        G.Ai = reshape(1:numel(A),size(A));
        G.Bi = zeros(size(B));
        G.A = zeros(size(A));
        G.B = zeros(size(B));
        [G.C] = unique(A);
        for i = 1:numel(G.C)  %with 3 colors, even the best switching array may take 6 iterations to reset.
            indB = (B==G.C(i)); %i.e. find all the red B values
            indA = (A==G.C(i)); %     find all the red A values
            G.Bi(indB) = G.Ai(indA);
            G.A(indA) = i;
            G.B(indB) = i;
        end
        
        
        if numel(G.C) ==2  %then generate a two-step transformation.  This is always possible for 2 colors and two desired shapes
            G.Ai = reshape(1:numel(A),size(A));
            G.Bi = zeros(size(B));
            G.A = zeros(size(A));
            G.B = zeros(size(B));
            [G.C] = unique(A);
            % it is often impossible for more than 2 desired shapes {"O","W","L"},
            % RICE, UIC, all failed for me.
            G.T = zeros(size(A));
            for i = 1:numel(A)
                if G.T(i) == 0
                    G.T(i) = 1;
                    if B(i) == A(i)
                        G.Bi(i) = G.Ai(i);
                        G.A(i) = find(G.C == A(i));
                        G.B(i) = find(G.C == A(i));
                    else
                        Bind = find(  B == A(i) & B ~= A & G.T == 0,1); %find first untouched item in B that mathces A
                        G.T(Bind) = 1;
                        
                        G.Bi(Bind) = G.Ai(i);
                        G.A(i)    = find(G.C == A(i));
                        G.B(Bind) = find(G.C == A(i));
                        
                        G.Bi(i)   = G.Ai(Bind);
                        G.A(Bind) = find(G.C == A(Bind));
                        G.B(i)    = find(G.C == A(Bind));
                    end
                end
            end
        end
    end
    
    function setupObstacles()
        %%% Sets up the obstacles needed to form permutation from A to B
        
        [ar,ac] = size(G.A);
        [br,bc] = size(G.B);
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
        
        G.obstacle_pos=G.EMPTY*ones(G.r,G.c);  %initialize grid to be empty
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% place the robots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [xind,yind] = meshgrid(1+(1:ar)+exHt,1+(1:ac)+exWd);
        RobotPts = [ reshape(yind,numel(G.A),1), reshape(xind,numel(G.A),1),(1:numel(G.A))', reshape( (G.A'),numel(G.A),1)];
        
        %place the obstacles%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = 1:ac
            G.obstacle_pos(offsetY + ar*i+1+exHt,1+i+exWd ) =G.OBST;  %move 1 (horizontal stops) needs ar blocks, move (offsetY-ar) + ar*ac
        end
        G.m1 = (offsetY-ar) + ar*ac;
        
        for n = 1:numel(G.Ai)  %move 2: stop at correct width  (this is the only section that changes), needs ar*ac blocks, move offsetX+(bc-1)*(2*br)+2*(bc)
            [Br,Bc] = find( G.Bi == n);
            %Bc is the desired column to end up in,
            %Br is the desired row to end in
            % vertical                   , horiz
            G.obstacle_pos(offsetY+n+exHt,  1+offsetX+(Br-1)*(2*bc)+2*(Bc)+exWd) = G.OBST;
            %G.obstacle_pos(offsetY+n+exHt,1+offsetX+(Bc-1)*(2*br)+2*(Br)+exWd) = G.OBST;
            %[Ac,Ar] = find( G.Ai == n); %identity
        end
        G.m2 = offsetX+(bc-1)*(2*br)+2*(bc);
        %
        %         for Br = 1:br%move 3 (step stones), needs ar*ac blocks, move offsetY + ar*ac  -1
        %             for Bc = 1:bc      % vertical      , horiz
        %                 G.obstacle_pos( Br+exHt,   Bc*2 +  offsetX + (Br-1)*(2*bc)+exWd) = G.OBST;
        %                 %G.obstacle_pos( Br*2-1+exHt,   Br*2 +  offsetX + (Bc-1)*(2*br)+exWd) =G.OBST;
        %             end
        %         end
        for n = 1:numel(G.Ai)
            G.obstacle_pos( 1+floor((n-1)/bc)+exHt,    offsetX + exWd + 2*n) =  G.OBST;
        end
        
        G.m3 = offsetY + ar*ac  -1;
        
        G.obstacle_pos(1+(1:br)+exHt,1+exWd) =G.OBST; %move 4 (vertical line) %needs br blocks, move offsetX+(bc-1)*(2*br)+br
        G.m4 =offsetX+(bc-1)*(2*br)+br;
        G.obstacle_pos(1+exHt,1+(1:bc)+exWd) =G.OBST; %move 5 (horizontal line)  %(not a move, but looks nice) needs bc blocs,
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end