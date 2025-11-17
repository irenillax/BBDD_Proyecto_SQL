-- 1 Crea el esquema de la base de datos
-- Ver esquema en DBeaver -> ER Diagram (BBDD_Proyecto)

-- 2 Muestra los nombres de todas las películas con una clasificación por edades de 'R'.
select f.title
from public.film AS f
where f.rating = 'R'
order by f.title;

-- 3 Encuentra los nombres de los actores que tengan un 'actor_id' entre 30 y 40.
select a.first_name, a.last_name
from public.actor as a
where a.actor_id between 30 and 40
order by a.actor_id;

-- 4 Obtén las películas cuyo idioma coincide con el idioma original.
-- Nota: En el dataset aparece que no hay coincidencias (resultado 0 filas)
select f.film_id, f.title
from public.film AS f
where f.original_language_id is not null
and f.original_language_id = f.language_id
order by f.title;

-- 5. Ordena las películas por duración de forma ascendente. 
select f.title, f.length
from film AS f
order by f.length ASC, f.title ASC;

-- 6 Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
select a.first_name, a.last_name
from actor AS a
where a.last_name ILIKE '%allen%'
order by a.last_name, a.first_name;

-- 7 Encuentra la cantidad total de películas en cada clasificación de la tabla 'film' y muestra la clasificación junto con el recuento.
select f.rating, COUNT(*) AS total_peliculas
from film AS f
group by f.rating
order by total_peliculas DESC, f.rating;

-- 8 Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 3 horas en la tabla film. 
select title, rating, length
from film
where rating = 'PG-13' OR length > 180
order by rating, length DESC, title;

-- 9 Encuentra la variabilidad de lo que costaría reemplazar las películas.
select
  MIN(replacement_cost) AS "Coste mínimo",
  MAX(replacement_cost) AS "Coste máximo",
  AVG(replacement_cost) AS "Coste medio"
from film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select
  MIN(length) as "Duración mínima",
  MAX(length) as "Duración máxima"
from film;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día. 
select payment_id, amount, payment_date
from payment p 
order by payment_date desc
offset 2 limit 1;

-- 12. Encuentra el título de las películas en la tabla 'film' que no sean ni 'NC-17' ni 'G' en cuanto a su clasificación. 
select title, rating
from film
where rating NOT IN ('NC-17', 'G')
order by rating, title;

-- 13 Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
select rating, AVG(length) as "Duración promedio"
from film
group by rating
order by rating;

-- 14 Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos. 
select title, length
from film
where length > 180
order by length desc;

-- 15 ¿Cuánto dinero ha generado en total la empresa?
select SUM(amount) as "Total generado"
from payment;

-- 16 Muestra los 10 clientes con mayor valor de id. 
select customer_id, first_name, last_name
from customer
order by customer_id desc
limit 10;

-- 17 Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'.
select a.first_name, a.last_name
from actor AS a
join film_actor as fa on fa.actor_id = a.actor_id
join film       as f  on f.film_id   = fa.film_id
where f.title = 'EGG IGBY'
order by a.last_name, a.first_name;

-- 18 Selecciona todos los nombres de las películas únicos. 
select distinct title
from film
order by title;

-- 19 Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla 'film'.
select f.title, f.length
from film AS f
join film_category as fc on fc.film_id = f.film_id
join category      as c  on c.category_id = fc.category_id
where c.name = 'Comedy'
  and f.length > 180
order by f.length desc;

-- 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración. 
select c.name as categoria, AVG(f.length) as promedio_min
from category AS c
join film_category as fc on fc.category_id = c.category_id
join film          as f  on f.film_id      = fc.film_id
group by c.name
having AVG(f.length) > 110
order by promedio_min desc;

-- 21 ¿Cuál es la media de duración del alquiler de las películas?
select AVG(f.rental_duration) as media_dias_alquiler
from film as f;

-- 22 Crea una columna con el nombre y apellidos de todos los actores y actrices.
select actor_id,
       first_name || ' ' || last_name as nombre_completo
from actor
order by last_name, first_name;

-- 23 Números de alquiler por día, ordenados por cantidad de alquiler de fomra descendente. 
select CAST(r.rental_date as DATE) as dia,
       COUNT(*) as total_alquileres
from rental as r
group by CAST(r.rental_date as DATE)
order by total_alquileres desc, dia desc;

-- 24 Encuentra las películas con una duración superior al promedio. 
select f.title, f.length
from film as f
where f.length > (select AVG(length) from film)
order by f.length desc;

-- 25 Averigua el número de alquileres registrados por mes. 
select DATE_TRUNC('month', r.rental_date) as mes,
       COUNT(*) as total_alquileres
from rental as r
group by DATE_TRUNC('month', r.rental_date)
order by mes;

-- 26 Encuentra el promedio, la desviación estándar y varianza del total pagado.
select AVG(amount)     as promedio,
       STDDEV(amount)  as desviacion_estandar,
       VARIANCE(amount) as varianza
from payment;

