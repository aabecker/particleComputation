function []= BuildLogarithmic()
% Logarithmic Factory
% I need to write a function which gives me the number of stages, 
% The number of red and blue tiles in the polyomino so hoppers can be made,
% Number of copies of the polyomino
% At each stage I need to know the build order (sequence + directions)
% Write the direction Codes and find a way to concatenate the sub-factories
BlueHopper1=BlueHopper();
RedHopper1=RedHopper();
hoppers=horzcat(BlueHopper1,RedHopper1);
DisplayFactory(hoppers);
end