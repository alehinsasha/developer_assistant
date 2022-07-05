
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		СтандартнаяОбработка = Ложь;
		
		ПоказатьЗначение(Неопределено, ВыбраннаяСтрока.Ключ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьДатуВизуализацииТрудозатрат(Команда)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеВыбораДатыВизуализацииТрудозатрат", ЭтотОбъект);
	ПоказатьВводДаты(ОповещениеОЗавершении, ДатаПланирования, ЧастиДаты.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораДатыВизуализацииТрудозатрат(Дата, ДополнительныеПараметры) Экспорт
	
	ДатаПланирования = Дата;
	ИнициализироватьПланировщик();
	ОбновитьВизуализациюТрудозатрат();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВизуализациюТрудозатратПринудительно(Команда)
	
	ОбновитьВизуализациюТрудозатрат();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВизуализациюТрудозатрат()
	
	ПланировщикТрудозатрат.Элементы.Очистить();
	ИтогоТрудозатраты = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Замеры.Ссылка КАК ЗамерСсылка,
	|	Замеры.Комментарий КАК ЗамерКомментарий,
	|	Замеры.ДатаВремяНачала КАК ЗамерДатаВремяНачала,
	|	Замеры.ДатаВремяОкончания КАК ЗамерДатаВремяОкончания,
	|	Замеры.Владелец КАК ЗадачаСсылка,
	|	ПРЕДСТАВЛЕНИЕ(Замеры.Владелец) КАК ЗадачаСтрокой,
	|	Замеры.Владелец.Владелец.ЛичноеВремя КАК ЭтоЛичноеВремя,
	|	Замеры.Затрачено КАК Затрачено
	|ИЗ
	|	Справочник.Замеры КАК Замеры
	|ГДЕ
	|	Замеры.ДатаВремяНачала >= &ДатаВремяНачала
	|	И Замеры.ДатаВремяОкончания <= &ДатаВремяОкончания";
	
	Запрос.УстановитьПараметр("ДатаВремяНачала", НачалоДня(ДатаПланирования));
	Запрос.УстановитьПараметр("ДатаВремяОкончания", КонецДня(ДатаПланирования));
	Запрос.УстановитьПараметр("ДатаВремяТекущиее", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовыйЭлементПланировщика = ПланировщикТрудозатрат.Элементы.Добавить(ВыборкаДетальныеЗаписи.ЗамерДатаВремяНачала, ВыборкаДетальныеЗаписи.ЗамерДатаВремяОкончания);
		НовыйЭлементПланировщика.Значение = ВыборкаДетальныеЗаписи.ЗамерСсылка;
		
		ИзСекунд = ОбщегоНазначенияКлиентСервер.ИзСекунд(ВыборкаДетальныеЗаписи.Затрачено);
		ЗатраченоСтрокой = ОбщегоНазначенияКлиентСервер.ПредставлениеТрудозатрат(, ИзСекунд.Часов, ИзСекунд.Минут);

		Содержимое = Новый Массив();
		Содержимое.Добавить(СтрШаблон("[%1]", ЗатраченоСтрокой));
		Содержимое.Добавить(" ");
		Содержимое.Добавить(Новый ФорматированнаяСтрока(ВыборкаДетальныеЗаписи.ЗадачаСтрокой,, WebЦвета.Коричневый,, ПолучитьНавигационнуюСсылку(ВыборкаДетальныеЗаписи.ЗадачаСсылка)));
		НовыйЭлементПланировщика.Текст = Новый ФорматированнаяСтрока(Содержимое);
		
		НовыйЭлементПланировщика.Подсказка = ВыборкаДетальныеЗаписи.ЗамерКомментарий;		
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ЗамерКомментарий) Тогда
			НовыйЭлементПланировщика.Картинка = БиблиотекаКартинок.ОформлениеЗнакФлажок;
		Иначе
			НовыйЭлементПланировщика.Картинка = БиблиотекаКартинок.ОформлениеЗнакВоcклицательныйЗнак;
		КонецЕсли;
		
		Если ВыборкаДетальныеЗаписи.ЭтоЛичноеВремя Тогда
			НовыйЭлементПланировщика.ЦветФона = WebЦвета.СеребристоСерый;
		Иначе
			НовыйЭлементПланировщика.ЦветФона = WebЦвета.БледноЗеленый;
			
			ИтогоТрудозатраты = ИтогоТрудозатраты + ВыборкаДетальныеЗаписи.Затрачено;
		КонецЕсли;
		
		Измерения = Новый Соответствие;
		Измерения.Вставить("Корень", "ФактическиеТрудозатраты");
		НовыйЭлементПланировщика.ЗначенияИзмерений = Новый ФиксированноеСоответствие(Измерения);
	КонецЦикла;
	
	Прогресс = ИтогоТрудозатраты;
	
	ИзСекунд = ОбщегоНазначенияКлиентСервер.ИзСекунд(ИтогоТрудозатраты);
	ИтогоТрудозатратыЗаДень = ОбщегоНазначенияКлиентСервер.ПредставлениеТрудозатрат(, ИзСекунд.Часов, ИзСекунд.Минут);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗамер(Команда)
	
	Если Элементы.ПланировщикТрудозатрат.ВыделенныеЭлементы.Количество() Тогда
		ПараметрыФормы = Новый Структура();
		
		Замер = Элементы.ПланировщикТрудозатрат.ВыделенныеЭлементы[0].Значение;
		ПараметрыФормы.Вставить("Ключ", Замер);
		
		КонтекстФормы = Новый Структура();
		КонтекстФормы.Вставить("Замер", Замер);
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияФормыЗамера", ЭтотОбъект, КонтекстФормы);
		
		ОткрытьФорму("Справочник.Замеры.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыЗамера(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Замер = Неопределено;
	Если ДополнительныеПараметры.Свойство("Замер", Замер) И ЗначениеЗаполнено(Замер) Тогда
		Если ДополнительныеПараметры.Свойство("КомментарийКЗамеру") Тогда
			ИскомыйЗамер = ПланировщикТрудозатрат.Элементы.Найти(Замер);
			ИскомыйЗамер.Подсказка = ДополнительныеПараметры.КомментарийКЗамеру;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтроки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтроки() Экспорт
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(Элементы.Список.ТекущаяСтрока);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СправочникСсылка.Задачи") Тогда
		ТекущаяЗадача = Элементы.Список.ТекущаяСтрока;
	КонецЕсли;
	
	ОбработатьАктивизациюСтрокиНаСервере(ДанныеСтроки);
	
	РМ_MarkdownКлиент.ПриСменеСтраницыПоляКомментария(ЭтаФорма, Элементы.РМ_Страницы_ОписаниеЗадачи,  Элементы.РМ_Страница_Просмотр_ОписаниеЗадачи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикТрудозатратПриАктивизации(Элемент)
	
	Если Элемент.ВыделенныеЭлементы.Количество() Тогда
		ТекущаяЗадача = ЗадачаЗамера(Элемент.ВыделенныеЭлементы[0].Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьАктивизациюСтрокиНаСервере(ДанныеСтроки)
	
	ЗаполнитьОписаниеЗадачи(ДанныеСтроки);
	ЗапомнитьТекущийПроект(ДанныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписаниеЗадачи(ДанныеСтроки)

	ОписаниеЗадачи = "";

	Если ДанныеСтроки.Свойство("Ссылка") Тогда
		ОбъектОписания = ДанныеСтроки.Ссылка;
	ИначеЕсли ДанныеСтроки.Свойство("Владелец") Тогда
		ОбъектОписания = ДанныеСтроки.Владелец;
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОписанияПоОбъектам.Описание КАК Описание,
	|	ОписанияВХранилищах.Хранилище КАК Хранилище
	|ИЗ
	|	РегистрСведений.ОписанияПоОбъектам КАК ОписанияПоОбъектам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписанияВХранилищах КАК ОписанияВХранилищах
	|		ПО ОписанияПоОбъектам.Описание = ОписанияВХранилищах.Описание
	|ГДЕ
	|	ОписанияПоОбъектам.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", ОбъектОписания);
	
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Описание = ВыборкаДетальныеЗаписи.Хранилище.Получить();
		Если ЗначениеЗаполнено(Описание) Тогда
			ОписаниеЗадачи = Описание;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗапомнитьТекущийПроект(ДанныеСтроки)
	
	Если Не ДанныеСтроки.Свойство("Владелец") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСеанса.ТекущийПроект = ДанныеСтроки.Владелец;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	НарисоватьЭлементыРаботыСОписаниемЗадачи();
	
	ДатаПланирования = ТекущаяДатаСеанса();

	ИнициализироватьПланировщик();
	ОбновитьВизуализациюТрудозатрат();

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПланировщик()
	
	ДатаНачала = НачалоДня(ДатаПланирования);
	ДатаОкончания = КонецДня(ДатаПланирования);
	
	ПланировщикТрудозатрат.ШкалаВремени.Положение = ПоложениеШкалыВремени.Лево;
	ПланировщикТрудозатрат.ОтображениеВремениЭлементов = ОтображениеВремениЭлементовПланировщика.ВремяНачалаИКонца;
	ПланировщикТрудозатрат.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.День;
	ПланировщикТрудозатрат.КратностьПериодическогоВарианта = 1;
	ПланировщикТрудозатрат.ОтображатьПеренесенныеЗаголовки = Истина;
	ПланировщикТрудозатрат.ОтображатьПеренесенныеЗаголовкиШкалыВремени = Истина;
	ПланировщикТрудозатрат.НачалоПериодаОтображения = ДатаНачала;
	ПланировщикТрудозатрат.КонецПериодаОтображения = ДатаОкончания;
	ПланировщикТрудозатрат.ОтображатьТекущуюДату = Истина;
	ПланировщикТрудозатрат.ВыравниватьГраницыЭлементовПоШкалеВремени = Истина;
	
	ПланировщикТрудозатрат.ТекущиеПериодыОтображения.Очистить();
	ПланировщикТрудозатрат.ТекущиеПериодыОтображения.Добавить(ДатаНачала + 6*60*60, ДатаОкончания);
	
	УдалитьЭлементыШкалыВремени();
	
	ЭлементШкалыВремени = ПланировщикТрудозатрат.ШкалаВремени.Элементы.Добавить();
	ЭлементШкалыВремени.Единица = ТипЕдиницыШкалыВремени.Минута;
	ЭлементШкалыВремени.Кратность = 5;
	ЭлементШкалыВремени.Формат = "ДФ='HH:mm'";
	ЭлементШкалыВремени.ОтображатьПериодическиеМетки = Истина;
	ПланировщикТрудозатрат.ШкалаВремени.Элементы.Удалить(ПланировщикТрудозатрат.ШкалаВремени.Элементы[0]);	
	
	ПланировщикТрудозатрат.Измерения.Очистить();
	
	Измерение = ПланировщикТрудозатрат.Измерения.Добавить("Корень");
	Измерение.Элементы.Добавить("ФактическиеТрудозатраты", "Трудозатраты");

КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыШкалыВремени() 
	
	КоличествоЭлементовВШкалеВремени = ПланировщикТрудозатрат.ШкалаВремени.Элементы.Количество();
	Для Счетчик = 0 По КоличествоЭлементовВШкалеВремени Цикл
		ПланировщикТрудозатрат.ШкалаВремени.Элементы.Удалить(ПланировщикТрудозатрат.ШкалаВремени.Элементы[0]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НарисоватьЭлементыРаботыСОписаниемЗадачи()
	
	РМ_MarkdownСервер.ВставитьПолеРедактированияТекстаНаФорму(ЭтотОбъект, Элементы.ОписаниеЗадачи,
		"ОписаниеЗадачи", "ones", Истина);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура РМ_Подключаемый_ОбработкаКомандыПоляКомментария(Команда)
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(Элементы.Список.ТекущаяСтрока);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Команда.Имя = "РМ_ЗакончитьРедактирование_ОписаниеЗадачи" Тогда
		СохранитьОписание(ДанныеСтроки, ОписаниеЗадачи);
		Элементы.РМ_Страницы_ОписаниеЗадачи.ТекущаяСтраница = Элементы.РМ_Страница_Просмотр_ОписаниеЗадачи;
		РМ_MarkdownКлиент.ПриСменеСтраницыПоляКомментария(ЭтаФорма, Элементы.РМ_Страницы_ОписаниеЗадачи,  Элементы.РМ_Страница_Просмотр_ОписаниеЗадачи);
		
		Элементы.Список.Обновить();
	ИначеЕсли Команда.Имя = "РМ_НачатьРедактирование_ОписаниеЗадачи" Тогда
		// Изменить
		Элементы.РМ_Страницы_ОписаниеЗадачи.ТекущаяСтраница = Элементы.РМ_Страница_Редактирование_ОписаниеЗадачи;
		РМ_MarkdownКлиент.ПриСменеСтраницыПоляКомментария(ЭтаФорма, Элементы.РМ_Страницы_ОписаниеЗадачи, Элементы.РМ_Страница_Редактирование_ОписаниеЗадачи);
	Иначе
		РМ_MarkdownКлиент.ОбработкаКомандыПоляКомментария(ЭтаФорма, Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьОписание(ДанныеСтроки, ОписаниеЗадачи)
	
	Если ДанныеСтроки.Свойство("Ссылка") Тогда
		ОбъектОписания = ДанныеСтроки.Ссылка;
	ИначеЕсли ДанныеСтроки.Свойство("Владелец") Тогда
		ОбъектОписания = ДанныеСтроки.Владелец;
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОписанияПоОбъектам.Описание
	|ИЗ
	|	РегистрСведений.ОписанияПоОбъектам КАК ОписанияПоОбъектам
	|ГДЕ
	|	ОписанияПоОбъектам.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", ОбъектОписания);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ИдентификаторЗадачи = Строка(ОбъектОписания.УникальныйИдентификатор());
		
		ИскомоеОписание = Справочники.Описания.НайтиПоНаименованию(ИдентификаторЗадачи);
		Если ЗначениеЗаполнено(ИскомоеОписание) Тогда
			Описание = ИскомоеОписание;
		Иначе
			НовоеОписание = Справочники.Описания.СоздатьЭлемент();
			НовоеОписание.УстановитьНовыйКод();
			НовоеОписание.Наименование = ИдентификаторЗадачи;
			НовоеОписание.Записать();
			
			Описание = НовоеОписание.Ссылка;
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ОписанияПоОбъектам.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Описание = Описание;
		МенеджерЗаписи.Объект = ОбъектОписания;
		МенеджерЗаписи.Записать();
	Иначе
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();

		Описание = ВыборкаДетальныеЗаписи.Описание;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ОписанияВХранилищах.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Описание = Описание;
	МенеджерЗаписи.Хранилище = Новый ХранилищеЗначения(ОписаниеЗадачи, Новый СжатиеДанных(9));
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура РМ_Подключаемый_ПриНажатииПоляПросмотраКомментария(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	РМ_MarkdownКлиент.ПриНажатииПоляПросмотраКомментария(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикТрудозатратПередСозданием(Элемент, Начало, Конец, ЗначенияИзмерений, Текст, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ТекущаяЗадача) Тогда
		Текст = ТекущаяЗадача;
	Иначе 
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, "Выбери задачу");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПланировщикТрудозатратПриОкончанииРедактирования(Элемент, НовыйЭлемент, ОтменаРедактирования)
	
	ТекущийЭлементПланировщика = Элемент.ВыделенныеЭлементы[0];
	Если НовыйЭлемент Тогда
		Замер = Новый Структура;
		Замер.Вставить("Начало", ОбщегоНазначенияКлиентСервер.ОкруглитьМинутыВДате(ТекущийЭлементПланировщика.Начало));
		Замер.Вставить("Конец", ОбщегоНазначенияКлиентСервер.ОкруглитьМинутыВДате(ТекущийЭлементПланировщика.Конец));
		Замер.Вставить("Значение", ТекущаяЗадача);
		НовыйЗамер = СоздатьЗамер(Замер);
		ТекущийЭлементПланировщика.Значение = НовыйЗамер;
	Иначе
		Замер = Новый Структура;
		Замер.Вставить("Значение", ТекущийЭлементПланировщика.Значение);
		Замер.Вставить("Начало", ОбщегоНазначенияКлиентСервер.ОкруглитьМинутыВДате(ТекущийЭлементПланировщика.Начало));
		Замер.Вставить("Конец", ОбщегоНазначенияКлиентСервер.ОкруглитьМинутыВДате(ТекущийЭлементПланировщика.Конец));
		ИзменитьЗамер(Замер);
	КонецЕсли;
	
	ТекущийЭлементПланировщика.Текст = ОбщегоНазначенияВызовСервера.ПредставлениеЗамера(ТекущийЭлементПланировщика.Значение);
	
	ОбновитьВизуализациюТрудозатрат();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьЗамер(Замер) 
	
	НовыйЗамер = Справочники.Замеры.СоздатьЭлемент();
	НовыйЗамер.ДатаВремяНачала = Замер.Начало;
	НовыйЗамер.ДатаВремяОкончания = Замер.Конец;
	НовыйЗамер.Владелец = Замер.Значение;
	НовыйЗамер.Записать();
	
	Возврат НовыйЗамер.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура ПланировщикТрудозатратПередУдалением(Элемент, Отказ)
	
	ПланировщикТрудозатратПередУдалениемНаСервере(Элемент.ВыделенныеЭлементы[0].Значение);
	
КонецПроцедуры

&НаСервере
Процедура ПланировщикТрудозатратПередУдалениемНаСервере(Замер)
	
	ЗамерОбъект = Замер.ПолучитьОбъект();
	ЗамерОбъект.Удалить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикТрудозатратВыбор(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Элемент.ВыделенныеЭлементы.Количество() Тогда
		ПоказатьЗначение(, ЗадачаЗамера(Элемент.ВыделенныеЭлементы[0].Значение));
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗадачаЗамера(Замер) 
	
	Возврат Замер.Владелец;
	
КонецФункции

&НаКлиенте
Процедура ПланировщикТрудозатратПередНачаломБыстрогоРедактирования(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ПланировщикТрудозатрат.ВыделенныеЭлементы.Количество() Тогда
		Элементы.Список.ТекущаяСтрока = ЗадачаЗамера(Элементы.ПланировщикТрудозатрат.ВыделенныеЭлементы[0].Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИзменитьЗамер(Замер) 
	
	ЗамерОбъект = Замер.Значение.ПолучитьОбъект();
	ЗамерОбъект.ДатаВремяНачала = Замер.Начало;
	ЗамерОбъект.ДатаВремяОкончания = Замер.Конец;
	ЗамерОбъект.Записать();
	
КонецПроцедуры
