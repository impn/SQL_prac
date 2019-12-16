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

# 进阶7：子查询

/*
含义：
出现在其他语句中的select语句，称为子查询或内查询外部的查询语句，称为主查询或外查询

分类：
按子查询出现的位置：
	select后：
		仅仅支持标量子查询
	from后面
		支持表子查询
	where或having后面：
		标量子查询
		列子查询
		行子查询
	exists后面（相关子查询）
	表子查询
	
按结果集的行列数不同：
	标量子查询（结果集只有一行一列）
	列子查询（结果集只有一列多行）
	行子查询（结果集有一行多列）
	表子查询（结果集一般为多行多列）


*/

#一、where或having后面

/*

1、标量子查询（单行子查询）
2、列子查询（多行子查询）
3、行子查询（多列多行）

特点：
①子查询放在小括号内
②子查询一般放在条件的右侧
③标量子查询，一般搭配着单行操作符使用
><>=<==<>
④子查询的执行优先于主查询执行，主查询的条件用到了子查询的结果


列子查询，一般搭配着多行操作符使用in、any/some、al1
*/
#1.标量子查询
#案例1：谁的工资比Abel高？
#①查询Abe1的工资

SELECT e.last_name,e.salary
FROM employees AS e
WHERE e.salary >(SELECT salary FROM employees WHERE last_name='Abel')

#案例2：返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
SELECT 
	last_name,
	job_id,
	salary
FROM employees
WHERE job_id=(
	SELECT job_id 
	FROM employees 
	WHERE employee_id=141
)AND salary>(
	SELECT salary
	FROM employees
	WHERE employee_id=143
);
#案例3：返回公司工资最少的员工的last_name，job_id和salary
SELECT 
	last_name,
	job_id,
	salary
FROM employees
WHERE salary=(SELECT MIN(salary) FROM employees LIMIT 1)

#案例4：查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT 
	department_id,
	MIN(salary) AS min_sal
FROM employees
GROUP BY department_id
HAVING min_sal>(
	SELECT MIN(salary)
	FROM employees
	WHERE department_id=50
);


#2.列子查询（多行子查询）
#案例1：返回location_id是1400或1700的部门中的所有员工姓名

SELECT last_name
FROM employees AS e
JOIN departments AS d
ON e.department_id=d.department_id
WHERE d.location_id IN(1400,1700);

SELECT last_name
FROM employees AS e
WHERE department_id IN(
	SELECT department_id
	FROM departments
	WHERE location_id IN (1400,1700)
);
#案例2：返回其它工种中比job_id为'IT_PROG'部门任一工资低的员工的员工号、姓名、job_id 以及salary

SELECT
	employee_id,
	last_name,
	job_id,
	salary
FROM employees
WHERE salary <ANY(
	SELECT salary
	FROM employees
	WHERE job_id='IT_PROG'
)
AND job_id<>'IT_PROG';

#3、行子查询（结果集一行多列或多行多列）
#案例：查询员工编号最小并且工资最高的员工信息
SELECT *
FROM employees
WHERE (employee_id,salary)=(
	SELECT MIN(employee_id),MAX(salary)
	FROM employees
)

#二、select后面 仅仅支持标量子查询
#案例：查询每个部门的员工个数

SELECT d.*,(
	SELECT COUNT(1)
	FROM employees AS e
	WHERE e.department_id=d.department_id
) AS sum_emp
FROM departments AS d
#案例2：查询员工号=102的部门名
SELECT (SELECT department_name
	FROM employees AS e
	JOIN departments AS d
	ON e.department_id=d.department_id
	WHERE employee_id=102
)AS 102号员工部门名;

#三、from后面
1/*
将子查询结果充当一张表，要求必须起别名
*/
#案例：查询每个部门的平均工资的工资等级

SELECT
	department_name,
	avg_sal,
	grade_level
FROM(SELECT AVG(salary) AS avg_sal,
	department_name
	FROM employees AS e
	LEFT JOIN departments AS d
	ON e.department_id=d.department_id
	GROUP BY e.department_id
) AS sal JOIN job_grades
ON avg_sal BETWEEN lowest_sal AND highest_sal

#四、exists后面（相关子查询）
/*
语法：
	exists（完整的查询语句）
	结果：
	1或0
*/
#案例1：查询有员工的部门名

