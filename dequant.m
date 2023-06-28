function dequantized = dequant(N , decoded,q_table)

[r,c] = size(decoded);
dequantized = zeros(r,c);


for k = 1 : N : r
    for p = 1 :N: c
        img  = decoded(k:k+N-1 , p:p+N-1);
        temp = zeros(N,N ) ;
        
        for i = 1 : N
            for j = 1 :N
                 temp(i,j) = img(i,j) * q_table(i,j);
                
    end
        end

        dequantized(k:k+N-1 ,p:p+N-1) = temp ;
    end
end

end