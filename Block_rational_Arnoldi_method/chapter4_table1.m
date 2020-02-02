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
% f = @(s) full(C*((s*E - A)\B));

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
continuation = {'last', 'ruhe', 'last', 'last', 'ruhe'};
parallel = {1, 1, 4, 1, 1};
xi = {xi1, xi1, xi1, xi2, xi2};
xi_txt = {'xi1', 'xi1', 'xi1',' xi2', 'xi2'};
mpV = {mpV1, mpV1, mpV1, mpV2, mpV2};

for i = 1:5
    param.continuation = continuation{i};
    param.p = parallel{i};
    [V, K, H, outt] = rat_krylov(A, E, b, xi{i}, param);
    R = outt.R;
    D = fminsearch(@(x) cond(R*diag(x)), ones(size(R, 2), 1), ...
    struct('Display','off'));
    nrm = norm(V'*V - eye(size(V,2)));
    spc = norm(mpV{i}*(mpV{i}'*V)- V);

    fprintf(strcat('   Continuation vector: ', strcat(continuation{i},'\n')))
    fprintf(strcat('   Poles: ', strcat(xi_txt{i}, '\n')))
    fprintf(strcat('   Parallelisation: ', strcat(num2str(parallel{i}), '\n')))
    fprintf('   Cond number (scaled): %.3e\n', cond(R*diag(D)))
    fprintf('   Orthogonality check:  %.3e\n', nrm)
    fprintf('   norm(VpVp^*V - V)_2: %.3e\n', spc)
    fprintf('\n')
end