SELECT department_name
FROM departments AS d
WHERE EXISTS(
	SELECT *
	FROM employees AS e
	WHERE d.department_id=e.department_id
);

#案例2：查询没有女朋友的男神信息

SELECT bo.*
FROM boys AS bo
WHERE bo.id NOT IN(
	SELECT boyfriend_id
	FROM beauty
);

SELECT bo.*
FROM boys bo
WHERE NOT EXISTS(
	SELECT boyfriend_id
	FROM beauty b
	WHERE bo.id=b.boyfriend_id
)

#练习
#1.查询Zlotkey相同部门的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE department_id=(SELECT department_id
	FROM employees
	WHERE last_name='Zlotkey'
);

#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。
SELECT employee_id,last_name,salary
FROM employees
WHERE salary>(SELECT AVG(salary) FROM employees);

#3.查询各部门中工资比本部门平均工资高的员工的员工号，姓名和工资
#方法一：
SELECT 
	employee_id,
	last_name,
	department_id,
	salary
FROM employees AS e1
WHERE salary>(SELECT AVG(salary)
	FROM employees AS e2 
	GROUP BY department_id 
	HAVING e1.`department_id`=e2.`department_id`
)ORDER BY employee_id,last_name;
#方法二：
SELECT 
	employee_id,
	last_name,
	e.department_id,
	salary
FROM employees AS e
JOIN(SELECT 
	AVG(salary) AS avg_sal,
	department_id
	FROM employees
	GROUP BY department_id
)AS avg_deps
ON e.department_id=avg_deps.department_id
AND salary> avg_deps.avg_sal
ORDER BY employee_id,last_name;

#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名
SELECT 
	e.employee_id,
	e.last_name
FROM employees AS e
WHERE e.department_id IN(
	SELECT
		DISTINCT department_id
	FROM employees
	WHERE last_name LIKE '%u%'
);

#5.查询在部门的location_id为1700的部门工作的员工的员工号
SELECT employee_id
FROM employees
WHERE department_id IN(
	SELECT DISTINCT department_id
	FROM departments
	WHERE location_id=1700
);

#6.查询管理者是King的员工姓名和工资
SELECT last_name,salary
FROM employees
WHERE manager_id IN(SELECT employee_id
	FROM employees
	WHERE last_name='K_ing'
);

# 7.查询工资最高的员工的姓名，要求first_name和last_name显示为一列，列名为姓名。
SELECT
	CONCAT(first_name,' ',last_name) AS 姓.名
FROM
	employees
WHERE salary=(SELECT MAX(salary)FROM employees);

#进阶8：分页查询★
/*
语法：
	select 查询列表
	from 表
	【join type join 表2
	on 连接条件
	where 筛选条件
	group by 分组字段having 分组后的筛选order by排序的字段】
	limit【offset，】size；
	
	offset要显示条目的起始索引（起始索引从0开始）
	size要显示的条目个数了
	
特点：
	①limit语句放在查询语句的最后
	②公式
	要显示的页数page，每页的条目数size 
	
	select 查询列表
	from 表
	limit（page-1）*size，size；
	
	size=10
	page
	1	0
	2	10
	3	20
	
*/

#案例1：查询前五条员工信息
SELECT * FROM employees LIMIT 5;

#案例2：查询第11条一第25条
SELECT * FROM employees LIMIT 10,15;

#案例3：有奖金的员工信息，并且工资较高的前10名显示出来
SELECT * FROM employees
WHERE commission_pct IS NOT NULL
DESC salary
LIMIT 10;

/*
已知表 stuinfo 
id 学号
name 姓名
email 邮箱 john@126.com 
gradeId 年级编号
sex性别男女
age 年龄

已知表 grade
id 年级编号
gradeName 年级名称
一、查询所有学员的邮箱的用户名（注：邮箱中@前面的字符）select substr（）
二、查询男生和女生的个数
三、查询年龄>18岁的所有学生的姓名和年级名称
四、查询哪个年级的学生最小年龄>20岁
五、试说出查询语句中涉及到的所有的关键字，以及执行先后顺序
*/
-- 1.
SELECT SUBSTR(email,1,INSTR(email,'@')-1)
FROM stuinfo

-- 2.
SELECT COUNT(1),sex
FROM stuinfo
GROUP BY sex

