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