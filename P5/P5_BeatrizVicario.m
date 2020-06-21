
%%%% Práctica 5: Segmentación de Imagen (II) %%%%

%% Análisis visual de la imagen.
clear all; close all; clc; imtool close all;

I = imread('cormoran_rgb.jpg');
I_Gray = rgb2gray(I);

%Umbralizamos
I_bw = im2bw(I_Gray,160/255);

figure,
subplot(1,3,1), imshow(I), title('Imagen original')
subplot(1,3,2), imshow(I_Gray), title('Imagen escala de grises')
subplot(1,3,3), imshow(I_bw), title('Imagen umbralizada')

%% Características RGB y algoritmo k-medias.

I_R = I(:,:,1);
[nrows, ncols] = size(I_R);
I_R_res = reshape(I_R,nrows*ncols,1);

I_G = I(:,:,2);
[nrowsG, ncolsG] = size(I_G);
I_G_res = reshape(I_G,nrowsG*ncolsG,1);

I_B = I(:,:,3);
[nrowsB, ncolsB] = size(I_B);
I_B_res = reshape(I_B,nrowsB*ncolsB,1);

figure,
plot3(I_R_res, I_G_res, I_B_res, '.');

ngrupos = 3;
rgb_res = double([I_R_res I_G_res I_B_res]);
[cluster_idx, cluster_center] = kmeans(rgb_res,ngrupos,'distance','sqEuclidean','Replicates',10);

figure, plot3(I_R_res, I_G_res, I_B_res, '.b');
xlabel('R'), ylabel('G'), zlabel('B')

%valor de K
ngrupos = 3;

%Creamos una nueva estructura de datos(nueva matriz).
rgb_res = double([I_R_res I_G_res I_B_res]);

%Aplicamos la funcion kmedia con el valor de K de tres, con 10
%inicializaciones(Replicates,10) quedandose con la mejor(cluster center)
[cluster_idx cluster_center] = kmeans(rgb_res, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10);

%cluster idx es un identificador(vector) que contiene las etiquetas
%asociadas a cada pixel// si haces un histograma, representa las cantidades
%de pixeles por etiquetas//con reshape se aplica el vector a la imagen para
%poder visualizarl los pixeles en la imagen
pixel_labels_rgb = reshape(cluster_idx, nrows, ncols);

figure, hist(cluster_idx);

figure, plot3(I_R_res, I_G_res, I_B_res);
xlabel('R'), ylabel('G'), zlabel('B')
hold on
plot3(cluster_center(:,1), cluster_center(:,2), cluster_center(:,3),'sr','MarkerSize',20,'MarkerEdgeColor', 'r');

figure, imshow(pixel_labels_rgb, []), title('Segmentacion - RGB SIN NORMALIZAR');
I_seg = label2rgb(pixel_labels_rgb);
figure,imshow(I_seg);

%% SEPARACION DE LA IMAGEN EN COMPONENTES LAB Y APLICAR LA FUNCION KMEAN
close all;