-- 3.
SELECT NAME,gradeName
FROM stuinfo AS s
JOIN grade AS g
ON s.gradeId=g.id
WHERE age>18

-- 4.
SELECT gradeName
FROM grade AS g
JOIN(SELECT MIN(age) AS min_age,gradeId
	FROM stuinfo
	GROUP BY gradeId
	HAVING min_age>20
) AS b
ON g.gradeId=g.gradeId

-- 5.
SELECT 字段
FROM 表名
JOIN 表名
ON 连接条件
WHERE 过滤条件
GROUP BY 分组条件
HAVING 过滤条件
ORDER BY 排序条件
LIMIT 偏移，条目数

-- 练习
#1.查询工资最低的员工信息：last_name，salary
SELECT
	last_name,
	salary
FROM
	employees AS e
WHERE e.salary=(SELECT MIN(salary) FROM employees)

#2.查询平均工资最低的部门信息
SELECT *
FROM departments AS d
JOIN (
	SELECT AVG(salary) AS avg_sal, -- 查平均工资最低的部门编号和最低平均工资
	e.department_id
	FROM employees AS e
	GROUP BY department_id
	ORDER BY avg_sal ASC
	LIMIT 1
) AS b
WHERE d.department_id=b.department_id

#3.查询平均工资最低的部门信息和该部门的平均工资
-- 上题中已经做了
#4.查询平均工资最高的job信息

SELECT *
FROM jobs AS j
JOIN(SELECT 
	AVG(salary) AS avg_sal,
	job_id
	FROM employees
	GROUP BY job_id
	ORDER BY avg_sal DESC
	LIMIT 1
)AS b ON j.job_id=b.job_id

#5.查询平均工资高于公司平均工资的部门有哪些？
SELECT * -- 求这些部门id的详细信息
FROM departments AS d
JOIN(SELECT 
	department_id -- 求部门平均工资大于公司平均工资的部门id
	FROM(SELECT -- 所有部门的平均工资
		AVG(salary) avg_sal,
		department_id 
		FROM employees AS e
		GROUP BY department_id) AS a
	JOIN(SELECT -- 全公司的平均工资
		AVG(salary) AS avg_sal
		FROM employees
	)AS b 
	ON a.avg_sal>b.avg_sal) AS c
ON d.department_id=c.department_id

#6.查询出公司中所有manager的详细信息
-- 从部门表的角度（错）
SELECT * FROM employees AS e
JOIN(SELECT department_name,
	manager_id AS man_id
	FROM departments
	WHERE manager_id IS NOT NULL
	GROUP BY department_id
) AS b
ON e.employee_id=b.man_id;

-- 从员工角度（正确答案）
SELECT * 
FROM (SELECT DISTINCT manager_id FROM employees) AS e1,employees AS e2
WHERE e1.manager_id=e2.employee_id;

SELECT * FROM departments;

#7.各个部门中最高工资中最低的那个部门的最低工资是多少
SELECT MIN(salary)
FROM employees AS e
JOIN(	SELECT
		MAX(salary) AS max_sal,
		department_id
	FROM employees
	GROUP BY department_id
	ORDER BY max_sal
	LIMIT 1
) AS b
ON e.department_id=b.department_id;

-- 验证
SELECT * FROM employees WHERE department_id=10

#8.查询平均工资最高的部门的manager的详细信息：last_name，department_id，email，salary

SELECT 
	last_name,
	department_id,
	email,
	salary
FROM employees
WHERE employee_id=(
	SELECT manager_id
	FROM departments AS d
	JOIN (SELECT 
			AVG(salary) AS avg_sal,
			department_id
		FROM employees
		GROUP BY department_id
		ORDER BY avg_sal DESC
		LIMIT 1
	)AS b ON d.department_id=b.department_id
)

