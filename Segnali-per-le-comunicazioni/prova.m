clear
close all
T=1/10;
%rappresentazione grafica segnali discreti
n=-20:1:20;
nT=n*T;
fi=1/8;
x=cos(2*pi*fi*n);
figure(1)
stem(x)
pause

stem(x,'filled')
pause

stem(n,x,'filled')
pause

stem(nT,x,'filled','m')
pause

%rappresentazione grafica segnali continui e discreti
plot(n,x)
pause
hold on
stem(n,x,'r','filled')
pause

%rappresentazione grafica segnali continui
t=-20:.01:20;
x=cos(2*pi*fi*t);
hold off
plot(t,x)
pause

%sinc
x=sinc(t);
plot(t,x)
grid
pause

%sinc scalato
y=sinc(t/5);
hold on
plot(t,y,'r')
hold off
pause
close all

%numeri complessi
x=5+j*6
pause
abs(x)
pause
angle(x)
pause

%esponenziali complessi
exp(j*pi/4)

%segnali complessi
t=(-2:.01:3);
x=exp(j*2*pi*t);
figure(1)
plot(t,real(x))
hold on
pause

plot(t,imag(x),'r')
hold off
pause

plot(t,abs(x))
hold on
pause

plot(t,angle(x),'r')
hold on
pause

plot(t,unwrap(angle(x)),'m')
grid
hold off
pause

x=exp(j*pi*t.^2);
plot(t,angle(x))
pause
hold on
plot(t,unwrap(angle(x)),'r')
grid
pause
hold off
plot(t,real(x))
pause

hold on
plot(t,imag(x),'r')


