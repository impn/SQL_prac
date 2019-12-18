# 变量 

/*
系统变量：
	全局变量
	会话变量
自定义变量:
	用户变量
	局部变量
*/
# 系统变量
/*
说明：变量由系统提供，不是用户定义，属于服务器层面
使用的语法：
1. 查看所有的系统变量
show variables;
*/

SHOW VARIABLES;
SHOW GLOBAL VARIABLES;
SHOW SESSION VARIABLES;

# 2. 查看满足条件的部分系统变量
SHOW GLOBAL VARIABLES LIKE '%char%';

# 3. 查看指定某个系统变量的值
SELECT @@global.autocommit;

# 4.为系统的某个变量赋值

SET @@global.autocommit=0;

-- 如果是全局级别 则需要加global 如果是会话级别则需要加session 如果不写,则默认session

-- 查看隔离级别
SELECT @@tx_isolation;

/*
全局变量
作用域：
	服务器每次启动将会为所有的全局变量赋初始值，针对于所有的会话有效，但不能跨重启
如果想跨重启，则需要修改配置文件	
*/

# 会话变量
/*
作用域：仅仅这么对与当前会话连接有效


*/
# 查看所有的会话变量

SHOW VARIABLES;
SHOW SESSION VARIABLES;

# 查看部分的会话变量
SHOW VARIABLES LIKE '%char%';
SHOW SESSION VARIABLES LIKE '%char%';

# 查看指定的某个会话变量

SELECT @@session.tx_isolation;

# 为某个汇会话变量赋值
-- 方式一：
SET @@session.tx_isolation='read-uncommitted';

-- 方式二：
SET SESSION tx_isolation='read-committed';

# 自定义变量
/*
说明：变量使用户自定义的，你是由系统的：
使用步骤：
声明
赋值
使用（查看、比较、运算等）
*/

#1. 用户变量
/*
作用域：针对于当前绘画连接有效，同于会话变量的作用域
应用在任何地方
*/
#①声明并初始化
SET @m1=100;
SET @m2:=1000;
SELECT @m3:= 10010;

SELECT @m1,@m2,@m3,@m4;

SET @m2:='jack';

# 方式二：
SELECT COUNT(1) INTO @m4 FROM employees; 

#③ 使用 （查看用户变量值）

SELECT @m4;

# 2.局部变量
/*
作用域：仅仅在定义它的begin和end中有效
*/
#①声明
DECLARE 变量名 类型;
DECLARE 变量名 类型 DEFAULT 值;

#②赋值
/*
方式一：通过set或select
set 局部变量名=值
set 局部变量名:=值
select 用户变量名:=值

方式二：通过select into
select 字段 into @局部变量名
from 表
*/

#③使用
SELECT 局部变量名;

# 案例 声明两个变量并赋初值，求和 打印
SET @a1:=19;
SET @a2:=11;
SET @a3=@a1+@a2;
SELECT @a3;

# 局部变量需要写在begin和end中
BEGIN
DECLARE m INT DEFAULT 1;
DECLARE n INT DEFAULT 2;
DECLARE SUM INT ;
SET SUM=m+n;

SELECT SUM;
END
#存储过程和函数
/*
存储过程和函数：类似于java中的方法
好处：
1.提高代码的重用性
2.简化操作

*/

# 储存过程
/*
含义：一组预先编译好的sQL语句的集合，理解成批处理语句\好处：
1.提高代码的重用性
2.简化操作
3.减少了编译次数 并且 减少了和数据库服务器的连接次数，提高了效率

*/
#一、创建语法
CREATE PROCEDURE 存储过程名(参数列表);
BEGIN
	存储过程体
END
注意：
1、参数列表包含三部分
参数模式 参数名 参数类型
举例：
IN stuname VARCHAR(20)

参数模式： 
IN: 该参数可以作为输入，也就是该参数需要调用方法传入值
OUT: 该参数可以作为输出，也就是该参数可以作为返回值
INOUT: 该参数可以作为输出也可以作为输入，也就是该参数既需要传入值，又可以返回值

2、如果存储过程提仅仅只有一句话 BEGIN end可以省略
存储过程提中的每一条sql语句结尾要求必须加分号。
存储过程的结尾可以使用 delimiter重新设置
语法：
DELIMITER 结束标记
案例：delimiter $
#二、调用语法

CALL 存储过程名(实参列表);

#1.空参列表
-- 案列：插入到admin表中5条记录
SELECT * FROM admin;

DROP PROCEDURE IF EXISTS myp1;
DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username,PASSWORD)
	VALUES('tom','2001'),('jack','2001'),('rose','2001'),('lily','2001'),('tim','2001');
END $



CALL myp1();

创建带 IN 模式的参数的存储过程
#案例1：创建存储过程实现根据女神名，查询对应的男神信息


DROP PROCEDURE IF EXISTS myp2;

DELIMITER $
CREATE PROCEDURE myp2(IN beautyName VARCHAR(20))
BEGIN
	SELECT bo.*
	FROM boys AS bo
	RIGHT JOIN beauty AS b
	ON bo.id=b.boyfriend_id
	WHERE b.name=beautyName;
END $

CALL myp2('柳岩');

SELECT * FROM beauty;
SELECT * FROM boys;
UPDATE boys SET id=10 WHERE userCP=300; 
UPDATE beauty SET boyfriend_id=10 WHERE id=1;
#案例2：创建存储过程实现，用户是否登录成功


DROP PROCEDURE IF EXISTS myp3;
DELIMITER $
CREATE PROCEDURE myp3 (IN username VARCHAR(20),IN passwd VARCHAR(20))
BEGIN
DECLARE result INT DEFAULT 0;
	SELECT COUNT(1) INTO result -- 赋值
	FROM admin
	WHERE admin.username = username
	AND admin.password=passwd;
SELECT IF(result>0,"成功","失败") AS 登录结果;
END $


SELECT * FROM admin;

CALL myp3("john",8888);

#3、创建带out模式的存储过程
#案例1：根据女神名，返回对应的男神名

DROP PROCEDURE IF EXISTS myp5;
DELIMITER $
CREATE PROCEDURE myp5 (IN beautyName VARCHAR(20),OUT boyName VARCHAR(20))
BEGIN
	SELECT bo.boyname INTO boyName
	FROM boys AS bo
	JOIN beauty AS b
	ON bo.id=b.boyfriend_id
	WHERE b.name=beautyName;
END $

-- 调用
SET @bname:='';
CALL myp5("柳岩",@bname);
SELECT @bname;

#案例2：根据女神名，返回对应的男神名和男神魅力值
DROP PROCEDURE myp6;
DELIMITER $
CREATE PROCEDURE myp6 (
  IN beautyName VARCHAR (20),
  OUT boyNames VARCHAR (20),
  OUT userCPs INT
) 
BEGIN
	SELECT 
	    bo.boyName,bo.userCP INTO boynames,userCPs 
	FROM boys AS bo 
	JOIN beauty AS b 
	ON bo.id = b.boyfriend_id 
	WHERE b.name = beautyName;
END $

SET @c:='柳岩';
CALL myp6(@c,@a,@b);
SELECT @c AS 姓名,@a AS 男朋友,@b AS 魅力值;
  