function std_analysis(alpha_raw, pressed_time, pressed_flag, resume_time, resume_flag)

std_win = 10;
moving_std = movstd(alpha_raw(:,end), std_win);

figure
plot(alpha_raw(:,1), moving_std)
title('Standard deviation over 1 sec window')
xlabel('Time [sec]')
ylabel('STD')
hold on
if pressed_flag
    xline(pressed_time, 'color', 'r')
    legend('STD','Button pressed')
end
    
if resume_flag
    xline(resume_time, 'color', 'g')
    legend('STD', 'resume_video')
end


hold off
end