function [locations, min_peak_value] = pcg_peaks(pcg, signal, Fs)

    % Adaptive threshold calculation
    min_peak_value = movstd(signal, Fs, "Endpoints", mean(signal));
    
    % Find all peaks
    [peaks, locs] = findpeaks(signal, "MinPeakDistance", 700);
    
    % Removing peaks that are under threshold
    minimal_threshold_mask = (peaks >= min_peak_value(locs)) & (locs > 50);
    peaks = peaks(minimal_threshold_mask);
    locs = locs(minimal_threshold_mask);
    
    % Peak filtration (values in seconds)
    S1_S1_interval = [0.5 1.3] * Fs;
    S1_S2_interval = [0.2 0.4] * Fs;
    
    i = 1;
    while i < length(locs)
       j = i + 1;
       while j < length(locs)
           interval = locs(j) - locs(i);
           
           if interval >= S1_S1_interval(1) && interval <= S1_S1_interval(2)
               i = j;
               break;
           elseif interval > S1_S1_interval(2) || interval < S1_S2_interval(1)
               break;
           elseif interval >= S1_S2_interval(1) && interval <= S1_S2_interval(2)
               peaks(j) = [];
               locs(j) = [];
           else
               i = j;
               break;
           end
       end
       
       if i ~= j
            peaks(i) = [];
            locs(i) = [];
       end
    end
    
    % Moving peaks to find their true maximum
    hw = 30;
    i = 1;
    while i < length(locs)
       c = locs(i);
       s = pcg(max([1, c - hw]): min([length(pcg), c + hw]));
       m = max([1, c - hw]) + find(max(s));
       if isempty(m)
           locs(i) = [];
       else
           locs(i) = m;
           i = i + 1;
       end
    end
       
    locations = locs;
end

