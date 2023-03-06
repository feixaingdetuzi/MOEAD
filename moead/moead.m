function pareto = moead(mop,varargin)

    starttime = clock;
%全局变量
    global params idealpoint objDim parDim itrCounter;
%定义随机生成器
    rand('state', 10); %锁定初始状态保证每次随机生成的状态相同,也可以不锁定
   % 对除zdt4外的函数，锁定与不锁定的区别不大。而对zdt4函数，代码每次会收敛
   % 到不同PF，所以不锁定的话每次得到的PF都不一样
%---------初始化
    paramIn = varargin;
    [objDim,parDim,idealpoint,params,subproblems] = init(mop,paramIn);
%---------进化、更新
    itrCounter = 1;
    while ~terminate(itrCounter)
        tic;
        subproblems = evolve(subproblems,mop,params);
        fprintf('iteration %u finished,time used:%u\n',itrCounter,toc);
        itrCounter = itrCounter +1;
    end
%--------显示结果
    pareto = [subproblems.curpoint];
    pp = [pareto.objective];
    [a,~] = size(pp);
    if(a==2)
        hold on;
        scatter(pp(1,:),pp(2,:));
        title(mop.name);
        fprintf('total time used %u\n',etime(clock,starttime));
    else
        hold on;
        plot3(pp(1, :), pp(2, :),pp(3, :),'b.');
        title(mop.name);
        fprintf('total time used %u\n', etime(clock, starttime));
    end
end

function [objDim, parDim, idealp, params, subproblems] = init(mop, propertyArgIn)
    objDim = mop.od;%目标维度
    parDim = mop.pd;%参数维度
    idealp = ones(objDim,1)*inf;%初始化参考点
%固定参数默认值
    params.popsize = 100; params.niche = 30; params.iteration = 100;
    params.dmethod = 'te';
    params.F = 0.5;
    params.CR = 0.5;
%默认参数替换为自定义的参数
    while length(propertyArgIn)>=2
        prop = propertyArgIn{1};
        val = propertyArgIn{2};
        propertyArgIn = propertyArgIn(3:end);

        switch prop
            case 'popsize'
                params.popsize = val;
                case 'niche'
            %相邻种群规模
            params.niche = val;
        case 'iteration'
            % 迭代次数
            params.iteration = val;
        case 'method'
            % 方法
            params.dmethod = val;
        otherwise  
            warning('moea doesnot support the given parameters name');
        end 
    end

    %初始化权重向量，分解成多个单目标问题
    subproblems = init_weights(params.popsize,params.niche,objDim);
    params.popsize=length(subproblems);
    
    %初始化初始解
    %种群个数就是子问题个数，也就是权重向量个数
    inds = randompoint(mop,params.popsize);
    %计算初始解的目标函数值V并存放在inds中(arrayfun：将函数应用于结构体数组的字段)
    [V,INDS] = arrayfun(@evaluate,repmat(mop,size(inds)),inds,'UniformOutput',0);
    [subproblems.curpoint]=INDS{:};

    %初始化参考点
    %把最优点（所有问题中的最小目标函数值点）保存在idealp中作为参考点
    v=cell2mat(V);
    idealp = min(idealp,min(v,[],2));
    clear inds INDS v indcells;
end

function subproblems = evolve(subproblems,mop,params)
%%MOEA/D 优化
    global idealpoint;
    for i=1:length(subproblems)
        ind = genetic_op(subproblems,i,mop.domain,params);

        %更新z
        %比较y的目标函数值与原始的参考点，y的目标函数值更小，更新参考点
        [obj,ind] = evaluate(mop,ind);
        idealpoint = min(idealpoint,obj);

        %更新第i个子问题的邻居子问题的x
        neighborindex = subproblems(i).neighbour;
        subproblems(neighborindex)  = update(subproblems(neighborindex),ind,idealpoint);
        clear ind obj neighborindex;
    end
end

function subp = update(subp,ind,idealpoint)
%更新邻居解
 global params
 
 newobj = subobjective([subp.weight],ind.objective,idealpoint,params.dmethod);
 oops = [subp.curpoint];
 oldobj = subobjective([subp.weight],[oops.objective],idealpoint,params.dmethod);

 %更新邻居子问题的解
 %对某个邻居子问题，newobj<oldobj,更新该邻居子问题的解
 C = newobj<oldobj;%小于为1，不小于为0
 [subp(C).curpoint] = deal(ind);
 clear C newobj oops oldobj;
end

function y = terminate(itrcounter)
    %判断停止迭代条件
    global params;
    y = itrcounter > params.iteration;
end