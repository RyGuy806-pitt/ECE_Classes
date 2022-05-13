%Problem 0%
%initialize
delete ./input/train*.pgm
all = genpath('C:\Users\ryguy\OneDrive\Desktop\ECE1395\ps5_Hankee_Ryan\input\all\att_faces');
list = {};
leave = false;
count = 0;
%parse
remain = all;
while(1)
    [one, remain] = strtok(remain, ';');
    if(isempty(one) == 1)
       leave = true ;
    end
    
    if(leave)
        break
    end
    list = [list one];
end
list_s = size(list, 2);

for i = 1:list_s
   folder = list{i}; %pick a location
   fold = folder(14:end);
   cfold = char(fold);
   tak = str2num(cfold);
   
   %appropriate name
   cat = sprintf('C:\\Users\\ryguy\\OneDrive\\Desktop\\ECE1395\\ps5_Hankee_Ryan\\input\\test\\s%d', fold);
   
   %create
   if not(isfolder(cat)) 
    mkdir(cat);
    %rmdir C:Users\ryguy\OneDrive\Desktop\ECE1395\ps5_Hankee_Ryan\input\test\s
   end
   
   PGMN = sprintf('%s/*.pgm', folder);
   standard = dir(PGMN);
   list2_s = size(PGMN, 2);
   
   if(list_s ~= 0)
       toTrain = randperm(list_s, 8);
       total = [1 2 3 4 5 6 7 8 9 10];
       log = ismember(total, toTrain);
       
       for a = 1:10
          if(log(a)==0)
             count = count + 1;
             toTest(count) = a;
          end
       end
       
       for j = 1:8
            pgmfn = standard(toTrain(j)).name;
            complete = fullfile(folder, pgmfn);
            %Write
            step1 = sprintf('\\input\\train\\%d.pgm', j);
            step2 = char(step1);
            R = imread(step2);
            imwrite(R, step2);
       end
       
       for k = 1:2
           pgmfn = standard(toTest(j)).name;
           complete = fillfile(folder, pgmfn);
           %Write
            step1 = sprintf('\\input\\test\\s%d\\%d.pgm', folder, k);
            step2 = char(step1);
            R = imread(step2);
            imwrite(R, step2);
       end
   end
end