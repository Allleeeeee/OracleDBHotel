CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR AS 'D:\KURSORACLE\ARHIEVE';
GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO PUBLIC;


CREATE OR REPLACE PROCEDURE export_hotels_to_json
(
  p_file_name IN VARCHAR2
)
AS
  l_file      UTL_FILE.FILE_TYPE;
  l_buffer    VARCHAR2(32767);
  l_first_row BOOLEAN := TRUE;
  CURSOR c_hotels IS
    SELECT id_hot, name_hot, city, adress, rating
    FROM hotels;
BEGIN
  l_file := UTL_FILE.FOPEN('DATA_PUMP_DIR', p_file_name, 'w');

  UTL_FILE.PUT_LINE(l_file, '[');

  FOR rec IN c_hotels
  LOOP
    IF l_first_row THEN
      l_first_row := FALSE;
    ELSE
      UTL_FILE.PUT_LINE(l_file, ',');
    END IF;
    
    l_buffer := '  {' ||
                '"id_hot": ' || rec.id_hot || ',' ||
                '"name_hot": "' || rec.name_hot || '",' ||
                '"city": "' || rec.city || '",' ||
                '"adress": "' || rec.adress || '",' ||
                '"rating": "' || rec.rating || '"' ||
                '}';
    UTL_FILE.PUT_LINE(l_file, l_buffer);
  END LOOP;

  UTL_FILE.PUT_LINE(l_file, ']');
  UTL_FILE.FCLOSE(l_file);
EXCEPTION
  WHEN OTHERS THEN
    IF UTL_FILE.IS_OPEN(l_file) THEN
      UTL_FILE.FCLOSE(l_file);
    END IF;
    RAISE;
END;




BEGIN
  export_hotels_to_json('hotels.json');
END;









CREATE OR REPLACE PROCEDURE import_hotels_from_json(
    p_file_name IN VARCHAR2
)
AS
    l_file       UTL_FILE.FILE_TYPE;
    l_buffer     VARCHAR2(32767);
    l_id_hot     NUMBER := 1; -- �������� � 1
    l_name_hot   VARCHAR2(50);
    l_city       VARCHAR2(50);
    l_adress     VARCHAR2(50);
    l_rating     VARCHAR2(50);
BEGIN
    -- �������� ����� ��� ������
    l_file := UTL_FILE.FOPEN('DATA_PUMP_DIR', p_file_name, 'r');
    
    -- ������ ����������� ����� ���������
    LOOP
        -- ������ ������ �� �����
        UTL_FILE.GET_LINE(l_file, l_buffer);
        
        -- ����� �� ����� ��� ���������� ����� �����
        EXIT WHEN l_buffer IS NULL;
        
        -- ���������� ������ �� JSON ������
        l_name_hot := REGEXP_SUBSTR(l_buffer, '"name_hot": "([^"]+)"', 1, 1, NULL, 1);
        l_city := REGEXP_SUBSTR(l_buffer, '"city": "([^"]+)"', 1, 1, NULL, 1);
        l_adress := REGEXP_SUBSTR(l_buffer, '"adress": "([^"]+)"', 1, 1, NULL, 1);
        l_rating := REGEXP_SUBSTR(l_buffer, '"rating": "([^"]+)"', 1, 1, NULL, 1);
        
        -- ������� ������ � �������
        INSERT INTO hotel (ID_HOT, NAME_HOT, CITY, ADDRESS, RATING)
        VALUES (l_id_hot, l_name_hot, l_city, l_adress, l_rating);
        
        -- ���������� ID_HOT ��� ��������� ������
        l_id_hot := l_id_hot + 1;
    END LOOP;
    
    -- �������� �����
    UTL_FILE.FCLOSE(l_file);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(l_file) THEN
            UTL_FILE.FCLOSE(l_file);
        END IF;
        RAISE;
END;


import_hotels_from_json('hotel.json');

ALTER SESSION SET "_ORACLE_SCRIPT"=true;