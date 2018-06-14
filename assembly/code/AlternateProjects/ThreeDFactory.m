function [] = ThreeDFactory()

%Code for 3D worspace simulation.
%All blue voxels can move in any of the six directions
%TODO: Change the code so the particles don't stick when inside the hoppers
%but join when they hit each other outside hoppers

RobotPts=[ 1,44,24;1,43,24;1,42,24;1,44,25;1,43,25;1,42,25;1,44,26;1,43,26;1,42,26;1,37,24;1,36,24;1,35,24;1,37,25;1,36,25;1,35,25;1,37,26;1,36,26;1,35,26;
       1,23,24;1,22,24;1,21,24;1,23,25;1,22,25;1,21,25;1,23,26;1,22,26;1,21,26;1,30,24;1,29,24;1,28,24;1,30,25;1,29,25;1,28,25;1,30,26;1,29,26;1,28,26;1,16,24;1,15,24;1,14,24;1,16,25;1,15,25;1,14,25;1,16,26;1,15,26;1,14,26;
      1,9,24;1,8,24;1,7,24;1,9,25;1,8,25;1,7,25;1,9,26;1,8,26;1,7,26;];


% GoalPts=[3,1,1];

GoalPts = [1,1,40; 1,2,40;1,3,40;1,4,40;1,5,40;1,6,40;1,7,40;1,8,40;1,9,40;1,10,40;1,11,40;1,12,40;1,13,40;1,14,40;1,15,40;1,16,40;.... %top straight line
       1,17,40;1,18,40;1,19,40;1,20,40;1,21,40;1,22,40;1,23,40;1,24,40;1,25,40;1,26,40;1,27,40;1,28,40;1,29,40;1,30,40;1,31,40;1,32,40.... %top straight line
       ;1,33,40;1,34,40;1,35,40;1,36,40;1,37,40;1,38,40;1,39,40;1,40,40;1,41,40.... %top straight line
       ;1,41,39;1,40,39;1,41,38;1,41,37;1,41,36;1,41,35;1,41,34;1,41,33;1,41,32;1,41,31;1,41,30;1,41,29......%left column
       ;1,1,39;1,1,38;1,1,37;1,1,36;1,5,39.......
       ;1,46,28;1,45,28;1,44,28;1,43,28;1,42,28;1,41,28........ %hopper
       ;1,39,28;1,38,28;1,37,28;1,36,28;1,35,28;1,34,28........ %hopper
       ;1,32,28;1,31,28;1,30,28;1,29,28;1,28,28;1,27,28........ %hopper
       ;1,25,28;1,24,28;1,23,28;1,22,28;1,21,28;1,20,28........ %hopper
       ;1,18,28;1,17,28;1,16,28;1,15,28;1,14,28;1,13,28........ %hopper
       ;1,11,28;1,10,28;1,9,28;1,8,28;1,7,28;1,6,28;1,4,28;1,3,28;1,2,28;1,1,28........ %hopper
       ;1,46,27;1,41,27;1,39,27;1,34,27;1,32,27;1,27,27;1,25,27;1,20,27;1,18,27;1,13,27;1,11,27;1,6,27........ %hopper
       ;1,46,26;1,41,26;1,39,26;1,34,26;1,32,26;1,27,26;1,25,26;1,20,26;1,18,26;1,13,26;1,11,26;1,6,26........ %hopper
       ;1,46,25;1,41,25;1,39,25;1,34,25;1,32,25;1,27,25;1,25,25;1,20,25;1,18,25;1,13,25;1,11,25;1,6,25........ %hopper
       ;1,46,24;1,41,24;1,39,24;1,34,24;1,32,24;1,27,24;1,25,24;1,20,24;1,18,24;1,13,24;1,11,24;1,6,24........ %hopper
       ;1,46,23;1,41,23;1,39,23;1,34,23;1,32,23;1,27,23;1,25,23;1,20,23;1,18,23;1,13,23;1,11,23;1,6,23........ %hopper
       ;1,46,22;1,39,22;1,32,22;1,25,22;1,18,22;1,11,22....... %hopper
       ;1,46,21;1,45,21;1,44,21;1,43,21;1,42,21;1,41,21;1,40,21;1,39,21;1,38,21;1,37,21;1,36,21;1,35,21;1,34,21;1,33,21;1,32,21;1,31,21;1,30,21;1,29,21;1,28,21;1,27,21.....
       ;1,26,21;1,25,21;1,24,21;1,23,21;1,22,21;1,21,21;1,20,21;1,19,21;1,18,21;1,17,21;1,16,21;1,15,21;1,14,21;1,13,21;1,12,21;1,11,21;1,10,21;1,9,21;1,8,21;1,7,21;1,6,21;
       1,44,23;1,43,23;1,42,23;1,37,23;1,36,23;1,35,23;1,30,23;1,29,23;1,28,23;1,23,23;1,22,23;1,21,23;1,16,23;1,15,23;1,14,23;1,9,23;1,8,23;1,7,23;
       1,5,21;1,4,21;1,4,22;1,4,23;1,4,24;1,4,25;1,4,26;1,4,27;
       ];




