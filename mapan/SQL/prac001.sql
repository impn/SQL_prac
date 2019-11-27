SELECT * FROM employees ORDER BY salary DESC; -- 从高到低

SELECT * FROM employees ORDER BY salary ASC; -- 从低到高 asc代表升序 ，desc代表降序 

SELECT * FROM employees ORDER BY salary;  -- 如果不写就默认asc升序

SELECT * FROM employees WHERE department_id >= 90 ORDER BY hiredate ASC;

SELECT * , salary*12*(1+IFNULL(commission_pct,0)) AS `年薪` 
FROM employees 
ORDER BY `年薪` DESC;

-- 描述表的结构
DESC departments

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




