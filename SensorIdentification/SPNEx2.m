%Part A
addpath /home/svarun/Documents/Eurecom/Project/SensorIdentification/
img = imread('Eurecom_202_picFG_040.jpg');
[SPN, ESPN, S] = SPNandESPNextractor(img);
spnw = waverec2(SPN, S, 'db8');
espnw = waverec2(ESPN, S, 'db8');
%figure, imshow(spnw);
%figure, imshow(espnw);
%We see that the second picture has a cleaner noise

load('Eurecom_999_rspnBG_001.mat', 'RSPN')

D = '/home/svarun/Documents/Eurecom/Project/SensorIdentification/Dataset/FG';
S = dir(fullfile(D, '*.jpg'));
hist1 = [];
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    imgB = imread(F);
    [x, E] = SPNandESPNextractor(imgB);
    corr = xcorr(E, RSPN, 0, 'coeff');
    hist1 = [hist1, corr];
    k
end 

D2 = '/home/svarun/Documents/Eurecom/Project/SensorIdentification/Dataset/OTHER';
S2 = dir(fullfile(D2, '*.jpg'));
hist2 = [];
for k = 1:numel(S2)
    F = fullfile(D2,S2(k).name);
    imgB = imread(F);
    [x, E] = SPNandESPNextractor(imgB);
    corr = xcorr(E, RSPN, 0, 'coeff');
    hist2 = [hist2, corr];
    k
end 

ax1 = subplot(1,2,1); % Left subplot
histfit(ax1,hist1,40)
title(ax1,'My pictures')

ax2 = subplot(1,2,2); % Right subplot
histfit(ax2,hist2,40)
title(ax2,'Unknown')

%unexpectedly, there is far more correlation between my pictures and the
%sensor pattern noise i calculated from the original sky pictures than
%there is between the same and pictures of unkown origin. Therefore, this
%method can cleary be used to calculate if a picture was indeed taken with
%a specific camera or not. 
