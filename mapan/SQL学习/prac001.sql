SELECT * FROM employees ORDER BY salary DESC; -- 从高到低

SELECT * FROM employees ORDER BY salary ASC; -- 从低到高 asc代表升序 ，desc代表降序 

SELECT * FROM employees ORDER BY salary;  -- 如果不写就默认asc升序

SELECT * FROM employees WHERE department_id >= 90 ORDER BY hiredate ASC;

SELECT * , salary*12*(1+IFNULL(commission_pct,0)) AS `年薪` 
FROM employees 
ORDER BY `年薪` DESC;

-- 描述表的结构
DESC departments;

-- 按照姓名的长度显示员工的姓名和工资
SELECT LENGTH('join');  -- length()的含义是字节长度

SELECT first_name,salary
FROM employees
ORDER BY LENGTH(first_name) ASC;


# 练习题
# 1.查询员工的姓名和部门号和年薪，按照年薪降序，按照姓名升序。按照多个字段进行排序
SELECT last_name,department_id,salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY '年薪' DESC ,last_name ASC;

# 2.选择工资不在8000到17000的员工的姓名和工资，按工资降序
SELECT last_name,salary
FROM employees
WHERE NOT(salary BETWEEN 8000 AND 17000)
ORDER BY salary DESC;

# 3.查询邮箱中包含e的员工信息，并先按邮箱的字节数降序，再按部门号升序
SELECT *,LENGTH(email)
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC,department_id ASC;


# 进阶4 ：常见函数
/*
概念：功能类似java方法 将一组逻辑语句封装在方法体中，对外暴露方法名
调用： select 函数名(实参列表)
特点：
	①叫什么
	②怎么用
分类：
	1.单行函数 concat、length、ifnull等
	2.分组函数 做统计使用，又称为统计函数，聚合函数，组函数
*/

# 一、字符函数
# 1.length 获取参数值的字节个数
SELECT LENGTH("join");
SELECT LENGTH("张三丰hahaha"); -- 一个汉字占用3个字节，一个字母占用1个字节

SHOW VARIABLES LIKE "%char%";

# 2.concat拼接字符串
SELECT CONCAT(last_name,'_',first_name) AS '姓名' 
FROM employees;

# 3.upper lower
SELECT UPPER('jOhn');

SELECT LOWER('joHn');

# 将姓变大写 名变小写
SELECT CONCAT(LOWER(first_name),'_',UPPER(last_name))
FROM employees;

-- 函数是可以嵌套使用的。

# 4.substr / substring

# 从索引处开始显示 显示陆展元
SELECT SUBSTR('李莫愁爱上了陆展元',7) out_put; -- 索引从1开始

# 截取指定索引处的字符  显示李莫愁
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) out_put; -- 索引从1开始

# 案例：姓名从首字母大写 ，其他字母小写 然后用_拼接，显示出来

SELECT CONCAT(UPPER(SUBSTR(last_name,1,1)),'_',SUBSTR(last_name,2))
FROM employees;

# 5.instr 用于返回子串第一次出现的索引，如果找不到就返回0
SELECT INSTR('杨不悔爱上了殷六霞','殷六霞') AS out_put;

# 6.trim 去除前后的空格

SELECT LENGTH(TRIM(' sdgfdsg sdgsg seg sdg ')),
LENGTH(' sdgfdsg sdgsg seg sdg ');

-- 去除字符串前后的字符 a
SELECT TRIM('a' FROM 'aaaaa张aaa三丰aaaaaaaaaaa') AS out_put;


# 7.lpad 最后总的字符个数是10个，功能是用指定的字符实现左填充

SELECT LPAD('殷素素',10,'*') AS out_put; -- 使用*对字符串进行左填充，

SELECT LPAD('美猴王',2,'*') AS out_put; -- 如果实际的字符个数大于指定的字符个数，则执行右侧截断处理

# 8. rpad 类似的，rpad是右填充

SELECT RPAD('殷素素',10,'*') AS out_put;

SELECT RPAD('美猴王',2,'*') AS out_put;  -- 同样执行右侧截断

SELECT RPAD('美猴王',12,'asddd') AS out_put; 

# 9. replace 替换函数 

SELECT REPLACE('我爱你，我爱你,我爱你，我爱你','爱','讨厌');

# 二、数学函数

# 1.round 四舍五入
SELECT ROUND(324.235453,2);
SELECT ROUND(2.4556);


