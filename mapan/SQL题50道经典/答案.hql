-- 1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数

SELECT * FROM student AS t3
RIGHT JOIN(SELECT
        t1.sid,
        s1,
        s2
    FROM    
        (SELECT sid,score AS s1 FROM sc WHERE cid='01') AS t1, -- 01课程的成绩
        (SELECT sid,score AS s2 FROM sc WHERE cid='02') AS t2  -- 02课程的成绩
    WHERE t1.sid =t2.sid
    AND s1>s2) AS t4
ON t3.sid=t4.sid;

-- 1.1 查询同时存在" 01 "课程和" 02 "课程的情况

SELECT 
    t1.sid
FROM
    (SELECT sid FROM sc WHERE cid=01) AS t1, -- 查询01课程情况
    (SELECT sid FROM sc WHERE cid=02) AS t2 -- 查询02课程情况
WHERE
    t1.sid = t2.sid;

-- 1.2 查询存在"01"课程但可能不存在"02"课程的情况(不存在时显示为 null )

SELECT t1.sid
FROM (SELECT sid FROM sc WHERE cid=01) AS t1 -- 查询01课程情况
LEFT JOIN (SELECT sid FROM sc WHERE cid=02) AS t2  -- 查询02课程情况
ON t1.sid = t2.sid
WHERE t2.sid is null;

-- 1.3 查询不存在"01"课程但存在"02"课程的情况

SELECT t2.sid
FROM     (SELECT sid FROM sc WHERE cid=01) AS t1 -- 查询01课程情况
RIGHT JOIN     (SELECT sid FROM sc WHERE cid=02) AS t2 -- 查询02课程情况
ON t1.sid=t2.sid
WHERE t1.sid is null; 

-- 2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
 
 -- 下面sql在mysql中可以跑，但是在hive中不能运行。
SELECT
    t2.sid,
    t2.sname,
    AVG(t1.score) AS avg_sc
FROM
    sc AS t1,
    student AS t2
WHERE t1.sid= t2.sid
GROUP BY t2.sid
HAVING avg_sc>=60;

-- 下面SQL在hive中正常运行
SELECT
    t1.sid,
    t1.sname,
    t2.avg_sc
FROM
    student AS t1,
    (SELECT sid,avg(score) AS avg_sc FROM sc GROUP BY sid) AS t2
WHERE t1.sid=t2.sid
AND t2.avg_sc>=60;

-- 3. 查询在 SC 表存在成绩的学生信息

-- 同样的，下面的代码在mysql中可以运行，在hive中不能运行
SELECT t2.* 
FROM
    sc AS t1,
    student AS t2 
WHERE t1.sid=t2.sid 
GROUP BY t1.sid;

-- 在hive中运行的代码
SELECT t2.*
FROM (SELECT sid FROM sc GROUP BY sid ) AS t1
JOIN student AS t2
ON t1.sid=t2.sid;

-- 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )

-- MySQL中正常运行
SELECT 
    t1.sid,
    t1.sname,
    COUNT(score) AS cnt_sc,
    sum(score) AS sum_sc
FROM 
    sc AS t2,
    student AS t1
WHERE t1.sid = t2.sid
GROUP BY t1.sid;

--Hive中正常运行
SELECT
    t1.sid,
    t1.sname,
    t2.cnt_sc,
    t2.sum_sc
FROM
    student AS t1
LEFT JOIN(
    SELECT 
        sid,    
        COUNT(score) AS cnt_sc,
        sum(score) AS sum_sc
    FROM sc
    GROUP BY sid) AS t2
ON t1.sid=t2.sid;

-- 4.1 查有成绩的学生信息

SELECT t1.* 
FROM student AS t1 
JOIN (SELECT sid FROM sc GROUP BY sid)AS t2 
ON t1.sid=t2.sid ;

-- 5. 查询「李」姓老师的数量

SELECT COUNT(1) FROM teacher WHERE tname like "李%";

-- 6. 查询学过「张三」老师授课的同学的信息

SELECT t3.* FROM (  --找这些同学的信息
    SELECT t2.sid  -- 找修过张三老师的课的同学学号
    FROM (SELECT cid -- 找张三老师的讲授课程编号
        FROM course AS t2 
        JOIN(SELECT tid -- 找张三老师的教师编号
            FROM teacher 
            WHERE tname="张三")AS t1  
            ON t1.tid=t2.tid) AS t1 
    JOIN sc AS t2 
    ON t1.cid=t2.cid
)AS t4 
JOIN student AS t3 
ON t3.sid=t4.sid;




