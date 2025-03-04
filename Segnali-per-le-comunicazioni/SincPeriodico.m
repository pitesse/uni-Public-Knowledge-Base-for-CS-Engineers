% Plot del seno cardinale periodico trasformata della sequenza unitaria di N campioni
% a partire da n=0 fino a n=N-1
clear 
close all
N=15;
fi=(-1.5:.001:1.5)+.0005;
x=exp(-j*pi*fi*(N-1)).*sin(pi*fi*N)./sin(pi*fi);
subplot(211)
plot(fi,abs(x))
title('modulo del sinc periodico')
xlabel('frequenza normalizzata')
axis([-1.5 1.5 0 N])
grid on
subplot(212)
plot(fi,angle(x))
title('fase del sinc periodico')
xlabel('frequenza normalizzata')
axis([-1.5 1.5 -pi pi])
grid on
pause
figure(2)
plot(fi,sin(pi*fi*N)./sin(pi*fi))
grid
axis([-1.5 1.5 -N N])


