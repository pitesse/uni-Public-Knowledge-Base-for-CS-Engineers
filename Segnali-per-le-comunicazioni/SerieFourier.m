% PROGRAMMA SerieFourier
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2014

% Visualizza NA coefficienti della serie di Fourier di 
% un'onda quadra e ad ogni clik aggiunge al grafico
% l'armonica corrispondente.

clear all
clf
t=[-10:.01:10];
T0=5;
N=length(t);

NA=input('numero armoniche per ricostruire il segnale? ');

c0=1/2;
for n=1:NA;
c(n)=sin(pi*n/2)/(pi*n);
end

x0=ones(1,N)*1/2;
x=zeros(1,N);
figure(1)
clf
for n=1:NA;
    x=x+2*c(n)*cos(2*pi*n/T0*t);
    subplot(211)
    plot(t,x0+x)
    xlabel('tempo in secondi')
    subplot(212)
    stem(n,2*c(n),'filled')
    xlabel('armoniche')
    hold on
    pause
end
    
