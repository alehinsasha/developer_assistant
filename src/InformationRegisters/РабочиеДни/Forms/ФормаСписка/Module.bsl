
&НаКлиенте
Процедура ЗаполнитьРабочиеДни(Команда)
	
	ЗаполнитьРабочиеДниНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРабочиеДниНаСервере() 
	
	ДатаНачала = ПериодЗаполнения.ДатаНачала;
	ДатаОкончания = ПериодЗаполнения.ДатаОкончания;
	ДатаТекущая = ДатаНачала;
	
	Пока НачалоДня(ДатаТекущая) < НачалоДня(ДатаОкончания) Цикл
		МенеджерЗаписи = РегистрыСведений.РабочиеДни.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.День = ДатаТекущая;
		
		Если ДеньНедели(ДатаТекущая) = 6 Или ДеньНедели(ДатаТекущая) = 7 Тогда
			МенеджерЗаписи.Удалить();
		Иначе 
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
		ДатаТекущая = ДатаТекущая + 86400;
	КонецЦикла;
	
КонецПроцедуры
