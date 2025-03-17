function [S1position] = S1detect(PCG, Fs)
    [locations, ~, ~] = pcg_peaks(PCG, Fs);
    S1position = locations;
end






