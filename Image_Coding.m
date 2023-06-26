% clc;
% clear all;

% Load an input image
InputImage = imread('car.jpg');
GrayImage = rgb2gray(InputImage); % Convert to grayscale if needed
DGrayImage = im2double(GrayImage);
[width,length] = size(DGrayImage);
imwrite(GrayImage,'gray_image.jpg')
 

qtable=generateQuantizationMatrix(567, [width,length])

% Parameters
blockSize = 8; % Size of the DCT block
qSuperExtreme = [256, 192, 192, 256, 384, 640, 816, 976; 192, 192, 224, 304, 416, 928, 960, 880; 224, 208, 256, 384, 640, 912, 1104, 896; 224, 272, 352, 464, 816, 1392, 1280, 992; 288, 352, 592, 896, 1088, 1744, 1648, 1232; 384, 560, 880, 1024, 1296, 1664, 1808, 1472; 784, 1024, 1248, 1392, 1648, 1936, 1920, 1616; 1152, 1472, 1520, 1568, 1792, 1600, 1648, 1584;];
qExtreme = [128, 96, 96, 128, 192, 320, 408, 488; 96, 96, 112, 152, 208, 464, 480, 440; 112, 104, 128, 192, 320, 456, 552, 448; 112, 136, 176, 232, 408, 696, 640, 496; 144, 176, 296, 448, 544, 872, 824, 616; 192, 280, 440, 512, 648, 832, 904, 736; 392, 512, 624, 696, 824, 968, 960, 808; 576, 736, 760, 784, 896, 800, 824, 792;];
qveryveryLow =[64, 48, 48, 64, 96, 160, 204, 244; 48, 48, 56, 76, 104, 232, 240, 220; 56, 52, 64, 96, 160, 228, 276, 224; 56, 68, 88, 116, 204, 348, 320, 248; 72, 88, 148, 224, 272, 436, 412, 308; 96, 140, 220, 256, 324, 416, 452, 368; 196, 256, 312, 348, 412, 484, 480, 404; 288, 368, 380, 392, 448, 400, 412, 396;];
qveryLow = [ 32, 24, 24, 32, 48, 80, 102, 122; 24, 24, 28, 38, 52, 116, 120, 110;28, 26, 32, 48, 80, 114, 138, 112; 28, 34, 44, 58, 102, 174, 160, 124;36, 44, 74, 112, 136, 218, 206, 154;48, 70, 110, 128, 162, 208, 226, 184;98, 128, 156, 174, 206, 242, 240, 202; 144, 184, 190, 196, 224, 200, 206, 198;];
qLow = [16, 11, 10, 16, 24, 40, 51, 61; 12, 12, 14, 19, 26, 58, 60, 55; 14, 13, 16, 24, 40, 57, 69, 56; 14, 17, 22, 29, 51, 87, 80, 62; 18, 22, 37, 56, 68, 109, 103, 77; 24, 35, 55, 64, 81, 104, 113, 92; 49, 64, 78, 87, 103, 121, 120, 101; 72, 92, 95, 98, 112, 100, 103, 99]; % Quantization matrix for low quality
qMedium = [8, 6, 5, 8, 12, 20, 26, 31; 6, 6, 7, 10, 13, 29, 30, 27; 7, 6, 8, 12, 20, 28, 35, 28; 7, 9, 11, 15, 26, 44, 40, 31; 9, 11, 19, 28, 34, 55, 52, 39; 12, 18, 28, 32, 41, 52, 57, 46; 24, 32, 39, 44, 52, 61, 60, 51; 36, 46, 48, 49, 56, 50, 51, 50]; % Quantization matrix for medium quality
qHigh = [4, 3, 3, 4, 6, 10, 13, 15; 3, 3, 3, 4, 6, 14, 14, 12; 3, 3, 4, 6, 10, 14, 18, 14; 3, 4, 5, 7, 12, 20, 18, 15; 4, 5, 9, 14, 17, 28, 26, 19; 6, 9, 14, 16, 20, 26, 28, 23; 12, 16, 19, 21, 26, 30, 29, 25; 18, 23, 24, 24, 27, 24, 25, 24]; % Quantization matrix for high quality
quant=qtable;

