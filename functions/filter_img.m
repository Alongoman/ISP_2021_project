% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function filtered_img = filter_img(img, K, func)% assume square filter
    [n,m] = size(img);
    k = (K-1)/2;    
    zero_padded_img = padarray(img,[k k],0,'both');
    max_padded_img = padarray(img,[k k],255,'both');
    neighbors_sum = padarray(ones(size(img)),[k k],0,'both');
    
    mat_for_imgs_min = get_neighbors_mat(zero_padded_img,k);
    mat_for_imgs_max = get_neighbors_mat(max_padded_img,k); % helpful for computing the median
    total_neighbors = sum(get_neighbors_mat(neighbors_sum,k),3); % counting how many neighbors each pixel have
    
    if func == 'mean'
       filtered_img = get_mean_filter(mat_for_imgs_min,total_neighbors);
    elseif func == 'medi'
       filtered_img = get_median_filter(mat_for_imgs_min,mat_for_imgs_max);
    else
        disp("unsupported filter type")
    end
    filtered_img = filtered_img((k+1):(n+k),(k+1):(m+k));
    

end

function res = get_neighbors_mat(mat,k)
    res = [];
    for i=-k:k
        mat1 = circshift(mat,i,2);
        for j=-k:k
            mat2 = circshift(mat1,j,1);
            res = cat(3,res,mat2);
        end
    end
end

function pixels_mean = get_mean_filter(mat_min,total_neighbors)
    neighbors_sum_per_pixel = sum(mat_min,3);
    pixels_mean = neighbors_sum_per_pixel./total_neighbors;
end

function pixels_median = get_median_filter(mat_min,mat_max)
    min_max_mat = cat(3,mat_min,mat_max);
    pixels_median = median(min_max_mat,3);    
end

