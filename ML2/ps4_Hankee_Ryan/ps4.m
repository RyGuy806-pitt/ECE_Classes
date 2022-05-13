%Problem 1%
%{
M1a = load('hw4_data1.mat');
X1a = M1a.X_data;
y1a = M1a.y;
x1b = ones(size(X1a, 1), 1);
X1b = [x1b, X1a];
thetatest = Reg_normalEq(X1b, y1a, .01);
%Combine X and y
M1c = [X1b, y1a];
[r, c] = size(M1c);
Percent = .88;
lambda1c = [0 0.001 0.003 0.005 0.007 0.009 0.012 0.017];
%Looped content
for c1c = 1:20
RN = randperm(r);
Test1c = M1c(RN(round(Percent*r)+1:end),:);
Train1c = M1c(RN(1:round(Percent*r)),:);
X_Train1c = Train1c(:,1:c-1);
X_Test1c = Test1c(:, 1:c-1);
y_Train1c = Train1c(:, c);
y_Test1c = Test1c(:, c);
    for L1c = 1:8
        theta1c(L1c, :) = Reg_normalEq(X_Train1c, y_Train1c, lambda1c(L1c));
        theta1c2 = theta1c';
        error1c(c1c, L1c) = computeCost(X_Train1c, y_Train1c, theta1c2(:, L1c));
        theta1cT(L1c, :) = Reg_normalEq(X_Test1c, y_Test1c, lambda1c(L1c));
        theta1c2T = theta1cT';
        error1cT(c1c, L1c) = computeCost(X_Test1c, y_Test1c, theta1c2T(:, L1c));
    end
end
    for A = 1:8
        aveTr = 0;
        aveTe = 0;
        for B = 1:20
           aveTr = aveTr + error1c(B, A);
           aveTe = aveTe + error1cT(B, A);
        end
        AveErrTr(1, A) = aveTr/20;
        AveErrTe(1, A) = aveTe/20;
    end
plot(lambda1c, AveErrTe, 'green', lambda1c, AveErrTr, 'red' );
%}
%Problem 2%
M2a = load('hw4_data2.mat');
X_Train2a = [M2a.X1;M2a.X2;M2a.X3;M2a.X4];
y_Train2a = [M2a.y1;M2a.y2;M2a.y3;M2a.y4];
X_Test2a = M2a.X5;
y_Test2a = M2a.y5;

X_Train2b = [M2a.X5;M2a.X2;M2a.X3;M2a.X4];
y_Train2b = [M2a.y5;M2a.y2;M2a.y3;M2a.y4];
X_Test2b = M2a.X1;
y_Test2b = M2a.y1;

X_Train2c = [M2a.X1;M2a.X5;M2a.X3;M2a.X4];
y_Train2c = [M2a.y1;M2a.y5;M2a.y3;M2a.y4];
X_Test2c = M2a.X2;
y_Test2c = M2a.y2;
    
X_Train2d = [M2a.X1;M2a.X2;M2a.X5;M2a.X4];
y_Train2d = [M2a.y1;M2a.y2;M2a.y5;M2a.y4];
X_Test2d = M2a.X3;
y_Test2d = M2a.y3;

X_Train2e = [M2a.X1;M2a.X2;M2a.X3;M2a.X5];
y_Train2e = [M2a.y1;M2a.y2;M2a.y3;M2a.y5];
X_Test2e = M2a.X4;
y_Test2e = M2a.y4;

mdl1 = fitcknn(X_Train2a, y_Train2a);
ypreda = predict(mdl1, X_Test2a);