function [  ] = SaveFitParameterData( PatientNumber, ParameterDirectory, varargin )
% Saves input parameter maps to CSV as column vector

%% Setup filepath
PatientTitle = strcat('Patient_',num2str(PatientNumber,'%03d'));

%% Save all inputs in loop
fprintf('Saving %d Parameters\n',length(varargin))

for k = 1:length(varargin)
    
    ParameterName   = inputname(2+k); % varargin starts at 3rd fx input
    ParameterToSave = varargin{k};
    ParameterToSave = ParameterToSave((ParameterToSave>0)); % select values inside lung
    csvwrite(strcat(ParameterDirectory,PatientTitle,'_',ParameterName,'.csv'),ParameterToSave(:))

end

end

