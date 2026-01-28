clear
clc
close all
addpath(genpath(pwd));

%% Parameter settings
number = 1;                                                   %  Selected optimization function, replace manually
dim = 30;                                                     %  Optional: 2, 10, 30, 50, 100
[lb,ub,dim,fobj]=Get_Functions_cec2017(number,dim);           % [lb,ub,D,y]: lower bound, upper bound, dimension, objective function expression
pop_size = 30;                                                %  Population size 
max_iter = 500;                                               %  Maximum iterations

%% Run algorithms
[IALA_Best_score,~,IALA_curve] = IALA(pop_size,max_iter,lb,ub,dim,fobj); % Improved Lemming Algorithm 
[ALA_Best_score,~,ALA_curve] = ALA(pop_size,max_iter,lb,ub,dim,fobj);    % Lemming Algorithm 
[RRTO_Best_score,~,RRTO_curve] = RRTO(pop_size,max_iter,lb,ub,dim,fobj); % RRT Optimization Algorithm 
[WAA_Best_score,~,WAA_curve] = WAA(pop_size,max_iter,lb,ub,dim,fobj);    % Weighted Average Algorithm 
[BKA_Best_score,~,BKA_curve] = BKA(pop_size,max_iter,lb,ub,dim,fobj);    % Black-winged Kite Algorithm 
[PSA_Best_score,~,PSA_curve] = PSA(pop_size,max_iter,lb,ub,dim,fobj);    % PID Search Algorithm 
[HBA_Best_score,~,HBA_curve] = HBA(pop_size,max_iter,lb,ub,dim,fobj);    % Honey Badger Algorithm 
[WOA_Best_score,~,WOA_curve] = WOA(pop_size,max_iter,lb,ub,dim,fobj);    % Whale Optimization Algorithm 

%% Display results
display(['IALA best value on function ' [num2str(number)], ': ', num2str(IALA_Best_score)]);
display(['ALA best value on function ' [num2str(number)], ': ', num2str(ALA_Best_score)]);
display(['RRTO best value on function ' [num2str(number)], ': ', num2str(RRTO_Best_score)]);
display(['WAA best value on function ' [num2str(number)], ': ', num2str(WAA_Best_score)]);
display(['BKA best value on function ' [num2str(number)], ': ', num2str(BKA_Best_score)]);
display(['PSA best value on function ' [num2str(number)], ': ', num2str(PSA_Best_score)]);
display(['HBA best value on function ' [num2str(number)], ': ', num2str(HBA_Best_score)]);
display(['WOA best value on function ' [num2str(number)], ': ', num2str(WOA_Best_score)]);

%% Plot figures
figure1 = figure('Color',[1 1 1]);
G1=subplot(1,2,1,'Parent',figure1);
func_plot2017(number,dim)
xlabel('x','FontName','Times New Roman','FontSize',12)
ylabel('y','FontName','Times New Roman','FontSize',12)
zlabel('z','FontName','Times New Roman','FontSize',12)
subplot(1,2,2)
G2=subplot(1,2,2,'Parent',figure1);
CNT=20;
k=round(linspace(1,max_iter,CNT));       % Randomly select CNT points

iter=1:1:max_iter;
    semilogy(iter(k),IALA_curve(k),'r-o','linewidth',1);
    hold on
    semilogy(iter(k),ALA_curve(k),'g-+','linewidth',1);
    hold on
    semilogy(iter(k),RRTO_curve(k),'m-*','linewidth',1);
    hold on
    semilogy(iter(k),WAA_curve(k),'y-p','linewidth',1);
    hold on
    semilogy(iter(k),BKA_curve(k),'c-d','linewidth',1);
    hold on
    semilogy(iter(k),PSA_curve(k),'k-s','linewidth',1);
    hold on    
    semilogy(iter(k),HBA_curve(k),'b-^','LineWidth',1); 
    hold on
    semilogy(iter(k),WOA_curve(k),'Color', [0.75, 0, 1],'Marker','h','LineStyle','-','LineWidth',1);
grid on;
title('Convergence Curve - F1')
xlabel('Iteration');
ylabel('Fitness Value');
box on
legend('IALA','ALA','RRTO','WAA','BKA','PSA','HBA','WOA','Location','best')
set(gcf,'color','w')
set (gcf,'position', [300,300,800,330])

rmpath(genpath(pwd))