# 2.ceil 向上取整 该函数返回大于等于参数的最小整数

SELECT CEIL(324.643);

SELECT CEIL(324.00000001);

SELECT CEIL(-324.643);

# 3.floor 向下取整 该函数返回小于等于参数的最大整数

SELECT FLOOR(324.4353);

SELECT FLOOR(-324.4353);

# 5.truncate 截断 保留小数点后几位，不进行四舍五入

SELECT TRUNCATE('16.588',2);


# 6. mod取余

SELECT MOD(-10,3);

SELECT MOD(10,3),MOD(10.0,3);

# 三、日期函数

# 1.now 返回当前日期和时间
SELECT NOW();

# 2. curdate 返回当前日期 不包含时间
SELECT CURDATE();

# 3.curtime 返回当前时间 不包含日期
SELECT CURTIME();

# 获取指定的部分
SELECT CONCAT(YEAR(NOW()),"年",MONTH(NOW()),"月"); -- 拼接年份

SELECT REPLACE(SUBSTR(NOW(),1,10),"-","/"); -- 字符处理

SELECT MONTHNAME(NOW()) -- 获取当前月的英文名

# 4.str_to_date 将字符串转换成日期

SELECT STR_TO_DATE('1994/12/03','%Y-%c-%d'); -- 这样不行，日期格式 需要前后对应 比如前面是- 后面也要是-

SELECT STR_TO_DATE('1994-12-03','%Y-%c-%d');

SELECT STR_TO_DATE('1994/12/03','%Y/%c/%d');

# 5. 查询入职日期是1992-04-03的员工信息

SELECT * FROM employees WHERE hiredate = '1992-04-03';
-- 如果输入的日期格式不规范，那么可以用str_to_date()函数
SELECT * FROM employees WHERE hiredate = STR_TO_DATE('1992-04#3','%Y-%m#%D');

# 6. data_format 将日期转换成字符串

SELECT DATE_FORMAT('1993-1-04','%Y年%c月%d日');
-- 年 %Y %y
-- 月 %m %c
-- 日 %D %d

# 四、其他函数

SELECT VERSION() AS 版本,DATABASE() AS 数据库, USER() AS 用户;
PASSWORD('字符') 	-- ：返回该字符的密码形式
MD5('字符') 		-- ：返回该字md5加密形式

# 五、流程控制函数
# 1.if 函数： if else

SELECT IF(20>10,'大','小') AS '20大于10吗';

# 判断是否有奖金
SELECT last_name,commission_pct,IF(commission_pct IS NULL,'没奖金','有奖金') AS 年终奖
FROM employees;

# 类似switch(变量或者表达式)

-- CASE 要判断的表达式 
-- WHEN 常量1 THEN 要执行的语句1
-- WHEN 常量2 THEN 要执行的语句2
-- WHEN 常量3 THEN 要执行的语句3
-- WHEN 常量4 THEN 要执行的语句4
-- ...
-- ELSE 要显示的语句
-- end

/*案例 查询员工的工资 要求：如果部门的
部门号=30，显示的工资为1.1倍
部门号=40，显示的工资为1.2倍
部门号=50，显示的工资为1.3倍
其他部门，显示的工资为原工资
*/

SELECT salary AS 原始工资,last_name,department_id,
CASE department_id 
WHEN 30 THEN salary*1.1 
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END AS 新工资
FROM employees;

# 3.case 函数的使用 类似多重if
-- 实现上个例子
SELECT salary AS 原始工资,last_name,department_id,
CASE  
WHEN department_id=30 THEN salary*1.1 
WHEN department_id=40 THEN salary*1.2
WHEN department_id=50 THEN salary*1.3
ELSE salary
END AS 新工资
FROM employees;

-- 类似多重if 从上往下判断，如果有符合的，就跳出判断给出结果
SELECT last_name,department_id,salary,
CASE 
WHEN salary>20000 THEN 'A'
WHEN salary>15000 THEN 'B'
WHEN salary>10000 THEN 'C'
ELSE 'D'
END AS 薪资级别
FROM employees; 

#练习
#1.显示系统时间（注：日期+时间）
SELECT NOW();

#2.查询员工号，姓名，工资，以及工资提高百分之20后的结果（new salary）
SELECT employee_id,last_name,salary,salary*1.2 AS 'new salary'
FROM employees;

