function [dict , encoded ] = huff_enco(img, N)

[rows,cols] = size(img);
encoded = cell(rows/N , cols/N);
dict = cell(rows/N , cols/N);

for i = 1 : N : rows
    for j = 1 : N : cols
       
        img1 = img(i:i+N-1 , j:j+N-1);
        
        if nnz(img1) == 0
            img1(1,1) = 1;
            [g , ~ , Intensity_val] = grp2idx(img1(:));
            Frequency = accumarray(g,1);
            probability = Frequency./(N*N) ;
            [dict1,avglen] = huffmandict(Intensity_val,probability);
            encoded{floor(i/N)+1,floor(j/N)+1} = huffmanenco(img1(:) , dict1);
            dict{floor(i/N)+1,floor(j/N)+1} =dict1;
        else
            [g , ~ , Intensity_val] = grp2idx(img1(:));
            Frequency = accumarray(g,1);
            probability = Frequency./(N*N) ;
            [dict1,avglen] = huffmandict(Intensity_val,probability);
            encoded{floor(i/N)+1,floor(j/N)+1} = huffmanenco(img1(:) , dict1);
            dict{floor(i/N)+1,floor(j/N)+1} =dict1;
            

        end
    
    end
    
end
end