#一、查询每个专业的学生人数
SELECT majorid,COUNT(10
FROM student
GROUP majorid;

#二、查询参加考试的学生中，每个学生的平均分、最高分
SELECT AVG(score),MAX(score),studentno
FROM result
GROUP BY studentno;
#三、查询姓张的每个学生的最低分大于60的学号、姓名

SELECT studentno,studentname,MIN(score)
FROM student AS s
JOIN result AS r
ON s.studentno=r.studentno
WHERE s.studentname LIKE '张%'
GROUP BY s.studentno
HAVING MIN(score)>60

#四、查询每个专业生日在1988-1-1”后的学生姓名、专业名称
SELECT studentname, majorname 
FROM student s 
JOIN major m 
ON s. majorid=m. majorid 
WHERE DATEDIFF(borndate,'1988-1-1')>0;

#五、查询每个专业的男生人数和女生人数分别是多少
SELECT COUNT（*）个数,sex,majorid 
FROM student 
GROUP BY sex,majorid;

方式二：
SELECT 
	majorid,
	(SELECT COUNT(*)FROM student WHERE sex='男)男,
	(SELECT COUNE(*)FROM student WHERE sex='女’)女
FROM student 
GROUP BY maiorid;
-- 没有sql和表结构 暂时不做
#六、查询专业和张翠山一样的学生的最低分
#七、查询大于60分的学生的姓名、密码、专业名
#八、按邮箱位数分组，查询每组的学生个数
#九、查询学生名、专业名、分数
#十、查询哪个专业没有学生，分别用左连接和右连接实现
#十一、查询没有成绩的学生人数


#进阶9：联合查询
/*
union 联合合并：将多条查询语句的结果合并成一个结果语法：
查询语句1union查询语句2union应用场景：
要查询的结果来自于多个表，且多个表没有直接的连接关系，但查询的信息一致时



#DML语言
/*
数据操作语言：
插入：insert
修改：update
删除：delete
*/
#一、插入语句
/*
语法：
insert into 表名(列名,...)
values(值1,...)
*/
#1.插入的值的类型要与列的类型一致或者兼容
USE girls;
INSERT INTO beauty(id,NAME,sex,borndate,phone,photo,boyfriend_id)
VALUES(13,'唐艺昕','女','1998-05-16','19855521122',NULL,2);
SELECT * FROM beauty;
#2.不可以为nul1的列必须插入值。可以为nul1的列如何插入值？
# 方式一：
INSERT INTO beauty(id,NAME,sex,phone,boyfriend_id)
VALUES(14,'张宝','男',1572380923,2);

#3.列的顺序是否可以调换
INSERT INTO beauty(NAME,sex,id，phone)
VALUES('蒋欣’,’女’,16,'110);
#4.列数和值的个数必须一致
INSERT INTO beauty（NAME,sex,id,phone)
VALUES('关晓彤’,’女’,17,'110);

#5.可以省略列名，默认所有列，而且列的顺序和表中列的顺序一致
INSERT INTO beauty VALUES(18,'张飞','男',NULL,'119',NULL,NULL);

#方式二：
/*
语法：
insert into表名set列名=值，列名=值，..
*/

INSERT INTO beauty
SET id=19,NAME='刘涛',phone='999';

#两种方式大pk
#1、方式一支持插入多行,支持子查询

INSERT INTO beauty VALUES(15,'唐棒昕','女','1990-4-23','1898888888',NULL,2)
,(17,'唐二昕','女','1990-5-21','18988588881',NULL,2)
,(16,'唐三昕','女','1990-6-23','18988838881',NULL,2);

# 2、方式一支持子查询，方式二不支持
INSERT INTO beauty(id,NAME,phone)
SELECT 26,'宋茜','118098661';

INSERT INTO beauty(id,NAME,phone)
SELECT id+20,boyname,'1235443'
FROM boys
WHERE id<3
/*

1.修改单表的记录★
语法：
	update 表名
	set列=新值，列=新值，..
	where筛选条件；
2.修改多表的记录【补充】
语法：
sq192语法：
update 表1 别名，表2别名
set列=值，...
where 连接条件
and 筛选条件；

sq199语法：
update 表1 别名
inner | left | right 
join表2 别名
on 连接条件
set 列=值...
where 筛选条件；
*/
#1.修改单表的记录
#案例1：修改beauty表电姓唐的女神的电话为138998

UPDATE beauty SET phone='138998888'
WHERE NAME LIKE '唐%';
#案例2：修改boys表中id好为2的名称为张飞，魅力值10
USE girls;
UPDATE boys SET boyname='张飞',usercp=10
WHERE id=2;
#2.修改多表的记录
#案例1：修改张无忌的女朋友的手机号为114
UPDATE boys AS bo
JOIN beauty AS b
ON bo.id=b.`boyfriend_id`
SET b.`phone`='1000'
WHERE bo.`boyName`='张无忌';


#三、删除语句
/*
方式一：delete语法：
语法：
1、单表的删除【★】
delete from 表名 where筛选条件
2、多表的删除【补充】
delete from 表名 where筛选条件2、多表的删除【补充】

方式二：truncate语法：truncate table表名；
*/
#方式一：delete
#1.单表的删除
#案例1：删除手机号以9结尾的女神信息
DELETE FROM beauty WHERE phone LIKE '%9';

# 2. 多表的删除(补充)
/*
sq192语法：
delete表1的别名，表2的别名from表1别名，表2别名where连接条件and筛选条件；
*/

#案例： 删除张无忌的的女朋友的信息
DELETE bo
FROM beauty b
JOIN boys AS bo
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`boyName`='张无忌';

SELECT *
FROM beauty b
JOIN boys AS bo 
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`boyName`='张无忌';

#案例：删除黄晓明的信息以及他女朋友的信息

DELETE b,bo
FROM beauty b
JOIN boys bo
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`boyName`='黄晓明';


SELECT *
FROM beauty b
JOIN boys bo
ON b.`boyfriend_id`=bo.`id`
WHERE bo.`boyName`='黄晓明';

#方式二：truncate语句
#案例：将魅力值>100的男神信息删除

TRUNCATE TABLE boys WHERE usercp>100:

--  语句允许添加 where条件

-- 删除表中的全部数据的时候使用

#delete pk truncate【面试题】
/*
1.delete 可以加where条件，truncate不能加
2.truncate删除，效率高一丢丢
3.假如要删除的表中有自增长列，如果用delete删除后，再插入数据，自增长列的值从断点开始，而truncate删除后，再插入数据，自增均列的值从1 开始
4.truncate除没有返回值，delete删除有返回值！
5.truncate删除不能回滚，delete删除可以回滚.
*/


-- 1.运行以下脚本创建表my_employees
CREATE TABLE my_employees(
Id INT(10), First_name VARCHAR(10), Last_name VARCHAR(10), Userid VARCHAR(10), Salary DOUBLE(10,2) 
)

CREATE TABLE users(
id INT, userid VARCHAR(10), department_id INT )

-- 2.显示表my_employees的结构
DESC my_employees;

-- 3.向my employees表中插入下列数据
INSERT INTO my_employees
VALUE(1,'patel','Ralph','Rpatel',895),
(2,'Dancs','Betty','Bdancs' ,860),
(3,'Biri','Ben','Bbiri',1100),
(4,'Newman','Chad','Cnewman',750),
(5,'Ropeburn','Audrey','Aropebur',1550);

SELECT * FROM my_employees;


SELECT * FROM  users;
DESC users;
-- 4.向users表中插入数据
INSERT INTO users
VALUE(1,'Rpatel',10),
(2,'Bdancs',10),
(3,'Bbiri',20),
(4,'Cnewman',30),
(5,'Aropebur',40);

-- 5.将3号员工的last name修改为“drelxer”
UPDATE my_employees
SET last_name='drelxer'
WHERE id=3

-- 6.将所有工资少于900的员工的工资修改为1000
UPDATE employees
SET salary=1000
WHERE Salary<900;

-- 7.将userid为Bbiri的user表和my_employees表的记录全部删除
DELETE u,m
FROM users AS u JOIN my_employees AS m
ON m.userid=u.userid
WHERE m.userid='Bbiri';

-- 8.删除所有数据
DELETE FROM users;
DELETE FROM my_employees;

-- 9.检查所作的修正
SELECT * FROM users;
SELECT * FROM my_employees;

-- 10.清空表my_employees
TRUNCATE users;
TRUNCATE my_employees;

#DDL
/*
数据定义语言
库和表的管理
一、库的管理
创建、修改、删除
二、表的管理
创建、修改、删除
创建：create
修改：alter
删除：drop
*/
#一、库的管理
#1、库的创建
/*
语法：
create database库名；
*/
#案例：建库Books

CREATE DATABASE books;

CREATE DATABASE IF NOT EXISTS books;

CREATE TABLE IF NOT EXISTS books.novel(NO VARCHAR(20),id VARCHAR(20));

# 2.库的修改
RENAME DATABASE books TO book; -- 已经废弃的语法

# 更改库的字符集
ALTER DATABASE bookS CHARACTER SET utf8mb4;

#3、库的删除
DROP DATABASE books;

DROP DATABASE IF EXISTS books;
#二、表的管理
#1.表的创建★

/*
语法：
create table表名（
	列名列的类型【（长度）约束】，
	列名列的类型【（长度）约束】，
	列名列的类型【（长度）约束】，
	列名列的类型【（长度）约束】
）
*/
CREATE TABLE book(
	id INT, -- 编号
	bName VARCHAR(20), -- 图书名
	price DOUBLE, -- 价格
	authorId INT, -- 作者
	publishDate DATETIME -- 出版日期
);

CREATE TABLE author(
	id INT,
	au_name VARCHAR(20),
	nation VARCHAR(10)
);

DESC author;

#2.表的修改
/*
alter table 表名 add|drop|modify|change colum 列名 类型;
*/
#①改变列名
ALTER TABLE book CHANGE COLUMN publishDate pubdate DATETIME;
  
#②修改列的类型或约束
ALTER TABLE book MODIFY COLUMN pubdate TIMESTAMP;

DESC books.book

#③添加新列
ALTER TABLE author ADD COLUMN annual DOUBLE;

#④删除列
ALTER TABLE author DROP COLUMN annual;

#⑤修改表名
ALTER TABLE author RENAME TO book_author;

# 3.表的删除

DROP TABLE IF EXISTS author;
SHOW TABLES;
 
# 建表通用做法
DROP TABLE IF EXISTS 表名;
CREATE TABLE 表名();


#4.表的复制
INSERT INTO  books.author VALUES
(1,'村上春树',"日本",1000),
(2,'莫言','中国',2000),
(3,'冯唐','中国',3999),
(4,'金庸','中国',2444);
SELECT * FROM author;
DESC author;

# 1.仅仅复制表的结构
CREATE TABLE copy1 LIKE author;

SHOW TABLES;
SELECT * FROM copy1;

# 2.复制表的结构和部分内容
CREATE TABLE copy2 SELECT * FROM author WHERE annual>1500;
SELECT * FROM copy2;

# 3.复制表的部分结构和内容
CREATE TABLE copy3 SELECT id,au_name FROM author;
SELECT * FROM copy3;

# 4.仅仅复制部分表结构

CREATE TABLE copy4 SELECT au_name,annual FROM author WHERE 1=0; -- 或者where 0
SELECT * FROM copy4;

# 测试
-- 1.创建表dept1
DROP TABLE IF EXISTS dept1;
CREATE TABLE IF NOT EXISTS dept1(id INT(7),NAME VARCHAR(25));
USE books;
SHOW TABLES;

-- 2.将表departments中的数据插入新表dept2中
CREATE TABLE IF NOT EXISTS dept2 LIKE myemployees.departments;
INSERT INTO dept2 SELECT * FROM myemployees.departments;

SELECT * FROM dept2;

-- 3.创建表emp5
CREATE TABLE IF NOT EXISTS emp5(
	id INT(7),
	First_name VARCHAR(25),
	Last_name VARCHAR(25),
	Dept_id INT(7)
);

-- 4.将Last_name的长度增加到50
ALTER TABLE emp5 MODIFY COLUMN Last_name VARCHAR(50);

DESC emp5;

-- 5.根据表employees创建employees2
SHOW TABLES;
CREATE TABLE IF NOT EXISTS employees2 LIKE myemployees.employees;
INSERT INTO employees2
SELECT * FROM myemployees.employees;

-- 6.删除表emp5
DROP TABLE IF EXISTS emp5;

-- 7.将表employees2重命名为emp5
ALTER TABLE employees2 RENAME TO emp5;s

-- 8.在表dept和emp5中添加新列test_column，并检查所作的操作
ALTER TABLE dept1 ADD COLUMN test_column VARCHAR(20);

ALTER TABLE emp5 ADD COLUMN test_column VARCHAR(20);

-- 9.直接删除表emp5中的列 department_id
ALTER TABLE emp5 DROP COLUMN department_id;

#常见的数据类型
/*
数值型：
整型
小数：
定点数
浮点数
字符型：
较短的文本：char、varchar
较长的文本：text、blob（较长的二进制数据）
日期型：
*/

#一、鉴型
]/*
分类：
tinyint、smallint、mediumint、int/integer、bigint
1	   2	       3	4	     8
特点：
*/
#1.如何设置无符号和有符号
CREATE DATABASE IF NOT EXISTS prac;
USE prac;
CREATE TABLE tab_int(
	t1 INT
);

INSERT INTO tab_int VALUES(-54324);

CREATE TABLE IF NOT EXISTS tab_int2(
	t1 INT,
	t2 INT UNSIGNED
);

INSERT INTO tab_int2 VALUES(-534,346),
(-234,5764);
DESC tab_int2;

# 现在这个语法是错误的 不能插入超过范围的数据
INSERT INTO tab_int2 VALUES(-122,-234);
SELECT * FROM tab_int2;

INSERT INTO tab_int VALUES(2147483647);

#错过范围 不可以insert
INSERT INTO tab_int VALUES(2147483648);

SELECT * FROM tab_int;

# zerofill有unsigned的作用，插入负数会报错
CREATE TABLE IF NOT EXISTS tab_int3(t INT(7) ZEROFILL);
INSERT INTO tab_int3 VALUES(123);
#INSERT INTO tab_int3 VALUES(-123);
SELECT * FROM tab_int3;

#二、小数
]/*
1.浮点型s
float(M,D)
double(M,D)
2.定点型
dec(M,D)
decimal(M,D)

① 
M：整数部位+小数部位
D：小数部位
如果超过范围，则(旧版本插入临界值)直接报错

②
M和D都可以省略
如果是decima1，则M默认为10，D默认为0
如果是float和doub1e，
则会根据插入的数值的精度来决定精度

③定点型的精确度较高，
如果要求插入数值的精度较高
如货币运算等则考虑
*/

