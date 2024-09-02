/*������������� � �������� ������*/

SELECT TOP 10 *
FROM [dbo].[orders_log]

SELECT TOP 10 *
FROM uids

SELECT source_id,count(*) as cnt,min(dt),max(dt),sum([costs])
FROM [dbo].[costs]
GROUP BY source_id
ORDER BY source_id

SELECT * ---2018-06-01 ��� � �������
FROM [dbo].[costs]
WHERE [dt]='2018-03-30'


SELECT CAST(byu_ts as date),sum(revenue)
FROM [dbo].[orders_log]
GROUP BY CAST(byu_ts as date)
ORDER BY sum(revenue) 

SELECT min(byu_ts),max(byu_ts),sum(revenue),min(revenue),max(revenue),
avg(revenue),count(distinct uid_id),count(*)
FROM orders_log

---��������, ��� ����������
SELECT * 
FROM orders_log
WHERE revenue=0
/*
����� ����������, 
����������, ��������� �������� ������ � 
��������� ������� ��� ��� ������ �� ����
*/
SELECT TOP 10 *, [byu_ts],CAST(byu_ts as date), 
CAST(byu_ts as time),
DATEPART(mm,byu_ts)
FROM [dbo].[orders_log]

SELECT min(start_ts),max(start_ts),min(end_ts),max(end_ts),
count(distinct device),count(distinct source_id),count(distinct uid_id),
count(*)
FROM [dbo].[visits_log]

/*����������� DAU
��������� ������� �������� �� ���� ������.*/

SELECT CAST([start_ts] as date) as dd,count(distinct uid_id) as cnt_u
INTO #dau
FROM [dbo].[visits_log]
GROUP BY CAST([start_ts] as date)

SELECT avg(cnt_u)
FROM #dau
--ORDER BY dd
drop table #dau
/*M! ����������, ������� ��� �� ���� ������������ � ������� ������� �� ����. 
� �� �������*/

SELECT TOP 1 avg(CAST(count(vis_id) as float)) OVER () AS rr
FROM [dbo].[visits_log]
GROUP BY uid_id,cast(start_ts as date)

SELECT uid_id,cast(start_ts as date) as dd,count(*) as cnt
INTO #ses
FROM [dbo].[visits_log]
GROUP BY uid_id,cast(start_ts as date)

SELECT dd,avg(CAST(cnt as float))
FROM #ses
GROUP BY dd
ORDER BY avg(CAST(cnt as float))


/*������� ������ ������ ���� ������?*/

SELECT avg(DATEDIFF(ss,[start_ts],[end_ts]))
FROM [dbo].[visits_log]
WHERE DATEDIFF(ss,[start_ts],[end_ts])>=0

SELECT *
FROM 
(SELECT DATEDIFF(ss,[start_ts],[end_ts]) as dd_diff,count(*) as cc
FROM [dbo].[visits_log]
WHERE DATEDIFF(ss,[start_ts],[end_ts])>=0
GROUP BY DATEDIFF(ss,[start_ts],[end_ts])) x
ORDER BY x.cc DESC





/*�������� ��������� ������, ����������� Retention Rate. 
�������� ��������� ������� �� �������. 
������� ������� Retention Rate �� ������ ����� ������ ������.*/
--������ �����
select uid_id,min(start_ts) as first_date
INTO #first_date
FROM [dbo].[visits_log]
group by uid_id

select datepart(month,f.first_date) as cohort,DATEDIFF(month,f.first_date,v.start_ts) as delta_day, 
count(distinct v.uid_id) as cnt,x.c_uid,count(distinct v.uid_id)/cast(x.c_uid as float)*100 as rr
INTO #ret
FROM [dbo].[visits_log] v inner join #first_date f on v.uid_id=f.uid_id 
inner join (select datepart(month,first_date) as m_d, count(distinct uid_id)  as c_uid
from #first_date group by datepart(month,first_date)) x on x.m_d=datepart(month,f.first_date)
group by datepart(month,f.first_date),DATEDIFF(month,f.first_date,v.start_ts),x.c_uid
order by datepart(month,f.first_date),DATEDIFF(month,f.first_date,v.start_ts)

SELECT *
FROM #ret
ORDER BY cohort,delta_day


SELECT avg(rr) 
FROM #ret
WHERE delta_day=1



/*������� ������� � ������� �������� � ������� ������� ��������� ����� 
�� ���������� �������*/

/*C������ ���������� ������� �� ������ �������. ���������*/


/*������� ��� 
� �� �������*/


































/*��������, ��� �������� LTV �� ���������� �� ��������. 
�������, ��� LTV � ������������� �������. 
����������� ������� LTV �� �������� �� 6 �������; � ������ ��������� �������, ���������� �� ����� 6 �������. 
�������������� ������� � 100%. �������� ��������� ������� �� ������� �� �������*/

/*����� ������� �� ���������
� �� �������*/

/*������� �� ������� ���������
� �� �������*/


/*����������� ������� CAC �� ������ ���������� ��� ����� ������� 
� ��� ������� ��������� �������. 
�������� ��������� ������*/

/*����������� ROMI �� �������� � ������� ����������. 
�������� ����������� �� ���������� ������� ����� ������. 
�������� ��������, ��� �������, ��������� �� ������ ����������, ����� ����� ������ LTV. 
��������� ������ �� �������.*/


