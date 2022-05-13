function [theta, cost] = gradientDescent(X_train, y_train, alpha, iters)
    L = length(y_train);
    cx = size(X_train, 2);
    cost = zeros(iters, 1);
    theta = randi([-1, 1], cx, 1);
    for l00p = 1:1:iters
       temp1 = X_train*theta-y_train;
       temp2 = sum(temp1.*X_train);
       theta = theta - ((alpha*1/L)*temp2');
       cost(l00p) = computeCost(X_train, y_train, theta);
    end
end