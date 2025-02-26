close all; clear; clc
load('PCG_dataset.mat');
% PCG_dataset = PCG_dataset_val;

Fs = 3000;
index = 424; % 426 564 544 601
PCG = PCG_dataset(index).PCG;
S1_real = PCG_dataset(index).S1_pos;
hr_real = mode(diff(S1_real));

filtered = pcg_prefilter(PCG, Fs);
energy = pcg_energy(filtered, Fs);    
[locations, min_peak] = pcg_peaks(energy, Fs);

figure;
subplot(3,1,1);
plot(PCG);
title('Original Signal');

subplot(3,1,2);
plot(filtered);
title('Filtered Signal');

subplot(3,1,3);
plot(energy);
title('Energy');

figure;
hold on
plot(energy);
xline(locations, "Color", "magenta");
xline(S1_real, "Color", "green");
plot(min_peak);
hold off
title('Peaks');
