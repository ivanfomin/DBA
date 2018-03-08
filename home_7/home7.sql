/*Установите ограничения на таблицу товаров:
На цены товаров
На артикулы*/

ALTER TABLE products ADD CHECK (price > 1);
ALTER TABLE products ADD CHECK (products.vendor > 100 AND  products.vendor < 1000);

----------------------------------------------------------------------------------
/*Придумайте еще не менее двух ограничений в других таблицах будущего интернет-магазина и реализуйте их*/

ALTER TABLE brands ADD CHECK (LENGTH(brands.name) > 1);
ALTER TABLE categories ADD CHECK (LENGTH(categories.name) > 3);

-----------------------------------------------------------------------------------
/*
Допустим, что поступило требование: каждый товар может отныне находится в нескольких категориях сразу.
Перепроектируйте таблицу товаров, используя поле categories bigint[] и напишите запросы
 */
ALTER TABLE products DROP COLUMN categor_id;
ALTER TABLE products ADD COLUMN categors_id BIGINT[];

ALTER TABLE products
  ADD CHECK (products.categors_id [1] >= 1 AND products.categors_id [1] <= 4
             AND products.categors_id [2] >= 1 AND products.categors_id [2] <= 4);

------------------------------------------------------------------------------
/*
Выбирающий все товары из заданной категории
Выбирающий все категории и количество товаров в каждой из них
Добавляющий определенный товар в определенную категорию
 */

SELECT products.title
FROM products
  INNER JOIN categories ON categories.id = ANY (products.categors_id) AND categories.name = 'Computers';

SELECT categories.name,
  COUNT(products.categors_id) as amount
FROM categories INNER JOIN products
  ON categories.id = ANY(products.categors_id)
GROUP BY categories.id;

INSERT INTO categories (name) VALUES ('Secondhand');
UPDATE products SET categors_id = (array_append(categors_id, CAST ( 4 AS BIGINT)))  WHERE id = 8;

