function ind = genetic_op(subproblems, index, domain, params)
%% 使用当前的种群进行差分进化
    %GENETICOP function implemented the DE operation to generate a new
    %individual from a subproblems and its neighbours.

    %   subproblems: 所有的子问题
    %   index: 当前正在优化的子问题的编号
    %   domain: 多目标优化问题解的定义域
    %   ind: 个体结构体
    
%% 提取出邻居矩阵
    neighbourindex = subproblems(index).neighbour;

%% 从所有邻居中进行随机抽取三个不同的子问题
    nsize = length(neighbourindex);
    si = ones(1,3)*index;

    si(1) = neighbourindex(ceil(rand*nsize));%ceil

    while si(1) == index
        si(1) = neighbourindex(ceil(rand*nsize));
    end

    si(2) = neighbourindex(ceil(rand * nsize));

    while si(2) == index || si(2) == si(1)
        si(2) = neighbourindex(ceil(rand*nsize));
    end

    si(3) = neighbourindex(ceil(rand*nsize));

    while si(3) == index|| si(3) == si(2) || si(3) == si(1)
        si(3) = neighbourindex(ceil(rand * nsize));
    end

    %%  选择变异生成新x
    points = [subproblems(si).curpoint]; 
    selectpoints = [points.parameter];   %选定三个邻居子问题的当前解

    oldpoint = subproblems(index).curpoint.parameter; %原始解为当前子问题的当前解
    parDim = size(domain, 1); 
    
    jrandom = ceil(rand * parDim);  %四舍五入生成一个小于等于parDim的整数

    randomarray = rand(parDim, 1); %随机生成一列（0，1）范围内的向量
    
    %randomarray中小于CR(0.5)的索引处为deselect为1，其他点为0
    deselect = randomarray < params.CR;
    
    %保证原始解中第jrandom个维度元素值不变，所以设置deselect_jrandom=1
    deselect(jrandom) = true;%x_jrandom=1
    
    %使用三个邻居子问题的当前解生成新解，此处F=0.5
    newpoint = selectpoints(:, 1) + params.F * (selectpoints(:, 2) - selectpoints(:, 3));
    
    %若deselect中某一维度值为0，则当前解的该维度值不变，为1变异更新为newpoint中的值
    newpoint(~deselect) = oldpoint(~deselect); 

%% 规范新找到的点在定义域范围内
    newpoint = max(newpoint, domain(:, 1));
    newpoint = min(newpoint, domain(:, 2));
    ind = struct('parameter', newpoint, 'objective', [], 'estimation', []);
    
%% 对新找到的点进行高斯变异生成最终的子代
    ind = gaussian_mutate(ind, 1 / parDim, domain);
    
end