% Power Spectral Density
% Maggio 2016
% Autore Claudio Prati
%  1 - Stima autocorrelazione e densità spettrale di potenza di un processo
%  casuale bianco gaussiano a valor medio nullo
%  2 - Stima autocorrelazione e densità spettrale di potenza di un processo
%  casuale bianco gaussiano a valor medio nullo filtrato con h
%  3 - Stima cross-correlazione uscita ingresso di un processo
%  casuale bianco gaussiano a valor medio nullo filtrato con h

clear all
close all
clc

%% Stima autocorrelazione processo casuale bianco

figure(1)
plot(randn(1,1000))
title('una realizzazione del processo bianco xn')
pause

Rx=zeros(1,1999);
for k=1:200
    x=randn(1,1000);
    Rxx=xcorr(x);
    Rx=Rx*(k-1)/k+Rxx/k/1000;
    
    figure(1)
    plot((-100:100),Rx(900:1100));
    axis([-100 100 -.5 1.2])
    title('stima autocorrelazione Rx(tau) del processo bianco')
    pause(1/k)
end

pause

%% Stima densità spettrale processo casuale bianco

Rx=zeros(1,1999);
for k=1:600
    x=randn(1,1000);
    Rxx=xcorr(x);
    Rx=Rx*(k-1)/k+Rxx/k/1000;
    
    figure(2)
    plot((-999:999)/2000,fftshift(real(fft(ifftshift(Rx)))))
    hold on
    plot((-999:999)/2000,ones(1,1999),'g')
    plot((-999:999)/2000,fftshift(imag(fft(ifftshift(Rx)))),'r')
    hold off
    axis([-.5 .5 -.2 3])
    title('stima DSS Sx(f) del processo bianco')
    pause(1/k)
end
pause

%% Stima autocorrelazione processo casuale bianco filtrato

h=[1/2 1/2];
hh=zeros(1,1999);
hh(1:2)=h;
H=fftshift(abs(fft(hh)));

figure(1)
plot(conv(randn(1,999),h))
title('una realizzazione del processo bianco filtrato yn')

pause

Ry=zeros(1,1999);
for k=1:200
    x=randn(1,999);
    y=conv(x,h);
    Ryy=xcorr(y);
    Ry=Ry*(k-1)/k+Ryy/k/1000;
    
    figure(1)
    stem((-100:100),Ry(900:1100));
    axis([-100 100 -.5 1.2])
    title('stima autocorrelazione Ry(tau) del processo bianco filtrato')
    pause(2/k)
end
pause

%% Stima densità spettrale processo casuale bianco filtrato

Ry=zeros(1,1999);
for k=1:1000
    x=randn(1,999);
    y=conv(x,h);
    Ryy=xcorr(y);
    Ry=Ry*(k-1)/k+Ryy/k/1000;
    
    figure(2)
    plot((-999:999)/2000,fftshift(real(fft(ifftshift(Ry)))))
    hold on
    plot((-999:999)/2000,H,'m')
    plot((-999:999)/2000,H.^2,'g')
    plot((-999:999)/2000,fftshift(imag(fft(ifftshift(Ry)))),'r')
    hold off
    axis([-.5 .5 -.2 2])
    title('stima DSS Sy(f) del processo bianco filtrato')
    
    pause(1/k)
end

%% Stima cross-correlazione uscita ingresso

Ryx=zeros(1,1999);
for k=1:200
    x=randn(1,999);
    y=conv(x,h);
    Ryxx=xcorr(y,x);
    Ryx=Ryx*(k-1)/k+Ryxx/k/1000;
    
    figure(1)
    stem((-20:20),Ryx(980:1020));
    axis([-20 20 -.75 .75])
    title('stima cross-correlazione Ryx(tau) del processo bianco filtrato')
    pause(1/k)
end

