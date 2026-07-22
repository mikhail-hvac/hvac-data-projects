-- ============================================================
-- DDL — создание структуры (раздел «CREATE TABLE» из статьи)
-- ============================================================

-- ------------------------------------------------------------
-- 1. departments — справочник отделов
-- ------------------------------------------------------------
CREATE TABLE departments (
    id         SERIAL        PRIMARY KEY,
    name       VARCHAR(50)   NOT NULL,
    budget     DECIMAL(12,2) NOT NULL DEFAULT 0
);

-- ------------------------------------------------------------
-- 2. employees — сотрудники (главная таблица для примеров)
-- ------------------------------------------------------------
CREATE TABLE employees (
    id          SERIAL         PRIMARY KEY,
    name        VARCHAR(100)   NOT NULL,
    department  VARCHAR(50),
    dept_id     INT            REFERENCES departments(id),
    salary      DECIMAL(10,2),
    hired_at    DATE,
    phone       VARCHAR(20),        -- намеренно NULL у части записей
    is_active   BOOLEAN        NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- 3. categories — категории товаров
-- ------------------------------------------------------------
CREATE TABLE categories (
    id    SERIAL       PRIMARY KEY,
    name  VARCHAR(50)  NOT NULL
);

-- ------------------------------------------------------------
-- 4. products — каталог товаров
-- ------------------------------------------------------------
CREATE TABLE products (
    id           SERIAL         PRIMARY KEY,
    name         VARCHAR(100)   NOT NULL,
    category_id  INT            REFERENCES categories(id),
    price        DECIMAL(10,2)  NOT NULL,
    stock        INT            NOT NULL DEFAULT 0
);

-- ------------------------------------------------------------
-- 5. accounts — счета для примера с транзакциями (TCL)
-- ------------------------------------------------------------
CREATE TABLE accounts (
    id      SERIAL         PRIMARY KEY,
    owner   VARCHAR(100)   NOT NULL,
    balance DECIMAL(12,2)  NOT NULL DEFAULT 0
);

-- ------------------------------------------------------------
-- 6. orders — заказы
-- ------------------------------------------------------------
CREATE TABLE orders (
    id          SERIAL         PRIMARY KEY,
    customer_id INT            NOT NULL REFERENCES employees(id),
    created_at  TIMESTAMP      NOT NULL DEFAULT NOW(),
    status      VARCHAR(20)    NOT NULL DEFAULT 'new'
                               CHECK (status IN ('new','processing','shipped','completed','cancelled')),
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0
);

-- ------------------------------------------------------------
-- 7. order_items — строки заказа
-- ------------------------------------------------------------
CREATE TABLE order_items (
    id          SERIAL         PRIMARY KEY,
    order_id    INT            NOT NULL REFERENCES orders(id),
    product_id  INT            NOT NULL REFERENCES products(id),
    quantity    INT            NOT NULL DEFAULT 1,
    unit_price  DECIMAL(10,2)  NOT NULL
);

-- ============================================================
-- DDL — ALTER TABLE (раздел «ALTER TABLE и DROP»)
-- ============================================================

-- Добавить столбец
ALTER TABLE employees ADD COLUMN email VARCHAR(150);

-- Переименовать столбец
ALTER TABLE employees RENAME COLUMN email TO work_email;


-- ============================================================
-- DML — INSERT (раздел «INSERT, UPDATE, DELETE»)
-- ============================================================

-- ------------------------------------------------------------
-- departments
-- ------------------------------------------------------------
INSERT INTO departments (name, budget) VALUES
    ('Design',       500000.00),
    ('Development',  900000.00),
    ('Analytics',    300000.00),
    ('HR',           200000.00),
    ('Marketing',    400000.00);

-- ------------------------------------------------------------
-- employees  (dept_id = NULL у Алексея — для демонстрации LEFT JOIN)
-- ------------------------------------------------------------
INSERT INTO employees (name, department, dept_id, salary, hired_at, phone, is_active, work_email) VALUES
    ('Алексей Иванов',    'Development', 2,    95000.00, '2022-03-01', NULL,            TRUE,  'a.ivanov@company.ru'),
    ('Мария Петрова',     'Design',      1,    80000.00, '2022-03-15', '+7-900-001-01-01', TRUE,  'm.petrova@company.ru'),
    ('Дмитрий Козлов',   'Analytics',   3,    70000.00, '2022-04-01', '+7-900-002-02-02', TRUE,  'd.kozlov@company.ru'),
    ('Анна Смирнова',     'Development', 2,   105000.00, '2021-11-10', '+7-900-003-03-03', TRUE,  'a.smirnova@company.ru'),
    ('Иван Новиков',      'HR',          4,    60000.00, '2023-01-20', NULL,            TRUE,  'i.novikov@company.ru'),
    ('Ольга Фёдорова',   'Marketing',   5,    75000.00, '2023-02-14', '+7-900-005-05-05', TRUE,  'o.fedorova@company.ru'),
    ('Сергей Морозов',    'Development', 2,    88000.00, '2022-07-07', NULL,            TRUE,  's.morozov@company.ru'),
    ('Екатерина Волкова', 'Analytics',  3,    67000.00, '2023-05-23', '+7-900-007-07-07', TRUE,  'e.volkova@company.ru'),
    ('Павел Лебедев',     'Design',      1,    72000.00, '2022-09-01', '+7-900-008-08-08', FALSE, 'p.lebedev@company.ru'),
    ('Наталья Козлова',  'Development', 2,    91000.00, '2021-06-15', '+7-900-009-09-09', TRUE,  'n.kozlova@company.ru'),
    ('Артём Попов',       'HR',          4,    58000.00, '2023-08-10', NULL,            TRUE,  'a.popov@company.ru'),
    ('Виктория Зайцева',  NULL,          NULL, 65000.00, '2023-10-01', '+7-900-012-12-12', TRUE,  'v.zayceva@company.ru');

-- ------------------------------------------------------------
-- categories
-- ------------------------------------------------------------
INSERT INTO categories (name) VALUES
    ('Ноутбуки'),
    ('Смартфоны'),
    ('Аксессуары'),
    ('Программное обеспечение');

-- ------------------------------------------------------------
-- products
-- ------------------------------------------------------------
INSERT INTO products (name, category_id, price, stock) VALUES
    ('MacBook Air M3',         1, 149990.00,  12),
    ('ThinkPad X1 Carbon',     1, 129990.00,   8),
    ('iPhone 16 Pro',          2,  99990.00,  25),
    ('Samsung Galaxy S25',     2,  84990.00,  30),
    ('Беспроводные наушники',  3,   4990.00, 100),
    ('USB-C хаб 7-в-1',        3,   2490.00,  60),
    ('PostgreSQL Pro License', 4,  35000.00,   0),
    ('Антивирус 1 год',        4,   1990.00, 999);

-- ------------------------------------------------------------
-- accounts (для примера с транзакцией из TCL)
-- ------------------------------------------------------------
INSERT INTO accounts (owner, balance) VALUES
    ('Алексей Иванов',  250000.00),
    ('Мария Петрова',   180000.00);

-- ------------------------------------------------------------
-- orders
-- ------------------------------------------------------------
INSERT INTO orders (customer_id, created_at, status, total_amount) VALUES
    (1, '2024-01-15 10:00', 'completed', 154980.00),
    (2, '2024-01-20 14:30', 'completed',  84990.00),
    (3, '2024-02-05 09:15', 'shipped',   102480.00),
    (4, '2024-02-18 16:45', 'completed', 149990.00),
    (1, '2024-03-02 11:20', 'processing', 37490.00),
    (6, '2024-03-10 13:00', 'new',          4990.00),
    (7, '2024-03-22 17:00', 'completed',  99990.00),
    (2, '2024-04-01 08:55', 'cancelled',   2490.00);

-- ------------------------------------------------------------
-- order_items
-- ------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 149990.00),
    (1, 5, 1,   4990.00),
    (2, 4, 1,  84990.00),
    (3, 3, 1,  99990.00),
    (3, 5, 1,   4990.00),
    (3, 6, 2,   2490.00),
    (4, 1, 1, 149990.00),
    (5, 7, 1,  35000.00),
    (5, 6, 1,   2490.00),
    (6, 5, 1,   4990.00),
    (7, 3, 1,  99990.00),
    (8, 6, 1,   2490.00);


