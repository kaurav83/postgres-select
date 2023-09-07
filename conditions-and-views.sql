-- Задача: дізнатись, чи є в таблиці users користувачі, у яких в полі gender - NULL

SELECT * FROM users
WHERE gender IS NULL;

-- Задача. Створити стовпець в таблиці orders: виконано / не виокнано замовлення
SELECT * FROM orders;

ALTER TABLE orders
ADD COLUMN status boolean;

UPDATE orders
SET status = true
WHERE id % 2 = 0;

UPDATE orders
SET status = false
WHERE id % 2 = 1;

-- ЗАДАЧА: Вивести всі замовлення, там де статус "true" - написати "виконано"
SELECT id, created_at, customer_id, status, (
CASE
    WHEN status = true THEN 'Выполнен'
    WHEN status = false THEN 'Не выполнен'
END    
) as status_orders
FROM orders
ORDER BY id;

-- Витягти місяць народження юзера і на його основі вивести, народився юзер восени
-- , навесні, влітку чи взимку
SELECT * FROM users;

SELECT *, (
    CASE extract('month' from birthday)
        WHEN 1 THEN 'winter'
        WHEN 2 THEN 'winter'
        WHEN 3 THEN 'spring'
        WHEN 4 THEN 'spring'
        WHEN 5 THEN 'spring'
        WHEN 6 THEN 'summer'
        WHEN 7 THEN 'summer'
        WHEN 8 THEN 'summer'
        WHEN 9 THEN 'fall'
        WHEN 10 THEN 'fall'
        WHEN 11 THEN 'fall'
        WHEN 12 THEN 'winter'
        ELSE 'unkown'
    END
) as time_of_year 
FROM users;

-- Вивести юзерів, в яких в полі "стать" буде українською написано "жінка"
-- або "чоловік" або "інше значення"
SELECT *, (
    CASE
        WHEN gender = 'male' THEN 'мужчина'
        WHEN gender = 'female' THEN 'женщина'
        ELSE 'не известно'
    END
) AS gender_ukr
FROM users;

-- Вивести на основі кількості років користувача, що він повнолітній або неповнолітній
SELECT *, (
    CASE
        WHEN extract(year from age(birthday)) < 18 THEN 'несовершеннолетний'
        WHEN extract(year from age(birthday)) >= 18 THEN 'совершеннолетний'
        ELSE 'не известно'
    END
) AS mature
FROM users;

-- Вивести всі телефони (з таблиці products),
-- якщо ціна телефону > 6 тис - "флагман",
-- якщо ціна від 2 до 6 - "середній клас",
-- якщо ціна <2 тис - "бюджетний"
SELECT *, (
    CASE
        WHEN price > 6000 THEN 'флагман'
        WHEN price BETWEEN 2000 AND 6000 THEN 'середній клас'
        WHEN price < 2000 THEN 'бюджетний'
        ELSE 'не известно'
    END
) AS "ценовой диапазон"
FROM products;

/*
Вивести користувачів з інформацією про їхні замовлення у вигляді:
- якщо більше >=3 - "постійний клієнт"
- якщо від 1 до 2 - "активний клієнт"
- якщо 0 замовлень - "новий клієнт"
*/
SELECT u.id AS user_id, concat(first_name, ' ', last_name) as full_name, (
    CASE
        WHEN count(*) >= 3 THEN 'Постійний клієнт'
        WHEN count(*) BETWEEN 1 AND  2 THEN 'Активний клієнт'
        WHEN count(*) = 0 THEN 'Новый клиент'
    END
) AS info_orders
FROM users AS u JOIN orders AS o
ON u.id = o.customer_id
GROUP BY user_id;

------------------
SELECT * FROM products
WHERE products.id NOT IN (SELECT product_id FROM orders_to_products);

SELECT * FROM orders_to_products;

-----------------------
CREATE FUNCTION run_fn()
RETURNS void
AS
$$
BEGIN
    SELECT * FROM orders_to_products;
END;
$$
LANGUAGE plpgsql;

SELECT run_fn();

-- Найти все телефоны, которые покупал пользователь с id 11
-- 1. Без использования JOIN

SELECT * FROM products AS p
WHERE p.id = ANY (
    SELECT product_id FROM orders_to_products AS otp
    WHERE otp.order_id = SOME (
        SELECT id FROM orders AS o
        WHERE customer_id = 11
    )
);

-- 2. С использованием JOIN

SELECT * FROM products AS p
INNER JOIN orders_to_products AS otp
ON otp.product_id = p.id
INNER JOIN orders AS o
ON otp.order_id = o.id
WHERE o.customer_id = 11;


-- Создание новой схемы и таблиц в ней
CREATE SCHEMA newtask;

CREATE TABLE newtask.users (
    id serial PRIMARY KEY,
    login varchar(20) NOT NULL CHECK(login != ''),
    email varchar(30) UNIQUE NOT NULL,
    password varchar(20) NOT NULL CHECK(password != '')
);

CREATE TABLE newtask.employees (
    id serial PRIMARY KEY,
    salary int NOT NULL,
    position varchar(50) NOT NULL CHECK(position != ''),
    hire_date date DEFAULT current_date,
    name varchar(40) NOT NULL CHECK(name != ''),
    department_id int REFERENCES newtask.departments(id)
);

CREATE TABLE newtask.departments (
    id serial PRIMARY KEY,
    department varchar(100) NOT NULL CHECK(department != '')
);