#3.将员工的姓名按首字母排序，并写出姓名的长度（LENGTH）
SELECT last_name,LENGTH(last_name) AS name_length
FROM employees
ORDER BY SUBSTR(last_name,1,1);

# 4.做一个查询，产生下面的结果
/*
<last name>earns <salary>monthly but wants <salary*3>
Dream Salary 
King earns 24000 monthly but wants 720005.使用CASE-WHEN，按照下面的条件：
jobgradeAD PRESA ST MANB C
*/
SELECT CONCAT(last_name,' earns ',salary,' monthly but wants ',salary*3) AS 'Dream Salary'
FROM employees
WHERE salary=24000;
#5.使用case-when，按照下面的条件：
/* job	grade
   AD_PRES  A
   ST_MAN   B
   IT_PROG  C 
   SA_REP   D 
   ST_CLERK E
产生下面的结果
Last_name Job_id Grade
king 	AD_PRES    A
*/

SELECT last_name,job_id AS job,
CASE job_id
WHEN 'AD_PRES' THEN 'A'
WHEN 'ST_MAN' THEN 'B'
WHEN 'IT_PROG' THEN 'C'
WHEN 'SA_PRE' THEN 'D'
WHEN 'ST_CLERK' THEN 'E'
END AS Grade
FROM employees
WHERE job_id='AD_PRES';

#二、分组函数
/*
功能：用作统计使用，又称为聚合函数或统计函数或组函数分类：
sum 求和、avg平均值、max最大值、min最小值、count计算个数

特点：
1、sum、avg一般用于处理数值型
max、min、count可以处理任何类型
2、以上分组函数都忽略nul1值
3、可以和distinct搭配实现去重的运算
4、count函数的单独介绍
一般使用count（*）用作统计行数
5、和分组函数一同查询的字段要求是group by后的字段
*/
# 1.简单的使用

SELECT 
	COUNT(100),
	SUM(100) ,
	SUM(salary),
	MIN(salary) AS '最低薪资',
	MAX(salary) AS '最高薪资',
	AVG(salary) AS '平均薪资'
FROM
	employees;
	
# 2.参数支持哪些类型
SELECT SUM(last_name),AVG(last_name)FROM employees;

SELECT SUM(hiredate),AVG(hiredate)FROM employees;

SELECT MAX(last_name),MIN(last_name) FROM employees;
SELECT MAX(hiredate),MIN(hiredate) FROM employees;
SELECT COUNT(last_name) FROM employees;

SELECT COUNT(1) AS '没有奖金' FROM employees
WHERE commission_pct IS NULL;

SELECT COUNT(1) AS '有奖金'FROM employees
WHERE commission_pct IS NOT NULL;

#3. 是否忽略null值
SELECT SUM(commission_pct),AVG(commission_pct),
SUM(commission_pct)/35 AS '对比1',
SUM(commission_pct)/72 AS '对比2'
FROM employees; -- null值没有参与avg运算

#4. 和distinct搭配
SELECT SUM(DISTINCT salary) ,SUM(salary) FROM employees;

SELECT COUNT(DISTINCT salary)FROM employees; -- 有多少种工资

#5. count函数的详细介绍
SELECT COUNT(salary) FROM employees;

SELECT COUNT(*) FROM employees;
SELECT COUNT(1) FROM employees;
# 效率：
# MYISAM存储引擎下 count(*)效率更高
# INNOBD存储引擎下 count(1)效率更高

# 一般使用count(*)统计行数

#6. 和分组函数异同查询的字段有限制

SELECT AVG(salary),employee_id FROM employees;

  
/*
测试
1.查询公司员工工资的最大值，最小值，平均值，总和。
2.查询员工表中的最大入职时间和最小入职时间的相差天数
（DIFFRENCE）
3.查询部门编号为90的员工个数。
*/
-- 1.
SELECT 
	MAX(salary) AS '最大值',
	MIN(salary) AS '最小值',
	AVG(salary) AS '平均值',
	SUM(salary) AS '总和'
FROM 
	employees;
-- 2.
SELECT 	MAX(hiredate) AS '最晚入职时间',
	MIN(hiredate) AS '最早入职时间',
	DATEDIFF(MAX(hiredate),MIN(hiredate)) AS DATEDIFF
FROM
	employees;
-- 3.
SELECT COUNT(1) FROM employees WHERE department_id = 90;

# 进阶5. 分组查询

