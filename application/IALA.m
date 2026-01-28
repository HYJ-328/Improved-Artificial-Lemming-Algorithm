function [Score,Position,Convergence_curve]=IALA(N,Max_iter,lb,ub,dim,fobj)

% X=initialization(N,dim,ub,lb);% Initialize population
%% Hammersley Sequence
hammersley = hammersley_sequence(1, N, dim, N);
X = hammersley' .* (ub - lb) + lb;
Position=zeros(1,dim); % Best position
Score=inf; %Best score (initially infinite)
fitness=zeros(1,size(X,1));% Fitness of each individual
Convergence_curve=[];% Store convergence information
vec_flag=[1,-1]; % Directional flag
%% Record the initial optimal solution and fitness
for i=1:size(X,1)  
    fitness(1,i)=fobj(X(i,:));
    if fitness(1,i)<Score
        Position=X(i,:); Score=fitness(1,i);
    end
end

Iter=1; %Iteration number
%% Main optimization loop
while Iter<=Max_iter
    RB=randn(N,dim);  % Brownian motion
    F=vec_flag(floor(2*rand()+1)); % Random directional flag
    theta=2*atan(1-Iter/Max_iter); % Time-varying parameter
    for i=1:N
        E=2*log(1/rand)*theta;
        if E>1
           if rand<0.3
               r1 = 2 * rand(1,dim) - 1;
               Xnew(i,:)= Position+F.*RB(i,:).*(r1.*(Position-X(i,:))+(1-r1).*(X(i,:)-X(randi(N),:)));
          else
               r2 = rand ()* (1 + sin(0.5 * Iter));
               Xnew(i,:)= X(i,:)+ F.* r2*(Position-X(randi(N),:));
          end
        else
           if rand<0.5
               % radius = sqrt(sum((Position-X(i, :)).^2));
               % r3=rand();
               % spiral=radius*(sin(2*pi*r3)+cos(2*pi*r3));
               % Xnew(i,:) =Position + F.* X(i,:).*spiral*rand;
               %%  Introduction of Competitive Learning Strategy
               j = i;
               while j == i
                   j = randi(N);
               end   
               s = rand(1, dim);
               if fitness(1,j) < fitness(1,i)
                   Xnew(i,:) = X(i,:) + s .* (X(i,:) - X(j,:));
               else
                   Xnew(i,:) = X(i,:) + s .* (X(j,:) - X(i,:));
               end
           else
               G=2*(sign(rand-0.5))*(1-Iter/Max_iter);    
               Xnew(i,:) = Position + F.* G*Levy(dim).* (Position - X(i,:)) ;
           end
        end
    end
    %%  Boundary check and evaluation
    for i=1:size(X,1)
        Flag4ub=Xnew(i,:)>ub;
        Flag4lb=Xnew(i,:)<lb;
        Xnew(i,:)=(Xnew(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % Boundary correction
        newPopfit=fobj(Xnew(i,:)); % Evaluate new solution
        if newPopfit<fitness(i)
            X(i,:)=Xnew(i,:);
            fitness(1,i)=newPopfit;
        end
        if fitness(1,i)<Score
            Position=X(i,:);
            Score=fitness(1,i);
        end
    end

    for i=1:N
        %%  Lemming Defense Mechanism
        U1=rand(1,dim)>rand;
        y=(X(i,:)+X(randi(N),:))/2;
        Xnew(i,:)=(U1).*X(i,:)+(1-U1).*(y+rand*(X(randi(N),:)-X(randi(N),:)));
    end
    %%  Boundary check and evaluation
    for i=1:size(X,1)
        Flag4ub=Xnew(i,:)>ub;
        Flag4lb=Xnew(i,:)<lb;
        Xnew(i,:)=(Xnew(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % Boundary correction
        newPopfit=fobj(Xnew(i,:)); % Evaluate new solution
        if newPopfit<fitness(i)
            X(i,:)=Xnew(i,:);
            fitness(1,i)=newPopfit;
        end
        if fitness(1,i)<Score
            Position=X(i,:);
            Score=fitness(1,i);
        end
    end
    %% Record convergence curve
    Convergence_curve(Iter)=Score; 
    Iter=Iter+1; 
end

end
function o=Levy(d)
beta=1.5;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
o=step;
end

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
    
    if i1 <= i2
        step = 1;
    else
        step = -1;
    end
    
    L = abs(i2 - i1) + 1;
    r = zeros(m, L);
    k = 0;
    
    for i = i1:step:i2
        t(1:m-1,1) = i;
        prime_inv = zeros(m-1, 1);
        for idx = 1:m-1
            prime_inv(idx) = 1.0 / prime(idx);
        end
        k = k + 1;
        r(1, k) = mod(i, n+1) / n;
        
        while any(t ~= 0)
            for j = 1:m-1
                d = mod(t(j), prime(j));
                r(j+1, k) = r(j+1, k) + d * prime_inv(j);
                prime_inv(j) = prime_inv(j) / prime(j);
                t(j) = floor(t(j) / prime(j));
            end
        end
    end
    return
end