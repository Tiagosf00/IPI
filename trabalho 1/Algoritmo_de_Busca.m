% Universidade de Brasília
% Introdução ao Processamento de Imagem
% Tiago de Souza Fernandes - 18/0131818
%
% Algoritmo de busca de melhor caminho de um ponto
% a outro na superfície de marte, utilizando como
% paramêtro a distância e o nível de brilho.


% Lê a imagem da superfície de Marte (RGB).
MRGB = imread('Mars.bmp');

% Armazena cada uma das 3 componentes de cor da imagem.
red = MRGB(:, :, 1);
green = MRGB(:, :, 2);
blue = MRGB(:, :, 3);

% Une as 3 componentes de cor poderadamente em uma unica matriz,
% que representa a imagem monocromática.
MGray = 0.2989*red + 0.587*green + 0.114*blue;

% Equaliza o histograma da imagem.
MHeq = histeq(MGray);

% Coordenadas iniciais.
y = 260;
x = 415;

% Coordenadas finais.
yf = 815;
xf = 1000;

% Inicializa uma matriz do mesmo tamanho da imagem
% para armazenar o caminho, e adiciona o pixel inicial.
rota = uint8(zeros(size(MHeq)));
rota(y, x)=255;

% Vetores auxiliares para acessar pixels adjacentes.
dy = [-1 0 1 1 1 0 -1 -1];
dx = [-1 -1 -1 0 1 1 1 0];

% Itera em busca pelo caminho até que o destino seja alcançado.
while(x~=xf && y~=yf)
	% Vetor auxiliar para armazenar as distâncias euclidianas dos pixels.
	D = zeros(8);

	% Variáveis auxiliares para armazenarem a informação do pixel
	% com menor valor de brilho. 
	minimo = 500;
	mx = 0;
	my = 0;

	% Calcula as distâncias euclidianas de cada um dos pixels
	% adjacentes e os ordena.
	for n = 1:8
		D(n,1) = sqrt((x+dx(n)-xf)^2+(y+dy(n)-yf)^2);
	end
	S = sort(D);

	% Itera novamente pelos pixels adjacentes, procurando
	% pelos 3 com menor distância em relação ao ponto final,
	% comparando os valores com o vetor ordenado, e armazenando
	% apenas o pixel com menor brilho dentre eles. 
	for n = 1:8
		d = sqrt((x+dx(n)-xf)^2+(y+dy(n)-yf)^2);
		if d == S(1,1) || d == S(2,1) || d == S(3, 1)
			if MHeq(y+dy(n), x+dx(n)) < minimo
				minimo = MHeq(y+dy(n), x+dx(n));
				mx = x + dx(n);
				my = y + dy(n);
			end
		end
	end

	% Atualiza e armazena o pixel encontrado.
	x=mx;
	y=my;
	rota(y, x) = 255;

	% Pinta as bordas do caminho para facilitar a visualização na imagem.
	for n = 1:8
		rota(y+dy(n), x+dx(n)) = 255;
	end
end

% Concatena e mostra a imagem da rota com a imagem da superfície de Marte.
novo = cat(3, imadd(rota, MHeq), imsubtract(MHeq, rota), imsubtract(MHeq, rota));
imshow(novo)
