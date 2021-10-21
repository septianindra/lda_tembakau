clc; clear all; close all ;
%% Load data
[ndata, text, X] = xlsread('raw_data.xlsx','training'); % memanggil data excel training
[~, y] = xlsread('raw_data.xlsx','label'); % memanggil label dari tiap data
target_name = {'darmawangi';'besuki';'banyuwangi';'kalituri';'kanyumas';'prancak'}; % merupakan label tiap kelas
testing_data = xlsread('raw_data.xlsx','testing');

[row1,~] = size(target_name); %row1 merupakan banyaknya kelas
[row2,col2] = size(ndata); %row2 merupakan banyaknya data ciri; col2 merupakan nilai yang dipakai untuk penyesuaian matriks pada perhitungan 

n = row2/row1; %n merupakan banyaknya data ciri tiap kelas

% init

class_feature_mean = zeros(6,3);
data_min_cfm = zeros(300,3);
between_class_scatter_matrix = cell([1 6]);
within_class_scatter_matrix = cell([300 1]);
between_class = zeros(3,3);
within_class_scatter = zeros(3,3);

%% between-class scatter matrix

% menghitung rata - rata seluruh ciri 
for i = 1:col2
    xmean(i) = mean(ndata(:,i)); 
end

% menghitung rata - rata seluruh ciri tiap kelas
df = [text {'class'};num2cell(ndata) y]; % pengelompokan data ciri dan label

for i = 1 : row1 % looping 1 - 6
    for j = 1 : row2 % looping 1 - 300
        if (isequal(target_name{i},df{j+1,4})) 
            class_feature_mean(i,1) = class_feature_mean(i,1)+df{j+1,1};
            class_feature_mean(i,2) = class_feature_mean(i,2)+df{j+1,2};
            class_feature_mean(i,3) = class_feature_mean(i,3)+df{j+1,3};
        end
    end
end
class_feature_mean = class_feature_mean/(row2/row1);

% menghitung sb tiap kelas
for i = 1:row1
    between_class_scatter_matrix{i} = 50*((class_feature_mean(i,:)- xmean).*(class_feature_mean(i,:) - xmean)');
    between_class = between_class + between_class_scatter_matrix{i};
end

%% within-class scatter matrix

for i = 1 : row1
    for j = 1 : row2
        if (isequal(target_name{i},df{j+1,4}))
            data_min_cfm(j,:) = ndata(j,:) - class_feature_mean(i,:);
            within_class_scatter_matrix{j} = data_min_cfm(j,:).* data_min_cfm(j,:)';
            within_class_scatter = within_class_scatter + within_class_scatter_matrix{j};
        end
    end
end

%% eigenvalue, eigenvector 
[eigen_vectors,eigen_values] = eig(inv(within_class_scatter)*(between_class)); % nilai eigen vector dan nilai eigen value

[d,ind] = sort(diag(eigen_values),'descend'); % mengurutkan dari yang terbesar

Ds = eigen_values(ind,ind) % eigen value 
Vs = eigen_vectors(:,ind) % eigen vector

w_matrix = [Vs(:,1) Vs(:,2)]; 


%% new plane
X_lda = ndata*w_matrix;

%% plotting result
T = table(y,X_lda);
TF = (strcmp(T.y,'darmawangi')|strcmp(T.y,'besuki'));
T_selected = T(TF,:);

figure(1)
h = gscatter(X_lda(:,1),X_lda(:,2),y,'krbgmc','ov^+xs');
set(h,'LineWidth',2);xlabel('new plane x'); ylabel('new plane y');
hold on

MdlLinear = fitcdiscr(X_lda,y);

for i = 1:6
    MdlLinear.ClassNames([3 i])
    K = MdlLinear.Coeffs(3,i).Const  
    L = MdlLinear.Coeffs(3,i).Linear

    f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
    h(i) = fimplicit(f,[-750 -100 0 1000]);
 
    h(i).LineWidth = 2;
    h(i).DisplayName = ['Boundary between ' ans{1} '&' ans{2}];
end
hold off
%% Classification Error

pred = MdlLinear.predict(X_lda);
Ibad = ~strcmp(pred,y);

miss_classification_rate = sum(Ibad)/numel(y)
figure(2)
cm = confusionchart(y,pred)

cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

% figure(1)
% h = gscatter(T_selected.X_lda(:,1),T_selected.X_lda(:,2),T_selected.y);
% set(h,'LineWidth',2);xlabel('new plane x'); ylabel('new plane y');
% % 
% %% Apply Linear LDA
% md1 = fitcdiscr([T_selected.X_lda(:,1) T_selected.X_lda(:,2)],T_selected.y,'discrimtype','linear');
% 
% %% Visualize the classification
% [L,W] = meshgrid(linspace(0,700,100),linspace(0,1000,100));
% 
% L = L(:);
% W = W(:);
% pred = md1.predict([L W]);
% 
% figure(2)
% h = gscatter(L,W,pred,'rb','.',1,'off');
% set(h,'LineWidth',2,'MarkerSize',2);legend('kanyumas','besuki');
% hold on;
% h = gscatter(T_selected.X_lda(:,1),T_selected.X_lda(:,2),T_selected.y,'rb','v^',[],'off');
% set(h,'LineWidth',2);xlabel('new plane x'); ylabel('new plane y');
% 
% % or 
% md1.ClassNames([1,2])
% A = md1.Coeffs(1,2).Linear;
% B = md1.Coeffs(1,2).Const;
% h = ezplot(@(x,y) [x y]*A+B,[0 700 0 1000]);title("");
% set(h,'LineWidth',2);xlabel('new plane x'); ylabel('new plane y');legend('linear');
% hold off;
% 
% %%
% 
% figure(3)
% h = gscatter(T.X_lda(:,1),T.X_lda(:,2),T.y);
% set(h,'LineWidth',2);xlabel('new plane x'); ylabel('new plane y');
% 
% %%
% 
% 
% 