-- 27 ¿Qué películas se alquilan por encima del precio medio?
select f.title, f.rental_rate
from film AS f
where f.rental_rate > (select AVG(rental_rate) from film)
order by f.rental_rate desc, f.title;

-- 28 Muestra el id de los actores que hayan participado en más de 40 películas.
select fa.actor_id,
       COUNT(*) as num_peliculas
from film_actor as fa
group by fa.actor_id
having COUNT(*) > 40
order by num_peliculas desc, fa.actor_id;

-- 29 Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select f.title, COUNT(i.inventory_id) as cantidad_disponible
from film as f
left join inventory as i on f.film_id = i.film_id
group by  f.title
order by cantidad_disponible desc, f.title;

-- 30 Obtener los actores y el número de películas en las que ha actuado.
select a.first_name, a.last_name, COUNT(fa.film_id) as num_peliculas
from actor as a
join film_actor as fa on a.actor_id = fa.actor_id
group by a.first_name, a.last_name
order by  num_peliculas desc, a.last_name;

-- 31 Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select f.title, a.first_name, a.last_name
from film as f
left join film_actor as fa on f.film_id = fa.film_id
left join actor as a on fa.actor_id = a.actor_id
order by f.title, a.last_name;

-- 32 Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película. 
select a.first_name, a.last_name, f.title
from actor as a
left join film_actor as fa on a.actor_id = fa.actor_id
left join film as f on fa.film_id = f.film_id
order by a.last_name, a.first_name;

-- 33 Obtener todas las películas que tenemos y todos los registros de alquiler. 
select f.title, r.rental_id, r.rental_date, r.return_date
from film as f
left join inventory as i on f.film_id = i.film_id
left join rental as r on i.inventory_id = r.inventory_id
order by f.title, r.rental_date;

-- 34 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select c.first_name, c.last_name, SUM(p.amount) as total_gastado
from customer as c
join payment as p on c.customer_id = p.customer_id
group by c.first_name, c.last_name
order by total_gastado desc
limit 5;

-- 35 Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select actor_id, first_name, last_name
from actor
where UPPER(first_name) = 'JOHNNY'
order by last_name, first_name;

-- 36 Renombra la columna 'first_name' como Nombre y 'Last_name' como Apellido.
select first_name as "Nombre", last_name as "Apellido"
from actor
order by "Apellido", "Nombre";

-- 37 Encuentra el ID del actor más bajo y más alto en la tabla actor.
select MIN(actor_id) as id_minimo, MAX(actor_id) as id_maximo
from actor;

-- 38 Cuenta cuántos actores hay en la tabla 'actor'.
select COUNT(*) as total_actores
from actor;

-- 39 Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select first_name, last_name
from actor
order by last_name asc, first_name asc;

-- 40 Selecciona las primeras 5 películas de la tabla 'film'.
select film_id, title
from film
order by film_id
limit 5;

-- 41 Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select first_name, COUNT(*) as total
from actor
group by first_name
order by total desc, first_name
limit 1;

-- 42 Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.rental_id, r.rental_date, c.first_name, c.last_name
from rental r
join customer c on c.customer_id = r.customer_id
order by r.rental_id;

-- 43 Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres. 
select c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
from customer c
left join rental r on r.customer_id = c.customer_id
order by c.customer_id, r.rental_id;

-- 44 Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación. 
select f.title, c.name as category
from film f
cross join category c;

-- CONTESTACIÓN: Este tipo de JOIN combina todas las películas con todas las categorías, por eso el resultado en este caso, no tiene sentido práctico. 

-- 45 Encuentra los actores que han participado en películas de la categoría 'Action'.
select distinct a.first_name, a.last_name
from actor a
join film_actor fa   on fa.actor_id = a.actor_id
join film f          on f.film_id   = fa.film_id
join film_category fc on fc.film_id = f.film_id
join category c      on c.category_id = fc.category_id
where c.name = 'Action'
order by a.last_name, a.first_name;

-- 46 Encuentra todos los actores que no han participado en películas.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE fa.actor_id IS NULL
ORDER BY a.actor_id;

-- 47 Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) as num_peliculas
from actor a
left join film_actor fa on fa.actor_id = a.actor_id
group by a.actor_id, a.first_name, a.last_name
order by num_peliculas desc, a.last_name, a.first_name;

-- 48 Crea una vista llamada 'actor_num_peliculas' que muestre los nombres de los actores y el número de películas en las que han participado.
select
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) as num_peliculas
from actor a
join film_actor fa 
    on fa.actor_id = a.actor_id
group by
    a.actor_id,
    a.first_name,
    a.last_name
order by 
    num_peliculas desc;

-- 49 Calcula el nímero total de alquileres realizados por cada cliente. 
select c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as total_alquileres
from customer c
left join rental r on r.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_alquileres desc, c.last_name, c.first_name;

-- 50 Calcula la duración total de las películas en la categoría 'Action'.
select SUM(f.length) as duracion_total_min
from film f
join film_category fc on fc.film_id = f.film_id
join category c       on c.category_id = fc.category_id
where c.name = 'Action';

