% PROGRAMMA TFdiscreta
% Autore: Claudio Prati
% Politecnico di Milano, 11 Aprile 2014
%
% Calcolo della DFT di alcune sequenze x di N campioni e confronto con la
% Trasformata di Fourier continua in frequenza della stessa squenza.
% Prima sequenza 1/4 1/2 1/4 simmetrica rispotto a n=0
% Seconda sequenza -1/4 1/2 -1/4 simmetrica rispotto a n=0
% Terza sequenza cos(2*pi*n/8) con n tra 0 e N-1 (numero intero di cicli)
% Quarta sequenza cos(2*pi*n/7) con n tra 0 e N-1 (numero non intero di cicli)

clear all
close all
clc

%% First time series (LP)

DT=.1;          % Periodo di campionamento
N=32;           % Numero di samples 
n=(0:N-1);

% Serie discreta
x=zeros(N,1);
x(1)=1/2;
x(2)=1/4;  
x(N)=1/4;
stem(n,x,'filled');
xlabel('TIME SAMPLES')
title('first time series to be tranformed')
display('PLEASE NOTICE THE CIRCULAR FORMAT OF THE TIME SERIES: ACTUALLY THE 3 SAMPLES ARE SYMMETRIC WRT 0')

pause
% Trasformata del segnale campionato
To=N*DT;    % Lunghezza segnale in secondi
DF=1/To;    % Passo di campionamento in frequenza 
X=fft(x);
stem(n,real(X)) 
title('DFT of the time series x')
xlabel('FREQUENCY SAMPLES')
pause
stem(DF*n,real(X))
title('DFT of the time series x')
xlabel('FREQUENCY HZ')

pause
% Segnale 'continuo'
M=1000;
m=(0:M-1);
xx=zeros(M,1);
xx(1)=1/2;
xx(2)=1/4;
xx(M)=1/4;

% Transformata del segnale 'continuo'
TTo=M*DT;
df=1/TTo;
XX=fft(xx);
plot(df*m,real(XX))
xlabel('FREQUENCY HZ')
title('TF continuous in frequency of the time series x')
hold on
pause
stem(DF*n,abs(X),'r','filled')
title('TF (blue) and DFT (red) of the time series x')

pause
hold off

%% Second time series (HP)
clf
close all
clear all

DT=.1;
N=32;
n=(0:N-1);

% Segnale discreto
x=zeros(N,1);
x(1)=1/2;
x(2)=-1/4;
x(N)=-1/4;
stem(n,x,'filled');
xlabel('TIME SAMPLES')
title('second time series to be tranformed')
pause

% Transformata del segnale discreto
To=N*DT;
DF=1/To;
X=fft(x); 
stem(n,real(X))
xlabel('FREQUENCY SAMPLES')
title('DFT of the time series x')
pause
stem(DF*n,real(X))
xlabel('FREQUENCY HZ')
title('DFT of the time series x')

pause

% Segnale 'continuo'
M=1000;
m=(0:M-1);
xx=zeros(M,1);
xx(1)=1/2;
xx(2)=-1/4;
xx(M)=-1/4;

% Transformata del segnale 'continuo'
TTo=M*DT;
df=1/TTo;
XX=fft(xx);
plot(df*m,real(XX))
xlabel('FREQUENCY HZ')
title('TF continuous in frequency of the time series x')
hold on
pause
stem(DF*n,real(X),'r','filled')
title('TF (blue) and DFT (red) of the time series x')

display('PRESS TO COMPUTE THE INVERSE DFT FROM THE SAMPLES OF X')
pause
hold off
y=ifft(X);
stem(n,y,'r','filled');
xlabel('TIME SAMPLES')
title('IDFT of the frequency series X')

pause

%% Third time series (cos: integer number of cycles)

clf
close all
clear all

DT=.1;
N=32;
n=(0:N-1);

% Segnale discreto
x=cos(2*pi*n/8);
stem(n,x,'filled');
xlabel('TIME SAMPLES')
title('third time series to be tranformed')
pause

% Traformata del segnale discreto
To=N*DT;
DF=1/To;
X=fft(x);
stem(n,real(X))
hold on
stem(n,imag(X),'r')
xlabel('FREQUENCY SAMPLES')
title('DFT of the time series x (real=blue, imag=red)')
hold off
pause
stem(DF*n,real(X))
hold on
stem(DF*n,imag(X),'r')
xlabel('FREQUENCY HZ')
title('DFT of the time series x (real=blue, imag=red)')
hold off

pause
% Segnale 'continuo'
M=1000;
m=(0:M-1);
xx=zeros(M,1);
xx(1:N)=cos(2*pi*n/8);

% Traformata del segnale 'continuo'
TTo=M*DT;
df=1/TTo;
XX=fft(xx);
plot(df*m,real(XX))
hold on
plot(df*m,imag(XX),'r')
xlabel('FREQUENCY HZ')
title('TF continuous in frequency of the time series x (real=blue, imag=red)')
grid on
pause
stem(DF*n,real(X),'b','filled')
stem(DF*n,imag(X),'r','filled')
title('TF and DFT of the time series x (real=blue, imag=red)')

pause

%% Fourth time series (cos: non-integer number of cycles)

clf
close all
clear all
DT=.1;
N=32;
n=(0:N-1);

% Segnale discreto
x=cos(2*pi*n/7);
stem(n,x,'filled');
xlabel('TIME SAMPLES')
title('fourth time series to be tranformed')
pause

% Trasformata del segnale discreto
To=N*DT;
DF=1/To;
X=fft(x);
stem(n,real(X))
hold on
stem(n,imag(X),'r')
xlabel('FREQUENCY SAMPLES')
title('DFT of the time series x (real=blue, imag=red)')
hold off
pause
stem(DF*n,real(X))
hold on
stem(DF*n,imag(X),'r')
xlabel('FREQUENCY HZ')
title('DFT of the time series x (real=blue, imag=red)')
hold off


pause

% Segnale 'continuo'
M=1000;
m=(0:M-1);
xx=zeros(M,1);
xx(1:N)=cos(2*pi*n/7);

% Traformata del segnale 'continuo'
TTo=M*DT;
df=1/TTo;
XX=fft(xx);
plot(df*m,real(XX))
hold on
plot(df*m,imag(XX),'r')
xlabel('FREQUENCY HZ')
title('TF continuous in frequency of the time series x (real=blue, imag=red)')
grid on
pause
stem(DF*n,real(X),'b','filled')
stem(DF*n,imag(X),'r','filled')
title('TF and DFT of the time series x (real=blue, imag=red)')


