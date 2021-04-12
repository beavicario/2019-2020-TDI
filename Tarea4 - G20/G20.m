 %%%% Tarea 4: Segmentación %%%%

   % María Guadaño Nieto.
   % Beatriz Vicario Guerrero.
   
%% ----- PARTE OBLIGATORIA -----
clear all, close all, clc;

%% ----- LECTURA Y VISUALIZACIÓN DE IMAGEN ORIGINAL.

I = imread('G20.jfif');
figure,imshow(I),title('Imagen original')

%% ----- VISUALIZACIÓN DE CADA COMPONENTE DEL MODELO RGB.

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

figure,
subplot(1,3,1), imshow(R), title('Componente R');
subplot(1,3,2), imshow(G), title('Componente G');
subplot(1,3,3), imshow(B), title('Componente B');

%% ----- ELECCIÓN DE UNA COMPONENTE. 
close all;

% -- Nos quedamos con la comonente B para segmentar.
% -- Se observa una diferencia clara entre el objeto y el fondo.

Componente = B;
subplot(1,2,1), imshow(Componente), title('Componente B');
subplot(1,2,2), imhist(Componente), title('Histograma de la Componente B');

%% ----- OBSERVACIÓN DEL VALOR DEL UMBRAL DE LA COMPONENTE.
close all;

% -- Para la obtención del umbral de utiliza la función 'graythresh'.
% -- 'graythresh': obtiene automáticamente un valor umbral
% -- utilizando el método de Otsu.
Umbral = graythresh(Componente);

% -- Umbralizamos con dicho valor y se obtiene la imagen binaria de la
% -- componente a nivel escalar [0,255].
Componente_U = im2bw(Componente,Umbral);
I_bin = uint8(255*Componente_U);

figure, 
subplot(1,2,1), imshow(Componente), title('Componente B');
subplot(1,2,2), imshow(I_bin), title('Imagen Binaria escalada');

%% ----- FILTRADO CON FILTRO DE MEDIANA.

% -- Para homogeneizar el inteior del objeto pero no modificarlo,
% -- se utiliza un flitro no lineal de mediana de máscara 17x17.
% -- En las esquinas se pueden observar objetos de no interés.

I_filt = medfilt2(I_bin,[17 17]);
figure, imshow(I_filt), title('Imagen procesada con Filtro de Mediana');

%% ----- DEFINICIÓN DE UN ELEMENTO ESTRUCTURANTE(EE).
close all;

% -- Para definir el elemento se utiliza la instrucción 'strel'.
% -- Se genera un EE cuadrado de lado 35 píxeles.
EE_cuadrado = strel('square', 5); 

%% ----- APLICACIÓN DE OPERADORES MORFOLÓGICOS.

% -- Erosión.
I_erosion = imerode(I_filt, EE_cuadrado); 

% -- Dilatación.
I_dilate = imdilate(I_filt, EE_cuadrado); 

% -- Apertura.
I_apertura = imopen(I_filt, EE_cuadrado); 

% -- Cierre.
I_cierre = imclose(I_filt, EE_cuadrado); 

figure, 
subplot(2,2,1), imshow(I_erosion), title('Erosión')
subplot(2,2,2), imshow(I_dilate), title('Dilatación')
subplot(2,2,3), imshow(I_apertura), title('Apertura')
subplot(2,2,4), imshow(I_cierre), title('Cierre')

%% ----- IMAGEN RESULTANTE.

% -- Se utiliza el operador morfológico de "cierre" porque contiene más
% -- información del objeto principal.
% -- Se puede observar el contorno del objeto con total claridad.
Im_Res_Morf =I_cierre; 
figure, imshow(Im_Res_Morf), title('Imagen resultante (Imagen cierre)')

%% ----- NEGATIVO DE LA IMAGEN RESULTANTE.

Im_Res_Morf = 255 - I_cierre; 
figure, imshow(Im_Res_Morf), title('Negativo de la Imagen resultante')

%% ----- ELIMINACIÓN DE BORDES.

