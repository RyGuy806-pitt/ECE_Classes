function [theta] = normalEqn(X_train, y_train)
    L = size(X_train, 2);
    theta = zeros(L, 1);
    theta = pinv(X_train'*X_train)*X_train'*y_train;
end