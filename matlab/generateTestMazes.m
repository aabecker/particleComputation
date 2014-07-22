function generateTestMazes
%TODO:  generate a maze
%TODO:  place N robots and N/2 targets
%TODO: try to solve the problem
close all
format compact

%global FrameCount MOVIE_NAME MAKE_MOVIE
MAKE_MOVIE = 0; % if 1, records png images to make into a movie
MOVIE_NAME = 'massive3dManipulateChair';
%ffmpeg -r 30 -f image2 -i img/massive3dManipulateChair.png -b 24000k -r 30 massive3dManipulateChair.mp4
FrameCount = 0;
set(0,'defaultaxesfontsize',18);
set(0,'defaulttextfontsize',18);
n = 100; %grid size
N = 5; %number of robots


G.obstacle_pos = randi(2,n)-1
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    ];
colormap(G.colormap)
%G.obstacle_pos = ones(n,n);
% %seed value for the maze
% G.obstacle_pos(randi(n),randi(n)) = 0;
% ind = find(G.obstacle_pos == 0);
% while( 2*numel(ind) < n^2)
%     seed = ind(randi(numel(ind)));
%     newdir =randi(4);
%      %   1
%      %2     3
%     %    4
%     if newdir ==1 && seed-1 > 0
%         G.obstacle_pos(seed-1) = 0;
%     elseif newdir ==2 && seed-n > 0
%         G.obstacle_pos(seed-n) = 0;
%     elseif newdir ==3 && seed+n < n^2
%         G.obstacle_pos(seed+n) = 0;
%     elseif newdir ==4 && seed+1 < n^2
%         G.obstacle_pos(seed+1) = 0;
%     end
%     ind = find(G.obstacle_pos == 0);
% end

f1 = figure(1);
G.axis=imagesc(G.obstacle_pos);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off');
%set(G.axis,'edgealpha',.08)
axis equal
axis tight
G.title = title('press arrows keys to move');

hold on



axis equal

set(gca,'XGrid','on','YGrid','on')
xlabel('x')
ylabel('y')
set(f1 ,'color',[1,1,1]);
set(f1 ,'KeyPressFcn',@keyhandler,'Name','Massive Control 3D');


    function keyhandler(src,evnt) %#ok<INUSL>
        moveto(evnt.Key)
    end

    function moveto(key)
        % Maps keypresses to moving pixels
        step = [0,0,0];
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
            desVal = RobotPts(ni,1:3)+step;
            if  ~ismember(desVal,RobotPts(:,1:3),'rows') && ~ismember(desVal,PillarPts(:,1:3),'rows')...
                    && ~any(desVal<=[aXmin,aYmin,aZmin])&& ~any(desVal>=[aXmax,aYmax,aZmax])
                RobotPts(ni,1:2) = desVal;
            end
        end
        %update the drawing
        updateDrawing
    end

    function updateDrawing
        %global FrameCount MOVIE_NAME MAKE_MOVIE G
        set(f1, 'position',[-98          57        1774         965]);
        drawnow
        if(MAKE_MOVIE)
            FrameCount=FrameCount+1;
            fname = sprintf('img/%s%06d.png',MOVIE_NAME,FrameCount);
            lighting phong
            %set(gcf,'Renderer','zbuffer')
            %            lighting gouraud
            % set(gcf,'Renderer','OpenGL')
            F = getframe_nosteal_focus; %getframe;
            imwrite(F.cdata, fname,'png');
            while(FrameCount < 10)
                updateDrawing
            end
            F = 1;
            %clear F
        end
    end
end

