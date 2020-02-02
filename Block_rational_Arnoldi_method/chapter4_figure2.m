clc
mydefaults
r = .71;
s = 5;
fontsize = 20;
set(0,'defaulttextinterpreter','latex')

% Import time series, E1 from book, see Example 3.2.3
% http://www.jmulti.de/data_imtsa.html
import = importdata('e1.dat.txt');

orig_b = import.data;
% Take difference of log of data (removes trend), note first datapoint is 
% lost due to differencing
log_b = log(orig_b);
all_b = diff(log_b); 

% As p=2, keep the first two observations of differenced series as
% presampled values. Keep them inside b but do not use for evaluating mean.
b = all_b(1:75, :); 
mu = mean(b(3:end,:)) % Example 3.3.5, Equation 3.3.20

b = b - ones(length(b),1)*mu; % mean center the time series

% Construct VAR(2) model using block rational Krylov spaces
A = spdiags([zeros(size(b,1),1),ones(size(b,1),1)],0:1,size(b,1),size(b,1)); 
xi_ = inf*ones(1, 2);
D = zeros(75,75); D(1:73, 1:73) = eye(73);
param.balance = 0;
param.inner_product = @(x, y) y'*D*x;
[V, K, H, out] = rat_krylov(A, b, xi_, param);
R = out.R(1:3, 1:3);

C{1} = zeros(3);
C{2} = zeros(3);
C{3} = H(7:9, 4:6)*H(4:6, 1:3)*R;

r_ = rkfunb(K, H, C);


% Make some predictions using model, Example 3.5.3, Equation 3.5.16
y_tminus1 = b(end-1, :) + mu
y_t = b(end, :) + mu

Ahat = [0, 1; 0, 0];
bhat = b(end-1: end, :);

pred1 = -r_(Ahat, bhat*inv(R));
prediction_1 = pred1(end-1,:) + mu

bhat = [bhat(2:end, :); prediction_1 - mu];
pred2 = -r_(Ahat, bhat*inv(R));
prediction_2 = pred2(end-1,:) + mu


%% Recreate Fig 3.3

bhat = b(end-1: end, :);
predictions = [];
for i = 1:5
    pred = -r_(Ahat, bhat*inv(R));
    predictions = [predictions; pred(end-1, :)];
    bhat = [bhat(2:end, :); pred(end-1, :)];
end

predictions = predictions + mu;

figure
hold on
p1 = plot(all_b(1:80, 1), 'Color', [0, 0.4470, 0.7410]);
plot(75:80, [all_b(75, 1); predictions(:, 1)], 'Color', [0, 0.4470, 0.7410], 'LineStyle', '--')
p2 = plot(all_b(1:80, 2), 'Color', [0.85, 0.3250, 0.0980]);
plot(75:80, [all_b(75, 2); predictions(:, 2)], 'Color', [0.85, 0.3250, 0.0980], 'LineStyle', '--')
p3 = plot(all_b(1:80, 3), 'Color', [0.9290, 0.6940, 0.1250]);
plot(75:80, [all_b(75, 3); predictions(:, 3)], 'Color', [0.9290, 0.6940, 0.1250], 'LineStyle', '--')
axis([60,80, -0.1, 0.1])
pbaspect([2 1 1])
legend([p1, p2, p3], {'investment', 'income', 'consumption'}, 'FontSize', ...
    fontsize, 'Interpreter', 'latex', 'Orientation','horizontal', 'Location', 'south')
xlabel('timestep', 'FontSize', fontsize, 'Interpreter','latex')
ylabel('preprocessed time series', 'FontSize', fontsize, 'Interpreter','latex')

mypdf('figure2A',0.71, 1)



figure
hold on
p1 = plot(orig_b(1:81,1), 'Color', [0, 0.4470, 0.7410]);
plot(76:81, exp(cumsum([all_b(75,1); predictions(:,1)]) + log_b(75,1)), 'Color', [0, 0.4470, 0.7410], 'LineStyle', '--');
p2 = plot(orig_b(1:81,2), 'Color', [0.85, 0.3250, 0.0980]);
plot(76:81, exp(cumsum([all_b(75,2); predictions(:,2)]) + log_b(75,2)), 'Color', [0.85, 0.3250, 0.0980], 'LineStyle', '--');
p3 = plot(orig_b(1:81,3), 'Color', [0.9290, 0.6940, 0.1250]);
plot(76:81, exp(cumsum([all_b(75,3); predictions(:,3)]) + log_b(75,3)), 'Color', [0.9290, 0.6940, 0.1250], 'LineStyle', '--');
axis([60, 80, 0, 3000])
pbaspect([2 1 1])
legend([p1, p2, p3], {'investment', 'income', 'consumption'}, 'FontSize', ...
     fontsize, 'Interpreter', 'latex', 'Location', 'northwest')
xlabel('timestep', 'FontSize', fontsize, 'Interpreter','latex')
ylabel('original time series', 'FontSize', fontsize, 'Interpreter','latex')

mypdf('figure2B',0.71, 1)

