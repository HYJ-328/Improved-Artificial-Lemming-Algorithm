function   [ValidPath] = CreateValidPath(pop,dim,lb,ub,NodesNumber,startPoint,endPoint,ThreatAreaPostion,ThreatAreaRadius)
for a = 1:pop  %Set each individual
    SuccessFlag = 0;
    for i = 1:NodesNumber
        postionP(i,1) = startPoint(1) + (endPoint(1)-startPoint(1))*i/(NodesNumber+1);
    end
    while SuccessFlag<1
        SuccessFlag = 1;        
        postion = (ub-lb).*rand(1,dim) + lb;
        postionP(:,2) = postion(1:NodesNumber)';
        postionP(:,3) = postion(NodesNumber + 1:2*NodesNumber)';
        [~,SortIndex]=sort(postionP(:,1));
        postionP(:,1) = postionP(SortIndex,1);
        postionP(:,2) = postionP(SortIndex,2);
        postionP(:,3) = postionP(SortIndex,3);
        % Process Z direction to ensure generated z is above ground/mountain
        for i = 1:size(postionP)
            x= postionP(i,2);
            y = postionP(i,1);
            postionP(i,3) = postionP(i,3) + MapValueFunction(x,y);
        end

        PALL = [startPoint;postionP;endPoint];
        x_seq=PALL(:,1);
        y_seq=PALL(:,2);
        z_seq=PALL(:,3);


        k = size(PALL,1);
        i_seq = linspace(0,1,k);
        I_seq = linspace(0,1,200);
        %Cubic spline interpolation
        X_seq = spline(i_seq,x_seq,I_seq);
        Y_seq = spline(i_seq,y_seq,I_seq);
        Z_seq = spline(i_seq,z_seq,I_seq);
%         X_seq = interp1(i_seq,x_seq,I_seq);
%         Y_seq = interp1(i_seq,y_seq,I_seq);
%         Z_seq = interp1(i_seq,z_seq,I_seq);

        path = [X_seq', Y_seq', Z_seq'];%Colon sets range; apostrophe means transpose; (1,:)' transposes all data in first row
        % Check if generated curve intersects with obstacles
        for i = 1:size(path,1)
            x = path(i,1);
            y = path(i,2);
            z_interp = MapValueFunction(x,y);
            for k = 1:size(ThreatAreaPostion,1)
                if ((x-ThreatAreaPostion(k,1))^2 + (y-ThreatAreaPostion(k,2))^2)^0.5<ThreatAreaRadius(k)
                    SuccessFlag = 0;
                    break;
                end
            end
            if path(i,3) < z_interp
                SuccessFlag = 0;
                break;
            end
        end
    end
    ValidPath(a,:) = postion;
end
end