function ind = gaussian_mutate( ind, prob, domain)
%% 高斯变异，变异概率为"1/决策空间维度"

   x = ind.parameter;
   parDim = length(x);
   lowend  = domain(:,1);
   highend =domain(:,2);
   sigma = (highend-lowend)./20; %标准差
   
%r = normrnd(mu,sigma) generates a random number from the normal distribu-
%   tion with mean parameter mu and standard deviation parameter sigma.

   newparam = min(max(normrnd(x, sigma), lowend), highend);
   C = rand(parDim, 1)<prob; %小于为1，不小于为0
   x(C) = newparam(C);
   
   ind.parameter = x;
end