create database [day]


----------------------------------DAY 1  -----------------------------------
create table product
(p_id int,
p_name varchar(20),
p_family varchar(20),
price int,
cost int,
launch_date date);

insert 
into product values(100,'Marker','stationary',75,60,'15-jan-18')
,(101,'Mouse','computer',1000,750,'16-apr-17')
,(102,'Whiteboard','stationary',450,375,'20-aug-10')
,(103,'desktop','computer',20000,25000,'21-sep-10')
,insert into product values (10,'Laptop','computer',40000,45000,'21-dec-10')

delete from product where p_id=10


-- 1.Write the select statement which gives all the products which costs more than Rs 250.

select * from product 
where cost>250

--2.Write the select statement which gives product name, cost, price and profit.
--(profit formula is price – cost)

select p_name,cost,price, (price-cost) as Profit from product

--3.Find the products which give more profit than product Mouse

select * from product 
where (price-cost)>
(select (price-cost)as profit from product where p_name='mouse')

-- 4.Display the products which give the profit greater than 100 Rs.

select *,(price-cost) as profit from product
where (price-cost) > 100


select * from(select *,(price-cost) as profit from product) a
where profit>100

--  5.Display the products which are not from Stationary and Computer family.

select * from product where p_family not in('computer','stationary')

-- 6.Display the products which give more profit than the p_id 102.

----Derived Table------------
select * from (select *,(price-cost) as profit from product) a
where profit>(select  (price-cost) profit from product where p_id=102)

-----------------sub queries----------------------

select *,(price-cost) as profit from product
where (price-cost)>(select (price-cost) from product where p_id=102)

--7. Display products which are launched in the year of 2010.

select * from product
where year(launch_date) = '2010'

--8.Display the products which name starts with either ‘S’ or ‘W’ and 
--which belongs to Stationary and cost more than 300 Rs

select * from product
where p_name like '[sw]%' and p_family='stationary' and cost>300

--9.	Display the products which are launching next month.

select * from product
where month(launch_date) = month(launch_date)+1 and year(launch_date) =  year(GETDATE())

-- 10.Display product name which has the maximum price in the entire product table.

-------------==Sub Query=========================

select * from product where price =(select max(price) from product);

-------------==top=========================

select top 1 * from product
order by price desc

-------------==CTE=========================
with cte 
as
(select max(price) as a from product)
select * from cte c join product p on c.a=p.price

--========rank=========================

select * from (select *,DENSE_RANK() over(order by price desc) as Dns_Rnk from product)a
where Dns_Rnk <=1

--========OFFSET=========================
 select * from product
 order by price desc
 offset 0 rows
 fetch next 1 rows only

--11.	List the product name, cost, price, profit and percentage of profit we get in each product.

select p_name,cost,price,(price-cost) as profit ,cast((price-cost) as decimal)/cast(price as decimal) as '% of profit' from product

select p_name,cost,price,(price-cost) as profit ,
cast(round((price-cost)*100/(price),2)as decimal(10,2)) as '% of profit' from product


--12.Display how many products we have in Computer family which has the price range between 2000 and 50000.

select p_family,count(p_family) cnt from product
where p_family='computer' and price between 2000 and 50000
group by p_family 

---^^^^^^^^^^^^^^^^^^^^^^^^^  Day 2  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--
create table city
(city_id int primary key,
city_name varchar(20),
city_population varchar(20));




insert
into city values(10,'bangalore',2367890)
,(20,'chennai',6474854)
,(30,'mumbai',783983736)


create table branch
(b_id int primary key,
b_name varchar(20),
b_address varchar(20),
b_phone int,
city_id int references city(city_id));

insert 
into branch values(500,'btm layout','185, ring road',97865432,10)
,(501,'jayanagar','44,15th main',97654201,10)
,(502,'ashoknagar','ashoka pillar',88960447,20)
,(503,'mount road','nandanam',99765987,20)
,(504,'jp nagar','South end circle',88007766,20)



--1.	Write a query to list the cities which have more population than Bangalore.

---------------SUB QUERY------------------
select * from city
where city_population>(select city_population from city where city_name = 'bangalore')

