function [normalized_energy] = pcg_energy(signal, Fs)
    % Bandpass filtering
    % Nyquist frequency Fs / 2
    [b, a] = butter(5, [20 80] / (Fs / 2), "bandpass");
    filtered = filtfilt(b, a, signal);

    energy = abs(filtered);
    energy = energy - movmean(energy, Fs/2);
    energy(energy < 0) = 0;
        
    normalized_energy = normalize(energy, "range");
end
