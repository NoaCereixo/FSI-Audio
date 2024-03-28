function [info] = detectar_tonales(nombrearchivo)
%La función escribirá por pantalla "verdadero" si la señal del archivo
%contiene componentes tonales o "falso" en caso contrario. Además,
%proporcionará información adicional sobre la señal a analizar que
%dependerá de la presencia o no de estos componentes tonales.
%Argumentos de entrada
%   nombrearchivo = nombre del archivo de audio que contiene la señal a
%   analizar (character vector).
%Argumentos de salida
%   info = información de la señal analizada (struct).

%Lectura y análisis del archivo de audio 
[audio,fs]=audioread(nombrearchivo);
audio=audio(:,1);
N=length(audio);
dur=N/fs;
info.fs=fs;
info.Muestras=N;
info.Duracion=dur;
fprintf("\n\n\nAnalisis de archivo: "+nombrearchivo);

%Representación de la amplitud y la magnitud de la señal
ver_espectro(audio,'hamming',2048,fs);

%Representación del espectograma de la señal
figure;
spectrogram(audio,hamming(2048),0,2048,fs,'yaxis')
title('Espectograma de la señal');

%Representación de la longitud de las ráfagas de energía
env=envelope(audio,80,'rms');
f=figure;
pulsewidth(env,fs);
title('Longitud de las Ráfagas de energía');
Raf=ans;

%Detección de componentes tonales
NRaf=0;
for i=1:length(Raf)
    if(Raf(i)>=dur/100)
        %consideraremos ráfaga de energía aquellas que sean, al menos, de
        %longitud una centésima parte de la duración de la señal
        NRaf=NRaf+1;
        LRaf(1,NRaf)=Raf(i);
    end
end
if(NRaf==0) %no tonales
    close(f);
    
    %Cálculo de la frecuencia fundamental
    t=0:1/fs:dur;
    aux=audio(t>=2e-3 & t<=10e-3);
    T0=max(cceps(aux)); %en ms
    f0=1000/T0; %en Hz
    info.FrecFundamental=f0;
    
    %Salida por pantalla
    fprintf("\n\n"+nombrearchivo+": Falso");
    varNames={'Fs','Muestras','Duracion','FrecFundamental'};
    ResultadoDelAnalisis=table(info.fs,info.Muestras,info.Duracion,info.FrecFundamental,'VariableNames',varNames)
    
else %tonales
    info.NumeroRafagas=NRaf;
    info.LongitudRafafas=LRaf;
    
    %Salida por pantalla
    fprintf("\n\n"+nombrearchivo+": Verdadero\n");
    varNames={'Fs','Muestras','Duracion','NumRafagas'};
    ResultadoDelAnalisis=table(info.fs,info.Muestras,info.Duracion,info.NumeroRafagas,'VariableNames',varNames)
end
end