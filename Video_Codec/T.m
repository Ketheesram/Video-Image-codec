load('dict_for_p_residuals.mat');

% a = dict_for_p_residuals{1,1};
% 
% sizee = size(b);
% sizee = sizee(1);
r =  23 ;
w = 40 ;

fid1 = fopen('dict.txt','w');

for p = 1 : 10
    
    a = dict_for_p_residuals{1,p};
    
for i = 1 : r
    for j = 1 : w

    b = a{i,j};
    sizee = size(b);
    sizee = sizee(1);
    
for k = 1 : sizee
    fprintf(fid1, num2str(b{k,1}));
    fprintf(fid1,',');
    fprintf(fid1, num2str(b{k,2}));
    fprintf(fid1,',');
end
    fprintf(fid1,'/');
    end
end
    fprintf(fid1,'p');
%     fprintf(fid1,',');
end

fclose(fid1);
%%
% read file
fid2 = fopen('dict.txt');

% break into frames
txt = textscan(fid2,'%s','delimiter','p'); 
framess = txt{1,1};
dict_for_all_frames = cell(1,10);

for u = 1 : 10
frame = framess{u,1};
blocks_in_a_frame = textscan(frame,'%s','delimiter','/');
blocks_in_a_frame = blocks_in_a_frame{1,1};
blocks_in_a_frame = transpose(reshape(blocks_in_a_frame , w,r));


for i = 1 : r
    for j = 1 : w
        t1 = textscan(blocks_in_a_frame{i,j},'%s','delimiter',',');
        t1 = t1{1,1};
        q = size(t1);
        block_in_a_frame = cell(q(1)/2 , 2);
        
        for e = 1 : q(1)
    if rem(e , 2 ) == 0
        block_in_a_frame{e/2,2} = t1{e,1};
    else
         block_in_a_frame{ceil(e/2),1} = t1{e,1};
    end
        end
        blocks_in_a_frame{i,j} = block_in_a_frame;
    end
end
dict_for_all_frames{1,u} = blocks_in_a_frame;
end

%%


