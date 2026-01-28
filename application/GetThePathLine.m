function [X_seq,Y_seq,Z_seq,x_seq,y_seq,z_seq] = GetThePathLine(postion,NodesNumber,startPoint,endPoint)
        
        for i = 1:NodesNumber
            postionP(i,1) = startPoint(1) + (endPoint(1)-startPoint(1))*i/(NodesNumber+1);
        end
        postionP(:,2) = postion(1:NodesNumber)';
        postionP(:,3) = postion(NodesNumber + 1:2*NodesNumber)';
        %Sort by X coordinate
        [~,SortIndex]=sort(postionP(:,1));
        postionP(:,1) = postionP(SortIndex,1);
        postionP(:,2) = postionP(SortIndex,2);
        postionP(:,3) = postionP(SortIndex,3);
        %Process Z direction to ensure generated z is above ground/mountain
        for i = 1:size(postionP,1)
            x= postionP(i,2);
            y = postionP(i,1);
            postionP(i,3) = postionP(i,3) + MapValueFunction(x,y);
        end
        
        
        PALL = [startPoint;postionP;endPoint];%Add start and end points
        x_seq=PALL(:,1);%X-coordinates of all nodes
        y_seq=PALL(:,2);
        z_seq=PALL(:,3);


        k = size(PALL,1);%Start + end + intermediate nodes
        i_seq = linspace(0,1,k);%Generate N-point row vector between x1,x2. x1=start, x2=end, k=number of elements. Default N=100 if omitted. See help linspace for details.
        I_seq = linspace(0,1,200);
        %Cubic spline interpolation
        X_seq = spline(i_seq,x_seq,I_seq);
        Y_seq = spline(i_seq,y_seq,I_seq);
        Z_seq = spline(i_seq,z_seq,I_seq);
%         X_seq = interp1(i_seq,x_seq,I_seq);
%         Y_seq = interp1(i_seq,y_seq,I_seq);
%         Z_seq = interp1(i_seq,z_seq,I_seq);

end