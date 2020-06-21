%%%% Lectura, visualización y almacenamiento de imágenes %%%%

%% Declarar variables.
clear all, close all, clc

Pimientos= imread('peppers.png');
Monedas= imread('coins.png');
Cara= imread('cara.tif');

%% Dimensión de la variable asociada a cada una de las imágenes.

%whos(Saca las características de la imagen, no es necesario size)

imtool(Pimientos)
size_Pimientos = size(Pimientos)

imtool(Monedas)
size_Monedas = size(Monedas)

imtool(Cara)
size_Cara = size(Cara)

%% Imagen binaria a RGB.

Cara_mapa = [255 255 0; 255 0 0];
Cara_RGB = ind2rgb(Cara, Cara_mapa);
figure, imshow(Cara_RGB)

%% RGB a Escala de Grises.

Pimientos_gray = rgb2gray(Pimientos);
imtool(Pimientos_gray);          %Se genera la imagen, no es necesario imshow.    

%% RGB a Indexada con 255 niveles.

[Pimientos_index255, mapa_255]= rgb2ind(Pimientos,255);
imtool(Pimientos_index255, mapa_255)

%% RGB a Indexada con 5 niveles.

[Pimientos_index5, mapa_5]= rgb2ind(Pimientos,5);
imtool(Pimientos_index5, mapa_5)

%% Escala de grises a Indexada 5 niveles.

[Monedas_index5, mapa_5]= gray2ind(Monedas, 5);
imtool(Monedas_index5, mapa_5)

%% Escala de grises a binaria.

[Monedas_binaria]= im2bw(Monedas);
imtool(Monedas_binaria)

%% Guardar imágenes.

imwrite(Cara_RGB, 'Cara_RGB.tif');
imwrite(Pimientos_index5, mapa_5, 'Pimientos_index5.png');

%%
%%%% Modificación de la resolución espacial y en intensidad %%%%

%% Modificar resolución y número de niveles.
clear all, close all, clc

Lena_512 = imread('Lena_512.tif');

Lena_256 = imresize(Lena_512,0.5);   %Reducir con un diezmado de 1/2. Cada dos líneas coges una.
figure, imshow(Lena_256)
imwrite(Lena_256,'Lena_256.tif')

Lena_128 = imresize(Lena_512,0.25);   %Reducir con un diezmado de 1/4. Cada cuatro líneas coges una.
figure, imshow(Lena_128)
imwrite(Lena_128,'Lena_128.tif')

whos

%% Menor resolución espacial a tamaño inicial de la imagen.
close all

Lena_512a = imresize(Lena_128,4,'nearest');    %Lineal,replica los pixeles uno a uno.
subplot(1,2,1),imshow(Lena_512a)               %subplot(fila, columna, posición)
title('Lena Interpolación Lineal.tif')

Lena_512b = imresize(Lena_128,4,'bilinear');   %Utiliza los pixeles adyacentes para generar un pixel.
subplot(1,2,2),imshow(Lena_512a)
title('Lena Interpolación Bilineal.tif')

%% Reducir el número de niveles de intensidad.
close all

[Lena_16, map16niv] = gray2ind(Lena_512, 16);
[Lena_4, map4niv] = gray2ind(Lena_512, 4);
[Lena_2, map2niv] = gray2ind(Lena_512, 2);

figure,
subplot(1, 3, 1), imshow(Lena_16, map16niv), title('Lena a 16 niveles');
subplot(1, 3, 2), imshow(Lena_4, map4niv), title('Lena a 4 niveles');
subplot(1, 3, 3), imshow(Lena_2, map2niv), title('Lena a 2 niveles');

%%
%%%% Histograma y mejora de contraste %%%%

%% Histogramas de las imágenes.
close all

figure
subplot(2,2,1), imhist(Lena_512,256), title('Lena 512: Histograma Original')
subplot(2,2,2), imhist(Lena_16,map16niv), title('Lena 16: Histograma Original')
subplot(2,2,3), imhist(Lena_4,map4niv), title('Lena 4: Histograma Original')
subplot(2,2,4), imhist(Lena_2,map2niv), title('Lena 2: Histograma Original')

%% Ecualización de histograma.
close all

Imagen = imread('pout.tif');
I_eq = histeq(Imagen);

figure, 
subplot(2,2,1),imshow(Imagen), title('Imagen Original')
subplot(2,2,2), imshow(I_eq), title('Imagen Ecualizada')
subplot(2,2,3), imhist(Imagen), title('Histograma de Imagen Original')
axis auto          %Límites de representación los ejes de manera automática.  
subplot(2,2,4), imhist(I_eq), title('Histograma de Imagen Ecualizada')
axis auto   

%%
%%%% Interpretación del color y transformaciones puntuales %%%%

%% Imagen Peppers.png y extraer la componente roja.
clear all, close all, clc

Peppers = imread('peppers.png');
Peppers_gray = rgb2gray(Peppers);   %Convertir de RGB a Escala de grises.

Peppers_R= Peppers(:,:,1);  %(todas las filas,todas las columnas,1ªComponente 'Roja')

figure,
subplot(1,2,1), imshow(Peppers_gray), title('Escala de Grises');
subplot(1,2,2), imshow(Peppers_R), title('Componente Roja');

%% Histograma de cada componente RGB. 
close all

Peppers_G= Peppers(:,:,2);
Peppers_B= Peppers(:,:,3);

figure,
subplot(2,3,1), imshow(Peppers_R), title('Componente Roja');
subplot(2,3,2), imshow(Peppers_G), title('Componente Verde');
subplot(2,3,3), imshow(Peppers_B), title('Componente Azul');
subplot(2,3,4), imhist(Peppers_R), title('Histograma Componente Roja');
subplot(2,3,5), imhist(Peppers_G), title('Histograma Componente Verde');
subplot(2,3,6), imhist(Peppers_B), title('Histograma Componente Azul');

%%  Negativo de la componente roja y recomponer RGB.
close all

%Componente_R= -Peppers_R + 255; ¡¡¡MAL!!!
Componente_R= 255 - Peppers_R;   %¡¡¡BIEN!!

Original = Peppers;
Peppers(:, :, 1)= Componente_R;
imshow(Peppers);

%% Representación de componente roja en imagen RGB, color predominante sea rojo.
close all

X = zeros(size(Peppers));
X = uint8(X);       %Conversión a uint8 ¡¡¡NECESARIO!!!

X(:, :, 1) = Peppers_R;
imshow(X);
