function gadgets
% @brief: demonstrates several gadgets for "Particle Computation: Designing Worlds
% To Control Robot Swarms with only Global Signals"  See paper at
% https://github.com/aabecker/particleComputation/blob/master/fanout/FanOutgatesAndBinaryCounters.pdf
% And video at http://youtu.be/EJSv8ny31r8
%
% @author; Aaron Becker, atbecker@uh.edu
%
%  These 'gadgets' manipulate particles (also called robots) according to
%  THREE LAWS:
%  1.) everything is on a planar, square grid, with unit-sized robots (in color)
%  and fixed, unit-size blocks (black)
%  2.) Valid commands are "Go Up" (u), "Go Down" (d), "Go Left" (l),
%  "Go Right" (r)
%  3.) All robots move in the commanded direction until they hit an
%  obstacle or another robot.
%
%  To play:
%       1.) uncomment a gadget below "STEP 1: create Workspace"
%       2.) run the code, use arrow keys or {'u','r','d','l'} keyboard
%       letters to move the robots
%       3.) design your own obstacle map.
%
%
% My goal is to do everything with the input
% sequence {D,L,D,R}
% TODO:
%   1.) the memory gate memorycw() is not conservative. This is not good
%   enough for a journal submission. It is not conservative.  I'd like to
%   represent state (true or false) by the position of a 2x1 slider.  This
%   slider may require more than 1 CW cycle.
%   2.) design a collection of obstacles and 2x1 sliders that work as a one-cycle delay:
% [ reservoir full of 1x1 components] --> [connecting line that feeds 1x1
% components] -->[ one-cycle-delay]
%
% OUTPUT:  every other CW cycle a 1x1 block comes out.  Currently we get a
% new component every CW cycle.  We'd like to get one every other cycle, or
% concatenate these to get a 1x1 output every n cycles.
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
strTitle = ''; %#ok<NASGU>
%

% STEP 1:  create Workspace (robots and obstacle map) and draw it
%%% Gates that use input sequence {d,l,d,r}
%[G.obstacle_pos,RobotPts] = ddNOTgate(); %BAD
%[G.obstacle_pos,RobotPts] = possible(); %BAD
%[G.obstacle_pos,RobotPts] = SAFEddNOTgate();  %For ICRA paper, we made this
%[G.obstacle_pos,RobotPts] = ddNOTandConnectorgate();
%[G.obstacle_pos,RobotPts] = ONEWAY_SAFEddNOTgate();
%[G.obstacle_pos,RobotPts] = FullAdderCarry();
%[G.obstacle_pos,RobotPts] = FullAdderSum();
%[G.obstacle_pos,RobotPts] = ddXORgate;
%[G.obstacle_pos,RobotPts] = SAFEddCNTgate;
%[G.obstacle_pos,RobotPts] = ONEWAY_SAFEddCNTgate;
%[G.obstacle_pos,RobotPts] = XORgate;
%[G.obstacle_pos,RobotPts] = NOTgate; %broken
%[G.obstacle_pos,RobotPts] = FANOUTgate; %works -- single rail with supply
%[G.obstacle_pos,RobotPts] = ddANDgate();
%[G.obstacle_pos,RobotPts] = maintainDLDR();
%[G.obstacle_pos,RobotPts,strTitle] = verySAFEddANDgate();  % the gate Artie built
%[G.obstacle_pos,RobotPts,strTitle] = verySAFEddANDgateSET();  % the gate Artie built
%[G.obstacle_pos,RobotPts,strTitle] = unSAFEddANDgateSET();  %NAND/NOR/OR/AND ICRA without oneways
%[G.obstacle_pos,RobotPts,strTitle] = unSAFEddFANOUT();  % fan-out gate?  Looks like memory
%[G.obstacle_pos,RobotPts] = VariableBlkIndexed(4);
%[G.obstacle_pos,RobotPts] = VariableBlk();
%[G.obstacle_pos,RobotPts] = SAFEVariableBlk();
%[G.obstacle_pos,RobotPts] = ONEWAY_mInANDgate();
%[G.obstacle_pos,RobotPts] = SandorsGadgetForCounting();
%[G.obstacle_pos,RobotPts] = SandorsGadgetForCountingV2();
%[G.obstacle_pos,RobotPts] = ONEWAY_3InORgate();

%%% CLOCKWISE GATES {d,l,u,r}
%[G.obstacle_pos,RobotPts,strTitle] = ddFANOUTcw();  % CW fan-out gate
%[G.obstacle_pos,RobotPts,strTitle] = ddFANOUTcw4();  % CW fan-out gate
%[G.obstacle_pos,RobotPts] = ddXORgatecw; %sum bit
%[G.obstacle_pos,RobotPts] = memorycw; %memory
%[G.obstacle_pos,RobotPts] = ddANDgatecw();  %NAND/NOR/OR/AND
%[G.obstacle_pos,RobotPts] = ddCarrycw();
%[G.obstacle_pos,RobotPts] = singleCycleDelay();
[G.obstacle_pos,RobotPts] = DialsGate();
%[G.obstacle_pos,RobotPts] = partHopper()
G.EMPTY = 0;
G.OBST = 1;


G.maxX = size(G.obstacle_pos,2);
G.maxY = size(G.obstacle_pos,1);

%create vector of robots and draw them.  A robot vector consists of an xy
%position, an index number, and a color.

numRobots = size(RobotPts,1);

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
set(gcf,'Position',[4 260 1897 728])
set(gca,'Position',[0 0 1 1])
%axis tight
hold on
%set(G.fig, 'Position',[1 41 1920 964])
%tightfig
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
colors = [1,0,0;0,0,1; 1,.5,1; .5,0,.5;];