% -- En las esquinas de la imagen hay objetos de no interés
% -- por lo tanto se eliminan.
Im_Res_Morf2 = bwareaopen(Im_Res_Morf, 50);
figure, imshow(Im_Res_Morf2), title('Negativo de la Imagen resultante sin bordes')

%% ----- SEGMENTACIÓN DE IMAGEN BINARIA.
close all;

% -- Para realizar la segmentación binaria se utiliza la función 'bwlabel'.
% -- Utiliza vecindad a 8 (izquierda, derecha, arriba, abajo y diagonales).
IM_Seg = bwlabel(Im_Res_Morf2); 

%% ----- OBTENCIÓN DEL NÚMERO DE OBJETOS.

% -- Se obtiene el único objeto obtenido, el principal.
Num_objetos = max(IM_Seg(:))
figure, imshow(IM_Seg,[]), title('Obtención del objeto')

%% ----- EXTRACCIÓN DE CONTORNOS.

% -- Para la obtener el contorno del objeto se utiliza
% -- únicamente un EE cuadrado.
EE = strel('square', 10);

% -- Obtencion de los contornos por definición de la frontera.

% -- Segmento erosionado.
I_Seg_erode = imerode(IM_Seg, EE); 

% -- Segmento dilatado.
I_Seg_dilat = imdilate(IM_Seg, EE); 

% -- Calculo del Gradiente (Dilatación - Erosión).
I_contornos = I_Seg_dilat - I_Seg_erode;

figure, 
subplot(1,3,1), imshow(I_Seg_erode),title('Segmento Erosionado');
subplot(1,3,2), imshow(I_Seg_dilat),title('Segmento Dilatado');
subplot(1,3,3), imshow(I_contornos),title('Gradiente');

%% ----- CREACIÓN DEL CONTORNO ROJO E IMAGEN FINAL.
close all;

% -- Contorno rojo utlizando mapa de color.
Contorno = uint8(I_contornos);
maps = [0 0 0;255 0 0];
Contorno_R = ind2rgb(Contorno, maps);

% -- Se obtiene la imagen final superponiendo el contorno rojo 
% -- sobre Imagen Original.

I = imread('G20.jfif');
Img_Final = uint8(Contorno_R) + I; 

figure,imshow(Contorno_R),title('Contorno de la imagen');
figure,imshow(Img_Final),title('Imagen original con el contorno');



%% ----- PARTE CREATIVA ----- (OPCIÓN A - CON DILATACIÓN)
clear all, close all, clc;

%% ----- CONVERSIÓN DE IMAGEN ORIGINAL A ESCALA DE GRISES Y SU VISUALIZACIÓN.

Imagen = imread('G20.jfif');
I = rgb2gray(Imagen);

figure,
imshow(I),title('Imagen en escala de grises');

%% ----- VISUALIZACIÓN DE CADA COMPONENTE DEL MODELO RGB.

R = Imagen(:,:,1);
G = Imagen(:,:,2);
B = Imagen(:,:,3);

figure,
subplot(1,3,1), imshow(R), title('Componente R');
subplot(1,3,2), imshow(G), title('Componente G');
subplot(1,3,3), imshow(B), title('Componente B');

%% ----- OBTENCIÓN DE IMAGEN BINARIA DE UNA COMPONENTE Y SU NEGATIVO.
close all;

% -- Se convierte la Componente R a Binaria utilizando un umbral.
% -- Se utiliza Componente R porque aporta mayor información sobre el
% -- objeto.
R_bin= im2bw(R, 55/255);

% -- Se obtiene su negativo.
I_bin = 1 - R_bin; 

figure, 
subplot(2,1,1), imshow(R_bin), title('Imagen Binaria de la Componente R')
subplot(2,1,2), imshow(I_bin),title('Negativo de la Imagen Binaria');

%% ----- APLICACIÓN DE FILTRO ALTERNADO SECUENCIAL(ASF3) "open-close" CON UN EE.
close all;

