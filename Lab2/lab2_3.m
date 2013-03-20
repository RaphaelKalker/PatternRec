% Lab 2 Part 3 Model Estimation 2-D Case

clear all
close all

% INITIALIZATION
% ----------------------------------------
load('lab2_2.mat')

NA = length(al);
NB = length(bl);
NC = length(cl);

[muA, sigA] = Utils.learnParams(al, NA);
[muB, sigB] = Utils.learnParams(bl, NB);
[muC, sigC] = Utils.learnParams(cl, NC);

% figure
% scatter(al(:,1), al(:,2))
% hold on
% scatter(bl(:,1), bl(:,2))
% hold on 
% scatter(cl(:,1), cl(:,2))
% hold on

% % ----------------------------------------
% % ML Classifier for Parametric Estimation
% % ----------------------------------------
% datapoints = [al; bl; cl];
% means = [muA; muB; muC];
% variances = [sigA; sigB; sigC];
% gridML = Utils.CreateGrid(means, datapoints, variances)

% ----------------------------------------
% ML Classifier for Non Parametric Estimation using 2D Parzen
% ----------------------------------------
stDev = 20;
win = fspecial('gaussian', [25 25], stDev);
minX = min([min(al(1 ,:)) min(bl(1,:)) min(cl(1,:))])
maxX = max([max(al(1 ,:)) max(bl(1,:)) max(cl(1,:))])
minY = min([min(al(: ,1)) min(bl(:,1)) min(cl(:,1))])
maxY = max([max(al(: ,1)) max(bl(:,1)) max(cl(:,1))])

res = [5, minX - 5, minY-5, maxX+5, maxY+5];
[pdfA, xA, yA] = parzen(al,res,win);
[pdfB, xB, yB] = parzen(bl,res,win);
[pdfC, xC, yC] = parzen(cl,res,win);

grid = zeros(length(xA),length(yA));

dx = 5;
xVals = [minX:dx:maxX];
yVals = [minY:dx:maxY];

probs{1} = pdfA
probs{2} = pdfB
probs{3} = pdfC

for j=1:yA
	for k=1:A
		grid(j, k) = Utils.Parzen_Classifier([xVals(j), yVals(k)], probs);
	end
end
contour(xVals, yVals, grid, 3, 'k');
