function [Best_score,Best_pos,curve] = BWO(N,T,lb,ub,D,y)
%% Problem definition

objective=y;        % Evaluation function
VarSize=[1 D];   % Decision variable matrix size

%% Initialization

habitat.Position=[];
habitat.Cost=[];

pop=repmat(habitat,N,1);

for i=1:N
    pop(i).Position=unifrnd(lb,ub,VarSize);
    pop(i).Cost=objective(pop(i).Position);
end

% Sort by fitness value
[~, sortOrder]=sort([pop.Cost]); % sort(A) sorts elements of A in ascending order (small to large)
pop=pop(sortOrder);

% Array to save optimal value of each generation
BestCost=zeros(T,1);

%% BWO main loop

for it=1:T

    newpop=pop;  % Create temporary population

    Bf=rand()*(1-it/2*T);  % Balance factor
    Wf=0.1-0.05*it/T;    % Whale fall probability

    for i=1:N

        if Bf>0.5
            % Exploration phase
            p=ceil(unifrnd(1,D));  % Randomly select one dimension
            r=ceil(unifrnd(1,N));  % Randomly select one individual
            r1=rand();
            r2=rand();
            for j=1:D
                % Eq.(4)
                if mod(j,2)==0  % j is even
                    newpop(i).Position(j)=pop(i).Position(p)+(1+r1)*sin(2*pi*r2)*(pop(r).Position(p)-pop(i).Position(p));
                else  % j is odd
                    newpop(i).Position(j)=pop(i).Position(p)+(1+r1)*cos(2*pi*r2)*(pop(r).Position(p)-pop(i).Position(p));
                end
            end
        else
            % Exploitation phase
            r3=rand();
            r4=rand();
            C1=2*r4*(1-it/T);
            r=ceil(unifrnd(1,N));  % Randomly select one individual
            % Eq. (5)
            newpop(i).Position=r3*pop(1).Position-r4*pop(i).Position+C1*levy(1,D,1.5).*(pop(r).Position-pop(i).Position);
        end


        % Ensure each component is within the value range
        newpop(i).Position = max(newpop(i).Position, lb);
        newpop(i).Position = min(newpop(i).Position, ub);

        % Re-evaluation
        newpop(i).Cost=objective(newpop(i).Position);


        if Bf<Wf
            C2=2*Wf*N;
            Xstep=(ub-lb)*exp(-C2*it/T); % Eq.(9)
            r5=rand();
            r6=rand();
            r7=rand();
            r=ceil(unifrnd(1,N));  % Randomly select one individual
            newpop(i).Position=r5*pop(i).Position-r6*pop(r).Position+r7*Xstep; % Eq.(8)
        end



        % Ensure each component is within the value range
        newpop(i).Position = max(newpop(i).Position, lb);
        newpop(i).Position = min(newpop(i).Position, ub);

        % Re-evaluation
        newpop(i).Cost=objective(newpop(i).Position);


        % Greedy selection
        if newpop(i).Cost<pop(i).Cost
            pop(i).Position=newpop(i).Position;
            pop(i).Cost=newpop(i).Cost;
        end

    end



    [~, sortOrder]=sort([pop.Cost]);
    pop=pop(sortOrder);

    BestCost(it)=pop(1).Cost;
    Bestsol=pop(1).Position;

    % Display optimal value found per generation
%     format long e;
%     disp(['Iteration' num2str(it)]);
%     fprintf('Best Cost is£º%40.30f\n',BestCost(it));

end
%% Output final results
curve = BestCost;
format long e;
Best_score =min(BestCost);
Best_pos = Bestsol;
end

% Levy flight function
function [z] = levy(n,m,beta)
num = gamma(1+beta)*sin(pi*beta/2);
den = gamma((1+beta)/2)*beta*2^((beta-1)/2);
sigma_u = (num/den)^(1/beta);
u = random('Normal',0,sigma_u,n,m);
v = random('Normal',0,1,n,m);
z =u./(abs(v).^(1/beta));
end