% -- Sucesión de discos (apertura-cierre) utilizando un EE pequeño y a
% -- partir de él un EE cada vez mayor.

% -- EE RADIO 1.
EE1 = strel('disk',1);
I_open1 = imopen(I,EE1);
I_ASF1 = imclose(I_open1, EE1);

% -- EE RADIO 2.
EE2 = strel ('disk', 2);
I_open2 = imopen(I_ASF1,EE2);
I_ASF2 = imclose(I_open2, EE2);

% -- EE RADIO 3.
EE3 = strel ('disk', 3);
I_open3 = imopen(I_ASF2,EE3);
I_ASF3 = imclose(I_open3, EE3);

figure, 
subplot(1,3,1), imshow(I_ASF1), title('EE Radio 1');
subplot(1,3,2), imshow(I_ASF2), title('EE Radio 2');
subplot(1,3,3), imshow(I_ASF3), title('EE Radio 3');

%% ----- OBTENCIÓN DE LOS MARCADORES DEL OBJETO.

% -- Se obtendrán un Marcado Interno y un Marcador Externo que se
% -- combinarán para sacar la Imagen con los mínimos regionales.

% -- Para ello se realizan los siguientes pasos.

%% ----- 1º EROSIONAR EL NEGATIVO DE LA IMAGEN FILTRADA CON UN EE PLANO.
close all;

% -- Obtención del negativo de la Imagen de Filtrado Altenardo Secuencial
% -- (RADIO 1, RADIO 2 Y RADIO 3).
I_neg = imcomplement(I_ASF3);

% -- Erosión del negativo con un EE.
% -- Se utiliza un EE plano correspondiente a un disco de radio 9.
EE9 = strel('disk', 9);
I_marker = imerode(I_neg, EE9);

figure, 
subplot(2,1,1), imshow(I_neg), title('Negativo de ASF3')
subplot(2,1,2), imshow(I_marker), title('Erosión del negativo de ASF3')

%% ----- 2º RECONSTRUCCIÓN MORFOLÓGICA DEL NEGATIVO.
close all;

% -- Se reconstruye la imagen utilizando el marcador de erosión y el
% -- negativo de la imagen filtrada.
Reconstruct = imreconstruct(I_marker, I_neg);

% -- Se superpone el negativo de la Componente R creado anteriormente 
% -- y la reconstrución realizada.
% -- Se obtienen matrices enteras sin signo.
Rec_neg = uint8(I_bin*255) + Reconstruct;

% -- Se realiza el negativo de la superposición para obtener un fondo negro
% -- homogéneo.
I_rec = 255 - Rec_neg;

figure, 
subplot(2,1,1), imshow(Reconstruct), title('Reconstrucción Morfológica del negativo')
subplot(2,1,2), imshow(Rec_neg), title('Superposición de Reconstrucción y R Negativo ')

figure, imshow(I_rec), title('Imagen reconstruida')

%% ----- 3º OBTENCIÓN DEL MARCADOR INTERNO.
close all;

% -- Los pixeles de primer plano tienen que indicar los máximos regionales.
I_max_reg = imregionalmax(I_rec);

% -- Hay que eliminar grupos de pixeles con máximos que no interesan.
% -- En nuestra imagen no sería necesario ya que, al superponer el fondo negro, 
% -- sólo se encuentra un único objeto en primer plano.
% -- No existen máximos de no interés.
I_max_reg2 = imclearborder (I_max_reg);

% -- Se realiza una segmentacion binaria y se obtiene la característica
% -- del nivel mínimo de la imagen.
% -- Consideraremos 100 como el valor de intensidad umbral para determinar
% -- si el mínimo regional corresponde o no al interior del objeto.
I_max_reg3= I_max_reg2;
 cc = bwlabel(I_max_reg2);
 n_objetos = max(max(cc(:)));
 stats = regionprops(cc,I,'MinIntensity');
 for nob=1:n_objetos
     if stats(nob).MinIntensity >= 100
         [r,c] = find(cc == nob);
         I_max_reg3(r,c)=0;
     end
 end 
 
 figure, 
 subplot(2,1,1), imshow(I_max_reg2), title('Eliminación de supuestos máximos')
 subplot(2,1,2), imshow(I_max_reg3), title('Marcador interno')

