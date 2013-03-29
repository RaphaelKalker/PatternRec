
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
[grid, xVals, yVals] = Utils.CreateGrid(datapoints);
cont = Utils.GED_Contour(grid, xVals, yVals, means, datapoints, variances);
confPoints = Utils.MICD_Check(testMeans, testDatapoints, testVariances)





