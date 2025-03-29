-- Включение вывода времени выполнения
SET SERVEROUTPUT ON;

-- Запуск запроса без индекса
DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;
    FOR rec IN (SELECT * FROM PAYMENTS WHERE ID_RESERV = 50000) LOOP
        NULL; -- здесь выполняется запрос
    END LOOP;
    end_time := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Time without index: ' || (end_time - start_time) || ' hsecs');
END;


-- Создание индекса
CREATE INDEX idx_payments_id_reserv ON PAYMENTS(ID_RESERV);

-- Запуск запроса с индексом
DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;
    FOR rec IN (SELECT * FROM PAYMENTS WHERE ID_RESERV = 50000) LOOP
        NULL; -- здесь выполняется запрос
    END LOOP;
    end_time := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Time with index: ' || (end_time - start_time) || ' hsecs');
END;
