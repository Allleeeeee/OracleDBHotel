--���������� HOTELS
CREATE OR REPLACE FUNCTION populate_hotels_table
RETURN BOOLEAN
AS
    TYPE t_name_arr IS TABLE OF VARCHAR2(50);
    TYPE t_city_arr IS TABLE OF VARCHAR2(50);
    TYPE t_address_arr IS TABLE OF VARCHAR2(50);
    TYPE t_rating_arr IS TABLE OF VARCHAR2(50);

    names t_name_arr := t_name_arr('������ �������� ����', '������ �����', '����������� ������', '������ ������� �����', '����������� ��� ���',
                                   '���� ������� ����', '����� ��������� ����', '������ �������', '��������� �����', '����� ��� �� ������');
    cities t_city_arr := t_city_arr('��������', '������', '������', '�����', '����', '�������', '�����', '�����', '������');
    addresses t_address_arr := t_address_arr('��. �������, 123', '��. ��������, 456', '��. ������������, 789', '��. �������� ���, 123', '��. ���� ����, 456',
                                             '��. ������ �������, 789', '��. ��������, 123', '��. ���������� ����, 456', '��. ���������� �������, 789',
                                             '��. �������� ������, 123');
    ratings t_rating_arr := t_rating_arr('4 ������', '3 ������', '5 �����');

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



--������ �������
BEGIN
    IF populate_hotels_table() THEN
        DBMS_OUTPUT.PUT_LINE('������� HOTELS ������� ���������.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ ���������� ������� HOTELS.');
    END IF;
END;


--���������� ROOMS
CREATE OR REPLACE FUNCTION populate_rooms_table
RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO ROOMS (ID_NUM, ID_HOT, TYPE, PRICE, AVAILABILITY, NUM_OF_ROOM)
        VALUES (i,
                ROUND(DBMS_RANDOM.VALUE(1, 100000)), 
                CASE ROUND(DBMS_RANDOM.VALUE(1, 6)) 
                    WHEN 1 THEN '�����������'
                    WHEN 2 THEN '����'
                    WHEN 3 THEN '����������� ����'
                     WHEN 4 THEN '�����������'
                    WHEN 5 THEN '����������'
                    WHEN 6 THEN '������������� ����'
                END,
                ROUND(DBMS_RANDOM.VALUE(100, 1000)), 
                CASE ROUND(DBMS_RANDOM.VALUE(0, 1)) 
                    WHEN 0 THEN '��������'
                    WHEN 1 THEN '�� ��������'
                END,
                ROUND(DBMS_RANDOM.VALUE(1, 500))); 
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;


--������ �������
BEGIN
 IF populate_rooms_table() THEN
        DBMS_OUTPUT.PUT_LINE('������� ROOMS ������� ���������.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ ���������� ������� ROOMS.');
    END IF;
END;


--���������� CUSTOMERS
CREATE OR REPLACE FUNCTION populate_customers_table
RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO CUSTOMERS (ID_CUSTOM, NAME, SURNAME, EMAIL, PHONE_NUM, LOGIN)
        VALUES (i,
               CASE ROUND(DBMS_RANDOM.VALUE(1, 15))
                    WHEN 1 THEN '����'
                    WHEN 2 THEN '�����'
                    WHEN 3 THEN '���������'
                    WHEN 4 THEN '�����'
                    WHEN 5 THEN '�������'
                    WHEN 6 THEN '�����'
                    WHEN 7 THEN '��������'
                    WHEN 8 THEN '��������'
                    WHEN 9 THEN '���'
                    WHEN 10 THEN '�����'
                    WHEN 11 THEN '������'
                    WHEN 12 THEN '������'
                    WHEN 13 THEN '�������'
                    WHEN 14 THEN '�����'
                    WHEN 15 THEN '������'
                END,
                CASE ROUND(DBMS_RANDOM.VALUE(1, 12))
                    WHEN 1 THEN '������'
                    WHEN 2 THEN '�����'
                    WHEN 3 THEN '���������'
                    WHEN 4 THEN '��������'
                    WHEN 5 THEN '��������'
                    WHEN 6 THEN '�����'
                     WHEN 7 THEN '��������'
                    WHEN 8 THEN '������'
                    WHEN 9 THEN '�����'
                    WHEN 10 THEN '��������'
                    WHEN 11 THEN '������'
                    WHEN 12 THEN '�����'
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

--������ �������
BEGIN
 IF populate_customers_table() THEN
        DBMS_OUTPUT.PUT_LINE('������� CUSTOMERS ������� ���������.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ ���������� ������� CUSTOMERS.');
    END IF;
END;


--���������� RESERVATIONS
CREATE OR REPLACE FUNCTION populate_reservations_table RETURN BOOLEAN IS
BEGIN
    FOR i IN 1..100000 LOOP
        INSERT INTO RESERVATIONS (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
        VALUES (
            i,
            ROUND(DBMS_RANDOM.VALUE(1, 100000)), 
            ROUND(DBMS_RANDOM.VALUE(1, 100000)), 
            CASE ROUND(DBMS_RANDOM.VALUE(1, 2))
                WHEN 1 THEN '������������'
                WHEN 2 THEN '������� �������������'
            END,
            TO_DATE('2024-05-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 365)), -- ��������� ���� � �������� ����
            TO_DATE('2024-12-31', 'YYYY-MM-DD') - TRUNC(DBMS_RANDOM.VALUE(0, 365)) 
        );
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
        RETURN FALSE;
END;



--������ �������
BEGIN
 IF populate_reservations_table() THEN
        DBMS_OUTPUT.PUT_LINE('������� RESERVATIONS ������� ���������.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ ���������� ������� RESERVATIONS.');
    END IF;
END;


--���������� payments
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
                    WHEN 1 THEN '��������'
                    WHEN 2 THEN '������� ������'
                END
            );
        END;
    END LOOP;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
        RETURN FALSE;
END;




--������ �������
BEGIN
 IF populate_payments_table() THEN
        DBMS_OUTPUT.PUT_LINE('������� payments ������� ���������.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ ���������� ������� payments.');
    END IF;
END;


--���������� roles
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
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
        RETURN FALSE;
END;


----������ �������
BEGIN
 IF populate_role_table() THEN
        DBMS_OUTPUT.PUT_LINE('������� role ������� ���������.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('������ ���������� ������� role.');
    END IF;
END;

