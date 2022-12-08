
&НаКлиенте
Процедура ПоКнопкеСформироватьОтчет(Команда)
	
	СформироватьОтчет();
	
КонецПроцедуры

Процедура СформироватьОтчет() Экспорт
	
	Результат.Очистить();
	
	Настройки = Отчет.КомпоновщикНастроек.Настройки;
	ПараметрыДанных = Настройки.ПараметрыДанных;
	УстановитьПараметрДанных(ПараметрыДанных, "ДатаОтчета", Отчет.ДатаОтчета);
	УстановитьПараметрДанных(ПараметрыДанных, "СтатьяДДС", Отчет.СтатьяДДС);
	УстановитьПараметрДанных(ПараметрыДанных, "КоличествоМесяцев", Отчет.КоличествоМесяцев);

	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	СхемаКомпоновки = Отчеты.АнализРасходов.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновки, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	АдресДанныхРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	
	ПроцессорВывода  = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент();
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отчет.ДатаОтчета = ТекущаяДата();
	Отчет.КоличествоМесяцев = 6;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтатьяДДС = ПолучитьЗначениеРасшифровки(Расшифровка);
	
	Если ТипЗнч(СтатьяДДС) = Тип("СправочникСсылка.СтатьиДДС") Тогда 
		Адрес = ПолучитьНавигационнуюСсылку(СтатьяДДС);
		ПерейтиПоНавигационнойСсылке(Адрес);
	КонецЕсли;
	
КонецПроцедуры


Функция ПолучитьЗначениеРасшифровки(Расшифровка) 
	
	Данные = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки);	
	Поля = Данные.Элементы.Получить(Расшифровка).ПолучитьПоля();
	
	ПолеДДС = Поля.Найти("СтатьяДДС");
	Если ПолеДДС <> Неопределено Тогда
		Возврат ПолеДДС.Значение;
	КонецЕсли;	
	
КонецФункции	

