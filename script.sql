--����� � ����������
--��������� ������ ���� ������
exec GET_ALL_HOTELS();
--����� �������� ������������� �����:
EXEC get_hotel_rating_in_city('������ �����', '������');
--��������� ������ ���� ������� � ���������� �����
EXEC GET_ROOMS_IN_HOTEL(2);
--����� ���������� � ��������� ������� � ���������� �����
EXEC GET_AVAILABLE_ROOMS_IN_HOTEL(2);
--����� ����������� �������:
EXEC get_room_availability(102, 2);
--����� ���� �������:
EXEC get_room_type(201, 2);
--����� ���� �������:
EXEC get_room_price(201, 2);


--user
--������������ ������ � �����:
EXEC BOOK_ROOM(1, 2, 10, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-10', 'YYYY-MM-DD'));

--��������� ����� �� ����������� ������������:
exec GET_SUM_PAY_BY_RESERVATION(2);


--������ ������������ ������������:
--��
exec GET_MY_RESERVATIONS(76207);
--������
EXEC CANCEL_RESERVATION(1);
--�����
exec GET_MY_RESERVATIONS(76207);


--










--admin
--����� ���������� � ������������
exec GET_ALL_USERS();

--��������� ������ ���� ������
exec GET_ALL_HOTELS();
-- ���������� ������ ����� � �������
EXEC ADD_HOTEL(100010, '�����', '�����', '��. ��������, 12', '5 �����');

--����� ���� � ��������
exec  VIEW_PAYMENTS();

--������������� �������:
EXEC CONFIRM_PAYMENT(11);

--��������� ���������� � ������:
EXEC update_room_info(1, 2, '�����������', 100, '��������', 201);

--�������� �������
EXEC delete_room(2);
--���������� ������ ������ � �����:
EXEC ADD_ROOM(100010, 5, '����', 500, '��������', 501);

--�������� ������������ �� ������:
EXEC delete_user_by_login('login_10');

--��������� ������ ������������:
--� ��������� �����
EXEC update_user_by_login('login_10', 'Joh', 'Doe', 'john.doe@example.com', '+1234567890');

--�������� ����� �� �������
EXEC DELETE_HOTEL(10);

--���������� �������� �����
EXEC UPDATE_HOTEL_RATING(2, '4 ������');

--���������� ������������
exec GET_RESERVATION_STATISTICS;