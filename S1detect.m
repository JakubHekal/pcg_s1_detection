function [S1position] = S1detect(PCG, Fs)
    filtered = pcg_prefilter(PCG, Fs);
    energy = pcg_energy(filtered, Fs);    
    [locations, ~] = pcg_peaks(energy, Fs);
    S1position = locations;
end