%% ----- 4º OBTENCIÓN DEL MARCADOR EXTERNO. (OPCIÓN A - CON DILATACIÓN)
close all;

% -- Se realiza la dilatación de la imagen con un disco de radio 1,
% -- para aumentar el tamaño de los objetos que componen el marcador
% -- interno. Expandimos los punto de primer plano.
I_dilate = imdilate(I_max_reg3, strel('disk',2));

% -- Se realiza la transformación de distancia de la imagen binaria
% -- obtenida en la dilatación.
D = bwdist(I_dilate);

% -- Se aplica un Filtro Watershed sobre la función distancia 
% -- obtenida de la dilatación.
% -- Se segmentan las regiones contiguas de interés en objetos distintos,
% -- Creando fronteras entre mínimos regionales.
DL = watershed(D);
bgm = (DL == 0);

figure, 
subplot(1,2,1), imshow(I_dilate), title('Imagen binaria final')
subplot(1,2,2),imshow(imadd(255*uint8(bgm),I)), title('Imagen binaria final')

%% ----- COMBINACIÓN DE MARCADORES INTERNO Y EXTERNO.
close all;

% -- Se realiza la combinación mediante un operador lógico OR.
I_minimos = bgm | I_max_reg3;

figure, imshow(I_minimos), title('Minimos')

%% ----- OBTENCIÓN DE VARIABLE ASOCIADA A WATERSHED.
close all;

