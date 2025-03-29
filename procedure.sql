------procedures----



-----admin--------------------------------
--��������� ��� ��������� �������� � �� �������������

 CREATE OR REPLACE PROCEDURE VIEW_PAYMENTS
AS
BEGIN
    FOR p IN (SELECT ID_PAY, ID_RESERV, SUM_PAY, STATUS FROM PAYMENTS)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID �������: ' || p.ID_PAY);
        DBMS_OUTPUT.PUT_LINE('ID ������������: ' || p.ID_RESERV);
        DBMS_OUTPUT.PUT_LINE('����� �������: ' || p.SUM_PAY);
        DBMS_OUTPUT.PUT_LINE('������: ' || p.STATUS);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;


--��������� ��� ��������� ���������� � ������
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

--��������� ������ ���� �������������
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


--�������� �������
CREATE OR REPLACE PROCEDURE delete_room (
    p_id_num IN NUMBER
) IS
BEGIN
    -- ������� ����� �� ������� ROOMS
    DELETE FROM rooms
    WHERE id_num = p_id_num;

    -- ���������, ���� �� ������� �����-���� ������
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Room ' || p_id_num || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Room ' || p_id_num || ' successfully deleted.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--��������� ��� �������� ������������ �� ������
CREATE OR REPLACE PROCEDURE delete_user_by_login (
    p_login IN VARCHAR2
) IS
BEGIN
    -- �������� ������������ �� ������� CUSTOMERS
    DELETE FROM customers
    WHERE login = p_login;

    -- �������� ������������ �� ������� ROLE
    DELETE FROM role
    WHERE login = p_login;

    -- ��������, ���� �� ������� ���� �� ���� ������ �� ������� CUSTOMERS
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' successfully deleted.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--���������� ������ �����
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
    DBMS_OUTPUT.PUT_LINE('����� ������� ��������.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('������: ����� � ��������� ID_HOT ��� ����������.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;




--��������� ��� ��������� ������ ������������
CREATE OR REPLACE PROCEDURE update_user_by_login (
    p_login IN VARCHAR2,
    p_name IN VARCHAR2,
    p_surname IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone_num IN VARCHAR2
) as
is_valid boolean;
BEGIN
-- ��������� ���������� email
    is_valid := is_valid_email(p_email);
    IF NOT is_valid THEN
        DBMS_OUTPUT.PUT_LINE('Invalid email format: ' || p_email);
        RETURN;
    END IF;
    -- ���������� ������ ������������ � ������� CUSTOMERS
    UPDATE customers
    SET
        name = p_name,
        surname = p_surname,
        email = p_email,
        phone_num = p_phone_num
    WHERE login = p_login;

    -- ��������, ���� �� ��������� ���� �� ���� ������
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' not found.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User with login ' || p_login || ' successfully updated.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--�������� ����� �� �������
CREATE OR REPLACE PROCEDURE DELETE_HOTEL(
    p_id_hot IN NUMBER
)
AS
    e_hotel_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_hotel_not_found, -20001);
BEGIN
    -- �������� ������� �����
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM HOTELS WHERE ID_HOT = p_id_hot;
        IF v_count = 0 THEN
            RAISE e_hotel_not_found;
        END IF;
    END;

    -- �������� ������, ��������� � ������
    DELETE FROM ROOMS WHERE ID_HOT = p_id_hot;
    
    -- �������� ������ �����
    DELETE FROM HOTELS WHERE ID_HOT = p_id_hot;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('����� � ��������� � ��� ������� ������� �������.');
    
