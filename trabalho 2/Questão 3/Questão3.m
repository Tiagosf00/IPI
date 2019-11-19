% Universidade de Brasília
% Introdução ao Processamento de Imagem
% Tiago de Souza Fernandes - 18/0131818
%
% Algoritmo de identificação de buracos que mostra
% como resultado a quantidade de buracos e seus diâmetros.

% Lê a imagem
O = imread('pcb.jpg');

% Transforma a imagem em monocromática
I = rgb2gray(O);

% Binariza a imagem
G = graythresh(I);
I = imbinarize(I,G);

% Gera um elemento estruturante e aplica a operação morfológica de fechamento
es = strel('disk', 13, 8);
I = imclose(I, es);

% Inverte a imagem
I=1-I;

% Remove os elementos das bordas da imagem
I = imclearborder(I);

% Binariza novamente a imagem
G = graythresh(I);
I = imbinarize(I,G);

% Aplica a função regionprops para mapear os furos
S = regionprops('table', I, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');

% Inverte novamente a imagem
I=1-I;

% Recebe as informações obtidas pela função
N = numel(S)/3; % Número de furos
C = S.Centroid; % Centros dos furos
D = (S.MajorAxisLength+S.MinorAxisLength)/2; % Diâmetros médios dos furos
R = D/2; % Raios dos furos

% Mostra a imagem original
figure;imshow(O);

% Mostra aonde os buracos foram identificados
hold on
viscircles(C, R);
hold off

% Mostra os dados coletados na tela
fprintf("\n\nNúmero de buracos = %d\n", N);
fprintf("Diâmetros :\n");

for k = 1 : N
    fprintf("D%d = %d\n", k, D(k));
end
