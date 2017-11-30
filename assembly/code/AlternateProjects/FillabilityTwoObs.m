function [Fill,fill_rowarray] = FillabilityTwoObs()
%The function fills a white region of 6 rows and 6 columns and finds the
%maximum number of red particles which can be filled after placing an
%obstacle at one of the 36 possible locations.
% Authors: Sheryl Manzoor, smanzoor2@uh.edu and Aaron T. Becker, atbecker@uh.edu
format compact
nRows = 6;
white_col=4;
blk_col1=white_col-1;
blk_col2=white_col+1;
%blk_col1=3;
%blk_col2=5;
fill_rowarray=zeros(1,36*36); %saves sum for each second obstacle location.
cnt2=1; %Counter for fill_rowarray 


for col_position=1:1 %For six different positions of drop down column
    
obs_row1=10; %the obstacle position in the region starts from tenth row 
obs_col1=3; %Start column position from fourth column
cnt1=1; %Counter for the fill1 array
fill1=zeros(1,36); %this array saves the maximum number of red particles in the white space for each obstacle position

for second_obs=1:36

cnt=1; %Counter for the fill array
fill=zeros(1,36); %this array saves the maximum number of red particles in the white space for each obstacle position
clear fill; 
obs_row=10; %the obstacle position in the region starts from tenth row 
obs_col=3; %Start column position from first column


%for second obstacle
obs_col1=obs_col1+1; %Add one to the column because the obstacle's first column position is four
if obs_col1==10 %if the column position of the obstacle becomes 10 then, make it 4 and add one to the row position
 obs_col1=4;
 obs_row1=obs_row1+1;
end


    for totalitr=1:36 % first obstacle has 36 locations

        obs_col=obs_col+1; %Add one to the column because the obstacle's first column position is four
        if obs_col==10 %if the column position of the obstacle becomes 10 then, make it 4 and add one to the row position
           obs_col=4;
           obs_row=obs_row+1;
        end

        path = ones(16,10); %Make a region of 16 rows and 10 columns
        path(2:8,2:9) = 2; %Put red particles in the top six rows of the region
        path(2:10,white_col) = 0; 
        path(3:9,blk_col1) = 1;
        path(3:9,blk_col2) = 1;
        path(10:15,4:9) = 0; %Make white free space to be filled
        path(obs_row,obs_col)=1; %Place the obstacle at a location inside white space
        path(obs_row1,obs_col1)=1; %Place the second obstacle at a location inside white space
      

%       G.fig = figure(col_position);
        G.fig = figure(1);
        set(gcf,'color','k');
%         set(G.fig ,'KeyPressFcn',@keyhandler,'Name',strcat('col# ',num2str(white_col)));
        G.game = flipud(path);
        G.obstacle_pos = (G.game==1);  
        G.colormap = [  1,1,1; %Empty = white
            0,0,0; %obstacle
            1,0,0;];
        colormap(G.colormap);
        G.axis=imagesc(G.game);
        set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off','color',0.8*[1,1,1]);
        axis equal
        axis tight
        %assignin('base','P',G);

        % build list of items
        makeItemList();
        drawGameboard();
       
     
        count=0; %count is the number of red particles in the white space; start from zero
            for increment=1:60 %this is the number of red particles in the top region
                previtrcount=count;
                %for autonum=1:4 %One clockwise cycle of right, down , left, up
                for autonum=1:4 %One clockwise cycle of up, right, down , left
                        %step=[0,0];
                    if autonum==2
                       step=[0,1]; %right
                    elseif autonum==3
                       step= -[1,0]; %down
                    elseif autonum==4
                        step= -[0,1]; %left
                    elseif autonum==1
                        step= [1,0]; %up
                    end
                    %drawGameboard();
                    revertList = [];
                    while numel(revertList) < numel(G.items)
                        %move everything: check for collisions, make list of objects that must be reverted
                        G.game = zeros(size(G.obstacle_pos));
                        revertList = [];
                        for i = 1:numel(G.items)
                            for j = 1:size(G.items{i},1)
                                ny = G.items{i}(j,1) + int16(step(1));
                                nx = G.items{i}(j,2) + int16(step(2));
                                G.items{i}(j,1:2) =  [ny,nx];
                                if nx>0 && ny>0 && ny<=size(G.game,1) && nx<=size(G.game,2) 
                                G.game(ny,nx) = i;
                                    if  G.obstacle_pos(ny,nx)==true % if this bit hit an obstacle, make sure it is on the revertList
                                        if isempty(find(revertList == i, 1))
                                            revertList(end+1) = i; %#ok<AGROW>
                                        end
                                    end
                                else  
                                    scEdge = 5;
                                    if nx<-scEdge || ny<scEdge && ny>size(G.game,1)+scEdge || nx>size(G.game,2) +scEdge
                                        if isempty(find(revertList == i, 1))
                                            revertList(end+1) = i;
                                        end
                                    end
                                end
                            end

                        end


                        % go recursively through revert list, moving them back in the image
                        % and adding any shapes they collide with back to the
                        i = 1;
                        while i<=numel(revertList)
                            item2revert = revertList(i);
                            for j = 1:size(G.items{item2revert},1)
                                G.items{item2revert}(j,1:2) =  G.items{item2revert}(j,1:2)-int16(step);
                                collisionItem = G.game(G.items{item2revert}(j,1),G.items{item2revert}(j,2));
                                if collisionItem ~= item2revert && collisionItem ~= 0 
                                    if isempty(find(revertList == collisionItem, 1))
                                        revertList(end+1) = collisionItem;
                                    end
                                end
                            end
                            i=i+1;
                        end
                        drawGameboard();
            %             drawnow
                         makeItemList();
                    end
                   %autonum=autonum+1; 
                   %pause(0.1);
                end
                region = G.game(2:7,4:9); %White space region in which the red particles need to be counted.
                count = numel(region(region==2)); %count number of red particles in the region
                if count==previtrcount %if the count of this iteration is equal to previous iteration's count then break the loop
                    fill(1,cnt)=previtrcount;
                    cnt=cnt+1;
                    break;
                end
               % drawGameboard();
                
            end
        % pause(0.5); %Pause for 1 sec before changing the obstacle location\
        drawnow
    end
    
    
