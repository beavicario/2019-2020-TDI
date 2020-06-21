%%%% Imágenes contaminadas con ruido %%%%

%% Contaminar imagen sintética de 8 bits con 'gaussian' y 'speckle'.
clear all, close all, clc;

Imagen= uint8(zeros(256,256) + 128);

%ruido gaussiano
R_Gaussiano= imnoise(Imagen, 'gaussian', 0, 0.02); %(imagen, ruido, media, PWR_Media)

%ruido granular (speckle)
R_Speckle= imnoise(Imagen, 'speckle', 0.02);    %(imagen, ruido, PWR_Media)

%ruido salt & pepper
R_SaltPeppers= imnoise(Imagen, 'salt & pepper', 0.02);  %(imagen, ruidon, PWR_Media)

figure,
subplot(2,4,1),imshow(Imagen),title('Imagen Sintética'), axis auto
subplot(2,4,2),imshow(R_Gaussiano),title('Ruido Gaussiano'), axis auto
subplot(2,4,3),imshow(R_Speckle),title('Ruido Granular'), axis auto
subplot(2,4,4),imshow(R_SaltPeppers),title('Ruido Salt & Pepper'), axis auto
subplot(2,4,5),imhist(Imagen),title('Historigrama Imagen Sintética'), axis auto
subplot(2,4,6),imhist(R_Gaussiano),title('Historigrama Ruido Gaussiano'), axis auto
subplot(2,4,7),imhist(R_Speckle),title('Historigrama Ruido Granular'), axis auto
subplot(2,4,8),imhist(R_SaltPeppers),title('Historigrama Ruido Salt & Pepper'), axis auto

%% 
%%%% Filtros espaciales suavizadores %%%%

%% Filtrado lineal - Tratamiento de bordes.
close all;

H = 1/25 * ones(5,5);       %zero-padding

FPB_Zero_Gaussiana = imfilter(R_Gaussiano, H);
FPB_Zero_Speckle = imfilter(R_Speckle, H);
FPB_Zero_SaltPeppers = imfilter(R_SaltPeppers, H);

figure,
subplot(2,2,1),imshow(R_Gaussiano),title('Imagen Ruido Gaussiano'), axis auto
subplot(2,2,2),imshow(FPB_Zero_Gaussiana),title('Imagen Filtrada Zero Padding'), axis auto
subplot(2,2,3),imhist(R_Gaussiano), axis auto
subplot(2,2,4),imhist(FPB_Zero_Gaussiana), axis auto

figure,
subplot(2,2,1),imshow(R_Speckle),title('Imagen Ruido Speckle'), axis auto
subplot(2,2,2),imshow(FPB_Zero_Speckle),title('Imagen Filtrada Zero Padding'), axis auto
subplot(2,2,3),imhist(R_Speckle),axis auto
subplot(2,2,4),imhist(FPB_Zero_Speckle), axis auto

figure,
subplot(2,2,1),imshow(R_SaltPeppers),title('Imagen Ruido Salt & Pepper'), axis auto
subplot(2,2,2),imshow(FPB_Zero_SaltPeppers),title('Imagen Filtrada Zero Padding'), axis auto
subplot(2,2,3),imhist(R_SaltPeppers), axis auto
subplot(2,2,4),imhist(FPB_Zero_SaltPeppers), axis auto

%% Filtrado lineal - Simétrica.
close all;

%mirror-padding

FPB_Mirror_Gaussiana = imfilter(R_Gaussiano, H, 'symmetric');
FPB_Mirror_Speckle = imfilter(R_Speckle, H, 'symmetric');
FPB_Mirror_SaltPeppers = imfilter(R_SaltPeppers, H, 'symmetric');

figure,
subplot(2,2,1),imshow(R_Gaussiano),title('Imagen Ruido Gaussiano'), axis auto
subplot(2,2,2),imshow(FPB_Mirror_Gaussiana),title('Imagen Filtrada Mirror Padding'), axis auto
subplot(2,2,3),imhist(R_Gaussiano), axis auto
subplot(2,2,4),imhist(FPB_Mirror_Gaussiana), axis auto

figure,
subplot(2,2,1),imshow(R_Speckle),title('Imagen Ruido Speckle'), axis auto
subplot(2,2,2),imshow(FPB_Mirror_Speckle),title('Imagen Filtrada Mirror Padding'), axis auto
subplot(2,2,3),imhist(R_Speckle), axis auto
subplot(2,2,4),imhist(FPB_Mirror_Speckle), axis auto

figure,
subplot(2,2,1),imshow(R_SaltPeppers),title('Imagen Ruido Salt & Pepper'), axis auto
subplot(2,2,2),imshow(FPB_Mirror_SaltPeppers),title('Imagen Filtrada Mirror Padding'), axis auto
subplot(2,2,3),imhist(R_SaltPeppers), axis auto
subplot(2,2,4),imhist(FPB_Mirror_SaltPeppers), axis auto

%% Filtrado lineal - Matriz 35x35.
close all;

H_35= 1/1225 * ones(35,35);

FPB_35_Zero_Gaussiano = imfilter (R_Gaussiano, H_35);
FPB_35_Mirror_Gaussiano = imfilter (R_Gaussiano, H_35, 'symmetric');

