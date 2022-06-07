function [N_before,edges_before, N_resume, edges_resume] = plot_before_pressed_and_after_video_resume(subj_file_name, edges, before_pressed, after_start_video, ms_time)
figure
histogram(before_pressed(:), 'BinEdges', edges);
[N_before,edges_before] = histcounts(before_pressed(:),edges);
hold on;
% histogram(mean_after_pressed)
histogram(after_start_video(:), 'BinEdges', edges)
[N_resume,edges_resume] = histcounts(after_start_video(:),edges);
title(append('Student No.',subj_file_name))
subtitle(append('before pressed and after video resume, num of sample:', num2str(ms_time)))
xlabel('frequency [Hz]')
ylabel('count')
% histogram(mean_pressed)

legend('Before button press','After video resume')
end