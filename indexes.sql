-- ��������� ������ ������� ����������
SET SERVEROUTPUT ON;

-- ������ ������� ��� �������
DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;
    FOR rec IN (SELECT * FROM PAYMENTS WHERE ID_RESERV = 50000) LOOP
        NULL; -- ����� ����������� ������
    END LOOP;
    end_time := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Time without index: ' || (end_time - start_time) || ' hsecs');
END;


-- �������� �������
CREATE INDEX idx_payments_id_reserv ON PAYMENTS(ID_RESERV);

-- ������ ������� � ��������
DECLARE
    start_time NUMBER;
    end_time NUMBER;
BEGIN
    start_time := DBMS_UTILITY.GET_TIME;
    FOR rec IN (SELECT * FROM PAYMENTS WHERE ID_RESERV = 50000) LOOP
        NULL; -- ����� ����������� ������
    END LOOP;
    end_time := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Time with index: ' || (end_time - start_time) || ' hsecs');
END;
