
% PROGRAMMA linpred2
% Autore: Claudio Prati
% Politecnico di Milano, 22 Maggio 2014

% Fornisce la stima del campione all'istante n+1 noto il valore del campione all'istante n
% di una serie temporale generata dal modello x(n+1)=rho*x(n)+kk*w(n)
% dove rho è il coefficiente di correlazione a passo 1 del processo casuale, kk è un 
% coefficiente che garantisce la stazionarietà del processo casuale e w(n) è un processo casuale
% indipendente da x(n) e con ddp unifome tra -1/2 e +1/2.
% Stima la densità di probabilità di una variabile casuale dai valori assunti 
% dalla variabile casuale in N realizzazione dell'esperimento. 
% La d.d.p. della variabile casuale si ottiene dividendo l'istogramma per il
% numero N delle realizzazioni e per l'intervallo di campionamento dell'istogramma.
%
% Viene inoltre stimata e visualizzata tramite istogramma 3D la densità di
% probabilità congiunta tra x(n+1) e x(n).
% Da questa è facile realizzare l'andamento della ddp di x(n+1)
% condizionata a x(n) e il suo valore medio che corrisponde alla predizione
% che minimizza l'errore quadratico medio tra dato previsto e dato vero.


clear all
close all

ro=input('coefficiente di correlazione? ');
N=2000000;
M=2000;
% Calcolo di kk per garantire la stazionarietà del processo
kk=sqrt(1-ro^2);
x=zeros(1,N+1);
w=rand(1,N)-.5;
x(1)=rand(1,1)-.5;

% Generazione del processo casuale
for n=1:N;
    x(n+1)=ro*x(n)+kk*w(n);
end

% Stima del coefficiente di correlazione del processo a passo 1 utilizzando
% N campioni di una realizzazione del processo

rostim=mean(x(1:M).*x(2:M+1))/var(x(1:M))

% Predizione lineare a passo 1 utilizzando il coefficiente di correlazione stimato
% e calcolo dell'errore di predizione
for n=1:N;
x2stim(n)=rostim*x(n);
error(n+1)=x(n+1)-x2stim(n);
end

display('VALORI OTTENUTI UTILIZZANDO IL COEFF. DI CORRELAZIONE STIMATO')
varianza_x=var(x)
varianza_err=var(error)

% Visualizzazione di M campioni del processo (blu), dei valori predetti
% (rossi) e dell'errore di predizione (verde)

figure(1)
stem(x(1:M))
pause
hold on
stem(x2stim(2:M+1),'r')
pause
stem(error(2:M+1),'g')
hold off
pause

% Predizione lineare a passo 1 utilizzando il coefficiente di correlazione
% vero e calcolo dell'errore di predizione
for n=1:N;
x2stim(n)=ro*x(n);
error(n+1)=x(n+1)-x2stim(n);
end

display('VALORI OTTENUTI UTILIZZANDO IL COEFF. DI CORRELAZIONE VERO')
varianza_x=var(x)
varianza_err=var(error)

pause

% visualizzazione della densità di propabilità del processo x(n)
figure(3)
da=0.05;
cnt=hist(x(1:N),[-1:da:1]);
ddpx=cnt/N/da;
C=(-1:da:1);
plot(C,ddpx)
title('Ddp del processo casuale x(n)')

pause
% visualizzazione della densità di probabilità congiunta tra x(n) e x(n+1)
figure(4)
yx(1:N,2)=x(2:N+1);
yx(1:N,1)=x(1:N);
da=.05;
db=.05;
cnt=hist3(yx,{-1:da:1 -1:db:1});
ddpyx=cnt/N/(da*db);
imagesc((-1:da:1),(-1:db:1),ddpyx)
title('Ddp congiunta di x(n+1) e x(n)')


xn=0;

% visualizzazione della densità di propabilità di x(n+1) condizionata a x(n)
for k=1:5;
xn=input(' Inserire un valore di x(n) compreso tra -1 e +1 ... >>  ');
nn=floor((xn+1)/da);
figure(5)
plot((-1:db:1),ddpyx(nn,:)/(ddpx(nn)))
grid on
pause
end