-- ============================================================
-- DML — UPDATE
-- ============================================================

-- Поднять зарплату конкретному сотруднику
UPDATE employees SET salary = 100000.00 WHERE id = 1;

-- Повысить зарплату разработчикам с зарплатой выше 90 000 на 10%
UPDATE employees
SET salary = salary * 1.1
WHERE department = 'Development' AND salary > 90000;


-- ============================================================
-- TCL — транзакция (пример из раздела «DCL и TCL»)
-- ============================================================

BEGIN;
    UPDATE accounts SET balance = balance - 5000 WHERE id = 1;
    UPDATE accounts SET balance = balance + 5000 WHERE id = 2;
COMMIT;

-- ============================================================
-- SELECT-ЗАПРОСЫ
-- ============================================================

-- 1. Простой SELECT всех активных сотрудников
SELECT name, department, salary
FROM employees
WHERE is_active = TRUE
ORDER BY salary DESC;

-- 2. WHERE с BETWEEN, IN, LIKE, IS NULL
SELECT name, salary, phone
FROM employees
WHERE salary BETWEEN 60000 AND 95000
  AND department IN ('Development', 'Design')
ORDER BY name;

SELECT name FROM employees WHERE name LIKE 'А%';
SELECT name FROM employees WHERE phone IS NULL;

