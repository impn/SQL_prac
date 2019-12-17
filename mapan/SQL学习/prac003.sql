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