%Cambio al espacio lab y considero unicamente el espacio ab(ahora nuestro
%espacio de caracteristicas tiene solo 2 dimensiones en vez de 3
[lab_imL, l_L, a_L, b_L] = rgb2lab(I);;
a_res = reshape(a_L, nrows*ncols,1);
b_res = reshape(b_L, nrows*ncols,1);
figure, mesh(a_L);
figure, mesh(b_L);

ab_res = [a_res, b_res];

%cluster center tendria unas dimensiones de 3x2 porque tienes 3
%centroides(etiquetas) en 2 dimensiones
[cluster_idx cluster_center] = kmeans(ab_res, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10);

figure, plot(a_res, b_res, '.');
xlabel('a'), ylabel('b')
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');

pixels_labels_ab = reshape(cluster_idx, nrows, ncols);
I_seg = label2rgb(pixels_labels_ab);
figure, imshow(I_seg);

%normalizamos las dos componentes para que tengan media cero y std 1
ab_res = [a_res b_res];
ndim = size(ab_res,2);
ab_norm = ab_res;
for ind_dim=1:ndim
    datos = ab_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_norm(:,ind_dim) = datos_norm;
end 

[cluster_idx_norm cluster_center] = kmeans(ab_norm, ngrupos,'distance','sqEuclidean', 'Replicates', 10);
pixels_labels_ab_norm = reshape(cluster_idx_norm, nrows, ncols);

I_seg = label2rgb(pixels_labels_ab_norm);
figure, imshow(I_seg);
figure, plot(ab_norm(:,1), ab_norm(:,2));

%% AHORA EN EL ESPACIO ES Y APLICAR LA FUNCION K-MEAN

E = entropyfilt(I_gray, ones(7,7));

%A mayor entropua mas inhomogenea es la imagen en cuanto a caracteristicas
%de textura

S = stdfilt(I_gray, ones(7,7));
R = rangefilt(I_gray,ones(7,7));

imtool(E,[]), title('E');
imtool(S,[]), title('S');
imtool(R,[]), title('R');

%Escogemos dos componentes, normalizamos el rango y hacemos k-medias

E_res = reshape(E,nrows*ncols,1);
S_res = reshape(S,nrows*ncols,1);
ES_res = [E_res S_res];

%normalizacion
ndim = size(ES_res,2);
ES_norm = ES_res;
for ind_dim=1:ndim
    datos = ES_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ES_norm(:,ind_dim) = datos_norm;
end 

[cluster_idx_norm cluster_center] = kmeans(ES_norm, ngrupos,'distance','sqEuclidean', 'Replicates', 10);
pixels_labels_ES_norm = reshape(cluster_idx_norm, nrows, ncols);

I_seg = label2rgb(pixels_labels_ES_norm);
figure, imshow(I_seg);
figure, plot(ES_norm(:,1), ES_norm(:,2));
xlabel('E_norm'), ylabel('S_norm');
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');

%% HACEMOS LA COMBINACION DE ab y E

[cluster_idx_norm cluster_center] = kmeans([ab_norm ES_norm(:,1)], ngrupos,'distance','sqEuclidean', 'Replicates', 10);
pixels_labels_ES_norm = reshape(cluster_idx_norm, nrows, ncols);

I_seg = label2rgb(pixels_labels_ES_norm);
figure, imshow(I_seg);
figure, plot3(ab_norm(:,1),ab_norm(:,2),ES_norm(:,1));
xlabel('a'), ylabel('b'), zlabel('E')
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');

%% APLICAMOS LOS FILTROS a ab y usamos otra vez E

%Hacemos un filtro paso bajo de la componente a y de la componente b para
%quitar al pajaro

mascara = 1/49*ones(7,7);
a_mean = imfilter(a_L, mascara,'symmetric');
b_mean = imfilter(b_L,mascara,'symmetric');

a_mean_res = reshape(a_mean, nrows*ncols,1);
b_mean_res = reshape(b_mean, nrows*ncols,1);


ab_mean_res = [a_mean_res b_mean_res];
ndim = size(ab_mean_res,2);
ab_mean_norm = ab_mean_res;
for ind_dim=1:ndim
    datos = ab_mean_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_mean_norm(:,ind_dim) = datos_norm;
end 

[cluster_idx_norm cluster_center] = kmeans([ab_mean_norm ES_norm(:,1)], ngrupos,'distance','sqEuclidean', 'Replicates', 10);
pixels_labels_ab_mean_norm = reshape(cluster_idx_norm, nrows, ncols);

I_seg = label2rgb(pixels_labels_ab_mean_norm);
figure, imshow(I_seg);
figure, plot(ab_mean_norm(:,1), ab_mean_norm(:,2));
xlabel('ab_mean_norm'), ylabel('ab_mean_norm');
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');
