function [motion_vectors,sad_vals] = sad(frame1 , frame2 ,N)

[r,c] = size(frame1);
motion_vectors = cell(r/N , c/N);
sad_vals = cell(r/N , c/N);

for i = 1 : N : r
    for j = 1 : N : c
        frame2_block = frame2(i: i +N-1 , j : j + N-1);
        previous_sum_abs_diff = 16320 ; 
        motion_vect = zeros(1,2);
%         disp('____________');
%         disp(previous_sum_abs_diff);
        for k = 1 : N : r
            for m = 1 : N : c
                
                   
                frame1_block = frame1(k : k + N-1 , m : m + N-1);
                diff = abs(double(frame2_block) - double(frame1_block)) ;
                sum_abs_diff = sum(diff(:));
                
                if (sum_abs_diff < previous_sum_abs_diff)
                previous_sum_abs_diff = sum_abs_diff ; 
                motion_vect(1,1) = k ;
                motion_vect(1,2) = m ;
                end
             
                
            end
        end
        sad_vals{ceil(i/N) , ceil(j/N)} = previous_sum_abs_diff ; 
        motion_vectors{ceil(i/N) , ceil(j/N)} = motion_vect;
    end
end

end