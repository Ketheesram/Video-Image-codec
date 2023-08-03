function reconstructed_img = frame_decoder(height , width ,N , encoded_frame, dict_frame , q_table)

%Huffman decoding
decoded_frame = huff_deco(height , width ,N , encoded_frame, dict_frame);

% disp('decoded_frame');
% disp(decoded_frame);
% disp('=========================');

%Inverse qunatizing 
dequantized_frame = dequant(N , decoded_frame,q_table) ;


% IDCT
reconstructed_img = idctt(dequantized_frame , N);
%figure , imshow(reconstructed_img) , title('Reconstructed frame');
end