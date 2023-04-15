DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS answers CASCADE;

CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  question VARCHAR(255) NOT NULL,
  correct_answer VARCHAR NOT NULL
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  -- age INTEGER NOT NULL CHECK (age >= 18)
  age INTEGER NOT NULL
);

CREATE TABLE answers (
  id SERIAL PRIMARY KEY,
  answer VARCHAR(255),
  --user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL, 
  question_id INTEGER NOT NULL REFERENCES questions(id),
  CONSTRAINT answers_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT answers_one_answer_per_question_per_user
    UNIQUE (question_id, user_id)
);

INSERT INTO questions (question, correct_answer) VALUES
  ('What is the capital of Spain?', 'Madrid'),
  ('What is the capital of France?', 'Paris'),
  ('What is the capital of Germany?', 'Berlin'),
  ('What is the capital of Italy?', 'Rome'),
  ('What is the capital of Portugal?', 'Lisbon');

INSERT INTO users (name, age) VALUES
  ('Shepard', 32),
  ('Garrus', 30),
  ('Liara', 109),
  ('Tali', 25),
  ('Miranda', 36);

INSERT INTO answers (question_id, user_id, answer) VALUES
  (1, 1, 'Madrid'),
  (1, 5, 'Madrid'),
  (2, 2, 'Paris'),
  (2, 3, 'Montreal'),
  (2, 4, 'Tokyo');

-- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta)
SELECT user_name, correct_answers
FROM (
  SELECT u.id, u.name as user_name, COUNT(DISTINCT(q.id)) AS correct_answers
  FROM users u
  LEFT JOIN answers a ON u.id = a.user_id
  LEFT JOIN questions q ON a.question_id = q.id AND a.answer = q.correct_answer
  GROUP BY u.id, u.name
) subquery 
ORDER BY subquery.id ASC;

-- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta
SELECT q.id AS question_id, COUNT(DISTINCT(a.user_id)) AS num_correct_users
FROM questions q
LEFT JOIN answers a ON a.question_id = q.id AND a.answer = q.correct_answer
GROUP BY q.id
ORDER BY q.id ASC;

-- Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación.
DELETE FROM users WHERE id = 1; -- Test (Should fail)
-- Reload data here

ALTER TABLE answers DROP CONSTRAINT answers_user_id_fk;
ALTER TABLE answers ADD CONSTRAINT answers_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
SELECT * FROM answers;
DELETE FROM users WHERE id = 1;
SELECT * FROM answers;

-- Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE users ADD CONSTRAINT age_check CHECK (age >= 18);
INSERT INTO users (name, age) VALUES ('Hillary', 15); --Test (Should fail)

-- Altera la tabla existente de usuarios agregando el campo email con la restricción de único.
ALTER TABLE users ADD COLUMN email VARCHAR(100) UNIQUE;
INSERT INTO users (name, age, email) VALUES ('Javik', 50030, 'prothytheprothean@normandy.com'); --Test
INSERT INTO users (name, age, email) VALUES ('Blasto', 74, 'prothytheprothean@normandy.com'); --Test