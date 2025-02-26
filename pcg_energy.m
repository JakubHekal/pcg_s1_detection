function [normalized_energy] = pcg_energy(signal, Fs)
    signal = abs(signal);
    energy = -signal .* log(signal);
    
    energy = energy - movmean(energy, Fs);
    energy(energy < 0) = 0;
    
    normalized_energy = normalize(energy, "range");
end
