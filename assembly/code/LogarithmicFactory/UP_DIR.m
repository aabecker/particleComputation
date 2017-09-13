function [] = UP_DIR (parts_matrix,part1_length,part1_width,part2_length,part2_width,alignment)
%Function joins two polyominoes by 'UP' move
%part1_length = length of part entering from first inlet
%part1_width = width of part entering from first inlet
%alignment = horizonatl distance between left corners of the two parts
if nargin <1
parts_matrix=[1 1 1 1 1 1 1;
              1 2 3 2 3 0 0;
              1 3 2 3 2 0 0;
              1 1 1 1 1 1 1;
              1 1 1 1 1 1 1;
              1 3 2 0 0 0 0;
              1 2 3 0 0 0 0;
              1 1 1 1 1 1 1];

% Part sizes and alignment;
part1_length = 2; %part entering from the first inlet
part1_width = 4; 
part2_length = 2; %part entering from the second inlet
part2_width = 2;
alignment=3; % horizontal distance between the left corners of both the parts

end
rows=6+((part1_length+part2_length)*2)+part2_length; %initialize rows and columns of the subfactory from the lengths & widths of the parts
columns=1+5+part1_width+part1_width+part2_width+part2_width;
subfactory=zeros(rows,columns);%white space equal to size of the subfactory
subfactory(1,1:end)=1; %make top row black
subfactory(end,1:end)=1; %make bottom row black
subfactory(2:1+part1_length,end-5-part2_width:end-5)=1; %make top right obstacle
subfactory(4+part1_length+part2_length,1:part1_width+part2_width)=1; %make obstacle to stop up movement
subfactory(1+4+((part1_length+part2_length)*2),1:alignment)=1;
subfactory(1+4+((part1_length+part2_length)*2):end,1:alignment)=1;
subfactory(1+4+((part1_length+part2_length)*2),part1_width+part2_width+1:part1_width+part2_width+part1_width)=1;
subfactory(1:4+part1_length+part2_length,end-5:end)=1; %add black space to end columns
subfactory(1+4+((part1_length+part2_length)*2):end,end-5:end)=1; %add black space to end columns


%Once the subfactory is made concatenate it with the part_matrix : horzcat
parts_matrix=vertcat(parts_matrix,ones(size(subfactory,1)-size(parts_matrix,1),size(parts_matrix,2)));
subfactory=horzcat(parts_matrix,subfactory);
DisplayFactory(subfactory); %Display the parts and subfactory
end