---------------CTE------------------------
with cte 
as
(select city_id,city_population from city where city_name='bangalore' )
select ci.city_id,ci.city_name,ci.city_population from cte c  join city ci on ci.city_population > c.city_population


--2.	Display all the branch names from Chennai.

select b_id,b_name from city c join branch b on c.city_id=b.city_id
where city_name='chennai'


--3.	Display a city name which does not have any branches

select * from city c left join branch b on c.city_id=b.city_id
where b.city_id is null

--4.	Display branch name, address and phone number of all the branches where 
--the name starts with either B or M and the city name starts with either B or C.

select b_name,b_address,b_phone from city c join branch b on c.city_id=b.city_id
where b_name like '[bm]%' and city_name like '[bc]%'

--5.	How many branches we have in Bangalore?
select * from city
select * from branch

select city_name, count(b.city_id) from city c join branch b on c.city_id=b.city_id
where


select  city_name,b.city_id,count(b.city_id)as cnt from branch b join city c on b.city_id=c.city_id
where city_name='bangalore'
group by city_name,b.city_id

--6.Display the branches which are in the Ring road of any city.

select * from city c join branch b on c.city_id=b.city_id
where b_address like '%ring road%'

--7.	Display the city name, branch name. Order the data based on the city name.


select city_name,b_name
from city c left join branch b on c.city_id=b.city_id
order by city_name

-- 8.	Display the city name and the number of branches in each city.

select city_name, COUNT(b.city_id) as no_of_branch
from city c left join branch b on b.city_id=c.city_id
group by city_name


-- 9.	Display the city name which has most number of branches.

select top 1 city_name, COUNT(b_id)as no_of_branch from
city c left join branch b on c.city_id=b.city_id
group by city_name
order by  COUNT(b_id) desc
 --====================================================
 select * from (select  city_name, COUNT(b_id)as no_of_branch,  DENSE_RANK() over(order by COUNT(b_id) desc) as DR from
city c left join branch b on c.city_id=b.city_id
group by city_name)a
where DR =1
 --====================================================


-- 10.	Display the city name, population, number of branches in each city.
select * from city
select * from branch

select city_name,city_population, count(b_address) as cnt from
city c left join branch b on c.city_id=b.city_id
group by city_name,city_population


---==================^^^^^^^^^^^^^^^^^^^^^^^^^  Day 3  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^========================


create table doctor
(doc_id varchar(4) primary key,
fname varchar(20),
lname varchar(20),
specialty varchar(20),
phone int
);

create table patient
(pat_id varchar(4) primary key,
fname varchar(20),
lname varchar(20),
ins_comp varchar(20),
phone int
);


create table [case]
(admission_date date,
pat_id varchar(4) references patient(pat_id),
doc_id varchar(4) references doctor(doc_id),
diagnosis varchar(40),
constraint con_cpk primary key(admission_date,pat_id)
);

insert 
into doctor values('d1','arun','patel','ortho',96750453)
,('d2','tim','patil','general',96745653)
,('d3','abhay','sharma','heart',96759453)




insert 
into patient values('p1','akul','shankar','y',9152347)
,('p2','aman','shetty','y',9896317)
,('p3','ajay','shetty','n',99873564)
,('p4','akshay','pandit','y',91125889)
,('p5','adi','shankar','n',9177721)


insert 
into [case] values('10-jun-16','p1','d1','fracture')
,('03-may-16','p2','d1','bone cancer')
,('17-apr-16','p2','d2','fever')
,('28-oct-15','p3','d2','cough')
,('10-jun-16','p3','d1','fracture')
,('1-jan-16','p3','d1','bone cramp')
,('11-sep-15','p3','d3','heart attack')
,('30-nov-15','p4','d3','heart hole')
,('10-nov-15','p4','d3','angioplasty')
,('1-jan-16','p5','d3','angiogram')



-- 1.	Find all the patients who are treated in the first week of this month.
select * from  doctor 
select * from  patient
select * from  [case]

select * from patient p join [case] c on p.pat_id=c.pat_id

--2.	Find all the doctors who have more than 3 admissions today

select fname,COUNT(c.doc_id)as cnt from doctor d join [case] c on d.doc_id=c.doc_id
where admission_date = getdate()
group by fname
having COUNT(c.doc_id)>3