fill_text = reshape(fill,nRows,nRows)';
fill=sum(fill);
fill1(1,cnt1)=fill; %For displaying the sums for each inlet point.
cnt1=cnt1+1; %Counter for fill1 array

fill_rowarray(1,cnt)=fill;
cnt2=cnt2+1;


if(fill<70) %Value can be determined only after looking at the sums array
path(15,9) = 0;
G.fig = figure(cnt1);
set(gcf,'color','k');
set(G.fig ,'Name',strcat('col# ',num2str(fill)));
G.game = flipud(path);
G.obstacle_pos = (G.game==1);  
G.colormap = [  1,1,1; %Empty = white
    0,0,0; %obstacle
    1,0,0;];
colormap(G.colormap);
G.axis=imagesc(G.game);
set(gca,'box','off','xTick',[],'ytick',[],'ydir','normal','Visible','off','color',0.8*[1,1,1]);
axis equal
axis tight

drawGameboard();

for p=1:6
    for m=1:6
        ht = text(3+p,1+m,num2str(fill_text(7-m,p)) ,'HorizontalAlignment','center');
    end
    set(ht, 'color','k');
end

end

end

fill1 = reshape(fill1,nRows,nRows)';
fill_all(:,:, col_position) = fill1;

white_col=white_col+1;
blk_col1=blk_col1+1;
blk_col2=blk_col2+1;
end
Fill = fill_all; %6*6*number of inlets
fill_rowarray=sort(fill_rowarray,'ascend');


    function drawGameboard()
        %draw obstacles
        G.game = uint8(G.obstacle_pos);
        for i = 1:numel(G.items)
            for j = 1:size(G.items{i},1)
                %%delete any components that leave the screen
                if G.items{i}(j,1)>0 && G.items{i}(j,1)<=size(G.game,1) &&...
                   G.items{i}(j,2)>0 && G.items{i}(j,2)<=size(G.game,2)
                G.game(G.items{i}(j,1),G.items{i}(j,2)) = G.items{i}(j,3);
                end
            end
        end
    % %DRaw bitmap        
        set(G.axis,'CData',G.game)
    end


    function makeItemList()
        % searches over the whole gameboard to find 'Items'
        G.items = {};
        for x = 1:size(G.game,2)
            for y = 1:size(G.game,1)
                if G.game(y,x)>1
                    num = numel(G.items)+1;
                    color = G.game(y,x);
                    G.items{num} = int16([y,x,color]);
                    addItems(y+1,x,color,num);
                    addItems(y-1,x,color,num);
                    addItems(y,x+1,color,num);
                    addItems(y,x-1,color,num);
                end
            end
        end
        %assignin('base','items',G.items);
    end


    function  addItems(y,x,color,num)
        if y>size(G.game,1) || y<1 ||x<1 || x>size(G.game,2)   %% what does it do if the size exceeds the gameboard
            return
        end
        thisColor = G.game(y,x);  
        if (thisColor == 2 && color == 3) || (thisColor == 3 && color == 2)
            G.game(y,x) = 0; 
            %                          y,x,color
            G.items{num}(end+1,:) = int16([y,x,thisColor]);
            addItems(y+1,x,thisColor,num);
            addItems(y-1,x,thisColor,num);
            addItems(y,x+1,thisColor,num);
            addItems(y,x-1,thisColor,num);
        end
    end
end






