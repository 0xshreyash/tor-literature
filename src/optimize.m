function optimize
    for i=2:50
        output = zeros(50,1);
        for j=1:50
            output(j) = start_optimize(i);
        end
        dlmwrite('output-50.csv',max(output),'delimiter',',','-append');
    end
end

function ret_val = start_optimize(n_val)

global n

setGlobaln(n_val);


fun = @(x) -x(3*n+1);


A = zeros(6*n, 3*n+1);
b = zeros(6*n, 1);

for i=1:3*n
    A(i, i) = -1;
    A(i, 3 * n + 1) = 1;
    A(3 * n + i, i) = 1;
    A(3 * n + i, 3 * n + 1) = 1;
    b(3 * n + i) = 1;
end

% disp(A);
% disp(b);


Aeq = [];
beq = [];
lb = [];
ub = [];
options = optimoptions('fmincon', 'Algorithm', 'sqp', 'MaxFunctionEvaluation', 25000000);

x0 = zeros(3*n+1,1);

for i=1:3*n+1
    x0(i) = rand;
end
x0(3*n+1) = 0;

% disp(x0);
cons = @nonlcon;
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,cons,options);

ret_val = x(3*n+1);

end

% A = [1,0,0,0,0,0; 0,1,0,0,0,0; 0,0,1,0,0,0; 0,0,0,1,0,0; 0,0,0,0,1,0; 0,0,0,0,0,1;
%     -1,0,0,0,0,0; 0,-1,0,0,0,0; 0,0,-1,0,0,0; 0,0,0,-1,0,0; 0,0,0,0,-1,0; 0,0,0,0,0,-1];

function [c, ceq] = nonlcon(x)
n = getGlobaln;
count = 1;
for i=1:3:(3*n)
    j = 3 + i;
    while j < 3 * n
        c(count) = -sqrt((x(i)-x(j))^2 + (x(i+1)-x(j+1))^2 + (x(i+2)-x(j+2))^2) + 2*x(3*n+1);
        count = count + 1;
        j = j + 3;
    end
end
ceq = [];
end


function r = getGlobaln
global n
r = n;
end

function setGlobaln(val)
global n
n = val;
end