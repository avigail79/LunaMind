function [eeg_data, raw_data, out_data] = load_files(path_subj)
file_path = dir(path_subj);
for i= 3:length(file_path)
    curr_file_name = file_path(i).name;
    data_type_name = curr_file_name(end-6: end-4);
    if data_type_name == 'raw'
        raw_data = readtable([path_subj '\' curr_file_name],'VariableNamingRule','preserve');
        raw_data = table2array(raw_data);
        raw_data(isnan(raw_data)) = 0;
    elseif data_type_name == 'out'
        out_data = readcell([path_subj '\' curr_file_name]);
    elseif data_type_name == 'eeg'
        eeg_data = readtable([path_subj '\' curr_file_name],'VariableNamingRule','preserve');
        eeg_data = table2array(eeg_data);
        eeg_data(isnan(eeg_data)) = 0;
    end
end
end