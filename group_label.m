function group = group_label(file,sheet)
%GROUP_LABEL Summary of this function goes here
%   file = selected file 
%   sheet = selected sheet 

class_name = {'darmawangi', 'besuki', 'banyuwangi', 'kalituri', 'kanyumas', 'prancak'};
col = size(class_name);
label = xlsread(file,sheet)';
row = size(label);
for i = 1 : row(1)
    for j = 1 : col(2)
        if (label(i)==j)
            group{i} = class_name{j};
        end
    end
end
group = categorical(group)';

end

