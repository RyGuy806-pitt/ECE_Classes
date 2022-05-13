%Problem 1a%
AdmissionData = dlmread('hw3_data1.txt');
NotIn = ones(40, 3);
GotIn = ones(60, 3);
X_a = AdmissionData(:, 1:2);
y_a = AdmissionData(:, 3);
%Problem 1b%
countIn = 0;
countOut = 0;

for AD = 1:1:100
   if(y_a(AD, 1) == 1)
      countIn= countIn + 1;
      GotIn(countIn, :) = AdmissionData(AD,:); 
   else
      countOut= countOut + 1;
      NotIn(countOut,:) = AdmissionData(AD,:);
   end
end
X_a_1 = GotIn(:, 1);
X_a_2 = NotIn(:, 1);
Y_a_1 = GotIn(:, 2);
Y_a_2 = NotIn(:, 2);

scatter(X_a_1, Y_a_1, 'green');
hold on;
scatter(X_a_2, Y_a_2, 'red');
hold off;
%Problem 1c%
[r, c] = size(AdmissionData);
Percent = .9;
RN = randperm(r);
Test = AdmissionData(RN(round(Percent*r)+1:end),:);
Train = AdmissionData(RN(1:round(Percent*r)),:);
X_test(:,1) = Test(:,1);
X_test(:,2) = Test(:,2);
y_test(:,1) = Test(:,3);
X_train(:,1) = Train(:,1);
X_train(:,2) = Train(:,2);
y_train(:,1) = Train(:,3);
%Problem 1d%
z = [-10:10];
g = sigmoid(z);
scatter(z, g);
%Problem 1e%
toySet = [0 1 0; 0 3 1; 2 0 0; 2 1 1];
X_e = toySet(:, 1:2);
add = ones(size(toySet,1),1);
X_e_1 = [add, X_e];
y_e_1 = toySet(:, 3);
theta_e_1 = [0 0 0]';
[J, grad] = costFunction(theta_e_1, X_e_1, y_e_1);
%Problem 1f%
options = optimset('GradObj', 'on', 'MaxIter', 400);
initial_theta = theta_e_1;
addf = ones(size(X_train,1),1);
X_train_f = [addf, X_train];
[theta_f_1, cost_f_1] = fminunc(@(t)(costFunction(t, X_train_f, y_train)), initial_theta, options);
%Problem 1g%
g_f = X_train_f * theta_f_1;
x_g = [1:115];
y_g = -x_g + 115;
scatter(X_a_1, Y_a_1, 'green');
hold on;
line(x_g, y_g);
scatter(X_a_2, Y_a_2, 'red');
hold off;
%Problem 1h%
addh = ones(size(X_test,1), 1);
X_test_h = [addh, X_test];
theta_h_1 = theta_f_1;
y_pred_h = X_test_h * theta_h_1;
correct = 0;
for i = 1:size(X_test,1)
    if((y_pred_h(i, 1) > 0) && (y_test(i, 1) == 1))
       correct = correct + 1;
    elseif((y_pred_h(i, 1) < 0) && (y_test(i, 1) == 0))
        correct = correct + 1;
    end
end
accuracy = (correct/(size(y_test,1)));
%Problem 1i%
i_1 = [1 50 75] * theta_h_1;

%Problem 2a%
profit_stats = load('hw3_data2.mat');
[r, c] = size(profit_stats.data);
Percent = .9;
RN = randperm(r);
Test_2 = profit_stats.data(RN(round(Percent*r)+1:end),:);
Train_2 = profit_stats.data(RN(1:round(Percent*r)),:);
X_test_2(:,1) = Test_2(:,1);
y_test_2(:,1) = Test_2(:,2);
X_train_2(:,1) = Train_2(:,1);
y_train_2(:,1) = Train_2(:,2);
adda = ones(size(X_train_2, 1), 1);
X_train_2_sq = X_train_2.^2;
X_train_2_a = [adda, X_train_2, X_train_2_sq];
[Ntheta2] = normalEqn(X_train_2_a, y_train_2);
adda2 = ones(size(X_test_2, 1), 1);
X_test_2_sq = X_test_2.^2;
X_test_2_a = [adda2, X_test_2, X_test_2_sq];
NCost2 = computeCost(X_test_2_a, y_test_2, Ntheta2);
scatter(X_train_2, y_train_2);
hold on;
x = (500:1000);
for j = 1:500
    y(j) = [x(j)^0 x(j) x(j)^2] * Ntheta2;
end
line(x, y);
hold off;