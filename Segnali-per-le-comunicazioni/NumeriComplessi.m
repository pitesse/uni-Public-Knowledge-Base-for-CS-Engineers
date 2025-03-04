% Author: Borra Federico, Ph.D.,
% Politecnico di Milano, DEIB
% email address: federico.borra@polimi.it
% March 2017; Last revision: 21/03/2017

clear all
close all
clc


%% Funzioni di base
x=1+3i;  % dichiarazione di variabile (numero complesso in form algebrica)

disp('Il complesso coniugato di x è: ')
conj(x)

disp('Il modulo di x è: ')
abs(x)

disp('La fase di x è [rad]: ')
phase(x)

disp('La parte immaginaria di x è: ')
imag(x)

disp('La parte reale di x è: ')
real(x)

% Plot
figure
plot(x,'o')
xlabel('Re')
ylabel('Im')
title('Numero complesso nel piano')
grid on

x2=-2+5i;

figure
plot(x,'o');
hold on
plot(x2,'d');
xlabel('Re')
ylabel('Im')
title('Numeri complessi nel piano')
grid on
xl=xlim; % xl è vettore che contiene il limite sup. e inf. dell'asse x
yl=ylim; % yl è vettore che contiene il limite sup. e inf. dell'asse y
axis([ xl+[-3,+3] yl+ [-3,+3]])

%% Numeri complessi in forma esponenziale
A=1; % modulo
phi=pi/2; % fase

e1=A*exp(1i*phi); % esponenziale complesso

%Plot
figure
plot(complex(e1),'o') %cast a numeri complessi
xlabel('Re')
ylabel('Im')
title('Esponenziale complesso nel piano')
grid on

%% Funzione a valori complessi
N = 1000;                       % Numero punti campionamento
angle_l=0;                      % limite inferiore [rad]
angle_h=2*pi;                   % limite superiore [rad]
inc=(angle_h-angle_l)/(N-1);    % calcolo incremento
ang_ax=angle_l:inc:angle_h;     % vettore asse radianti

exp_f1=zeros(1,N);
for ii=1:N
    exp_f1(ii)=exp(1i*ang_ax(ii));
end

figure
subplot(3,2,1)
plot(exp_f1)
xlabel('Re')
ylabel('Im')
title('Funzione complessa nel piano')
axis equal

subplot(3,2,2)
plot(ang_ax,real(exp_f1))
xlabel('angle')
title('Parte reale')
axis equal

subplot(3,2,3)
plot(ang_ax,imag(exp_f1))
xlabel('angle')
title('Parte immaginaria')
axis equal

subplot(3,2,4)
plot(ang_ax,abs(exp_f1))
xlabel('angle')
title('Modulo')
axis equal

subplot(3,2,5)
plot(ang_ax,angle(exp_f1))
xlabel('angle')
title('Fase')
axis equal

subplot(3,2,6)
plot(ang_ax,phase(exp_f1));hold on
plot(ang_ax,angle(exp_f1),'--r')
xlabel('angle')
title('Fase "srotolata" ')
axis equal

%% Funzione a valori reali
N = 1000;
angle_l=0;
angle_h=2*pi;
inc=(angle_h-angle_l)/(N-1);
ang_ax=angle_l:inc:angle_h;

exp_f1=zeros(1,N);
for ii=1:N
    exp_f1(ii)=2*cos(ang_ax(ii));
end

figure
subplot(3,2,1)
plot(complex(exp_f1))
xlabel('Re')
ylabel('Im')
title('Funzione reale nel piano')
axis equal

subplot(3,2,2)
plot(ang_ax,real(exp_f1))
xlabel('angle')
title('Parte reale')
axis equal

subplot(3,2,3)
plot(ang_ax,imag(exp_f1))
xlabel('angle')

title('Parte immaginaria')
axis equal

subplot(3,2,4)
plot(ang_ax,abs(exp_f1))
xlabel('angle')
title('Modulo')
axis equal

subplot(3,2,5)
plot(ang_ax,angle(exp_f1))
xlabel('angle')
title('Fase')
axis equal

subplot(3,2,6)
plot(ang_ax,phase(exp_f1)); hold on
plot(ang_ax,angle(exp_f1),'--r')
xlabel('angle')
title('Fase "srotolata" ')
axis equal

%% Funzione a valori complessi
N = 4000;
angle_l=0;
angle_h=8*pi;
inc=(angle_h-angle_l)/(N-1);
ang_ax=angle_l:inc:angle_h;

exp_f1=zeros(1,N);
for ii=1:N
    A=exp(-0.1*ang_ax(ii));
    exp_f1(ii)=A*exp(1i*ang_ax(ii));
end

figure
subplot(3,2,1)
plot(exp_f1)
xlabel('Re')
ylabel('Im')
title('Funzione complessa nel piano')
axis equal

subplot(3,2,2)
plot(ang_ax,real(exp_f1))
xlabel('angle')
title('Parte reale')

subplot(3,2,3)
plot(ang_ax,imag(exp_f1))
xlabel('angle')
title('Parte immaginaria')

subplot(3,2,4)
plot(ang_ax,abs(exp_f1))
xlabel('angle')
title('Modulo')

subplot(3,2,5)
plot(ang_ax,angle(exp_f1))
xlabel('angle')
title('Fase')

subplot(3,2,6)
plot(ang_ax,phase(exp_f1)); hold on
plot(ang_ax,angle(exp_f1),'--r')
xlabel('angle')
title('Fase "srotolata" ')
axis equal

%% Animazione di una funzione a valori complessi
N = 200;
angle_l=0;
angle_h=8*pi;
inc=(angle_h-angle_l)/(N-1);
ang_ax=angle_l:inc:angle_h;

figure
for ii=1:N
    A=exp(-0.1*ang_ax(ii));
    exp_f1=A*exp(1i*ang_ax(ii));
    plot(complex(exp_f1),'bo'); hold on
    axis([-1 1 -1 1])
    axis equal
    grid on
    drawnow
end
hold off;