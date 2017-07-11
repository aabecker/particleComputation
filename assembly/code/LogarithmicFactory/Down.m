function [OneStage]= Down(subfactory,align2,align3,stage)
%Function for joining tiles from Down move
if nargin<1
    align2 =7;
    align3 =10;
    subfactory=[2 3 2 3 2 3 2 3;
                1 1 1 1 1 1 1 1;
                1 1 1 1 1 1 1 1];
    stage=1;
end
obs=1;
OneStage=vertcat(subfactory,ones(align2-size(subfactory,1)-1,(stage*4+1+3)));
matrix=horzcat(zeros(align3-align2+1,stage*4+1),ones(align3-align2+1,3));
OneStage=vertcat(OneStage,matrix);
OneStage=vertcat(OneStage,zeros((stage*2)+1,(stage*4)+1+3));
OneStage(align3+1,1)=obs;

% DisplayFactory(OneStage);   
end