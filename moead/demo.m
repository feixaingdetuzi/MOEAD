clc;clear
disp('输入测试函数');
fun = input('kno1,zdt1-zdt4,zdt6,dtlz1/2:','s');
dimension = input('输入目标维数');
mop = objective(fun,dimension);

% 种群规模(=权重向量个数=子问题个数)popsize：100；
% 邻居权重向量个数niche：20；
% 迭代次数iteration：250；
% 分解方法method：%te% or  ws ；
% 目标函数个数objDim：mop.od；
% 决策变量个数(决策空间维度)parDim：mop.pd；
% 参考点z：idealp 

pareto = moead(mop,'popsize',100,'niche',20,'iteration',1000,'method','te');
%pareto = moead(mop,'popsize',100,'niche',20,'iteration',1000,'method','ws');