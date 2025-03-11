function [normalized_energy] = pcg_energy(signal, Fs)
    energy = abs(signal .^ 2);
    energy = energy - movmean(energy, Fs/2);
    energy(energy < 0) = 0;
        
    normalized_energy = normalize(energy, "range");
end
