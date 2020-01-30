mydefaults

N = 100; m = 99;
ev = [1:50, 60:110];
A = spdiags(ev', 0, N, N);
b = ones(N, 1);
xi = 55*ones(1, m);

[V, K, H] = rat_krylov(A, b, xi);

Am = H(1:m, 1:m)/K(1:m, 1:m);
R  = ones(N+10, m);
for j = 1:m
    ritz = eig(Am(1:j,1:j));
    for i = 1:length(ritz)
        [y, ind] = min(abs(ev - ritz(i)));
        R(ev(ind),j) = min(R(ev(ind), j), y);
    end
end
imagesc(R); colormap(hot(100)); colorbar
xlabel('order j'); ylabel('Ritz values');
mypdf('2-1B',0.71, 1)


mydefaults

N = 100; m = 99;
ev = [1:50, 60:110];
A = spdiags(ev', 0, N, N);
b = ones(N, 1);

R  = ones(N+10, m);
for j = 2:m-1
    xi = [55*ones(1, j), inf];

    [V, K, H] = rat_krylov(A, b, xi);
    ritz = eig(H(1:end-1, :), K(1:end-1, :));
    for i = 1:length(ritz)
        [y, ind] = min(abs(ev - ritz(i)));
        R(ev(ind),j) = min(R(ev(ind), j), y);
    end
end
imagesc(R); colormap(hot(100)); colorbar
xlabel('order j'); ylabel('Ritz values');
mypdf('2-1Bb',0.71, 1)
