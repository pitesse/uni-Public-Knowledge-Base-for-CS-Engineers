% PROGRAMMA ISI
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2013

G=zeros(1,10000);
G(1:501)=1;
G(9501:10000)=1;
figure(1)
plot((-5000:4999),fftshift(G))
xlabel('frequenze')
grid
pause
g=ifft(G);
figure(2)
plot((-5000:4999)/10000,fftshift(real(g)))
xlabel('tempi')
hold on
pause
plot((-5000:4999)/10000,-fftshift(real(g)))
hold off
pause
G(1:1001)=cos(2*pi*(0:1000)/2000)*1/2+1/2;
G(9001:10000)=cos(2*pi*(1001:2000)/2000)*1/2+1/2;
figure(1)
hold on
plot((-5000:4999),fftshift(G),'r')
hold off
pause
g=ifft(G);
figure(3)
plot((-5000:4999)/10000,fftshift(real(g)))
xlabel('tempi')
hold on
pause
plot((-5000:4999)/10000,-fftshift(real(g)))
hold off
pause
figure(2)
hold on
plot((-5000:4999)/10000,fftshift(real(g)),'r')