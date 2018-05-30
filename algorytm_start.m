clear all;
addpath('A-weighting_filter');
%wykresy
plotLaf = 0; %poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F
plotLaqt = 0; %r�wnowa�ny poziom d�wi�ku A


%-----------------START sta�e-------------
p0 = 2e-5; %ci�nienie odniesienia
F = 0.125; %stala czasowa fast
%----------------KONIEC sta�ych-------------


%[y,Fs] = audioread('applause.wav');
%[y,Fs] = audioread('muscle-car.wav');


%generuj sygna� wzorcowy
allTime = 1;
Fs = 48000;
y = zeros(Fs*allTime,1);
amplitude = 1; freq = 1e3;
for i = 1:allTime*Fs
    t = i * 1/Fs - 1/Fs;
    y(i) = amplitude * sin(freq*2*pi()*t);
end
%plot(y)

%koniec generacji sygna�u wzorcowego
time = length(y)/Fs;


%--------------------- START ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F
yA = filterA(y, Fs);
p = (yA.^2)/(p0^2);%sta�a u�atwiaj�ca dalsze obliczenia



%u�rednianie sygna�u dla sta�ej czasoej FAST:
nSamplesF = floor(F * Fs); %liczba pr�bek przypadaj�ca na sta�� czasow�, zaokr�glenie w d�

pAverage = p;
nF = floor(length(yA)/nSamplesF); % ilo�� oddzielnych u�rednionych warto�ci
pAverage = pAverage(1:nF*nSamplesF,1); %przyci�cie tabeli z pr�bkami do idealnej d�ugo�ci, by zmieni� kszta�t
pAverage = reshape(pAverage,nSamplesF,nF);
pAverage = mean(pAverage,1);

Lpa = 10 * log10(pAverage); %poziom ci�nienia akustycznego 

%u�ywane do wykre�lenia poziomu, powiela wyniki co sta�� czasow� F
yLaf = yA;
for i = 1:nF
    for k = 1:nSamplesF
       
       yLaf((i-1)*nSamplesF + k,1)= Lpa(1,i);
    end
end
yLaf = yLaf(1:nF*nSamplesF);

%--------------------- KONIEC ------ poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F



if (plotLaf)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yNew)
    %sound(y,Fs)%odtw�rz 
end

%--------------------------------------START r�wnowa�ny poziom d�wi�ku A
T = 1; %czas obserwacji
nSamplesT = floor(T * Fs); %ilo�� pr�bek przypadaj�ca na czas obserwacji, zaokr�glenie w d�
sampleTime = 1/Fs; %czas trwania jednej pr�bki
nT = floor(length(yA)/nSamplesT); % ilo�� odddzielnych sca�kowanych warto�ci

%ca�kowanie, dla ka�dego z przedzia��w:

Ea = 0; %warto�� ca�ki w wyznaczonym przedziale - ekspozycja a na d�wi�k
Laqt = zeros(nT,1);%poziom r�wnowa�ny

for i = 1:nT
    for k = 1:nSamplesT
        n = (i-1)*nSamplesT + k; %przetwarzana pr�bka
        if(n+1 > length(p)),continue;end %ochrona przed wyj�ciem za wektor
        Ea = Ea + sampleTime * p(n);
    end
    Laqt(i) = 10 * log10(1/T * Ea); %obliczanie poziomu r�wnowa�nego
    Ea = 0;
end
%u�ywane do wykre�lenia poziomu, powiela wyniki co sta�� czasow� T
yLaqt = yA;
for i = 1:nT
    for k = 1:nSamplesT  
       n = (i-1)*nSamplesT + k; %przetwarzana pr�bka
       if(n > length(yLaqt)), continue; end
       yLaqt(n,1)= Laqt(i);
    end
end
yLaqt = yLaqt(1:nT*nSamplesT);
if (plotLaqt)
    
    %plot(y(1:n*nSamples))
   % hold on
    plot(yLaqt)
    %sound(y,Fs)%odtw�rz 
end
%--------------------------------------KONIEC r�wnowa�ny poziom d�wi�ku A

%--------------------------------------START poziom A ekspozycji na d�wi�k


%--------------------------------------KONIEC poziom A ekspozycji na d�wi�k







%wy�wietl ca�o�� na 3 wykresach:
figure;
subplot(3,1,1);
plot(yLaf);
title('poziom d�wi�ku A u�redniony wed�ug charakterystyki czasowej F')
subplot(3,1,2);
plot(yLaqt);
string = ['r�wnowa�ny poziom d�wi�ku A dla T=', num2str(T)];
title(string);



