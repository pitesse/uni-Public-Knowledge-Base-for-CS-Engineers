clear
clf
bin=0.05;
N=500000;
x=rand(1,N);
y=rand(1,N);
z=rand(1,N);
v=rand(1,N);
w=rand(1,N);
frR1=hist(x,[0+bin/2:bin:1-bin/2])/N/bin;
frR2=hist(x+y,[0+bin/2:bin:2-bin/2])/N/bin;
frR3=hist(x+y+z,[0+bin/2:bin:3-bin/2])/N/bin;
frR4=hist(x+y+z+v,[0+bin/2:bin:4-bin/2])/N/bin;
frR5=hist(x+y+z+v+w,[0+bin/2:bin:5-bin/2])/N/bin;

figure(1)
bar([0+bin/2:bin:1-bin/2],frR1)
pause
a=[0+bin/2:bin:1-bin/2];
ga=1/sqrt(2*pi*1/12)*exp(-(a-0.5).^2/(2*1/12));
hold on
plot([0+bin/2:bin:1-bin/2],ga,'r')
pause

figure(1)
clf
bar([0+bin/2:bin:2-bin/2],frR2)
pause
a=[0+bin/2:bin:2-bin/2];
ga=1/sqrt(2*pi*2/12)*exp(-(a-2*0.5).^2/(2*2/12));
hold on
plot([0+bin/2:bin:2-bin/2],ga,'r')
pause

figure(1)
clf
bar([0+bin/2:bin:3-bin/2],frR3)
pause
a=[0+bin/2:bin:3-bin/2];
ga=1/sqrt(2*pi*3/12)*exp(-(a-3*0.5).^2/(2*3/12));
hold on
plot([0+bin/2:bin:3-bin/2],ga,'r')
pause

figure(1)
clf
bar([0+bin/2:bin:4-bin/2],frR4)
pause
a=[0+bin/2:bin:4-bin/2];
ga=1/sqrt(2*pi*4/12)*exp(-(a-4*0.5).^2/(2*4/12));
hold on
plot([0+bin/2:bin:4-bin/2],ga,'r')
pause

figure(1)
clf
bar([0+bin/2:bin:5-bin/2],frR5)
pause
a=[0+bin/2:bin:5-bin/2];
ga=1/sqrt(2*pi*5/12)*exp(-(a-5*0.5).^2/(2*5/12));
hold on
plot([0+bin/2:bin:5-bin/2],ga,'r')



