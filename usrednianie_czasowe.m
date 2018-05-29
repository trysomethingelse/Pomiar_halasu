%generuj przebieg prostok�tny, a p�niej zastosuj u�rednianie czasowe
%skrypt testuj�cy u�rednianie czasowe
clear all;
allTime = 5; %czas okna obserwacji
time = 1.5;%czas trwania skoku jednostkowego
startTime = 2;
samples = 1000;
deltaTime = allTime/samples;

LOW = 0;
HIGH = 1;

signal = zeros(samples,1);

startSample = floor(startTime/deltaTime);
stopSample = floor((time+startTime)/deltaTime);

for sample = 1:samples
    if sample >= startSample && sample <= stopSample
        signal(sample) = HIGH;
    end 
end

timeAxis = deltaTime:deltaTime:allTime;
plot(timeAxis,signal);
axis([0,allTime,-0.1,HIGH+1]);