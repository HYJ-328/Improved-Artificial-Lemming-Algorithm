%%  Clear environment variables
clear
clc
close all

%%  Parameter settings
pop = 100;       % Number of points
dim = 2;         % Spatial dimension
lb = 0;          % Lower bound
ub = 100;        % Upper bound

%%  Hammersley sequence initialization
% Generate pop dim-dimensional Hammersley sequence points with indices from 0 to pop-1
H_points = hammersley_sequence(0, pop-1, dim, pop);
Hammersley_points = H_points' .* (ub - lb) + lb;

%%  Random initialization
% Generate pop dim-dimensional random points
Random_points = rand(pop, dim) .* (ub - lb) + lb;

%%  Plot subplots
figure;
subplot(1,2,1);
scatter(Hammersley_points(:,1), Hammersley_points(:,2), '.');
%%xlabel('(a) Hammersley sequence initialization');

subplot(1,2,2);
scatter(Random_points(:,1), Random_points(:,2), '.');
%%xlabel('(b) Random initialization');

set(gcf, 'Position', [300, 300, 800, 330]);
set(gcf, 'Color', 'w');


function r = hammersley_sequence(i1, i2, m, n)
    prime = [ ...
        2;   3;   5;   7;  11;  13;  17;  19;  23;  29; ...
       31;  37;  41;  43;  47;  53;  59;  61;  67;  71; ...
       73;  79;  83;  89;  97; 101; 103; 107; 109; 113; ...
      127; 131; 137; 139; 149; 151; 157; 163; 167; 173; ...
      179; 181; 191; 193; 197; 199; 211; 223; 227; 229; ...
      233; 239; 241; 251; 257; 263; 269; 271; 277; 281; ...
      283; 293; 307; 311; 313; 317; 331; 337; 347; 349; ...
      353; 359; 367; 373; 379; 383; 389; 397; 401; 409; ...
      419; 421; 431; 433; 439; 443; 449; 457; 461; 463; ...
      467; 479; 487; 491; 499; 503; 509; 521; 523; 541 ];
    
    % Determine the step direction of the loop by comparing i1 and i2
    if i1 <= i2
        step = 1;
    else
        step = -1;
    end
    
    % Calculate the number of points to generate
    L = abs(i2 - i1) + 1;
    % Initialize output matrix, each column stores a sequence point
    r = zeros(m, L);
    k = 0;
    
    % Loop over indices i from i1 to i2
    for i = i1:step:i2
        % Initialize auxiliary vector t (dimension m-1) for subsequent component calculation
        t(1:m-1,1) = i;
        % Initialize prime inverse value prime_inv for each component
        prime_inv = zeros(m-1, 1);
        for idx = 1:m-1
            prime_inv(idx) = 1.0 / prime(idx);
        end
        k = k + 1;
        % The first component uses uniform distribution, calculated as mod(i, n+1)/n
        r(1, k) = mod(i, n+1) / n;
        
        % For each subsequent component, calculate radical inverse value via modulo and division
        while any(t ~= 0)
            for j = 1:m-1
                % Calculate remainder of current component under prime(j)
                d = mod(t(j), prime(j));
                % Accumulate the remainder multiplied by current prime inverse to get value of j+1-th component
                r(j+1, k) = r(j+1, k) + d * prime_inv(j);
                % Update prime inverse for next iteration
                prime_inv(j) = prime_inv(j) / prime(j);
                % Update t(j) by floor division
                t(j) = floor(t(j) / prime(j));
            end
        end
    end
    return
end