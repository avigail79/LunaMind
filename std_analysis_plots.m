function std_analysis_plots(subj_file_name, time, data, pressed_time, resume_time, pressed_num)

figure
plot(time, data)
xline(pressed_time, 'color', 'r')
xline(resume_time, 'color', 'g')
legend('STD','Button pressed', 'resume video')
title(append('Student No.',subj_file_name))
subtitle(append('Num of pressed in level 3-4:', num2str(pressed_num)))
xlabel('Time [sec]')
ylabel('STD')
ylim([0 0.5])


hold off
end