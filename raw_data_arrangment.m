function raw_data_second = raw_data_arrangment(raw_data)

min_samples_per_sec = 7;

for i=1:length(raw_data(:,1))
    curr_num = num2str(raw_data(i,1));
    raw_data(i,1) = str2num(curr_num(1:10));
end

sub_elem = raw_data(1,1); % make timestamp start with 0
for i=1:length(raw_data(:,1))
    raw_data(i,1) = (raw_data(i,1)-sub_elem);
end

raw_data_second = zeros(raw_data(end,1), 9);
row_end = 1;
sec_sub_row = 0;
for sec = 1:raw_data(end,1)
    row_start = row_end;
    
    % if there is no data
    if raw_data(row_start, 1) ~= sec -1
        sec_sub_row = sec_sub_row + 1;
        continue
    end
    
    % count the samples per second
    samples_per_sec = 0;
    while raw_data(row_end, 1) == sec - 1
        row_end = row_end +1;
        samples_per_sec = samples_per_sec + 1;
    end

    % contninue if there is less samples than min_samples
    if samples_per_sec > min_samples_per_sec
        % calculate std per second
        for col=2:9
            raw_data_second(sec-sec_sub_row, col) = std(raw_data(row_start:row_end-1, col));
        end
    else
        sec_sub_row = sec_sub_row + 1;
        continue
    end

    % give number to row
    raw_data_second(sec-sec_sub_row,1) = sec-1;


end

end