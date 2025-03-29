------procedures----



-----admin--------------------------------
--процедуры для просмотра платежей и их подтверждения

 CREATE OR REPLACE PROCEDURE VIEW_PAYMENTS
AS
BEGIN
    FOR p IN (SELECT ID_PAY, ID_RESERV, SUM_PAY, STATUS FROM PAYMENTS)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID Платежа: ' || p.ID_PAY);
        DBMS_OUTPUT.PUT_LINE('ID Бронирования: ' || p.ID_RESERV);
        DBMS_OUTPUT.PUT_LINE('Сумма Платежа: ' || p.SUM_PAY);
        DBMS_OUTPUT.PUT_LINE('Статус: ' || p.STATUS);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;


--Процедура для изменения информации о номере
CREATE OR REPLACE PROCEDURE update_room_info (
    p_id_num IN NUMBER,
    p_id_hot IN NUMBER,
    p_type IN VARCHAR2,
    p_price IN NUMBER,
    p_availability IN VARCHAR2,
    p_num_of_room IN NUMBER
) IS
BEGIN
    UPDATE rooms
    SET id_hot = p_id_hot,
        type = p_type,
        price = p_price,
        availability = p_availability,
        num_of_room = p_num_of_room
    WHERE id_num = p_id_num;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Room ' || p_id_num || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Room ' || p_id_num || ' successfully updated.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--Получение списка всех пользователей
CREATE OR REPLACE PROCEDURE GET_ALL_CUSTOMERS_INFO
AS
BEGIN
    FOR r IN (SELECT ID_CUSTOM, NAME, SURNAME, EMAIL, PHONE_NUM, LOGIN 
              FROM CUSTOMERS) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Customer ID: ' || r.ID_CUSTOM);
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.NAME);
        DBMS_OUTPUT.PUT_LINE('Surname: ' || r.SURNAME);
        DBMS_OUTPUT.PUT_LINE('Email: ' || r.EMAIL);
        DBMS_OUTPUT.PUT_LINE('Phone Number: ' || r.PHONE_NUM);
        DBMS_OUTPUT.PUT_LINE('Login: ' || r.LOGIN);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;


--удаление комнаты
CREATE OR REPLACE PROCEDURE delete_room (
    p_id_num IN NUMBER
) IS
BEGIN
    -- Удаляем номер из таблицы ROOMS
    DELETE FROM rooms
    WHERE id_num = p_id_num;

    -- Проверяем, была ли удалена какая-либо строка
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Room ' || p_id_num || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Room ' || p_id_num || ' successfully deleted.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--Процедура для удаления пользователя по логину
CREATE OR REPLACE PROCEDURE delete_user_by_login (
    p_login IN VARCHAR2
) IS
BEGIN
    -- Удаление пользователя из таблицы CUSTOMERS
    DELETE FROM customers
    WHERE login = p_login;

    -- Удаление пользователя из таблицы ROLE
    DELETE FROM role
    WHERE login = p_login;

    -- Проверка, была ли удалена хотя бы одна строка из таблицы CUSTOMERS
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' successfully deleted.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--добавление нового отеля
CREATE OR REPLACE PROCEDURE ADD_HOTEL(
    p_id_hot IN NUMBER,
    p_name_hot IN VARCHAR2,
    p_city IN VARCHAR2,
    p_address IN VARCHAR2,
    p_rating IN VARCHAR2
)
AS
BEGIN
    INSERT INTO HOTELS (ID_HOT, NAME_HOT, CITY, ADRESS, RATING)
    VALUES (p_id_hot, p_name_hot, p_city, p_address, p_rating);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Отель успешно добавлен.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Отель с указанным ID_HOT уже существует.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;




