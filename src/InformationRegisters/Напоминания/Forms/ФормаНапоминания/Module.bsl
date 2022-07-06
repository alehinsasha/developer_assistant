
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьАктуальныеНапоминания();
	Отказ = Не АктуальныеНапоминания.Количество();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАктуальныеНапоминания()
	
	АктуальныеНапоминания.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Напоминания.Объект
	|ИЗ
	|	РегистрСведений.Напоминания КАК Напоминания
	|ГДЕ
	|	Напоминания.ДатаВремяНапоминания <= &ДатаВремяНапоминания
	|
	|УПОРЯДОЧИТЬ ПО
	|	Напоминания.ДатаВремяНапоминания";
	
	Запрос.УстановитьПараметр("ДатаВремяНапоминания", ТекущаяДатаСеанса());
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Отказ = Истина;
		
		Возврат;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		АктуальныеНапоминания.Добавить(ВыборкаДетальныеЗаписи.Объект);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура АктуальныеНапоминанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(, Элементы.АктуальныеНапоминания.ДанныеСтроки(ВыбраннаяСтрока).Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьНапоминание(Команда)
	
	ОткладываемыеНапоминания = ВыбранныеНапоминания();
	Если ОткладываемыеНапоминания.Количество() Тогда
		ОповещениеОПереносеНапоминания = Новый ОписаниеОповещения("ПослеПереносаНапоминаний", ЭтотОбъект);
		ОбщегоНазначенияКлиент.СоздатьОтложитьНапоминания(ОткладываемыеНапоминания, ОповещениеОПереносеНапоминания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПереносаНапоминаний(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьАктуальныеНапоминания();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНапоминание(Команда)
	
	ЗавершаемыеНапоминания = ВыбранныеНапоминания();
	Если ЗавершаемыеНапоминания.Количество() Тогда
		ОповещениеОЗавершенииНапоминаний = Новый ОписаниеОповещения("ПослеЗавершенияНапоминаний", ЭтотОбъект);
		ОбщегоНазначенияКлиент.ЗавершитьНапоминания(ЗавершаемыеНапоминания, ОповещениеОЗавершенииНапоминаний);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияНапоминаний(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьАктуальныеНапоминания();
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНапоминания()
	
	Результат = Новый Массив();
	
	Для Каждого Строка Из АктуальныеНапоминания Цикл
		Если Строка.Пометка Тогда
			Результат.Добавить(Строка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
