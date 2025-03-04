% Filtro_elementare
% Dalla risposta all'impulso alla risposta in frequenza
% Author: C. Prati
% Date: February 2025
clear 
close all

% h: risposta all'impulso
h=[-1/4 1/2 -1/4];
% Scelta della frequenza normalizzata fi
fi=input('frequenza normalizzata input? ');
% Segnale di INPUT: coseno alla frequenza normalizzata fi
x=cos(2*pi*fi*(-52:52));
figure(1)
stem((-20:20),x(33:73))
hold on
plot((-20:20),x(33:73),'g')
pause
% Segnale di OUTPUT (convoluzione tra x e h)
 y=conv(x,h,'same');
stem((-20:20),y(33:73),'filled','r')
hold off
pause

% Stesse operazioni calcolate per un range di frequenza normalizzate da -0.5 a +0.5 
for fi=-.5:.025:.5
    x=cos(2*pi*fi*(-52:52));
    y=conv(x,h,'same');
   figure(2)
   subplot(211)
   stem((-20:20),x(33:73))
  
   hold on
    plot((-20:20),x(33:73),'g')
   stem((-20:20),y(33:73),'filled','r')
   xlabel(' campioni dei segnali nel tempo')
   title('Input e Output')
   hold off
   subplot(212)
   grid on
   hold on
   % grafico del massimo della cosinusoide di uscita in funzione della fi
   stem(fi,y(53),'filled')
   xlabel(' frequenza normalizzata')
   title('Massima ampiezza del coseno di uscita')
   axis([-.5 .5 0 1.2])
   
   pause(1)
end
