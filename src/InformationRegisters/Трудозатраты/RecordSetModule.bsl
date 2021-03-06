
#Если Сервер Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Префиксы = Новый Массив;
	Префиксы.Добавить("Затрачено");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Запись.ЗатраченоВСекундах = ПолучитьЗатрачено(Запись.Задача);
		
		Для Каждого Префикс Из Префиксы Цикл
			ИзСекунд = ОбщегоНазначенияКлиентСервер.ИзСекунд(Запись[Префикс + "ВСекундах"]);
			Запись[Префикс] = ОбщегоНазначенияКлиентСервер.ПредставлениеТрудозатрат(, ИзСекунд.Часов, ИзСекунд.Минут);
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьЗатрачено(Задача) 
	
	Результат = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(Замеры.Затрачено) КАК Затрачено
	|ИЗ
	|	Справочник.Замеры КАК Замеры
	|ГДЕ
	|	Замеры.Владелец = &Задача
	|	И НЕ Замеры.Владелец.Владелец.ЛичноеВремя";
	
	Запрос.УстановитьПараметр("Задача", Задача);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Результат = ВыборкаДетальныеЗаписи.Затрачено;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
