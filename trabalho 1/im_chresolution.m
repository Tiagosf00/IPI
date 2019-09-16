% Universidade de Brasília
% Introdução ao Processamento de Imagem
% Tiago de Souza Fernandes - 18/0131818
%
% Função que redimensiona uma imagem de acordo
% com os paramêtros recebidos, e retorna o resultado.

% função im_chresolution:
%
% img - Imagem a ser processada;
%
% factor - número real que representa a escala com que
% a imagem deve ser redimensionada;
%
% modo - valor inteiro entre 1 e 2, representa a abordagem
% a ser utilizada pela função para redimencionar a imagem.
%	1 - Copia os pixels de cima e da esquerda;
% 	2 - Faz uma média entre os pixels da direita e esquerda, ou os de cima e baixo;
function [y] = im_chresolution(img, factor, modo)

% Garante que a imagem vai ser monocromática
if size(img,3)==3
	red = img(:, :, 1);
	green = img(:, :, 2);
	blue = img(:, :, 3);
	imgray = 0.2989*red + 0.587*green + 0.114*blue;
end

% Armazena as dimensões da imagem e inicizaliza uma nova matriz
% com as dimensões da nova imagem, levando em consideração o
% fator recebido como parâmetro.
[oldrow, oldcol] = size(imgray);
new = zeros(round(oldrow*factor), round(oldcol*factor));

% Variáveis auxiliares para varrer a nova matriz.
newrow = 1;
newcol = 1;


% Itera pela nova matriz e ao mesmo tempo, utilizando dos contadores "row" e "col",
% itera sobre os pixels da imagem original, adicionando na nova matriz sempre os
% pixels cujo os indíces são os valores arredondados de col e row.
if modo==1 % Abordagem 1
	for row = 1:1/factor:oldrow
		for col = 1:1/factor:oldcol
			new(newrow,newcol) = imgray(floor(row), floor(col)); % Pixels de cima e da esquerda
			newcol=newcol+1;
		end
		newrow=newrow+1;
		newcol=1;
	end
elseif modo==2 % Abordagem 2
	for row = 1:1/factor:oldrow
		for col = 1:1/factor:oldcol
			new(newrow,newcol) = (0.5*imgray(ceil(row), ceil(col)) + 0.5*imgray(floor(row), floor(col))); % Média dos pixels
			newcol=newcol+1;
		end
		newrow=newrow+1;
		newcol=1;
	end

end

% Normaliza, mostra na tela e retorna a nova matriz.
new = new/255;
imshow(new);
y = new;