#原则：所选择的类型越简单越好，能保数值的类型越小越好
CREATE TABLE IF NOT EXISTS tab_float(
	f1 FLOAT(5,2),
	f2 FLOAT(5,2),
	f3 FLOAT(5,2)
);

SELECT * FROM tab_float;

INSERT INTO tab_float VALUES(123.454,123.255,124.556);
INSERT INTO tab_float VALUES(123.45,123.24,123.43);
INSERT INTO tab_float VALUES(123.4,123.6,123.3);

#三、字符型
1/*
较短的文本：
char
varchar
较长的文本：
text
p1ob（较大的二进制）

特点：
	写法		M的意思					特点		空间耗费	效率
char 	char（M）	最大的字符数，可以省略，默认为1		固定长度的字符	比较耗费	高
varchar varchar（M）	最大的字符数，不可以省略		可变长度的字符	比较节省	低
*/


-- 枚举类型
USE prac;
CREATE TABLE IF NOT EXISTS tab_char(
	c1 ENUM('a','b','c')
);
DESC prac.tab_char;

INSERT INTO tab_char VALUES('a');
INSERT INTO tab_char VALUES('A'); -- 可以插入 会自动转换成小写
INSERT INTO tab_char VALUES('m'); -- 失败
SELECT * FROM tab_char;

