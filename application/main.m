clear
clc
close all

%%  Create map
MapSizeX = 200 ; MapSizeY = 200;       % Map size: 200*200

x = 1:1:MapSizeX;
y = 1:1:MapSizeY;
for i = 1:MapSizeX
    for j = 1:MapSizeY
        Map(i,j) = MapValueFunction(i,j);
    end
end
global NodesNumber
global startPoint
global endPoint
global ThreatAreaPostion
global ThreatAreaRadius

%%  Plot threat areas
ThreatAreaPostion = [150,50; 50,150];  % Center coordinates of threat areas
ThreatAreaRadius = [30;20];            % Radii of threat areas

%%  Overlay threat areas on map
figure
mesh(Map);
hold on;
for i= 1:size(ThreatAreaRadius,1)
    [X,Y,Z] = cylinder(ThreatAreaRadius(i),50);
    X = X + ThreatAreaPostion(i,1);
    Y = Y + ThreatAreaPostion(i,2);
    Z(2,:) = Z(2,:) + 50;              % Height of threat areas
    mesh(X,Y,Z)
end

%%  Set start and end points
startPoint = [0,0,20];
endPoint = [200,200,20];
plot3(startPoint(1),startPoint(2),startPoint(3),'ro');
text(startPoint(1),startPoint(2),startPoint(3),'start')
plot3(endPoint(1),endPoint(2),endPoint(3),'r*');
text(endPoint(1),endPoint(2),endPoint(3),'end')
title('Map Information')
set(gcf,'color','w')
saveas(gcf, 'Map_Information', 'svg');

%%  Algorithm parameter settings
NodesNumber  = 3;                         % Number of intermediate nodes
dim          = 2 * NodesNumber;           % Dimension
SearchAgents = 30;                        % Population size
MaxIter      = 100;                       % Maximum iterations
% Variable bounds: e.g., x ¡Ê [20,180], y ¡Ê [0,50]
lb = [20.*ones(1,NodesNumber), 0.*ones(1,NodesNumber)];
ub = [180.*ones(1,NodesNumber),50.*ones(1,NodesNumber)];
% Objective function handle
fobj = @(x) fun(x, NodesNumber, startPoint, endPoint, ThreatAreaPostion, ThreatAreaRadius);

%%  Convergence statistics for multiple experiments
runs = 15;                                % Run 15 times (adjustable)
scoresIALA  = zeros(runs,1);
scoresALA = zeros(runs,1);
scoresDOA = zeros(runs,1);
scoresNRBO = zeros(runs,1);
scoresGRO = zeros(runs,1);
scoresABC = zeros(runs,1);

all_curveIALA = zeros(runs, MaxIter);
all_curveALA = zeros(runs, MaxIter);
all_curveDOA = zeros(runs, MaxIter);
all_curveNRBO = zeros(runs, MaxIter);
all_curveGRO = zeros(runs, MaxIter);
all_curveABC = zeros(runs, MaxIter);

%%  Run algorithms in loop
for i = 1:runs

    disp(['Running iteration ', num2str(i), '...']);
    %-------------- IALA --------------
    [bestIALA, bestPosIALA, curveIALA] = IALA(SearchAgents, MaxIter, lb, ub, dim, fobj);
    scoresIALA(i) = bestIALA;         % Improved Lemming Algorithm (IALA)
    all_curveIALA(i,:) = curveIALA;
    
    %-------------- ALA --------------
    [bestALA, bestPosALA, curveALA] = ALA(SearchAgents, MaxIter, lb, ub, dim, fobj);
    scoresALA(i) = bestALA;           % Lemming Algorithm (ALA)
    all_curveALA(i,:) = curveALA;

    %-------------- DOA --------------
    [bestDOA, bestPosDOA, curveDOA] = DOA(SearchAgents, MaxIter, lb, ub, dim, fobj);
    scoresDOA(i) = bestDOA;           % Dream Optimization Algorithm (2025)
    all_curveDOA(i,:) = curveDOA;

    %-------------- NRBO --------------
    [bestNRBO, bestPosNRBO, curveNRBO] = NRBO(SearchAgents, MaxIter, lb, ub, dim, fobj);
    scoresNRBO(i) = bestNRBO;         % Newton-Raphson Optimization (2024)
    all_curveNRBO(i,:) = curveNRBO;

    %-------------- GRO --------------
    [bestGRO, bestPosGRO, curveGRO] = GRO(SearchAgents, MaxIter, lb, ub, dim, fobj);
    scoresGRO(i) = bestGRO;           % Gold Rush Optimizer (2023)
    all_curveGRO(i,:) = curveGRO;

    %-------------- ABC --------------
    [bestABC, bestPosABC, curveABC] = ABC(SearchAgents, MaxIter, lb, ub, dim, fobj);
    scoresABC(i) = bestABC;           % Artificial Bee Colony (2005)
    all_curveABC(i,:) = curveABC;
end

mean_curveIALA = mean(all_curveIALA);
mean_curveALA = mean(all_curveALA);
mean_curveDOA = mean(all_curveDOA);
mean_curveNRBO = mean(all_curveNRBO);
mean_curveGRO = mean(all_curveGRO);
mean_curveABC = mean(all_curveABC);

%%  Plot paths
figure
mesh(Map,'HandleVisibility','off'); 
hold on;

for i= 1:size(ThreatAreaRadius,1)
    [X,Y,Z] = cylinder(ThreatAreaRadius(i),50);
    X = X + ThreatAreaPostion(i,1);
    Y = Y + ThreatAreaPostion(i,2);
    Z(2,:) = Z(2,:) + 50;
     % Ensure cylinder base is above z=0, otherwise part may be below
    if min(Z(1,:)) < 0
        Z(1,:) = max(0, Z(1,:)); % Lift parts below 0 to 0
    end
    mesh(X,Y,Z,'HandleVisibility','off')
