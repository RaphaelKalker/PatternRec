% Lab 2 Part 3 Model Estimation 2-D Case

clear all
close all

% INITIALIZATION
% ----------------------------------------
load('lab2_2.mat')

NA = length(al);
NB = length(bl);
NC = length(cl);

[muA, sigA] = Utils.learnParams(al, NA)
[muB, sigB] = Utils.learnParams(bl, NB)
[muC, sigC] = Utils.learnParams(cl, NC)

figure
scatter(al(:,1), al(:,2))
hold on
scatter(bl(:,1), bl(:,2))
hold on 
scatter(cl(:,1), cl(:,2))
hold on
% ----------------------------------------
% ML Classifier for Parametric Estimation
% ----------------------------------------
datapoints = [al; bl; cl];
means = [muA; muB; muC];
variances = [sigA; sigB; sigC];
gridML = Utils.CreateGrid(means, datapoints, variances)