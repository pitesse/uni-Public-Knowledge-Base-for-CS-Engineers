% PROGRAMMA RispostaInFrequenza
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2014

% Visualizza N valori di modulo e fase della risposta in frequenza di h
% (rettangolare da 0 a T secondi con ampiezza unitaria)in corrispondenza 
% delle frequenze f. 
% La risposta in frequenza e' calcolata come modulo e fase della risposta
% ad esponenziali complessi con differenti frequenze.
% N.B. L'integrale di convoluzione è approssimato con una somma di
% convoluzione moltiplicata per l'intervallo di campionamento (piccolo) dt.


clear all
figure(1)
clf
Tmax=10;
dt=0.01;
T=.5;
t=[0:dt:Tmax];
h=ones(1,T/dt);
N=500;
for k=1:N+1;
    f=(k-N/2)*1/100;
    x=exp(j*2*pi*f*t);
    y=conv(x,h)*dt;
    fr(k)=f;
    modulo(k)=abs(y(Tmax/2/dt));
    fase(k)=angle(y(Tmax/2/dt).*conj(x(Tmax/2/dt)));
end
figure(1)
subplot(211)
plot(fr,modulo)
title('Modulo')
xlabel('Frequenza')
grid
subplot(212)
plot(fr,fase)
title('Fase')
xlabel('Frequenza')
grid
