
#Если Сервер Тогда

Функция ДанныеОписания(Объект) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Ссылка");
	Результат.Вставить("Текст");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОписанияПоОбъектам.Описание КАК Ссылка,
	|	ОписанияПоОбъектам.Описание.Текст КАК Текст
	|ИЗ
	|	РегистрСведений.ОписанияПоОбъектам КАК ОписанияПоОбъектам
	|ГДЕ
	|	ОписанияПоОбъектам.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", Объект);
	
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Результат.Ссылка = ВыборкаДетальныеЗаписи.Ссылка;
		Результат.Текст = ВыборкаДетальныеЗаписи.Текст;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура СвязатьОписаниеСОбъектом(Описание, Объект) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = Объект;
	МенеджерЗаписи.Описание = Описание;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ОтвязатьОписаниеОтОбъекта(Объект) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = Объект;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Удалить();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
