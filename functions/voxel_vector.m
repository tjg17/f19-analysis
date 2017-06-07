function [ vvec, nrow, ncol, nslice, nel, nscans, x, y ] = voxel_vector( all_scan, nscans, x, y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nvox = numel(all_scan);
nel = numel(all_scan{1});
nslice = size(all_scan{1},3);
nrow = size(all_scan,1);
ncol = size(all_scan,2);
i = 1;%row
j = 1;%col
% k = 1;%slice
n = 1;
% p = 1;

vvec = ones(nel, nscans);

while n  <= nel%voxel
    for k = 1:nslice
%         k = p;
        while i <= nrow
            while j <= ncol
                for m = 1:nscans%scan
                    vvec(n,m) = all_scan{m}(i,j,k); % can be changed from all to all_roi
%                     k = p+(m*nslice);
                end
%                 k = p;%slice
                j = j+1;
                n = n+1;
            end
            j = 1;%col
            i = i+1;
        end
        i = 1;%row 
    end
end


end

