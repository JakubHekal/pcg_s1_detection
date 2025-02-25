close all; clear; clc
load('PCG_dataset.mat');
% PCG_dataset = PCG_dataset_val;

Fs = 3000;
index = 570; % 426 564 544 601
PCG = PCG_dataset(index).PCG;
S1_real = PCG_dataset(index).S1_pos;
hr_real = mode(diff(S1_real));

raw_s = fft(PCG);
len_s = length(raw_s);
s = abs(raw_s(1:len_s/2));


filtered = pcg_prefilter(PCG, Fs);
energy = pcg_energy(filtered, Fs);    
[locations, min_peak] = pcg_peaks(energy, Fs);

figure;
subplot(3,1,1);
plot(PCG);
title('Original Signal');

subplot(3,1,2);
plot(s);
title('Signal spectrum');

subplot(3,1,3);
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
