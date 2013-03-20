classdef Utils
    methods(Static)
        
        function plotGuass(mu, sigma, dMu, dSigma)
            figure
            x = (mu - 4 * sigma) : (sigma / 100) : (mu + 4 * sigma);
            pdfEst = normpdf(x, mu, sigma);
            plot(x, pdfEst, 'r');
            hold on
            x = (dMu - 4 * dSigma) : (dSigma / 100) : (dMu + 4 * dSigma);
            pdfAct = normpdf(x, dMu, dSigma);
            plot(x, pdfAct, 'b');
        end

        function plotExp(lam, dLam)
            figure 
            x = 0:0.1:10;
            expEst = exppdf(x,lam);
            plot(x, expEst, 'b')
            hold on
            expAct = exppdf(x,dLam);
            plot(x, expAct, 'r')
        end
        
        function plotUniform(data)
            figure
            minOfData = min(data);
            maxofData = max(data);
            x = 0:0.1:10;
            y = unifpdf(x, minOfData, maxofData);
            plot(y, 'b');
        end
        
        function grid = CreateGrid(means, datapoints, variances) 
                dx = 5; % step size
                maxY = max(datapoints(:, 2));
                maxX = max(datapoints(:, 1));
                minX = min(datapoints(:, 1));
                minY = min(datapoints(:, 2));
                xVals = [minX:dx:maxX];
                yVals = [minY:dx:maxY];
                
                grid = zeros(length(xVals),length(yVals));
                
                for k=1:length(xVals)
                    for j=1:length(yVals)
                            grid(k,j) = Utils.ML_Classifier(means, [xVals(k), yVals(j)], variances); 
                    end
                end
                contour(xVals, yVals, grid, 3, 'k');
        end

        function class = ML_Classifier(means, point, variances)
            class = -1;
            mu = [];
            sig = [];
            numOfMeans = length(means(:, end));
            count = 0;
            for k=1:numOfMeans
                mu{k} = [means(k, 1) means(k, 2)];
                sig{k} = [variances(k+count,1) variances(k+count,2); variances(k+count+1, 1) variances(k+count+1, 2)];
                count = count + 1;
            end

            muA = cell2mat(mu(1)); muB = cell2mat(mu(2)); muC = cell2mat(mu(3));
            sigA = cell2mat(sig(1)); sigB = cell2mat(sig(2)); sigC = cell2mat(sig(3));

            guassA = 1/(sqrt(2*pi)^2*sqrt(det(sigA)))*exp(-0.5*(point - muA)*inv(sigA)*(point-muA)');
            guassB = 1/(sqrt(2*pi)^2*sqrt(det(sigB)))*exp(-0.5*(point - muB)*inv(sigB)*(point-muB)');
            guassC = 1/(sqrt(2*pi)^2*sqrt(det(sigC)))*exp(-0.5*(point - muC)*inv(sigC)*(point-muC)');

            [~,class] = max([guassA guassB guassC]);
        end

        function [mu, sig] = learnParams(data, N)
            mu = (1/N)*sum(data);
            temp = [0 0; 0 0];
            for k=1:N
                temp = temp + (data(k,:) - mu)'*(data(k,:) - mu);
            end
            sig = (1/N).*temp;
        end

        function class = Parzen_Classifier(point, probs)
            class = -1;
            pdfA = cell2mat(probs(1));
            pdfB = cell2mat(probs(2));
            pdfC = cell2mat(probs(3));

            probA = pdfA(point(1,1), point(1,2))
            probB = pdfB(point)
            probC = pdfC(point)

            [~, class] = max([probA probB probC]);
        end
    end
end