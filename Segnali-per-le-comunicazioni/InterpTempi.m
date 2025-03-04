% PROGRAMMA InterpFrequenza
% Autore: Claudio Prati
% Politecnico di Milano, 11 Aprile 2014
%
% Interpolazione nei tempi con zero-padding in frequenza.

clear all
close all
clc

O=input('oversampling factor? ');

%% Segnale nel tempo
DT=.1;
N=16;
n=(0:N-1);
x=zeros(N,1);
x(4)=1/4;
x(5)=1/2;
x(6)=1/4;

% Plot del segnale
figure(1)
stem(n*DT,x,'filled');
xlabel('TIME SAMPLES')
title('time series x N=16 samples at DT=1/10 sec.')
pause

% DFT del segnale
To=N*DT;
DF=1/To;
X=fft(x);
stem(DF*n,abs(X),'r','filled')
title('Absolute value of the DFT of the time series x')
xlabel('FREQUENCY HZ')

pause

%% Zero-padding in frequenza => interpolazione nei tempi

N2=N*O;
n2=(0:N2-1);
X2=zeros(N2,1);
X2(1:N/2+1)=X(1:N/2+1);
X2(N2:-1:N2-N/2+2)=X(N:-1:N/2+2);

% Plot del segnale nelle frequenze dopo lo zero-padding
figure(2)
stem(DF*n2,abs(X2),'r','filled')
title('Absolute value of the DFT after frequency zero-padding')
xlabel('FREQUENCY HZ')
pause

% Anti-trasformata del segnale dopo lo zero-padding
x2=ifft(X2)*O;
DT2=To/N2;
stem(DT2*n2,real(x2))
title('time series x after interpolation')
xlabel('TIME')
hold on
pause
stem(n*DT,x,'filled');
xlabel('TIME')



