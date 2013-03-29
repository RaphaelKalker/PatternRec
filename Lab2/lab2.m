% Lab 2 Part 1 Model Estimation 1-D Case

clear all
close all

load('lab2_1.mat')

N = length(a);
dMu = 5;
dSigma = 1;

% Parameter Estimation Gaussian
% -----------------------------

mu = (1/N)*sum(a)
sigma = 0;
for i=1:N
	sigma = sigma + (a(i) - mu)^2;
end
sigma = (1/N)*sigma

Utils.plotEstGuass(mu, sigma);
hold on
Utils.plotActGuass(dMu, dSigma);

mu = (1/N)*sum(b)
sigma = 0;
for i=1:N
	sigma = sigma + (b(i) - mu)^2;
end
sigma = (1/N)*sigma

figure
Utils.plotEstGuass(mu, sigma);
hold on
Utils.plotActGuass(dMu, dSigma);

% Parameter Estimation Exponential
% --------------------------------
dLam = 1;
mu = (1/N)*sum(a);
lam = 1/mu

figure
Utils.plotActExp(dLam);
hold on
Utils.plotEstExp(lam);

mu = (1/N)*sum(b);
lam = 1/mu
figure
Utils.plotActExp(dLam);
hold on
Utils.plotEstExp(lam);

% Parameter Estimation Uniform
% ----------------------------
figure 
Utils.plotUniform(a);
hold on
Utils.plotActGuass(dMu, dSigma);
figure
Utils.plotUniform(b);
hold on
Utils.plotActExp(dLam)

% Non Parametric Estimation
% -------------------------
stDev1 = 0.1;
stDev2 = 0.4;
K = 0.1
xRange = 0:0.1:9.9;

h = K/sqrt(N);
parzen1 = [];
parzen2 = [];
parzen1b = [];
parzen2b = [];

for j=1:100
	sumVal1 = 0;
	sumVal2 = 0;
	sumVal1b = 0;
	sumVal2b = 0;
	for i=1:N
		sumVal1 = sumVal1 + ((1/h)*(1/(stDev1*sqrt(2*pi)))*exp(-1/(2*(stDev1^2))*(((j/10)-a(i))^2)));
		sumVal2 = sumVal2 + ((1/h)*(1/(stDev2*sqrt(2*pi)))*exp(-1/(2*(stDev2^2))*(((j/10)-a(i))^2)));
		sumVal1b = sumVal1b + ((1/h)*(1/(stDev1*sqrt(2*pi)))*exp(-1/(2*(stDev1^2))*(((j/10)-b(i))^2)));
		sumVal2b = sumVal2b + ((1/h)*(1/(stDev2*sqrt(2*pi)))*exp(-1/(2*(stDev2^2))*(((j/10)-b(i))^2)));
	end
	parzen1(j) = (1/N)*sumVal1/20;
	parzen2(j) = (1/N)*sumVal2/20;
	parzen1b(j) = (1/N)*sumVal1b/20;
	parzen2b(j) = (1/N)*sumVal2b/20;
end

figure
hold on
plot(xRange, parzen1);
hold on
plot(xRange, parzen2);

figure
plot(xRange, parzen1b);
hold on
plot(xRange, parzen2b);










