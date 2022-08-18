% Find: 1) the number of fades in the initial signal; and 2) where these
% fades occur.
%--------------------------------------------------------------------------

% Find the number of fades in the initial signal, by first quantising the
% signal around the mean

clc;
clear;
M=15; %number of multipaths
N=10^5; %number of samples to generate
fd=100; % Maximum doppler spread in hertz
Ts=0.0001; % Sampling period in seconds
x=[0:N-1]*Ts;
initial_signal = 12*sin(16*x)+1;



h=rayleighFading(M,N,fd,Ts);
h_re=real(h);
h_im=imag(h);
figure;
subplot(2,1,1);
plot([0:(N-1)]*Ts,ifft(fft(initial_signal).*fft(h)));
title('Magnitude*initial signal');
xlabel('time(s)');ylabel('Amplitude |hI(t)|');
subplot(2,1,2);
plot([0:N-1]*Ts,h_im);
title('Imaginary part of impulse response of the Flat Fading channel');
xlabel('time(s)');ylabel('Amplitude |hQ(t)|');
figure;



quantised = initial_signal / mean(initial_signal) < 1;
crossings_up  = find(diff(quantised) == -1); % Index of when signal crosses above threshold of the mean, suggesting the end of a fade
crossings_down  = find(diff(quantised) == 1); % Index of when signal crosses below threshold of the mean, suggesting the beginning of a fade

% Remove stray crossings at start & end of data
if(length(crossings_up) > 1 && length(crossings_down) > 1)
    if(crossings_up(1) < crossings_down(1))
        crossings_up(1) = [];
    end
    if(crossings_down(end) > crossings_up(end))
        crossings_down(end) = [];
    end
end

% Hence the number of fades in the initial signal is...

% plot(x, initial_signal);

nfades = length(crossings_up)

