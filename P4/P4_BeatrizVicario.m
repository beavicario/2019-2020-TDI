
%%%% Práctica 4: Segmentación de Imagen (I) %%%%

%%  Histograma y umbralización.
clear all, close all, clc;

I = imread('calculadora.TIF');

imtool(I);
imhist(I);

I_U = im2bw(I, 230/255);
figure, imshow(I_U);

%% Segmentación y caracterización de regiones.

[Seg_I_U, Nobjetos] = bwlabel(I_U);     % Segmentación binaria: Grupos conexos de pixeles.
imtool(uint8(Seg_I_U));

RGB_Segment = label2rgb(Seg_I_U);       % Segmentación RGB.
imtool(RGB_Segment);

Props = regionprops(Seg_I_U,'Area');    % Área = nº de pixeles.
V_Area = [];                            % [] genera un vector vacío.

for ind_obj = 1:Nobjetos;
    V_Area = [V_Area Props(ind_obj).Area];  % En la matriz vacía V_Area añade el área de la región de cada objeto.
end

figure, stem(V_Area), title('Área de cada objeto segmentado');;
% xlabel('Numero de Objeto'), ylabel('Tamaño');

%% %% Procesado para identificación de la tecla.

V_No_Interes = [3 10 56 61];           % Vector de NO interés.

% Líne de comandos. >> ismember(V_No_Interes,numero_et)

% >> ismember(V_No_Interes,7)

    % 1×4 logical array
    % 0   0   0   0

% >> ismember(V_No_Interes,3)

    % 1×4 logical array
    % 1   0   0   0

[n_filas, n_cols] = size(I_U);  % De la imagen binaria.

for ind_nfila=1:n_filas
    for ind_ncol=1:n_cols
        if I_U(ind_nfila,ind_ncol)
            numero_et = Seg_I_U(ind_nfila,ind_ncol);        % En la parte de segmentación cual es el nº etiqueta.
            if sum(ismember(V_No_Interes,numero_et)) > 0    % Matriz, 'numero_et' valor de la etiqueta.
                I_U(ind_nfila,ind_ncol) = 0;
            end
        end
     end
end

figure, imshow(I_U);

%% Filtro de media para unir regiones.

 % Definición de la máscara.
 H = 1/(5*5) * ones(5,5);                   % Máscara 5*5. Modificar como nos convenga. 
 I_U_Fmedia = imfilter(255*uint8(I_U),H);
 
figure, 
subplot(1,2,1),imshow(I_U_Fmedia), title('Imagen filtrada');
subplot(1,2,2), mesh(double(I_U_Fmedia)), title('Malla Imagen filtrada');

%% Umbralizar la imagen

I_U_Fmedia_Th = im2bw(I_U_Fmedia,1/255); 
figure, imshow(I_U_Fmedia_Th)

%% Procesado para identificación de la tecla ‘Enter’

[Segm_regs_teclas, Nteclas] = bwlabel(I_U_Fmedia); 

Props = regionprops(Segm_regs_teclas, 'Area');
V_Area = [];

for ind_obj=1:Nteclas
 V_Area = [V_Area Props(ind_obj).Area];
end

figure,stem(V_Area);
xlabel('Numero de tecla');
ylabel('Tamaño');

imtool(Segm_regs_teclas);

Label_Interes = 5;             

[n_filas, n_cols] = size(I_U_Fmedia); 

for ind_nfila=1:n_filas
    for ind_ncol=1:n_cols
        if Segm_regs_teclas(ind_nfila,ind_ncol) ~= Label_Interes 
                I_U(ind_nfila,ind_ncol) = 0;
        end
    end
 end

figure, imshow(I_U);

%% REPRESENTACIONES
close all, imtool close all, clc;

figure, 
subplot(1,2,1),imshow(I_U_Fmedia), title('Imagen filtrada');
subplot(1,2,2), mesh(double(I_U_Fmedia)), title('Malla Imagen filtrada');


figure, 
subplot(2,2,1), imshow(Seg_I_U,[]), title('Imagen Segmentación');
subplot(2,2,2), imshow(RGB_Segment), title('Imagen Segmentación RGB');
subplot(2,2,3), imshow(I_U_Fmedia_Th), title('Imagen Umbralizada');
subplot(2,2,4), imshow(I_U), title('Imagen tecla ENTER');

figure,
subplot(1,2,1), imhist(I), title('Histograma Imagen Original');
subplot(1,2,2), stem(V_Area), title('Gráfica Área de Objetos');






