clear; clc; close all;
% This script is for delta/alpha


%% loading the data
% Avigail's Path
% path_data = 'C:\Users\Avigail Makbili\Documents\LunaMind\DATA Motzkin\DATA_LunaMind\20-2-22\';
% Anat's path
% path_data = 'G:\My Drive\Oren Shriki\LunaMind\Analyses\DATA\DATA_LunaMind\20-2-22\';
path_data = 'G:\My Drive\Oren Shriki\LunaMind\Analyses\DATA\DATA_LunaMind\24-2-22\';


subj_num = [101:112 114:118];


% prompt = 'Choose frequency range: 1-beta, 2-theta, 3-alpha, 4-delta: ';
% i_freq = input(prompt);
% i_freq = inputdlg(prompt);
% beta 12.5-30Hz
% i_freq = 1;
% theta 4-8Hz
% i_freq = 2;
% alpha raw 8-12Hz
% i_freq = 3;
% delta raw 0.5-4Hz
% i_freq = 4;

for s = 1:length(subj_num)
    path_subj = append(path_data, num2str(subj_num(s)));
    file_path = dir(path_subj);

    % this load should move to function
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

    %% define parameters
    num_elec = 4;
    num_freq = 4;
    elec_names = ["TP9", "AF7", "AF8", "TP10"];
    bands_names = ["beta", "theta", "alpha", "delta"];
    x = (raw_data(:,1)-raw_data(1,1)); %time
    fs = 256; %Sampling frequency

    %% Arrange the data

    % raw data
    raw_data(:,1) = raw_data(:,1) * 1000; % equal the time stamp of out
    sub_elem = raw_data(1,1); % make outstam start with 0
    for i=1:length(raw_data(:,1))
        raw_data(i,1) = (raw_data(i,1)-sub_elem) / fs;
    end

% alpha
    alpha_raw = raw_data(:,1); % time
    for i_elec = 1:num_elec
        alpha_raw(:,i_elec+1) = raw_data(:,1+3+(4*(i_elec-1)));
    end
    for i = 1:length(alpha_raw) % column 6 is mean
        alpha_raw(i,6) = sum(alpha_raw(i,2:5))/nnz(alpha_raw(i,2:5));
    end


