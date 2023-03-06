function ind  = randompoint(prob,n)
%% 在定义域范围内随机采样生成初始解\vec{x}
   %n = popsize

   if(nargin == 1)
       n=1;
   end
    % 在决策空间范围内随机采样生成初始解
    randarray = rand(prob.pd,n);
    lowend = prob.domain(:,1);
    span = prob.domain(:,2) - lowend;
    a = span(:,ones(1,n));
    b = lowend(:,ones(1,n));
    point = randarray .* a + b;
% 然后把生成的随机数变成变成元孢便于存放在当前解的结构体ind中
    cellpoints = num2cell(point,1);
    % 把生成的元孢装进ind中的parameter里
    indiv = struct('parameter',[],'objective',[],'estimation',[]);
    ind = repmat(indiv,1,n);
    [ind.parameter] = cellpoints{:};

    estimation = struct('obj',NaN,'std',NaN);
    [ind.estimation] = deal(repmat(estimation,prob.od,1));
end