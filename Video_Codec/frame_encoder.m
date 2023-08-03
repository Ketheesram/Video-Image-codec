function [dict , encoded] = frame_encoder(img ,N , q_table)


% DCT transform image
dct_frame = dctt(img , N);


% Quantizing the image
quantized_I_frame = quant(N , dct_frame, q_table) ;


% Huffman coding
[dict , encoded] = huff_enco(quantized_I_frame, N);


end