% PROGRAMMA Campionamento
% Autore: Claudio Prati
% Politecnico di Milano, 8 Aprile 2014

% Campiona il segnale x(t)con intervallo di campionamento DT ottenendo il
% segnale campionato xn.
% Esegue la ricostruzione del segnale tempo-continuo x(t) convolvendo i campioni
% di xn con il filtro di ricostruzione ideale h(t) (sinc troncato).
% Mostra la sovrapposizione del filtro di ricostruzione applicato ai singoli campioni
% mettendo in evidenza che nessun campione interpolato interagisce con gli
% altri.
% Inoltre mostra la somma progressiva dei campioni interpolati con il
% filtro di ricostruzione fino ad ottenere il segnale ricostruito x(t).


clear all
close all
clc

%% Segnale 'continuo'
dt=.001;
t=(0:dt:8);
x=gausswin(length(t));

%% Campionamento del segnale
DT=0.5;
T=(0:DT:8);
xn=x(1:DT/dt:length(t));

% Plot segnale 'continuo' e segnale campionato
figure(1)
plot(t,x)
axis([0 8 -0.25 1.1])
xlabel('time')
title('original time-continuous signal')
grid on
hold on
pause
stem(T,xn,'r')
title('sampled signal')

%% Filtro interpolante
tt=(-16:dt:16);

pause
figure(1)
for k=1:length(T)
    hold on
    axis([0 8 -0.25 1.1])
    grid on
    plot(tt,xn(k)*sinc((tt-(k-1)*DT)/DT))
    xlabel('time')
    title('convolution of the reconstruction filter with each sample')
    pause
end
hold off

%% Convoluzione con seno cardinale per ricostruire il segnale 'continuo'
%  Ricorda: in questo caso possiamo sommare i seni cardinali shiftati
%  nella posizioni dei campioni

r=zeros(1,length(tt));
figure(1)
for k=1:length(T)
    r=r+xn(k)*sinc((tt-(k-1)*DT)/DT);
    plot(tt,r)
    hold on
    stem(T,xn,'r')
    xlabel('time')
    title('convolution of the reconstruction filter with the sampled signal')
    grid on
    axis([0 8 -0.25 1.1])
    hold off
    pause
end

% Plot del segnal originale
figure(1)
hold on
plot(t,x,'g--')
legend('recontructed signal','sampled signal','original signal')

