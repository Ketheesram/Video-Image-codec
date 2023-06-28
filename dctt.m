function dct_img = dctt(gray_img , N)
blockSize=N;
dct_img = blockproc(gray_img, [blockSize blockSize], @(block_struct) dct2(block_struct.data));

end