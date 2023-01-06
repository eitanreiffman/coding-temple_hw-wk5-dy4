
--1. Create a Stored Procedure that will insert a new film into the film table with the
--following arguments: title, description, release_year, language_id, rental_duration,
--rental_rate, length, replacement_cost, rating

-- Inserting a film without using a Procedure

INSERT INTO film (
	title,
	description,
	release_year,
	language_id,
	rental_duration,
	rental_rate,
	length,
	replacement_cost,
	rating
) VALUES (
	'The Matrix',
	'Upon discovering that his world his fake, a man enters the real world and seeks to save whats left of humanity.',
	'1999',
	'1',
	'7',
	5.99,
	136,
	20.00,
	'R'
);

-- Inserting a film with a Procedure


CREATE OR REPLACE PROCEDURE add_film(
	f_title VARCHAR(255),
	f_description TEXT,
	f_release_year YEAR,
	f_language_id integer,
	f_rental_duration integer,
	f_rental_rate NUMERIC(4,2),
	f_length integer,
	f_replacement_cost NUMERIC(5,2),
	f_rating mpaa_rating
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO film (
	title,
	description,
	release_year,
	language_id,
	rental_duration,
	rental_rate,
	length,
	replacement_cost,
	rating
)   VALUES (
	f_title,
	f_description,
	f_release_year,
	f_language_id,
	f_rental_duration,
	f_rental_rate,
	f_length,
	f_replacement_cost,
	f_rating
);
END;
$$;
    
CALL add_film(
	'The Lord of the Rings: The Fellowship of the Ring',
	'Four hobbits, one wizard, two men, one elf, and one dwarf seek to destroy an all-powerful ring.',
	'2001',
	1,
	7,
	6.99,
	178,
	20.00,
	'PG-13'::mpaa_rating
);


DROP PROCEDURE add_film(character varying,text,year,smallint,smallint,numeric,smallint,numeric,mpaa_rating)

SELECT *
FROM film
WHERE title LIKE 'The %';

SELECT *
FROM film
WHERE film_id = 1003;

DELETE FROM film
WHERE film_id = 1005;



--2. Create a Stored Function that will take in a category_id and return the number of
--films in that category


CREATE OR REPLACE FUNCTION films_in_category(a_category integer)
RETURNS integer
LANGUAGE plpgsql
AS $$
	DECLARE film_count integer;
BEGIN
	SELECT count(*) into film_count
	FROM film_category
	GROUP BY category_id
	HAVING category_id = a_category;
	RETURN film_count;
END;
$$;


SELECT films_in_category(4); -- Category ID 4, film count: 57
SELECT films_in_category(14); -- Category ID 14, film count: 61
SELECT films_in_category(3); -- Category ID 3, film count: 60