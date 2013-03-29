
clear all 
close all

load feat.mat

feature = f2
temp = 0;

for k=1:10
	count = 0;
	for j=(16*k-15):16*k
		if (feature(3,j) == k)
			if (count == 0)
				data = [feature(1, j) feature(2, j)]
			else
				data = [data; feature(1, j) feature(2, j)]
			end
			count = 1;
		end
	end
	datapoints{k} = data;
end

for k=1:10
	[mu, sig] = Utils.learnParams(cell2mat(datapoints(k)), 16)
	if (k == 1)
		means = mu;
		variances = sig;
	else
		means = [means; mu];
		variances = [variances; sig];
	end
end