-- set是集合，有序，插入重复数据也不会重复
CREATE TABLE IF NOT EXISTS tab_set(
	s1 SET('a','b','c','d','e')
);
INSERT INTO tab_set VALUE('a');
INSERT INTO tab_set VALUE('a,b');
INSERT INTO tab_set VALUE('a,E,b');
INSERT INTO tab_set VALUE('a,b,a');
SELECT * FROM tab_set;


# 日期型
/*
分类：
date只保存日期
time 只保存时间
year只保存年
datetime保存日期+时间
timestamp保存日期+时间
特点：
		字节	范围		时区影响
datetime	8	1000-9999	不受
timestamp	3	1970-2038	受
*/
DROP TABLE IF EXISTS tab_date;
CREATE TABLE IF NOT EXISTS tab_date(
	t1 DATETIME,
	t2 TIMESTAMP
);

INSERT INTO tab_date VALUES(NOW(),NOW());

SELECT * FROM tab_date;

SHOW VARIABLES LIKE 'time_zone';

SET time_zone='+9:00';

# 常见约束

CREATE TABLE 表名(
	字段名 字段类型 约束
)



# 创建表时添加约束

# 1.添加列级约束

/*
语法：
直接在字段名和类型后面追加约束类型即可。
只支持：默认、非空、主键、唯一
*/


