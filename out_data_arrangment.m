function out_data = out_data_arrangment(out_data)

for i=2:size(out_data(:,1))
    curr_num = num2str(out_data{i,1});
    out_data{i,1} = str2num(curr_num(1:10));
end

sub_elem = out_data{2,1}; % make timestamp start with 0
for i=2:size(out_data(:,1))
    out_data{i,1} = (out_data{i,1} - sub_elem);
end

end