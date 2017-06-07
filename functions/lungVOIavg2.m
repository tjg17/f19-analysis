function [ timepts, means, times2, nrow, ncol, nslice, nel, nvox, x, y, z, last_pfp, mask, masked_all ] = lungVOIavg2( nscans, y, x, all, t1, times, ROI )
%lungVOIavg finds the mean signal intensity values of the lung volume.
%   This function uses a MIM derived mask to create the volume of
%   interest -- the lung.  The mean signal intensity is then recorded into
%   the output argument, "means" for this VOI.

%% Find mean of whole lung ROI

nvox = numel(all);

nslice = size(t1,3);
nrow = size(all,1);
ncol = size(all,2);
nel = nrow*ncol*nslice;

timepts = linspace(1,nscans,nscans).';

prompt = 'Enter scan number of last PFP breath-hold.';
z = input(prompt);
last_pfp = (y-z) + 1;

mask = ROI>0;

masked_all = cell(nrow, ncol, nslice, nscans);
roi_values = cell(nscans);
means = zeros(nscans,1);
a = 1;
b = nslice;
for j = 1:nscans
    
%     masked_all{j} = all(:,:,a:b).*(mask);
    masked_all{j} = all{j}.*(mask);
    roi_values{j} = masked_all{j}(masked_all{j}>0);
    means(j,1) = mean(roi_values{j});
    a = a + nslice;
    b = b + nslice;
end


times2 = times(:,1);

end

