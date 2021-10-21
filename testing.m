clc, close all, clear all;
%% load label...

[y, label] = xlsread('raw_data.xlsx','label');
selected_label = label(1:100);
%% load training data...
raw_training = xlsread('raw_data.xlsx','training');

co = raw_training(:,1);
no = raw_training(:,2);
coo = raw_training(:,3);

T = table(label,co,no,coo);
TF = (strcmp(T.label,'darmawangi')|strcmp(T.label,'besuki'));
T_selected = T(TF,:);

figure(1)
h = gscatter(T_selected.co,T_selected.no,T_selected.label,'rb','v^',[],'off');
set(h,'LineWidth',2);xlabel('sensor co'); ylabel('sensor no');


%% Apply Linear LDA
md1 = fitcdiscr([T_selected.co T_selected.no],T_selected.label,'discrimtype','linear');

%% Visualize the classification
[L,W] = meshgrid(linspace(100,700,100),linspace(0,1000,100));

L = L(:);
W = W(:);
pred = md1.predict([L W]);
h = gscatter(L,W,pred,'rb','.',1,'off');
set(h,'LineWidth',2,'MarkerSize',2)
hold on;
h = gscatter(T_selected.co,T_selected.no,T_selected.label,'rb','v^',[],'off');
set(h,'LineWidth',2);xlabel('sensor co'); ylabel('sensor no');
hold off;

% or 

hold on; 
A = md1.Coeffs(1,2).Linear;
B = md1.Coeffs(1,2).Const;
h = ezplot(@(x,y) [x y]*A+B,[100 700 0 1000]);title("");
set(h,'Color','m','LineWidth',2);xlabel('sensor co'); ylabel('sensor no');
hold off;

%% load testing data...
raw_testing = xlsread('raw_data.xlsx','testing')';

co_testing = raw_testing(:,1);
no_testing = raw_testing(:,2);
coo_testing = raw_testing(:,3);

T_testing = table(label,co,no,coo);
TF_testing = (T_testing.label=='darmawangi')|(T_testing.label=='besuki');
T_testing_selected = T_testing(TF_testing,:);

%% prediction 

pred = md1.predict([T_testing_selected.co T_testing_selected.no]);
Ibad = ~strcmp(pred,T_testing_selected.label);
missclassificationrate = sum(Ibad)/numel(T_testing_selected.label)
figure(2)
[confusionmatrix,matrixlabels] = confusionmat(selected_label,pred);
cm = confusionchart(T_testing_selected.label,pred);
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

