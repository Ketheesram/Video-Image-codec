function [dict , encoded] = residual_frame_encoder(img ,N , q_table)


figure , imshow(uint8(img)) , title('Image to be encoded');
% DCT transform image
dct_frame = dctt(img , N);
disp(dct_frame);

% Quantizing the image
quantized_I_frame = quant(N , dct_frame, q_table) ;
disp(quantized_I_frame);

% Huffman coding
[dict , encoded] = huff_enco(quantized_I_frame, N);


end