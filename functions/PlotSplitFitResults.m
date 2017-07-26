function [  ] = PlotSplitFitResults( PatientNumber, tau1_normal, tau1_split, tau2_normal, tau2_split, r2_normal, r2_split )
%Plot results of split fit vs. normal
figure('Name','Patient 003','NumberTitle','off')

subplot(3,2,1)
title('Tau1 - NORMAL')

C = tau1_map(tau1_map>0);
edges = [0 : 5 : 100];
figure
histogram(C,edges)
heading = strcat( beginning, ': Wash-in Rate' );
title(heading)
xlabel('Tau1 (seconds)')
ylabel('Count')

end

