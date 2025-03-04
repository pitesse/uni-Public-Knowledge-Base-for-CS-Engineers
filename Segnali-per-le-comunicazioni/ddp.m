% PROGRAMMA ddp
% Autore: Claudio Prati
% Politecnico di Milano, 8 Aprile 2014

% Stima la densità di probabilità di una variabile casuale dai valori assunti 
% dalla variabile casuale in N realizzazione dell'esperimento. 
% La d.d.p. della variabile casule si ottiene dividendo l'istogramma per il
% numero N delle realizzazioni e per l'intervallo di campionamento dell'istogramma.
%


%% Esempio 1

clear all
close all

N=1000000;
% Dado 1
x=rand(1,N);
dado1=floor(x*6)+1;
% Dado 2
y=rand(1,N);
dado2=floor(y*6)+1;

% Calcolo degli istogrammi
da=1;
ddpx=hist(dado1,1:6)/N/da;
ddpxpy=hist(dado1+dado2,2:12)/N/da;

% Plot
figure(1)
subplot(2,1,1)
bar(ddpx); hold on
stem(1:6,1/6*ones(1,6),'filled')
title('D.d.p del risultato del lancio di un dado')
subplot(2,1,2); 
bar(2:12,ddpxpy)
hold on
stem(2:12,conv(1/6*ones(1,6),1/6*ones(1,6)),'filled')
title('D.d.p della somma dei risultati del lancio di 2 dadi')

%% Esempio 2

clear all
close all

N=100000;
x=randn(1,N);
da=0.25;
ddpx=hist(x,-4:da:4)/N/da;

figure(1)
bar((-4:da:4),ddpx); hold on
plot((-4:da:4),normpdf((-4:da:4),0,1),'linewidth',3);
title('D.d.p gaussiana a varianza unitaria e m=0')



%% Esempio 3

clear all
close all

N=100000;
x=(randn(1,N)).^2;
da=0.25;
ddpx=hist(x,0:da:8)/N/da;

figure(1)
bar((0:da:8),ddpx); 
hold on
plot((0:da/10:8),chi2pdf(0:da/10:8,1),'linewidth',3)
title('D.d.p gaussiana a varianza unitaria e m=0 elevata al quadrato')


%% Esempio 4

clear all
close all

N=100000;
x=(randn(1,N)).^2;
y=(randn(1,N)).^2;
z=sqrt(x+y);
da=0.25;
ddpz=hist(z,0:da:8)/N/da;

figure(1)
bar((0:da:8),ddpz); hold on
plot((0:da/100:8),raylpdf((0:da/100:8),1),'linewidth',3)
title('D.d.p della radice della somma dei quadrati di 2 gaussiane indipendenti')


%% Esempio 5

clear all
close all

N=10000000;
x=cos(2*pi*rand(1,N));
da=0.001;
ddpx=hist(x,-1:da:1)/N/da;

figure(1)
bar((-1:da:1),ddpx); hold on
plot((-1:da/100:1),1./(pi*sqrt(1-(-1:da/100:1).^2)),'linewidth',3);
title('D.d.p del coseno di uniforme da 0 a 2pi')

%% Esempio 6

clear all
close all

N=10000000;
x=rand(1,N);
y=rand(1,N);
z=x.*y;
da=0.001;
ddpz=hist(z,0:da:1)/N/da;

figure(1)
bar((0:da:1),ddpz); hold on
plot(0:da/100:1,-log(0:da/100:1),'linewidth',3)
title('D.d.p del prodotto di 2 uniformi indipendenti')


%% Esempio 7

clear all
close all

N=10000000;
x=rand(1,N)+1;
y=rand(1,N)+1;
z=x./y;
da=0.01;
ddpz=hist(z,0:da:2)/N/da;
figure(1)
bar((0:da:2),ddpz); hold on
title('D.d.p del quoziente di 2 uniformi indipendenti')