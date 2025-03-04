F=1/21;
x=cos(2*pi*F*(-50:50));
h=ones(1,11)*1/11;
y=conv(x,h);
figure(1)
stem((-50:50),x)
hold on
stem((-50:50),y(6:106),'r')
hold off