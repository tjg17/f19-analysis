function [ masked_all ] = maskcellimages( mask, all, nrow, ncol, nslice, nscans )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



j = 1;

masked_all = cell(nrow, ncol, nslice, nscans);
for i = 1 : nscans
    um = all{i};
    masked = um .* mask;
    masked_all{j}(:, :, :) = masked;
    j = j + 1;
end

end

