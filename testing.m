close all; clear; clc
load('PCG_dataset_val.mat');
PCG_dataset = PCG_dataset_val;

Fs = 3000;
index = 605; % 545 530 498
PCG = PCG_dataset(index).PCG;
S1_real = PCG_dataset(index).S1_pos;
hr_real = mode(diff(S1_real));

[locations, min_peak, energy] = pcg_peaks(PCG, Fs);

figure;
subplot(2,1,1);
plot(PCG);
title('Original Signal');

subplot(2,1,2);
plot(energy);
title('Energy');

figure;
hold on
plot(energy);
xline(locations, "Color", "magenta");
xline(S1_real, "Color", "green", "LineStyle", "--", "LineWidth", 1.5);
plot(min_peak);
hold off
title('Peaks');
