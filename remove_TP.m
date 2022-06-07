function [new_raw_data] = remove_TP(raw_data)
% TP is in column 2-5 and 14-17
raw_data(:, 2:5) = [];
raw_data(:, 14:17) = [];
new_raw_data = raw_data;
end