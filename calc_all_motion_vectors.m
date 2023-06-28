function motion_vectors= calc_all_motion_vectors(num_frames , N)

motion_vectors = cell(1,num_frames);
frame_names = cell(1 , num_frames);
frames = cell(1,num_frames);


for i = 1 : num_frames
    frame_names{1,i} = strcat('frame',num2str(i),'.jpg') ;
end

for j = 1 : num_frames
    frames{1,j} = imread(frame_names{1,j}); 
end

for k = 2: num_frames 

        motion_vectors{1,k} = sad( frames{1,k-1} , frames{1,k} ,N);
   
 
end


end
