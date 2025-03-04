% PROGRAMMA ConvChirp
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2017

% Esegue la convoluzione tra un chirp (coseno linearmente modulato in
% frequenza) ed una replica del chirp ribaltata nel tempo.
% Il risultato è un segnale di tipo impulsivo.
% Il programma fa anche ascoltare il suono del "chirp".

clear all
figure(1)
clf
figure(2)
clf
n=(1:100000);
x=cos(2*pi*n.^2/1000000);

w=.2+gausswin(100000);

chirp=x.*w';

h=fliplr(chirp);
L=length(chirp);
figure(1)
subplot(211)
plot((0:L-1)/22500,chirp)
title('chirp')
xlabel('TIME')
display('press for zooming')
pause
axis([500/22500 6000/22500 -.5 .5])
display('press for playing')
pause
soundsc(chirp,22500)
pause
subplot(212)
plot((0:L-1)/22500,h,'r')
title('time reversed chirp')
xlabel('TIME')
display('press for zooming')
pause
axis([(100000-6000)/22500 100000/22500 -.5 .5])
display('press for playing')
pause
soundsc(h,22500)
pause

figure(2)

subplot(211)
plot((0:L-1)/22500,chirp)
title('chirp')
xlabel('TIME')

y=conv(chirp,h);
display('press for chirp compression')
pause

subplot(212)
L2=length(y);
plot((0:L2-1)/22500,y)
title('chirp compression')
display('press for zooming')
pause
axis([99950/22500 100050/22500 -20000 30000])
