function [N_before, edges_before, N_after, edges_after] = plot_before_and_after_pressed(subj_file_name, edges, before_pressed, after_pressed, ms_time)
figure
histogram(before_pressed(:), 'BinEdges', edges);
[N_before,edges_before] = histcounts(before_pressed(:),edges);
hold on;
% histogram(mean_after_pressed)
histogram(after_pressed(:), 'BinEdges', edges)
[N_after,edges_after] = histcounts(after_pressed(:),edges);

title(append('Student No.',subj_file_name))
subtitle(append('before and after pressed, num of sample:', num2str(ms_time)))
xlabel('Amp[dB/Hz]')
ylabel('count')
% histogram(mean_pressed)
% histogram(before_pressed(:), 'BinEdges', edges);


% histogram(after_pressed(:), 'BinEdges', edges)

legend('Before button press','After button pressed')
end
