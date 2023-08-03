function predicted_frame = motion_vect_predict(prev_frame , motion_vectors , N)

[r,c] = size(prev_frame);
predicted_frame = zeros(r,c);

for i = 1 : N : r
    for j = 1 : N : c
        motion_vect = motion_vectors{ceil(i/N) , ceil(j/N)} ;
        vect_r = motion_vect(1,1);
        vect_c = motion_vect(1,2);
        predicted_frame(i:i+N-1 , j : j + N - 1) = prev_frame( vect_r:vect_r+N-1 , vect_c:vect_c + N - 1  );
        
    end
end
end