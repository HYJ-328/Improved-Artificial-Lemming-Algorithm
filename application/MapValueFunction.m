function Value = MapValueFunction(x,y)
%Terrain constants
a = 1; b = 1; c = 1; d = 1; e = 1; f = 1; g = 1;
z = sin(y + a)+b*sin(x)+c*cos(d*(y^2 + x^2))+e*cos(y) + ...
            f*sin(f*(y^2+x^2))+g*cos(y);
%Mountain peak model
%% Create mountain peak model
A = [60,60;
    100,100;
    150,150;]; % Mountain peak coordinates
h0 = 0; %Minimum height of mountain peaks
hi = [50;60;80]; %Heights of three mountain peaks
ai = [20;30;20]; %X-direction slopes of three mountain peaks
bi = [20;30;20]; %Y-direction slopes of three mountain peaks
h = sum(hi.*exp(-(x-A(:,1)).^2./ai.^2 - (y-A(:,2)).^2./bi.^2))+h0;
Value = max(z,h);

end