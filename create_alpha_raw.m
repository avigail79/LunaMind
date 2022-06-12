function alpha_raw = create_alpha_raw(raw_data, curr_freq)

curr_num_elec = (size(raw_data,2)-1)/4;
bands_names = ["beta", "theta", "alpha", "delta"];
freq_num = find(bands_names==curr_freq);

alpha_raw = raw_data(:,1); % time - column 1

for i_elec = 1:curr_num_elec
    alpha_raw(:,i_elec+1) = raw_data(:,1+freq_num+(4*(i_elec-1)));
end

for i = 1:length(alpha_raw) % end column is mean
    alpha_raw(i,curr_num_elec+2) = sum(alpha_raw(i,2:curr_num_elec+1))/nnz(alpha_raw(i,2:curr_num_elec+1));
end

end