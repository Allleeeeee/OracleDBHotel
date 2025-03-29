--заполнение HOTELS
CREATE OR REPLACE FUNCTION populate_hotels_table
RETURN BOOLEAN
AS
    TYPE t_name_arr IS TABLE OF VARCHAR2(50);
    TYPE t_city_arr IS TABLE OF VARCHAR2(50);
    TYPE t_address_arr IS TABLE OF VARCHAR2(50);
    TYPE t_rating_arr IS TABLE OF VARCHAR2(50);

    names t_name_arr := t_name_arr('Курорт Закатный Пляж', 'Лесной Замок', 'Королевский Дворец', 'Курорт Золотые Пески', 'Тропический Рай Инн',
                                   'Шале Снежные Пики', 'Отель Городские Огни', 'Речная Усадьба', 'Пустынный Оазис', 'Отель Вид на Гавань');
    cities t_city_arr := t_city_arr('Гонолулу', 'Денвер', 'Лондон', 'Дубай', 'Бали', 'Уистлер', 'Токио', 'Париж', 'Сидней');
    addresses t_address_arr := t_address_arr('ул. Вайкики, 123', 'ул. Сосновая, 456', 'ул. Букингемская, 789', 'ул. Джумейра Бич, 123', 'ул. Пляж Кута, 456',
                                             'ул. Горный Городок, 789', 'ул. Шиндзюку, 123', 'ул. Набережная Сены, 456', 'ул. Аравийская Пустыня, 789',
                                             'ул. Круговая Причал, 123');
    ratings t_rating_arr := t_rating_arr('4 звезды', '3 звезды', '5 звезд');

    name_idx NUMBER;
    city_idx NUMBER;
    address_idx NUMBER;
    rating_idx NUMBER;
    i PLS_INTEGER := 5;
BEGIN
       WHILE i <= 100005  LOOP
        name_idx := TRUNC(DBMS_RANDOM.VALUE(1, names.COUNT + 1));
        city_idx := TRUNC(DBMS_RANDOM.VALUE(1, cities.COUNT + 1));
        address_idx := TRUNC(DBMS_RANDOM.VALUE(1, addresses.COUNT + 1));
        rating_idx := TRUNC(DBMS_RANDOM.VALUE(1, ratings.COUNT + 1));

       
        INSERT INTO HOTELS (ID_HOT, NAME_HOT, CITY, ADRESS, RATING)
        VALUES (i, names(name_idx), cities(city_idx), addresses(address_idx), ratings(rating_idx));
   i:= i+1;
    END LOOP;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;



--ЗАПУСК ФУНКЦИИ
BEGIN
    IF populate_hotels_table() THEN
        DBMS_OUTPUT.PUT_LINE('Таблица HOTELS успешно заполнена.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ошибка заполнения таблицы HOTELS.');
    END IF;
END;


--заполнение ROOMS
CREATE OR REPLACE FUNCTION populate_rooms_table
RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO ROOMS (ID_NUM, ID_HOT, TYPE, PRICE, AVAILABILITY, NUM_OF_ROOM)
        VALUES (i,
                ROUND(DBMS_RANDOM.VALUE(1, 100000)), 
                CASE ROUND(DBMS_RANDOM.VALUE(1, 6)) 
                    WHEN 1 THEN 'Стандартный'
                    WHEN 2 THEN 'Люкс'
                    WHEN 3 THEN 'Двухэтажный люкс'
                     WHEN 4 THEN 'Двухместный'
                    WHEN 5 THEN 'Трёхместный'
                    WHEN 6 THEN 'Президентский люкс'
                END,
                ROUND(DBMS_RANDOM.VALUE(100, 1000)), 
                CASE ROUND(DBMS_RANDOM.VALUE(0, 1)) 
                    WHEN 0 THEN 'Доступен'
                    WHEN 1 THEN 'Не доступен'
                END,
                ROUND(DBMS_RANDOM.VALUE(1, 500))); 
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;


--запуск функции
BEGIN
 IF populate_rooms_table() THEN
        DBMS_OUTPUT.PUT_LINE('Таблица ROOMS успешно заполнена.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ошибка заполнения таблицы ROOMS.');
    END IF;
END;


