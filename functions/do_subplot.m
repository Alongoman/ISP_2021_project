% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function do_subplot(figures) % get a N x 2 cell first dim is title, second dim is picture
    n = size(figures,1);
    m = ceil(n/2);
    figure
    for i=1:n
        subplot(m,2,i)
        imshow(figures{i,2})
        title(figures{i,1})
    end
end