/*
语法：
select分组函数，列（要求出现在group by的后面）from表
【where 筛选条件】
group by分组的列表【order by 子句】
注意：
查询列表必须特殊，要求是分组函数和group by后出现的字段
特点：
1、分组查询中的筛选条件分为两类
		数据源		位置			关键字		
分组前筛选	原始表		group by子句的前面 	where
分组后筛选	分组后的结果集	group by子句的后面	having

①分组函数做条件肯定是放在having子句中
②能用分组前筛选的，就优先考虑使用分组前筛选
2、group by子句支持单个字段分组，多个字段分组（多个字段之间用逗号隔开没有顺序要求），表达式或函数（用得较少）
3、也可以添加排序（排序放在整个分组查询的最后）
*/
# 引入：查询每个部门的平均工资
SELECT AVG(salary) FROM employees;

#案例1 查询每个工种的最高工资

SELECT MAX(salary),job_id
FROM employees
GROUP BY job_id;

# 案例2 查询每个位置上的部门个数

SELECT COUNT(1),location_id
FROM departments
GROUP BY location_id;

# 添加筛选条件
# 案例1 查询邮箱中包含a字符的，每个部门的平均工资

SELECT AVG(salary),department_id
FROM employees
WHERE email LIKE '%a%'
GROUP BY department_id;

#案例2 查询有奖金的每个领导手下员工的最高工资

SELECT MAX(salary),manager_id
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY manager_id;

#添加复杂的筛选条件
#案例1：查询哪个部门的员工个数>2

-- where是对分组之前的条件进行筛选,HAVING是对分组之后的值进行筛选
SELECT COUNT(employee_id) AS 人数,department_id
FROM employees
GROUP BY department_id
HAVING 人数>2;

#案例2：查询每个工种有奖金的员工的最高工资>12000的工种编号和最高工资
#①查询每个工种有奖金的员工的最高工资
#②根据①结果继续筛选，最高工资>12000
SELECT MAX(salary) AS 最高工资,job_id AS 工种编号
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING 最高工资>12000;

#案例3：查询领导编号>102的每个领导手下的最低工资>5000的领导编号是哪个，以及其最低工资
#①查询查询领导编号>102的每个领导手下的员工固定最低工资
#②添加筛选条件：编号>102
#③添加筛选条件：最低工资>5000

SELECT manager_id,MIN(salary) AS min_sal
FROM employees
WHERE manager_id>102
GROUP BY manager_id
HAVING min_sal>5000

#按表达式或函数分组
#案例：按员工姓名的长度分组，查询每一组的员工个数，筛选员工个数>5的有哪些
#①查询每个长度的员工个数

SELECT COUNT(1) AS 员工个数,LENGTH(last_name) AS 姓名长度
FROM employees
GROUP BY 姓名长度
HAVING 员工个数>5

#按多个字段分组
#案例：查询每个部门每个工种的员工的平均工资

SELECT AVG(salary) AS avg_sal,department_id,job_id
FROM employees
GROUP BY department_id,job_id;

#添加排序
#案例：查询每个部门每个工种的员工的平均工资，并且按平均工资的高低显示,显示平均薪资高于10000的部门id和工种id

SELECT AVG(salary) AS avg_sal,department_id,job_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id,job_id
HAVING avg_sal>10000
ORDER BY avg_sal DESC;
-- 练习
#1. 查询各job_id的员工工资的最大值，最小值，平均值，总和，并按job_id升序
#2. 查询员工最高工资和最低工资的差距（DIFFERENCE）
#3. 查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
#4. 查询所有部门的编号，员工数量和工资平均值，并按平均工资降序
#5. 选择具有各个job_id的员工人数

-- 1.
SELECT MAX(salary) AS max_asl,MIN(salary) AS min_sal,AVG(salary) AS avg_sal,SUM(salary) AS sum_sal,job_id
FROM employees
GROUP BY job_id
ORDER BY job_id;

-- 2.
SELECT MAX(salary) AS max_asl,MIN(salary) AS min_sal, MAX(salary)-MIN(salary) AS DIFFERENCE
FROM employees

-- 3.
SELECT MIN(salary) AS min_sal,manager_id
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING min_sal>=6000;

-- 4.
SELECT department_id,COUNT(1) AS sum_emp,AVG(salary) AS avg_sal
FROM employees
GROUP BY department_id
ORDER BY avg_sal DESC;

-- 5.
SELECT COUNT(1) AS sum_emp,job_id
FROM employees
GROUP BY job_id;

