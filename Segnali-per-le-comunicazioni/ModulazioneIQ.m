% PROGRAMMA ModulazioneIQ
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2014

% Esegue la modulazione e demodulazione in fase e quadratura di 2 segnali
% gaussiani x1(t) e x2(t) con ampiezze il primo il doppio del secondo. I
% segnali modulati coseno e seno (y1(t) e y2(t)) sono sommati tra loro a
% formare il segnale modulato IQ z(t). Il segnale z(t) viene demodulato
% coseno (z1(t)) e poi seno (z2(t)). La componente a bassa frequenza di
% z1(t) e z2(t) coincide con i 2 segnali iniziali gaussiani x1(t) e x2(t).
% ATTENZIONE i segnali nel dominio delle ftrequenze sono ottenuti
% moltiplicando i risultati della DFT per l'intervallo di campionamento dt.
% In pratica si è approssimato l'integrale dela trasformata di Fourier con
% una scalinata ottenuta utilizzando un intervallo di campionamento molto
% piccolo.

clear all
close all
dt=.0002;
N=2000;
fo=200;
t=(-N:N-1)'*dt;
df=1/(dt*(2*N));
f=(-N:N-1)'*df;
display('SEGNALE x1(t) A BASSA FREQUENZA DA MODULARE COSENO')
figure(1)
clf
xx1=(gausswin(2*N+1,20));
x1=xx1(1:2*N);
plot(t,x1)
axis([-dt*2*N/10 dt*2*N/10 -0.5 1.5])
grid on
xlabel('time (seconds)')
title('x1(t)')

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (reale) X1(f)')
pause

figure(2)
clf
X1=fft(fftshift(x1));
plot(f,fftshift(real(X1))*dt)
axis([-3*fo 3*fo -100*dt 300*dt])
grid on
xlabel('frequency (Hz)')
title('Real part of X1(f)')

display('PREMERE PER VISUALIZZARE SEGNALE x2(t) A BASSA FREQUENZA DA MODULARE SENO')
pause

figure(1)
hold on
xx2=.5*(gausswin(2*N+1,20));
x2=xx2(1:2*N);
plot(t,x2,'r')
axis([-dt*2*N/10 dt*2*N/10 -0.5 1.5])
xlabel('time (seconds)')
title('x1(t) and x2(t)')
hold off

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (reale) X2(f)')
pause

figure(2)
hold on
X2=fft(fftshift(x2));
plot(f,fftshift(real(X2))*dt,'r')
axis([-3*fo 3*fo -100*dt 300*dt])
xlabel('frequency (Hz)')
title('Real part of X1(f) and X2(f)')
hold off

display('PREMERE PER VISUALIZZARE y1(t)=x1(t)*cos(2*pi*t*fo)')
pause

y1=x1.*cos(2*pi*t*fo);
figure(3)
plot(t,y1)
axis([-dt*2*N/10 dt*2*N/10 -1.5 1.5])
grid on
xlabel('time (seconds)')
title('y1(t)=x1(t)*cos(2*pi*t*fo)')

display('PREMERE PER VISUALIZZARE y2(t)=x2(t)*sin(2*pi*t*fo)')
pause
y2=x2.*sin(2*pi*t*fo);
figure(3)
hold on
plot(t,y2,'r')
xlabel('time (seconds)')
title('y1(t)=x1(t)*cos(2*pi*t*fo) and y2(t)=x2(t)*sin(2*pi*t*fo)')
axis([-dt*2*N/10 dt*2*N/10 -1.5 1.5])

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (reale) Y1(f)')
pause

figure(4)
Y1=fft(fftshift(y1));
Y2=fft(fftshift(y2));
plot(f,fftshift(real(Y1))*dt)
axis([-3*fo 3*fo -100*dt 200*dt])
grid on
xlabel('frequency (Hz)')
title('Real part of Y1(f)')
hold on

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (immaginaria) Y2(f)')
pause

plot(f,fftshift(imag(Y2))*dt,'r')
axis([-3*fo 3*fo -100*dt 200*dt])
xlabel('frequency (Hz)')
title('Real part of Y1(f) and Imaginary part of Y2(f)')

display('PREMERE PER VISUALIZZARE z(t)=y1(t)+y2(t)')
pause

z=y1+y2;
figure(5)
plot(t,z)
grid on
xlabel('time (seconds)')
title('y1(t)+y2(t)')
axis([-dt*2*N/10 dt*2*N/10 -1.5 1.5])

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (complessa) Z(f)')

pause
Z=fft(fftshift(z));
figure(6)
plot(f,fftshift(real(Z))*dt)
axis([-3*fo 3*fo -100*dt 200*dt])
grid on
hold on
plot(f,fftshift(imag(Z))*dt,'r')
axis([-3*fo 3*fo -100*dt 200*dt])
xlabel('frequency (Hz)')
title('Real and Imaginary part of Z(f)')

display('PREMERE PER VISUALIZZARE z1(t)=z(t)*cos(2*pi*t*fo)')
pause

z1=z.*2.*cos(2*pi*t*fo);
z2=z.*2.*sin(2*pi*t*fo);
figure(7)
plot(t,z1);
grid on
xlabel('time (seconds)')
title('z(t)*cos(2*pi*t*fo)')
axis([-dt*2*N/10 dt*2*N/10 -1.5 2.5])
hold on

display('PREMERE PER VISUALIZZARE z2(t)=z(t)*sin(2*pi*t*fo)')
pause
plot(t,z2,'r');
grid on
xlabel('time (seconds)')
title('z(t)*2*cos(2*pi*t*fo) and z(t)*2*sin(2*pi*t*fo) ')
axis([-dt*2*N/10 dt*2*N/10 -1.5 2.5])

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (complessa) Z1(f)')
pause

figure(8)
Z1=fft(fftshift(z1));
Z2=fft(fftshift(z2));
subplot(211)
plot(f,fftshift(real(Z1))*dt)
axis([-3*fo 3*fo -100*dt 300*dt])
grid on
xlabel('frequency (Hz)')
title('Real part of Z1(f)')
hold on
subplot(212)
plot(f,fftshift(imag(Z1))*dt)
axis([-3*fo 3*fo -150*dt 300*dt])
grid on
xlabel('frequency (Hz)')
title('Imaginary part of Z1(f)')
hold on

display('PREMERE PER VISUALIZZARE LA TRASFORMATA DI FOURIER (complessa) Z2(f)')
pause

subplot(211)
plot(f,fftshift(real(Z2))*dt,'r')
axis([-3*fo 3*fo -100*dt 300*dt])
xlabel('frequency (Hz)')
title('Real part of Z1(f) and real part of Z2(f)')
subplot(212)
plot(f,fftshift(imag(Z2)*dt),'r')
title('Imaginary part of Z1(f) and imaginary part of Z2(f)')
axis([-3*fo 3*fo -150*dt 300*dt])
xlabel('frequency (Hz)')

pause
display('PREMERE PER VISUALIZZARE IL SEGNALE DEMODULATO COSENO')

figure(9)
plot(t,z1,'y');
grid on
xlabel('time (seconds)')
title('I+Q Demodulated signals')
axis([-dt*2*N/10 dt*2*N/10 -1.5 2.5])
hold on
plot(t,x1)

display('PREMERE PER VISUALIZZARE IL SEGNALE DEMODULATO SENO')
pause
plot(t,z2,'g');
plot(t,x2,'r')
plot(t,x1)




