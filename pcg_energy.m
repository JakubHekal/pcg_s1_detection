function [normalized_energy] = pcg_energy(signal, Fs)
    % Bandpass filtering
    % Nyquist frequency Fs / 2
    [b, a] = butter(4, [10 50] / (Fs / 2), "bandpass");
    filtered = filtfilt(b, a, signal);

    % TKEO implementation
    energy = tkeo(filtered);
    
    % Smoothing function and removing negative peaks
    energy = movmean(energy, 11);
    energy(energy < 0) = 0;
       
    % Normalizing energy
    normalized_energy = normalize(energy, "range");
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