# 进阶6：连接查询
#进阶6：连接查询
/*
含义：又称多表查询，当查询的字段来自于多个表时，就会用到连接查询
笛卡尔乘积现象：表1有m行，表2有n行，结果=m*n行
发生原因：没有有效的连接条件如何避免：添加有效的连接条件

分类：
	按年代分类：
		sq192标准: 仅仅支持内连接
		sq199标准【推荐】: 支持内连接+外连接（左外和右外）+交叉连接

	按功能分类：
		内连接：
			等值连接
			非等值连接
			自连接
		外连接：
			左外连接
			右外连接
			全外连接
		交叉连摸
*/
SELECT * FROM beauty;
SELECT * FROM boys;

#一、sq192标准
#1、等值连接
/*
①多表等值连接的结果为多表的交集部分
②n表连接，至少需要n-1个连接条件
③多表的顺序没有要求
④一般需要为表起别名
⑤可以搭配前面介绍的所有子句使用，比如排序、分组、筛选
*/

#案例1：查询女神名和对应的男神名 发生笛卡尔积
SELECT NAME,boyname FROM boys,beauty
WHERE beauty.boyfriend_id=boys.id;

#案例2：查询员工名和对应的部门名
SELECT a.last_name,b.department_name
FROM employees AS a,departments AS b
WHERE a.department_id=b.department_id;

#2、为表起别名
/*
①提高语句的简洁度
②区分多个重名的字段
注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定
*/
#查询员工名、工种号、工种名
SELECT a.last_name,a.job_id,b.job_title
FROM employees AS a,jobs AS b
WHERE a.job_id=b.job_id;

#3、两个表的顺序是否可以调换
#查询员工名、工种号、工种名
SELECT a.last_name,a.job_id,b.job_title
FROM employees AS a,jobs AS b
WHERE b.job_id=a.job_id;

#4、可以加筛选？
#案例：查询有奖金的员工名、部门名

SELECT last_name ,department_name,commission_pct
FROM employees AS e,departments AS d
WHERE e.department_id=d.department_id AND e.commission_pct IS NOT NULL;

#5、可以加分组？
#案例1：查询每个城市的部门个数

SELECT COUNT(department_id) 个数,d.location_id,city
FROM departments d,locations l
WHERE d.location_id=l.location_id
GROUP BY city;

#案例2：查询有奖金的每个部门的部门名和部门的领导编号 --和该部门的最低工资

SELECT 
	d.department_name,
	d.manager_id
FROM 
	employees e,
	departments d
WHERE 
	e.department_id=d.department_id
AND 
	commission_pct IS NOT NULL
GROUP BY 
	d.department_name,
	d.manager_id;
	
#6、可以加排序
#案例：查询每个工种的工种名和员工的个数，并且按员工个数降序

SELECT job_title,COUNT(employee_id) AS count_emp
FROM employees e,jobs j
WHERE e.job_id=j.job_id
GROUP BY j.job_title
ORDER BY count_emp DESC;

# 写法2：
SELECT job_title,COUNT(employee_id) AS count_emp
FROM employees e,jobs j
WHERE e.job_id=j.job_id
GROUP BY j.job_id
ORDER BY count_emp DESC;

#7、可以实现三表连接？
#案例：查询员工名、部门名和所在的城市
 
SELECT 
	last_name,
	department_name,
	city
FROM 
	employees e,
	departments d,
	locations l
WHERE 
	e.department_id=d.department_id
AND 
	d.location_id=l.location_id;
	
#2、非等值连接
#案例1：查询员工的工资和工资级别
SELECT 	last_name,salary AS 薪资水平 ,grade_level AS 薪资级别
FROM employees,job_grades
WHERE salary BETWEEN lowest_sal AND highest_sal;


#3、自连接
#案例：查询员工名和上级的名称

SELECT 
	e1.employee_id AS emp_id,
	e1.last_name AS emp_name,
	e2.employee_id AS leader_id,
	e2.last_name AS leader_name
FROM 
	employees AS e1,
	employees AS e2
WHERE 
	e1.manager_id=e2.employee_id;
