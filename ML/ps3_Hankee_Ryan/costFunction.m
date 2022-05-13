function [J, grad] = costFunction(theta, X_train, y_train)
J = 0;
grad = ones(size(theta));
L = length(y_train);

z = X_train * theta;
g = sigmoid(z);

J = ((-y_train'*log(g)) - ((1-y_train)' * log(1-g)))/L;
grad = ((g - y_train)'*X_train)/L;
end