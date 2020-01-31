close all
clear all
clc
rng(0)

N = 100;

% Construct time series
A = spdiags([zeros(N,1),ones(N,1)],0:1,N,N); % Shifts upwards
A(N, 1) = 1;

e = randn(N,2);
% Construct MA model model and approximate by small order VAR.
b = A^3*e*rand(2) + A^2*e*rand(2) + A*e*rand(2) + e*rand(2);


% OLS
L = spdiags([zeros(size(b,1),1),ones(size(b,1),1)],0:1,size(b,1),size(b,1)); 
M = [L*b, b, L^2*b];
p = -pinv(M(1:end-2, 1:4))*M(1:end-2, 5:6)
C1 = p(3:4, :)
C2 = p(1:2, :)

% BRKFUN
L = spdiags([zeros(size(b,1),1),ones(size(b,1),1)],0:1,size(b,1),size(b,1)); 
param.balance = 0;                      
D = diag([ones(1,length(b)-2), 0, 0]);
param.inner_product = @(x, y) y'*D*x; 
[~, K, H, out] = rat_krylov(L, b, [inf, inf], param);                            
C{1} = zeros(2);
C{2} = zeros(2);
C{3} = (-1)^2 *H(5:6, 3:4)*H(3:4, 1:2)*out.R(1:2,1:2); 
%C{3} = (-1)^2 *H(5:6, 3:4)*H(3:4, 1:2); 
p = rkfunb(K, H, C);

C1 = p(zeros(2), eye(2)*inv(out.R(1:2,1:2)))
C2 = p(eye(2), eye(2)*inv(out.R(1:2,1:2))) - C1 - eye(2)
%C1 = p(zeros(2), eye(2))
%C2 = p(eye(2), eye(2)) - C1 - eye(2)