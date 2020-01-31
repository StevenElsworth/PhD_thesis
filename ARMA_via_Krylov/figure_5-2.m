close all
clear all
clc
rng(0)

N = 100;

col = [     0    0.4470    0.7410
       0.8500    0.3250    0.0980
       0.9290    0.6940    0.1250
       0.4940    0.1840    0.5560
       0.4660    0.6740    0.1880
       0.3010    0.7450    0.9330
       0.6350    0.0780    0.1840];

% Build untiary shift matrix L. The eigenvalues of L lie equally spaced on
% the unit circle and the eigenvectors form Fourier basis. Given a vector
% y, the vector Ay shifts each element upwards. (Looks into the future)
A = spdiags([zeros(N,1),ones(N,1)],0:1,N,N); 
A(N, 1) = 1;

[V, D] = eig(full(A));
evals = diag(D);

[evals, I] = sort(evals, 'descend', 'ComparisonMethod', 'real');
evecs = V(:, I);

figure(1)
plot(diag(D), 'rx')
shg()

figure(2)
plot(real(evecs(:, 1)), 'k')
hold on
plot(real(evecs(:, 2)), 'color', col(2, :))
plot(real(evecs(:, 3)), 'color', col(2, :))
plot(real(evecs(:, 4)), 'color', col(3, :))
plot(real(evecs(:, 5)), 'color', col(3, :))
plot(real(evecs(:, 6)), 'color', col(4, :))
plot(real(evecs(:, 7)), 'color', col(4, :))
plot(real(evecs(:, 8)), 'color', col(5, :))
plot(real(evecs(:, 9)), 'color', col(5, :))
shg()

figure(3)
plot(real(evecs(:, N)), 'k')
hold on
plot(real(evecs(:, N-1)), 'color', col(2, :))
plot(real(evecs(:, N-2)), 'color', col(2, :))
plot(real(evecs(:, N-3)), 'color', col(3, :))
plot(real(evecs(:, N-4)), 'color', col(3, :))
plot(real(evecs(:, N-5)), 'color', col(4, :))
plot(real(evecs(:, N-6)), 'color', col(4, :))
plot(real(evecs(:, N-7)), 'color', col(5, :))
plot(real(evecs(:, N-8)), 'color', col(5, :))
shg()

% General shape controlled by roots
e = rand(N, 1);

r1 = rkfun('((z + 1.2)*(z + 1.4))/((z - 1.1)*(z - 1.3))');
b1 = r1(A, e);

r2 = rkfun('((z - 1.2)*(z - 1.4))/((z - 1.1)*(z - 1.3))');
b2 = r2(A, e);

%r3 = rkfun('((z + 1.1)*(z + 1.3))/((z + 1.2)*(z + 1.4))');
%b3 = r3(A, e);

%r4 = rkfun('((z - 1.2)*(z - 1.4))/((z + 1.1)*(z + 1.3))');
%b4 = r4(A, e);


figure(4)
plot(e)
hold on 
plot(b1)
plot(b2)
legend('noise', '+-', '--')



%%

A = spdiags([zeros(N,1),ones(N,1)],0:1,N,N); 

[V, D] = eig(full(A));
evals = diag(D);

[evals, I] = sort(evals, 'descend', 'ComparisonMethod', 'real');
evecs = V(:, I);

figure(5)
plot(diag(D), 'rx')
shg()


r1 = rkfun('((z + 1.2)*(z + 1.4))/((z - 1.1)*(z - 1.3))');
b1 = r1(A, e);

r2 = rkfun('((z - 1.2)*(z - 1.4))/((z - 1.1)*(z - 1.3))');
b2 = r2(A, e);


figure(6)
plot(e)
hold on 
plot(b1)
plot(b2)
legend('noise', '+-', '--')

