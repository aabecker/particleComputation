function chooseKpermutations
%  allow users to switch between different permutations.
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
MAKE_MOVIE = false;
G.fig = figure(1);
G.numCommands = 0;
G.totalMoves = 0;
if MAKE_MOVIE
    set(G.fig ,'Name','Massive Control','color',[1,1,1]); %#ok<UNRCH>
else
    set(G.fig ,'KeyPressFcn',@keyhandler,'Name','Massive Control');
end

%create obstacle map and draw it
%G.obstacle_pos = flipud(NOTGate());


A =[1,0,1;  %'A'
    0,1,0;
    0,0,0;
    0,1,0;
    0,1,0]';



G.perm(:,:,1) =   [0,0,1; %'B'
    0,1,0;
    0,0,1;
    0,1,0;
    0,0,1]';
G.perm(:,:,2) =[ ...
    0,0,0; %'C'
    0,1,0;
    0,1,1;
    0,1,1;
    0,0,0]';
G.perm(:,:,3) =[0,0,1; %'D'
    0,1,0;
    0,1,0;
    0,1,0;
    0,0,1]';
G.perm(:,:,4) =[0,0,0; %'E'
    0,1,1;
    0,0,1;
    0,1,1;
    0,0,0]';

[G.Ai, G.P1, G.Ac, G.Bc] = assignCorrespondencies(A,G.perm(:,:,1));
[G.Ai, G.P2, G.Ac, G.Bc] = assignCorrespondencies(A,G.perm(:,:,2));
[G.Ai, G.P3, G.Ac, G.Bc] = assignCorrespondencies(A,G.perm(:,:,3));
[G.Ai, G.P4, G.Ac, G.Bc] = assignCorrespondencies(A,G.perm(:,:,4));
G.EMPTY = 0;
G.OBST = 1;
%assignCorrespondencies(A,B);
setupCourse();

G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

numRobots = numel(G.Ac);
clf

G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    %0.5,0.5,0.5;
    %1,0,0;
    ];

colormap(G.colormap);
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
%set(G.axis,'edgealpha',.08)
axis equal
axis tight
G.title = title('press arrows keys to move');


%end
G.hRobotsPast8 = zeros(1, numRobots);
G.hRobotsPast7 = zeros(1, numRobots);
G.hRobotsPast6 = zeros(1, numRobots);
G.hRobotsPast5 = zeros(1, numRobots);
G.hRobotsPast4 = zeros(1, numRobots);
G.hRobotsPast3 = zeros(1, numRobots);
G.hRobotsPast2 = zeros(1, numRobots);
G.hRobotsPast = zeros(1, numRobots);
G.hRobots = zeros(1, numRobots);

colors = hsv(numel(unique(RobotPts(:,4)))+1);

for hi = 1: numRobots
    G.hRobotsPast8(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.10);
    G.hRobotsPast7(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.15);
    G.hRobotsPast6(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.25);
    G.hRobotsPast5(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.35);
    G.hRobotsPast4(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.45);
    G.hRobotsPast3(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.55);
    G.hRobotsPast2(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.65);
    G.hRobotsPast(RobotPts(hi,3)) =  createRobotPath( RobotPts(hi,:), 0.75);
    G.hRobots(RobotPts(hi,3)) =  rectangle('Position',[RobotPts(hi,1)-1/2,RobotPts(hi,2)-1/2,1,1],'Curvature',[1,1],'FaceColor',colors(RobotPts(hi,4),:));
    
