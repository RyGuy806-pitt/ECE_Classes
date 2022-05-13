%Problem_3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = .6;
b = 1.5;
x = m.*randn(1000000, 1) + b;
z = -2 + (2+2)*rand(1000000, 1);
%h1 = histogram(x); c1
%h2 = histogram(z); c2

s = size(x);
tic
for i = 1:1:s
   x(i, 1) = x(i, 1) + 1; 
end
toc

f = @() x + 1;
t1 = timeit(f);
c = 0;

for j = 1:1:s
    if(z(j, 1) < .5)
            c = c + 1;
    end
end

y = rand(c, 1);
c2 = 0;
for j2 = 1:1:s
    if(z(j2, 1) < .5)
        c2 = c2 + 1;
        y(c2) = z(j2, 1);
    end
end
%Problem_4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [2 1 3; 2 6 8; 6 8 18];
minEachColumn = min(A, [], 2);
maxEachRow = max(A, [], 2);
minA = min(A, [], 'all');
SumRows = sum(A, 2);
SumA = sum(A, 'all');
B = A.^2;

%2x+y+3z=1
%2x+6y+8z=3
%6x+8y+18z=5

ValueMatrix = [2 1 3; 2 6 8; 6 8 18];
ResultMatrix = [1; 3; 5];
xMatrix = inv(ValueMatrix)*ResultMatrix;

x1 = [.5 0 -1.5];
x2 = [1 -1 0];
L1x1 = norm(x1, 1);
L2x1 = norm(x1, 2);
L1x2 = norm(x2, 1);
L2x2 = norm(x2, 2);

normalize_Col(ValueMatrix);
normalize_Col([2 1 3 4; 2 6 8 12; 6 8 18 34]);

function [B] = normalize_Col(A)
    B = normalize(A, 1);
    disp(B);
end
