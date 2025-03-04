% Definizione del vettore temporale
t = 0:0.001:1;  % Tempo da 0 a 1 secondo con passo 0.001
x = exp(1j * 20 * pi * t);  % Segnale complesso

% Componenti cartesiane
parte_reale = real(x);
parte_immaginaria = imag(x);

% Componenti polari
modulo = abs(x);
fase = angle(x);            % Fase iniziale tra -π e π
fase(fase < 0) = fase(fase < 0) + 2*pi;  % Regola la fase tra 0 e 2π

% Creazione della figura
figure;

% Grafico della parte reale
subplot(2, 2, 1);
plot(t, parte_reale);
title('Parte Reale');
xlabel('Tempo (s)');
ylabel('Re[x(t)]');
grid on;

% Grafico della parte immaginaria
subplot(2, 2, 2);
plot(t, parte_immaginaria);
title('Parte Immaginaria');
xlabel('Tempo (s)');
ylabel('Im[x(t)]');
grid on;

% Grafico del modulo
subplot(2, 2, 3);
plot(t, modulo);
title('Modulo');
xlabel('Tempo (s)');
ylabel('|x(t)|');2704
ylim([0 1.5]);  % Limiti dell'asse y per chiarezza
grid on;

% Grafico della fase
subplot(2, 2, 4);
plot(t, fase);
title('Fase');
xlabel('Tempo (s)');
ylabel('Arg[x(t)] (rad)');
ylim([0 2*pi]);  % Mostra da 0 a 2π
yticks([0 pi 2*pi]);
yticklabels({'0', '\pi', '2\pi'});
grid on;