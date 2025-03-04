% PROGRAMMA MediaMobile
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2014

% Esegue una media mobile di 1000 campioni
% su una sequenza di N campioni costituita
% da una cosinusoide a bassissima frequenza 
% e da una retta a pendenza leggermente negativa.
% La media mobile e' eseguita tramite convoluzione con una finestra
% rettangolare di 1000 campioni di valore 1/1000.

clf 
clear all
close all
%% Genrazione del segnale cosinusoidale
N=11000;
n=1:N;
line=-n/20000;
x=0.15*cos(2*pi*n/2000)+line;

%% Progetto del filtro a media mobile
N_filter=1000;
h=ones(1,N_filter)/N_filter;

%% Filtraggio (convoluzione)
y=conv(x,h);

%% Plot

figure
plot((1:N-N_filter),x(N_filter/2+1:N-N_filter/2))
plot(x)
pause
hold on
plot(line)
pause
plot(y)
xlim([0 length(x)])
pause
legend('x','linea','segnale filtrato')

figure
subplot(3,1,1)
h(10000)=0;
plot((1:N-1000),h)
xlabel('samples')
title('filtro')
subplot(3,1,2)
plot(linspace(-1/2,1/2,length(h)),fftshift(abs(fft(h))));
xlabel('frequenza normalizzata')
title('Filtro in frequenza')
subplot(3,1,3)
plot(linspace(-1/2,1/2,length(h)),fftshift(abs(fft(h))));
axis([-1/100 1/100 0 1])
xlabel('frequenza normalizzata')
title('Zoom filtro in frequenza')