/*
一、显示员工表的最大工资，工资平均值

二、查询员工表的employee_id，job_id，last_name，按department_id降序，salary升序

三、查询员工表的job_id中包含a和e的，并且a在e的前面

四、已知表 student，里面有id（学号），name，gradeId（年级编号）
已知表grade，里面有id（年级编号），name（年级名）
已知resuit，里面有id，score，studentNo（学号）
要求查询姓名、年级名、成绩

五、显示当前日期，以及去前后空格，截取子字符串的函数
*/
-- 1.
SELECT MAX(salary) AS max_sal,AVG(salary)AS avg_sal
FROM employees;

-- 2.
SELECT employee_id,job_id,last_name -- ,department_id,salary
FROM employees
ORDER BY department_id DESC, salary;

-- 3.
SELECT *
FROM employees
WHERE job_id LIKE '%a%e%';

-- 4.
SELECT 
	s.student,
	g.name,
	r.score
FROM
	student s,
	grade g,
	result r
WHERE 
	s.gradeId=g.id
AND	r.studentNo=s.id;

-- 5.
SELECT REPLACE(SUBSTR(TRIM(NOW()),1,10),'-','/') AS today;

SELECT RAND();

--  练习 
#1.显示所有员工的姓名，部门号和部门名称。
SELECT 
	last_name,
	department_id,
	department_


#2.查询90号部门员工的job_id和90号部门的location_id
SELECT
	job_id,
	location_id
FROM
	employees AS e,
	departments AS d
WHERE
	e.department_id=90
AND
	e.department_id=d.department_id;
#3.选择所有有奖金的员工的last_name,department_name,location_id,city

SELECT 
	e.last_name,
	d.department_name,
	l.location_id,
	l.city
FROM
	employees AS e,
	departments AS d,
	locations AS l
WHERE
	e.department_id=d.department_id
AND	
	d.location_id=l.location_id

#4.选择city在Toronto的员工的last name，job_id，daepartment_id，department_name

SELECT
	e.last_name,
	e.job_id,
	e.department_id,
	d.department_name
FROM
	employees AS e,
	departments AS d,
	locations AS l
WHERE
	e.department_id=d.department_id
AND
	l.`location_id`=d.`location_id`
AND
	l.city=`Toronto`


#5.查询每个工种、每个部门的部门名、工种名和最低工资
SELECT
	d.department_name,
	j.job_title,
	j.min_salary
FROM
	departments AS d,
	jobs AS j,
	employees AS e
WHERE	e.job_id=j.job_id
AND	e.department_id=d.department_id
GROUP BY
	j.job_id,
	d.department_name

#6.查询每个国家下的部门个数大于2的国家编号
SELECT
	l.country_id
FROM
	locations AS l,
	departments AS d
WHERE
	l.location_id=d.location_id
GROUP BY
	d.country_id
HAVING
	COUNT(department_id)>2
	
SELECT COUNT(DISTINCT country_id) FROM locations;
#7、选择指定员工的姓名，员工号，以及他的管理者的姓名和员工号，结果类似于下面的格式
/*
employees 	Emp	#manager Mgr
kochhar 	101 	king	100
*/

SELECT
	a.last_name AS '姓名',
	a.employee_id AS '工号',
	b.last_name AS '上司姓名',
	b.employee_id AS '上司工号'
FROM
	employees AS a,
	employees AS b
WHERE	a.manager_id=b.employee_id
AND	a.last_name='kochhar';





#二、sq199语法
1/*
语法：
	select 查询列表
	from表1别名【连接类型】
	join表2别名
	on连接条件
	【where 筛选条件】
	【group by 分组】
	【having 筛选条件】
	【order by 排序列表】
分类：
内连接（★）：inner
外连接：
	左外（★）：left 【outer】
	右外（★）：right【outer】
	全外：full【outer】
交叉连接：cross
*/

#一）内连接
/*
语法：
select 查询列表from表1别名inner join 表2别名on 连接条件；分类：等值
非等值自连接
特点：
①添加排序、分组、筛选
②inner可以省略
③筛选条件放在where后面，连接条件放在on后面，提高分离性，便于阅读
④inner join连接和sq192语法中的等值连接效果是一样的，都是查询多表的交集
*/
#1、等值连接
#案例1.查询员工名、部门名

SELECT
	last_name,
	department_name
FROM 	employees e
INNER JOIN departments d
ON	e.department_id=d.department_id
-- 调换顺序
SELECT
	last_name,
	department_name
FROM 	departments d
INNER JOIN employees e
ON	e.department_id=d.department_id

#案例2.查询名字中包含e的员工名和工种名（筛选）

