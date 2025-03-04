%FiltroMedia
% Simula la trasmissione numerica binaria antipodale in presenza
% di rumore bianco sia di larga banda sia nella banda del segnale.
% Mostra l'effetto della media aritmetica di molteplici repliche dello
% stesso segnale con rumore indipendente per evidenziare l'effetto della
% somma in tensione del segnale e in potenza del rumore
% Autore: Claudio Prati
% Data: 24 Maggio 2017

clear all
M=10;
for k=1:M;
    s(k)=sign(rand(1,1)-0.5);
end
g=gausswin(50,3.5);
x=zeros(1,50*M);
for k=1:M;
    x((k-1)*50+1:k*50)=g*s(k)*.2;
end
figure(1)
plot(x)
axis([1 50*M -.5 .5])
grid
pause
y=x+randn(1,50*M);
hold on
plot(y,'r')
axis([1 50*M -1 1])
grid on
hold off
pause
for n=1:10
   y=y*n/(n+1)+(x+randn(1,50*M))/(n+1); 
   figure(1)
   plot(x)
   hold on
   plot(y,'r')
   axis([1 50*M -1 1])
   grid on
   for k=1:M;
       if sign(y((k-1)*50+25))==sign(x((k-1)*50+25));
           plot((k-1)*50+25,.8,'og')
       else
           plot((k-1)*50+25,-.8,'om')
       end
   end
   hold off
   pause
end
   
for n=11:200
   y=y*n/(n+1)+(x+randn(1,50*M))/(n+1); 
   figure(1)
   plot(x)
   hold on
   plot(y,'r')
   axis([1 50*M -.5 .5])
   grid on
   for k=1:M;
       if sign(y((k-1)*50+25))==sign(x((k-1)*50+25));
           plot((k-1)*50+25,.4,'og')
       else
           plot((k-1)*50+25,-.4,'om')
       end
   end
   hold off
   pause(.1)
end

pause
y=x+randn(1,50*M);

figure(2)
X=abs(fft(x));
plot(X)
pause
Y=abs(fft(y));
plot(Y)
h=fir1(50,.2);
yf=conv(y,h);
yy=yf(26:50*M+25);
pause
YY=fft(yy);
plot(abs(YY))
pause
plot(x)
hold on
plot(yy,'r')
axis([1 50*M -.5 .5])
grid on
hold off
pause

for n=1:200
   yyf=conv((x+randn(1,50*M)),h);
   yyn=yyf(26:50*M+25);
   yy=yy*n/(n+1)+yyn/(n+1);
  
   figure(2)
   plot(x)
   hold on
   plot(yy,'r')
   axis([1 50*M -.5 .5])
   grid on
   for k=1:M;
       if sign(yy((k-1)*50+25))==sign(x((k-1)*50+25));
           plot((k-1)*50+25,.4,'og')
       else
           plot((k-1)*50+25,-.4,'om')
       end
   end
   hold off
   pause(.1)
end
   
