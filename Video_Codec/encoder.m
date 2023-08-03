clc;
clear all;
v = VideoReader('surfing.mp4');
% Break video to frames
num_frames = 10;


%Break into 10 frames and Resize change to gray each frames  
for img = 1:10;
    filename=strcat('frame',num2str(img),'.jpg');
    b = read(v, img);
    bb = rgb2gray(b);
    bbb =imresize(bb , [184 ,320 ]);
    imwrite(bbb,filename);
end

%Cell arrays save frames,names 
vid_frames  = cell(1,10);
vid_frame_names = cell(1,10);

%File name of extracted images
for i = 1 : num_frames
    vid_frame_names{1,i} = strcat('frame',num2str(i),'.jpg') ;
end
%Frames correseponding of names
for j = 1 : num_frames
    vid_frames{1,j} = imread(vid_frame_names{1,j}); 
end

%Create a video using the same fraem rate for writting
outputVideo1 = VideoWriter('Frames');
outputVideo1.FrameRate = v.FrameRate;
open(outputVideo1);

%Add these frames into created video
for ii = 1:num_frames
   img = uint8(vid_frames{1,ii}) ;
  writeVideo(outputVideo1,img);
end

close(outputVideo1);


%%

% demensions of a frame
m = size(vid_frames{1,1});
height = m(1) ;
width = m(2) ;
N = 8 ; % MB size
qHighe = [4, 3, 3, 4, 6, 10, 13, 15; 3, 3, 3, 4, 6, 14, 14, 12; 3, 3, 4, 6, 10, 14, 18, 14; 3, 4, 5, 7, 12, 20, 18, 15; 4, 5, 9, 14, 17, 28, 26, 19; 6, 9, 14, 16, 20, 26, 28, 23; 12, 16, 19, 21, 26, 30, 29, 25; 18, 23, 24, 24, 27, 24, 25, 24]; % Quantization matrix for high quality

%q_table = [16, 11, 10, 16, 24, 40, 51, 61; 12, 12, 14, 19, 26, 58, 60, 55; 14, 13, 16, 24, 40, 57, 69, 56; 14, 17, 22, 29, 51, 87, 80, 62; 18, 22, 37, 56, 68, 109, 103, 77; 24, 35, 55, 64, 81, 104, 113, 92; 49, 64, 78, 87, 103, 121, 120, 101; 72, 92, 95, 98, 112, 100, 103, 99]; % Quantization matrix for low quality
num_frames = 10 ; 

q_table=qHighe;


% %%
% %Display the results of i frame
% figure , imshow(I_frame) , title('Original frame');

%%

for i = 1 : num_frames
    frame_names{1,i} = strcat('frame',num2str(i),'.jpg') ;
end

for j = 1 : num_frames
    frames{1,j} = imread(frame_names{1,j}); 
end

%%

%Calculate all motion vectors
 motion_vectors= calc_all_motion_vectors(num_frames , N);
%[di , en] = frame_encoder( frames{1,1},N , q_table);  %Encode the frame1



%%

% Difference between Original Frame and Motion predicted Frame
residual = cell(1,num_frames);
residual{1,1} = double(frames{1,1});
for i = 2 : num_frames        
    residual{1,i} = double(frames{1,i}) - double(frames{1,i-1});
end

%%

% Encode Residual of all frames
% should  i use quantization when encoding p residual.
dict_for_residuals = cell(1 , 10);
encoded_residual = cell(1,10);

for i = 1 : num_frames
    [dict_for_p_residual , encoded] = frame_encoder(residual{1,i} ,N , q_table);
    dict_for_residuals{1,i} = dict_for_p_residual ; 
    encoded_residual{1,i} = encoded ;
end

%%

%encoded_residual{1,1} = encoded_I_frame ;
% write text file
fid1 = fopen('residual_frames_including_I.txt','w');

for k = 1 : num_frames
    pres = encoded_residual{1,k};
for i = 1 : height/N
    for j = 1 :width/N
        
fprintf(fid1, num2str(pres{i,j}));
fprintf(fid1,',');
   
    end
end
    fprintf(fid1,'*');
end

fclose(fid1);


%figure , imshow(uint8(predicted_frames{1,2})) , title('predicted frame_2');

figure , imshow(uint8(frames{1,2})) , title('original frame_2');
figure , imshow(uint8(residual{1,2})) , title('residual frame_2');





%%
dict_for_residuals{1,1} = dict_for_residuals{1,1} ;
save('dict_for_residuals.mat', 'dict_for_residuals');
save('motion_vectors.mat' , 'motion_vectors');

function dct_img = dctt(gray_img , N)
blockSize=N;
dct_img = blockproc(gray_img, [blockSize blockSize], @(block_struct) dct2(block_struct.data));

end
function quantized = quant(N , dct_img,q_table)
    blockSize=N;
    quantized = blockproc(dct_img, [blockSize blockSize], @(block_struct) round(block_struct.data ./ q_table));

end


