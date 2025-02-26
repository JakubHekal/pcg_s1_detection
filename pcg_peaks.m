function [locations, min_peak_value] = pcg_peaks(signal, Fs)

    window_size = Fs;
    energy_std = movstd(signal, window_size, "Endpoints", std(signal));
    
    min_peak_value = 2.5 * energy_std;

    [peaks, locs] = findpeaks(signal, "MinPeakDistance", 300);

    i = 1;
    while i < length(peaks)
        if peaks(i) < min_peak_value(locs(i))
            locs(i) = [];
            peaks(i) = [];
        else
            i = i + 1;
        end
    end

    general_peak_distance = median(diff(locs));

    i = 1;
    while i < length(locs)
        min_peak_distance = 1.7 * abs(1 - general_peak_distance/3500) * general_peak_distance;
        
        if locs(i+1) - locs(i) < 0.5 * min_peak_distance && peaks(i+1) > 1.2 * peaks(i)
            locs(i) = [];
            peaks(i) = [];
            general_peak_distance = median(diff(locs));
        elseif locs(i+1) - locs(i) < min_peak_distance
            locs(i+1) = [];
            peaks(i+1) = [];
            general_peak_distance = median(diff(locs));
        else
            i = i + 1;
        end
    end
       
    locations = locs;
end

