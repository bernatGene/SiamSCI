function [SPN, ESPN, S] = SPNandESPNextractor(image)
w_s = 512; %window size

if size(image,1) < w_s
    image = imresize(image, [w_s NaN]);
end
if size(image,2) < w_s
    image = imresize(image, [NaN w_s]);
end

% selecting image center to extract a square of 512x512 pixels
img_center = [floor(size(image,1)/2),floor(size(image, 2)/2)];
win_size = [w_s, w_s];
crop_values = [img_center(1)-floor(win_size(1)/2) img_center(2)-floor(win_size(2)/2)];

square512 = image(crop_values(1)+1:crop_values(1)+win_size(1), crop_values(2)+1:crop_values(2)+win_size(2), :);

% Applying wavelet decomposition 
wname = 'db8';
[C,S] = wavedec2(square512,4,wname);

% Extract the level 1 coefficients.
%a1 = appcoef2(C,S,wname,1);
h1 = detcoef2('h',C,S,1);
v1 = detcoef2('v',C,S,1);
d1 = detcoef2('d',C,S,1);

% Extract the level 2 coefficients.
%a2 = appcoef2(C,S,wname,2);
h2 = detcoef2('h',C,S,2);
v2 = detcoef2('v',C,S,2);
d2 = detcoef2('d',C,S,2);

% Extract the level 3 coefficients.
%a3 = appcoef2(C,S,wname,3);
h3 = detcoef2('h',C,S,3);
v3 = detcoef2('v',C,S,3);
d3 = detcoef2('d',C,S,3);

% Extract the level 4 coefficients.
a4 = appcoef2(C,S,wname,4);
h4 = detcoef2('h',C,S,4);
v4 = detcoef2('v',C,S,4);
d4 = detcoef2('d',C,S,4);

% window sizes
W = [3 5 7 9];

sigma0=5;

[r1,c1,z1] = size(h1);
[r2,c2,z2] = size(h2);
[r3,c3,z3] = size(h3);
[r4,c4,z4] = size(h4);

h1new = zeros(r1,c1,z1,4);
v1new = zeros(r1,c1,z1,4);
d1new = zeros(r1,c1,z1,4);

h2new = zeros(r2,c2,z2,4);
v2new = zeros(r2,c2,z2,4);
d2new = zeros(r2,c2,z2,4);

h3new = zeros(r3,c3,z3,4);
v3new = zeros(r3,c3,z3,4);
d3new = zeros(r3,c3,z3,4);

h4new = zeros(r4,c4,z4,4);
v4new = zeros(r4,c4,z4,4);
d4new = zeros(r4,c4,z4,4);

for i=1 : 4
    center = floor((W(i)*W(i))/2);
    % function to be applied to each (sliding) window
    f = @(x) max(0, (1/W(i)^2) * ((sum(x.^2) - x(center)^2) - sigma0^2));
    
    h1new(:,:,1,i) = colfilt(h1(:,:,1),[W(i) W(i)],'sliding',f);
    v1new(:,:,1,i) = colfilt(v1(:,:,1),[W(i) W(i)],'sliding',f);
    d1new(:,:,1,i) = colfilt(d1(:,:,1),[W(i) W(i)],'sliding',f);
    
    h2new(:,:,1,i) = colfilt(h2(:,:,1),[W(i) W(i)],'sliding',f);
    v2new(:,:,1,i) = colfilt(v2(:,:,1),[W(i) W(i)],'sliding',f);
    d2new(:,:,1,i) = colfilt(d2(:,:,1),[W(i) W(i)],'sliding',f);
    
    h3new(:,:,1,i) = colfilt(h3(:,:,1),[W(i) W(i)],'sliding',f);
    v3new(:,:,1,i) = colfilt(v3(:,:,1),[W(i) W(i)],'sliding',f);
    d3new(:,:,1,i) = colfilt(d3(:,:,1),[W(i) W(i)],'sliding',f);
    
    h4new(:,:,1,i) = colfilt(h4(:,:,1),[W(i) W(i)],'sliding',f);
    v4new(:,:,1,i) = colfilt(v4(:,:,1),[W(i) W(i)],'sliding',f);
    d4new(:,:,1,i) = colfilt(d4(:,:,1),[W(i) W(i)],'sliding',f);
    
    h1new(:,:,2,i) = colfilt(h1(:,:,2),[W(i) W(i)],'sliding',f);
    v1new(:,:,2,i) = colfilt(v1(:,:,2),[W(i) W(i)],'sliding',f);
    d1new(:,:,2,i) = colfilt(d1(:,:,2),[W(i) W(i)],'sliding',f);
    
    h2new(:,:,2,i) = colfilt(h2(:,:,2),[W(i) W(i)],'sliding',f);
    v2new(:,:,2,i) = colfilt(v2(:,:,2),[W(i) W(i)],'sliding',f);
    d2new(:,:,2,i) = colfilt(d2(:,:,2),[W(i) W(i)],'sliding',f);
    
    h3new(:,:,2,i) = colfilt(h3(:,:,2),[W(i) W(i)],'sliding',f);
    v3new(:,:,2,i) = colfilt(v3(:,:,2),[W(i) W(i)],'sliding',f);
    d3new(:,:,2,i) = colfilt(d3(:,:,2),[W(i) W(i)],'sliding',f);
    
    h4new(:,:,2,i) = colfilt(h4(:,:,2),[W(i) W(i)],'sliding',f);
    v4new(:,:,2,i) = colfilt(v4(:,:,2),[W(i) W(i)],'sliding',f);
    d4new(:,:,2,i) = colfilt(d4(:,:,2),[W(i) W(i)],'sliding',f);
    
    h1new(:,:,3,i) = colfilt(h1(:,:,3),[W(i) W(i)],'sliding',f);
    v1new(:,:,3,i) = colfilt(v1(:,:,3),[W(i) W(i)],'sliding',f);
    d1new(:,:,3,i) = colfilt(d1(:,:,3),[W(i) W(i)],'sliding',f);
    
    h2new(:,:,3,i) = colfilt(h2(:,:,3),[W(i) W(i)],'sliding',f);
    v2new(:,:,3,i) = colfilt(v2(:,:,3),[W(i) W(i)],'sliding',f);
    d2new(:,:,3,i) = colfilt(d2(:,:,3),[W(i) W(i)],'sliding',f);
    
    h3new(:,:,3,i) = colfilt(h3(:,:,3),[W(i) W(i)],'sliding',f);
    v3new(:,:,3,i) = colfilt(v3(:,:,3),[W(i) W(i)],'sliding',f);
    d3new(:,:,3,i) = colfilt(d3(:,:,3),[W(i) W(i)],'sliding',f);
    
    h4new(:,:,3,i) = colfilt(h4(:,:,3),[W(i) W(i)],'sliding',f);
    v4new(:,:,3,i) = colfilt(v4(:,:,3),[W(i) W(i)],'sliding',f);
    d4new(:,:,3,i) = colfilt(d4(:,:,3),[W(i) W(i)],'sliding',f);
