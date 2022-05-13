function [theta] = Reg_normalEq(X_train, y_train, lambda)
    L = size(X_train, 2);
    theta = zeros(L, 1);
    I = eye(size(X_train, 2));
    I(1, 1) = 0;
    theta = pinv(X_train'*X_train + lambda.*I)*X_train'*y_train;
end