figure,
subplot(2,3,1),imshow(R_Gaussiano),title('Imagen Ruido Gaussiano'), axis auto
subplot(2,3,2),imshow(FPB_35_Zero_Gaussiano),title('Imagen Filtrado 35x35 - Zero Padding'), axis auto
subplot(2,3,3),imshow(FPB_35_Mirror_Gaussiano),title('Imagen Filtrado 35x35 - Mirror Padding'), axis auto
subplot(2,3,4),imhist(R_Gaussiano), axis auto
subplot(2,3,5),imhist(FPB_35_Zero_Gaussiano), axis auto
subplot(2,3,6),imhist(FPB_35_Mirror_Gaussiano), axis auto

%% Filtrado no lineal.
close all;

FPB_Mediana_Gaussiana = medfilt2(R_Gaussiano, [5 5], 'symmetric');

figure,
subplot(2,1,1),imshow(FPB_Mediana_Gaussiana),title('Imagen Ruido Gaussiano con Filtro Mediana'), axis auto
subplot(2,1,2),imhist(FPB_Mediana_Gaussiana), axis auto

FPB_Mediana_Speckle = medfilt2(R_Speckle, [5 5], 'symmetric');

figure,
subplot(2,1,1),imshow(FPB_Mediana_Speckle),title('Imagen Ruido Granular con Filtro Mediana'), axis auto
subplot(2,1,2),imhist(FPB_Mediana_Speckle), axis auto

FPB_Mediana_SaltPeppers = medfilt2(R_SaltPeppers, [5 5], 'symmetric');

figure,
subplot(2,1,1),imshow(FPB_Mediana_SaltPeppers),title('Imagen Ruido Salt & Pepper con Filtro Mediana'), axis auto
subplot(2,1,2),imhist(FPB_Mediana_SaltPeppers), axis auto

%%  
%%%% Filtros espaciales de realce de contornos %%%%

%% Filtrado espacial.
clear all, close all, clc;

Coins = imread('coins.png');
Prewitt = fspecial('Prewitt');
T = Prewitt';   %Transpuesta para las verticales.

I_Prewitt = imfilter(Coins, Prewitt, 'symmetric');
I_T = imfilter(Coins, T, 'symmetric');

I_grad_Prewitt = imadd (I_Prewitt,I_T);

I_Binaria = im2bw(I_grad_Prewitt, 0.10);

figure,
subplot(2,3,1),imshow(Coins),title('Imagen Original'), axis auto
subplot(2,3,2),imshow(I_grad_Prewitt),title('Imagen Prewitt'), axis auto
subplot(2,3,3),imshow(I_Binaria),title('Imagen Binaria'), axis auto
subplot(2,3,4),imhist(Coins), axis auto
subplot(2,3,5),imhist(I_grad_Prewitt), axis auto
subplot(2,3,6),imhist(I_Binaria), axis auto

%% Filtrado isotrópico.
close all;

H_Isotropico = [-1 -1 -1
                -1 8 -1
                -1 -1 -1];
     
I_Isotropico = imfilter(Coins, H_Isotropico, 'symmetric');

I_Isotropico_Binario = im2bw(I_Isotropico, 0.10);

figure,
subplot(2,3,1),imshow(Coins),title('Imagen Original'), axis auto
subplot(2,3,2),imshow(I_Isotropico),title('Imagen Isotrópica'), axis auto
subplot(2,3,3),imshow(I_Isotropico_Binario),title('Imagen Isotrópica Binaria'), axis auto
subplot(2,3,4),imhist(Coins), axis auto
subplot(2,3,5),imhist(I_Isotropico), axis auto
subplot(2,3,6),imhist(I_Isotropico_Binario), axis auto

%% Filtrado con pre-procesado (suavizado)
close all;

I_Suavizado = medfilt2(Coins, [11 11], 'symmetric');

I_BW = im2bw(I_Suavizado, 0.4);

figure,
subplot(2,3,1),imshow(Coins),title('Imagen Original'), axis auto
subplot(2,3,2),imshow(I_Suavizado),title('Imagen Suavizada'), axis auto
subplot(2,3,3),imshow(I_BW),title('Imagen Binaria'), axis auto
subplot(2,3,4),imhist(Coins), axis auto
subplot(2,3,5),imhist(I_Suavizado), axis auto
subplot(2,3,6),imhist(I_BW), axis auto

%% Filtro de realce.
close all;

Realce = fspecial('Prewitt');
T_Realce = Prewitt';   %Transpuesta para las verticales.

I_BW_Horizontal= imfilter(Coins, Realce, 'symmetric');
I_BW_Vertical = imfilter(Coins, T_Realce, 'symmetric');

figure,
subplot(2,3,1),imshow(Coins),title('Imagen Original'), axis auto
subplot(2,3,2),imshow(I_BW_Horizontal),title('Imagen Horizontal'), axis auto
subplot(2,3,3),imshow(I_BW_Vertical),title('Imagen Vertical'), axis auto
subplot(2,3,4),imhist(Coins), axis auto
subplot(2,3,5),imhist(I_BW_Horizontal), axis auto
subplot(2,3,6),imhist(I_BW_Vertical), axis auto

%%
%%%% Composición de imágenes %%%%
close all;











