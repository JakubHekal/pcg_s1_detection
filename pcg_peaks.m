function [locations, min_peak_value, normalized_energy] = pcg_peaks(signal, Fs)
    % Bandpass filtering
    [b, a] = butter(4, [10 50] / (Fs / 2), "bandpass");
    filtered = filtfilt(b, a, signal);

    % TKEO implementation
    energy = tkeo(filtered);
    
    % Smoothing function and removing negative peaks
    energy = movmean(energy, 11);
    energy(energy < 0) = 0;
       
    % Normalizing energy
    normalized_energy = normalize(energy, "range");

    % Adaptive threshold calculation
    min_peak_value = movstd(normalized_energy, Fs);
    
    % Find all peaks
    [peaks, locs] = findpeaks(normalized_energy, "MinPeakDistance", Fs/4);
    
    % Removing peaks that are under threshold
    minimal_threshold_mask = (peaks >= min_peak_value(locs)) & (locs > 500);
    peaks = peaks(minimal_threshold_mask);
    locs = locs(minimal_threshold_mask);
    
    % Peak filtration (values in seconds)
    S1_S1_interval = [0.4 1.5] * Fs;
    S1_S2_interval = [0.2 0.4] * Fs; 
    
    i = 1;
    locations = [];
    while i <= length(locs)
       candidates = locs(i:end);
       S1_candidates = candidates((candidates - locs(i) <= S1_S1_interval(2)) & (candidates - locs(i) >= S1_S1_interval(1)));
       S2_candidates = candidates((candidates - locs(i) <= S1_S2_interval(2)) & (candidates - locs(i) >= S1_S2_interval(1)));
       
       if ~isempty(S2_candidates)
           locs = setdiff(locs, S2_candidates, 'stable');
       end
       
       if ~isempty(S1_candidates)
           if isempty(locations)
               locations = [locations, locs(i)];
           end
           locations = [locations, S1_candidates(1)];
       end
       i = i + 1;   
    end
    
    % Moving peaks to find their true maximum
    hw = 30;
    i = 1;
    while i < length(locations)
       c = locations(i);
       s = signal(max([1, c - hw]): min([length(signal), c + hw]));
       m = max([1, c - hw]) + find(max(s));
       if isempty(m)
           locations(i) = [];
       else
           locations(i) = m;
           i = i + 1;
       end
    end
end

function y = tkeo(x)
    N = length(x);
    y = zeros(size(x));
    
    for n = 2:N-1
        y(n) = x(n)^2 - x(n-1)*x(n+1);
    end
    
    y(1) = x(1)^2 - x(1)*x(2);
    y(N) = x(N)^2 - x(N-1)*x(N);
end


