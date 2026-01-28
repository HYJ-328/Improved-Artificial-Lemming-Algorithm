clear
clc
close all
addpath(genpath(pwd));

%% parameters setting
pop_size = 30;                        
max_iter = 500;                       
run = 50;                             
box_pp = 1;                           %  If 1, plot box plot; otherwise, skip.
RESULT = [];                          %  Store std, mean, best value and other results
rank_sum_RESULT = [];                 %  Store rank sum test results

F = [1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];   %  The second function is removed
variables_no = 30;                    %  Dimensions: 2, 10, 30, 50, 100
disp(['Statistics for CEC2017 benchmark functions with ',num2str(variables_no),' dimensions'])

if box_pp ==1
    figure('Name', 'Box Plot', 'Color', 'w','Position', [50 50 1400 700])
end

for func_num = 1:length(F)    %29 functions in CEC2017
    disp(['Calculation results for F',num2str(F(func_num)),' function：'])
    num=F(func_num);
    [lb,ub,variables_no,fhd] = Get_Functions_cec2017(num,variables_no);
    resu = [];                        %  Store std, mean, best value and other results
    rank_sum_resu = [];               %  Store rank sum test results
    box_plot = [];                    %  Store box plot data

    %% Run IALA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = IALA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z1(nrun) =  final;
    end
    box_plot = [box_plot;final_main];
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    disp(['IALA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run ALA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = ALA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['ALA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run RRTO algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = RRTO(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['RRTO：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run WAA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = WAA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['WAA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run BKA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = BKA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['BKA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run PSA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = PSA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['PSA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run HBA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = HBA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['HBA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    %% Run WOA algorithm
    time_main = zeros(1,run); % Initialize runtime array
    for nrun=1:run
        tic; % Start timing
        [final,position,iter] = WOA(pop_size,max_iter,lb,ub,variables_no,fhd);
        time_main(nrun) = toc; % Record runtime
        final_main(nrun)=final;
        z2(nrun) =  final;
    end
    box_plot = [box_plot;final_main]; %Collect box plot data
    avg_time = mean(time_main); % Calculate average runtime
    zz = [min(final_main);std(final_main);mean(final_main);median(final_main);max(final_main);avg_time];
    resu = [resu,zz];
    rs = ranksum(z1,z2);
    if isnan(rs)  
        rs=1;
    end
    rank_sum_resu = [rank_sum_resu,rs]; %Collect rank sum test results
    disp(['WOA：Best:',num2str(zz(1)),' Std:',num2str(zz(2)),' Mean:',num2str(zz(3)),' Median:',num2str(zz(4)),' Worst:',num2str(zz(5)),...
          ' Avg Time:',num2str(zz(6))]);

    rank_sum_RESULT = [rank_sum_RESULT;rank_sum_resu];   %  Collect rank sum test results
    RESULT = [RESULT;resu];                              %  Collect std, mean, best value and other results

    %% Plot box plot
    if box_pp == 1 
        subplot(5,6,func_num)  %5 rows, 6 columns
        mycolor = [0.862745098039216,0.827450980392157,0.117647058823529;...
        0.705882352941177,0.266666666666667,0.423529411764706;...
        0.949019607843137,0.650980392156863,0.121568627450980;...
        0.956862745098039,0.572549019607843,0.474509803921569;...
        0.231372549019608,0.490196078431373,0.717647058823529];  %Color library
        %% Start plotting
        %Parameters: data matrix, color setting, marker
        box_figure = boxplot(box_plot','color',[0 0 0],'Symbol','-');
        %Set line width
        set(box_figure,'Linewidth',1.2);
        boxobj = findobj(gca,'Tag','Box');
        for i = 1:5
            patch(get(boxobj(i),'XData'),get(boxobj(i),'YData'),mycolor(i,:),'FaceAlpha',0.5,...
                'LineWidth',1.1);
        end
        set(gca,'XTickLabel',{'IALA','ALA','RRTO','WAA','BKA','PSA','HBA','WOA'});
        title(['F',num2str(F(func_num))])
        hold on
    end 
end

if exist('Metrics_Results.xlsx','file')
    delete('Metrics_Results.xlsx')
end

if exist('Rank_Sum_Test_Results.xlsx','file')
    delete('Rank_Sum_Test_Results.xlsx')
end

%% Write std, mean, best value and other results to Excel
A = string();
for i = 1:length(F)
    str = string(['F',num2str(F(i))]);
    A(6*(i-1)+1:6*i,1)= repmat(str,6,1);
    A(6*(i-1)+1:6*i,2)= ["Best";"Std";"Mean";"Median";"Worst";"Avg Time"];
end
A = cellstr (A);
A = [A,num2cell(RESULT)];
title = {" "," ","IALA","ALA","RRTO","WAA","BKA","PSA","HBA","WOA"};
A = [title;A];
xlswrite(['CEC2017-',num2str(variables_no),'D_Metrics_Results.xlsx'], A)

%% Write rank sum test results to Excel
B = string();
for i = 1:length(F)
    str = string(['F',num2str(F(i))]);
    B(i,1)= str;
end
B = cellstr (B);
B = [B,num2cell(rank_sum_RESULT)];
title = {" ","ALA","RRTO","WAA","BKA","PSA","HBA","WOA"};
B = [title;B];
xlswrite(['CEC2017-',num2str(variables_no),'D_Rank_Sum_Test_Results.xlsx'], B)

%% Friedman test
selected_rows = [];
for i = 1:numel(F)
    selected_rows = [selected_rows, 3 + (i-1)*6]; % Rows of mean values
end
average = RESULT(selected_rows, :);
[p,tbl,stats] = friedman(average); % Calculate Friedman value
% Output average rank of each algorithm
algorithms = {"IALA","ALA","RRTO","WAA","BKA","PSA","HBA","WOA"};
for i = 1:numel(algorithms)
    fprintf('Average Friedman rank of %s algorithm: %f\n', algorithms{i}, stats.meanranks(i)); 
end
disp(['p-value of Friedman test: ', num2str(p)]);
C = num2cell(stats.meanranks);
C = [algorithms;C];
% Write data to Excel file
xlswrite(['CEC2017-',num2str(variables_no),'D_Friedman_Test_Results.xlsx'], C)