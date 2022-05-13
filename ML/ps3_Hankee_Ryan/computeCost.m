function CC = computeCost(X, y, theta)
    L = length(y);
    CC = (1/(2*L)) * sum((X*theta-y).^2, 1);
end