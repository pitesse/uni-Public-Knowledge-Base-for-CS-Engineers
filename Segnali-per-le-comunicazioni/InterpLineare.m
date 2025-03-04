% InterpLineare
% Aprile 2015
% Autore Claudio Prati
% Campiona una cosinusoide x a 100Hz con un intervallo di campionamento T
% minore del minimo teorico (1/200) dettato dal teorema del campionamento.
% Simula in discreto la ricostruzione con interpolazione lineare xl e con
% interpolazione a mantenimento xr.
% Calcola e visualizza gli spettri XL e XR dei segnali ricostruiti con i 
% due metodi.

clear all
close all
clc


% Scelta dell'intervallo di campionamento
T=1/800;
% Generazione dell'asse dei tempi (2 secondi)
t=(0:T:2);
% Generazione della sinusoide campionata
x=cos(2*pi*100*t);

figure(1)
stem((0:30)*T,x(1:31),'filled')

pause

%Generazione di xc (segnale campionato idealmente (gli impulsi continui
%sono sostituiti con impulsi discreti e intervallo di campionamento 10
%volte minore di quello della cosinusoide x

t2=(0:T/10:2);
xc(1:10:length(x)*10)=x;

%interpolazione lineare
hold on
tri(1:10)=(1:10)/10;
tri(11:20)=1-(1:10)/10;

xl=conv(xc,tri);

plot((0:300)*T/10,xl(10:310),'r')
pause

hold off 
N=length(xl);
XL=abs(fftshift(fft(xl)))/length(x)/10;
fs=10/T;
df=fs/N;
f=(-fs/4:df:fs/4-df);
M=(length(f)/2)*2;
plot(f,XL(N/2-M/2:N/2+M/2-1))
pause

%interpolazione rettangolare

stem((0:30)*T,x(1:31),'filled')
pause
hold on
rect=ones(1,10);
xr=conv(xc,rect);

plot((0:300)*T/10,xr(5:305),'r')
pause

hold off 
N=length(xr);
XR=abs(fftshift(fft(xr)))/length(x)/10;
fs=10/T;
df=fs/N;
f=(-fs/4:df:fs/4);
M=length(f);
plot(f,XR(N/2-M/2:N/2+M/2-1))


