function [info] = detectar_tonales(nombrearchivo)
%La funci�n escribir� por pantalla "verdadero" si la se�al del archivo
%contiene componentes tonales o "falso" en caso contrario. Adem�s,
%proporcionar� informaci�n adicional sobre la se�al a analizar que
%depender� de la presencia o no de estos componentes tonales.
%Argumentos de entrada
%   nombrearchivo = nombre del archivo de audio que contiene la se�al a
%   analizar (character vector).
%Argumentos de salida
%   info = informaci�n de la se�al analizada (struct).

%Lectura y an�lisis del archivo de audio 
[audio,fs]=audioread(nombrearchivo);
audio=audio(:,1);
N=length(audio);
dur=N/fs;
info.fs=fs;
info.Muestras=N;
info.Duracion=dur;
fprintf("\n\n\nAnalisis de archivo: "+nombrearchivo);

%Representaci�n de la amplitud y la magnitud de la se�al
ver_espectro(audio,'hamming',2048,fs);

%Representaci�n del espectograma de la se�al
figure;
spectrogram(audio,hamming(2048),0,2048,fs,'yaxis')
title('Espectograma de la se�al');

%Representaci�n de la longitud de las r�fagas de energ�a
env=envelope(audio,80,'rms');
f=figure;
pulsewidth(env,fs);
title('Longitud de las R�fagas de energ�a');
Raf=ans;

%Detecci�n de componentes tonales
NRaf=0;
for i=1:length(Raf)
    if(Raf(i)>=dur/100)
        %consideraremos r�faga de energ�a aquellas que sean, al menos, de
        %longitud una cent�sima parte de la duraci�n de la se�al
        NRaf=NRaf+1;
        LRaf(1,NRaf)=Raf(i);
    end
end
if(NRaf==0) %no tonales
    close(f);
    
    %C�lculo de la frecuencia fundamental
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