load('dict_for_residuals.mat');
load('motion_vectors.mat');

si = size(dict_for_residuals{1,2});
r = si(1);    % r = rows /N
w = si(2);
N = 8 ;
qHighe = [4, 3, 3, 4, 6, 10, 13, 15; 3, 3, 3, 4, 6, 14, 14, 12; 3, 3, 4, 6, 10, 14, 18, 14; 3, 4, 5, 7, 12, 20, 18, 15; 4, 5, 9, 14, 17, 28, 26, 19; 6, 9, 14, 16, 20, 26, 28, 23; 12, 16, 19, 21, 26, 30, 29, 25; 18, 23, 24, 24, 27, 24, 25, 24]; % Quantization matrix for high quality

%q_table = [16, 11, 10, 16, 24, 40, 51, 61; 12, 12, 14, 19, 26, 58, 60, 55; 14, 13, 16, 24, 40, 57, 69, 56; 14, 17, 22, 29, 51, 87, 80, 62; 18, 22, 37, 56, 68, 109, 103, 77; 24, 35, 55, 64, 81, 104, 113, 92; 49, 64, 78, 87, 103, 121, 120, 101; 72, 92, 95, 98, 112, 100, 103, 99]; % Quantization matrix for low quality
q_table=qHighe;
%%
%read data from text file
fid2 = fopen('residual_frames_including_I.txt');

% Read all lines & collect in cell array
txt = textscan(fid2,'%s','delimiter','*'); 
%txt = textscan(txt,'%s','delimiter','*');
aa = txt{1,1};

%%retrive residual_p_frame data

final_retrived_code = cell(1,10);


for k = 1 : 10
code = retrive(r,w,aa{k,1});
final_retrived_code{1,k} = code ;
end

%%
%Reconstructing p frames % first frame is the I frame

decoded_residual = cell(1,10);

for i = 1 : 10
    decoded_residual{1,i} = frame_decoder(r*N , w*N ,N , final_retrived_code{1,i}, dict_for_residuals{1,i} , q_table) ;
    
end


%%
% get predicted frames from motion vectors

% [predicted_frames , motion_vectors] = calc_all_motion_vectors(decoded_p_residual{1,1},10, N);
predicted_frames = cell(1,10);
predicted_frames{1,1} = decoded_residual{1,1};

for i = 2 : 10
predicted_frames{1,i} = motion_vect_predict(predicted_frames{1,i-1} , motion_vectors{1,i} , N);

end

%%
final_frames = cell(1,10);
final_frames{1,1} = decoded_residual{1,1} ;

for i = 2 : 10
    
    final_frames{1,i} = double(decoded_residual{1,i}) + double(predicted_frames{1,i});
    
end

%%
 figure ;
 imshow(uint8(final_frames{1,2}));
 title('Reconstructed frame ')

%%
%Save compressed video

outputVideo = VideoWriter('compressed_vid');
outputVideo.FrameRate = 30;
open(outputVideo);

for ii = 1:10
   img = uint8(final_frames{1,ii}) ;
   writeVideo(outputVideo,img);
end

close(outputVideo);
%%
