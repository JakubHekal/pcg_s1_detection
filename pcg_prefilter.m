function [prefiltered] = pcg_prefilter(signal, Fs)
    % Bandpass filtering
    band = [20 100];
    band_normalized = band / (Fs / 2); % Nyquist frequency Fs / 2
    [b, a] = butter(5, band_normalized, "bandpass");
    filtered = filtfilt(b, a, signal);
    
    % Nulovani spektralnich car - zkusit
    
    prefiltered = filtered;
end