DROP DATABASE IF EXISTS students;
CREATE DATABASE IF NOT EXISTS students;
USE students;
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY, -- 主键
	stuname VARCHAR(20) NOT NULL, -- 非空
	gender CHAR(1) CHECK(gender='男' OR gender='女'), -- 性别
	seat INT UNIQUE, -- 唯一
	age INT DEFAULT 18, -- 默认约束
	majorid INT REFERENCES major(id) -- 外键
);
CREATE TABLE IF NOT EXISTS major(
	id INT PRIMARY KEY,
	majorname VARCHAR(20)
);
DESC stuinfo;
SHOW INDEX FROM stuinfo;
#2.添加表级约束
/*
语法：在各个字段的最下面
constraint约束名约束类型（字段名） 可以省略
*/
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	CONSTRAINT pk PRIMARY KEY(id), -- 主键
	CONSTRAINT uq UNIQUE(seat), -- 唯一键
	CONSTRAINT ck CHECK(gender='男' OR gender='女'), -- 检查
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id) -- 外键
);
SHOW INDEX FROM stuinfo;
DESC stuinfo;

# 通用的写法
DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY,
	stuname VARCHAR(20) NOT NULL,
	gender CHAR(1),
	age INT DEFAULT 28,
	seat INT UNIQUE,
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
);
/*
含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确和可靠性
分类：六大约束
	NOT NULL：非空，用于保证该字段的值不能为空比如姓名、学号等
	DEFAULT：默认，用于保证该字段有默认值
	比如性别
	PRIMARY KEYI主键，用于保证该字段的值具有唯一性，并且非空
	比如学号、员工编号等
	UNTQUE：唯一，用于保证该字段的值具有唯一性，可以为空比如座位号
	CHECK：检查约束【mysq1中不支持】
	比如年龄、性别
	FOREIGN REY：外键，用于限制两个表的关系，用于保证该字段的值必须来自于主表的关联列的值
	在从表添加外键约束，用于引用主表中某列的值
	比如学生表的专业编号，员工表的部门编号，员工表的工种编号
添加约束的时机：
	1.创建表时
	2.修改表时
约束的添加分类：
	列级约束：
		六大约束语法上都支持，但外键约束没有效果
	表级约束：
		除了非空、默认，其他的都支持
主键和唯一的大对比：
	保证唯一性	是否允许为空	一个表中可以有多个	是否允许组合
主键	✔		✖		最多有1个		✔，不推荐
唯一	✔		✔		可有有多个		✔，不推荐


*/

