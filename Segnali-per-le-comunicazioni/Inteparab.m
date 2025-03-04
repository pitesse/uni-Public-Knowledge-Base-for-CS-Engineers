clear 
close all
%GENERAZIONE DEL SEGNALE DI RIFERIMENTO
N=300;
x=randn(N,1);
% FILTRAGGIO PASSA BASSO E FINESTRATURA GAUSSIANA
h=fir1(20,.15);
y=conv(x,h,'same').*gausswin(N,4);

figure(1)
plot(y)
grid
pause

Y=fftshift(fft(y));
shift=randn(1,1)*15
ex=exp(j*2*pi*shift/N*(-N/2:N/2-1));
YS=Y.*transpose(ex);
ys=real(ifft(ifftshift(YS)));

figure(1)
hold on
plot(ys,'r')
hold off
pause

R=xcorr(y,ys);
length(R)
pause
figure(2)
plot(R)
hold on
pause
plot(R,'om')
[Rmax,nmax]=max(R);
    n0=nmax
    shift_intero=n0-N
    n_right=nmax+1;
    n_left=nmax-1;
    R0=Rmax;
    Rr=R(n_right);
    Rl=R(n_left);
    a=Rr/2+Rl/2-R0;
    b=Rr/2-Rl/2;
    c=R0;
    dnmax=-b/(2*a);
    shift_stimato=nmax+dnmax-N
    
    t=(-1.5:.01:1.5);
    y=a*t.^2+b*t+c;
    pause
    figure(2)
    hold on
    plot(t+n0,y,'r')
    hold off



