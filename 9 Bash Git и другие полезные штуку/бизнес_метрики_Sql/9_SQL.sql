/*предобработка и изучение данных*/

SELECT TOP 10 *
FROM [dbo].[orders_log]

SELECT TOP 10 *
FROM uids

SELECT source_id,count(*) as cnt,min(dt),max(dt),sum([costs])
FROM [dbo].[costs]
GROUP BY source_id
ORDER BY source_id

SELECT * ---2018-06-01 нет в таблице
FROM [dbo].[costs]
WHERE [dt]='2018-03-30'


SELECT CAST(byu_ts as date),sum(revenue)
FROM [dbo].[orders_log]
GROUP BY CAST(byu_ts as date)
ORDER BY sum(revenue) 

SELECT min(byu_ts),max(byu_ts),sum(revenue),min(revenue),max(revenue),
avg(revenue),count(distinct uid_id),count(*)
FROM orders_log

---спросить, что происходит
SELECT * 
FROM orders_log
WHERE revenue=0
/*
можно посмотреть, 
пожалуйста, выделение например месяца в 
отдельный столбец или дня недели из даты
*/
SELECT TOP 10 *, [byu_ts],CAST(byu_ts as date), 
CAST(byu_ts as time),
DATEPART(mm,byu_ts)
FROM [dbo].[orders_log]

SELECT min(start_ts),max(start_ts),min(end_ts),max(end_ts),
count(distinct device),count(distinct source_id),count(distinct uid_id),
count(*)
FROM [dbo].[visits_log]

/*Рассчитайте DAU
Вычислите средние значения за весь период.*/

SELECT CAST([start_ts] as date) as dd,count(distinct uid_id) as cnt_u
INTO #dau
FROM [dbo].[visits_log]
GROUP BY CAST([start_ts] as date)

SELECT avg(cnt_u)
FROM #dau
--ORDER BY dd
drop table #dau
/*M! Определите, сколько раз за день пользователи в среднем заходят на сайт. 
и во времени*/

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


/*Сколько обычно длится одна сессия?*/

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





/*Применяя когортный анализ, рассчитайте Retention Rate. 
Покажите изменения метрики во времени. 
Найдите средний Retention Rate на второй месяц «жизни» когорт.*/
--первый визит
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



/*Сколько времени в среднем проходит с момента первого посещения сайта 
до совершения покупки*/

/*Cреднее количество покупок на одного клиента. когортами*/


/*Средний чек 
и во времени*/


































/*Выясните, как меняется LTV на покупателя по когортам. 
Помните, что LTV — накопительная метрика. 
Рассчитайте средний LTV по когортам за 6 месяцев; в расчёт включайте когорты, «прожившие» не менее 6 месяцев. 
Маржинальность сервиса — 100%. Отразите изменения метрики во времени на графике*/

/*Общие расходы на маркетинг
и во времени*/

/*Расходы по каждому источнику
и во времени*/


/*Рассчитайте средний CAC на одного покупателя для всего проекта 
и для каждого источника трафика. 
Отразите изменения метрик*/

/*Рассчитайте ROMI по когортам в разрезе источников. 
Сравните окупаемость за одинаковые периоды жизни когорт. 
Обратите внимание, что клиенты, пришедшие из разных источников, могут иметь разный LTV. 
изменения метрик во времени.*/


