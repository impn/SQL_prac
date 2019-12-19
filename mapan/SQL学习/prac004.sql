# 函数
/*
含义：一组预先编译好的sQL语句的集合，理解成批处理语句
1、提高代码的重用性
2、简化操作
3、减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率

区别：

存储过程：可以有0个返回，也可以有多个返回，适合做批量插入、批量更新
函数：只能有1个返回，适合做处理数据后返回一个结果
*/

#一、创建语法
CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型

BEGIN
	函数体
END
/*
注意：
1.参数列表包含两部分：
参数名参数类型

2.函数体：肯定会有return语句，如果没有会报错
如果return语句没有放在函数体的最后也不报错，但不建议

return值；
3.函数体中仅有一句话，则可以省略begin end
4.使用delimiter语句设置结束标记
*/
#二、调用语法
-- SELECT函数名（参数列表）

-- 1.无参又返回的
-- 案例：返回公司的员工个数
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0; -- 定义一个变量
	SELECT COUNT(1) INTO c -- 为变量赋值
	FROM employees;
	RETURN c;
END $

SELECT myf1();
-- 2.有参有返回
-- 根据员工名，返回他的工资

DROP FUNCTION myf2;
DELIMITER $
CREATE FUNCTION myf2(emp_name VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal=0; -- 定义了一个用户变量
	
	SELECT salary INTO @sal
	FROM employees
	WHERE last_name=emp_name
	LIMIT 1;
	RETURN @sal;
END $


SELECT myf2('K_ing');

# 案例2 根据部门名，返回该部门的平均工资
DROP FUNCTION myf3;
DELIMITER $
CREATE FUNCTION myf3(deptName VARCHAR(20))RETURNS DOUBLE
BEGIN
	DECLARE sal DOUBLE;
	SELECT AVG(salary) INTO sal
	FROM employees AS e
	JOIN departments AS d
	ON e.department_id=d.department_id
	WHERE d.department_name=deptName;
	RETURN sal;
END $
SELECT myf3("Adm");

# 3.查看函数
SHOW CREATE FUNCTION myf3;

# 4.删除函数
DROP FUNCTION myf3;

#案例
#一、创建函数，实现传入两个float，返回二者之和

DELIMITER $
CREATE FUNCTION myfun1(f1 FLOAT,f2 FLOAT) RETURNS FLOAT
BEGIN
	DECLARE f3 FLOAT;
	SELECT f2+f1 INTO f3;
	RETURN f3;
END $
SELECT myfun1(23.5,334.45);

#流程控制结构
1/*
顺序结构：程序从上往下依次执行
分支结构：程序从两条或多条路径中选择一条去执行
循环结构：程序在满足一定条件的基础上，重复执行一段代码
*/

#一、分支结构
#1.if函数
/* 功能：现简单的双分刻
语法：
select if(表达式1,表达式2,表达式3)
执行顺序：
如果表达式1成立，则IF函数返回表达式2的值，否则返回表达式3的值
应用：任何地方

特点：
①可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，BEGINEND中或BEGINEND的外面
可以作为独立的语句去使用，只能放在BEGIN END中

②如果WHEN中的值满足或条件成立，则执行对应的THEN后面的语句，并且结束CASE
如果都不满足，则执行ELSE中的语句或值

③ELSE可以省略，如果ELSE省略了，并且所有WHEN条件都不满足，则返回NULL
*/

#2.case结构
/*
情况1：类似于java中的switch语句，一般用于实现的等值判断
语法：
	CASE 变量|表达式|字段
	WHEN 要判断的值THEN 返回的值1
	WHEN 要判断的值THEN 返回的值2
	...
	ELSE 要返回的值n
	END

情况2：类似于java中的多重IF语句，一般用于实现区间判断
语法：
	CASE
	WHEN 要判断的条件1 THEN 返回的值1
	WHEN 要判断的条件2 THEN 返回的值2
	...
	ELSE 要返回的值n
	END

特点：
可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，BEGIN END中或BEGIN END的外面
可以作为独立的语句去使用，只能放在EGIN END中

*/
#案例
#创建存储过程，根据传入的成绩，来显示等级，比如传入的成绩：90-100，显示A，80-90，显示B，60-80，显示c，否则，显示D

DELIMITER $
CREATE PROCEDURE test_case(IN score INT)
BEGIN
	CASE
	WHEN score BETWEEN 90 AND 100 THEN SELECT "A";
	WHEN score BETWEEN 80 AND 90 THEN SELECT "B";
	WHEN score BETWEEN 70 AND 80 THEN SELECT "C";
	ELSE SELECT "D";
	END CASE;
END $
























