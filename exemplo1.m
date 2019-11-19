%%%%%%%%%%%%%%%%%%%%%%%%
% Amostragem de Sinais %
%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

% Freqüência do sinal (em Hertz)
fc = 1;

% Freqüência de amostragem (em Hertz)
fa = 8;

% Período de amostragem (em segundos)
Ta = 1/fa;

% Intervalo de simulação (em segundos)
ti = 0;  % Tempo inicial
tf = 1;  % Tempo final
t = ti:Ta:tf;

% Simula a função contínua
tcont = ti:1/(100*fa):tf;
ycont = 3*sin(2*pi*fc.*tcont);

% Amostragem do sinal
y = 3*sin(2*pi*fc.*t);

% Mostra a função contínua (simulada) e
% sobrepõe o sinal em tempo discreto
set(gca,'FontSize',14)
h = plot(tcont, ycont)
set(h,'LineWidth',1)
hold on
h = stem(t,y,'or','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g')
xlabel('t (s)')
ylabel('y(t)')
title('Amostragem')
h = legend('Sinal contínuo', 'Sinal em tempo discreto')
set(h,'FontSize',12);
grid on


