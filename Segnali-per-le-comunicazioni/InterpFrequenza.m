% PROGRAMMA InterpFrequenza
% Autore: Claudio Prati
% Politecnico di Milano, 11 Aprile 2014
%
% Interpolazione in frequenza con zero-padding nei tempi.

clear all
close all
clc

O=input('oversampling factor? ');
%% Segnale nel tempo
DT=.1;
N=16;
n=(0:N-1);
x=zeros(N,1);
x(1)=1/4;
x(2)=1/2;
x(3)=1/4;

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

%% Zero-padding nei tempi => interpolazione in frequenza

N2=N*O;
n2=(0:N2-1);
x=zeros(N2,1);
x(1)=1/4;
x(2)=1/2;
x(3)=1/4;

% Plot del segnale nei tempi dopo lo zero-padding
figure(2)
stem(n2*DT,x,'filled');
xlabel('TIME SAMPLES')
title('time series x N=32 samples at DT=1/10 sec.')
pause

% Trasformata del segnale dopo lo zero-padding
To2=N2*DT;
DF2=1/To2;
X2=fft(x);
stem(DF2*n2,abs(X2))
title('Absolute value of the DFT of the time series x after zero-padding')
xlabel('FREQUENCY HZ')
hold on
pause
stem(DF*n,abs(X),'r','filled')
hold off


