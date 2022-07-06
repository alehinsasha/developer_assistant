
#Если Сервер Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = Текст;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбъектОписания") Тогда
		РегистрыСведений.ОписанияПоОбъектам.СвязатьОписаниеСОбъектом(Ссылка, ДополнительныеСвойства.ОбъектОписания);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
