% Author: Borra Federico, Ph.D.,
% Politecnico di Milano, DEIB
% email address: federico.borra@polimi.it
% May 2017; Last revision: 04/05/2017

% Campiona il segnale x(t)=cos(t*2*pi*.2) con intervallo di campionamento
% DT=.5 ottenendo il segnale campionato xn.
% Mostra che gli stessi campioni si ottengono aumentando la frequenza del 
% coseno di multipli interi di 1/DT. 

clear
close all
clc

%% Segnali 'continui'
dt=.001;        % Periodo di campionamento molto breve per 'simulare' segnali continui 
t=(0:dt:5);     % Asse temporale

DT=.5;          % Periodo di campionamento         

% Coseni con frequenza che varia a multipli interi di 1/DT.
x1=cos(t*2*pi*.2);
x2=cos(t*2*pi*(.2+1/DT));
x3=cos(t*2*pi*(.2+2/DT));
x4=cos(t*2*pi*(.2+3/DT));

%% Campionamento dei segnali
T=(0:DT:5);                  % Asse temporale campionato

% Campionamento segnali 'continui'
xn_1=x1(1:DT/dt:length(t));    
xn_2=x2(1:DT/dt:length(t)); 
xn_3=x3(1:DT/dt:length(t)); 
xn_4=x4(1:DT/dt:length(t)); 

%% Plot
% Facciamo i plot di x1,x2,x3 e x4 e i rispettivi valori che otteniamo dal
% campionamento

figure(1)
plot(t,x1)
axis([0 5 -1.5 1.5])
xlabel('time')
title('Frequency of the cosine = 1/5 Hz')
grid on
hold on
pause
stem(T,xn_1,'filled')
pause

hold on
plot(t,x2,'r')
title('Frequency of the cosine = 1/5 + 1/DT Hz')
pause
stem(T,xn_2,'filled')
pause


hold on
plot(t,x3,'r')
title('Frequency of the cosine = 1/5 + 2/DT Hz')
pause
stem(T,xn_3,'filled')
pause

hold on
plot(t,x4,'r')
title('Frequency of the cosine = 1/5 + 3/DT Hz')
pause
stem(T,xn_4,'filled')


