function [prefiltered] = pcg_prefilter(signal, Fs)
    % Bandpass filtering
    band = [20 70];
    band_normalized = band / (Fs / 2); % Nyquist frequency Fs / 2
    [b, a] = butter(2, band_normalized, 'bandpass');
    filtered = filtfilt(b, a, signal);
    
    % Nulovani spektralnich car - zkusit
    
    prefiltered = filtered;
end