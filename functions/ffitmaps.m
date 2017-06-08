function [ d0_map, df_map, tau1_map, tau2_map, t0_map, t1_map, probe ] = ffitmaps( nrow, ncol, nslice, nscans, nel, time2max_map, time2max_mapt, vvec2, et_vector, f4 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


fullfit = fittype('(x>=t0 & x<=t1)*[d0 + (df-d0)*[1-exp(-(x-t0)/tau1)]] + (x>=t1)*[d0 + (df-d0)*[1-exp(-(t1-t0)/tau2)]*[exp(-(x-t1)/tau2)]] ', ...
    'dependent', {'y'}, 'independent', {'x'}, ...
    'coefficients', {'d0', 'df', 'tau1', 'tau2', 't0', 't1'});

d0_map = ones(nrow,ncol,nslice); %Map of d0
df_map = ones(nrow,ncol,nslice); %Map of df
tau1_map = ones(nrow,ncol,nslice); %Map of tau1
tau2_map = ones(nrow,ncol,nslice); %Map of tau2
t0_map = ones(nrow,ncol,nslice); %Map of t0
t1_map = ones(nrow,ncol,nslice); %Map of t1
probe = zeros(nel,3);

count = 1;

while count <= nel
    
    for a = 1:nslice
        fprintf('\n   Computing Slice %i of %i...',a,nslice); tStart = tic; % starts timer
        for b = 1:nrow
            for c = 1:ncol
                probe(count, 1) = a;
                probe(count, 2) = b;
                probe(count, 3) = c;
                if max(vvec2(count, :))>0
                    mt1 = (.5*f4.tau1);
                    mt2 = (.5*f4.tau2);
                    lower_limits = [vvec2(count, 1) - 50, vvec2(count, time2max_map(b, c, a)) - 50, f4.tau1 - mt1, f4.tau2 - mt2, et_vector(2, 1) - 60, time2max_mapt(b, c, a) - 60];
                    upper_limits = [vvec2(count, 1) + 50, vvec2(count, time2max_map(b, c, a)) + 50, f4.tau1 + mt1, f4.tau2 + mt2, et_vector(2, 1) + 60, time2max_mapt(b, c, a) + 60];
                    %                     lower_limits = [vvec2(count, 1) - 50, vvec2(count, time2max_map(b, c, a)) - 50, 0, 0, et_vector(2, 1) - 60, time2max_mapt(b, c, a) - 60];%for validation
                    %                     upper_limits = [vvec2(count, 1) + 50, vvec2(count, time2max_map(b, c, a)) + 50, 150, 150, et_vector(2, 1) + 60, time2max_mapt(b, c, a) + 60];%for validation
                    
                    start = [f4.d0, f4.df, f4.tau1, f4.tau2, f4.t0, f4.t1];
                    f_vvec = fit(et_vector(2: nscans), vvec2(count, 2:nscans).', fullfit,'Lower', lower_limits,... %LEFT OFF HERE!!!!
                        'Upper', upper_limits, 'Startpoint', start);              
                    
                    
                    %                     legend('off')
                    %                     plot(f_vvec, 'b-', et_vector, vvec2(count))
                    %                     hold on
                    %                     legend('off')
                    
                    
                    d0_map(b, c, a) = f_vvec.d0;
                    df_map (b, c, a) = f_vvec.df;
                    tau1_map(b, c, a) = f_vvec.tau1;
                    tau2_map(b, c, a) = f_vvec.tau2;
                    t0_map(b, c, a) = f_vvec.t0;
                    t1_map(b, c, a) = f_vvec.t1;
                else
                    d0_map(b, c, a) = 0;
                    df_map (b, c, a) = 0;
                    tau1_map(b, c, a) = 0;
                    tau2_map(b, c, a) = 0;
                    t0_map(b, c, a) = 0;
                    t1_map(b, c, a) = 0;
                end
                count = count + 1;
                
            end 
        end
        fprintf('done (%0.1f Seconds)',toc(tStart)) % print timing
    end
    
    
end


end

