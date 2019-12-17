# TCL
/*
Transaction Control Language 事务控制语言

事务：
一个或一组sq1语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。
案例： 转账
张三丰	1000 
郭襄	1000

update 表 set 张三丰的余额=500 where name='张三丰'
update 表 set 郭襄的余额=1500 where name = '郭襄'

事务：事务由单独单元的一个或多个SQL语句组成，在这个单元中，
每个MysQL语句是相互依赖的。而整个单独单元作为一个不可分割的整体，
如果单元中某条sQL语句一旦执行失败或产生错误，整个单元将会滚。
所有受到影响的数据将返回到事物开始以前的状态；
如集单元中的所有SQL语句均执行成功，则事物被顺利执行。
*/

SHOW ENGINES;
/*
事务的特性：
ACID
原子性：一个事务不可再分割，要么都执行要么都不执行
一致性：一个事务执行会使数据从一个一致状态切换到另外一个一致状态
隔离性：一个事务的执行不受其他事务的千扰
持久性：一个事务一旦提交，则会永久的改变数据库的数据|

事务的创建

隐式的创建
隐式事务：事务没有明显的开启和结束的标记
比如insert update delete

显式事物：
事务具有明显的开始和结束的标记
前提：必须先设置自动提交功能为禁用
开启事务的语句


*/
SHOW VARIABLES LIKE 'autocommit';

SET autocommit=0;

/**
步骤1：开启事务
set autocommit=0;
start transaction;
步骤2：编写事务中的sql语句

语句1;
语句2;
...

步骤3：结束事务
commit;提交事务
rollback;回滚
*/

# 演示事务
USE prac;
DROP TABLE IF EXISTS account;

CREATE TABLE IF NOT EXISTS account(
	id INT,
	username VARCHAR(20),
	balance INT
);

INSERT INTO account VALUES(1001,'张无忌',1000),
(1002,'郭襄',1000);

SELECT * FROM account;

# 开启事务
SET autocommit=0;
START TRANSACTION;
# 编写一组事务
UPDATE account SET balance =500 WHERE username='张无忌';
UPDATE account SET balance =1500 WHERE username='郭襄';
# 提交
COMMIT;


/*
对于同时运行的多个事务，当这些事务访问数据库中相同的数据时，如果没有采取必要的隔离机制，就会导致各种并发问题：
>脏读：对于两个事务T1，T2，T1读取了已经被T2更新但还没有被提交的字段.
之后，若T2回滚，T1读取的内容就是临时且无效的.

>不可重复读：对于两个事务T1，T2，T1读取了一个字段，然后T2更新了该字段.
之后，T1再次读取同一个字段，值就不同了.

>幻读：对两个事务T1，T2，T1从一个表中读取了一个字段，然后T2在该表中插入了一些新的行.
之后，如果T1再次读取同一个表，就会多出几行.
*/
-- 视图 
-- 感觉像一个大的别名，类似一张动态的表，他会随着原始数据的改变而动态更新里面的数据

CREATE VIEW my_v1 
AS SELECT studentname, majorname 
FROM student s 
INNER JOIN maior m 
ON s.majorid=m. majorid 
WHEREs. majorid=1;


# 创建视图
/*
1.查询邮箱中包含a字符的员工名、部门名和工种信息
2.查询各部门的平均工资级别
3.查询平均工资最低的部门信息
4.查询平均工资最低的部门名和工资
*/
DROP VIEW IF EXISTS prac.v2;
CREATE VIEW prac.v2 AS
SELECT 
	e.last_name,
	d.department_name,
	e.job_id 
FROM employees e 
JOIN departments d
ON e.department_id=d.department_id
JOIN jobs j ON j.job_id=e.job_id ;

SELECT * FROM prac.v2;


# 视图修改
USE myemployees;

-- 创建视图(方式1)
CREATE OR REPLACE VIEW v3 AS
SELECT 
	employee_id,
	last_name,
	job_title,
	e.department_id,
	department_name
FROM employees AS e
JOIN departments AS d
ON e.department_id=d.department_id
JOIN jobs AS j
ON j.job_id=e.job_id;

SELECT * FROM v3;

-- 修改方式2
ALTER VIEW v3 AS
SELECT * FROM employees;


-- 删除视图

DROP VIEW IF EXISTS v3,prac.v2;

-- 查看视图
DESC v3;

SHOW CREATE VIEW v3;

#一、创建视图emp_v1，要求查询电话号码以011’开头的员工姓名和工资、邮箱

SELECT * FROM employees;
CREATE OR REPLACE VIEW emp_v1 AS
SELECT
	last_name,
	salary,
	email
FROM employees
WHERE phone_number LIKE '011%';

SELECT * FROM emp_v1;
#二、创建视图emp_v2，要求查询部门的最高工资高于12000的部门信息
CREATE OR REPLACE VIEW emp_v2 AS
 (SELECT 
		department_id,
		MAX(salary) AS max_sal
	FROM employees AS e
	WHERE department_id IS NOT NULL
	GROUP BY department_id
	HAVING max_sal>12000);
	
SELECT 
	d.*,
	max_sal 
FROM departments AS d
JOIN  emp_v2 AS t1
ON d.department_id=t1.department_id;

# 视图的更新
-- 更改视图的

CREATE OR REPLACE VIEW my_v1 AS
SELECT 
	last_name,
	email-- ,
	-- salary*12*(1+ifnull(commission_pct,0)) as 'annual salary'
FROM employees;

# 1.插入
INSERT INTO my_v1 VALUES('张飞','213@123.com');

SELECT * FROM employees;

-- 视图可以插入，在视图没有做复杂处理的时候，可以插入或者更改与原表结构相同或者少于原表结构字段的行，但是不能插入和原表字段结构不同的行。

# 2.修改
UPDATE my_v1 SET last_name='张无忌' WHERE last_name='张飞';

# 3.删除
DELETE FROM my_v1 WHERE last_name='张无忌'; 











