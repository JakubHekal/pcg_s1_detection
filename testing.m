close all; clear; clc
load('PCG_dataset_val.mat');
PCG_dataset = PCG_dataset_val;

Fs = 3000;
index = 508; % 426 564 544 601
PCG = PCG_dataset(index).PCG;
S1_real = PCG_dataset(index).S1_pos;
hr_real = mode(diff(S1_real));

filtered = pcg_prefilter(PCG, Fs);
energy = pcg_energy(filtered, Fs);    
[locations, min_peak] = pcg_peaks(energy, Fs);

figure;
subplot(2,1,1);
plot(PCG);
title('Original Signal');

subplot(2,1,2);
plot(filtered);
title('Filtered Signal');

figure;
hold on
plot(energy);
xline(locations, "Color", "magenta");
xline(S1_real, "Color", "green");
plot(min_peak);
hold off
title('Peaks');
