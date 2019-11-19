I = imread('foto.jpg'); % Abre uma foto

[X, map] = gray2ind(I, 16); % Remapeia a quantidade de tons de cinza para 16
II = ind2gray(X, map);

imshow(II); % Mostra a imagem

RGB = imread('foto.jpg');
I = rgb2gray(RGB);

Eq = histeq(I); % Equaliza a imagem