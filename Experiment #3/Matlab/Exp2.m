function Exp2 ()
close all;
clc;
figure;
hold on;

%% Figure 1
angle=[0 45 90 135];
zeta=angle/180*pi;
Vave=[9.78 8.28 3.52 -0.211];
Vrms=[17.8 17.1 12.3 5.6];
VaveTheory=28/2*1.414/pi*(1+cos(zeta));
%VaveTheory=28*1.414*(1+2/pi*cos(zeta));
VrmsTheory=28*1.414*sqrt(0.5*0.5/pi*(pi-zeta+0.5*sin(2*zeta)));

plot(angle,Vave,'-xb');
plot(angle,Vrms,'-or');
plot(angle,VaveTheory,'-.+b');
plot(angle,VrmsTheory,'-.^r');

xlabel('Delay angle /degree')
ylabel('Voltage /V');
legend('V_{out,ave}','V_{out,rms}','V_{out,ave} -theory','V_{out,rms} -theory');
axis([0 160 -1 25]);
set(gcf, 'Position', [200 200 500 350])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', 'plot1');

%% Figure 2
delay=[5.2 5.9 6.2 6.9];
angle=delay/2.08*45;
Zeta=angle*pi/180
Iave=[0.225 0.128 0.09 0.019];
Irms=[0.67 0.466 0.363 0.113];
Tau=asin(13.4/28/1.414)
IaveTheory=1/2/pi*((cos(Zeta) - cos(pi-Tau))*28*1.414+(Zeta - (pi-Tau))*13.4)/7.1;
Vin=28*1.414;
Vout=[13.4 13.4 13.3 13.3];
IrmsTheory=sqrt(((Vin^2*sin(2*Zeta))/4 + (Vin^2*sin(2*Tau - 2*pi))/4 - (Vin^2*Zeta)/2 - Vout.^2.*Zeta - (Vin^2*(Tau - pi))/2 - Vout.^2*(Tau - pi) - 2*Vin.*Vout.*cos(Zeta) + 2*Vin.*Vout.*cos(Tau - pi))/2/pi)/7.1
figure;
hold on;
plot(angle,Iave,'-xb');
plot(angle,Irms,'-or');
plot(angle,IaveTheory,'-.+b');
plot(angle,IrmsTheory,'-.^r');

xlabel('Delay angle /degree')
ylabel('Current /A');
legend('I_{out,ave}','I_{out,rms}','I_{out,ave} -theory','I_{out,rms} -theory');

set(gcf, 'Position', [200 200 500 350])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', 'plot2');
