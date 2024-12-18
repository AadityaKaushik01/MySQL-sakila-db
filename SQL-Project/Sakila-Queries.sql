/* 1. All "films" with PG-13 films with "rental rate" of 2.99 or lower.*/
	
select 
    f.rating, 
    f.rental_rate
from film f
where f.rating = 'PG-13' AND f.rental_rate <= 2.99;


/* 2) All films that have deleted scenes(with starting of any letter and apply anylimit).*/
 
select 
    f.title,
    f.film_id,
    f.release_year,
    f.special_features
from film f
where f.special_features LIKE '%deleted scenes%' and f.title like 'c%'
limit 10;

/* 3) All active customers.*/
	
select 
    c.customer_id,
    c.first_name,
    c.active
from customer c
where c.active = 1;


/* 4) Names of customers who rented a movie on 26th July 2005.*/

select 
    r.customer_id,
    date(r.rental_date) 'Rent Date',
    c.first_name
from rental r
join customer c on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-07-26';


/* 5) Distinct names of customers who rented a movie on 26th July 2005.*/

select 
    distinct c.first_name,
    r.customer_id,
    concat(c.first_name,' ', c.last_name)'Full name',
    date(r.rental_date) 'Rent Date'
from rental r
join customer c on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-07-26';

/* ------------------------------OR----------------------------------------------------------*/

select 
    c.first_name,
    COUNT(*) AS rental_count
from rental r
join customer c on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-07-26'
group by c.first_name;


/*6) How many rentals we do on each day?*/

select 
    date(r.rental_date) as RD,
    count(*) as 'Rental_prday_count'
from rental r
group by RD
order by Rental_prday_count desc;



/* 7) All Sci-fi films in our catalogue.*/

select 
    cat.category_id,	
    cat.name,
    f.title,
    f.film_id,
    f.special_features
from category cat
join film_category fc on fc.category_id = cat.category_id
join film f on f.film_id = fc.film_id
where cat.name = 'Sci-Fi';


/* 8) A Customers and how many movies they rented from us on daily bases so far?*/

SELECT 
    c.first_name,
    COUNT(*) AS 'Rental_prday_count',
    c.customer_id
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
GROUP BY c.first_name , c.customer_id
ORDER BY Rental_prday_count DESC;

/* 9) Which movies should we discontinue from our catalogue (less than 2 lifetime rentals)?*/

with low_rentals as 
	(select  
	     inventory_id,
	     count(*) 'inventory_count'
	from rental
	group by inventory_id
	having inventory_count <=1)
    
select 
    i.inventory_id, 
    f.film_id, 
    f.title
from low_rentals
join inventory i on i.inventory_id = low_rentals.inventory_id
join film f on f.film_id = i.film_id;
    
/*10) Which movies are not returned yet*/

select 
    r.customer_id, 
    r.inventory_id, 
    r.return_date, 
    r.rental_date, 
    f.title
from rental r
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
where r.return_date  is null
order by f.title;

/*11) How much money and rentals we make for store 1 by day?*/

with day_rentals as
	(select 
	     r.rental_id,
	     date(r.rental_date) as 'Rent_date',
	     count(*) as 'Pr_day_count',
             r.staff_id
	from rental r
        where r.staff_id = 1
	group by  Rent_date, r.rental_id)
    
    select 
	sum(p.amount)'Total Payment',
	date(p.payment_date)'Rental_day',
        count(*) as 'Rental_count'
    from day_rentals
    join payment p on p.rental_id = day_rentals.rental_id
    group by Rental_day
    order by Rental_count desc; 



/*12) What are the top 3 earnings so far?*/

select 
    sum(p.amount)'Total Payment',
    date(p.payment_date)'Rental_day',
    count(p.payment_date) as 'Rental_count'
from payment p
group by  Rental_day
order by Rental_count desc;
    
#----------------------------------------OR--------------------------------------------------------------

    select 
	sum(p.amount)'Total Payment',
        date(p.payment_date)'Rental_day',
        count(*) as 'Rental_count'
    from rental r
    join payment p on p.rental_id = r.rental_id
    group by Rental_day
    order by Rental_count desc; 
    
    







