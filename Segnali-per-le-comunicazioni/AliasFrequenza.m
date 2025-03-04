% PROGRAMMA AliasFrequenza
% Autore: Claudio Prati
% Politecnico di Milano, 8 Aprile 2014

% Campiona il segnale x(t)=sin(t*2*pi*3) con frequenza di campionamento
% a scelta ottenendo il segnale campionato xn.
% Mostra l'effetto dell'alias in frequenza quando non si rispetta il teorema 
% del campionamento che dice che fs>6.
% Si provi a vedere cosa succede se si utilizza fs=24, fs=12, fs=4, fs=3.


clear all
close all
clc

%% Segnale 'continuo'
t=(0:.001:1);
x=sin(2*pi*3*t);

% Plot del segnale 'continuo'
figure(1)
plot(t,x)
grid on
xlabel('time')
title('sinusoid frequency = 3Hz')
hold on

%% Richiesta all'utente del periodo di campionamento
fs=input('frequenza di campionamento fs? ');

%% Campionamento
T=1/fs;             % Periodo di campionamento
nT=(0:T:1);         % Asse tempi campionato
xn=sin(2*pi*3*nT);  % Segnale campionato

% Plot dei campioni del segnale nella stessa figura di prima
figure(1)
stem(nT,xn,'r','filled')
hold off

