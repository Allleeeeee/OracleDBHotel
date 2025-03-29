--функци€, котора€ провер€ет
--на валидносьт email
CREATE OR REPLACE FUNCTION is_valid_email(email IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
    -- ѕровер€ем, соответствует ли email заданному формату
    IF REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

--ѕолучение списка всех гостиниц в указанном городе
CREATE OR REPLACE FUNCTION get_hotels_in_city(city_name IN VARCHAR2)
RETURN SYS_REFCURSOR
AS
    hotel_cursor SYS_REFCURSOR;
BEGIN
    OPEN hotel_cursor FOR
        SELECT *
        FROM hotels
        WHERE city = city_name;
    
    RETURN hotel_cursor;
END;

--ѕолучение списка бронирований в указанной гостинице 
--за определенный период времени
CREATE OR REPLACE FUNCTION get_reservations_in_hotel(hotel_id IN NUMBER, start_date IN DATE, end_date IN DATE)
RETURN SYS_REFCURSOR
AS
    reservation_cursor SYS_REFCURSOR;
BEGIN
    OPEN reservation_cursor FOR
        SELECT *
        FROM reservations
        WHERE id_num IN (SELECT id_num FROM rooms WHERE id_hot = hotel_id)
          AND DATE_A BETWEEN start_date AND end_date;
    
    RETURN reservation_cursor;
END;

--