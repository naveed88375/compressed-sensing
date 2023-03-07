clear; close all; clc;          % Clearing MATLAB environment

%Create a sinusoidal signal
n=5000;
t=linspace(0,1/8,n);
y=sin(1394*pi*t)+sin(3266*pi*t);

%Plot the signal
subplot 211 
plot(t,y),grid
xlabel('Sample [n]')
ylabel('Amplitude')
axis([0 0.125 -2.5 2.5])
title('Original Signal')

%Take Discrete Cosine Transform
ft=dct(y);

%Pick 100 random samples from the signal
k = 10;
m=100;
r1= randintrlv([1:n], 793);
perm=r1(1:m);
y2=y(perm);
t2=t(perm);

%Reconstruct original signal with 100 samples using OMP
D=dct(eye(n,n));
A=D(perm,:);
y_r = OMP(k,y2,A);

%Plot reconstructed signal
subplot 212 
plot(idct(y_r));
xlabel('Sample [n]')
ylabel('Amplitude')
title('Reconstructed Signal')
