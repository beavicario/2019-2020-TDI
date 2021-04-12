%%%% Tarea 1: Transformaciones de intensidad y filtrado espacial %%%%

   % María Guadaño Nieto.
   % Beatriz Vicario Guerrero.
   
%% Parte Obligatoria

clear all, close all, clc;

Imagen = imread('Cabra.jfif');

% Obtener una imagen binaria, del mismo tamaño (filas*columnas)

% Sacamos Componentes RGB.
figure,
subplot(1,3,1), imshow(Imagen(:,:,1)), title('R')
subplot(1,3,2), imshow(Imagen(:,:,2)), title('G')
subplot(1,3,3), imshow(Imagen(:,:,3)), title('B')

% Elegimos la componente Azul.
Imagen_B = Imagen(:,:,3);

M = 11; 
Level = 140/255;

% Suavizamos la imagen con la Componente Azul.
Imagen_Suavizado = medfilt2(Imagen_B, [M M], 'symmetric');

% Obtener una imagen binaria, del mismo tamaño (filas*columnas)
% Convertimos la imagen a binaria.
Imagen_Bin = im2bw(Imagen_Suavizado, Level)*255;


% Utilizamos la transpuesta del Filtro 'Prewitt' para obtener las líneas
% verticales de mayor intensidad.
Prewitt = fspecial('Prewitt');
T_Prewitt = Prewitt';
I_Prewitt = imfilter(Imagen_Bin, T_Prewitt, 'symmetric');

% Pasamos la imagen, suavizada y filtrada, a imagen binaria.
I_Final = im2bw(uint8(abs(I_Prewitt)),0.4);

figure,
subplot(2,2,1), imshow(Imagen), title('Imagen Original')
subplot(2,2,2), imshow(Imagen_Suavizado), title('Imagen Suavizada')
subplot(2,2,3), imshow(Imagen_Bin), title('Imagen Binaria')
subplot(2,2,4), imshow(I_Final), title('Imagen Filtrada')










%% Imagen RGB diferenciada por cambio de componentes.
clear all, close all, clc;
Imagen = imread('Hojas.jfif');

% Declaramos Componentes RGB.
R = Imagen(:, :, 1);
G = Imagen(:, :, 2);
B = Imagen(:, :, 3);

figure, 
subplot(1,3,1), imshow(R), title('Imagen Componente Roja');
subplot(1,3,2), imshow(G), title('Imagen Componente Verde');
subplot(1,3,3), imshow(B), title('Imagen Componente Azul');

% Creamos una matriz de ceros de un una sola componente.
I = uint8(zeros(size(Imagen,1),size(Imagen,1)));
I = (240/255)*R + (255/255)*G + (0/255)*B;

M = 5;
Level = 0.01;
% Suavizamos la imagen modificada.
Imagen_Suavizado = medfilt2(I, [M M], 'symmetric');

% Filtramos la imagen.
H_Prewitt = fspecial('prewitt');       
Imagen_Prewit = uint8(abs(imfilter(Imagen_Suavizado, H_Prewitt, 'symmetric')));

% Convertimos a imagen binaria.
Imagen_Bin = im2bw(Imagen_Prewit, Level);

% Convertimos a imagen RGB.
Imagen_Map = [50 50 50; 0 0 255];
Imagen_RGB = ind2rgb(Imagen_Bin, Imagen_Map);

figure, 
subplot(2,3,1), imshow(Imagen), title('Imagen Original');
subplot(2,3,2), imshow(I), title('Imagen por Componentes');
subplot(2,3,3), imshow(Imagen_Suavizado), title('Imagen Suavizada');
subplot(2,3,4), imshow(Imagen_Prewit), title('Imagen Filtrada');
subplot(2,3,5), imshow(Imagen_Bin), title('Imagen Binaria');
subplot(2,3,6), imshow(Imagen_RGB), title('Imagen RGB');






%% OTRO OPCIONAL
%% Reconstrucción de una imagen con componentes RGB a partir de su negativo.
clear all, close all, clc;
umbrellas = imread('umbrellas.jpg');

% Extracción de las componentes de la imagen seleccionada.
umbrellas_red = umbrellas( :, :, 1);
umbrellas_grey = umbrellas( :, :, 2);
umbrellas_blue = umbrellas( :, :, 3);

% Representación de las componentes obtenidas.
figure
subplot(1,3,1), imshow(umbrellas_red), title('Componente roja')
subplot(1,3,2), imshow(umbrellas_grey), title('Componente roja')
subplot(1,3,3), imshow(umbrellas_blue), title('Componente roja')


% Negativo de la imagen original seleccionada.
N_umbrellas = uint8(255-double(umbrellas));


% Negativo de las componentes RGB obtenidas.
NR_umbrellas = 255-umbrellas_red;
NG_umbrellas = 255-umbrellas_grey;
NB_umbrellas = 255-umbrellas_blue;

% Reconstrucción de la imagen por cada componente.
Imagen_R = umbrellas;
Imagen_R( :, :, 1) = uint8(NR_umbrellas);

Imagen_G = umbrellas;
Imagen_G( :, :, 2) = uint8(NG_umbrellas);

Imagen_B = umbrellas;
Imagen_B( :, :, 3) = uint8(NB_umbrellas);


% Representación de las componentes obtenidas.
figure;
subplot(2,3,1), imshow(umbrellas), title('Imagen original')
subplot(2,3,3), imshow(N_umbrellas), title('Imagen del negativo')
subplot(2,3,4), imshow(Imagen_R), title('Componentes R')
subplot(2,3,5), imshow(Imagen_G), title('Componentes G')
subplot(2,3,6), imshow(Imagen_B), title('Componentes B')


