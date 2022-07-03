function std_analysis_plots(subj_file_name, alpha_raw, pressed_time, resume_time, pressed_num)

std_win = 10;
moving_std = movstd(alpha_raw(:,end), std_win);

figure
plot(alpha_raw(:,1), moving_std)
xline(pressed_time, 'color', 'r')
xline(resume_time, 'color', 'g')
legend('STD','Button pressed', 'resume video')
title(append('Student No.',subj_file_name))
subtitle(append('Standard deviation over 1 sec window. NumOfPressed:', num2str(pressed_num)))
xlabel('Time [sec]')
ylabel('STD')
ylim([0 0.02])


hold off
end