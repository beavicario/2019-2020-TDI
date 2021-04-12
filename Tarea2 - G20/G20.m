
%%%% Tarea 2: Filtrado en el dominio de la frecuencia %%%%

   % María Guadaño Nieto.
   % Beatriz Vicario Guerrero.
   
   
%% ----- PARTE OBLIGATORIA
clear all, close all, clc;

% -- Se lee la imagen y se pasa a escala de grises
Imagen = imread('Cabra.jfif');
X = rgb2gray(Imagen);

% -- Obtención de la FFT de la imagen original.
X_FFT = fftshift(fft2(double(X),size(X,1),size(X,2)));

% -- Obtención de módulo y fase de la FFT de la imagen original.
FFT_modulo = abs(X_FFT);
FFT_fase = angle(X_FFT);

figure,
subplot(2,3,1),imshow(X),title('Imagen Original')
subplot(2,3,2),imshow(FFT_modulo, []),title('Módulo FFT Imagen Original')
subplot(2,3,3),imshow(FFT_fase, []),title('Fase FFT Imagen Original') 
subplot(2,3,4),mesh(X)
subplot(2,3,5),mesh(FFT_modulo)
subplot(2,3,6),mesh(FFT_fase)

% -- Filtro paso alto para altas frecuencias (componentes con más energia)
% -- Máscara gaussiana con D0=77
H_Gaussian = fftshift(lpfilter('gaussian', size(X,1), size(X,2), 77));
% -- filtro paso alto
Filtrada_freq = (1 - H_Gaussian).*X_FFT;
% -- inversa de la imagen filtrada para poder visualizarla
FPA_Gaussian = uint8(real(ifft2(Filtrada_freq)));
% -- Modulo y fase
FPA_modulo = abs(Filtrada_freq);
FPA_fase = angle(Filtrada_freq);

figure,
subplot(2,3,1), imshow(FPA_Gaussian, []), title('Filtro Paso alto gaussiano 77')
subplot(2,3,2), imshow(FPA_modulo, []), title('Modulo de la FPA')
subplot(2,3,3), imshow(FPA_fase, []), title('Fase de la FPA')
subplot(2,3,4), mesh(FPA_Gaussian)
subplot(2,3,5), mesh(FPA_modulo)
subplot(2,3,6), mesh(FPA_fase)

%-- Se umbraliza la imagen y se pasan los pixeles en primer plano de 1 a 255
X_FFT_binaria = imbinarize(FPA_Gaussian, 0.015)*255;
figure, imshow(X_FFT_binaria), title('Binaria')



%% ----- PARTE CREATIVA
clear all, close all, clc;

% -- Se lee la imagen y se pasa a escala de grises
Imagen = imread('Cabra.jfif');
X = rgb2gray(Imagen);

% -- Introducción de un ruido gaussiano para producir pequeñas variaciones en la imagen
Noise = imnoise(X,'gaussian');

% -- Se crean dos filtros, un filtro gaussiano y otro
% -- filtro con una máscara de media de 3x3
H1 = fspecial('gaussian');
H2 = fspecial('average');
Filtro_Gaussian1 = imfilter(Noise,H1);
Filtro_Media2 = imfilter(Noise,H2);

% -- Representaciones de las imágenes
figure,
subplot(2,2,1),imshow(X),title('Imagen original');
subplot(2,2,2),imshow(Noise),title('Imagen con ruido gaussiano');
subplot(2,2,3),imshow(Filtro_Gaussian1),title('Filtro gaussiano');
subplot(2,2,4),imshow(Filtro_Media2),title('Filtro de media 3X3');


