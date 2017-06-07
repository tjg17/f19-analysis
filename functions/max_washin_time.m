function [ max_map, time2max_map, time2max_map_time, avg_time2max, avg_time2max_time, M, I, I2 ] = max_washin_time( vvec, nrow, ncol, nslice, nel, all, time, x, y, z, last_pfp, mask )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% time = tot_elap_time;
[M,I] = max(vvec, [], 2);
for i = 1: nel
    I2(i,1) = time(I(i));
end

%% Send max and time of max to Map
max_map1 = ones(nrow,ncol,nslice); %Map of Maximum Value
tm_map = ones(nrow,ncol,nslice); %Map of Scan Number of Maximum Value
tm_map_time = ones(nrow,ncol,nslice); %Map of Scan Number of Maximum Value

count = 1;
while count <= nel
    for a = 1:nslice
        for b = 1:nrow
            for c = 1:ncol
                max_map1(b, c, a) = M(count);
                tm_map (b, c, a) = I(count);
                tm_map_time (b, c, a) = I2(count);
                count = count+1;
            end
        end
    end
end

%% Sum of all PFP acquisitions for masking purposes
i = last_pfp;
% sumtest = zeros(nrow,ncol,nslice);
% while i > 0
%     sumtest = sumtest + all{i};
%     i = i - 1;
% end
% mask = sumtest>thresh;


% mask = all{last_pfp}(:, :, :)>thresh; %former mask of single PFP
% acquisition

%% Masking time-to-maximum wash-in map
masked_tm_map = mask.*tm_map; 
time2max_map = masked_tm_map;

masked_tm_map_time = mask.*tm_map_time; 
time2max_map_time = masked_tm_map_time;

%% Masking maximum intensity per voxel map
max_map = mask.*max_map1;

%% Find mode of time-to-maximum wash-in map
find_mode = masked_tm_map(masked_tm_map>0);
avg_time2max = mode(find_mode);

find_mode2 = masked_tm_map_time(masked_tm_map_time>0);
avg_time2max_time = mode(find_mode2);
end

