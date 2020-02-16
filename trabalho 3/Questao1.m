% Lê a imagem
I = imread('mona.bmp');
I = imadjust(I);

% Tamanho dos blocos
d = 8;

% Aplicando padding na imagem
[x, y] = size(I);
I = padarray(I,[rem(x, d) rem(y, d)],0,'post');
% Armazenando a imagem para futura comparação
ref = I;

[x, y] = size(I);

passo = [1, 10, 20, 50, 100];
PSNR = [];
VAR = zeros(1, length(passo));

% Itera pelos valores de passo utilizados
for p = 1:length(passo)
    I = ref;
    % Itera pelos blocos dxd (8x8)
    for l = d:d:x
        for k = d:d:y
            aux = I(l-d+1:l,k-d+1:k,:);

            % Realiza a transformada DCT apenas no bloco dxd,
            % aplicando a quantização com a função floor
            aux = dct2(aux);
            aux = passo(p)*floor(aux/passo(p));
            VAR(p) = VAR(p) + var(aux(:)); % Calcula a variância
            aux = idct2(aux);

            I(l-d+1:l,k-d+1:k,:) = aux;
        end
    end
    % Cacula a PSNR
    [peaksnr, snr] = psnr(I, ref);
    PSNR(p) = peaksnr;
    if passo(p)==10 | passo(p)==50
        I = imadjust(I);
        figure;imshow(I);
    end
end
VAR = VAR/(x*y/(d*d));

PSNR
VAR

figure;plot(PSNR, VAR);
