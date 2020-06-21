
%%%% Pr�ctica 4: Segmentaci�n de Imagen (I) %%%%

%%  Histograma y umbralizaci�n.
clear all, close all, clc;

I = imread('calculadora.TIF');

imtool(I);
imhist(I);

I_U = im2bw(I, 230/255);
figure, imshow(I_U);

%% Segmentaci�n y caracterizaci�n de regiones.

[Seg_I_U, Nobjetos] = bwlabel(I_U);     % Segmentaci�n binaria: Grupos conexos de pixeles.
imtool(uint8(Seg_I_U));

RGB_Segment = label2rgb(Seg_I_U);       % Segmentaci�n RGB.
imtool(RGB_Segment);

Props = regionprops(Seg_I_U,'Area');    % �rea = n� de pixeles.
V_Area = [];                            % [] genera un vector vac�o.

for ind_obj = 1:Nobjetos;
    V_Area = [V_Area Props(ind_obj).Area];  % En la matriz vac�a V_Area a�ade el �rea de la regi�n de cada objeto.
end

figure, stem(V_Area), title('�rea de cada objeto segmentado');;
% xlabel('Numero de Objeto'), ylabel('Tama�o');

%% %% Procesado para identificaci�n de la tecla.

V_No_Interes = [3 10 56 61];           % Vector de NO inter�s.

% L�ne de comandos. >> ismember(V_No_Interes,numero_et)

% >> ismember(V_No_Interes,7)

    % 1�4 logical array
    % 0   0   0   0

% >> ismember(V_No_Interes,3)

    % 1�4 logical array
    % 1   0   0   0

[n_filas, n_cols] = size(I_U);  % De la imagen binaria.

for ind_nfila=1:n_filas
    for ind_ncol=1:n_cols
        if I_U(ind_nfila,ind_ncol)
            numero_et = Seg_I_U(ind_nfila,ind_ncol);        % En la parte de segmentaci�n cual es el n� etiqueta.
            if sum(ismember(V_No_Interes,numero_et)) > 0    % Matriz, 'numero_et' valor de la etiqueta.
                I_U(ind_nfila,ind_ncol) = 0;
            end
        end
     end
end

figure, imshow(I_U);

%% Filtro de media para unir regiones.

 % Definici�n de la m�scara.
 H = 1/(5*5) * ones(5,5);                   % M�scara 5*5. Modificar como nos convenga. 
 I_U_Fmedia = imfilter(255*uint8(I_U),H);
 
figure, 
subplot(1,2,1),imshow(I_U_Fmedia), title('Imagen filtrada');
subplot(1,2,2), mesh(double(I_U_Fmedia)), title('Malla Imagen filtrada');

%% Umbralizar la imagen

I_U_Fmedia_Th = im2bw(I_U_Fmedia,1/255); 
figure, imshow(I_U_Fmedia_Th)

%% Procesado para identificaci�n de la tecla �Enter�

[Segm_regs_teclas, Nteclas] = bwlabel(I_U_Fmedia); 

Props = regionprops(Segm_regs_teclas, 'Area');
V_Area = [];

for ind_obj=1:Nteclas
 V_Area = [V_Area Props(ind_obj).Area];
end

figure,stem(V_Area);
xlabel('Numero de tecla');
ylabel('Tama�o');

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
subplot(2,2,1), imshow(Seg_I_U,[]), title('Imagen Segmentaci�n');
subplot(2,2,2), imshow(RGB_Segment), title('Imagen Segmentaci�n RGB');
subplot(2,2,3), imshow(I_U_Fmedia_Th), title('Imagen Umbralizada');
subplot(2,2,4), imshow(I_U), title('Imagen tecla ENTER');

figure,
subplot(1,2,1), imhist(I), title('Histograma Imagen Original');
subplot(1,2,2), stem(V_Area), title('Gr�fica �rea de Objetos');






