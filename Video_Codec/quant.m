function quantized = quant(N , dct_img,q_table)
    blockSize=N;
    quantized = blockproc(dct_img, [blockSize blockSize], @(block_struct) round(block_struct.data ./ q_table));

end