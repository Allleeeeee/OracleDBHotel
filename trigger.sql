--������� ��� ��������������� ��������� 
--������� ����� ������ ��� ������
CREATE OR REPLACE TRIGGER payment_trigger
AFTER UPDATE OF status ON payments
FOR EACH ROW
BEGIN
    IF :OLD.status <> :NEW.status THEN
        IF :NEW.status = '��������' THEN
            UPDATE reservations
            SET status = '������������'
            WHERE id_reserv = :NEW.id_reserv;
        ELSIF :NEW.status = '�� ��������' THEN
            UPDATE reservations
            SET status = '������� �������������'
            WHERE id_reserv = :NEW.id_reserv;
        END IF;
    END IF;
END;


UPDATE payments
SET status = '�� ��������'
WHERE id_reserv = 1; 

--������� ��� ��������������� ��������� 
--����������� ������ ��� �������� �����

CREATE OR REPLACE TRIGGER reservation_trigger
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    UPDATE rooms
    SET availability = '�� ��������'
    WHERE id_num = :new.id_num;
END;


INSERT INTO reservations (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
VALUES (5, 1, 3, '������� �������������', TO_DATE('2024-08-05', 'YYYY-MM-DD'),
TO_DATE('2024-08-10', 'YYYY-MM-DD'))


--������� ��� �������� �����������
--������ ��� �������� ����� �����
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
    AND availability = '��������';
    
    IF room_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '����� �����. ����������, �������� ������');
    END IF;
END;

INSERT INTO reservations (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
VALUES (8, 1, 1, '������� �������������', TO_DATE('2024-08-05', 'YYYY-MM-DD'),
TO_DATE('2024-08-10', 'YYYY-MM-DD'))
