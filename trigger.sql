--Триггер для автоматического изменения 
--статуса брони номера при оплате
CREATE OR REPLACE TRIGGER payment_trigger
AFTER UPDATE OF status ON payments
FOR EACH ROW
BEGIN
    IF :OLD.status <> :NEW.status THEN
        IF :NEW.status = 'Оплачено' THEN
            UPDATE reservations
            SET status = 'Подтверждено'
            WHERE id_reserv = :NEW.id_reserv;
        ELSIF :NEW.status = 'Не оплачено' THEN
            UPDATE reservations
            SET status = 'Ожидает подтверждения'
            WHERE id_reserv = :NEW.id_reserv;
        END IF;
    END IF;
END;


UPDATE payments
SET status = 'Не оплачено'
WHERE id_reserv = 1; 

--Триггер для автоматического изменения 
--доступности номера при создании брони

CREATE OR REPLACE TRIGGER reservation_trigger
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    UPDATE rooms
    SET availability = 'Не доступен'
    WHERE id_num = :new.id_num;
END;


INSERT INTO reservations (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
VALUES (5, 1, 3, 'Ожидает подтверждения', TO_DATE('2024-08-05', 'YYYY-MM-DD'),
TO_DATE('2024-08-10', 'YYYY-MM-DD'))


--Триггер для проверки доступности
--номера при создании новой брони
CREATE OR REPLACE TRIGGER availability_trigger
BEFORE INSERT ON reservations
FOR EACH ROW
DECLARE
    room_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO room_count
    FROM rooms
    WHERE id_num = :NEW.id_num
    AND availability = 'Доступен';
    
    IF room_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Номер занят. Пожалуйста, выберите другой');
    END IF;
END;

INSERT INTO reservations (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
VALUES (8, 1, 1, 'Ожидает подтверждения', TO_DATE('2024-08-05', 'YYYY-MM-DD'),
TO_DATE('2024-08-10', 'YYYY-MM-DD'))
