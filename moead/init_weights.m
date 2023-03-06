function subp = init_weights(popsize,niche,objDim)
%初始化权重向量并找到每个向量的20个邻居向量
%初始化权重向量
  subp = [];
  %---------两目标----
  if objDim==2
     for i = 0:popsize
        p = struct('weight',[],'neighbour',[],'optimal',Inf,'optpoint',[],'curpoint',[]);
        %平均划分，定义每个权重向量
        weight = zeros(2,1);
        weight(1) = i/popsize;
        weight(2) = (popsize - i)/popsize;
        p.weight = weight;
        subp = [subp p];
     end
   %-------三目标----
  elseif objDim == 3
      for i = 0:popsize
     %lhsdesign:lhsdesign函数是基本的拉丁超立方抽样的函数，总体的抽样结果服从均匀分布
     %返回一个 n × p 的矩阵，每一列的元素是随机排列的。n为样本空间的分层数，p为样本维度数
         p = struct('weight',[],'neighbour',[],'optimal',Inf,'optpoint',[],'curpoint',[]);
         weight = lhsdesign(1,3,"criterion","maximin","iterations",1000);
         W = sum(weight);
         weight = weight./W;
         p.weight = weight';
         subp = [subp p];
      end
  end

  %%求解邻居向量
   % 根据欧式距离求解邻居向量B(i)
   leng = length(subp);
   distanceMatrix = zeros(leng,leng);%初始化距离矩阵

   %计算每两个点的距离
   for i = 1:leng
       for j = i+1:leng
           A = subp(i).weight; B = subp(j).weight;
           distanceMatrix(i,j) = 0;
           for n = 1:objDim
               distanceMatrix(i,j) = (A(n)-B(n))^2 + distanceMatrix(i,j);
           end
           distanceMatrix(i,j) = sqrt(distanceMatrix(i,j));
           distanceMatrix(j,i) = distanceMatrix(i,j);
       end
       %对第i个权重向量与其他权重向量之间的距离以及其他权重向量的索引进行排序
        %分别存放到s与sindex中
        [s,sindex] = sort(distanceMatrix(i,:));

        %将第i个子问题的邻居向量索引填入其结构体的对应元素neighbour中
        subp(i).neighbour = sindex(1:niche)';
   end
end