function decoded = huff_deco(r ,c ,N , comp, dict)

decoded = zeros(r , c);


for i = 1 : r/N
    for j = 1 : c/N
        
        input_dic = dict{i,j};
        input_code = comp{i,j} ;
        decoded((i-1)*8 + 1 : (i-1)*8+8 , (j-1)*8 + 1 : (j-1)*8+8) =  reshape(huffmandeco(input_code , input_dic),[N,N]);

    end
end
end

