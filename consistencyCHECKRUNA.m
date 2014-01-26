function [notemsg, errormsg] = consistencyCHECKRUNA(handles);

errormsg = '';
notemsg  = '';
noise_pixsize=str2num(get(handles.noisepixsize, 'String'));

%aiforRR = get(handles.aiforrr, 'Value');

% image parameters
tr = str2num(get(handles.tr, 'String')); %#ok<ST2NM>
fa = str2num(get(handles.fa, 'String')); %#ok<ST2NM>
time_resolution = str2num(get(handles.time_resolution, 'String')); %#ok<ST2NM>
hematocrit = str2num(get(handles.hematocrit, 'String')); %#ok<ST2NM>
snr_filter = str2num(get(handles.snr_filter, 'String')); %#ok<ST2NM>
relaxivity = str2num(get(handles.relaxivity, 'String')); %#ok<ST2NM>
injection_time = str2num(get(handles.injection_time, 'String')); %#ok<ST2NM>
water_fraction = str2num(get(handles.water_fraction, 'String')); %#ok<ST2NM>

if isempty(tr) || isempty(fa) || isempty(time_resolution) || isempty(hematocrit) || isempty(snr_filter) || ...
        isempty(relaxivity) || isempty(injection_time) || isempty(water_fraction)
    
    errormsg = 'Problem with image parameters';
    return;
end

% Check files

% First, we check whether the dynamic datasets are in order

filevolume = get(handles.filevolume, 'Value');
LUT = handles.LUT;

if filevolume == 1
    % 4D volume
    
    if size(LUT,1) > 1
        % More files input, but we only take the first one. notify user of
        % this
        notemsg = [notemsg '4D volume: only 1st file used'];
    end
elseif filevolume == 2
    % 3D volume
    
    if size(LUT,1) > 1 && size(LUT, 2) > 1
          % More files input, but we only take the first one. notify user of
        % this
        notemsg = [notemsg '3D volume: only 1st file of each row used'];
    end
elseif filevolume == 3
    % 2D volume
    
    numfiles = numel(find(LUT(1,:) > 0)); 
    for i = 2:size(LUT,1)
        
        if numfiles ~= numel(find(LUT(i,:) > 0));
            errormsg = 'Subsets have mismatched # of files';
            return;
        end
    end
    
    % Multislice volume, check if noise/roi files are ok
    
    numaif = numel(handles.tiaiffiles);
    numroi = numel(handles.tiroifiles);
    numt1map=numel(handles.t1mapfiles);
    
    if numaif ~= numfiles || numroi ~= numfiles || numt1map ~=numfiles
         errormsg = 'ROI files have mismatched # of files';
            return;
    end
        
    
    if get(noisefile, 'Value', 1)
        numnoise = numel(handles.noisefiles);
        
        if numnoise ~= numfiles
             errormsg = 'Noise files have mismatched # of files';
            return;
        end
    else
        isempty(noise_pixsize)
             notemsg = [notemsg 'Noise pixels defaulted to 81'];
             set(handles.noisepixsize, 'String', num2str(81));
    end
end
             
    
    
end
        
        


    
