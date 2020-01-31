close all
clear all
clc
mydefaults
rng(0)

N = 80;

col = [     0    0.4470    0.7410
       0.8500    0.3250    0.0980
       0.9290    0.6940    0.1250
       0.4940    0.1840    0.5560
       0.4660    0.6740    0.1880
       0.3010    0.7450    0.9330
       0.6350    0.0780    0.1840];

A = spdiags([zeros(N,1),ones(N,1)],0:1,N,N); 
A(N, 1) = 1;

[V, D] = eig(full(A));
evals = diag(D);

[evals, I] = sort(evals, 'descend', 'ComparisonMethod', 'real');
evecs = V(:, I);

figure(1)
plot(evals(10:end), 'r*', 'MarkerSize', 8, 'LineWidth', 2)
hold on
th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);
plot(xunit, yunit, 'k');
axis([-1.1, 1.1, -1.1, 1.1])
axis square

plot(complex(evals(1)), 'ko', 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(2), 'o', 'color', col(2, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(3), 'o', 'color', col(2, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(4), 'o', 'color', col(3, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(5), 'o', 'color', col(3, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(6), 'o', 'color', col(4, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(7), 'o', 'color', col(4, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(8), 'o', 'color', col(5, :), 'MarkerSize', 12, 'LineWidth', 3)
plot(evals(9), 'o', 'color', col(5, :), 'MarkerSize', 12, 'LineWidth', 3)
mypdf('evals', 0.71, 1)

figure(2)
plot(real(evecs(:, 1)), 'k', 'LineWidth', 3)
hold on
plot(real(evecs(:, 2)), 'color', col(2, :), 'LineWidth', 3)
plot(real(evecs(:, 3)), 'color', col(2, :), 'LineWidth', 3)
plot(real(evecs(:, 4)), 'color', col(3, :), 'LineWidth', 3)
plot(real(evecs(:, 5)), 'color', col(3, :), 'LineWidth', 3)
plot(real(evecs(:, 6)), 'color', col(4, :), 'LineWidth', 3)
plot(real(evecs(:, 7)), 'color', col(4, :), 'LineWidth', 3)
plot(real(evecs(:, 8)), 'color', col(5, :), 'LineWidth', 3)
plot(real(evecs(:, 9)), 'color', col(5, :), 'LineWidth', 3)
mypdf('evecs', 0.71, 1)

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


% General shape controlled by roots
e = rand(N, 1);

% r1 = rkfun('((z + 1.2)*(z + 1.4))/((z - 1.1)*(z - 1.3))');
% b1 = r1(A, e);
% 
% r2 = rkfun('((z + 4)*(z + 3))/((z - 6)*(z - 5))');
% b2 = r2(A, e);

e = rand(N, 1);

r1 = rkfun('((z + 4)*(z + 4))/((z - 1.1)*(z - 1.3))');
b1 = r1(A, e);

r2 = rkfun('((z + 4)*(z + 4))/((z - 6)*(z - 5))');
b2 = r2(A, e);

figure(4)
plot(e)
hold on 
plot(b1)
axis([0, 80, 0, 450])
legend({'noise', 'time series'}, 'Location', 'northoutside', 'Orientation', 'horizontal')
mypdf('smooth', 0.71, 1)

figure(5)
plot(e)
hold on 
plot(b2)
axis([0, 80, 0, 1.05])
legend({'noise', 'time series'}, 'Location', 'northoutside', 'Orientation', 'horizontal')
mypdf('noisy', 0.71, 1)