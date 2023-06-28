function idct_img_uint8 = idctt(gray_img , N)

[rows , cols ] = size(gray_img);
idct_img = zeros(rows , cols);

for i= 1 : N :rows
    for j = 1:N:cols
        idct_img(i:i+N-1 , j:j+N-1) = idct2(gray_img(i:i+N-1 , j :j+N-1));
    end
end

idct_img_uint8 = uint8(idct_img);

end

