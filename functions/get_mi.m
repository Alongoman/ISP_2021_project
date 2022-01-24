% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function res = get_mi(pic1,pic2)
    figure;
    h = histogram2(pic1(:),pic2(:),256);
    joint_prob = h.Values/(length(pic1(:)));
    marg_prob1 = sum(joint_prob,1);
    marg_prob2 = sum(joint_prob,2);
    marg_prob_mat = marg_prob2*marg_prob1;
    marg_prob_mat(marg_prob_mat==0)=1;
    mat_tmp = joint_prob./marg_prob_mat;
    mat_tmp(mat_tmp==0) = 1; % avoid devision by zero
    res = sum(joint_prob.*log2(mat_tmp),'all');
end