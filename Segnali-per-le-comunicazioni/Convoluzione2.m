
% Calcola la convoluzione tra una cosinusoide di frequenza normalizzata f
% e una risposta impulsiva i cui campioni sono inseriti nel vettore h

clear all
figure(1)
clf
M=5;
n=(-102:102);
f=input('frequenza normalizzata del coseno? ');
x=cos(2*pi*f*n);
m=(-30:30);

stem(m,x(73:133))
axis([-30 30 -1.2 1.2])
hold on
h=ones(M,1)/M;
y=conv(x,h);
pause
stem(m,y(73+(M-1)/2:133+(M-1)/2),'r')
hold off