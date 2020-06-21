
%%%% Práctica 3: Filtrado de imágenes en el dominio espectral %%%%

%% Representación de la imagen en el dominio transformado.
clear all, close all, clc

Triangulo = imread('triangulo.bmp');
X = Triangulo;

X_FFT = fftshift(fft2(double(X),256,256));

FFT_modulo = abs(X_FFT);
FFT_fase = angle(X_FFT);

figure,
subplot(2,3,1),imshow(X),title('Imagen Original')
subplot(2,3,2),imshow(FFT_modulo, []),title('Módulo FFT Imagen Original')
subplot(2,3,3),imshow(FFT_fase, []),title('Fase FFT Imagen Original') 
subplot(2,3,4),mesh(X)
subplot(2,3,5),mesh(FFT_modulo)
subplot(2,3,6),mesh(FFT_fase)

Continua_X = max(FFT_modulo(:));     %Valor de la Delta (Componente Continua).

%% Propiedades de la Transformada de Fourier.
clear all, close all, clc

TrianguloDesp = imread('triangulodesp.bmp');
TrianguloZoom = imread('triangulozoom.bmp');
TrianguloGirado = imread('triangulogirado.bmp');

X_TrianguloDesp = TrianguloDesp;
X_TrianguloZoom = TrianguloZoom;
X_TrianguloGirado = TrianguloGirado;

X_TrianguloDesp_FFT = fftshift(fft2(double(X_TrianguloDesp),256,256));
X_TrianguloDesp_FFT_modulo = abs(X_TrianguloDesp_FFT);
X_TrianguloDesp_FFT_fase = angle(X_TrianguloDesp_FFT);

X_TrianguloZoom_FFT = fftshift(fft2(double(X_TrianguloZoom),256,256));
X_TrianguloZoom_FFT_modulo = abs(X_TrianguloZoom_FFT);
X_TrianguloZoom_FFT_fase = angle(X_TrianguloZoom_FFT);

X_TrianguloGirado_FFT = fftshift(fft2(double(X_TrianguloGirado),256,256));
X_TrianguloGirado_FFT_modulo = abs(X_TrianguloGirado_FFT);
X_TrianguloGirado_FFT_fase = angle(X_TrianguloGirado_FFT);

figure,
subplot(2,3,1),imshow(X_TrianguloDesp),title('Imagen Original Desplazada')
subplot(2,3,2),imshow(X_TrianguloDesp_FFT_modulo, []),title('Módulo FFT Imagen Original Desplazada')
subplot(2,3,3),imshow(X_TrianguloDesp_FFT_fase, []),title('Fase FFT Imagen Original Desplazada')
subplot(2,3,4),mesh(X_TrianguloDesp)
subplot(2,3,5),mesh(X_TrianguloDesp_FFT_modulo)
subplot(2,3,6),mesh(X_TrianguloDesp_FFT_fase)

figure,
subplot(2,3,1),imshow(X_TrianguloZoom),title('Imagen Original Zoom')
subplot(2,3,2),imshow(X_TrianguloZoom_FFT_modulo, []),title('Módulo FFT Imagen Original Zoom')
subplot(2,3,3),imshow(X_TrianguloZoom_FFT_fase, []),title('Fase FFT Imagen Original Zoom') 
subplot(2,3,4),mesh(X_TrianguloZoom)
subplot(2,3,5),mesh(X_TrianguloZoom_FFT_modulo)
subplot(2,3,6),mesh(X_TrianguloZoom_FFT_fase)

figure,
subplot(2,3,1),imshow(X_TrianguloGirado),title('Imagen Original Girado')
subplot(2,3,2),imshow(X_TrianguloGirado_FFT_modulo, []),title('Módulo FFT Imagen Original Girado')
subplot(2,3,3),imshow(X_TrianguloGirado_FFT_fase, []),title('Fase FFT Imagen Original Girado') 
subplot(2,3,4),mesh(X_TrianguloGirado_FFT_modulo)
subplot(2,3,5),mesh(X_TrianguloGirado_FFT_modulo)
subplot(2,3,6),mesh(X_TrianguloGirado_FFT_fase) 

%% Filtrado Paso Bajo en el dominio frecuencial.
clear all, close all, clc

Triangulo = imread('triangulo.bmp');

% FPB ideal D0 = 10.
F_Ideal_I10 = fft2(double(Triangulo));
H_Ideal_I10 = lpfilter('ideal', 256, 256, 10);
FPB_freq_I10 = H_Ideal_I10.*F_Ideal_I10;
FPB_espacio_I10 = real(ifft2(FPB_freq_I10));

