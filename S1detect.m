function [S1position] = S1detect(PCG, Fs)
    energy = pcg_energy(PCG, Fs);    
    [locations, ~] = pcg_peaks(energy, Fs);
    S1position = locations;
end






