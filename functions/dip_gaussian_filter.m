% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function filtered_img = dip_gaussian_filter(img, K, sigma)% assume square filter
    
    [n,m] = size(img);
    k = (K-1)/2;    
    sigma_mat = [sigma,0;0,sigma];
    gm = gmdistribution([0,0],sigma_mat);
    kernel = @(x,y) arrayfun(@(x0,y0) pdf(gm,[x0 y0]),x,y);
    zero_padded_img = padarray(img,[k k],0,'both');
    mat_for_imgs_min = get_neighbors_mat(zero_padded_img,k,kernel);
    filtered_img = sum(mat_for_imgs_min,3);
    filtered_img = filtered_img((k+1):(n+k),(k+1):(m+k));
    

end

function res = get_neighbors_mat(mat,k,kernel)
    res = [];
    for i=-k:k
        mat1 = circshift(mat,i,2);
        for j=-k:k
            mat2 = circshift(mat1,j,1)*kernel(i,j);
            res = cat(3,res,mat2);
        end
    end
end

