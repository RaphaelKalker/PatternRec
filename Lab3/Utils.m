classdef Utils
    methods (Static)

         function [grid, xVals, yVals] = CreateGrid(datapoints) 
                dx = 0.01; % step size
                maxY = max(datapoints(:, 2));
                maxX = max(datapoints(:, 1));
                minX = min(datapoints(:, 1));
                minY = min(datapoints(:, 2));
                xVals = [minX:dx:maxX];
                yVals = [minY:dx:maxY];

                grid = zeros(length(xVals),length(yVals));
        end

        function cont = GED_Contour(grid, xVals, yVals, means, datapoints, variances)
            for k=1:length(xVals)
                for j=1:length(yVals)
                    grid(k,j) = Utils.GED_Classifier(means, [xVals(k), yVals(j)], variances); 
                end
            end
            cont = grid;
            contour(xVals, yVals, grid, 10);
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
                dist = sqrt((point - cell2mat(mean(k)))*inv(variances(k))*(point - cell2mat(mean(k)))');
                count = count +1;
                if (k ==1)
                    distances = [dist];
                else
                    distances = [distances dist];
                end
            end
            
            [~,class] = min(distances);
                
        end
        
        function [mu, sig] = learnParams(data, N)
            mu = (1/N)*sum(data);
            temp = [0 0; 0 0];
            for k=1:N
                temp = temp + (data(k,:) - mu)'*(data(k,:) - mu);
            end
            sig = (1/N).*temp;
        end

        function confPoints = MICD_Check(means, testPts, variances)

            confPoints = zeros(10,10); 

            dists = [];

            for k=1:length(testPts(:,1))
                index = testPts(k, 3);
                class = Utils.GED_Classifier(means, [testPts(k,1) testPts(k,2)], variances );
                confPoints(index, class) = confPoints(index, class) + 1;
            end
        end

    end
end