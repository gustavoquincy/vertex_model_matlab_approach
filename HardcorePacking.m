%seed control
rng('default')

width = 100;
height = 100;
max = width.*height;
inside_box = 1;
count = 0;
X = [width/2,height/2];
while inside_box <= max
    count = count+1;
    v = [width.*rand, height.*rand];
    flag = true;
    for i = 1:inside_box
        %brutal here since it compare norm2 with all extant points in the
        %box
        if norm(v-X(i,:))<1
            flag = false;
            break
        end
    end
    if flag == true
        inside_box = inside_box+1;
        X = [X;v];   
    end
    if count >1e5
        break
    end
end
save('./HardcorePackingData/HardPacking100.mat','X','width','height')

     
    