end
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
        updatePastPath(G.hRobotsPast7,G.hRobotsPast8);
        updatePastPath(G.hRobotsPast6,G.hRobotsPast7);
        updatePastPath(G.hRobotsPast5,G.hRobotsPast6);
        updatePastPath(G.hRobotsPast4,G.hRobotsPast5);
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

    function setupCourse()
        perms = size(G.perm,3);
        lvls = ceil(log(perms)/log(2));
        
        % set up switching section (to choose between k permutations
        [ar,ac] = size(G.Ac);
        [br,bc] = size(G.Bc);
        offsetY =  max(br+1, ar +1); %height of move 4 stoppers
        G.r = (perms)*(ar*ac+1)+ar+lvls*ar+1;%how tall?
        offsetX =  max(bc,ac);
        G.c= (lvls+1)*(ac+1)+2*ac*ar;  %how wide?
        % we want 16/9 = 1.7778
        %display([G.c,G.r])
        
        %robot_pos=G.EMPTY*ones(G.r,G.c); %initialize grid to be empty
        G.obstacle_pos=G.EMPTY*ones(G.r,G.c);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% place the robots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %robot_pos(1+(1:ar)+exHt,1+(1:ac)+exWd)=G.OBST+ G.A;
        [xind,yind] = meshgrid(1+(1:ar),1+(1:ac));
        RobotPts = [ reshape(yind,numel(G.Ac),1), reshape(xind,numel(G.Ac),1),(1:numel(G.Ac))',  reshape( (G.Ac'),numel(G.Ac),1)]; %(1:numel(G.A))'
        
        %place the obstacles%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        G.obstacle_pos(1+(1:br),1) =G.OBST; %move 4 (vertical line) %needs br blocks, move offsetX+(bc-1)*(2*br)+br
        G.obstacle_pos(1,1+(1:bc)) =G.OBST; %move 5 (horizontal line)  %(not a move, but looks nice) needs bc blocs,
        %TODO for each level:
        % horizontal stopper(s)
        for l = 1:lvls
            for obs = 1:2^(l-1)
                %display([l,obs,(-1)^(obs+l)])
                vertpos = ar+1 + ((2*obs-1)*perms*(ac*ar+ac))/2^(l);
                if (2*obs-1) /2^(l) > 1/2
                    vertpos = vertpos+ar+1;
                end
                horzpos = 1+(ac+1)*(l+1);
                G.obstacle_pos(vertpos ,horzpos-2*(ac+1)+(1:bc)) = G.OBST; %move 5 (horizontal line)  %(not a move, but looks nice) needs bc blocs,
                flipped = (-1)^(obs+1);
                if l == 1
                    flipped = -1;
                end
                G.obstacle_pos(vertpos+flipped*(1:br),horzpos) =G.OBST; %move 4 (vertical line) %needs br blocks, move offsetX+(bc-1)*(2*br)+br
                if l == lvls
                    %up
                    for i = 1:ac
                        G.obstacle_pos( -flipped*ar*i+vertpos,horzpos+i-ac-1) =G.OBST;  %move 1 (horizontal stops) needs ar blocks, move (offsetY-ar) + ar*ac
                    end
                    % set up each permutation
                    if flipped == -1
                        setupObstacles(ar,ac,bc,lvls,offsetY+vertpos-(br+2),1, G.P1);
                        setupObstacles(ar,ac,bc,lvls,offsetY+vertpos-(ar+br+1), -1, G.P2);
                    else
                        setupObstacles(ar,ac,bc,lvls,offsetY+vertpos-1,1, G.P3);
                        setupObstacles(ar,ac,bc,lvls,offsetY+vertpos-(ar), -1, G.P4);
                    end
                    %down
                    for i = 1:ac
                        G.obstacle_pos( flipped*(ar*(i+1)+1)+vertpos,horzpos+i-ac-1) =G.OBST;  %move 1 (horizontal stops) needs ar blocks, move (offsetY-ar) + ar*ac
                    end
                    
                end
            end
        end
        % vertical stoppers(2)
        for Br = 1:br%move 3 (step stones), needs ar*ac blocks, move offsetY + ar*ac  -1
            for Bc = 1:bc      % vertical      , horiz
                G.obstacle_pos( Br, (lvls+1)*(ac+1)+  Bc*2 + (Br-1)*(2*bc)) = G.OBST;
            end
        end
    end

    function setupObstacles(ar,ac,bc,lvls,offsetY, invert, Bi)
        for n = 1:numel(G.Ai)  %move 2: stop at correct width  (this is the only section that changes), needs ar*ac blocks, move offsetX+(bc-1)*(2*br)+2*(bc)
            [Br,Bc] = find( Bi == n);
            %Bc is the desired column to end up in,
            %Br is the desired row to end in
            % vertical                  , horiz
            if invert == -1
                n2 = [13,14,15,10,11,12,7,8,9,4,5,6,1,2,3];
                G.obstacle_pos(offsetY+n2(n)-numel(G.Ai)-1,  1+(lvls+1)*(ac+1)+(Br-1)*(2*bc)+2*(Bc)) = G.OBST+1;
            else
            G.obstacle_pos(offsetY+n,  1+(lvls+1)*(ac+1)+(Br-1)*(2*bc)+2*(Bc)) = G.OBST;
            end
            %[Ac,Ar] = find( G.Ai == n); %identity
        end
    end


    function [Ai, Bi, Ac, Bc] = assignCorrespondencies(A,B)
        %Ai and Bi are indexed sets that specify the desired permutation
        %A and B are matrices with each cell labelled with a number 1..k
        %corresponding to the color.
        A=flipud(A);
       % B=flipud(B);
        %assign correspondences between A and B
        Ai = reshape(1:numel(A),size(A));
        Bi = zeros(size(B));
        Ac = zeros(size(A));
        Bc = zeros(size(B));
        uniqA = unique(A);

        for i = 1:numel(uniqA)  %with 3 colors, even the best switching array may take 6 iterations to reset.
            indB = (B==uniqA(i)); %i.e. find all the red B values
            indA = (A==uniqA(i)); %     find all the red A values

            Bi(indB) = Ai(indA);
            Ac(indA) = i;
            Bc(indB) = i;
        end
        
        
        if numel(uniqA) ==2  %then generate a two-step transformation.  This is always possible for 2 colors and two desired shapes
            Ai = reshape(1:numel(A),size(A));
            Bi = zeros(size(B));
            Ac = zeros(size(A));
            Bc = zeros(size(B));
            
            T = zeros(size(A));
            for i = 1:numel(A)
                if T(i) == 0
                    T(i) = 1;
                    if B(i) == A(i)
                        Bi(i) = Ai(i);
                        Ac(i) = find(uniqA == A(i));
                        Bc(i) = find(uniqA == A(i));
                    else
                        Bind = find(  B == A(i) & B ~= A & T == 0,1); %find first untouched item in B that mathces A
                        T(Bind) = 1;
                        
                        Bi(Bind) = Ai(i);
                        Ac(i)    = find(uniqA== A(i));
                        Bc(Bind) = find(uniqA== A(i));
                        
                        Bi(i)   = Ai(Bind);
                        Ac(Bind) = find(uniqA== A(Bind));
                        Bc(i)    = find(uniqA== A(Bind));
                    end
                end
            end
        end
    end

end