% -- Se aplica un filtro lineal Sobel, 
% -- utilizando las líneas horizontales y verticales(traspuesta)
% -- para poder obtener el módulo del gradiente.
H_Sobel = fspecial('Sobel');
I_horiz = imfilter(double(I), H_Sobel);
I_vert = imfilter(double(I), H_Sobel');

% -- El módulo del gradiente se realiza para obtener
% -- el realce de bordes del objeto.
I_grad = sqrt((I_horiz.^2) + (I_vert.^2));

figure, imshow(I_grad, []), title('Módulo del gradiente')

%% ----- SEGMENTACIÓN POR WATERSHED Y EXTRACCIÓN DE LÍNEAS.
close all;

% -- Se reducen los mínimos regionales para evitar la sobresegmentación.
% -- La función 'imimposemin' se encarga de imponer mínimos
% -- donde la imagen de marcador binario es distinto de cero.
I_grad_mrk = imimposemin (I_grad, I_minimos);

figure, imshow(I_grad_mrk), title('Imposición de mínimos')

% -- Se realiza de nuevo Watershed y se establece una frontera en el 0.
% -- Se han obtenido las regiones del objeto según su propiedad de
% -- intensidad.
L = watershed (I_grad_mrk);
L_frontera = (L == 0);

figure, imshow(L_frontera), title('Segmentación Watershed')

%% ----- SUPERPOSICIÓN DE IMAGEN SEGMENTADA CON IMAGEN ORIGINAL.
close all;

% -- Combinación de imagen original con la imagen segmentada
% -- por Watershed y escalada [0,255].
I_Superpuesta = imadd(I, uint8(255*L_frontera));

figure, imshow(I_Superpuesta), title('Superposición de imagenes')



%% ----- PARTE CREATIVA ----- (OPCIÓN B - SIN DILATACIÓN)
clear all, close all, clc;

%% ----- CONVERSIÓN DE IMAGEN ORIGINAL A ESCALA DE GRISES Y SU VISUALIZACIÓN.

Imagen = imread('G20.jfif');
I = rgb2gray(Imagen);

figure,
imshow(I),title('Imagen en escala de grises');

%% ----- VISUALIZACIÓN DE CADA COMPONENTE DEL MODELO RGB.

R = Imagen(:,:,1);
G = Imagen(:,:,2);
B = Imagen(:,:,3);

figure,
subplot(1,3,1), imshow(R), title('Componente R');
subplot(1,3,2), imshow(G), title('Componente G');
subplot(1,3,3), imshow(B), title('Componente B');

%% ----- OBTENCIÓN DE IMAGEN BINARIA DE UNA COMPONENTE Y SU NEGATIVO.
close all;

% -- Se convierte la Componente R a Binaria utilizando un umbral.
% -- Se utiliza Componente R porque aporta mayor información sobre el
% -- objeto.
R_bin= im2bw(R, 55/255);

% -- Se obtiene su negativo.
I_bin = 1 - R_bin; 

figure, 
subplot(2,1,1), imshow(R_bin), title('Imagen Binaria de la Componente R')
subplot(2,1,2), imshow(I_bin),title('Negativo de la Imagen Binaria');

%% ----- APLICACIÓN DE FILTRO ALTERNADO SECUENCIAL(ASF3) "open-close" CON UN EE.
close all;

% -- Sucesión de discos (apertura-cierre) utilizando un EE pequeño y a
% -- partir de él un EE cada vez mayor.

% -- EE RADIO 1.
EE1 = strel('disk',1);
I_open1 = imopen(I,EE1);
I_ASF1 = imclose(I_open1, EE1);

% -- EE RADIO 2.
EE2 = strel ('disk', 2);
I_open2 = imopen(I_ASF1,EE2);
I_ASF2 = imclose(I_open2, EE2);

% -- EE RADIO 3.
EE3 = strel ('disk', 3);
I_open3 = imopen(I_ASF2,EE3);
I_ASF3 = imclose(I_open3, EE3);

figure, 
subplot(1,3,1), imshow(I_ASF1), title('EE Radio 1');
subplot(1,3,2), imshow(I_ASF2), title('EE Radio 2');
subplot(1,3,3), imshow(I_ASF3), title('EE Radio 3');

%% ----- OBTENCIÓN DE LOS MARCADORES DEL OBJETO.

% -- Se obtendrán un Marcado Interno y un Marcador Externo que se
% -- combinarán para sacar la Imagen con los mínimos regionales.

% -- Para ello se realizan los siguientes pasos.

%% ----- 1º EROSIONAR EL NEGATIVO DE LA IMAGEN FILTRADA CON UN EE PLANO.
close all;

% -- Obtención del negativo de la Imagen de Filtrado Altenardo Secuencial
% -- (RADIO 1, RADIO 2 Y RADIO 3).
I_neg = imcomplement(I_ASF3);

% -- Erosión del negativo con un EE.
% -- Se utiliza un EE plano correspondiente a un disco de radio 9.
EE9 = strel('disk', 9);
I_marker = imerode(I_neg, EE9);

figure, 
subplot(2,1,1), imshow(I_neg), title('Negativo de ASF3')
subplot(2,1,2), imshow(I_marker), title('Erosión del negativo de ASF3')

%% ----- 2º RECONSTRUCCIÓN MORFOLÓGICA DEL NEGATIVO.
close all;

% -- Se reconstruye la imagen utilizando el marcador de erosión y el
% -- negativo de la imagen filtrada.
Reconstruct = imreconstruct(I_marker, I_neg);

% -- Se superpone el negativo de la Componente R creado anteriormente 
% -- y la reconstrución realizada.
% -- Se obtienen matrices enteras sin signo.
Rec_neg = uint8(I_bin*255) + Reconstruct;

% -- Se realiza el negativo de la superposición para obtener un fondo negro
% -- homogéneo.
I_rec = 255 - Rec_neg;

figure, 
subplot(2,1,1), imshow(Reconstruct), title('Reconstrucción Morfológica del negativo')
subplot(2,1,2), imshow(Rec_neg), title('Superposición de Reconstrucción y R Negativo ')

figure, imshow(I_rec), title('Imagen reconstruida')

%% ----- 3º OBTENCIÓN DEL MARCADOR INTERNO.
close all;

% -- Los pixeles de primer plano tienen que indicar los máximos regionales.
I_max_reg = imregionalmax(I_rec);

% -- Hay que eliminar grupos de pixeles con máximos que no interesan.
% -- En nuestra imagen no sería necesario ya que, al superponer el fondo negro, 
% -- sólo se encuentra un único objeto en primer plano.
% -- No existen máximos de no interés.
I_max_reg2 = imclearborder (I_max_reg);

% -- Se realiza una segmentacion binaria y se obtiene la característica
% -- del nivel mínimo de la imagen.
% -- Consideraremos 100 como el valor de intensidad umbral para determinar
% -- si el mínimo regional corresponde o no al interior del objeto.
I_max_reg3= I_max_reg2;
 cc = bwlabel(I_max_reg2);
 n_objetos = max(max(cc(:)));
 stats = regionprops(cc,I,'MinIntensity');
 for nob=1:n_objetos
     if stats(nob).MinIntensity >= 100
         [r,c] = find(cc == nob);
         I_max_reg3(r,c)=0;
     end
 end 
 
 figure, 
 subplot(2,1,1), imshow(I_max_reg2), title('Eliminación de supuestos máximos')
 subplot(2,1,2), imshow(I_max_reg3), title('Marcador interno')

%% ----- 4º OBTENCIÓN DEL MARCADOR EXTERNO. (OPCIÓN B - SIN DILATACIÓN)
close all;

% -- Se realiza la transformación de distancia del Marcado Interno.
D = bwdist(I_max_reg3);

% -- Se aplica un Filtro Watershed sobre la función distancia 
% -- Se segmentan las regiones contiguas de interés en objetos distintos,
% -- Creando fronteras entre mínimos regionales.
DL = watershed(D);
bgm = (DL == 0);

figure, imshow(imadd(255*uint8(bgm),I)), title('Imagen binaria final')

%% ----- COMBINACIÓN DE MARCADORES INTERNO Y EXTERNO.
close all;

% -- Se realiza la combinación mediante un operador lógico OR.
I_minimos = bgm | I_max_reg3;

figure, imshow(I_minimos), title('Minimos')

%% ----- OBTENCIÓN DE VARIABLE ASOCIADA A WATERSHED.
close all;

% -- Se aplica un filtro lineal Sobel, 
% -- utilizando las líneas horizontales y verticales(traspuesta)
% -- para poder obtener el módulo del gradiente.
H_Sobel = fspecial('Sobel');
I_horiz = imfilter(double(I), H_Sobel);
I_vert = imfilter(double(I), H_Sobel');

% -- El módulo del gradiente se realiza para obtener
% -- el realce de bordes del objeto.
I_grad = sqrt((I_horiz.^2) + (I_vert.^2));

figure, imshow(I_grad, []), title('Módulo del gradiente')

%% ----- SEGMENTACIÓN POR WATERSHED Y EXTRACCIÓN DE LÍNEAS.
close all;

% -- Se reducen los mínimos regionales para evitar la sobresegmentación.
% -- La función 'imimposemin' se encarga de imponer mínimos
% -- donde la imagen de marcador binario es distinto de cero.
I_grad_mrk = imimposemin (I_grad, I_minimos);

figure, imshow(I_grad_mrk), title('Imposición de mínimos')

% -- Se realiza de nuevo Watershed y se establece una frontera en el 0.
% -- Se han obtenido las regiones del objeto según su propiedad de
% -- intensidad.
L = watershed (I_grad_mrk);
L_frontera = (L == 0);

figure, imshow(L_frontera), title('Segmentación Watershed')

%% ----- SUPERPOSICIÓN DE IMAGEN SEGMENTADA CON IMAGEN ORIGINAL.
close all;

% -- Combinación de imagen original con la imagen segmentada
% -- por Watershed y escalada [0,255].
I_Superpuesta = imadd(I, uint8(255*L_frontera));

figure, imshow(I_Superpuesta), title('Superposición de imagenes')
