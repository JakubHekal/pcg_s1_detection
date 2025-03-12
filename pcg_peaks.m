function [locations, min_peak_value] = pcg_peaks(pcg, signal, Fs)

    window_size = Fs;
    energy_std = movstd(signal, window_size, "Endpoints", std(signal));
    
    min_peak_value = 2.5 * energy_std;

    [peaks, locs] = findpeaks(signal, "MinPeakDistance", 700);

    i = 1;
    while i < length(peaks) + 1
        if peaks(i) < min_peak_value(locs(i))
            locs(i) = [];
            peaks(i) = [];
        else
            i = i + 1;
        end
    end

    general_peak_distance = mode(diff(locs));

    i = 1;
    while i < length(locs)
        min_peak_distance = 1.7 * abs(1 - general_peak_distance/3500) * general_peak_distance;
        
        if locs(i+1) - locs(i) < 0.5 * min_peak_distance && peaks(i+1) > 1.05 * peaks(i)
            locs(i) = [];
            peaks(i) = [];
            general_peak_distance = mode(diff(locs));
        elseif locs(i+1) - locs(i) < min_peak_distance
            locs(i+1) = [];
            peaks(i+1) = [];
            general_peak_distance = mode(diff(locs));
        else
            i = i + 1;
        end
    end
    
    hw = 20;
    for i = 1:length(locs)
       c = locs(i);
       s = pcg(max([1 c - hw]): min([length(pcg) c + hw]));
       locs(i) = c - hw + find(max(s));
    end
       
    locations = locs;
end
