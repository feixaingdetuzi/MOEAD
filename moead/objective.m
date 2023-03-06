function mop = objective(testname,dimension)

 mop = struct('name',[],'od',[],'pd',[],'domain',[],'func',[]);

    switch lower(testname)
    case 'kno1'
        mop = kno1(mop, dimension);
    case 'zdt1'
        mop = zdt1(mop, dimension);
    case 'zdt2' 
        mop = zdt2(mop, dimension);
    case 'zdt3' 
        mop = zdt3(mop, dimension);
    case 'zdt4' 
        mop = zdt4(mop, dimension);
    case 'zdt6' 
        mop = zdt6(mop, dimension); 
    case 'dtlz1' 
        mop = dtlz1(mop, dimension);
    case 'dtlz2' 
        mop = dtlz2(mop, dimension);         
    otherwise 
        error('Undefined test problem name');
    end 

end

function p = kno1(p,dim)
    p.name = 'KNO1';
    p.od = 2;
    p.pd = dim;
    p.domain = [0 3;0 3];
    p.func = @evaluate;

    function y = evaluate(x)
        y = zeros(2,1);
        c = x(1) + x(2);
        f = 9-(3*sin(2.5*c^0.5)+3*sin(4*c)+5*sin(2*c+2));
        g = (pi/2.0)*(x(1)-x(2)+3.0)/6.0;
        y(1) = 20 - (f*cos(g));
        y(2) = 20 - (f*sin(g));
    end
end

function p = zdt1(p,dim)
    p.name = 'ZDT1';
    p.od = 2;
    p.pd = dim;
    p.domain = [zeros(dim,1) ones(dim,1)];
    p.func = @evaluate;

    function y = evaluate(x)
        y = zeros(2,1);
        y(1) = x(1);
        su = sum(x) - x(1);
        g = 1+9*su/(dim-1);
        y(2) = g*(1-sqrt(x(1)/g));
    end
   load('ZDT1.txt');%%没有这个数据集
   plot(ZDT1(:,1),ZDT1(:,2),'k.');
   PP = ZDT1;
end
%% ZDT2 function generator

function p = zdt2(p, dim)
    p.name = 'ZDT2';
    p.pd = dim; %决策变量的维度
    p.od = 2; %目标函数的个数
    p.domain = [zeros(dim, 1) ones(dim, 1)];
    p.func = @evaluate;

    % ZDT2 evaluation function.

    function y = evaluate(x)
        y = zeros(2, 1);
        y(1) = x(1);
        su = sum(x) - x(1);
        g = 1 + 9 * su / (dim - 1);
        y(2) = g * (1 - (x(1) / g)^2);
    end 
    load('ZDT2.txt');%导入正确的前端解
    plot(ZDT2(:,1),ZDT2(:,2),'k.');
    PP=ZDT2;
end 

%% ZDT3 function generator
function p = zdt3(p, dim)
    p.name = 'ZDT3';
    p.pd = dim;
    p.od = 2;
    p.domain = [zeros(dim, 1) ones(dim, 1)];
    p.func = @evaluate;

    % ZDT3 evaluation function.

    function y = evaluate(x)
        y = zeros(2, 1);
        y(1) = x(1);
        su = sum(x) - x(1);
        g = 1 + 9 * su / (dim - 1);
        y(2) = g * (1 - sqrt(x(1) / g) - x(1) * sin(10 * pi * x(1)) / g);
    end 
    load('ZDT3.txt');%导入正确的前端解
    plot(ZDT3(:,1),ZDT3(:,2),'k.');
    PP=ZDT3;
end 
%% ZDT4 function generator
function p = zdt4(p, dim)
    p.name = 'ZDT4';
    p.pd = dim;
    p.od = 2;
    x_min = [0,-5,-5,-5,-5,-5,-5,-5,-5,-5]';
    x_max=[1,5,5,5,5,5,5,5,5,5]';
    p.domain = [x_min x_max];
    p.func = @evaluate;

    % ZDT4 evaluation function.

    function y = evaluate(x)
        y = zeros(2, 1);
        y(1) = x(1);
        sum=0;
        for i=2:p.pd
            sum = sum+(x(i)^2-10*cos(4*pi*x(i)));
        end
        su = sum;
        g = 1 + 10 * (dim - 1) + su;
        y(2) = g * (1 - sqrt(x(1) / g));
    end 
    load('ZDT4.txt');%导入正确的前端解
    plot(ZDT4(:,1),ZDT4(:,2),'k.');
    PP=ZDT4;
end 
%% ZDT6 function generator
function p = zdt6(p, dim)
    p.name = 'ZDT6';
    p.pd = dim;
    p.od = 2;
    p.domain = [zeros(dim, 1) ones(dim, 1)];
    p.func = @evaluate;

    % ZDT6 evaluation function.

    function y = evaluate(x)
        y = zeros(2, 1);
        y(1)=1-(exp(-4*x(1)))*((sin(6*pi*x(1)))^6);
        su = sum(x) - x(1);
        g = 1 + 9 * ((su / (dim - 1))^0.25);
        y(2) = g * (1 - (y(1) / g)^2);
    end 
    load('ZDT6.txt');%导入正确的前端解
    plot(ZDT6(:,1),ZDT6(:,2),'k.');
    PP=ZDT6;
    
end 

%% DTLZ1 function generator
function p = dtlz1(p, dim)
    p.name = 'DTLZ1';
    p.pd = dim;
    p.od = 3;
    p.domain = [zeros(dim, 1) ones(dim, 1)];
    p.func = @evaluate;

    % DTLZ1 evaluation function.

    function y = evaluate(x)
        y = zeros(3, 1);
        sum = 0;
        for i=3:dim
          sum = sum+((x(i)-0.5)^2-cos(20*pi*(x(i)-0.5)));
        end       
        su = sum;
        g=100*(dim-2)+100*sum;
        y(1)=(1+g)*x(1)*x(2);
        y(2)=(1+g)*x(1)*(1-x(2));
        y(3)=(1+g)*(1-x(1));        
    end 
    load('DTLZ1.txt');%导入正确的前端解
    plot3(DTLZ1(:,1),DTLZ1(:,2),DTLZ1(:,3),'r.');
    PP=DTLZ1;
    
end

%% DTLZ2 function generator
function p = dtlz2(p, dim)
    p.name = 'DTLZ2';
    p.pd = dim;
    p.od = 3;
    p.domain = [zeros(dim, 1) ones(dim, 1)];
    p.func = @evaluate;

    % DTLZ2 evaluation function.

    function y = evaluate(x)
        y = zeros(3, 1);
        sum = 0;
        for i=3:dim
          sum = sum+(x(i))^2;
        end 
        g=sum;
        y(1)=(1+g)*cos(x(1)*pi*0.5)*cos(x(2)*pi*0.5);
        y(2)=(1+g)*cos(x(1)*pi*0.5)*sin(x(2)*pi*0.5);
        y(3)=(1+g)*sin(x(1)*pi*0.5);
    end 
    load('DTLZ2.txt');%导入正确的前端解
    plot3(DTLZ2(:,1),DTLZ2(:,2),DTLZ2(:,3),'g*');
    PP=DTLZ2;
    
end 