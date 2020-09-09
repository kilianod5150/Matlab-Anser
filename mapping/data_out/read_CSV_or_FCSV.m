function [data] = read_CSV_or_FCSV(filename)
%READ_CSV_OR_FCSV Summary of this function goes here
%   Detailed explanation goes here
fcsv_string='.fcsv';

TF = contains(filename,fcsv_string);

if TF
    data = FCSV_Read(filename); 
else
    data = importcsvfile(filename);   
end

end

