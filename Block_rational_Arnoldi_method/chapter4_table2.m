close all
clear all
clc

mydefaults

if exist('Inlet.A') ~= 2 || exist('Inlet.B') ~= 2 || ...
        exist('Inlet.C') ~= 2 || exist('Inlet.E') ~= 2 || ...
        exist('mmread') ~= 2
    disp(['The required matrices for this problem can be '  ...
        'downloaded from https://portal.uni-freiburg.de/' ...
        'imteksimulation/downloads/benchmark/38866']);
    return
end

N = 11730;
A = mmread('Inlet.A');
B = mmread('Inlet.B');
C = mmread('Inlet.C');
E = mmread('Inlet.E');

f = @(s) full(C*((s*E - A)\B));
f0 = 40;
s = linspace(0, f0, 12 + 11*8);
for j = 1:length(s) 
    fs(j, 1:2) = f(1i*s(j)); 
end
b = full(A\B);

%% Define  poles

xi1 = 1i*repmat(linspace(0, 40, 4), 1, 6);
xi2 = xi1; 
xi2(13) = 0.996 - 0.0762i; %xi2(13) = 0.996025588922290 - 0.076234141401036i;

%% Compute high precision space
param.waitbar = 1;

mpA = mp(A);
mpb = mp(b);
mpE = mp(E);
mpxi1 = mp(xi1);
mpxi2 = mp(xi2);



%{
disp('xi1')
[mpV1, mpK1, mpH1] = rat_krylov(mpA, mpE, mpb, mpxi1, param);
disp('xi2')
[mpV2, mpK2, mpH2] = rat_krylov(mpA, mpE, mpb, mpxi2, param);
disp('done with mp')
%}
load mpdata



%%
deflation_tol = 0;
param.waitbar = 1;
param.orth = 'CGS';
param.reorth = 0;
continuation = {'last', 'ruhe', 'last'};
lstyle = {'-', ':', '-.'};
parallel = {1, 1, 4};

cmatrix  = [0, 0.4470, 0.7410; 0.85, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250];

figure(1)
hold on
xlabel('s'), ylabel('Error: |H(is) - Hm(is)|')
for i = 1:3
    param.continuation = continuation{i};
    param.p = parallel{i};
    [V, K, H, outt] = rat_krylov(A, E, b, xi1, param);
    R = outt.R;
    D = fminsearch(@(x) cond(R*diag(x)), ones(size(R, 2), 1), ...
    struct('Display','off'));
    nrm = norm(V'*V - eye(size(V,2)));
    spc = norm(mpV1*(mpV1'*V)- V);

    fprintf(strcat('   Continuation vector: ', strcat(continuation{i},'\n')))
    fprintf('   Poles: xi1 \n')
    fprintf(strcat('   Parallelisation: ', strcat(num2str(parallel{i}), '\n')))
    fprintf('   Cond number (scaled): %.3e\n', cond(R*diag(D)))
    fprintf('   Orthogonality check:  %.3e\n', nrm)
    fprintf('   norm(VpVp^*V - V)_2: %.3e\n', spc)
    fprintf('\n')
    
    % Evaluate and plot reduced transfer function.
    Em = V'*E*V; Am = V'*A*V; Bm = V'*B; Cm = C*V;
    for j = 1:length(s)
        fsm(j, 1:2) = (Cm*((1i*s(j)*Em - Am)\Bm));
    end
    p{i} = plot(s, abs(fsm(:,1) - fs(:,1)), lstyle{i}, 'Color', cmatrix(i,:));
    pp{i} = plot(s, abs(fsm(:,2) - fs(:,2)), lstyle{i}, 'Color', cmatrix(i,:));
end
legend([p{1}, p{2}, p{3}], {'last', 'ruhe', 'last\_4'})
mypdf('xxi1')

figure(2)
hold on
xlabel('s'), ylabel('Error: |H(is) - Hm(is)|')
for i = 1:3
    param.continuation = continuation{i};
    param.p = parallel{i};
    [V, K, H, outt] = rat_krylov(A, E, b, xi2, param);
    R = outt.R;
    D = fminsearch(@(x) cond(R*diag(x)), ones(size(R, 2), 1), ...
    struct('Display','off'));
    nrm = norm(V'*V - eye(size(V,2)));
    spc = norm(mpV2*(mpV2'*V)- V);

    fprintf(strcat('   Continuation vector: ', strcat(continuation{i},'\n')))
    fprintf('   Poles: xi2 \n')
    fprintf(strcat('   Parallelisation: ', strcat(num2str(parallel{i}), '\n')))
    fprintf('   Cond number (scaled): %.3e\n', cond(R*diag(D)))
    fprintf('   Orthogonality check:  %.3e\n', nrm)
    fprintf('   norm(VpVp^*V - V)_2: %.3e\n', spc)
    fprintf('\n')

    % Evaluate and plot reduced transfer function.
    Em = V'*E*V; Am = V'*A*V; Bm = V'*B; Cm = C*V;
    for j = 1:length(s)
        fsm(j, 1:2) = (Cm*((1i*s(j)*Em - Am)\Bm));
    end
    p{i} = plot(s, abs(fsm(:,1) - fs(:,1)), lstyle{i}, 'Color', cmatrix(i,:));
    pp{i} = plot(s, abs(fsm(:,2) - fs(:,2)), lstyle{i}, 'Color', cmatrix(i,:));
end
legend([p{1}, p{2}, p{3}], {'last', 'ruhe', 'last\_4'})
mypdf('xxi2')