for hi = 1: numRobots
    G.hRobotsPast11(hi) =  createRobotPath( RobotPts(hi,:), 0.20);
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

    function handleRobotPath = createRobotPath( robotInfo, fractionColor)
        % creates a robot path variable
        handleRobotPath =  rectangle('Position',[robotInfo(1)-1/2,robotInfo(2)-1/2,1,1],'Curvature',[1,1],'FaceColor',[1,1,1]-([1,1,1]-colors(robotInfo(4),:))*fractionColor,'LineStyle','none');
    end

    function handleRobotPath = BLUEcreateRobotPath( robotInfo, fractionColor) %#ok<DEFNU>
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

    function retVal = spaceFreeWithNoRobot(desVal, RobotPts, G)
        % move there if no robot in the way and space is free
        retVal =  ~ismember(desVal,RobotPts(:,1:2),'rows')  ...
            && desVal(1) >0 && desVal(1) <= G.maxX && desVal(2) >0 && desVal(2) <= G.maxY ...
            && G.obstacle_pos( desVal(2),desVal(1) )==0;
    end

    function moveto(key)
        updatePastPath(G.hRobotsPast10,G.hRobotsPast11);
        updatePastPath(G.hRobotsPast9,G.hRobotsPast10);
        updatePastPath(G.hRobotsPast8,G.hRobotsPast9);
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
        drawnow; pause(0.05);  % this innocent line prevents the Matlab hang
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

    function [blk,RobotPts] = ddNOTgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            7,11,2,2;
            ];
        %             x   x'
        blk=[1 1 1 1 0 1 0 1 1 1 1
            1 1 0 0 0 0 0 1 1 1 1
            1 1 0 1 0 1 1 1 1 1 1
            1 1 0 1 0 0 0 1 1 1 1
            1 1 0 1 1 1 0 1 1 1 1
            1 1 0 0 0 1 0 1 1 1 1
            1 1 1 1 0 1 0 1 1 1 1
            1 1 1 1 0 1 0 1 1 1 1
            1 1 1 1 0 1 0 1 1 1 1
            1 1 1 1 0 1 0 1 1 1 1
            1 1 1 1 0 1 0 1 1 1 1];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = XORgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [ % x,y,color, num, w,h
            3,9,1,1,1,1;  %X input
            6,9,2,2,1,1;  %Y input
            12,9,3,3,1,1; %supply
            13,5,4,4,2,1; %slider
            ];
        for i = 1:numel(RobotPts(:,1))
            RobotPts(i,3) = i;
            RobotPts(i,4) = i;
        end
        %               x     x'
        %         blk=[1 1 1 0 1 0 1 1 1 0 1 1
        %             1 1 1 0 1 0 0 0 0 0 0 0
        %             1 1 1 0 1 0 0 0 0 1 0 1
        %             1 0 0 0 0 0 0 0 0 0 0 1
        %             1 1 1 1 0 1 1 1 1 1 1 1
        %             1 1 1 1 0 0 1 1 1 1 1 1
        %             1 1 1 1 1 0 1 1 1 1 1 1
        %             1 1 1 1 1 0 1 1 1 1 1 1];
        blk=[1 1 0 1 1 0 1 1 1 1 1 0 1 1 1
            1 1 0 1 0 0 0 1 1 1 0 0 0 1 1
            1 0 0 0 1 1 0 1 1 1 1 1 0 1 1
            1 1 1 0 1 1 0 1 1 1 1 1 0 1 1
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1
            1 1 1 1 0 1 1 1 1 0 0 0 1 0 1
            1 1 1 1 0 1 0 0 0 0 0 0 0 0 0
            1 1 1 0 0 0 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 0 1 1 1 1 1 1 1 1 1];
        blk = flipud([blk, repmat(blk(:,end),1,5)]);
    end
    function [blk,RobotPts] = NOTgate() %#ok<DEFNU>
        % uses a 2x1 block and supply bit to create a NOT gate
        % want 1->0, 0->1
        RobotPts = [ % x,y,color, num, w,h
            %6,8,1,1,1,1;  %X input
            9,8,3,3,1,1; %supply
            12,5,4,4,2,1; %slider
            ];
        for i = 1:numel(RobotPts(:,1))
            RobotPts(i,3) = i;
            RobotPts(i,4) = i;
        end
        blk=[1 1 1 1 1 0 1 1 0 1 1 1 1 1 1  %problem 0->1 OR 0!
            1 1 1 1 1 0 1 0 0 0 1 1 1 1 1
            1 1 1 1 1 0 1 0 1 1 1 1 1 1 1
            1 0 0 0 0 0 0 0 0 0 0 0 0 1 1
            1 1 1 0 1 1 1 1 1 0 1 1 0 1 1
            1 1 1 0 1 0 1 0 0 0 0 0 0 0 0
            1 1 0 0 0 0 1 1 1 1 1 1 1 1 1
            1 1 1 1 1 0 1 1 1 1 1 1 1 1 1];
        blk = flipud([blk, repmat(blk(:,end),1,5)]);
    end
    function [blk,RobotPts] = FANOUTgate() %#ok<DEFNU>
        % uses a 2x1 block and supply bit to create a FANOUT gate
        %  Only outputs ones with the correct input sequence BUT easy to
        %  create zeros
        % want 1 -> 11; 0 -> 00
        %         RobotPts = [ % x,y,color, num, w,h
        %             6,8,1,1,1,1;  %X input
        %             9,8,3,3,1,1; %supply
        %             10,5,4,4,2,1; %slider
        %             ];
        %         for i = 1:numel(RobotPts(:,1))
        %             RobotPts(i,3) = i;
        %             RobotPts(i,4) = i;
        %         end
        %        blk=[1 1 1 1 1 0 1 1 0 1 1 1 1  %allows 1 -> 11, 01, 10
        %             1 1 1 1 1 0 1 0 0 0 1 1 1  %allows 0 -> 00
        %             1 1 1 1 1 0 1 0 1 1 1 1 1
        %             1 0 0 0 0 0 0 0 0 0 0 1 1
        %             1 1 1 1 0 1 1 1 0 1 0 1 1
        %             1 1 1 1 0 1 1 0 0 0 0 0 0
        %             1 1 1 0 0 0 1 1 0 1 1 1 1
        %             1 1 1 1 1 0 1 1 0 1 1 1 1];
        RobotPts = [ % x,y,color, num, w,h
            5,12,1,1,1,1;  %X input
            8,10,3,3,1,1; %supply
            10,5,4,4,2,1; %slider
            ];
        for i = 1:numel(RobotPts(:,1))
            RobotPts(i,3) = i;
            RobotPts(i,4) = i;
        end
        blk=[1 1 1 1 0 1 1 0 1 1 1 1 1 %allows 1 -> 11, 01,
            1 1 1 1 0 1 0 0 0 1 1 1 1 %allows 0 -> 00
            1 1 1 1 0 1 1 1 0 1 1 1 1
            1 1 1 0 0 0 1 0 0 0 1 1 1
            1 1 1 1 1 0 1 0 1 1 1 1 1
            1 0 0 0 0 0 0 0 0 0 0 1 1
            1 1 1 1 0 1 1 1 0 1 0 1 1
            1 1 1 1 0 1 1 0 0 0 0 0 0
            1 1 1 0 0 0 1 1 0 1 1 1 1
            1 1 1 1 1 0 1 1 0 1 1 1 1];
        
        blk = flipud([blk, repmat(blk(:,end),1,5)]);
    end

    function [blk,RobotPts] = ddNOTandConnectorgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            12,11,2,2;
            ];
        %            A   A'
        blk=[1 1 1 1 0 1 0 1 ;
            1 1 1 1 0 1 0 1 ;
            1 0 0 0 0 0 0 1 ;
            1 0 1 1 0 1 1 1 ;
            1 0 1 0 0 1 1 1 ;
            1 0 1 0 1 1 1 1 ;
            1 0 1 0 0 0 0 1 ;
            1 0 1 1 1 1 0 1 ;
            1 0 0 0 0 1 0 1 ;
            1 1 1 1 0 1 0 1 ;
            1 1 1 1 0 1 0 1 ];
        %             B   B'
        blkC=[ 1 1 1 0 1 0 1 ;
            1 1 1 0 1 0 1 ;
            0 0 0 0 0 0 1 ;
            0 1 1 0 1 1 1 ;
            0 1 0 0 1 1 1 ;
            0 1 0 1 1 1 1 ;
            0 1 0 0 1 1 1 ;
            0 1 1 0 1 1 1 ;
            0 0 0 0 0 0 1 ;
            1 1 1 0 1 0 1 ;
            1 1 1 0 1 0 1 ];
        blk = flipud([blk,blkC]);
    end


    function [blk,RobotPts] = SAFEddNOTgate() %#ok<DEFNU>
        % this is a reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            7,11,2,2;
            ];
        %            x   x'
        blk=[1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1;
            1 0 0 0 0 0 0 1 1 1 1;
            1 0 1 1 0 1 1 1 1 1 1;
            1 0 1 0 0 1 1 1 1 1 1;
            1 0 1 0 1 1 1 1 1 1 1;
            1 0 1 0 0 0 0 1 1 1 1;
            1 0 1 1 1 1 0 1 1 1 1;
            1 0 0 0 0 1 0 1 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = ONEWAY_3InORgate() %#ok<DEFNU>
        % this is a NON-reversible OR gate for three inputs
        RobotPts = [
            8,10,1,1;
            10,10,2,2;
            12,10,3,3;
            ];
        %                     x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = ONEWAY_RECYCLING() %#ok<DEFNU>
        % UNFINISHED
        RobotPts = [
            7,11,1,1;
            %6,11,2,1;
            9,11,2,2;
            ];
        %               x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1];
        blk = flipud(blk);
    end


    function [blk,RobotPts] = SandorsGadgetForCounting() %#ok<DEFNU>
        %         % is a cross between 3(a) and 3(b)
        % that is basically another version of Figure 3(a) (the 3-input OR):
        % one additional dent of size 1 pixel at the left of the first horizontal row, similar to what's in
        % 3(b), where the dent has size m=4.
        % The idea is that we get 1 pixel out if we have at least 2 pixels, but don't get more out if there's more in.
        % This will be a separate (!) figure, which we will plug together 2 times to get a 2^n counter.
        % (OK, strictly speaking it will be a number of inputs through the SAME channel, but it will work
        %  the same way, and should get the idea across.)
        %
        % Maybe you can produce a second version with only one input channel, which exits from the lower
        % right of a preceding cave? And no white pixels in the third row.
        % Then we can fill the fourth row with a sequence of down/right moves,
        % and "cash in" the pixels by moving left/down.
        RobotPts = [
            8,10,1,1;
            10,10,2,2;
            12,10,3,3;
            ];
        %                     x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,0,0;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,0,0;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,0,0];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = SandorsGadgetForCountingV2() %#ok<DEFNU>
        %
        % Maybe you can produce a second version with only one input channel, which exits from the lower
        % right of a preceding cave? And no white pixels in the third row.
        % Then we can fill the fourth row with a sequence of down/right moves,
        % and "cash in" the pixels by moving left/down.
        % (1) Make the vertical "chimney" of white pixels below the red horizontal row
        %       white enough to accommodate whatever is in the right "dead-end" half of the red row.
        %       (That way, we will have to empty that row completely when passing a pixel to the next gadget.)
        % (2) Extend the left dead-end in the long white row (parallel to and two rows below the red row
        %       - the one that exits to the right) so that it can also accommodate all extra pixels.
        %      (That way, there is no way of retaining extra pixels and feeding them back into the green column.)
        %
        % (2) is critical, as it makes it clear that "cheating" is impossible. (1) would also be good, but I can wave
        % my hands to explain why this is not a problem.
        RobotPts = [
            9,30,1,1;
            16,27,2,2;
            12,32,3,3;
            ];
        %                     x1
        %        blk=[1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
        %             1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
        %             1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
        %             1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
        %             1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0];
        blk=[1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,0,0;
            1,1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0;
            1,1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0;
            1,1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,0,0];
        blk = flipud([blk;2*blk;blk]);
    end


    function [blk,RobotPts] = ONEWAY_mInANDgate() %#ok<DEFNU>
        % this is a NON-reversible AND gate for m-inputs
        RobotPts = [
            7,10,1,1;
            9,10,2,2;
            11,10,3,3;
            13,10,4,4;
            15,10,5,5;
            ];
        %                     x1    x2    x3
        blk=[1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0,1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 0, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 0, 1, 2, 0, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 0, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 1, 2, 0, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,1;
            1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = ddANDgatecw()
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %                  A   B   A'  B'
        blk=[1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0;
            1 1 0 1 1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 1 0 1 1 1 1 1 1 0 1 0 1 0;
            1 1 0 1 0 1 1 0 1 1 1 0 1 0 1 0;
            1 1 0 1 0 1 0 0 0 0 1 0 1 0 1 0;
            1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 0;
            1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 0;
            %      AND,OR,NOR,NAND
            ];
        w = size(blk,2);
        h = size(blk,1);
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+8,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+12,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+10,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+14,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end



    function [blk,RobotPts] = partHopper()
        % this holds many parts and releases one per turn.
        
        RobotPts = [];
        
        % DESIGN THE OBSTACLES:  0 are free space, 1 are obstacles
        %                  A   A'  B   B'
        blk=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;  %OUTPUT
            1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0;
            ];
        w = size(blk,2);
        h = size(blk,1);
        
        
        %INSERT THE ROBOTS   each row is  [x,y,  ID(must be unique) , color]
        nr = w-3;
        RobotPts = [ 1+[1:nr]', 2*ones(nr,1), [1:nr]'  ,ones(nr,1)          ];
        
        blk = flipud(repmat(blk,1,1));
    end



    function [blk,RobotPts] = singleCycleDelay()
        % @Author: Aaron and Shiva, THIS DOES NOT WORK YET!
        %
        % @BRIEF: this gate starts with a large collection of components, and
        % emits one particle every other cycle.
        RobotPts = [];
        
        % DESIGN THE OBSTACLES:
        blk=[1 1 1 1 1 0 1;
            1 1 1 1 1 0 1;
            1 1 1 1 1 0 1;
            1 0 1 1 1 0 1;
            1 0 1 0 0 0 1;
            1 0 0 0 0 0 1;
            1 1 1 1 1 1 1;
            ];
        w = size(blk,2);
        h = size(blk,1);
        
        
        %INSERT THE ROBOTS   each row is [x,y,  ID(must be unique) , color,width, height]
        RobotPts = [
            6,h,1,1,1,1
            6,h-1,1,1,1,1;
            4,2,2,2,2,1;
            2,2,3,3,1,2;
            ];
        
        blk = flipud(repmat(blk,1,1));
    end


   function [blk,RobotPts] = DialsGate()
        % @Author: Aaron and Robert Dial
        %
        % @BRIEF: this gate starts with a large collection of components, and
        % emits one particle every other cycle.
        RobotPts = [];
        
        % DESIGN THE OBSTACLES:
        blk=[0 1 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 1 0 0;
            0 0 0 0 0 0 0 0 0 1 0 0;
            0 0 0 0 0 0 1 0 0 0 0 0;
            0 0 1 1 1 1 0 1 0 0 0 0;
            0 0 1 0 0 0 0 0 0 0 0 0;
            0 0 1 0 1 1 0 0 0 0 0 0;
            0 0 1 0 0 1 0 0 0 0 0 0;
            0 0 1 0 0 1 0 0 0 0 0 0;
            0 0 1 0 0 1 0 0 0 0 0 0;
            0 0 1 1 1 1 0 1 1 1 0 0;
            1 0 0 0 0 0 0 1 0 0 0 0;
            1 0 0 0 0 0 0 1 0 0 0 0;
            0 0 0 0 0 0 1 1 0 0 0 0;
            ];
        w = size(blk,2);
        h = size(blk,1);
        
        
        %INSERT THE ROBOTS   each row is [x,y,  ID(must be unique) , color,width, height]
        RobotPts = [
            5,5,1,1,1,1
            4,5,2,1,1,1;
            5,6,3,1,1,1
            4,6,4,1,1,1;
            5,7,5,1,1,1
            4,7,6,1,1,1;
            4,8,7,1,1,1;
            7,9,8,2,1,2;
            %2,2,3,3,1,2;
            ];
        
        blk = flipud(repmat(blk,1,1));
    end

    function [blk,RobotPts] = ddCarrycw()
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %                  A   A'  B   B'
        blk=[1 1 1 1 1 1 1 0 1 0 1 0 1 0 1 0;
            1 1 0 1 1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 1 1 0 1 1 1 0 1 1 1 0 1 0;
            1 1 0 1 1 0 1 1 1 0 1 1 1 0 1 0;
            1 1 0 1 0 0 0 0 1 0 1 1 1 0 1 0;
            1 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 1 1 0 1 0 1 1 1 1 1 1 1 0;
            %    AND,   1,  NAND
            ];
        w = size(blk,2);
        h = size(blk,1);
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+8,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+10,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+12,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+14,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end

    function [blk,RobotPts] = ddXORgatecw() %SUMMER
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %              A   A'  B   B'
        blk=[1 1 1 0 1 0 1 0 1 0 1 1 1 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0;
            1 0 0 1 1 0 1 0 1 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1 0;
            1 1 1 1 1 1 1 1 1 1 0 1 0 1 0 1 0;
            ];%                     XOR, XNOR,1
        
        w = size(blk,2);
        h = size(blk,1);
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+4,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+6,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+8,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+10,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end
    function [blk,RobotPts] = ddXORgate()
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %            A   B   A'  B'
        blk=[1 1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 1 1 1 0 1 0 1 1 1 0;
            1 0 0 1 0 0 0 0 0 1 1 1 0;
            1 0 0 1 0 0 1 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 1 1 0;
            1 1 0 1 1 0 1 1 0 0 1 1 0;
            1 1 0 0 0 0 0 1 0 0 1 1 0;
            1 1 1 1 1 1 0 1 0 0 1 1 0;
            %
            ];
        w = size(blk,2);
        h = size(blk,1);
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+7,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+9,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+11,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end
    function [blk,RobotPts] = FullAdderCarry() %#ok<DEFNU>
        RobotPts = [];
        %Fails.  Tomorrow. make a 3-XOR
        % dual-rail full adder
        %           A   B   C         A'  B'  C'
        blk=[1 1 1 1 0 1 0 1 0 1 1 1 1 0 1 0 1 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1;
            1 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 1 1 1;
            1 1 0 1 0 0 1 1 1 1 1 0 1 1 0 0 1 1 1;
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  %Waste
            1 1 0 1 1 0 1 1 1 1 1 0 1 1 0 1 1 1 1;
            1 1 0 0 1 0 1 1 1 1 1 0 0 1 0 1 1 1 1;
            1 1 1 0 1 0 1 1 1 1 1 1 0 1 0 1 1 1 1;
            %      C   S             C'  S'
            ];
        w = size(blk,2);
        for c = 1:8
            str = dec2bin(c-1,3);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+5,9,1+(c-1)*3,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+14,9,1+(c-1)*3,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+7,9,2+(c-1)*3,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+16,9,2+(c-1)*3,2]; %B'
            end
            if str(3) == '1'
                RobotPts(end+1,:) = [w*(c-1)+9,9,3+(c-1)*3,3];  %C
            else
                RobotPts(end+1,:) = [w*(c-1)+18,9,3+(c-1)*3,3]; %C'
            end
            
        end
        blk = flipud(repmat(blk,1,8));
    end
    function [blk,RobotPts] = FullAdderSum() %#ok<DEFNU>
        % sum bit for dual-rail full adder   d,l,d,r,d,l,d
        RobotPts = [];
        %           A   B   C         A'  B'  C'
        blk=[1 1 1 1 0 1 0 1 0 1 1 1 1 0 1 0 1 0 1;
            1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1;
            1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1; %at least 1 / 2
            1 1 0 0 1 1 1 1 1 1 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1; %at least 2 / 1
            1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
            1 1 1 0 0 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
            1 1 1 1 0 1 1 1 1 1 1 1 0 1 0 1 0 1 1;
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1;
            1 0 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1;
            1 0 1 1 1 1 1 1 1 1 1 1 0 0 1 1 0 1 1;
            1 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 1 1;
            1 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 1 1;
            1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1;
            1 0 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1;
            %
            ];
        w = size(blk,2);
        h = size(blk,1);
        for c = 1:8
            str = dec2bin(c-1,3);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*3,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+14,h,1+(c-1)*3,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+7,h,2+(c-1)*3,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+16,h,2+(c-1)*3,2]; %B'
            end
            if str(3) == '1'
                RobotPts(end+1,:) = [w*(c-1)+9,h,3+(c-1)*3,3];  %C
            else
                RobotPts(end+1,:) = [w*(c-1)+18,h,3+(c-1)*3,3]; %C'
            end
        end
        blk = flipud(repmat(blk,1,8));
    end


    function [blk,RobotPts] = ONEWAY_SAFEddNOTgate() %#ok<DEFNU>
        % this is a NON-reversible cross-over switch that is also a NOT gate for
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            7,11,1,1;
            %6,11,2,1;
            9,11,2,2;
            ];
        %               x     x'
        blk=[1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;
            1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = SAFEddCNTgate() %#ok<DEFNU>
        % this is a reversible CONNECTOR (PIPLINE)
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            5,11,1,1;
            %6,11,2,1;
            7,11,2,2;
            ];
        %               x     x'
        blk=[1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1];
        blk = flipud(blk);
    end


    function [blk,RobotPts] = ONEWAY_SAFEddCNTgate() %#ok<DEFNU>
        % this is a NON-reversible CONNECTOR (PIPLINE)
        % dual-rail logic SAFE because both paths require same # of moves
        RobotPts = [
            7,11,1,1;
            %6,11,2,1;
            9,11,2,2;
            ];
        %               x     x'
        blk=[1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1];
        blk = flipud(blk);
    end



    function [blk,RobotPts] = SIMPLEmaintainDLDR() %#ok<DEFNU>
        % ensure that the sequence DLDR is followed
        % without skips
        RobotPts = [
            4,13,1,1; % x
            6,15,2,2; % x'
            8,15,3,3;  %y
            10,15,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;];
        %           x&y, (x|y)',x|y, (x&y)'
        blk = flipud(blk);
    end
    function [blk,RobotPts] = maintainDLDR() %#ok<DEFNU>
        % includes CAVEs to ensure that the sequence DLDR is followed
        % without skips
        RobotPts = [
            6,13,1,1; % x
            6,15,2,2; % x'
            8,15,3,3;  %y
            10,15,4,4;  %y'
            ];
        %                  x     x'    y     y'
        blk = [ 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0;
            1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0;
            1, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0;
            0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0;
            0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;];
        %           x&y, (x|y)',x|y, (x&y)'
        blk = flipud(blk);
    end


    function [blk,RobotPts] = ddANDgate() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND gate
        RobotPts = [
            4,13,1,1; % x
            6,15,2,2; % x'
            8,15,3,3;  %y
            10,13,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk = [ 1 1 1 0 1 0 1 0 1 0 1 1;
            1 0 0 0 0 0 0 0 1 0 1 1;
            1 0 0 1 1 0 1 1 1 0 1 1;
            1 0 0 0 0 0 0 0 1 0 1 1;
            1 1 0 1 1 0 1 0 1 0 1 1;
            1 1 0 0 1 0 1 0 1 0 1 1;
            1 1 1 0 1 0 1 0 1 0 1 1;
            1 0 0 0 0 0 0 0 0 0 1 1;
            1 0 0 0 1 1 1 0 1 1 1 1;
            1 0 0 0 0 0 1 0 1 1 1 1;
            1 1 0 0 1 0 1 0 1 1 1 1;
            1 1 0 0 0 0 0 0 0 0 1 1;
            1 1 1 0 1 0 1 0 1 0 1 1;];
        %           x&y, (x&y)',x|y, (x|y)'
        blk = flipud(blk);
    end

    function [blk,RobotPts] = SAFEddANDgate() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND gate
        RobotPts = [
            4,17,1,1; % x
            6,15,2,2; % x'
            8,17,3,3;  %y
            10,15,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk=[1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1;
            1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1;
            % 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2; %AND/NAND gate
            % 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 2, 2, 2;
            2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2; %NOR/OR gate
            2, 2, 2, 2, 2, 0, 2, 0, 2, 2, 2, 2, 2;
            ];
        %           x&y, (x|y)',x|y, (x&y)'
        blk = flipud(blk);
    end

    function [blk,RobotPts,strTitle] = verySAFEddANDgate() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        % and can never be reversed more than 1 move.
        %  thi is the first gate we will manufacture
        strTitle = 'x, x'', y, y''';
        RobotPts = [
            6,16,1,1; % x
            8,18,2,2; % x'
            10,16,3,3;  %y
            12,18,4,4;  %y'
            ];
        %                x     x'    y     y'
        blk=[
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 0 1 1 1 0 1 1 1 0 1 1 1;
            1 1 0 0 1 1 1 0 1 0 1 0 1 1 1;
            1 0 0 0 0 0 0 0 0 0 1 0 1 1 1;
            1 1 1 0 1 1 1 0 1 0 1 0 1 1 1;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 1 0 1 0 1 0 1 1 1;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1;
            1 1 0 0 1 0 1 1 1 0 1 1 1 1 1;
            1 1 0 0 1 0 1 0 1 0 1 1 1 1 1;
            1 0 0 0 0 0 0 0 1 0 1 1 1 1 1;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 0 0 0 0 1 1 1;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1;
            % 2 2 2 2 2 0 2 0 2 2 2 2 2 2 2;%AND/NAND gate
            % 2 2 2 2 2 2 2 2 2 0 2 0 2 2 2; %NOR/OR gate
            ];
        %           x&y, (x&y)',x|y, (x|y)'
        blk = flipud(blk);
        
    end

    function [blk,RobotPts,strTitle] = verySAFEddANDgateSET() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        % and can never be reversed more than 1 move.
        %  thi is the first gate we will manufacture
        strTitle = 'x, x'', y, y''';
        %                x     x'    y     y'
        blk=[
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 0 1 1 1 0 1 1 1 0 1 1 1 0;
            1 1 0 0 1 1 1 0 1 0 1 0 1 1 1 0;
            1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 0;
            1 1 1 0 1 1 1 0 1 0 1 0 1 1 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 1 0 1 0 1 0 1 1 1 0;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0;
            1 1 0 0 1 0 1 1 1 0 1 1 1 1 1 0;
            1 1 0 0 1 0 1 0 1 0 1 1 1 1 1 0;
            1 0 0 0 0 0 0 0 1 0 1 1 1 1 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 0 0 1 1 1 0;
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0;
            % 2 2 2 2 2 0 2 0 2 2 2 2 2 2 2;%AND/NAND gate
            % 2 2 2 2 2 2 2 2 2 0 2 0 2 2 2; %NOR/OR gate
            ];
        %           x&y, (x&y)',x|y, (x|y)'
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+6,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+8,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+10,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+12,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end

    function [blk,RobotPts,strTitle] = unSAFEddANDgateSET() %#ok<DEFNU>
        % this is a  dual-rail logic gate that implements AND/NOR/OR/NAND
        % and can never be reversed more than 1 move.
        %  thi is the first gate we will manufacture
        strTitle = 'x, x'', y, y''';
        %                x     x'    y     y'
        blk=[1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 1 0 1 0;
            1 0 0 1 1 0 1 1 1 0 1 0;
            1 0 0 0 0 0 0 0 1 0 1 0;
            %1 1 0 1 1 0 1 0 1 0 1 0;
            1 1 0 0 1 0 1 0 1 0 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0;
            1 0 0 0 0 0 0 0 0 0 1 0;
            1 0 0 0 1 1 1 0 1 1 1 0;
            1 0 0 0 0 0 1 0 1 1 1 0;
            %1 1 0 0 1 0 1 0 1 1 1 0;
            1 1 0 0 0 0 0 0 0 0 1 0;
            1 1 1 0 1 0 1 0 1 0 1 0;
            ];
        %           x&y, (x&y)',x|y, (x|y)'
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 2;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+4,h,1+(c-1)*ins,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+6,h,1+(c-1)*ins,1]; %A'
            end
            if str(2) == '1'
                RobotPts(end+1,:) = [w*(c-1)+8,h,2+(c-1)*ins,2];  %B
            else
                RobotPts(end+1,:) = [w*(c-1)+10,h,2+(c-1)*ins,2]; %B'
            end
        end
        blk = flipud(repmat(blk,1,2^ins));
    end

    function [blk,RobotPts,strTitle] = ddFANOUTcw4
        % this is a  dual-rail logic gate that implements a FanOut with 4
        % copies of the input
        % With the universal input <d,l,u,r>
        strTitle = 'x, x'', 1';
        %           1   1   1   x                  x'
        blk=[1 1 1 1 0 1 0 1 0 1 0 1 1 1 1 1 1 1 1 1 0 1 1
            1 1 1 1 0 1 0 1 0 1 0 1 1 1 1 1 1 1 1 0 0 0 1
            1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 1
            1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 1
            1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 0 1
            1 1 1 0 0 0 0 0 0 0 1 0 1 1 1 0 1 0 1 0 1 0 1
            1 1 1 0 0 0 0 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1
            1 1 1 0 0 0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1
            1 1 1 1 1 0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0 1
            ];%       x   x   x   x   x'  x'  x'  x'
        
        
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 1;
        sp = 3;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [sp+w*(c-1)+11,h,1+(c-1)*ins,1,1,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+21,h,1+(c-1)*ins,1,1,1]; %A'
            end
        end
        %         x   1   x'
        RobotPts(end+1,:) = [5,h,3,2,1,1]; %supply
        RobotPts(end+1,:) = [7,h,4,2,1,1]; %supply
        RobotPts(end+1,:) = [9,h,5,2,1,1]; %supply
        RobotPts(end+1,:) = [13,5,6,3,2,1]; %slider
        RobotPts(end+1,:) = [sp+w+5,h,7,2,1,1]; %supply
        RobotPts(end+1,:) = [sp+w+7,h,8,2,1,1]; %supply
        RobotPts(end+1,:) = [sp+w+9,h,9,2,1,1]; %supply
        RobotPts(end+1,:) = [sp+w+13,5,10,3,2,1]; %slider
        blk = flipud([blk, zeros(h,sp),blk]);
    end

    function [blk,RobotPts,strTitle] = memorycw
        % this is a  dual-rail logic gate that implements one bit of memory
        % With the universal input <d,l,u,r>
        strTitle = 'x, x'', 1';
        sp = 3;
        %       5       9               15
        %     READ     SET         CLEAR
        blk=[1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1
            1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1
            1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1%this line is optional (makes process easier to understand)
            1 1 1 0 0 0 0 0 0 0 0 0 0 1 0 1
            1 1 1 0 0 1 1 0 0 1 1 1 0 1 0 1
            1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 1
            1 1 1 0 0 0 1 0 1 1 0 1 0 1 0 1
            1 1 1 1 1 0 1 0 1 1 0 0 0 0 0 1
            1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 1
            ];%       Q   W     W   Q'
        
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        sh=4; sw = 10;
        rc = 1;
        % You can choose 1 from Read, Set or Clear (or nothing)
        %  Q = 0: Read, Set, Clear, nothing
        %  Q = 1: Read, Set, Clear, nothing
        for c =1:6
            if c == 1
                RobotPts(end+1,:) = [(c-1)*(sp+w)+5,h,rc,1,1,1];  %Read
                rc=rc+1;
            elseif c == 2
                %                 RobotPts(end+1,:) = [(c-1)*(sp+w)+5,h,rc,1,1,1];  %Read
                %                 rc=rc+1;
                RobotPts(end+1,:) = [(c-1)*(sp+w)+9,h,rc,4,1,1]; %Set
                rc=rc+1;
            elseif c == 3
                %                 RobotPts(end+1,:) = [(c-1)*(sp+w)+5,h,rc,1,1,1];  %Read
                %                 rc=rc+1;
                
                RobotPts(end+1,:) = [(c-1)*(sp+w)+15,h,rc,4,1,1]; %Clear
                rc=rc+1;
            elseif c == 4
                RobotPts(end+1,:) = [(c-1)*(sp+w)+5,h,rc,1,1,1];  %Read
                rc=rc+1;
                RobotPts(end+1,:) = [(c-1)*(sp+w)+sw-1,sh,rc,2,1,1];  %STATE=1
                rc=rc+1;
            elseif c == 5
                %                 RobotPts(end+1,:) = [(c-1)*(sp+w)+5,h,rc,1,1,1];  %Read
                %                 rc=rc+1;
                RobotPts(end+1,:) = [(c-1)*(sp+w)+9,h,rc,4,1,1]; %Set
                rc=rc+1;
                RobotPts(end+1,:) = [(c-1)*(sp+w)+sw-1,sh,rc,2,1,1];  %STATE=1
                rc=rc+1;
            elseif c == 6
                %                 RobotPts(end+1,:) = [(c-1)*(sp+w)+5,h,rc,1,1,1];  %Read
                %                 rc=rc+1;
                RobotPts(end+1,:) = [(c-1)*(sp+w)+15,h,rc,4,1,1]; %Clear
                rc=rc+1;
                RobotPts(end+1,:) = [(c-1)*(sp+w)+sw-1,sh,rc,2,1,1];   %STATE=1
                rc=rc+1;
            end
            RobotPts(end+1,:) = [(c-1)*(sp+w)+sw,sh,rc,3,2,1]; %slider
            rc=rc+1;
        end
        blk = flipud([blk, zeros(h,sp),blk, zeros(h,sp),blk, zeros(h,sp),blk,zeros(h,sp),blk, zeros(h,sp),blk]);
    end
    function [blk,RobotPts,strTitle] = ddFANOUTcw
        % this is a  dual-rail logic gate that implements a FanOut
        % With the universal input <d,l,u,r>
        strTitle = 'x, x'', 1';
        sp = 3;
        %       x   1           x'
        blk=[1 1 0 1 0 1 1 1 1 1 0 1 1
            1 1 0 1 0 1 1 1 1 0 0 0 1  %this line is optional (makes process easier to understand)
            1 1 0 1 0 1 1 1 1 0 0 0 1
            1 1 0 1 0 1 1 1 1 1 1 0 1   %this line is optional (makes process easier to understand)
            1 0 0 0 0 0 0 0 0 0 1 0 1
            1 1 1 0 0 0 1 0 1 0 1 0 1
            1 1 1 1 1 0 1 0 1 0 1 0 1
            ];%       x   x   x'  x'
        %           1   x           x'
        %        blk=[1 1 1 1 0 1 0 1 1 1 1 1 0 1 1
        %             1 1 1 1 0 1 0 1 1 1 1 0 0 0 1
        %             1 1 1 1 0 1 0 1 1 1 1 1 1 0 1%this line is optional (makes process easier to understand)
        %             1 1 1 0 0 0 0 0 0 0 0 0 1 0 1
        %             1 0 0 0 0 0 0 0 0 0 1 0 1 0 1
        %             1 1 1 0 0 0 1 0 1 1 1 0 1 0 1
        %             1 1 1 1 1 0 1 0 1 1 1 0 1 0 1
        %             ];%       x   x       x'  x'  x'  x'
        
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 1;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [sp+w*(c-1)+3,h,1+(c-1)*ins,1,1,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+11,h,1+(c-1)*ins,1,1,1]; %A'
            end
        end
        %         x   1   x'
        RobotPts(end+1,:) = [5,h,3,2,1,1]; %supply
        RobotPts(end+1,:) = [9,3,4,3,2,1]; %slider
        RobotPts(end+1,:) = [sp+w+5,h,5,2,1,1]; %supply
        RobotPts(end+1,:) = [sp+w+9,3,6,3,2,1]; %slider
        blk = flipud([blk, zeros(h,sp),blk]);
    end


    function [blk,RobotPts,strTitle] = unSAFEddFANOUT
        % this is a  dual-rail logic gate that implements a FanOut
        
        %
        strTitle = 'x, x'', 1';
        %       x   x'     1
        blk=[1 1 0 1 0 1 1 0 1 1 1 1 1 1 1 0 %allows 1 -> 11, 01,
            1 0 0 1 0 1 0 0 1 1 1 1 1 1 1 0 %allows 0 -> 00
            1 0 1 1 0 1 0 1 1 1 1 1 1 1 1 0
            1 0 0 1 0 1 0 0 0 0 1 1 1 1 1 0
            1 1 0 1 0 0 0 0 0 0 0 0 0 0 1 0
            1 1 0 1 1 1 0 1 1 0 1 0 1 1 1 0
            1 1 0 1 1 1 0 0 1 0 1 0 1 1 1 0
            1 1 0 1 1 1 1 0 1 0 1 0 1 1 1 0];
        %       x       x   x'  x'
        
        % blk = flipud(blk);
        w = size(blk,2);
        h = size(blk,1);
        RobotPts = [];
        ins = 1;
        for c =1:2^ins
            str = dec2bin(c-1,ins);
            if str(1) == '1'
                RobotPts(end+1,:) = [w*(c-1)+3,h,1+(c-1)*ins,1,1,1];  %A
            else
                RobotPts(end+1,:) = [w*(c-1)+5,h,1+(c-1)*ins,1,1,1]; %A'
            end
        end
        %         x   1   x'
        RobotPts(end+1,:) = [8,h,3,2,1,1]; %supply
        RobotPts(end+1,:) = [13,4,4,3,2,1]; %slider
        RobotPts(end+1,:) = [w+8,h,5,2,1,1]; %supply
        RobotPts(end+1,:) = [w+13,4,6,3,2,1]; %slider
        
        
        blk = flipud(repmat(blk,1,2^ins));
    end


    function [blk,RobotPts] = SAFEVariableBlk() %#ok<DEFNU>
        % lets the user set a variable t/f on the ith step, and ignores
        % all other r/l switching on steps j ~= i.
        % this is SAFE because  applying a u/d after the deciding r/l
        % switch latches the input.
        RobotPts = [
            10,15,1,1; % x
            6,18,2,2; % x'
            8,18,3,3;  %y
            10,18,4,4;  %y'
            ];
        %
        blk=[1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1;
            1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1;
            1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1;
            1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1;
            1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1;
            1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1;
            1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1;
            1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1;];
        blk = flipud(blk);
    end

    function [blk,RobotPts] = VariableBlkIndexed(index) %#ok<DEFNU>
        % lets the user set a variable t/f on the ith step, and ignores
        % all other r/l switching on steps j ~= i.
        % this is SAFE because  applying a u/d after the deciding r/l
        % switch latches the input.
        switch index
            case 1
                RobotPts = [ 11,11,1,1;  ];
            case 2
                RobotPts = [ 9,11,1,1;  ];
            case 3
                RobotPts = [ 7,11,1,1;  ];
            otherwise
                RobotPts = [ 7,11,1,1;  ];
        end
        
        %
        blk{1}=[1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1 1;
            1 1 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 1;
            1 1 1 1 0 1 0 1 1 1 1 1 1 1 0 1 0 1 1 1;
            1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1;
            1 1 1 0 1 1 1 0 1 1 1 1 1 0 1 1 1 0 1 1;
            1 1 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 1;
            1 1 0 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 0 1;
            1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0;
            1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0;
            ];%               10,                 20
        blk{2}=[1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1;
            1 1 1 1 1 1 1 0 1 0 1 1 1 1 1 1;
            1 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1;
            1 1 1 1 0 1 1 1 1 1 1 1 0 1 1 1;
            1 1 1 0 0 0 1 1 1 1 1 0 0 0 1 1;
            1 1 1 0 1 0 1 1 1 1 1 0 1 0 1 1;
            1 1 0 0 0 0 0 1 1 1 0 0 0 0 0 1;
            1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1;
            1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0;
            1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
            ]; %           8              16
        blk{3}=[1 1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 0 0 1 1 1 1;
            1 1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 0 0 0 0 1 1 1;
            1 1 1 1 0 1 1 1 0 1 1 1;
            1 1 1 0 0 0 0 0 0 0 1 1;
            1 1 1 0 1 1 1 1 1 0 1 1;
            1 1 0 0 0 1 1 1 0 0 0 1;
            1 1 0 1 0 1 1 1 0 1 0 1;
            1 0 0 0 0 0 1 0 0 0 0 0;
            1 1 1 1 1 0 1 1 1 1 1 0;
            ];%        6          12
        blk{4}=[1, 1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 0 0 1 1 1 1;
            1 1 1 1 1 0 1 0 1 1 1 1;
            1 1 1 1 0 0 0 0 0 1 1 1;
            1 1 1 1 0 1 1 1 0 1 1 1;
            1 1 1 0 0 0 0 0 0 0 1 1;
            1 1 1 0 1 1 1 1 1 0 1 1;
            1 1 0 0 0 0 0 0 0 0 0 1;
            1 1 0 1 1 1 1 1 1 1 0 1;
            1 0 0 0 1 1 1 1 1 0 0 0;
            1 1 1 0 1 1 1 1 1 1 1 0;
            ];%    4              12
        blk = flipud([blk{index},ones(size(blk{index}(:,1)))] );
    end

    function [blk,RobotPts] = VariableBlk() %#ok<DEFNU>
        % lets the user set a variable t/f on the ith step, and ignores
        % all other r/l switching on steps j ~= i.
        RobotPts = [
            9,13,1,1; % x
            6,16,2,2; % x'
            8,16,3,3;  %y
            10,16,4,4;  %y'
            ];
        %
        blk=[1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 0 0 0 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 0 1 0 1 1 1 1 1 1 1;
            1 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 1;
            1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1;
            1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1;
            1 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1;
            1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1;
            1 1 0 1 0 1 1 1 1 1 1 1 0 1 0 1 1;
            1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1;
            1 0 1 1 1 0 1 1 1 1 1 0 1 1 1 0 1;];
        blk = flipud(blk);
    end

    function blk = GateBlk() %#ok<DEFNU>
        blk = [ 1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1 1 1 1];
    end
    function ANDGate = ANDGate() %#ok<DEFNU>
        ANDGate=[1 1 0 1 1 0 1 1 1 1 1;
            1 1 0 1 1 0 1 0 0 0 0;
            1 1 0 1 1 0 1 0 1 1 1;
            1 1 0 0 0 0 0 0 1 1 1;
            1 1 1 0 1 1 1 1 1 1 1;
            1 1 1 0 0 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1];
    end
    function ORGate = ORGate()  %#ok<DEFNU>
        ORGate=[1 1 0 1 1 0 1 1 1 1 1;
            1 0 0 0 0 0 0 0 0 0 0;
            1 0 0 1 1 0 1 1 1 1 1;
            1 0 0 0 0 0 1 1 1 1 1;
            1 0 1 1 1 1 1 1 1 1 1;
            1 0 0 0 0 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1];
    end
    function NOTGate = NOTGate()  %#ok<DEFNU>
        NOTGate=[1 1 1 1 1 0 1 1 0 1 1;
            1 1 1 1 1 0 0 0 0 0 0;
            1 1 1 1 1 0 0 1 1 0 1;
            1 1 0 0 0 0 0 0 0 0 1;
            1 1 1 1 0 1 1 1 1 1 1;
            1 1 1 1 0 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1;
            1 1 1 1 1 0 1 1 1 1 1];
    end
end