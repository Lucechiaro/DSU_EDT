
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НеПоказыватьОсновнуюВалютуУчета") И Параметры.НеПоказыватьОсновнуюВалютуУчета Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ПравоеЗначение = Константы.ОсновнаяВалютаУчета.Получить();
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ЭлементОтбора.Использование = Истина;	
			
	КонецЕсли;	
	
КонецПроцедуры
