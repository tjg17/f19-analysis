function [  ] = PlotSplitFitResults( PatientNumber, tau1_normal, tau1_split, tau2_normal, tau2_split, r2_normal, r2_split, mask )
%Plot results of split fit vs. normal
% mask is needed for r2 map

%Plot results of split fit vs. normal
figure('Name',strcat('Patient_',num2str(PatientNumber,'%03d')),'NumberTitle','off')

subplot(3,2,1)
data = tau1_normal;
histogram_data = data(data>0);
edges = 0 : 2 : max(data(:));
histogram(histogram_data,edges)
title('Tau1 - NORMAL')

subplot(3,2,2)
data = tau1_split;
histogram_data = data(data>0);
edges = 0 : 2 : max(data(:));
histogram(histogram_data,edges)
title('Tau1 - SPLIT')

subplot(3,2,3)
data = tau2_normal;
histogram_data = data(data>0);
edges = 0 : 2 : max(data(:));
histogram(histogram_data,edges)
title('Tau2 - NORMAL')

subplot(3,2,4)
data = tau2_split;
histogram_data = data(data>0);
edges = 0 : 2 : max(data(:));
histogram(histogram_data,edges)
title('Tau2 - SPLIT')

subplot(3,2,5)
data = r2_normal;
data = single(data).*mask/100;
histogram_data = data(data>0);
edges = 0.8:0.01:1;
histogram(histogram_data,edges)
poorFits = length(find(r2_normal<80));
title(sprintf('R^2 - NORMAL (%i<0.8)',poorFits))

subplot(3,2,6)
data = r2_split;
data = single(data).*mask/100;
histogram_data = data(data>0);
edges = 0.8:0.01:1;
histogram(histogram_data,edges)
poorFits = length(find(r2_split<80));
title(sprintf('R^2 - SPLIT (%i<0.8)',poorFits))

end

