% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function disp_filter_noise(pic,noise_pic,pic_name,noise_type,withGraph)
K = [3,9];
sigma = 1;
figure
disp(strcat(pic_name," with ",noise_type))
imshow(noise_pic)

if withGraph==1
 disp(strcat("histogram between the original ", pic_name,"and the image with ",noise_type))

mse = mean((noise_pic - pic).^2,'all');
mi = get_mi(noise_pic,pic);

mse_vec = [mse];
label_vec_mse = ['noise - original'];
mi_vec = [mi];
label_vec_mi =['noise - original'];
end

for k=K
    
    pic_salt_filt_mean = mean_filter(noise_pic,k);
    figure
    disp(strcat(pic_name," with ",noise_type," with mean filter k=",num2str(k)))

    imshow(pic_salt_filt_mean)
    
     if withGraph==1
     disp(strcat("histogram between the original ", pic_name,"and the image with ",noise_type," with mean filter k=",num2str(k)))
    [mse, mi] = Calc_mse_mi(pic,pic_salt_filt_mean,withGraph);
    mse_vec = [mse_vec; mse];
    label_vec_mse = [label_vec_mse; strcat("mean k=",num2str(k))];
    mi_vec = [mi_vec; mi];
    label_vec_mi = [label_vec_mi; strcat("mean k=",num2str(k))];
    end
    
    pic_salt_filt_med = median_filter(noise_pic,k);
    figure
    disp(strcat(pic_name," with ",noise_type," with median filter k=",num2str(k)))

    imshow(pic_salt_filt_med)
    
    if withGraph==1
     disp(strcat("histogram between the original ", pic_name,"and the image with ",noise_type," with median filter k=",num2str(k)))

    [mse, mi] = Calc_mse_mi(pic,pic_salt_filt_med,withGraph);
    mse_vec = [mse_vec; mse];
    label_vec_mse = [label_vec_mse; strcat("median k=",num2str(k))];
    mi_vec = [mi_vec; mi];
    label_vec_mi = [label_vec_mi; strcat("median k=",num2str(k))];
    end
    
    pic_salt_filt_gauss = dip_gaussian_filter(noise_pic,k,sigma);
    figure
     disp(strcat(pic_name," with ",noise_type," with gaussian filter k=",num2str(k),' sigma = ',num2str(sigma)))

    imshow(pic_salt_filt_gauss)
    
    if withGraph==1
         disp(strcat("histogram between the original ", pic_name,"and the image with ",noise_type," with gaussian filter k=",num2str(k)))

    [mse, mi] = Calc_mse_mi(pic,pic_salt_filt_gauss,withGraph);
    mse_vec = [mse_vec; mse];
    label_vec_mse = [label_vec_mse; strcat("gaussian k=",num2str(k))];
    mi_vec = [mi_vec; mi];
    label_vec_mi = [label_vec_mi;strcat("gaussian k=",num2str(k))];
    end
end
pic_salt_filt_diff = imdiffusefilt(noise_pic); 
figure
disp(strcat(pic_name," with ",noise_type," with diffusion filter"))

imshow(pic_salt_filt_diff)

if withGraph==1
     disp(strcat("histogram between the original ", pic_name,"and the image with ",noise_type," with diffusion filter"))

    [mse, mi] = Calc_mse_mi(pic,pic_salt_filt_diff,withGraph);
    mse_vec = [mse_vec; mse];
    label_vec_mse = [label_vec_mse;strcat("diffusion")];
    mi_vec = [mi_vec; mi];
    label_vec_mi = [label_vec_mi; strcat("diffusion")];
    
    figure;
    hold on
    boxplot(mse_vec,label_vec_mse,'Colors','r')
    boxplot(mi_vec,label_vec_mi,'Colors','b')
    title(strcat("Graph MSE,MI ",pic_name," with noise ",noise_type))
    ylabel('red = MSE , blue = MI');
    disp(strcat("min MSE is ", label_vec_mse(find(mse_vec==min(mse_vec)))))
    disp(strcat("max MI is ", label_vec_mi(find(mi_vec==max(mi_vec)))))

    hold off
end


end

function [mse,mi] = Calc_mse_mi(original_img,filtered_img,withGraph)

   
        mse = mean((filtered_img - original_img).^2,'all');
        mi = get_mi(original_img,filtered_img);
    
end