--3.	Find the patient name (first,last) who got admitted today where the doctor is ‘TIM’

select d.fname,p.fname+ ' ' + p.lname as Full_Name from doctor d join [case] c on d.doc_id=c.doc_id join patient p on p.pat_id=c.pat_id
where d.fname ='Tim' and admission_date = getdate()

--4.	Find the Doctors whose phone numbers were not update (phone number is null)

select * from doctor
where phone is null

--5.	Display the doctors whose specialty is same as Doctor ‘TIM’

select * from doctor where specialty = (select specialty from doctor where fname= 'tim') and fname <> 'tim'

--6.	Find out the number of cases monthly wise for the current year

select month(admission_date),count(pat_id) from [case]
where year(admission_date) = 2016
group by month(admission_date)

select datename(month,admission_date),count(pat_id) from [case]
where year(admission_date) = 2016
group by datename(month,admission_date)

--7.	Display the doctors who don’t have any cases registered this week


select * from doctor d join [case] c on d.doc_id=c.doc_id
where datepart(week,admission_date) = datepart(week,getdate())

select datepart(week,getdate())

--8.	Display Doctor Name, Patient Name, Diagnosis for all the admissions which happened on 1st of Jan this year

select d.fname,p.fname,diagnosis from doctor d left join [case] c on d.doc_id=c.doc_id left join patient p on p.pat_id=c.pat_id
where admission_date = DATEFROMPARTS( year(getdate()),01,01)

select DATEFROMPARTS( year(getdate()),01,01)

--9.	Display Doctor Name, patient count based on the cases registered in the hospital.
 
select  Upper(left(d.fname,1))+ SUBSTRING(d.fname,2,LEN(d.fname)) as Doc_name,diagnosis,count(diagnosis) as cnt from doctor d
left join [case] c on d.doc_id=c.doc_id left join patient p on p.pat_id=c.pat_id
group by d.fname,diagnosis

--10.	Display the Patient_name, phone, insurance company, insurance code (first 3 characters of insurance company)

select fname,phone,ins_comp,LEFT(phone,3) as ins_Code from patient

--11.	Create a view which gives the doctors whose specialty is ‘ORTHO’ and call it as ortho_doctors
select * from  doctor 
select * from  patient
select * from  [case]

create view ortho_doctors
as
select Upper(left(fname,1))+ SUBSTRING(fname,2,len(fname))+ ' ' + lname as Ortho_Doctors from doctor
where specialty = 'ortho'

select * from ortho_doctors
---==================^^^^^^^^^^^^^^^^^^^^^^^^^  Day 4  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^========================


create table country
(country_id int primary key,
country_name varchar(20));

create table resort
(resort_id int primary key,
resort_name varchar(20),
country_id int references country(country_id));

create table customer
(cust_id int primary key,
cust_name varchar(20),
phone int,
country_id int references country(country_id));

insert 
into country values(1,'US')
,(2,'UK')
,(3,'INDIA'),
(4,'nepal')

insert 
into resort values 
(10,'Blue valley',1)
,(20,'Beach front',1)
,(30,'Taj Oberai',2)
,(40,'Taj Maldives',4)
,(50,'Golden Flowers',2)
,(60,'Taj valley',1)
,(70,'hotel goa',1)


insert 
into customer values (1001,'tim downey',34231458,1)
,(1002,'ramesh k',8932748,2)
,(1003,'bill price',7832753,1)
,(1004,'malinga',9854231,3),
(1005,'farooq',45893121,4)
,(1006,'pradeep',732753,1)


select * from country
select * from resort
select * from customer


--1.	Query to find out number of resorts based on country.

select country_name,count(resort_id) from
country c left join resort r on c.country_id=r.country_id
group by  country_name

--2.	Query to display country wise customer count.

select country_name,count(cust_id) from
country co join customer cu on  co.country_id=cu.country_id
group by country_name


--3.	Query to display country, resort count and customer count.
--- if we use multiple count or joins it will multiplies the count of value so we have to use distinct

select * from country
select * from resort
select * from customer

select country_name,count(distinct cust_id) custmer_cnt,count(distinct resort_name) resort_cnt from country co left join resort r on co.country_id=r.country_id
left join customer cu on co.country_id=cu.country_id
group by country_name

