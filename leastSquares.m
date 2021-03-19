alpha = 1;
beta = 2;
gamma = 3;

% X and Y are vectors of pseudorandom scalar ints between 1 and max
max = 20;
x = randi(max,1,500);
y = randi(max,1,500);

% Creating Z array without noise
z = alpha*x+beta*y+gamma;

% Adding noise of normally distributed random numbers
z_noisy = z+randn(1,500);

% Finding Ap=b, A and b are knowns
A = [x' y' ones(500,1)];
b = z_noisy';

% Least squares fitting to find parameters alpha beta gamma
p = A\b;

disp('The original parameter values are:');
disp(['Alpha: ',num2str(alpha)]);
disp(['Beta: ',num2str(beta)]);
disp(['Gamma: ',num2str(gamma)]);

disp(' ');
disp('The estimated parameter values are:');
disp(['Alpha: ',num2str(p(1))]);
disp(['Beta: ',num2str(p(2))]);
disp(['Gamma: ',num2str(p(3))]);

disp(' ');
disp('The absolute errors between the original and estimated are:');
disp(['Alpha: ',num2str(abs(alpha-p(1)))]);
disp(['Beta: ',num2str(abs(beta-p(2)))]);
disp(['Gamma: ',num2str(abs(gamma-p(3)))]);
