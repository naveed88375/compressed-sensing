clear all; close all; clc;       %Clearing MATLAB environment
%% Signal generation 
 n = 5000;                        
 t = linspace(0, 1/8, n);              %Declaring time vector
 f = sin(1394*pi*t) + sin(3266*pi*t);  % "A" Dial tone
 ft = dct(f);                          % Discrete time cosine transform


%% Compressed Sensing
  m = 100;
  %r1 = randintrlv([1:n], 793);
  perm1 = (1:m/2);
  perm2 = (n-m/2:n);
  perm = [perm1, perm2];
  f2 = f(perm);
  t2 = t(perm);
  D = dct(eye(n, n));  % Fourier subspace
  A = D(perm, :);    
  cvx_begin;
   variable x3(n);
   minimize( norm(x3,1));
   subject to
   A*x3 == f2';
  cvx_end;
  yr = idct(x3)';
 
%% Adaptive amplification
  maxval = max(f2);
  minval = max(yr(max(perm1)+50:max(perm1)+150));
  amp = maxval/minval;  %Amplification Factor
  yr1 = [yr(1:max(perm1)),yr(max(perm1)+1:min(perm2)-1).*amp, yr(min(perm2):n)];
%% Plotting the waveforms
figure(1)
 subplot 211
 plot(t,f);
 xlabel('Time (sec)');
 ylabel('f(t)');
 title('Signal representation in time domain')
 subplot 212
 plot(ft)
 xlabel('n');
 ylabel('f(n)');
 title('Signal representation in frequency domain');
figure(2)
 subplot 211, plot(t,f, 'k', t2, f2, 'mo'),grid;
 axis([0 0.25 -3 3]);
 subplot 212, plot(yr1),grid
 axis([0 5000 -2.5 2.5])
 %% Finding the RMSE
 E = sqrt((sum((yr-f).^2))/n)