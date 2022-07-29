function [out_button, before_pressed, after_pressed, video_state_start] = pressed(out_data, alpha_raw)

out_button = []; % the button pressed from out file
video_state = zeros(1,3);
j = 0;
v = 0;

for i=1:size(out_data,1)
    if strcmp(out_data{i,3},'button_pressed')
        j = j+1;
        out_button(j,1) = i; %save the row index
        out_button(j,2) = out_data{i,1}; % save the time
        out_button(j,3) = out_data{i,4}; % save the focus level
    end
    if strcmp(out_data{i,3},'video_state')
        v = v+1;
        video_state(v,1) = i; %save the row index
        video_state(v,2) = out_data{i,1}; % save the time
        if strcmp(out_data{i,4},'video_pause')
            video_state(v,3) = 0;
        elseif strcmp(out_data{i,4},'video_play')
            if out_data{i,4} == 'video_play'
                video_state(v,3) = 1;
            end
        end

    end
end

video_state_start_indicies = find(video_state(:,3) == 1);
video_state_start = video_state(video_state_start_indicies,:);

% take time sec before and after the press
ms_time = 200;
%     ms_time = 50;

before_pressed = zeros(ms_time+1, length(out_button)); % time before the pressed
after_pressed = zeros(ms_time+1, length(out_button)); % time after the pressed
after_start_video = zeros(ms_time+1, length(out_button));% time after video play

for b = 1:size(out_button, 1)

    % remove button with focus level 1 or 2
    if out_button(b, 3) == 3 || out_button(b, 3) == 4
        continue
    end

    time_preseed_raw_idx = find(alpha_raw > out_button(b,2)); % find the closet bottom presed idx in raw (1)
    time_preseed_raw_idx_vec(b) = find(alpha_raw > out_button(b,2),1,'first'); % find the closet bottom pressed idx in raw (1)

    time_play_out_idx = find(video_state_start(:,2) > out_button(b,2)); % find the idx time of the start video after button pressed in out
    time_play_raw_idx = find(alpha_raw > video_state_start(time_play_out_idx(1), 2)); % find the idx time of the start video afeter button pressed in raw

    if time_preseed_raw_idx(1) > ms_time
        before_pressed(:,b) = alpha_raw(time_preseed_raw_idx(1)-ms_time:time_preseed_raw_idx(1),end);
    else
        before_pressed(:,b) = [zeros(ms_time+1-time_preseed_raw_idx(1),1); alpha_raw(1:time_preseed_raw_idx(1),end)];
    end

    if time_play_raw_idx(1)+ms_time < size(alpha_raw, 1)
        after_pressed(:,b) = alpha_raw(time_preseed_raw_idx(1):time_preseed_raw_idx(1)+ms_time,end);
    else
        after_pressed(:,b) = alpha_raw(time_preseed_raw_idx(1):end,end);
    end

    after_start_video(:,b) = alpha_raw(time_play_raw_idx:time_play_raw_idx+ms_time, end);
end

before_pressed(isnan(before_pressed))=0;
after_pressed(isnan(after_pressed))=0;

end