end

% selecting minimum variance
finalVar_h1 = min(h1new,[], 4);
finalVar_v1 = min(v1new,[], 4);
finalVar_d1 = min(d1new,[], 4);

finalVar_h2 = min(h2new,[], 4);
finalVar_v2 = min(v2new,[], 4);
finalVar_d2 = min(d2new,[], 4);

finalVar_h3 = min(h3new,[], 4);
finalVar_v3 = min(v3new,[], 4);
finalVar_d3 = min(d3new,[], 4);

finalVar_h4 = min(h4new,[], 4);
finalVar_v4 = min(v4new,[], 4);
finalVar_d4 = min(d4new,[], 4);

% obtaining denoised components
h1den = h1.*(finalVar_h1./(finalVar_h1+sigma0^2));
v1den = v1.*(finalVar_v1./(finalVar_v1+sigma0^2));
d1den = d1.*(finalVar_d1./(finalVar_d1+sigma0^2));

h2den = h2.*(finalVar_h2./(finalVar_h2+sigma0^2));
v2den = v2.*(finalVar_v2./(finalVar_v2+sigma0^2));
d2den = d2.*(finalVar_d2./(finalVar_d2+sigma0^2));

h3den = h3.*(finalVar_h3./(finalVar_h3+sigma0^2));
v3den = v3.*(finalVar_v3./(finalVar_v3+sigma0^2));
d3den = d3.*(finalVar_d3./(finalVar_d3+sigma0^2));

h4den = h4.*(finalVar_h4./(finalVar_h4+sigma0^2));
v4den = v4.*(finalVar_v4./(finalVar_v4+sigma0^2));
d4den = d4.*(finalVar_d4./(finalVar_d4+sigma0^2));

% rebuilding the wavelet decomposition vector
C1 = [a4(:)', h4den(:)', v4den(:)', d4den(:)', h3den(:)', v3den(:)', d3den(:)', h2den(:)', v2den(:)', d2den(:)', h1den(:)', v1den(:)', d1den(:)'];

% extracting sensor pattern noise
SPN = C-C1;

%%% Enhancement
alpha = 7;
ESPN = zeros(size(SPN));


%% model 4 %%
%LT0 = find(SPN<0 & SPN>=-alpha);
%MT0 = find(SPN>=0 & SPN<=alpha);
%ESPN(MT0) = 1-SPN(MT0)/alpha;
%ESPN(LT0) = -1-SPN(LT0)/alpha;

%% model 5 %%
LT0 = find(SPN<0);
MT0 = find(SPN>=0);
ESPN(MT0) = exp(((-0.5).*ESPN(MT0).^2)/alpha^2);
ESPN(LT0) = -exp(((-0.5).*ESPN(LT0).^2)/alpha^2);