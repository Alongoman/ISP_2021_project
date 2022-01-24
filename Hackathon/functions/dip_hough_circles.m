%DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
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