--Процедура для изменения данных пользователя
CREATE OR REPLACE PROCEDURE update_user_by_login (
    p_login IN VARCHAR2,
    p_name IN VARCHAR2,
    p_surname IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone_num IN VARCHAR2
) as
is_valid boolean;
BEGIN
-- Проверяем валидность email
    is_valid := is_valid_email(p_email);
    IF NOT is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Invalid email format: ' || p_email);
        RETURN;
    END IF;
    -- Обновление данных пользователя в таблице CUSTOMERS
    UPDATE customers
    SET
        name = p_name,
        surname = p_surname,
        email = p_email,
        phone_num = p_phone_num
    WHERE login = p_login;

    -- Проверка, была ли обновлена хотя бы одна строка
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' successfully updated.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--Удаление отеля из системы
CREATE OR REPLACE PROCEDURE DELETE_HOTEL(
    p_id_hot IN NUMBER
)
AS
    e_hotel_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_hotel_not_found, -20001);
BEGIN
    -- Проверка наличия отеля
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM HOTELS WHERE ID_HOT = p_id_hot;
        IF v_count = 0 THEN
            RAISE e_hotel_not_found;
        END IF;
    END;

    -- Удаление комнат, связанных с отелем
    DELETE FROM ROOMS WHERE ID_HOT = p_id_hot;
    
    -- Удаление самого отеля
    DELETE FROM HOTELS WHERE ID_HOT = p_id_hot;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Отель и связанные с ним комнаты успешно удалены.');
    
EXCEPTION
    WHEN e_hotel_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Отель с ID ' || p_id_hot || ' не существует.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;


--Добавление нового номера в отель
CREATE OR REPLACE PROCEDURE ADD_ROOM(
    p_id_num IN NUMBER,
    p_id_hot IN NUMBER,
    p_type IN VARCHAR2,
    p_price IN NUMBER,
    p_availability IN VARCHAR2,
    p_num_of_room IN NUMBER
)
AS
BEGIN
    -- Проверка наличия отеля с заданным ID_HOT
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM HOTELS WHERE ID_HOT = p_id_hot;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Отель с указанным ID_HOT не существует.');
        END IF;
    END;

    -- Вставка новой комнаты
    INSERT INTO ROOMS (ID_NUM, ID_HOT, TYPE, PRICE, AVAILABILITY, NUM_OF_ROOM)
    VALUES (p_id_num, p_id_hot, p_type, p_price, p_availability, p_num_of_room);

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Комната успешно добавлена.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Комната с таким ID_NUM уже существует.');
        ROLLBACK;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Отель с указанным ID_HOT не существует.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;


--Удаление номера из отеля
CREATE OR REPLACE PROCEDURE DELETE_ROOM(
    p_id_num IN NUMBER
)
AS
BEGIN
    -- Проверка наличия комнаты с заданным ID_NUM
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM ROOMS WHERE ID_NUM = p_id_num;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Комната с указанным ID_NUM не существует.');
        END IF;
 END;
  -- Удаление комнаты
    DELETE FROM ROOMS WHERE ID_NUM = p_id_num;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Комната успешно удалена.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Комната с указанным ID_NUM не найдена.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;



--процедура для обновления рейтинга отеля
CREATE OR REPLACE PROCEDURE UPDATE_HOTEL_RATING(
    p_id_hot IN NUMBER,
    p_new_rating IN VARCHAR2
)
AS
BEGIN
    -- Обновление рейтинга отеля
    UPDATE HOTELS SET RATING = p_new_rating WHERE ID_HOT = p_id_hot;
    
    -- Проверка количества обновленных строк
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Отель с указанным ID_HOT не найден.');
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Рейтинг отеля успешно обновлен.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Отель с указанным ID_HOT не найден.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;

--Получение статистики по бронированиям в системе
CREATE OR REPLACE PROCEDURE  GET_RESERVATION_STATISTICS
AS
    total_reservations NUMBER;
    confirmed_reservations NUMBER;
    pending_reservations NUMBER;
    cancelled_reservations NUMBER;
BEGIN
    SELECT COUNT(*),
           SUM(CASE WHEN STATUS = 'Подтверждено' THEN 1 ELSE 0 END),
           SUM(CASE WHEN STATUS = 'Ожидает подтверждения' THEN 1 ELSE 0 END),
           SUM(CASE WHEN STATUS = 'Отменено' THEN 1 ELSE 0 END)
    INTO total_reservations, confirmed_reservations, pending_reservations, cancelled_reservations
    FROM RESERVATIONS;

    DBMS_OUTPUT.PUT_LINE('Статистика бронирований:');
    DBMS_OUTPUT.PUT_LINE('Всего бронирований: ' || total_reservations);
    DBMS_OUTPUT.PUT_LINE('Подтвержденных бронирований: ' || confirmed_reservations);
    DBMS_OUTPUT.PUT_LINE('Бронирований, ожидающих подтверждения: ' || pending_reservations);
    DBMS_OUTPUT.PUT_LINE('Отмененных бронирований: ' || cancelled_reservations);
