function [OneStage]= Right(subfactory,align2,align3,stage)
%Function for joining tiles from Right move
if nargin<1
    align2 =7;
    align3 =10;
    subfactory=[2 3 2 3 2 3 2 3;
                1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1];
            
    stage=1;
end
obs=1; %Defines obstacle
OneStage=vertcat(subfactory,ones(align2-size(subfactory,1)-1,(stage*4)+1+3));
matrix=horzcat(zeros(align3-align2+1,stage*4+1),ones(align3-align2+1,3));
OneStage=vertcat(OneStage,matrix);
OneStage(align2,stage*4+1)=obs; %Add obstacle to stop right motion %Fix columns according to stage
OneStage=vertcat(OneStage,zeros(5,(stage*4)+1+3)); %Fix rows according to stage
OneStage(align3+1,1:3)=obs;
OneStage(end-1,2:4)=obs;
OneStage(end-2,2)=obs;
%Add outlet to the subfactory

% DisplayFactory(OneStage);   
end