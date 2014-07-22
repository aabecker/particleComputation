function olfatiFormationControl
% consensus and cooperation in Networked Multi-agent systems, eq (6)
% shows that robots asymptotically approach goal position, following a
% straight path.  Because this is a consensus operation, they assemble the
% correct formation and in the correct orientation, but  mean position is a
% function of the initial condition.
% @author Aaron Becker, ab55@rice.edu,
% @since June 24, 2013


 % goal is a capitol 'R'
   xGoal =  [ 16    16    16    16    16    28    36    42    38    32    22    34    37    42    47];
   yGoal = -[ 35    23    10    -2   -12   -15   -12    -3     6    11    12    17    24    29    34];
   
   xPos = (rand(1,numel(xGoal))-0.5)*100;
   yPos = (rand(1,numel(yGoal))-0.5)*100;
   
   clf;
   figure(1)
   plot(xGoal, yGoal,'gx')
   hold on
   hPos = plot(xPos,yPos,'bo');
   hPath = zeros(numel(xPos));
   for i = 1:numel(xGoal)
       hPath(i) = plot(xPos(i),yPos(i),'-','color',[0.8,0.8,1]);
   end
   axis equal
   
   %equation 6
   %b = -sum(xj-xi)
   bX = zeros(size(xGoal));
   bY = zeros(size(yGoal));
   for i = 1:numel(xGoal)
       bX(i) = sum(repmat(xGoal(i),1,numel(xGoal))- xGoal);
       bY(i) = sum(repmat(yGoal(i),1,numel(yGoal))- yGoal);
   end
   
   
   eps = 0.001;
    for j = 1:1000
        xPosD = xPos;
        yPosD = yPos;
       for i = 1:numel(xGoal)
        xPosD(i) = sum(xPos - repmat(xPos(i),1,numel(xPos))) + bX(i);
        yPosD(i) = sum(yPos - repmat(yPos(i),1,numel(yPos))) + bY(i);
       end
       xPos = xPos + eps*xPosD;
       yPos = yPos + eps*yPosD;
        
        set(hPos,'XData',xPos,'YData', yPos)
        drawnow
        for i = 1:numel(xGoal)
           set(hPath(i),'XData',[get(hPath(i),'XData'),xPos(i)],'YData',[get(hPath(i),'YData'),yPos(i)] );
       end
    end

end