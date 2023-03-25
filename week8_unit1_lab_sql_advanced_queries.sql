USE sakila;

#  1. List each pair of actors that have worked together.
SELECT 
  CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, 
  CONCAT(a2.first_name, ' ', a2.last_name) AS actor2 
FROM 
  film_actor fa1 
  JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id <> fa2.actor_id 
  JOIN actor a1 ON fa1.actor_id = a1.actor_id 
  JOIN actor a2 ON fa2.actor_id = a2.actor_id 
GROUP BY 
  actor1, 
  actor2 
ORDER BY 
  actor1, 
  actor2;

# 2. For each film, list actor that has acted in more films.
SELECT f.title AS film_title, CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM film_actor AS fa
JOIN actor AS a ON fa.actor_id = a.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN (
    SELECT fa.actor_id, COUNT(DISTINCT fa.film_id) AS num_films
    FROM film_actor AS fa
    GROUP BY fa.actor_id
) AS subquery ON a.actor_id = subquery.actor_id
JOIN (
    SELECT f.film_id, MAX(subquery.num_films) AS max_num_films
    FROM film AS f
    JOIN film_actor AS fa ON f.film_id = fa.film_id
    JOIN (
        SELECT fa.actor_id, COUNT(DISTINCT fa.film_id) AS num_films
        FROM film_actor AS fa
        GROUP BY fa.actor_id
    ) AS subquery ON fa.actor_id = subquery.actor_id
    GROUP BY f.film_id
) AS subquery2 ON f.film_id = subquery2.film_id AND subquery.num_films = subquery2.max_num_films
ORDER BY f.title;