INSERT INTO major VALUES(1,'java'),(2,'h5');
INSERT INTO stuinfo VALUES
(1,'join','男',12,19,1),
(2,'lily','女',12,18,1);


# 修改表时添加约束
DROP TABLE IF NOT EXISTS stuinfo;
CREATE TABLE stuinfo(
	id INT,
	stuname VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT
	
);

# 1.添加非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20) NOT NULL;

# 2.添加默认约束
ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 18;

# 3.添加主键

-- 方式一
ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;
-- 方式二
ALTER TABLE stuinfo ADD PRIMARY KEY(id);

# .删除非空约束
ALTER TABLE stuinfo MODIFY COLUMN stuname VARCHAR(20);

# 4.添加唯一键
ALTER TABLE stuinfo

# 测试
/*
1.向表emp2的id列中添加PRIMARYKEY约束（my_emp_id_pk）.
2.向表dept2的id列中添加PRIMARYKEY约束（my_dept_id_pk）.
3.向表emp2中添加列dept_id，并在其中定义FOREIGNKEY约束，与之相关联的列是dept2表中的id列。
*/
SHOW DATABASES;
SHOW TABLES;

SELECT * FROM dept2;
SELECT * FROM emp5;
-- 1
ALTER TABLE emp5 MODIFY COLUMN employee_id INT PRIMARY KEY;
ALTER TABLE emp5 ADD CONSTRAINT my_emp_id_pk PRIMARY KEY(employee_id);

-- 2
ALTER TABLE dept2 MODIFY COLUMN department_id INT PRIMARY KEY;
ALTER TABLE deot2 ADD CONSTRAINT my_dept_id_pk PRIMARY KEY(department_id);
-- 3
ALTER TABLE emp5 ADD COLUMN dept_id INT;
ALTER TABLE emp5 ADD CONSTRAINT fk_emp5_dept2 FOREIGN KEY(dept_id) REFERENCES dept2(department_id);




