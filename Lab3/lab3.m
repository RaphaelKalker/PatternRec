
clear all 
close all

load feat.mat

feature = f32;
featureTest = f32t;
%-------------------------------------------------------------
% Part 3 - Labelled Classification
%-------------------------------------------------------------

% extract datapoints and learn class means and variances
for k=1:10
	count = 0;
	for j=(16*k-15):16*k
		if (feature(3,j) == k)
			if (count == 0)
				data = [feature(1, j) feature(2, j)];
				testData = [featureTest(1, j) featureTest(2, j), featureTest(3,j)];
			else
				data = [data; feature(1, j) feature(2, j)];
				testData = [testData; featureTest(1, j) featureTest(2, j), featureTest(3,j)];
			end
			count = 1;
		end
	end
	[mu, sig] = Utils.learnParams(data, 16);
	[testMu, testSig] = Utils.learnParams([testData(:, 1) testData(:,2)], 16);

	if (k == 1)
		means = mu;
		testMeans = testMu;
		variances = sig;
		testVariances = testSig;
		datapoints = [data];
		testDatapoints = [testData];
	else
		means = [means; mu];
		testMeans = [testMeans; testMu];
		variances = [variances; sig];
		testVariances = [testVariances; testSig];
		datapoints = [datapoints; data];
		testDatapoints = [testDatapoints; testData];
	end
	
end

% MICD Classifier
% [grid, xVals, yVals] = Utils.CreateGrid(datapoints);
% cont = Utils.GED_Contour(grid, xVals, yVals, means, datapoints, variances);
% confPoints = Utils.MICD_Check(testMeans, testDatapoints, testVariances)

%-------------------------------------------------------------
% Part 4 - Image Classification and Segmentation
%-------------------------------------------------------------
% matrix = multf8;
% cimage = zeros(length(matrix(:,1)), length(matrix(1,:)));
% for j=1:length(matrix(:,1))
% 	for k=1:length(matrix(1,:))
% 		cimage(j,k) = Utils.GED_Classifier(means, matrix(j,k), variances);
% 	end
% end

% figure
% imagesc(cimage)
% figure
% imagesc(multim)

%-------------------------------------------------------------
% Part 5 - Unsupervised Classification
%-------------------------------------------------------------
k = 10;
classPts = zeros(length(datapoints),1);
prototypes = zeros(10,3);
for m=1:k
	prototypes(m,:) = [datapoints(randi(length(datapoints), 1)), datapoints(randi(length(datapoints)), 2) 0];
end

tempProto = zeros(10,3)
newPrototypes = prototypes;
newMeans = zeros(10,3);
count = 0;
while (isequal(newPrototypes, tempProto) ~= 1 && count < 25)
	tempProto = newPrototypes
	for n=1:length(feature)
		dist = [];
		point = [datapoints(n,1) datapoints(n, 2)];
		for p=1:k
			eu = Utils.eucD(point, [newPrototypes(p,1) newPrototypes(p,2)]);
			dist = [dist eu(:)];
		end
		[~, class] = min(dist);
		newMeans(class, :) = [([newMeans(class,1) newMeans(class,2)]+ point) newMeans(class, 3) + 1];
	end
	newPrototypes = newMeans;
	for m=1:k
		N = newPrototypes(m, 3);
		newPrototypes(m,:) = [newPrototypes(m,1)/N newPrototypes(m,2)/N 0];
	end
	count = count + 1;
end

newPrototypes
figure
scatter(datapoints(:,1), datapoints(:,2), 'k')
hold on
scatter(newPrototypes(:,1), newPrototypes(:,2), 'b')







