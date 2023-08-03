function predicted_frames = predict(reconstructed_I_frame,motion_vectors,num_frames , N)


frame_names = cell(1 , num_frames);
frames = cell(1,num_frames);
predicted_frames = cell(1 , num_frames);

for i = 1 : num_frames
    frame_names{1,i} = strcat('frame',num2str(i),'.jpg') ;
end

for j = 1 : num_frames
    frames{1,j} = imread(frame_names{1,j}); 
end


%predicted_frames{1,1} = frames{1,1};
predicted_frames{1,1} = reconstructed_I_frame ;
for k = 2: num_frames 

        if k == 2 
            predicted_frame = reconstructed_I_frame ;
        else 
            predicted_frame = predicted_frames{1,k-1};
        end
        

        predicted_frames{1,k} =  motion_vect_predict(predicted_frame , motion_vectors{1,k} , N) ;
 
end


end
