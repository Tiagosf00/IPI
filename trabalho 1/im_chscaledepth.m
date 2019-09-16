% Universidade de Brasília
% Introdução ao Processamento de Imagem
% Tiago de Souza Fernandes - 18/0131818
%
% Função que quantiza o número de cores
% e redimensiona uma imagem de acordo com
% os paramêtros recebidos e retorna o resultado.

% função im_chscaledepth:
%
% img - Imagem a ser processada;
%
% bits - inteiro entre 1 e 8 representando a quantidade
% de bits em que devem caber todas as cores da imagem;
%
% factor - número real que representa a escala com que
% a imagem deve ser redimensionada;
function [y] = im_chscaledepth(img, bits, factor)

% Quantiza a quantidade de cores da imagem
% ao fazer com que todos os valores sejam aproximados
% por inteiros entre 0 e 2^bits-1, de depois normalizando
% os pixels para valores entre 0 e 255.
s = round(((2^bits-1)/(2^8-1))*double(img));
M = max(s(:));
aux=uint8(255*(s/M));

% Armazena as dimensões da imagem e inicizaliza uma nova matriz
% com as dimensões da nova imagem, levando em consideração o
% fator recebido como parâmetro.
[oldrow, oldcol, olddim] = size(aux);
new = zeros(round(oldrow*factor), round(oldcol*factor), olddim);

% Variáveis auxiliares para varrer a nova matriz.
newrow = 1;
newcol = 1;

% Itera pela nova matriz e ao mesmo tempo, utilizando dos contadores "row" e "col",
% itera sobre os pixels da imagem original, adicionando na nova matriz sempre os
% pixels cujo os indíces são os valores arredondados de col e row.
for row = 1:1/factor:oldrow
	for col = 1:1/factor:oldcol
		new(newrow,newcol,:) = aux(round(row), round(col), :);
		newcol=newcol+1;
	end
	newrow=newrow+1;
	newcol=1;
end

% Normaliza, mostra na tela e retorna a nova matriz.
imshow(new);
y = new;