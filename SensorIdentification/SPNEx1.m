addpath /home/svarun/Documents/Eurecom/Project/SensorIdentification/Dataset/BG
D = '/home/svarun/Documents/Eurecom/Project/SensorIdentification/Dataset/BG';
S = dir(fullfile(D, '*.jpg'));
RSPN = 0
for k = 1:numel(S)
    F = fullfile(D,S(k).name);
    img = imread(F);
    SPN = SPNandESPNextractor(img);
    RSPN = RSPN + SPN
end
RSPN = RSPN / 50;
save('Eurecom_999_rspnBG_001.mat', RSPN);