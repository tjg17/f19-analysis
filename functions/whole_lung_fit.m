function [ f4 ] = whole_lung_fit(  last_pfp, means, et_vector, nscans, beginning )
%WHOLE_LUNG_FIT ouputs the plot of the mean intesity value of whole lung
%ROI vs. time (in minutes) and the fit.  

%   The fit is calculated using the method
%   outlined in "Simon BA, Marcucci C, Fung M, Lele SR (1998) Parameter 
%   estimation and confidence intervals for Xe-CT ventilation studies: 
%   a Monte Carlo approach. J Appl Physiol 84:709–716".
avt = et_vector(last_pfp);

fullfit = fittype('(x>=t0 & x<=t1)*[d0 + (df-d0)*[1-exp(-(x-t0)/tau1)]] + (x>=t1)*[d0 + (df-d0)*[1-exp(-(t1-t0)/tau2)]*[exp(-(x-t1)/tau2)]] ', ... 
    'dependent', {'y'}, 'independent', {'x'}, ...
    'coefficients', {'d0', 'df', 'tau1', 'tau2', 't0', 't1'});

f4 = fit(et_vector(2:nscans), means(2:nscans), fullfit,'Robust', 'off','Algorithm', 'Levenberg-Marquardt',...
    'Startpoint', [10, 50, 100, 100, 0, avt]);
%     'Lower', [0,             max(means) - 30,  1,   1,   et_vector(2, 1) - 45, avt - 45],... %NEED TO DEFINE REASONABLE LIMITS FOR ALL COEEFFICIENTS EXCEPT TAU
%     'Upper', [min(means)+30, max(means) + 30,  500, 500, et_vector(2, 1) + 45, avt + 45],...
    

figure 
plot(f4, 'r-', et_vector, means)
heading = strcat( beginning, ' VOI Wash In/Out Curve' );
title(heading)
xlabel('Time (seconds)')
ylabel('Signal Intensity')
legend off
end

