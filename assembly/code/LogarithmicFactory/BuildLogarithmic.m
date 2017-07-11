function []= BuildLogarithmic()
% Logarithmic Factory
% write a function which gives me the number of stages, 

[~, ~, directions] = Stages(); %Get coordinates, directions and dimensions
BlueHopper1=BlueHopper(8,4);
[RedHopper1,align2]=RedHopper(8,4);
hoppers=horzcat(BlueHopper1,RedHopper1); %concatenate both the hoppers

stage=1;

subfactory=[1 1 1 1 1 1 1 1;
            1 1 1 1 1 1 1 1];
for i=1:length(directions)

    if(directions(i)=='d')
   subfactory=Down(subfactory,align2(i),align2(i)+2,stage);
    elseif(directions(i)=='l')
   subfactory=Left(subfactory,align2(i),align2(i)+2,stage);
    elseif(directions(i)=='r')
   subfactory=Right(subfactory,align2(i),align2(i)+2,stage);
    elseif(directions(i)=='u')
   subfactory=Up(subfactory,align2(i),align2(i)+2,stage);
    end
    
end

subfactory=vertcat(subfactory,ones(1,size(subfactory,2))); %Add bottom row to the subfactory stage

if(size(hoppers,1)<size(subfactory,1))
hoppers=vertcat(hoppers,ones(size(subfactory,1)-size(hoppers,1),size(hoppers,2)));
else
subfactory=vertcat(subfactory,ones(size(hoppers,1)-size(subfactory,1),size(subfactory,2)));
end
factory=horzcat(hoppers,subfactory);


DisplayFactory(factory);
end