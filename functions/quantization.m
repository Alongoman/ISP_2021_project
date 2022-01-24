% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function out = quantization(img, num_bit)
    max_bit = 8;
    img = double(img);
    val = 0;%mod(img,(2^(max_bit-num_bit)))/(2^(max_bit-num_bit));
    out = floor(img/(2^(max_bit-num_bit)))-val;
end