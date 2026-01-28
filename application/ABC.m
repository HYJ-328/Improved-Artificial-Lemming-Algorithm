function [fitnessgbest, gbest, BestCost] = ABC(N, MaxIt, lb, ub, dim, fobj)

%% Problem definition
VarSize = [1, dim];

%% ABC parameters
nPop = N;                   % Bee colony size
nOnlooker = nPop;        % Number of onlooker bees
L = round(0.6*dim*nPop); % Limit parameter for exploration extremum
a = 1;                              % Upper limit of acceleration coefficient
X = initialization(N, dim, ub, lb);
%% Initialization
% Generate initial population
for i = 1:nPop
    fitness(i) = fobj(X(i, :));
end
[bestfitness, bestindex] = min(fitness);
gbest = X(bestindex, :);
fitnessgbest = bestfitness;
% Solution abandonment counter
C = zeros(nPop, 1);
% Array to save optimal function values
BestCost = zeros(MaxIt, 1);

%% ABC iteration
for it = 1:MaxIt
    % Employed bees phase
    for i = 1:nPop
        % Randomly select k not equal to i
        K = [1:i-1 i+1:nPop];
        k = K(randi([1 numel(K)]));
        % Define acceleration coefficient
        phi = a*unifrnd(-1, +1, VarSize);
        % New bee position
        newbee_X(i, :) = X(i, :)+phi.*(X(i, :)-X(k, :));
        % Boundary handling
        newbee_X(i, :) = max(newbee_X(i, :), lb);
        newbee_X(i, :) = min(newbee_X(i, :), ub);
        % New bee function value
        newbee_fitness(i) = fobj(newbee_X(i, :));
        % Comparison
        if newbee_fitness(i) <= fitness(i)
            X(i, :) = newbee_X(i, :);
            fitness(i) = newbee_fitness(i);
        else
            C(i) = C(i)+1;
        end
    end
    % Calculate fitness values and selection probabilities
    F = zeros(nPop, 1);
    MeanCost = mean(fitness);
    for i = 1:nPop
        % Convert function values to fitness
        if fitness(i) >= 0
            F(i) = 1/(1+fitness(i));
        else
            F(i) = 1+abs(fitness(i));
        end
    end
    P = F/sum(F);
    % Onlooker bees phase
    for m = 1:nOnlooker
        % Select food source
        i = RouletteWheelSelection(P);
        % Randomly select k not equal to i
        K = [1:i-1 i+1:nPop];
        k = K(randi([1 numel(K)]));
        % Define acceleration coefficient
        phi = a*unifrnd(-1, +1, VarSize);
        % New bee position
        newbee_X(i, :) = X(i, :)+phi.*(X(i, :)-X(k, :));
        % Boundary handling
        newbee_X(i, :) = max(newbee_X(i, :), lb);
        newbee_X(i, :) = min(newbee_X(i, :), ub);
        % New bee function value
        newbee_fitness(i) = fobj(newbee_X(i, :));
        % Comparison
        if newbee_fitness(i) <= fitness(i)
            X(i, :) = newbee_X(i, :);
            fitness(i) = newbee_fitness(i);
        else
            C(i) = C(i) + 1;
        end
    end
    % Scout bees phase
    for i = 1:nPop
        if C(i) >= L    % Exceed exploration extremum parameter
            maxPos = max(X(i, :));
            minPos = min(X(i, :));
            for j = 1:numel(X(i, :))
                X(i, j) = minPos+rand*(maxPos-minPos);
            end
            fitness(i) = fobj(X(i, :));
            C(i) = 0;
        end
    end
    % Update optimal solution per iteration
    for i = 1:nPop
        if fitness(i) <= fitnessgbest
            gbest = X(i, :);
            fitnessgbest = fitness(i);
        end
    end
    % Save optimal solution per iteration
    BestCost(it) = fitnessgbest;
end
end

function i = RouletteWheelSelection(P)
    r = rand;
    C = cumsum(P);
    i = find(r <= C, 1, 'first');
end