select country_name,count( cust_id),count( resort_name) from country co left join resort r on co.country_id=r.country_id
left join customer cu on co.country_id=cu.country_id
group by country_name
-----===========================  CTE  ==================================

with cte1 as
( select country_name,count(cust_id) as [count of cust] from country co left join customer cu on co.country_id=cu.country_id
group by country_name), cte2 as 
(select country_name,count(resort_name) [count of resort] from country co left join resort r on co.country_id=r.country_id
group by country_name)
select a.country_name,[count of cust],[count of resort] from cte1 a join cte2 b on a.country_name=b.country_name

--4.	Display Resort country name, resort name, customer name and customer country name.

select country_name as Resort_country_name,resort_name,cust_name,country_name as customer_country_name from
country co join resort r on co.country_id=r.country_id join customer cu on cu.country_id=r.country_id


--5.	Display countries in which we don’t have any resorts.

select * from country c left join resort r on c.country_id=r.country_id
where resort_id is null

--6.	Display countries in which we have minimum of 100 customers.

select country_name,count(cust_id) from customer cu left join country co on cu.country_id=co.country_id
group by country_name
having count(cust_id)>1

--7.	Display how many resorts we have in the country where resort ‘Beach front’ is?

select country_name,count(resort_name) as cnt from country c left join resort r on c.country_id=r.country_id
where  resort_name like 'beach front%'
group by country_name

--8.	Display customers whose name starts with F or R and who are either from India or Srilanka.

select * from country co join customer cu on co.country_id=cu.country_id
where cust_name like '[fr]%' and country_name in ('uk','srilanka')

--9.	Display customer names who are from US and do not have any phone numbers.


select * from country co left join customer cu on co.country_id=cu.country_id
where country_name = 'us' and phone is not null
--10.	Display Country name, resort name. Display all the countries whether we have resorts or not.

select country_name, resort_name from country co left join  resort  r on co.country_id=r.country_id


--11.	Display countries which have more resorts than the no of resorts in country India.
select * from country
select * from resort
select * from customer

select country_name from country c
where count(resort_id) > (select count(resort_id) from resort r where  c.country_id=r.country_id)
where country_name = 'india'  )


with cte1 as
(select c.country_id,c.country_name,count(resort_id)as cnt1 from country c left join resort r  on c.country_id=r.country_id
where country_name = 'india'
group by c.country_id,c.country_name), 
cte2 as
(select c.country_id,c.country_name,count(resort_id)as cnt2 from country c left join resort r  on c.country_id=r.country_id
group by c.country_id,c.country_name)
select b.* from cte1 a left join cte2 b on cnt2>cnt1

--12.	Display all the countries and resorts, if the country doesn’t have resort display as ‘no resort’.
select c.country_id,country_name,ISNULL(resort_name,'NO RESORT') from 
country c left join resort r on c.country_id=r.country_id


--13.	Display the countries as level-1,level-2 and level3 if the no of resorts in the 
--country are more than 50 then level 1, if >30 then level 2 otherwise level 3.


select country_name,count(resort_name) as cnt_resorts, 
case
when count(resort_name)>=4 then 'Level 3'
when count(resort_name)>=2 and count(resort_name)<=3   then 'Level 2'
else 'Level 1'     
end as Levels
from country co left join resort r on co.country_id=r.country_id
group by country_name

---==================^^^^^^^^^^^^^^^^^^^^^^^^^  Day 5  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^========================

create table author
(au_id int primary key,
au_f_name varchar(20),
au_l_name varchar(20),
au_dob date,
au_address varchar(20)
);


insert into author values(1,'raj','deshpande','22-jan-15','jpnagar,bang'),
(2,'arun','patil','03-mar-15','rrnagar,bang'),
(3,'ritesh','deshmukh','28-sep-15','kalyannagar,bang'),
(4,'arjun','janya','19-oct-15','jaynagar,bang'),
(5,'kiran','sharma','17-nov-15','tnagar,bang')


create table publisher
(pub_id int primary key,
pub_nm varchar(20), 
pub_address varchar(20),
pub_city varchar(20),
pub_state varchar(20)
);