f1 = figure(1);
vox_sz = [1,1,1]; %length of cube sides
voxel_image(GoalPts, vox_sz,'k',0.8);
patches = voxel_image(RobotPts(:,1:3), vox_sz,'b',0.5);
axis equal
axis([0,20,0,50,0,40]);
view([-37.5, 30]);
tixs = (-100:5:100);
set(gca,'XGrid','on','YGrid','on','ZGrid','on','Xtick', tixs,'Ytick', tixs,'Ztick', tixs)
xlabel('x')
ylabel('y')
zlabel('z')
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
            step = -[1,0,0];
        elseif strcmp(key,'rightarrow')|| strcmp(key,'+x') %+x
            RobotPts = sortrows(RobotPts,-1);
            step = [1,0,0];
        elseif strcmp(key,'uparrow')|| strcmp(key,'+y') %+y
            RobotPts = sortrows(RobotPts,-2);
            step = [0,1,0];
        elseif strcmp(key,'downarrow')|| strcmp(key,'-y') %-y
            RobotPts = sortrows(RobotPts,2);
            step = -[0,1,0];
        elseif strcmp(key,'w')|| strcmp(key,'+z') %+z
            RobotPts = sortrows(RobotPts,-3);
            step = [0,0,1];
        elseif strcmp(key,'s') || strcmp(key,'-z')%-z
            RobotPts = sortrows(RobotPts,3);
            step = -[0,0,1];
        end
        % implement the move on every robot
        for ni = 1:size(RobotPts,1)
            desVal = RobotPts(ni,1:3)+step;
            while  ~ismember(desVal,RobotPts(:,1:3),'rows') && ~ismember(desVal,GoalPts(:,1:3),'rows')...
                    && ~any(desVal<=[0,0,0])&& ~any(desVal>=[20,50,40])
                RobotPts(ni,1:3) = desVal;
                desVal = RobotPts(ni,1:3)+step;
            end
        end
        updateVoxel(RobotPts(:,1:3),patches)
        drawnow
    end


 function updateVoxel(pts,patches)
        %updates the Voxels with handle patches to be at pts
        np = size(pts,1);
        vert = zeros(8*np,3);
        fac = zeros(6*np,4,'uint32');
        vert_bas = [...
            -0.5,-0.5,-0.5;
            0.5,-0.5,-0.5;
            0.5,0.5,-0.5;
            -0.5,0.5,-0.5;
            -0.5,-0.5,0.5;
            0.5,-0.5,0.5;
            0.5,0.5,0.5;
            -0.5,0.5,0.5];
        vert_bas = vert_bas.*([vox_sz(1).*ones(8,1), vox_sz(2).*ones(8,1), vox_sz(3).*ones(8,1)]);
        fac_bas = [...
            1,2,3,4;
            1,2,6,5;
            2,3,7,6;
            3,4,8,7;
            4,1,5,8;
            5,6,7,8];
        for vx = 1:np
            a = ((vx-1)*8+1):vx*8;
            for dim = 1:3
                vert( a,dim ) = vert_bas(:,dim) + pts(vx,dim);
            end
            fac ( ((vx-1)*6+1):vx*6,: ) = (vx - 1)*8*ones(6,4) + fac_bas;
        end
        set(patches,'Vertices',vert,'Faces',fac);
    end
end