END;



--для пользователя---------------------------------------------------------


-- Процедура для бронирования номера в отеле
CREATE SEQUENCE SEQ_RESERVATION
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
 
CREATE OR REPLACE PROCEDURE BOOK_ROOM(
    CUSTOMER_ID IN NUMBER,
    HOTEL_ID IN NUMBER,
    ROOM_ID IN NUMBER,
    START_DATE IN DATE,
    END_DATE IN DATE
)
AS
    v_dummy NUMBER;
BEGIN
    -- Проверка существования клиента
    BEGIN
        SELECT 1 INTO v_dummy FROM CUSTOMERS WHERE ID_CUSTOM = CUSTOMER_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Клиент с указанным ID_CUSTOM не найден.');
    END;

    -- Проверка существования отеля
    BEGIN
        SELECT 1 INTO v_dummy FROM HOTELS WHERE ID_HOT = HOTEL_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Ошибка: Отель с указанным ID_HOT не найден.');
    END;

    -- Проверка существования номера
    BEGIN
        SELECT 1 INTO v_dummy FROM ROOMS WHERE ID_NUM = ROOM_ID AND ID_HOT = HOTEL_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Ошибка: Номер с указанным ID_NUM не найден в данном отеле.');
    END;

    -- Вставка данных о бронировании
    INSERT INTO RESERVATIONS (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
    VALUES (SEQ_RESERVATION.NEXTVAL, CUSTOMER_ID, ROOM_ID, 'Pending', START_DATE, END_DATE);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Бронирование успешно создано.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Данные не найдены.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Дублирующаяся запись.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;







-- Процедура для получения счета за собственное бронирование
CREATE OR REPLACE PROCEDURE GET_SUM_PAY_BY_RESERVATION(
    p_id_reserv IN NUMBER
)
AS
    v_sum_pay NUMBER(10, 2);
BEGIN

    -- Получение суммы платежей для данного ID_RESERV
    SELECT SUM(SUM_PAY)
    INTO v_sum_pay
    FROM PAYMENTS
    WHERE ID_RESERV = p_id_reserv;

    -- Проверка, чтобы сумма не была NULL
    IF v_sum_pay IS NULL THEN
        v_sum_pay := 0;
    END IF;

    -- Вывод суммы
    DBMS_OUTPUT.PUT_LINE('Сумма платежей для бронирования: ' || v_sum_pay);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Бронирование с ID ' || p_id_reserv || ' не найдено.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;


--добавление нового отеля в систему
CREATE OR REPLACE PROCEDURE ADD_HOTEL(
    p_id_hot IN NUMBER,
    p_name_hot IN VARCHAR2,
    p_city IN VARCHAR2,
    p_address IN VARCHAR2,
    p_rating IN VARCHAR2
)
AS
BEGIN
    -- Вставка данных об отеле
    INSERT INTO HOTELS (ID_HOT, NAME_HOT, CITY, ADRESS, RATING)
    VALUES (p_id_hot, p_name_hot, p_city, p_address, p_rating);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Отель успешно добавлен.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Отель с указанным ID_HOT уже существует.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;


-- Процедура для получения информации о собственных бронированиях
CREATE OR REPLACE PROCEDURE GET_MY_RESERVATIONS(
    p_id_custom IN NUMBER
)
AS
BEGIN
    -- Проверка существования клиента
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM CUSTOMERS WHERE ID_CUSTOM = p_id_custom;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Клиент с указанным ID_CUSTOM не найден.');
        END IF;
    END;

    -- Получение информации о бронированиях
    FOR r IN (SELECT ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D 
              FROM RESERVATIONS
              WHERE ID_CUSTOM = p_id_custom) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Комната: ' || r.ID_NUM);
        DBMS_OUTPUT.PUT_LINE('Статус: ' || r.STATUS);
        DBMS_OUTPUT.PUT_LINE('Дата заезда : ' || TO_CHAR(r.DATE_A, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Дата отъезда: ' || TO_CHAR(r.DATE_D, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Данные не найдены.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
END;



CREATE OR REPLACE PROCEDURE CONFIRM_PAYMENT(
    p_id_pay IN NUMBER
)
AS
BEGIN
    -- Проверка существования платежа
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM PAYMENTS WHERE ID_PAY = p_id_pay;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Платеж с указанным ID_PAY не найден.');
        END IF;
    END;

    -- Обновление статуса платежа
    UPDATE PAYMENTS SET STATUS = 'Оплачено' WHERE ID_PAY = p_id_pay;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Платеж успешно подтвержден.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Данные не найдены.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;


--Управление бронированиями 
create or replace 
PROCEDURE VIEW_PAYMENTS
AS
BEGIN
    FOR p IN (SELECT ID_PAY, ID_RESERV, SUM_PAY, STATUS FROM PAYMENTS)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID Платежа: ' || p.ID_PAY);
        DBMS_OUTPUT.PUT_LINE('ID Бронирования: ' || p.ID_RESERV);
        DBMS_OUTPUT.PUT_LINE('Сумма Платежа: ' || p.SUM_PAY);
        DBMS_OUTPUT.PUT_LINE('Статус: ' || p.STATUS);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;

--подтверждение
CREATE OR REPLACE PROCEDURE CONFIRM_RESERVATION(
    p_id_reserv IN NUMBER
)
AS
BEGIN
    -- Проверка существования бронирования
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RESERVATIONS WHERE ID_RESERV = p_id_reserv;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Бронирование с указанным ID_RESERV не найдено.');
        END IF;
    END;

    -- Обновление статуса бронирования
    UPDATE RESERVATIONS SET STATUS = 'Подтверждено' WHERE ID_RESERV = p_id_reserv;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Бронирование успешно подтверждено.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Данные не найдены.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Дублирующаяся запись.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;


--отмена
CREATE OR REPLACE PROCEDURE CANCEL_RESERVATION(
    p_id_reserv IN NUMBER
)
AS
BEGIN
    -- Проверка существования бронирования
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RESERVATIONS WHERE ID_RESERV = p_id_reserv;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ошибка: Бронирование с указанным ID_RESERV не найдено.');
        END IF;
    END;

    -- Обновление статуса бронирования
    UPDATE RESERVATIONS SET STATUS = 'Отменено' WHERE ID_RESERV = p_id_reserv;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Бронирование успешно отменено.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Данные не найдены.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Недопустимые значения параметров.');
        ROLLBACK;
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Дублирующаяся запись.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
        ROLLBACK;
END;






--для гостя
--Получение списка всех отелей
CREATE OR REPLACE PROCEDURE GET_ALL_HOTELS
AS
BEGIN
    FOR r IN (SELECT ID_HOT, NAME_HOT, CITY, ADRESS, RATING 
              FROM HOTELS) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hotel ID: ' || r.ID_HOT);
        DBMS_OUTPUT.PUT_LINE('Hotel Name: ' || r.NAME_HOT);
        DBMS_OUTPUT.PUT_LINE('City: ' || r.CITY);
        DBMS_OUTPUT.PUT_LINE('Address: ' || r.ADRESS);
        DBMS_OUTPUT.PUT_LINE('Rating: ' || r.RATING);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;




--Получение списка всех номеров в конкретном отеле
CREATE OR REPLACE PROCEDURE GET_ROOMS_IN_HOTEL(
    p_id_hot IN NUMBER
) IS
    CURSOR c_available_rooms IS
        SELECT num_of_room, price
        FROM rooms
        WHERE  id_hot = p_id_hot;
    v_num_of_room rooms.num_of_room%TYPE;
    v_price rooms.price%TYPE;
BEGIN
    OPEN c_available_rooms;
    LOOP
        FETCH c_available_rooms INTO v_num_of_room, v_price;
        EXIT WHEN c_available_rooms%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Комната: ' || v_num_of_room || ' свободна ' );
    END LOOP;
    CLOSE c_available_rooms;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--вывод информации о свободных номерах в конкретном отеле
CREATE OR REPLACE PROCEDURE GET_AVAILABLE_ROOMS_IN_HOTEL(
    p_id_hot IN NUMBER
) IS
    CURSOR c_available_rooms IS
        SELECT num_of_room, price
        FROM rooms
        WHERE availability = 'Свободен'
        AND id_hot = p_id_hot;
    v_num_of_room rooms.num_of_room%TYPE;
    v_price rooms.price%TYPE;
BEGIN
    OPEN c_available_rooms;
    LOOP
        FETCH c_available_rooms INTO v_num_of_room, v_price;
        EXIT WHEN c_available_rooms%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Комната: ' || v_num_of_room || ' свободна, Цена: ' || v_price ||' byn');
    END LOOP;
    CLOSE c_available_rooms;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--Процедура для вывода рейтинга определенного отеля
CREATE OR REPLACE PROCEDURE get_hotel_rating_in_city(
    p_name_hot IN VARCHAR2,
    p_city IN VARCHAR2
) AS
    CURSOR c_hotel_ratings IS
        SELECT rating
        FROM hotels
        WHERE name_hot = p_name_hot
        AND city = p_city;
    v_rating hotels.rating%TYPE;
BEGIN
    OPEN c_hotel_ratings;
    LOOP
        FETCH c_hotel_ratings INTO v_rating;
        EXIT WHEN c_hotel_ratings%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Рейтинг отеля: ' || p_name_hot || ' in ' || p_city || ': ' || v_rating);
    END LOOP;
    CLOSE c_hotel_ratings;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Hotel ' || p_name_hot || ' in ' || p_city || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--Процедура для вывода типа комнаты
CREATE OR REPLACE PROCEDURE get_room_type(
    p_num_of_room IN NUMBER,
    p_id_hot IN NUMBER
) AS
    v_type rooms.type%TYPE;
BEGIN
    SELECT type
    INTO v_type
    FROM rooms
    WHERE num_of_room = p_num_of_room
    AND id_hot = p_id_hot;
    
    DBMS_OUTPUT.PUT_LINE('Тип комнаты ' || p_num_of_room || ' в отеле ' || p_id_hot || ': ' || v_type);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Комната ' || p_num_of_room || ' в отеле ' || p_id_hot || 'не найдена.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Комнаты ' || p_num_of_room || ' в отеле ' || p_id_hot || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;



--Процедура для вывода цены комнаты
CREATE OR REPLACE PROCEDURE get_room_price(
    p_num_of_room IN NUMBER,
    p_id_hot IN NUMBER
) AS
    v_price rooms.price%TYPE;
BEGIN
    SELECT price
    INTO v_price
    FROM rooms
    WHERE num_of_room = p_num_of_room
    AND id_hot = p_id_hot;
    
    DBMS_OUTPUT.PUT_LINE('Стоимость комнаты ' || p_num_of_room || ' в отеле ' || p_id_hot || ': ' || v_price || ' byn.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Комната' || p_num_of_room || ' в отеле ' || p_id_hot || ' не найдена.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Комнаты ' || p_num_of_room || 'в отеле ' || p_id_hot || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--Процедура для вывода доступности комнаты
CREATE OR REPLACE PROCEDURE get_room_availability(
    p_num_of_room IN NUMBER,
    p_id_hot IN NUMBER
) AS
    v_availability rooms.availability%TYPE;
BEGIN
    SELECT availability
    INTO v_availability
    FROM rooms
    WHERE num_of_room = p_num_of_room
    AND id_hot = p_id_hot;
    
    DBMS_OUTPUT.PUT_LINE('Доступность комнаты ' || p_num_of_room || ' в отеле ' || p_id_hot || ': ' || v_availability);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Команата ' || p_num_of_room || ' в отеле ' || p_id_hot || ' не найдена.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Комнаты ' || p_num_of_room || 'в отеле ' || p_id_hot || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;