% theta
    theta_raw = raw_data(:,1); % time
    for i_elec = 1:num_elec
        theta_raw(:,i_elec+1) = raw_data(:,1+2+(4*(i_elec-1)));
    end
    for i = 1:length(theta_raw) % column 6 is mean
        theta_raw(i,6) = sum(theta_raw(i,2:5))/nnz(theta_raw(i,2:5));
    end

    %Theta/Alpha Ratio
    TA_ratio = [alpha_raw(:,1) theta_raw(:,6)./alpha_raw(:,6)];

    % out data
    out_data = out_data(2:end, :);
    sub_elem = out_data{1,1};
    for i=1:size(out_data, 1)
        out_data{i,1} = (out_data{i,1} - sub_elem) /fs;
    end
    % markers_type = unique(out_data(:,2));

    %% button pressed and video state
    out_button = zeros(1,2);
    video_state = zeros(1,3);
    j = 0;
    v = 0;
    for i=1:size(out_data,1)
        if size(out_data{i,3},2) == size('button_pressed',2)
            j = j+1;
            out_button(j,1) = i; %save the row index
            out_button(j,2) = out_data{i,1}; % save the time
        end
        if size(out_data{i,3},2) == size('video_state',2)
            v = v+1;
            video_state(v,1) = i; %save the row index
            video_state(v,2) = out_data{i,1}; % save the time
            if size(out_data{i,4},2) == size('video_pause', 2)
                video_state(v,3) = 0;
            elseif size(out_data{i,4},2) == size('video_play', 2)
                if out_data{i,4} == 'video_play'
                    video_state(v,3) = 1;
                end
            end

        end
    end

    video_state_start_indicies = find(video_state(:,3) == 1);
    video_state_start = video_state(video_state_start_indicies,:);

    % take time sec before and after the press
    % ms_time = 200;
    ms_time = 50;
    before_pressed = zeros(ms_time+1, length(out_button)); % time before the pressed
    after_pressed = zeros(ms_time+1, length(out_button)); % time after the pressed
    after_start_video = zeros(ms_time+1, length(out_button));% time after video play
    for b = 1:length(out_button)-1
        time_preseed_raw_idx = find(TA_ratio(:,1) > out_button(b,2)); % find the closet bottom pressed idx in raw (1)

        time_play_out_idx = find(video_state_start(:,2) > out_button(b,2)); % find the idx time of the start video after button pressed in out
        time_play_raw_idx = find(TA_ratio(:,1) > video_state_start(time_play_out_idx(1), 2)); % find the idx time of the start video afeter button pressed in raw

        if time_preseed_raw_idx(1) > ms_time
            before_pressed(:,b) = TA_ratio(time_preseed_raw_idx(1)-ms_time:time_preseed_raw_idx(1),2);
        else
            before_pressed(:,b) = TA_ratio(1:time_preseed_raw_idx(1),2);
        end

        if time_play_raw_idx(1)+ms_time < size(TA_ratio, 1)
            after_pressed(:,b) = TA_ratio(time_preseed_raw_idx(1):time_preseed_raw_idx(1)+ms_time,2);
        else
            after_pressed(:,b) = TA_ratio(time_preseed_raw_idx(1):end,2);
        end

        after_start_video(:,b) = TA_ratio(time_play_raw_idx:time_play_raw_idx+ms_time, 2);
    end

    %% plot histogram
    mean_pressed = mean(before_pressed);
    mean_after_pressed = mean(after_pressed);

    % edges = 0:0.1:5;
    All = [before_pressed;after_pressed];
    edges = 0:max(All(:))/20:max(All(:));


    [N_before(s,:), edges_before(s,:), N_after(s,:), edges_after(s,:)] = plot_before_and_after_pressed(subj_num(s), edges, before_pressed, after_pressed, ms_time);
    Max(s,1) = edges_before(s,(find(N_before(s,:) == max(N_before(s,:)),1,'first'))+1);

    Max(s,2) = edges_after(s,(find(N_after(s,:) == max(N_after(s,:)),1,'first'))+1);


    All = [before_pressed;after_start_video];
    edges = 0:max(All(:))/20:max(All(:));

    [N_before(s,:),edges_before(s,:), N_resume(s,:), edges_resume(s,:)] = plot_before_pressed_and_after_video_resume(subj_num(s), edges, before_pressed, after_start_video, ms_time);
    Max(s,3) = edges_resume(s,(find(N_resume(s,:) == max(N_resume(s,:))))+1);


end


% Analyse histogram bin count
p_befor_after = ranksum(Max(:,1),Max(:,2));
p_befor_resume = ranksum(Max(:,1),Max(:,3));


function [N_before,edges_before, N_after, edges_after] = plot_before_and_after_pressed(subj_num, edges, before_pressed, after_pressed, ms_time)
figure
histogram(before_pressed(:), 'BinEdges', edges, 'Normalization','countdensity');
[N_before,edges_before] = histcounts(before_pressed(:),edges);
hold on;
% histogram(mean_after_pressed)
histogram(after_pressed(:), 'BinEdges', edges, 'Normalization','countdensity')
[N_after,edges_after] = histcounts(after_pressed(:),edges);

title(append('Student No.',num2str(subj_num)))
subtitle(append('before and after pressed, num of sample:', num2str(ms_time)))
xlabel('frequency [Hz]')
ylabel('count')
% histogram(mean_pressed)
% histogram(before_pressed(:), 'BinEdges', edges);


% histogram(after_pressed(:), 'BinEdges', edges)

legend('Before button press','After button pressed')
end



function [N_before,edges_before, N_resume, edges_resume] = plot_before_pressed_and_after_video_resume(subj_num, edges, before_pressed, after_start_video, ms_time)
figure
histogram(before_pressed(:), 'BinEdges', edges, 'Normalization','countdensity');
[N_before,edges_before] = histcounts(before_pressed(:),edges);
hold on;
% histogram(mean_after_pressed)
histogram(after_start_video(:), 'BinEdges', edges, 'Normalization','countdensity')
[N_resume,edges_resume] = histcounts(after_start_video(:),edges);
title(append('Student No.',num2str(subj_num)))
subtitle(append('before pressed and after video resume, num of sample:', num2str(ms_time)))
xlabel('frequency [Hz]')
ylabel('count')
% histogram(mean_pressed)

legend('Before button press','After video resume')
end