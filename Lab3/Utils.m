classdef Utils
    methods (Static)

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
                            grid(k,j) = Utils.GED_Classifier(means, [xVals(k), yVals(j)], variances); 
                    end
                end
                contour(xVals, yVals, grid, 3, 'k');
        end

        function class = GED_Classifier(means, point, variances)
            mean = [];
            dist = [];
            variance = [];
            numOfMeans = length(means(:, end));
            count = 0;
            for k=1:numOfMeans
                mean{k} = [means(k, 1), means(k, 2)];
                variance{k} = [variances(k+count,1) variances(k+count+1,2); variances(k+count+1, 1) variances(k+count+1, 2)];
                dist{k} = sqrt((point - cell2mat(mean(k)))*inv(variances(k))*(point - cell2mat(mean(k)))');
                count = count +1;
            end
            
            [~,class] = min([dist(1) dist(2) dist(3)]);
                
        end

        function [mu, sig] = learnParams(data, N)
            mu = (1/N)*sum(data);
            temp = [0 0; 0 0];
            for k=1:N
                temp = temp + (data(k,:) - mu)'*(data(k,:) - mu);
            end
            sig = (1/N).*temp;
        end

    end
end