--заполнение CUSTOMERS
CREATE OR REPLACE FUNCTION populate_customers_table
RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO CUSTOMERS (ID_CUSTOM, NAME, SURNAME, EMAIL, PHONE_NUM, LOGIN)
        VALUES (i,
               CASE ROUND(DBMS_RANDOM.VALUE(1, 15))
                    WHEN 1 THEN 'Иван'
                    WHEN 2 THEN 'Мария'
                    WHEN 3 THEN 'Александр'
                    WHEN 4 THEN 'Елена'
                    WHEN 5 THEN 'Дмитрий'
                    WHEN 6 THEN 'Ольга'
                    WHEN 7 THEN 'Стефания'
                    WHEN 8 THEN 'Виктория'
                    WHEN 9 THEN 'Яна'
                    WHEN 10 THEN 'Алеся'
                    WHEN 11 THEN 'Полина'
                    WHEN 12 THEN 'Андрей'
                    WHEN 13 THEN 'Николай'
                    WHEN 14 THEN 'Артур'
                    WHEN 15 THEN 'Ксения'
                END,
                CASE ROUND(DBMS_RANDOM.VALUE(1, 12))
                    WHEN 1 THEN 'Гришко'
                    WHEN 2 THEN 'Савко'
                    WHEN 3 THEN 'Грицкевич'
                    WHEN 4 THEN 'Дашкевич'
                    WHEN 5 THEN 'Микайлян'
                    WHEN 6 THEN 'Мущук'
                     WHEN 7 THEN 'Панченко'
                    WHEN 8 THEN 'Гончар'
                    WHEN 9 THEN 'Осоко'
                    WHEN 10 THEN 'Якубенко'
                    WHEN 11 THEN 'Юхимук'
                    WHEN 12 THEN 'Дятко'
                END,
            DBMS_RANDOM.STRING('a', 10) || i || '@gmail.com',
               '+375' || i,
             'login_' || i );
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;

--запуск функции
BEGIN
 IF populate_customers_table() THEN
        DBMS_OUTPUT.PUT_LINE('Таблица CUSTOMERS успешно заполнена.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ошибка заполнения таблицы CUSTOMERS.');
    END IF;
END;


--заполнение RESERVATIONS
CREATE OR REPLACE FUNCTION populate_reservations_table RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO RESERVATIONS (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
        VALUES (
            i,
            ROUND(DBMS_RANDOM.VALUE(1, 100000)), 
            ROUND(DBMS_RANDOM.VALUE(1, 100000)), 
            CASE ROUND(DBMS_RANDOM.VALUE(1, 2))
                WHEN 1 THEN 'Подтверждено'
                WHEN 2 THEN 'Ожидает подтверждения'
            END,
            TO_DATE('2024-05-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 365)), -- Случайная дата в пределах года
            TO_DATE('2024-12-31', 'YYYY-MM-DD') - TRUNC(DBMS_RANDOM.VALUE(0, 365)) 
        );
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RETURN FALSE;
END;



--запуск функции
BEGIN
 IF populate_reservations_table() THEN
        DBMS_OUTPUT.PUT_LINE('Таблица RESERVATIONS успешно заполнена.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ошибка заполнения таблицы RESERVATIONS.');
    END IF;
END;


--заполнение payments
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE FUNCTION populate_payments_table RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        DECLARE
            v_price NUMBER(10, 2);
            v_pay_id NUMBER(10);
        BEGIN
            SELECT r.ID_NUM INTO v_price
            FROM RESERVATIONS r
            WHERE r.ID_RESERV = i;

            SELECT payment_seq.NEXTVAL INTO v_pay_id FROM dual;

            INSERT INTO PAYMENTS (ID_PAY, ID_RESERV, SUM_PAY, STATUS)
            VALUES (
                v_pay_id,
                i,
                (SELECT PRICE FROM ROOMS WHERE ID_NUM = v_price),
                CASE ROUND(DBMS_RANDOM.VALUE(1, 2))
                    WHEN 1 THEN 'Оплачено'
                    WHEN 2 THEN 'Ожидает оплаты'
                END
            );
        END;
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RETURN FALSE;
END;




--запуск функции
BEGIN
 IF populate_payments_table() THEN
        DBMS_OUTPUT.PUT_LINE('Таблица payments успешно заполнена.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ошибка заполнения таблицы payments.');
    END IF;
END;


--заполнение roles
CREATE OR REPLACE FUNCTION populate_role_table RETURN BOOLEAN IS
BEGIN
 INSERT INTO ROLE (LOGIN, STATUS, PASSWORD)
        VALUES ('admin','Admin','Pa$$w0rd');
    FOR i IN 2..100000 LOOP
        INSERT INTO ROLE (LOGIN, STATUS, PASSWORD)
        VALUES (
           'login_' || i,
            'User',
            'pass' || i
        );
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RETURN FALSE;
END;


----запуск функции
BEGIN
 IF populate_role_table() THEN
        DBMS_OUTPUT.PUT_LINE('Таблица role успешно заполнена.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ошибка заполнения таблицы role.');
    END IF;
END;

