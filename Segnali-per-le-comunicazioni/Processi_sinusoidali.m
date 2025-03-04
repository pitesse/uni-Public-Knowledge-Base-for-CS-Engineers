% PROGRAMMA Processi_sinusoidali
% Autore: Claudio Prati
% Politecnico di Milano, 8 Aprile 2014

% Visualizza N realizzazioni di un processo casuale con ampiezza casuale uniforme, 
% con fase iniziale uniforme e altre combinazioni


clear all
close all


t=[-10:.01:10];

N=input('numero realizzazioni? ');


for n=1:N;
    A=rand(1,1);
    r=A*cos(2*pi*0.1*t);
    figure(1)
    plot(t,r)
    pause(.1)
    hold on
end
hold off

pause

for n=1:N;
    fi=rand(1,1)*2*pi;
    r=cos(2*pi*0.1*t+fi);
    figure(2)
    plot(t,r)
    pause(.1)
    hold on
end
hold off

pause

for n=1:N;
    A=1;
    fi=(rand(1,1)-.5)*pi;
    r=A*cos(2*pi*0.1*t+fi);
    figure(3)
    plot(t,r)
    pause(.1)
    hold on
end
hold off

pause

for n=1:N;
    A=rand(1,1);
    r=A+cos(2*pi*0.1*t);
    figure(4)
    plot(t,r)
    pause(.1)
    hold on
end
hold off

