function std_analysis_plots(subj_file_name, alpha_raw, pressed_time, resume_time)

std_win = 10;
moving_std = movstd(alpha_raw(:,end), std_win);

figure
title(append('Student No.',subj_file_name))
subplot(2,1,1)
plot(alpha_raw(:,1), moving_std)
subtitle('Standard deviation over 1 sec window')
xlabel('Time [sec]')
ylabel('STD')
ylim([0 0.02])
hold on
if pressed_time
    xline(pressed_time, 'color', 'r')
    legend('STD','Button pressed')
end

subplot(2,1,2)
plot(alpha_raw(:,1), moving_std)
xlabel('Time [sec]')
ylabel('STD')
ylim([0 0.02])
hold on
if resume_time
    xline(resume_time, 'color', 'g')
    legend('STD', 'resume video')
end

hold off
end