EXCEPTION
    WHEN e_hotel_not_found THEN
        DBMS_OUTPUT.PUT_LINE('������: ����� � ID ' || p_id_hot || ' �� ����������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;


--���������� ������ ������ � �����
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
    -- �������� ������� ����� � �������� ID_HOT
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM HOTELS WHERE ID_HOT = p_id_hot;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ����� � ��������� ID_HOT �� ����������.');
        END IF;
    END;

    -- ������� ����� �������
    INSERT INTO ROOMS (ID_NUM, ID_HOT, TYPE, PRICE, AVAILABILITY, NUM_OF_ROOM)
    VALUES (p_id_num, p_id_hot, p_type, p_price, p_availability, p_num_of_room);

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('������� ������� ���������.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('������: ������� � ����� ID_NUM ��� ����������.');
        ROLLBACK;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ����� � ��������� ID_HOT �� ����������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;


--�������� ������ �� �����
CREATE OR REPLACE PROCEDURE DELETE_ROOM(
    p_id_num IN NUMBER
)
AS
BEGIN
    -- �������� ������� ������� � �������� ID_NUM
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM ROOMS WHERE ID_NUM = p_id_num;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ������� � ��������� ID_NUM �� ����������.');
        END IF;
 END;
  -- �������� �������
    DELETE FROM ROOMS WHERE ID_NUM = p_id_num;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('������� ������� �������.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ������� � ��������� ID_NUM �� �������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;



--��������� ��� ���������� �������� �����
CREATE OR REPLACE PROCEDURE UPDATE_HOTEL_RATING(
    p_id_hot IN NUMBER,
    p_new_rating IN VARCHAR2
)
AS
BEGIN
    -- ���������� �������� �����
    UPDATE HOTELS SET RATING = p_new_rating WHERE ID_HOT = p_id_hot;
    
    -- �������� ���������� ����������� �����
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '������: ����� � ��������� ID_HOT �� ������.');
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('������� ����� ������� ��������.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ����� � ��������� ID_HOT �� ������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;

--��������� ���������� �� ������������� � �������
CREATE OR REPLACE PROCEDURE  GET_RESERVATION_STATISTICS
AS
    total_reservations NUMBER;
    confirmed_reservations NUMBER;
    pending_reservations NUMBER;
    cancelled_reservations NUMBER;
BEGIN
    SELECT COUNT(*),
           SUM(CASE WHEN STATUS = '������������' THEN 1 ELSE 0 END),
           SUM(CASE WHEN STATUS = '������� �������������' THEN 1 ELSE 0 END),
           SUM(CASE WHEN STATUS = '��������' THEN 1 ELSE 0 END)
    INTO total_reservations, confirmed_reservations, pending_reservations, cancelled_reservations
    FROM RESERVATIONS;

    DBMS_OUTPUT.PUT_LINE('���������� ������������:');
    DBMS_OUTPUT.PUT_LINE('����� ������������: ' || total_reservations);
    DBMS_OUTPUT.PUT_LINE('�������������� ������������: ' || confirmed_reservations);
    DBMS_OUTPUT.PUT_LINE('������������, ��������� �������������: ' || pending_reservations);
    DBMS_OUTPUT.PUT_LINE('���������� ������������: ' || cancelled_reservations);
END;



--��� ������������---------------------------------------------------------


-- ��������� ��� ������������ ������ � �����
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
    -- �������� ������������� �������
    BEGIN
        SELECT 1 INTO v_dummy FROM CUSTOMERS WHERE ID_CUSTOM = CUSTOMER_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ������ � ��������� ID_CUSTOM �� ������.');
    END;

    -- �������� ������������� �����
    BEGIN
        SELECT 1 INTO v_dummy FROM HOTELS WHERE ID_HOT = HOTEL_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, '������: ����� � ��������� ID_HOT �� ������.');
    END;

    -- �������� ������������� ������
    BEGIN
        SELECT 1 INTO v_dummy FROM ROOMS WHERE ID_NUM = ROOM_ID AND ID_HOT = HOTEL_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, '������: ����� � ��������� ID_NUM �� ������ � ������ �����.');
    END;

    -- ������� ������ � ������������
    INSERT INTO RESERVATIONS (ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D)
    VALUES (SEQ_RESERVATION.NEXTVAL, CUSTOMER_ID, ROOM_ID, 'Pending', START_DATE, END_DATE);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('������������ ������� �������.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ������ �� �������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������� ������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;







-- ��������� ��� ��������� ����� �� ����������� ������������
CREATE OR REPLACE PROCEDURE GET_SUM_PAY_BY_RESERVATION(
    p_id_reserv IN NUMBER
)
AS
    v_sum_pay NUMBER(10, 2);
BEGIN

    -- ��������� ����� �������� ��� ������� ID_RESERV
    SELECT SUM(SUM_PAY)
    INTO v_sum_pay
    FROM PAYMENTS
    WHERE ID_RESERV = p_id_reserv;

    -- ��������, ����� ����� �� ���� NULL
    IF v_sum_pay IS NULL THEN
        v_sum_pay := 0;
    END IF;

    -- ����� �����
    DBMS_OUTPUT.PUT_LINE('����� �������� ��� ������������: ' || v_sum_pay);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������������ � ID ' || p_id_reserv || ' �� �������.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('������: ' || SQLERRM);
END;


--���������� ������ ����� � �������
CREATE OR REPLACE PROCEDURE ADD_HOTEL(
    p_id_hot IN NUMBER,
    p_name_hot IN VARCHAR2,
    p_city IN VARCHAR2,
    p_address IN VARCHAR2,
    p_rating IN VARCHAR2
)
AS
BEGIN
    -- ������� ������ �� �����
    INSERT INTO HOTELS (ID_HOT, NAME_HOT, CITY, ADRESS, RATING)
    VALUES (p_id_hot, p_name_hot, p_city, p_address, p_rating);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('����� ������� ��������.');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('������: ����� � ��������� ID_HOT ��� ����������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;


-- ��������� ��� ��������� ���������� � ����������� �������������
CREATE OR REPLACE PROCEDURE GET_MY_RESERVATIONS(
    p_id_custom IN NUMBER
)
AS
BEGIN
    -- �������� ������������� �������
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM CUSTOMERS WHERE ID_CUSTOM = p_id_custom;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ������ � ��������� ID_CUSTOM �� ������.');
        END IF;
    END;

    -- ��������� ���������� � �������������
    FOR r IN (SELECT ID_RESERV, ID_CUSTOM, ID_NUM, STATUS, DATE_A, DATE_D 
              FROM RESERVATIONS
              WHERE ID_CUSTOM = p_id_custom) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('�������: ' || r.ID_NUM);
        DBMS_OUTPUT.PUT_LINE('������: ' || r.STATUS);
        DBMS_OUTPUT.PUT_LINE('���� ������ : ' || TO_CHAR(r.DATE_A, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('���� �������: ' || TO_CHAR(r.DATE_D, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ������ �� �������.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
END;



CREATE OR REPLACE PROCEDURE CONFIRM_PAYMENT(
    p_id_pay IN NUMBER
)
AS
BEGIN
    -- �������� ������������� �������
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM PAYMENTS WHERE ID_PAY = p_id_pay;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ������ � ��������� ID_PAY �� ������.');
        END IF;
    END;

    -- ���������� ������� �������
    UPDATE PAYMENTS SET STATUS = '��������' WHERE ID_PAY = p_id_pay;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('������ ������� �����������.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ������ �� �������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;


--���������� �������������� 
create or replace 
PROCEDURE VIEW_PAYMENTS
AS
BEGIN
    FOR p IN (SELECT ID_PAY, ID_RESERV, SUM_PAY, STATUS FROM PAYMENTS)
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID �������: ' || p.ID_PAY);
        DBMS_OUTPUT.PUT_LINE('ID ������������: ' || p.ID_RESERV);
        DBMS_OUTPUT.PUT_LINE('����� �������: ' || p.SUM_PAY);
        DBMS_OUTPUT.PUT_LINE('������: ' || p.STATUS);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;

--�������������
CREATE OR REPLACE PROCEDURE CONFIRM_RESERVATION(
    p_id_reserv IN NUMBER
)
AS
BEGIN
    -- �������� ������������� ������������
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RESERVATIONS WHERE ID_RESERV = p_id_reserv;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ������������ � ��������� ID_RESERV �� �������.');
        END IF;
    END;

    -- ���������� ������� ������������
    UPDATE RESERVATIONS SET STATUS = '������������' WHERE ID_RESERV = p_id_reserv;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('������������ ������� ������������.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ������ �� �������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������� ������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;


--������
CREATE OR REPLACE PROCEDURE CANCEL_RESERVATION(
    p_id_reserv IN NUMBER
)
AS
BEGIN
    -- �������� ������������� ������������
    DECLARE
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM RESERVATIONS WHERE ID_RESERV = p_id_reserv;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, '������: ������������ � ��������� ID_RESERV �� �������.');
        END IF;
    END;

    -- ���������� ������� ������������
    UPDATE RESERVATIONS SET STATUS = '��������' WHERE ID_RESERV = p_id_reserv;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('������������ ������� ��������.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������: ������ �� �������.');
        ROLLBACK;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������ �������� ����������.');
        ROLLBACK;
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('������: ������������� ������.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
        ROLLBACK;
END;






--��� �����
--��������� ������ ���� ������
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




--��������� ������ ���� ������� � ���������� �����
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
        DBMS_OUTPUT.PUT_LINE('�������: ' || v_num_of_room || ' �������� ' );
    END LOOP;
    CLOSE c_available_rooms;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--����� ���������� � ��������� ������� � ���������� �����
CREATE OR REPLACE PROCEDURE GET_AVAILABLE_ROOMS_IN_HOTEL(
    p_id_hot IN NUMBER
) IS
    CURSOR c_available_rooms IS
        SELECT num_of_room, price
        FROM rooms
        WHERE availability = '��������'
        AND id_hot = p_id_hot;
    v_num_of_room rooms.num_of_room%TYPE;
    v_price rooms.price%TYPE;
BEGIN
    OPEN c_available_rooms;
    LOOP
        FETCH c_available_rooms INTO v_num_of_room, v_price;
        EXIT WHEN c_available_rooms%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('�������: ' || v_num_of_room || ' ��������, ����: ' || v_price ||' byn');
    END LOOP;
    CLOSE c_available_rooms;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--��������� ��� ������ �������� ������������� �����
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
        DBMS_OUTPUT.PUT_LINE('������� �����: ' || p_name_hot || ' in ' || p_city || ': ' || v_rating);
    END LOOP;
    CLOSE c_hotel_ratings;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Hotel ' || p_name_hot || ' in ' || p_city || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


--��������� ��� ������ ���� �������
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
    
    DBMS_OUTPUT.PUT_LINE('��� ������� ' || p_num_of_room || ' � ����� ' || p_id_hot || ': ' || v_type);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('������� ' || p_num_of_room || ' � ����� ' || p_id_hot || '�� �������.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('������� ' || p_num_of_room || ' � ����� ' || p_id_hot || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;



--��������� ��� ������ ���� �������
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
    
    DBMS_OUTPUT.PUT_LINE('��������� ������� ' || p_num_of_room || ' � ����� ' || p_id_hot || ': ' || v_price || ' byn.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�������' || p_num_of_room || ' � ����� ' || p_id_hot || ' �� �������.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('������� ' || p_num_of_room || '� ����� ' || p_id_hot || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

--��������� ��� ������ ����������� �������
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
    
    DBMS_OUTPUT.PUT_LINE('����������� ������� ' || p_num_of_room || ' � ����� ' || p_id_hot || ': ' || v_availability);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�������� ' || p_num_of_room || ' � ����� ' || p_id_hot || ' �� �������.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('������� ' || p_num_of_room || '� ����� ' || p_id_hot || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;