end
plot3(startPoint(1),startPoint(2),startPoint(3),'ro','LineWidth',2,'HandleVisibility','off');
plot3(endPoint(1),endPoint(2),endPoint(3),'r*','LineWidth',2,'HandleVisibility','off');
text(startPoint(1),startPoint(2),startPoint(3),'start','HandleVisibility','off')
text(endPoint(1),endPoint(2),endPoint(3),'end','HandleVisibility','off')
title('Path Planning Results');
grid on
ylim([0, 200]); 
xlim([0, 200]); 

%%  Get interpolated trajectories
[IALAX_seq, IALAY_seq, IALAZ_seq, ~, ~, ~] = GetThePathLine(bestPosIALA, NodesNumber, startPoint, endPoint);
plot3(IALAX_seq, IALAY_seq, IALAZ_seq, 'r.-','LineWidth',2);
[ALAX_seq, ALAY_seq, ALAZ_seq, ~, ~, ~] = GetThePathLine(bestPosALA, NodesNumber, startPoint, endPoint);
plot3(ALAX_seq, ALAY_seq, ALAZ_seq, 'b.-','LineWidth',2);
[DOAX_seq, DOAY_seq, DOAZ_seq, ~, ~, ~] = GetThePathLine(bestPosDOA, NodesNumber, startPoint, endPoint);
plot3(DOAX_seq, DOAY_seq, DOAZ_seq, 'm.-','LineWidth',2);
[NRBOX_seq, NRBOY_seq, NRBOZ_seq, ~, ~, ~] = GetThePathLine(bestPosNRBO, NodesNumber, startPoint, endPoint);
plot3(NRBOX_seq, NRBOY_seq, NRBOZ_seq, 'c.-','LineWidth',2);
[GROX_seq, GROY_seq, GROZ_seq, ~, ~, ~] = GetThePathLine(bestPosGRO, NodesNumber, startPoint, endPoint);
plot3(GROX_seq, GROY_seq, GROZ_seq, 'g.-','LineWidth',2);
[ABCX_seq, ABCY_seq, ABCZ_seq, ~, ~, ~] = GetThePathLine(bestPosABC, NodesNumber, startPoint, endPoint);
plot3(ABCX_seq, ABCY_seq, ABCZ_seq, 'y.-','LineWidth',2);
legend('IALA','ALA','DOA','NRBO','GRO','ABC','Location','best')
view([45,45,90])
set(gcf,'color','w')
saveas(gcf, 'Planning_Results', 'png');

%%  Plot iteration curves (using average values)
figure
hold on
semilogy(mean_curveIALA, 'r', 'LineWidth', 1.5);
semilogy(mean_curveALA, 'b', 'LineWidth', 1.5);
semilogy(mean_curveDOA, 'm', 'LineWidth', 1.5);
semilogy(mean_curveNRBO, 'c', 'LineWidth', 1.5);
semilogy(mean_curveGRO, 'g', 'LineWidth', 1.5);
semilogy(mean_curveABC, 'y', 'LineWidth', 1.5);
legend('IALA','ALA','DOA','NRBO','GRO','ABC','Location','best')
title('Average Convergence Curve');
xlabel('Iteration');
ylabel('Fitness Value');
set(gcf,'color','w')
saveas(gcf, 'Convergence_Curve', 'png');

%%  Print statistical results
minIALA = min(scoresIALA);  meanIALA = mean(scoresIALA);  maxIALA = max(scoresIALA);  stdIALA = std(scoresIALA);
minALA = min(scoresALA);  meanALA = mean(scoresALA);  maxALA = max(scoresALA);  stdALA = std(scoresALA);
minDOA = min(scoresDOA);  meanDOA = mean(scoresDOA);  maxDOA = max(scoresDOA);  stdDOA = std(scoresDOA);
minNRBO = min(scoresNRBO);  meanNRBO = mean(scoresNRBO);  maxNRBO = max(scoresNRBO);  stdNRBO = std(scoresNRBO);
minGRO = min(scoresGRO);  meanGRO = mean(scoresGRO);  maxGRO = max(scoresGRO);  stdGRO = std(scoresGRO);
minABC = min(scoresABC);  meanABC = mean(scoresABC);  maxABC = max(scoresABC);  stdABC = std(scoresABC);
disp(['IALA: Best=' num2str(minIALA) ', Mean=' num2str(meanIALA) ', Worst=' num2str(maxIALA)  ', Std=' num2str(stdIALA)]);
disp(['ALA: Best=' num2str(minALA) ', Mean=' num2str(meanALA) ', Worst=' num2str(maxALA) ', Std=' num2str(stdALA)]);
disp(['DOA: Best=' num2str(minDOA) ', Mean=' num2str(meanDOA) ', Worst=' num2str(maxDOA) ', Std=' num2str(stdDOA)]);
disp(['NRBO: Best=' num2str(minNRBO) ', Mean=' num2str(meanNRBO) ', Worst=' num2str(maxNRBO) ', Std=' num2str(stdNRBO)]);
disp(['GRO: Best=' num2str(minGRO) ', Mean=' num2str(meanGRO) ', Worst=' num2str(maxGRO) ', Std=' num2str(stdGRO)]);
disp(['ABC: Best=' num2str(minABC) ', Mean=' num2str(meanABC) ', Worst=' num2str(maxABC) ', Std=' num2str(stdABC)]);