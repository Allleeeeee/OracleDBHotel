--гость в приложение
--ѕолучение списка всех отелей
exec GET_ALL_HOTELS();
--вывод рейтинга определенного отел€:
EXEC get_hotel_rating_in_city('Ћесной «амок', 'ƒенвер');
--ѕолучение списка всех номеров в конкретном отеле
EXEC GET_ROOMS_IN_HOTEL(2);
--вывод информации о свободных номерах в конкретном отеле
EXEC GET_AVAILABLE_ROOMS_IN_HOTEL(2);
--вывод доступности комнаты:
EXEC get_room_availability(102, 2);
--вывод типа комнаты:
EXEC get_room_type(201, 2);
--вывод цены комнаты:
EXEC get_room_price(201, 2);


--user
--бронирование номера в отеле:
EXEC BOOK_ROOM(1, 2, 10, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-10', 'YYYY-MM-DD'));

--получени€ счета за собственное бронирование:
exec GET_SUM_PAY_BY_RESERVATION(2);


--отмена собственного бронировани€:
--до
exec GET_MY_RESERVATIONS(76207);
--отмена
EXEC CANCEL_RESERVATION(1);
--после
exec GET_MY_RESERVATIONS(76207);


--










--admin
--вывод информации о пользователе
exec GET_ALL_USERS();

--ѕолучение списка всех отелей
exec GET_ALL_HOTELS();
-- добавление нового отел€ в систему
EXEC ADD_HOTEL(100010, '¬еста', 'Ѕрест', 'ул.  овалева, 12', '5 звезд');

--вывод инфы о платежах
exec  VIEW_PAYMENTS();

--подтверждение платежа:
EXEC CONFIRM_PAYMENT(11);

--изменение информации о номере:
EXEC update_room_info(1, 2, 'ƒвухместный', 100, '—вободен', 201);

--удаление комнаты
EXEC delete_room(2);
--добавлени€ нового номера в отель:
EXEC ADD_ROOM(100010, 5, 'Ћюкс', 500, 'ƒоступен', 501);

--удаление пользовател€ по логину:
EXEC delete_user_by_login('login_10');

--изменение данных пользовател€:
--с проверкой почты
EXEC update_user_by_login('login_10', 'Joh', 'Doe', 'john.doe@example.com', '+1234567890');

--удалени€ отел€ из системы
EXEC DELETE_HOTEL(10);

--обновление рейтинга отел€
EXEC UPDATE_HOTEL_RATING(2, '4 звезды');

--статистика бронирований
exec GET_RESERVATION_STATISTICS;