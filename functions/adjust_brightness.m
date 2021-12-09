% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function out = adjust_brightness(img,action,parameter)

    if action=='mul'
        out = img * parameter;
    elseif action=='add'
        out = img + parameter;
    else
        disp(['undefined action ', action]);
        out = 0;
    end
    out(out>1)=1;
    out(out<0)=0;
end