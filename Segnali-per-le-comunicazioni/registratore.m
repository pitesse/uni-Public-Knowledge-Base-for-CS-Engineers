% PROGRAMMA registratore
% Autore: Claudio Prati
% Politecnico di Milano, 20 Marzo 2015

% Esegue la registrazione e il campionamento a frequenza di campionamento Fs
% di un segnale audio in ingresso dal microfono del PC.
% Ricostruisce il segnale tempo continuo a partire dal segnale campionato e lo
% riproduce tramite altoparlanti del PC. Il guadagno è selezionabile da
% input.
% Visualizza sia il segnale campionato sia la sua trasformata di Fourier.



Fs=20000;
Nbit=16;
Ch=1;
T=5;
N=Fs*T;
t=(0:1/Fs:T-1/Fs);
myVoice = audiorecorder(Fs,Nbit,Ch);
disp('Return to start ...');
pause
disp('Start speaking.');

recordblocking(myVoice, T);
disp('End of recording.');

%G=input('Amplificazione? ')
G=1;

disp('Return to play ...');
pause

x = getaudiodata(myVoice);
myVoice=audioplayer(x*G,Fs);
play(myVoice);

pause(T)

G=input('Amplificazione? ')

disp('Return to play ...');
pause
myVoice=audioplayer(x*G,Fs);
play(myVoice);


disp('Return to display ...');
pause

figure(1)
plot(t,x)
xlabel('Time seconds')
title('Recorded Signal')

disp('Return to display FFT...');
pause
X=fft(x);
f=(-Fs/2:Fs/N:Fs/2-Fs/N);
plot(f,fftshift(abs(X)))
xlabel('Frequency Hz')
title('Fourier T. Abs Value')

