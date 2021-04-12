 %%%% Tarea 3: Segmentación %%%%

   % María Guadaño Nieto.
   % Beatriz Vicario Guerrero.
   
   
%% ----- PARTE OBLIGATORIA
clear all, close all, clc;

%% -- Lectura de la imagen original
I = imread('G20.jfif');
figure,imshow(I),title('Imagen original');


%% ----- Transformación de la imagen original (espacio RGB) al espacio Lab
% -- Cambio al espacio lab
% -- Se considera unicamente el espacio ab porque es la crominancia
[lab_imL, l_L, a_L, b_L] = rgb2lab(I);
[nrows,ncols,ndim] = size(I);
a_res = reshape(a_L,nrows*ncols,1);
b_res = reshape(b_L,nrows*ncols,1);

% -- Representación de las componentes con el scatter plot de los datos
% -- Para ello se utiliza la función 'plot3'
% -- 'plot3': Traza puntos como marcadores sin líneas
figure, plot(a_res, b_res,'.'), title('Espacio ab')
xlabel('a'), ylabel('b')
hold on;

% -- Normalizamos las dos componentes 
% -- Para que tenga media nula y desviación típica uno
ab_res = [a_res b_res];
ndim = size(ab_res,2);
ab_norm = ab_res;
for ind_dim=1:ndim
    datos = ab_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_norm(:,ind_dim) = datos_norm;
end 



%% -- Aplicación del algoritmo de agrupamiento k-medias
% -- K=2 porque hay 2 objetos.
% -- Utilizaremos para ello la función 'kmeans'
ngrupos = 2;
% -- El algoritmo kmeans devuelve la posición de los centroides (variable cluster_center)
% -- y una etiqueta identificativa del cluster al que pertenece cada punto de entrada 
% -- (variable cluster_idx).
[cluster_idx_norm cluster_center] = kmeans(ab_norm, ngrupos,'distance','sqEuclidean', 'Replicates', 10);
pixels_labels_ab_norm = reshape(cluster_idx_norm, nrows, ncols);


%% -- Segmentación de la imagen
I_seg = label2rgb(pixels_labels_ab_norm);
figure, imshow(I_seg), title('Imagen segmentada')

%% ----- Imagen  objeto y fondo

% -- Se obtiene una imagen con el objeto y otra con el fondo.
Imagen_bw_objeto = im2bw(rgb2gray(I_seg));

Imagen_bw_fondo = 1 - Imagen_bw_objeto;

figure, 
subplot(1,2,1),imshow(Imagen_bw_fondo), title('Fondo')
subplot(1,2,2),imshow(Imagen_bw_objeto), title('Objeto')

% -- Se crea una matriz vacia donde se va a guardar el fondo gris y el
% -- objeto
Imagen_vacia = uint8(zeros(size(I))); 
Imagen_fondo_gris = uint8(ones(nrows,ncols,3)*128);

for i=1:3
    Imagen_vacia(:,:,i) = I(:,:,i).*uint8(Imagen_bw_objeto) + Imagen_fondo_gris(:,:,i).*uint8(Imagen_bw_fondo);
end

figure,imshow(Imagen_vacia,[]), title('Objeto de la imagen original en fondo gris')


%% -- Desplazamiento de la imagen

% -- Primero se obtienen de las proyecciones horizontal y vertical para
% -- poder conocer donde está nuestro objeto y así desplazarlo 

Proyecciones = rgb2gray(Imagen_vacia);
Horizontal = zeros(nrows,1); Vertical = zeros(1,ncols);

for i=1:nrows
    Horizontal(i) = sum(Proyecciones(i,:));
end
for j=1:ncols
    Vertical(j) = sum(Proyecciones(:,j));
end

figure, plot(Horizontal), title('Horizontal'); % 91 - 602 = 511
figure, plot(Vertical), title('Vertical');     % 280 - 706 = 426

% -- Movemos el objeto a la esquina superior derecha
% -- Para ello, colocamos en el fondo gris la imagen vacia creada
% -- Y colocamos la imagen vacia en la esquina superior derecha

% -- Imagen_fondo_gris = uint8(ones(nrows,ncols,3)*128);

for i=1:3
    Imagen_fondo_gris(1:512,484:end,i) = Imagen_vacia(91:602,280:706,i);
end

figure, imshow(Imagen_fondo_gris,[]), title('Imagen pedida');









%% ----- PARTE CREATIVA
clear all, imtool close all, close all, clc;

% Leemos la imagen.
I = imread('G20.jfif');

% Convertimos la Imagen Original a Binaria.
I_U = im2bw(I, 110/255);

% Segmentaci�n binaria: Grupos conexos de pixeles.
[Seg_I_U, Nobjetos] = bwlabel(I_U);     

% Los pixeles conexos sacados de la segmentaci�n se dividen en regiones.
Props = regionprops(Seg_I_U,'Area');    
V_Area = [];                                % V_Area genera un vector vac�o.

for ind_obj = 1:Nobjetos;
    V_Area = [V_Area Props(ind_obj).Area];  % En la matriz vac�a V_Area se a�ade el �rea de la regi�n de cada objeto.
end

% Gr�fica que asocia cada objeto con su �rea/longitud.
% xlabel('Numero de Objeto'), ylabel('Tama�o');
figure, stem(V_Area), title('�rea de cada objeto segmentado');

% Observando la gr�fica, elegimos los objetos que queremos eliminar.
% Vector de NO inter�s.
V_No_Interes = [14 131 806];           

[n_filas, n_cols] = size(I_U);    

% Iteramos tanto en filas como en columnas.
% Si la suma del la segmentaci�n de los vectores de NO inter�s es >0 lo
% eliminamos de la Imagen.
for ind_nfila=1:n_filas
    for ind_ncol=1:n_cols
        if I_U(ind_nfila,ind_ncol)
            numero_et = Seg_I_U(ind_nfila,ind_ncol);        
            if sum(ismember(V_No_Interes,numero_et)) > 0   
                I_U(ind_nfila,ind_ncol) = 0;
            end
        end
     end
end

% Filtro de media para unir regiones.
 % Definici�n de la m�scara.
 H = 1/(4*4) * ones(4,4);                  
 I_U_Fmedia = imfilter(255*uint8(I_U),H);

% Visualizamos las tres fases.
figure,
subplot(1,3,1), imshow(Seg_I_U), title('Imagen Binaria Segmentada');
subplot(1,3,2), imshow(I_U), title('Imagen Binaria FINAL');
subplot(1,3,3), imshow(I_U_Fmedia), title('Imagen Filtrada');







