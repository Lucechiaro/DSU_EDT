
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Для Каждого КлючИЗначение Из ДанныеЗаполнения Цикл
		
		Если КлючИЗначение.Ключ = "Период" Тогда
			
			Для каждого Запись Из ЭтотОбъект  Цикл
			
				Запись.Период = КлючИЗначение.Значение;
			
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;	
		
КонецПроцедуры
