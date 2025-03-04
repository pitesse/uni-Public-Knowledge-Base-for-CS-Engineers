
% Calcola la convoluzione tra una cosinusoide di frequenza normalizzata f
% e una risposta impulsiva i cui campioni sono inseriti nel vettore h

clear all
figure(1)
clf
n=(-50:50);
f=input('frequenza normalizzata del coseno? ');
x=cos(2*pi*f*n);
stem(n,x)
hold on
h=[-1/4 1/2 -1/4];
y=conv(x,h);
pause
m=(-51:51);
stem(m,y,'r')
hold off