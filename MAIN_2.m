clear; clc; close all;

%% loading the data
% Avigail's Path
path_data = 'C:\Users\Avigail Makbili\Documents\LunaMind\LunaMind\20-2-22\';
% Anat's path
% path_data = 'G:\My Drive\Oren Shriki\LunaMind\Analyses\LunaMind_Git\20-2-22\';
% path_data = 'G:\My Drive\Oren Shriki\LunaMind\Analyses\DATA\DATA_LunaMind\20-2-22\';
% path_data = 'G:\My Drive\Oren Shriki\LunaMind\Analyses\DATA\DATA_LunaMind\24-2-22\';


% subj_num = [101:112 114:118];
recordings_file = dir('20-2-22');

fs = 256; % Sampling frequency
pressed_focus_level = zeros(length(recordings_file), 4);

for s = 3:3%length(recordings_file)
    if length(recordings_file(s).name) > 3 && recordings_file(s).name(1,5) == '_'
        continue
    end

    %% loading file
    path_subj = [path_data num2str(recordings_file(s).name)];
    [eeg_data, raw_data, out_data] = load_files(path_subj);

    %% remove TP electrode
    raw_data = remove_TP(raw_data);

    %% Data arrangement 
    raw_data_second = raw_data_arrangment(raw_data);
    out_data = out_data_arrangment(out_data);

    %% std analysis
    
end