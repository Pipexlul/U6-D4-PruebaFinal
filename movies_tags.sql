DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS movies_tags CASCADE;

CREATE TABLE movies (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  release_year INTEGER NOT NULL
);

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  tag VARCHAR(32) NOT NULL
);

CREATE TABLE movies_tags (
  movie_id INTEGER NOT NULL REFERENCES movies(id),
  tag_id INTEGER NOT NULL REFERENCES tags(id),
  PRIMARY KEY (movie_id, tag_id)
);

INSERT INTO movies (name, release_year) VALUES
  ('The Dark Knight', 2008),
  ('Star Wars: Episode VI - Return of the Jedi', 1983),
  ('Schindler''s List', 1993),
  ('The Lord of the Rings: The Return of the King', 2003),
  ('Star Wars: Episode V - The Empire Strikes Back', 1980);

INSERT INTO tags (tag) VALUES
  ('action'),
  ('adventure'),
  ('comedy'),
  ('drama'),
  ('fantasy');

INSERT INTO movies_tags (movie_id, tag_id) VALUES
  (1, 1),
  (1, 2),
  (1, 4),
  (2, 1),
  (2, 5);

-- Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0
SELECT movie_name, num_tags 
FROM (
  SELECT movies.id, movies.name as movie_name, COUNT(movies_tags.movie_id) as num_tags
  FROM movies
  LEFT JOIN movies_tags ON movies.id = movies_tags.movie_id
  GROUP BY movies.id, movies.name
) subquery
ORDER BY subquery.id ASC;

-- Test unique combinations:
-- Add valid new values
INSERT INTO movies_tags (movie_id, tag_id) VALUES (5, 4);
-- Insert same combination to see if an error is raised
INSERT INTO movies_tags (movie_id, tag_id) VALUES (5, 4);