% FPB ideal D0 = 30.
F_Ideal_30 = fft2(double(Triangulo));
H_Ideal_30 = lpfilter('ideal', 256, 256, 30);
FPB_freq_I30 = H_Ideal_30.*F_Ideal_30;
FPB_espacio_I30 = real(ifft2(FPB_freq_I30));

% FPB ideal D0 = 50.
F_Ideal_50 = fft2(double(Triangulo));
H_Ideal_50 = lpfilter('ideal', 256, 256, 50);
FPB_freq_I50 = H_Ideal_50.*F_Ideal_50;
FPB_espacio_I50 = real(ifft2(FPB_freq_I50));

figure, 
subplot(2,3,1), imshow(FPB_espacio_I10, []), title('Imagen Filtro Ideal D0 = 10')
subplot(2,3,2), imshow(FPB_espacio_I30, []), title('Imagen Filtro Ideal D0 = 30')
subplot(2,3,3), imshow(FPB_espacio_I50, []), title('Imagen Filtro Ideal D0 = 50')
subplot(2,3,4),mesh(FPB_espacio_I10)
subplot(2,3,5),mesh(FPB_espacio_I30)
subplot(2,3,6),mesh(FPB_espacio_I50)

% FPB gaussiano D0 = 10.
F_Gaussiano_10 = fft2(double(Triangulo));
H_Gaussiano_10 = lpfilter('gaussian', 256, 256, 10);
FPB_freq_G10 = H_Gaussiano_10.*F_Gaussiano_10;
FPB_espacio_G10 = real(ifft2(FPB_freq_G10));

% FPB gaussiano D0 = 30.
F_Gaussiano_30 = fft2(double(Triangulo));
H_Gaussiano_30 = lpfilter('gaussian', 256, 256, 30);
FPB_freq_G30 = H_Gaussiano_30.*F_Gaussiano_30;
FPB_espacio_G30 = real(ifft2(FPB_freq_G30));

% FPB gaussiano D0 = 50.
F_Gaussiano_50 = fft2(double(Triangulo));
H_Gaussiano_50 = lpfilter('gaussian', 256, 256, 50);
FPB_freq_G50 = H_Gaussiano_50.*F_Gaussiano_50;
Fpb_espacio_G50 = real(ifft2(FPB_freq_G50));

figure, 
subplot(2,3,1), imshow(FPB_espacio_G10, []), title('Imagen Filtro Gaussiano D0 = 10')
subplot(2,3,2), imshow(FPB_espacio_G30, []), title('Imagen Filtro Gaussiano D0 = 30')
subplot(2,3,3), imshow(Fpb_espacio_G50, []), title('Imagen Filtro Gaussiano D0 = 50')
subplot(2,3,4),mesh(FPB_espacio_G10)
subplot(2,3,5),mesh(FPB_espacio_G30)
subplot(2,3,6),mesh(Fpb_espacio_G50)

%% Filtrado Paso Alto en el dominio frecuencial.
clear all, close all, clc

Triangulo = imread('triangulo.bmp');

% FPA Ideal D0 = 100.
F_Ideal = fft2(double(Triangulo));
H_Ideal = lpfilter('ideal', 256, 256, 100);
FPA_Ideal = (1 - H_Ideal);
FPA_freq_I = FPA_Ideal.*F_Ideal;
FPA_espacio_I = real(ifft2(FPA_freq_I));

% FPA Gaussiano D0 = 100.
F_Gaussiano = fft2(double(Triangulo));
H_Gaussiano = lpfilter('gaussian', 256, 256, 100);
FPA_Gaussiano = (1 - H_Gaussiano);
FPA_freq_G = FPA_Gaussiano.*F_Gaussiano;
FPA_espacio_G = real(ifft2(FPA_freq_G));

figure, 
subplot(2,2,1), imshow(FPA_Ideal, []), title('Filtro Ideal D0 = 100')
subplot(2,2,2), imshow(FPA_espacio_I, []), title('Imagen Filtro Ideal D0 = 100')
subplot(2,2,3),mesh(FPA_Ideal)
subplot(2,2,4),mesh(FPA_espacio_I)

figure,
subplot(2,2,1), imshow(FPA_Gaussiano, []), title('Filtro Gaussiano D0 = 100')
subplot(2,2,2), imshow(FPA_espacio_G, []), title('Imagen Filtro Gaussiano D0 = 100')
subplot(2,2,3),mesh(FPA_Gaussiano)
subplot(2,2,4),mesh(FPA_espacio_G)

% PTE FPA con transiciones suaves en la banda de paso.
% PTE Umbralizar.
