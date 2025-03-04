% ShiftSinc
% Visualizzazione dello spastamento del massimo di un 
% SINC sommato a rumore bianco nella banda del segnale
% Autore: Claudio Prati
% Data: 26 Maggio 2017

clear all
figure(1)
clf
g=sinc((-3:.01:3));
figure(1)
plot((-3:.01:3),g)
axis([-3 3 -.5 1.4])
grid on
pause
[a,b]=max(g);
tmax=((b-301)*.01)
hold on
plot(tmax,0,'ob')
axis([-3 3 -.5 1.4])
%hold off
h=fir1(100,.05);
pause
noise=conv(randn(1,length(g))/5,h);
gn=g+noise(51:651);
plot((-3:.01:3),gn,'r')
grid on
axis([-3 3 -.5 1.4])
pause
grid on
[a,b]=max(gn);
tmax=((b-301)*.01);
hold on
plot(tmax,0,'or')
axis([-3 3 -.5 1.4])
grid on
pause
hold off
t=zeros(1,100);
for k=1:100
    noise=conv(randn(1,length(g))/5,h);
    gn=g+noise(51:651);
    figure(1)
    subplot(211)
    plot((-3:.01:3),gn)
    axis([-3 3 -.5 1.4])
    grid
    [a,b]=max(gn);
    tmax=((b-301)*.01);
    hold on
    plot(tmax,0,'or')
    axis([-3 3 -.5 1.4])
    pause(.1)
    axis([-3 3 -.5 1.4])
    hold off
    figure(1)
    subplot(212)
    t(k)=tmax;
    plot(t,'r')
    pause(.1)
end
