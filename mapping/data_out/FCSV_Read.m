function [data] = FCSV_Read(filename)
%FCSV_READ Summary of this function goes here
%   Detailed explanation goes here



rawData1 = importdata(filename, ','); %read fcsv file
HEADERLINES = numel(rawData1);
header_offset=3;
no_header=cell(HEADERLINES-header_offset,1);
for i=1:HEADERLINES-header_offset;
    
    no_header{i}= rawData1{i+header_offset};
    C = textscan(no_header{i},'%s','Delimiter',',');
    data(i,1)=str2num(C{1,1}{2,1}); %x
    data(i,2)=str2num(C{1,1}{3,1}); %y
    data(i,3)=str2num(C{1,1}{4,1}); %z
    
end



end

