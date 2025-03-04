% PROGRAMMA Oversampling
% Autore: Claudio Prati
% Politecnico di Milano, 8 Aprile 2014

% Campiona il segnale x(t)=cos(2*pi*t) con intervallo di campionamento
% DT=1/4 ottenendo il segnale xm.
% Interpola 4:1 i campioni di xm utilizzando un seno cardinale di 31
% campioni sinc((-15:15)/4).
% Il segnale interpolato 4:1 xn viene costruito come somma dei seni
% cardinali centrati sui campioni xm e moltiplicati per i valori dei
% campioni xm corrispondenti.
% 
%
clear all
close all
dt=1/1000;
t=(-2:.001:5);
x=cos(2*pi*1*t);
figure(1)
plot(t,x)
L=length(t);
axis([-2 4 -1.5 1.5])
grid on
xlabel('time')
title('time continuous signal x(t)')
pause

%---------------------------------------------
DT=1/4;
T=(-2:DT:5);
xm=x(1:DT/dt:L);
Lxm=length(xm);
figure(1)
hold on
stem(T,xm,'r','fill')
title('Signal sampled with DT=1/4')
pause

%---------------------------------------------

DT2=DT/4;
T2=(-2:DT2:5);
T2=(-2-(15*DT2):DT2:5+(15*DT2));
xn=zeros(1,length(T2));
figure(2)
for m=1:Lxm
    xn(4*m-3:4*(m-1)+31)=xn(4*m-3:4*(m-1)+31)+xm(m)*sinc((-15:15)/4);
    stem(T2,xn,'fill')
    axis([-2 4 -1.5 1.5])
    grid on
    xlabel('time')
    title('Progressive reconstruction of the oversampled 4:1 signal')
pause(.2)
end




    