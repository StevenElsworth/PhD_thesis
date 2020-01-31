mydefaults


N = 99; m = 96; % m/s block Krylov iterations to perform
W = wilkinson(N); evs = eig(W);

rng(0), b = rand(N, 2); xi = inf*ones(1, m/2);

[~, K, H] = rat_krylov(W, b, xi);

Am = H(1:m, 1:m)/K(1:m, 1:m);
R  = ones(N, m);
for j = 2:2:m
    ritz = sort(eig(Am(1:j,1:j)), 'descend'); evs_copy = evs;
    for i = 1:length(ritz)
        [y, ind] = min(abs(evs_copy - ritz(i)));
        evs_copy(ind) = inf; % pair Ritz val with unique ev
        R(ind, j-2+1:j) = y;
    end
end
figure(); imagesc(R); colormap(hot(100)); colorbar
xlabel('order j'); ylabel('eigenvalue index');

mypdf('figure2B', 0.71, 1)