-- 51 Crea una tabla temporal llamada 'cliente_rentas_temporal' para alamacenar el total de alquileres por cliente. 
with cliente_rentas_temporal as 
	(select "customer_id" as "Número cliente", count("rental_id") as "Número alquileres"
	from "rental"
	group by "customer_id"
	order by "customer_id")
select "Número cliente", "Número alquileres"
from cliente_rentas_temporal;

-- 52 Crea una tabla temporal llamada 'películas_alquiladas' que almacene las películas que hans ido alquiladas al menos 10 veces. 
select
    f.title AS titulo_pelicula,
    COUNT(r.rental_id) as total_alquileres
from film f
join inventory i 
    on i.film_id = f.film_id
join rental r 
    on r.inventory_id = i.inventory_id
group by
    f.title
having 
    COUNT(r.rental_id) >= 10
order by
    total_alquileres desc;

-- 53 Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre 'Tammy Sanders' y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
select distinct f.title
from public.customer  c
join public.rental    r on r.customer_id = c.customer_id
join public.inventory i on i.inventory_id = r.inventory_id
join  public.film      f on f.film_id       = i.film_id
where LOWER(c.first_name) = 'tammy'
  and LOWER(c.last_name)  = 'sanders'
  and r.return_date is null
order by f.title;

-- 54 Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría 'Sci-Fi'. Ordena los resultados alfabéticamente por apellido. 
select distinct a.first_name, a.last_name
from actor a
join film_actor fa   on fa.actor_id = a.actor_id
join film f          on f.film_id   = fa.film_id
join film_category fc on fc.film_id = f.film_id
join category c      on c.category_id = fc.category_id
where c.name = 'Sci-Fi'
order by a.last_name, a.first_name;

-- 55 Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película 'Spartacus Cheaper' se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido. 
select distinct
    a.first_name,
    a.last_name
from actor a
join film_actor fa on fa.actor_id = a.actor_id
join inventory i   on i.film_id   = fa.film_id
join rental r      on r.inventory_id = i.inventory_id
where r.rental_date >
    (
        select MIN(r2.rental_date)
        from rental r2
        join inventory i2 on i2.inventory_id = r2.inventory_id
        join film f2 on f2.film_id = i2.film_id
        where LOWER(f2.title) = 'spartacus cheaper'
    )
order by
    a.last_name,
    a.first_name;

-- 56 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría 'Music'.
select
    a.first_name,
    a.last_name
from actor a
where a.actor_id not in (
    select distinct fa.actor_id
    from actor a2
    join film_actor fa 
        on fa.actor_id = a2.actor_id
    join film_category fc 
        on fc.film_id = fa.film_id
    join category c 
        on c.category_id = fc.category_id
    where c.name = 'Music'
)
order by
    a.last_name,
    a.first_name;

-- 57 Encuentra el título de todas las películas que fueron alquiladas por más de 8 días. 
select distinct f.title
from film f
join inventory i on i.film_id = f.film_id
join rental   r on r.inventory_id = i.inventory_id
where r.return_date is not null
  and (r.return_date - r.rental_date) > INTERVAL '8 days'
order by f.title;

-- 58 Encuentra el título de todas las películas que son de la misma categoría que 'Animation'.
select distinct f.title
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
where c.name = 'Animation'
order by f.title;

-- 59 Encuentra los nombres de las películas que tienen la misma duración que la película con el título 'Dancing Fever'. Ordena los resultados alfabéticamente por título de película.
select title
from film
where length = (
  select length
  from film
  where title = 'DANCING FEVER'
)
order by title;

-- 60 Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido. 
select c.first_name, c.last_name, COUNT(distinct f.film_id) as peliculas_distintas
from customer c
join rental   r on r.customer_id = c.customer_id
join inventory i on i.inventory_id = r.inventory_id
join film      f on f.film_id = i.film_id
group by c.customer_id, c.first_name, c.last_name
having COUNT(distinct f.film_id) >= 7
order by c.last_name, c.first_name;

-- 61 Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres. 
select c.name AS categoria, COUNT(r.rental_id) as total_alquileres
from category c
join film_category fc on fc.category_id = c.category_id
join film f          on f.film_id = fc.film_id
join inventory i     on i.film_id = f.film_id
join rental r        on r.inventory_id = i.inventory_id
group by c.name
order by c.name;

-- 62 Encuentra el número de películas por categoría estrenadas en 2006. 
select c.name as categoria, COUNT(f.film_id) as num_peliculas_2006
from category c
join film_category fc on fc.category_id = c.category_id
join film f          on f.film_id = fc.film_id
where f.release_year = 2006
group by c.name
order by c.name;

-- 63 Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos. 
select
  s.staff_id,
  s.first_name || ' ' || s.last_name as empleado,
  st.store_id AS tienda
from staff as s
cross join store as st
order by s.staff_id, st.store_id;

-- 64 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas. 
select c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as total_alquiladas
from customer c
left join rental r on r.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by c.customer_id;
