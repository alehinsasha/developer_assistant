
#Если Сервер Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Затрачено = НачалоМинуты(ДатаВремяОкончания) - НачалоМинуты(ДатаВремяНачала);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	РегистрыСведений.Трудозатраты.ПересчитатьТрудозатраты(Ссылка.Владелец);
	
	Если Владелец.ПередаватьОписаниеЗамерам Тогда
		ДанныеОписания = ОбщегоНазначенияВызовСервера.ДанныеОписания(Владелец);
		ОбщегоНазначенияВызовСервера.СвязатьОписаниеСОбъектом(ДанныеОписания.Ссылка, Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