insert 
into publisher values(1101,'abc publications','ring road','bangalore','karnataka'),
(1102,'pqr publications','south end','bangalore','karnataka'),
(1103,'xyz publications','kr circle','bangalore','karnataka'),
(1104,'rrr publications','rr road','bangalore','karnataka'),
(1105,'lmn publications','dk circle','bangalore','karnataka'),
(1106,'zzz publications','krpuram','bangalore','karnataka')


create table book
(book_id int primary key,
book_nm varchar(20),
pub_id int references publisher(pub_id));


insert 
into book values(11,'cartoon books',1101),
(12,'story books',1101),
(13,'adventures books',1102),
(14,'novel books',1101),
(15,'thriller books',1103),
(16,'horror books',1102)



create table book_author
(bk_au_id int primary key,
book_id int references book(book_id),
au_id int references author(au_id)
);

insert 
into book_author values(111,14,1),(222,12,1),(333,11,2),(444,11,3),(555,11,2),(666,14,2)



--1.	Identify the relationships between each table.
select * from publisher
select * from book
select * from book_author
select * from author

--2.	Query to get the number of books by each publisher.

select * from (select pub_nm,count(book_nm)as cnt from publisher p left join book b on p.pub_id=b.pub_id
group by pub_nm)a
order by cnt desc

--3.	Write a query which gives book_name, author_name for publisher ‘XYZ’

select book_nm,au_f_name from publisher p left join book b on p.pub_id=b.pub_id left join book_author ba on b.book_id=ba.book_id left join
author a on a.au_id=ba.au_id
where pub_nm = 'xyz publications'

--4.	Which book was written by more than 3 authors?
select * from book
select * from book_author
select * from author

select book_nm,count(distinct a.au_id) from book b left join book_author ba on b.book_id=ba.book_id left join
author a on a.au_id=ba.au_id
group by book_nm
having count(a.au_id)>=2

--5.	Want to include city and state information of author as well in the model.
--So, modifiy the model and show us the new model what you come up with.



--6.	Display publisher name, pub_city and metro flag of the city. 
--If city is CHN or MUM or DEL or CAL then display the flag as ‘Y’ otherwise ‘N’

select pub_id,pub_nm,pub_city,pub_state,  case
when pub_city not in ('bangalore') then 'Y' else 'N' end as Flag
from publisher


update publisher set pub_city = 'Penukonda' where pub_id = 1105

--7.	Display the authors whose age is greater than the author ‘rithesh’

select *,datediff(day,au_dob,getdate()) as days from author where datediff(day,au_dob,getdate())>  (select datediff(day,au_dob,getdate()) from author
where au_f_name = 'ritesh')

--8.	Display the publisher name, author_name and no of books they wrote.
select pub_nm,au_f_name,count(ba.au_id) from publisher p left join book b on p.pub_id=b.pub_id left join book_author ba on b.book_id=ba.book_id left join
author a on a.au_id=ba.au_id
group by pub_nm,au_f_name

--9.	Which author wrote the maximum number of books?


select top 1 * from(select au_f_name,count(ba.au_id)cnt from publisher p left join book b on p.pub_id=b.pub_id left join
book_author ba on b.book_id=ba.book_id left join author a on a.au_id=ba.au_id
group by au_f_name)a
order by cnt desc

--10.	Create a stored procedure which returns book_name, author_full_name by taking publisher name as the input.

create or alter proc sp_pub_nm
@name varchar(20)
as
begin
select pub_nm,Upper(au_f_name)+ ' '+Upper(au_l_name) as Full_name  from publisher p left join book b on p.pub_id=b.pub_id left join
book_author ba on b.book_id=ba.book_id left join author a on a.au_id=ba.au_id
where pub_nm  like '%' + @name + '%'
end


exec sp_pub_nm 'xyz'

--11.	Take the publisher name as input and give the number of books which that publisher published 
--where there are only one author.

select * from publisher
select * from book
select * from book_author
select * from author

select pub_nm ,count(distinct book_nm) book_cnt,count(distinct a.au_id) from publisher p left join book b on p.pub_id=b.pub_id left join
book_author ba on b.book_id=ba.book_id full join author a on a.au_id=ba.au_id
group by pub_nm