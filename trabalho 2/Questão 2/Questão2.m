% Universidade de Brasília
% Introdução ao Processamento de Imagem
% Tiago de Souza Fernandes - 18/0131818
%
% Algoritmo de remoção dos padrões de moiré de uma imagem.


% Lê a imagem
I = imread('moire.tif');

% Mostra a imagem inicial
figure;imshow(I);

% Gera a margem inicializada com zeros
I = padarray(I,[size(I, 1) size(I, 2)]);

% Realiza a transformada de fourier sobre a imagem
F = fftshift(fft2(double(I)));

% Mostra a transformada de fourier
figure;imshow(real(log(F)), []);

% Coleta as dimensões da imagem com as margens
h = size(I, 1);
w = size(I, 2);

% Encontra o centro da imagem
[x y]=meshgrid(-floor(w/2):floor(w/2)-1,-floor(h/2):floor(h/2)-1);

% Variáveis do filtro de Buterroth
n = 4;
B = sqrt(2) - 1;

% Raios dos filtros
d1 = 36;
d2 = 18;

% Aplicações dos filtros no domínio da frequência
D = sqrt((x+90).^2 + (y+111).^2);
filtro = 1 ./ (1 + B * ((d1 ./ D).^(2 * n)));
F1 = F .* filtro;

D = sqrt((x-90).^2 + (y-111).^2);
filtro = 1 ./ (1 + B * ((d1 ./ D).^(2 * n)));
F2 = F1 .* filtro;

D = sqrt((x+84).^2 + (y-129).^2);
filtro = 1 ./ (1 + B * ((d1 ./ D).^(2 * n)));
F3 = F2 .* filtro;

D = sqrt((x-84).^2 + (y+129).^2);
filtro = 1 ./ (1 + B * ((d1 ./ D).^(2 * n)));
F4 = F3 .* filtro;


D = sqrt((x+90).^2 + (y+240).^2);
filtro = 1 ./ (1 + B * ((d2 ./ D).^(2 * n)));
F5 = F4 .* filtro;

D = sqrt((x-90).^2 + (y-240).^2);
filtro = 1 ./ (1 + B * ((d2 ./ D).^(2 * n)));
F6 = F5 .* filtro;

D = sqrt((x+81).^2 + (y-246).^2);
filtro = 1 ./ (1 + B * ((d2 ./ D).^(2 * n)));
F7 = F6 .* filtro;

D = sqrt((x-81).^2 + (y+246).^2);
filtro = 1 ./ (1 + B * ((d2 ./ D).^(2 * n)));
F8 = F7 .* filtro;


% Mostra a transformada de fourier com os filtros aplicados
figure;imshow(real(log(F8)), []);

% Aplica a transformada de fourier reversa
I = uint8(real(ifft2(ifftshift(F8))));

% Mostra o resultado final da imagem
figure; imshow(I);
