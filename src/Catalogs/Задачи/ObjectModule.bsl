
#Если Сервер Тогда

Процедура ПриКопировании(ОбъектКопирования)
	
	ДатаВремяСоздания = '00010101';
	ДатаВремяРедактирования = '00010101';
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДатаИВремя = ТекущаяДатаСеанса();
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		ДатаВремяСоздания = ТекущиеДатаИВремя;
	КонецЕсли;
	
	ДатаВремяРедактирования = ТекущиеДатаИВремя;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ЭтоНовый Тогда
		МенеджерЗаписи = РегистрыСведений.Трудозатраты.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Задача = Ссылка;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
