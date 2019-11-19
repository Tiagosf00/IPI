% Universidade de Brasília
% Introdução ao Processamento de Imagem
% Tiago de Souza Fernandes - 18/0131818
%
% Algoritmo de binarização de imagem com fundo não homogêneo.

% Lê a imagem
I = imread('morf_test.png');

% Aplica o filtro de média no domínio do espaço
es = fspecial('average', 2);
I = imfilter(I, es);

% Inverte a imagem
I=255-I;

% Aplica as transformadas top-hat e bottom-hat
es = strel('disk', 3);
I = imsubtract(imadd(imtophat(I,es), I), imbothat(I,es));

% Aplica uma abertura na imagem para obter o fundo
es = strel('disk', 5, 8);
background = imopen(I, es);

% Mostra o fundo isolado
figure;imshow(255-background);

% Retira o fundo da imagem e a ajusta
I = I-background;
I = imadjust(I);

% Binariza a imagem
G = graythresh(I);
I = imbinarize(I,G);

% Realiza as operações morfológicas de dilatação,
% erosão e fechamento
es = strel('disk', 1);
I = imdilate(I, es);
I = imerode(I, es);
I = imclose(I, es);

% Inverte novamente a imagem
I = 1-I;

% Mostra o resultado final
figure;imshow(I);
