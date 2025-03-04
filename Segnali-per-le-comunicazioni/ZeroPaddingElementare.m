% Zero Padding Elemenatre
% Aprile 2015
% Autore Claudio Prati
% Illustra come interpolare nei tempi di un fattore M allungando con N*(M-1) 
% zeri la DFT del segnale originale lungo N. 

clear all
close all
% N pari per semplicità
N=16;
% M: fattore di sovracampionamento
M=2;
% Generazione segnale x
x=cos(2*pi*(0:N-1)/N).^2;
% Calcolo della DFT di x
X=fft(x);
% Vettore in frequenza di zeri lungo N*M)
Y=zeros(1,N*M);
% Copia della DFT di x nei primi e negli ultimi campioni di Y
Y(1:N/2)=X(1:N/2);
Y(N*M:-1:N*M-N/2+1)=X(N:-1:N/2+1);
% Calcolo della IDFT di Y*M
y=ifft(Y*M);
%Visualizzazione di x, X, Y e Y
figure(1)
subplot(221)
stem((0:N-1),x)
xlabel('tempo discreti a basso campionamento')
axis([0 N-1 0 1])
title('x(nT)')

subplot(222)
stem((0:N-1),X,'filled')
xlabel('frequenza discreta')
axis([0 N-1 0 N/2])

subplot(224)
stem((0:N*M-1),Y*M,'filled')
xlabel('frequenza discreta')
axis([0 N*M-1 0 N*M/2])

subplot(223)
stem((0:N*M-1),y)
xlabel('tempo discreti a alto campionamento')
axis([0 N*M-1 0 1])
title('x(nT/M)')