-- 7. 查询没有学全所有课程的同学的信息

-- MySQL和Hive都正常跑:
SELECT -- 查询这些同学的信息
    t1.*,
    t2.cnt_course
FROM student AS t1 
LEFT JOIN (SELECT -- 查询有成绩的学生学的科目
                sid,
                COUNT(1) AS cnt_course 
            FROM sc 
            GROUP BY sid) AS t2  
ON t1.sid=t2.sid
JOIN (SELECT COUNT(1) cnt_c FROM course) t3
ON 1=1
WHERE t2.cnt_course<t3.cnt_c -- 查询所有科目数
OR t2.cnt_course IS NULL; -- 查询没修过课的同学

-- Hive中正常跑1:
SELECT 
    t3.*
FROM student AS t3
LEFT JOIN(SELECT 
            sid,
            COUNT(1) AS cnt_c
          FROM sc 
          GROUP BY sid) AS t2
ON t3.sid=t2.sid
JOIN (SELECT COUNT(1) AS n1 FROM course) t1
ON t1.n1=t2.cnt_c
WHERE t2.sid is null;

-- 8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息

select cid from sc where sid ="01";
select 
    t3.*,
    t4.cnt 
from student AS t3 
join(
    select sid,
    count(1) as cnt 
    from sc as t1 
    join (select cid 
          from sc 
          where sid ="01") as t2 
    on t1.cid = t2.cid 
    group by sid 
    having cnt>0) as t4 
on t3.sid=t4.sid;

-- 在mysql中可以，但是在Hive中不能运行
select t2.* 
from 
    sc as t1,
    student as t2 
where cid in (select cid from sc where sid ="01") 
and  t1.sid =t2.sid 
group by t1.sid;

-- 9. 查询和"01"号的同学学习的课程 完全相同的其他同学的信息

select
    t1.*
from student AS t1
join(SELECT  -- 查询每个同学 与01同学修的课程相同 的门数
        t2.sid,
        COUNT(1) AS cnt 
    FROM sc AS t2
    LEFT JOIN (SELECT sid,cid FROM sc WHERE sid="01") AS t3 -- 查询01同学修的课程是哪些
    ON t2.cid=t3.cid
    GROUP BY t2.sid
    )AS t4
on t1.sid=t4.sid and t1.sid<>01
join (SELECT COUNT(1) as cnt01 FROM sc WHERE sid ="01") as t5 -- 如果和我修的课程相同的门数等于我所修的课程数，那么他就与我修的课程完全相同
on t5.cnt01=t4.cnt;

-- 10. 查询没学过"张三"老师讲授的任一门课程的学生姓名

-- 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
-- 
-- 12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
-- 
-- 13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
-- 
-- 14. 查询各科成绩最高分、最低分和平均分：
-- 
-- 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
-- 
-- 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
-- 
-- 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
-- 
-- 15. 按各科成绩进行排序，并显示排名， score 重复时保留名次空缺
-- 
-- 15.1 按各科成绩进行排序，并显示排名， score 重复时合并名次
-- 
-- 16. 查询学生的总成绩，并进行排名，总分重复时保留名次空缺
-- 
-- 16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
-- 
-- 17. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
-- 
-- 18. 查询各科成绩前三名的记录
-- 
-- 19. 查询每门课程被选修的学生数
-- 
-- 20. 查询出只选修两门课程的学生学号和姓名
-- 
-- 21. 查询男生、女生人数
-- 
-- 22. 查询名字中含有「风」字的学生信息
-- 
-- 23. 查询同名同性学生名单，并统计同名人数
-- 
-- 24. 查询 1990 年出生的学生名单
-- 
-- 25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
-- 
-- 26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
-- 
-- 27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
-- 
-- 28. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
-- 
-- 29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
-- 
-- 30. 查询不及格的课程
-- 
-- 31. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
-- 
-- 32. 求每门课程的学生人数
-- 
-- 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
-- 
-- 34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
-- 
-- 35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
-- 
-- 36. 查询每门功成绩最好的前两名
-- 
-- 37. 统计每门课程的学生选修人数（超过 5 人的课程才统计）。
-- 
-- 38. 检索至少选修两门课程的学生学号
-- 
-- 39. 查询选修了全部课程的学生信息
-- 
-- 40. 查询各学生的年龄，只按年份来算
-- 
-- 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
-- 
-- 42. 查询本周过生日的学生
-- 
-- 43. 查询下周过生日的学生
-- 
-- 44. 查询本月过生日的学生
-- 
-- 45. 查询下月过生日的学生