function tmpmask = creat_mask_from_gm(GMModel,hue_small,sat_small,Cr_small,Cb_small)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    x=[hue_small(:) sat_small(:) Cr_small(:) Cb_small(:)];
%     x=[hue_small(:) Cr_small(:) Cb_small(:)];
    Mu=GMModel.mu;
    Sigma=GMModel.Sigma;
    mat=mvnpdf(x,Mu,Sigma);
    th=0.0001*mvnpdf(Mu,Mu,Sigma);
    mat=reshape(mat,size(hue_small));
    tmpmask=(mat>th);
end

