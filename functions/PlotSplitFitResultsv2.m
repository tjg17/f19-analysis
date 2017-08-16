function [  ] = PlotSplitFitResultsv2( PatientNumber, FigureDirectory, tau1, tau2, dF, d0, r2_Washin, r2_Washout, mask )
%Plot results of split fit for tau1, tau2, d0, df, and both r2 in and out
% mask is needed for r2 map

%% Plot Results
PatientTitle = strcat('Patient_',num2str(PatientNumber,'%03d'));
figure( 'Name', PatientTitle , 'NumberTitle' , 'off' )

subplot(3,2,1)
data = tau1;
histogram_data = data(data>0);
edges = 0 : 4 : max(data(:));
histogram(histogram_data,edges)
title('tau1')

subplot(3,2,2)
data = tau2;
histogram_data = data(data>0);
edges = 0 : 4 : max(data(:));
histogram(histogram_data,edges)
title('tau2')

subplot(3,2,3)
data = dF;
histogram_data = data(data>0);
edges = 0 : 2 : max(data(:));
histogram(histogram_data,edges)
title('dF')

subplot(3,2,4)
data = d0;
histogram_data = data(data>0);
edges = 0 : 0.25 : max(data(:));
histogram(histogram_data,edges)
title('d0')

subplot(3,2,5)
data = r2_Washin;
data = single(data).*mask;
histogram_data = data(data>0);
edges = 0.8:0.01:1;
histogram(histogram_data,edges)
poorFits = length(find(r2_Washin<.8));
title(sprintf('R^2 - Washin (%i<0.8)',poorFits))

subplot(3,2,6)
data = r2_Washout;
data = single(data).*mask;
histogram_data = data(data>0);
edges = 0.8:0.01:1;
histogram(histogram_data,edges)
poorFits = length(find(r2_Washout<0.8));
title(sprintf('R^2 - Washout (%i<0.8)',poorFits))

%% Save Plot
saveas(gcf,strcat(FigureDirectory,PatientTitle,'.png'))

end

