function [BB, mask] = seg2(img)
    
    img = double(img);
     BB = zeros([1,4]);

    if(size(img,3)<3)
        mask = ones(size(img));
    else
         bw = edge(img(:,:,2));
         h = dip_hough_circles(bw,4,5);
         peaks1 = dip_houghpeaks3d(h);
         circle = rgb2gray(dip_draw_hough_circle(zeros(size(img)),peaks1,1));
         c_log = logical(circle);
         mask = imfill(c_log,'holes');
%         mask = bwareafilt(mask,1);
    end

   
    [poly_x,poly_y] = find(mask==1);
    polyin = polyshape(poly_x,poly_y);
    [ylim,xlim] = boundingbox(polyin);

    if(length(ylim)<2 || length(xlim)<2)
        return;
    end

    %rectangular params
    dx = xlim(2) - xlim(1);
    dy = ylim(2) - ylim(1);

    BB(1) = xlim(1);
    BB(2) = ylim(1);
    BB(3) = dx;
    BB(4) = dy;

    BB = uint16(BB);
    mask = logical(mask);

end

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

function H = dip_draw_hough_circle(img, peaks,R0)
    Rmin = 80;
    Rmax = 120;
    R = Rmin:R0:Rmax;
    c = ["blue","red","green","yellow","magenta"];
    H = img;
    
        a = peaks(1,1);
        b = peaks(1,2);
        r = peaks(1,3);
        H = insertShape(H,'circle',[b,a,R(r)],'LineWidth',4,'Color',{c(1)});
    
   
end