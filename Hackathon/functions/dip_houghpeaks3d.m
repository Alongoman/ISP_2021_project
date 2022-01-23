% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function peaks = dip_houghpeaks3d(H)

R_max=100;
R_min=80;
R=linspace(R_min,R_max,size(H,3));

peaks = zeros(1,3) ;

    [val, idx] = max(H(:)) ;
    [idx1, idx2, idx3] = ind2sub(size(H),idx) ;
    peaks(1,:) = [idx1,idx2,idx3] ;
    
    %Mask all the points that are near the peaks - explained in the
    %main.mlx
    r=R(idx3);
    for row=1:size(H,1)
        for col=1:size(H,2)
            if (row-idx1)^2+(col-idx2)^2<=r^2
                H(row,col,:)=0;
                
            end
        end
    end
end

function H = dip_hough_circles(BW, R0, T0)


    [M,N] = size(BW);
    Rmin = 80;
    Rmax = 100;
    R = Rmin:R0:Rmax;
    T = 0:T0:360;
    T=deg2rad(T);
    
    H = zeros(M,N,length(R));
    [y,x] = find(BW == 1);
    
    for i=1:length(x)
        for r=1:length(R)
                
            a_mat=round(x(i)-R(r)*cos(T));
            b_mat=round(y(i)-R(r)*sin(T));
            
            a=a_mat((a_mat>0) & (a_mat<=N) & (b_mat>0) & (b_mat<=M));
            b=b_mat((a_mat>0) & (a_mat<=N) & (b_mat>0) & (b_mat<=M));
            ind=sub2ind(size(H),b,a,r*ones(1,length(a)));
            
            H(ind) = H(ind)+1;
        end
    end
    
    
end

