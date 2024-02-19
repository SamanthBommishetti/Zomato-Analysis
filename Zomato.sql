use  samanth;
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1, '2017-09-22'),
    (3, '2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES 
    (1, '2014-09-02'),
    (2, '2015-01-15'),
    (3, '2014-04-11');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales (userid, created_date, product_id) VALUES 
    (1, '2017-04-19', 2),
    (3, '2019-12-18', 1),
    (2, '2020-07-20', 3),
    (1, '2019-10-23', 2),
    (1, '2018-03-19', 3),
    (3, '2016-12-20', 2),
    (1, '2016-11-09', 1),
    (1, '2016-05-20', 3),
    (2, '2017-09-24', 1),
    (1, '2017-03-11', 2),
    (1, '2016-03-11', 1),
    (3, '2016-11-10', 1),
    (3, '2017-12-07', 2),
    (3, '2016-12-15', 2),
    (2, '2017-11-08', 2),
    (2, '2018-09-10', 3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-- What is total amount each coustmer spent on Zomato

select a.userid,a.product_id,b.price from sales a inner join product b on a.product_id=b.product_id;
select a.userid,sum(b.price) total_amount_spent from sales a inner join product b on a.product_id=b.product_id 
group by a.userid;

-- How many days that coustmer visited zomato

select userid ,count(distinct created_date) distinct_days from sales group by userid;

--  What was the first product purchased by each coustmer
 
 select * from(select *, rank() over (partition by  userid order by  created_date) rnk from sales) a where rnk=1;

-- What is the most purchased item and how many times it is purchased by all coustmers

select product_id,count(product_id) from sales group by product_id order by count(product_id) desc;

select userid, count(product_id) as cnt
from sales 
where product_id = (
    select product_id 
    from sales 
    group by product_id 
    order by COUNT(product_id) desc 
    limit 1
) 
group by userid;

-- wwhich item was most popular for each  coustmer

select * from(select *, rank() over (partition by userid order by cnt desc) rnk from
(select userid,product_id,count(product_id) cnt from sales group by userid,product_id)a)b where rnk=1;

-- which item was purchase by the customer first after became a gold number

select * from(select c.* ,rank() over (partition by userid order by created_date) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on  a.userid=b.userid and created_date >= gold_signup_date)c)b where rnk=1; 

-- which item was purchased just before became a gold member

select * from(select c.* ,rank() over (partition by userid order by created_date desc) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on  a.userid=b.userid and created_date <= gold_signup_date)c)b where rnk=1; 

-- what is the total orders and amount spent for each member before they became gold member

select  userid,count(created_date) order_purchased, sum(price) total_amt_spent from (select c.*,d.price from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on  a.userid=b.userid and created_date <= gold_signup_date)c inner join 
product d on c.product_id=d.product_id) e group by userid;

-- if buying creates a point for ex 5Rs 2 zomato points and each product has different purchase points for
-- eg for p1 5Rs =1 zomato point , for p2 10Rs = 5zomato pointss and for p3 5rs=1 zomato point 2rs=zomato point
-- calculate the points collected by each coustemr and for which product most points are given now

select userid, sum(total_points) tota_points_earned from 
(select e.*,amt/points as total_points from
(select d.*,case when product_id =1 then 5 when product_id =2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e) f group by userid;

-- total money earned by each  userid on product id
select userid, sum(total_points)* 2.5 tota_money_earned from 
(select e.*,amt/points as total_points from
(select d.*,case when product_id =1 then 5 when product_id =2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e) f group by userid;


-- which product earned most points

select e.*,amt/points as total_points from
(select d.*,case when product_id =1 then 5 when product_id =2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e;
 

select product_id, sum(total_points)  tota_points_earned from 
(select e.*,amt/points as total_points from
(select d.*,case when product_id =1 then 5 when product_id =2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e) f group by product_id;

-- by rank 

select * from (select *,rank() over (order by total_points_earned desc) as rnk from
(select product_id, sum(total_points) as  total_points_earned from 
(select e.*,amt/points as total_points from
(select d.*,case when product_id =1 then 5 when product_id =2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price) as amt from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)d)e) f group by product_id)f_alias)derived_table where  rnk=1 ;

-- in the first one year after a coustmer joins the gold program including their joining date irrespective of what 
-- the coustmer has purchased they earn  5 zomato points for every 10rs spent who earned more on more 1 or 3
--  and what as their points earning in their first year

select c.*,d.price*0.5 total_points_earned from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join
goldusers_signup b on  a.userid=b.userid and created_date >= gold_signup_date and created_date 
<=date_add(gold_signup_date, interval 1 year))c inner join product d on c.product_id=d.product_id;

-- rank all the transactions of the coustmers

select *,rank() over(partition by userid order by created_date) rnk from sales;

-- rank all the transactions of each member when they are gold member for every non gold transaction mark as na

select e.*,case when rnkk=0 then 'na' else  rnkk end as rnkk from 
(select c.*,cast((case when gold_signup_date is null then 0 else @rank := if(@prev_user = userid, @rank + 1, 1) end) as char) as rnkk, @prev_user := userid from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid order by a.userid,a.created_date desc)c, (select @rank := 0, @prev_user := '') vars)e;




