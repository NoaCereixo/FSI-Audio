function ver_espectro(senal,ventana,Nfft,fs)

% Funcion para el calculo y representaci�n del espectro
%   ver_espectro(senal,ventana,Nfft,fs)
% Parametros de entrada:
%   senal = senal de la cual queremos ver el espectro
%   ventana = tipo de ventana a utilizar (sin solapamiento), posibilidades: 'rectangular', 'hamming', 'hanning'
%   Nfft = Numero de puntos de la fft, define tambien la longitud de la
%   ventana
%   fs = frecuencia de muestreo a utilizar para la representaci�n
% Parametros de salida:
%   Sin parametros de salida.
%   Se dibuja la se�al y su espectro en la ventana de figure que est� activa.


Nsenal=length(senal);  %Total de muestras de la se�al
Ts=1/fs;
t=0:Ts:Ts*(Nsenal - 1);
fss=[];

switch ventana
    case 'rectangular'
       window=rectwin(Nfft);
    case 'hanning'
       window=hanning(Nfft);
    case 'hamming'
        window=hamming(Nfft);
end

window=window/sum(window); %Normalizaci�n para que W(f=0)=1

%reordenamos el vector de datos en una matriz de 
columnas=ceil(Nsenal/Nfft);
totals=columnas*Nfft;
if totals > Nsenal 
       s0=[senal; zeros(totals-Nsenal,1)];
else
       s0=senal;
end
ss=reshape(s0,Nfft,columnas);

%enventanamos y calculamos la fft de cada columna de la matriz de datos
for indc=1:columnas
  wseg1=ss(:,indc).*window;  
  fss=[fss abs(fft(wseg1,Nfft))];  %normalizada la amplitud de la fft??
end

%nos quedamos con las frecuencias entre 0 y pi
nfss=fss(1:Nfft/2+1,:);

%calculamos la media
mfss=mean(nfss,2);
fHz=0:fs/Nfft:fs/2;

figure
subplot(211), plot(t,senal), xlabel('t (s)'), ylabel('amplitud'), axis tight;
subplot(212), plot(fHz,20*log10(mfss)), xlabel('f (Hz)'), ylabel('Magnitud (dB)'),axis([0 fs/2 -60 10]);
%subplot(212), semilogx(fHz,20*log10(mfss)), xlabel('f (Hz)'), ylabel('Magnitud (dB)'),axis([0 fs/2 -60 10]);
grid;
end
