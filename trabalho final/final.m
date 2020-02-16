% Lê o rosto da pessoa
I = imread('bruno.jpeg');

[x, y, z] = size(I);

% Inserir ou não a boca
boolMouth = 1;

% Inserir ou não o chapéu
boolHat = 1;

% Lê o template dos olhos e seu canal alpha
[Eyesize, ~, ImageAlpha1size] = imread('eye2.png');
[x1,y1,z] = size(Eyesize);

% Caso a imagem não possua um canal alpha, gera um canal alpha
if ~size(ImageAlpha1size)
	ImageAlpha1size(1:x1,1:y1) = 255;
end


if boolMouth
	% Lê o template da boca e seu canal alpha
	[Mouthsize, ~, ImageAlpha2size] = imread('mouth2.png');
	[x2,y2,z] = size(Mouthsize);
	
	% Caso a imagem não possua um canal alpha, gera um canal alpha
	if ~size(ImageAlpha2size)
		ImageAlpha2size(1:x2,1:y2) = 255;
	end
end

if boolHat
	% Lê o template do chapéu e seu canal alpha
	[Hatsize, ~, ImageAlpha3size] = imread('hat3.png');
	[x3,y3,z] = size(Hatsize);
	
	% Caso a imagem não possua um canal alpha, gera um canal alpha
	if ~size(ImageAlpha3size)
		ImageAlpha3size(1:x3,1:y3) = 255;
	end
end


% Identifica a posição dos olhos
eyedetector = vision.CascadeObjectDetector('EyePairBig');
bbox = eyedetector(I);
[a,b] = size(bbox);

% Mostra a quantidade de par de olhos identificados na imagem
a


% Proporções para o tamanho dos templates
propeye = 1.2; % Tamanho do template dos olhos
distmouth = 0.6; % Distância entre a boca e os olhos
propmouth = 0.8; % Tamanho do template da boca
disthat = 0.7; % Distância entre o chapéu e os olhos
prophat = 2.6; % Tamanho do template de chapéu

% O identificador de olhos pode identificar mais que um par de olhos,
% ele lê apenas o primeiro identificado.
for k = 1
	% Cria uma imagem auxiliar para ser alterada
	Img = I;

	% Redimensiona o template dos olhos para caber no rosto
	scale = bbox(k,3)/y1;
	Eye = imresize(Eyesize,propeye*scale);
	ImageAlpha1 = imresize(ImageAlpha1size,propeye*scale);
	[x1,y1,z] = size(Eye);


	% Posição do template = posição aonde os olhos foram identificados - d(x,y)
	dx = floor((x1-bbox(k,4))/2);
	dy = floor((propeye-1)*bbox(k,3)/2);

	% Mostra a imagem original o local onde os olhos foram identificados
	figure;imshow(Img);
	hold on
	rectangle('position',[bbox(k,1) bbox(k,2) bbox(k,3) bbox(k,4)], 'edgecolor', [1 0 0], 'LineWidth',3);

	% Une o template a imagem original, fazendo uma proporção entre os pixels
	% usando o valor de ImageAlpha
	for i = 1:x1
		for j = 1:y1
			m = bbox(k,2)-dx+i;
			n = bbox(k,1)+j-dy;
			if m > 0 & n > 0 & m <= x & n <= y
				alfa = ImageAlpha1(i,j)/255;
				%Img = (255-Alpha)/255 * Img + Alpha/255 * Template
				Img(m, n, :) = (1-alfa)*Img(m, n, :) + alfa*Eye(i,j,:);
			end
		end
	end

	if boolMouth
		% Redimensiona o template da boca para caber no rosto
		scale = bbox(k,3)/y2;
		Mouth = imresize(Mouthsize, propmouth*scale);
		ImageAlpha2 = imresize(ImageAlpha2size,propmouth*scale);
		[x2,y2,z] = size(Mouth);

		mouthcentery = floor(bbox(k,1)+bbox(k, 3)/2);
		mouthcenterx = floor((bbox(k, 2)+bbox(k, 4)/2) + bbox(k, 3)*distmouth);

		% Une o template a imagem original, fazendo uma proporção entre os pixels
		% usando o valor de ImageAlpha
		for i = 1:x2
			for j = 1:y2
				m = mouthcenterx-floor(x2/2)+i;
				n = mouthcentery-floor(y2/2)+j;
				if m > 0 & n > 0 & m <= x & n <= y
					alfa = ImageAlpha2(i,j)/255;
					%Img = (255-Alpha)/255 * Img + Alpha/255 * Template
					Img(m, n, :) = (1-alfa)*Img(m,n,:) + alfa*Mouth(i,j,:);
				end
			end
		end

		viscircles([mouthcentery, mouthcenterx], 10);
	end

	if boolHat
		% Redimensiona o template do chapéu
		scale = bbox(k,3)/y3;
		Hat = imresize(Hatsize, prophat*scale);
		ImageAlpha3 = imresize(ImageAlpha3size, prophat*scale);
		[x3,y3,z] = size(Hat);

		hatcentery = floor(bbox(k,1)+bbox(k, 3)/2);
		hatcenterx = floor((bbox(k, 2)+bbox(k, 4)/2) - bbox(k, 3)*disthat);

		% Une o template a imagem original, fazendo uma proporção entre os pixels
		% usando o valor de ImageAlpha
		for i = 1:x3
			for j = 1:y3
				m = hatcenterx-floor(x3/2)+i;
				n = hatcentery-floor(y3/2)+j;
				if m > 0 & n > 0 & m <= x & n <= y
					alfa = ImageAlpha3(i,j)/255;
					%Img = (255-Alpha)/255 * Img + Alpha/255 * Template
					Img(m, n, :) = (1-alfa)*Img(m,n,:) + alfa*Hat(i,j,:);
				end
			end
		end

		viscircles([hatcentery, hatcenterx], 10);
	end
	hold off

	% Mostra o resultado final
	figure;imshow(Img);

end