% Forward Transform (DCT)
dctImage = blockproc(DGrayImage, [blockSize blockSize], @(block_struct) dct2(block_struct.data));
dctImage = ceil(dctImage * 1000);

% Quantization
quantizedImage = blockproc(dctImage, [blockSize blockSize], @(block_struct) round(block_struct.data ./ quant));

% Entropy Encoding (Huffman coding)
[g,~,intensity_val] = grp2idx(quantizedImage(:));
 Frequency = accumarray(g,1);
 probability = Frequency./(width * length);
 T = table(intensity_val,Frequency,probability);%table(element | count| prob
 dict=huffmandict(intensity_val,probability);
 huffmanEncoded = huffmanenco(quantizedImage(:),dict);

binaryData = de2bi(huffmanEncoded);
encodedSize = numel(binaryData)/1024;
 %Save the compressed image

file3 = fopen('compressed image data.txt','w');
[r,~]=size(huffmanEncoded);
for c=1:r
    fprintf(file3, '%d',huffmanEncoded(c));
end
fclose(file3);
 
 
% Entropy Decoding (Huffman decoding)
huffmanDecoded=huffmandeco(huffmanEncoded,dict);
huffmanDecoded = reshape(huffmanDecoded , [width ,length]);

% Reconstruction of Quantized Data
reconstructedQuantized = blockproc(huffmanDecoded, [blockSize blockSize], @(block_struct) block_struct.data .* quant);

% Inverse Transform (IDCT)
reconstructedQuantized = reconstructedQuantized/1000;
reconstructedImage = (blockproc(reconstructedQuantized, [blockSize blockSize], @(block_struct) idct2(block_struct.data)));
imwrite(reconstructedImage,'Reconstructed_image.jpg');
% Display the results
binaryDataO = de2bi(GrayImage);
binaryData = de2bi(huffmanEncoded);
orignalsize = numel(binaryDataO)/1024;
encodedSize = numel(binaryData)/1024;
compressionRatio = orignalsize / encodedSize; % Compression ratio
PSNR_DECODE_IMAGE = psnr(reconstructedImage,DGrayImage); %30dB-50dB is better less is not acceptable   

fprintf('Original image size: %d kbits \n', orignalsize);
fprintf('Encoded image size: %d kbits \n', ceil(encodedSize));
fprintf('Compression ratio: %.2f\n', compressionRatio);
fprintf('PSNR: %.2f dB\n', PSNR_DECODE_IMAGE);
% imshow(reconstructedImage)
% figure;
% 
% subplot(1, 2, 1); imshow(DGrayImage); title('Original Image');
% subplot(1, 2, 2); imshow(reconstructedImage); title(' Reconstructed image' );
% figure;
% imshow(DGrayImage)

function quantizationMatrix = generateQuantizationMatrix(x, imageSize)
    % Define the base quantization matrix
    targetBitRate =((1*x^8)+(0*x^7)+(1*x^6)+(0*x^5)+(1*x^4)+(-45*x^3)+(16703*x^2)+(-3368296*x^1)+289655957)*(1.0e-17)   %targetBitRate=round(targetBitRate)
    
    baseMatrix = [16, 11, 10, 16, 24, 40, 51, 61;
                  12, 12, 14, 19, 26, 58, 60, 55;
                  14, 13, 16, 24, 40, 57, 69, 56;
                  14, 17, 22, 29, 51, 87, 80, 62;
                  18, 22, 37, 56, 68, 109, 103, 77;
                  24, 35, 55, 64, 81, 104, 113, 92;
                  49, 64, 78, 87, 103, 121, 120, 101;
                  72, 92, 95, 98, 112, 100, 103, 99];
    
    % Calculate the scale factor based on the target bit rate
    imageSize = prod(imageSize);
    scale = sqrt(targetBitRate / (imageSize/64));
    
    % Scale the base quantization matrix
    quantizationMatrix = round(baseMatrix * scale);
end
