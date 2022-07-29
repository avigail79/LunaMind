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

for s = 3:4%length(recordings_file)
    if length(recordings_file(s).name) > 3 && recordings_file(s).name(1,5) == '_'
        continue
    end

    %% loading file
    path_subj = [path_data num2str(recordings_file(s).name)];
    [eeg_data, raw_data, out_data] = load_files(path_subj);

    %% remove TP electrode
    raw_data = remove_TP(raw_data);

    %% Data arrangement 
    raw_data_by_second = raw_data_arrangment(raw_data);
    out_data = out_data_arrangment(out_data);
    
    alpha_raw = create_alpha_raw(raw_data_by_second, "alpha"); %The last column is the mean
    
    %% Button pressed and video state
    [out_button, before_pressed, after_pressed, video_state_start] = pressed(out_data, alpha_raw);

    %% std analysis
    std_win = 5;
    raw_data_mean = mean(raw_data_by_second(:,1:end), 2);
    moving_std = movstd(raw_data_mean(:,end), std_win);
    
    if out_button

        % pressed focus level
        for i = 1:4
            pressed_focus_level(s, i) = sum(out_button(:,3) == i);
        end
        pressed_focus_level(s, 5) = sum(pressed_focus_level(s, 1:2));
        pressed_focus_level(s, 6) = sum(pressed_focus_level(s, 3:4));
        
        pressed_time = out_button(:, 2);
        resume_time = video_state_start(:,2);

        std_analysis_plots(recordings_file(s).name, alpha_raw(:,1), moving_std, pressed_time, resume_time, pressed_focus_level(s,6))
    end

end