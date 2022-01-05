function [BB, mask] = seg2(img)
    
  
     BB = zeros([1,4]);

    if(size(img,3)<3)
        mask = ones(size(img));
    else
         mask = edge(img(:,:,2),'Canny');
        mask = bwareafilt(mask,1);
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
