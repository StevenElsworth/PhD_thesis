close all
clear all
clc
rng(0)

N = 100;

% Construct time series
A = spdiags([zeros(N,1),ones(N,1)],0:1,N,N); % Shifts upwards
A(N, 1) = 1;
e = randn(N,1);

r = rkfun('((z + 4)*(z + 4))/((z - 1.1)*(z - 1.3))'); % roots and poles lie outside unit circle
b = r(A, e);




% OLS
L = spdiags([zeros(size(b,1),1),ones(size(b,1),1)],0:1,size(b,1),size(b,1)); 
M = [L*b, b, L^2*b];
[1; -pinv(M(1:end-2, 1:2))*M(1:end-2,3)]'

% Charpoly
A = spdiags([zeros(size(b,1),1),ones(size(b,1),1)],0:1,size(b,1),size(b,1)); 
D = zeros(length(b),length(b));            
D(1:length(b)-2, 1:length(b)-2) = eye(length(b)-2);
param.inner_product = @(x, y) y'*D*x; 
[V, K, H, out] = rat_krylov(A, b, [inf, inf], param); 
poly(eig(H(1:end-1,:), K(1:end-1,:)))

% RKFUN
A = spdiags([zeros(size(b,1),1),ones(size(b,1),1)],0:1,size(b,1),size(b,1)); 
param.balance = 0;                      
D = diag([ones(1,length(b)-2), 0, 0]);
param.inner_product = @(x, y) y'*D*x; 
[~, K, H, out] = rat_krylov(A, b, [inf, inf], param);                            
C = zeros(3, 1);
C(3,1) = (-1)^2 * prod(diag(H, -1)); 
p = rkfun(K, H, C);

C2 = p(0, 1)
C1 = p(1, 1) - C2 - 1


p(0, 1/out.R(1,1))