-- 3. GROUP BY + агрегатные функции
SELECT
    department,
    COUNT(*)               AS headcount,
    ROUND(AVG(salary), 2)  AS avg_salary,
    MAX(salary)            AS max_salary,
    SUM(salary)            AS salary_fund
FROM employees
WHERE is_active = TRUE
GROUP BY department
ORDER BY avg_salary DESC;

-- 4. HAVING — отделы с более чем 2 сотрудниками
SELECT department, COUNT(*) AS cnt
FROM employees
GROUP BY department
HAVING COUNT(*) > 2
ORDER BY cnt DESC;

-- 5. ORDER BY + LIMIT + OFFSET (топ-5 и пагинация)
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 5;
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 5 OFFSET 5;

-- 6. INNER JOIN — сотрудники с их отделами
SELECT e.name, d.name AS department_name, d.budget
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id
ORDER BY d.name, e.name;

-- 7. LEFT JOIN — все сотрудники, включая без отдела
SELECT e.name, d.name AS department_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id
ORDER BY d.name NULLS LAST, e.name;

-- 8. FULL JOIN — все сотрудники и все отделы
SELECT e.name AS employee, d.name AS department
FROM employees e
FULL JOIN departments d ON e.dept_id = d.id
ORDER BY d.name NULLS LAST;

-- 9. Подзапрос в WHERE — сотрудники с зарплатой выше средней
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- 10. Подзапрос в FROM — отделы со средней зарплатой выше 70 000
SELECT dept_name, ROUND(avg_sal, 2) AS avg_salary
FROM (
    SELECT department AS dept_name, AVG(salary) AS avg_sal
    FROM employees
    WHERE is_active = TRUE
    GROUP BY department
) AS dept_stats
WHERE avg_sal > 70000
ORDER BY avg_salary DESC;

-- 11. Подзапрос в SELECT — зарплата сотрудника vs средняя по компании
SELECT
    name,
    salary,
    ROUND((SELECT AVG(salary) FROM employees), 2) AS company_avg,
    ROUND(salary - (SELECT AVG(salary) FROM employees), 2) AS delta
FROM employees
WHERE is_active = TRUE
ORDER BY delta DESC;

-- 12. Многотабличный JOIN — заказы с позициями и товарами
SELECT
    o.id        AS order_id,
    e.name      AS customer,
    p.name      AS product,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total,
    o.status
FROM orders o
JOIN employees  e  ON o.customer_id  = e.id
JOIN order_items oi ON oi.order_id   = o.id
JOIN products   p  ON oi.product_id  = p.id
ORDER BY o.id, p.name;

-- 13. Итоговая выручка по категориям
SELECT
    c.name        AS category,
    COUNT(DISTINCT o.id) AS orders_count,
    SUM(oi.quantity)     AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN orders   o ON oi.order_id  = o.id
JOIN products p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
WHERE o.status != 'cancelled'
GROUP BY c.name
ORDER BY revenue DESC;