SELECT last_name,job_title
FROM employees e
INNER JOIN jobs j
ON e.job_id=j.job_id
WHERE last_name LIKE '%e%';

#3.查询部门个数>3的城市名和部门个数，（分组+筛选）
SELECT city,COUNT(department_id)
FROM locations AS l
INNER JOIN departments AS d
ON l.location_id=d.location_id
GROUP BY city
HAVING COUNT(department_id)>3;

#4.查询哪个部门的部门员工个数>3的部门名和员工个数，并按个数降序（排序）
SELECT 
	COUNT(e.employee_id) AS sum_dep,
	e.department_id,
	d.department_name
FROM employees e
INNER JOIN departments d
ON d.department_id=e.department_id
GROUP BY e.department_id
HAVING sum_dep>3
ORDER BY sum_dep DESC;

#5.查询员工名、部门名、工种名，并按部门名降序

-- 子查询方式
SELECT 
	t1.last_name,
	t1.department_name,
	job_title
FROM
	(SELECT
		last_name,
		department_name,
		job_id
	FROM employees AS e
	JOIN departments AS d
	ON e.`department_id`=d.department_id)AS t1
JOIN jobs AS j
ON t1.job_id=j.job_id
ORDER BY department_name DESC;

-- 双inner join
SELECT 
	e.last_name,
	d.department_name,
	job_title
FROM employees AS e
INNER JOIN departments AS d
ON e.`department_id`=d.department_id
INNER JOIN jobs AS j
ON j.job_id=e.job_id
ORDER BY department_name DESC;

#二）非等值连接
#查询员工的工资级别

SELECT
	salary,
	grade_level
FROM employees AS e
JOIN job_grades AS g
ON e.salary BETWEEN g.lowest_sal AND g.highest_sal;

#查询每个工资级别的人数>2的工资级别，并且按工资级别降序

SELECT
	COUNT(1) AS sum_emp,
	grade_level
FROM
	employees AS e
JOIN	job_grades AS g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
GROUP BY grade_level
HAVING sum_emp>20
ORDER BY grade_level DESC;

#三）自连接
#查询姓名中包含字符k的员工的名字、上级的名字

SELECT 
	e.last_name AS '员工',
	m.last_name AS '上级'
FROM
	employees AS e
JOIN employees AS m
ON e.manager_id=m.employee_id
WHERE e.last_name LIKE '%k%';

#二、外连接 :用于查询一个表中有，另一个表中没有的
/*应用场景：用于查询一个表中有，另一个表没有的记录
特点：
    1、外连接的查询结果为主表中的所有记录
	如果从表中有和它匹配的，则显示匹配的值
	如果从表中没有和它匹配的，则显示null
	外连接查询结果=内连接结果+主表中有而从表中没有的记录
    2、左外和右外:
	左外连接：left join左边的是主表
	右外连接：right join右边的是主表
    3、左外和右外交换两个表的顺序，可以实现同样的效果
*/


SELECT * FROM boys;
SELECT * FROM beauty;

#引入：查询没有男朋友的女神名
SELECT 
	b.name
	-- bo.*
FROM beauty AS b
LEFT JOIN boys AS bo
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`id` IS NULL;

#案例1：查询哪个部门没有员工
#左外

SELECT 
	d.*,
	e.employee_id
FROM departments AS d
LEFT JOIN employees AS e
ON d.department_id=e.department_id
WHERE e.employee_id IS NULL;

#一、查询编号>3的女神的男朋友信息，如果有则列出详细，如果没有，用nul1填充
SELECT
	b.id,
	b.`name`,
	bo.*
FROM
	beauty AS b
LEFT JOIN boys AS bo
ON b.`boyfriend_id`=bo.`id`
WHERE b.`id`>3

#二、查询哪个城市没有部门
SELECT 
	city,
	d.*
FROM
	departments AS d
RIGHT JOIN locations AS l
ON l.location_id=d.location_id
WHERE d.department_id IS NULL;

#三、查询部门名为SAL或IT的员工信息
-- 此方法有问题
SELECT
	e.*,
	d.department_name
FROM employees AS e
JOIN departments AS d
ON e.department_id=d.department_id
WHERE d.department_name IN('Sal','IT');

-- 应该以departments为主表
SELECT 
	e.*,
	d.department_name
FROM departments AS d
LEFT JOIN employees AS e
ON e.department_id=d.department_id
WHERE d.department_name IN('Sal','IT');










