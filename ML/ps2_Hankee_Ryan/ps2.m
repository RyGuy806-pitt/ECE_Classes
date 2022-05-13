%Problem 1%
%general format h = theta0 + theta1*x1 + theta2*x2
x0 = [1 1 1 1]';
x1 = [1 2 3 4]';
x2 = [1 2 3 4]';
X = [x0 x1 x2];
y = [2 4 6 8]';
thetai = [0 1 0.5]';
thetaii = [3.5 0 0]';
theta = [thetai, thetaii];
computeCost(X, y, theta);
z = X*theta;
z2 = z - y;
%Problem 2%
[thetas, costs] = gradientDescent(X, y, .001, 15);
%Problem 3%
[Ntheta] = normalEqn(X, y);
%Problem 4%
IData = csvread('hw2_data1.csv');
prices = IData(:,1);
HP = IData(:,2);
con = ones(size(IData,1),1);
%scatter(prices, HP);
IData = [con, IData];
[r, c] = size(IData);
Percent = .9;
RN = randperm(r);
Test = IData(RN(round(Percent*r)+1:end),:);
Train = IData(RN(1:round(Percent*r)),:);
X_test(:,1) = Test(:,1);
X_test(:,2) = Test(:,2);
y_test(:,1) = Test(:,3);
X_train(:,1) = Train(:,1);
X_train(:,2) = Train(:,2);
y_train(:,1) = Train(:,3);
[theta4, cost4] = gradientDescent(X_train, y_train, .3, 500);
ypl = (1:size(cost4))';
%plot(cost4, ypl);
CCost4 = computeCost(X_test, y_test, theta4);
[Ntheta4] = normalEqn(X_test, y_test);
NCost4 = computeCost(X_test, y_test, Ntheta4);
%alpha = .001, .003, .03, 3
[theta4h1, cost4h1] = gradientDescent(X_train, y_train, .001, 300);
yplh1 = (1:size(cost4h1))';
%plot(cost4h1, yplh1);
[theta4h2, cost4h2] = gradientDescent(X_train, y_train, .003, 300);
yplh2 = (1:size(cost4h2))';
%plot(cost4h2, yplh2);
[theta4h3, cost4h3] = gradientDescent(X_train, y_train, .03, 300);
yplh3 = (1:size(cost4h3))';
%plot(cost4h3, yplh3);
[theta4h4, cost4h4] = gradientDescent(X_train, y_train, 3, 300);
yplh4 = (1:size(cost4h4))';
%plot(cost4h4, yplh4);
%Problem 5%
HouseData = dlmread('hw2_data2.txt');
HouseMean = mean(HouseData);
HouseSTD = std(HouseData);
HouseStandard = HouseData;
for house = 1:size(HouseData, 1)
    HouseStandard(house, :) = (HouseData(house,:)-HouseMean)/(HouseSTD);
end
apd = ones(size(HouseData, 1), 1);
HouseStanApd = [apd, HouseStandard];
X_train5 = HouseStanApd(:, 1:3);
y_train5 = HouseStanApd(:, 4);
[theta5, cost5] = gradientDescent(X_train5, y_train5, .01, 750);
ypl5 = (1:size(cost5))';
plot(cost5, ypl5);
