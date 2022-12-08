
&НаКлиенте
Процедура СформироватьВручнуюКлиент(Команда)
	
	СформироватьВручную();
	
КонецПроцедуры	

&НаСервере
Процедура СформироватьВручную() Экспорт
	
	Результат.Очистить();
	
	ОтчетБД = РеквизитФормыВЗначение("Отчет");
	СхемаКомпоновкиДанных = ОтчетБД.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	ИсполняемыеНастройки = Отчет.КомпоновщикНастроек.Настройки;
	УстановитьНастройки(ИсполняемыеНастройки);
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ДанныеРасшифровкиСКД = Новый ДанныеРасшифровкиКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ИсполняемыеНастройки, ДанныеРасшифровкиСКД);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , ДанныеРасшифровкиСКД);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровкиСКД, УникальныйИдентификатор);
    	
	Результат.ПоказатьУровеньГруппировокСтрок(1);
	Результат.ПоказатьУровеньГруппировокСтрок(0);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем Расшифровка;
	
	Если Параметры.Свойство("Расшифровка", Расшифровка) И Расшифровка <> Неопределено Тогда
		НачалоПериода = Параметры.Расшифровка.НачалоПериода;
		КонецПериода = Параметры.Расшифровка.КонецПериода;
		СтатьяДДС = Параметры.Расшифровка.СтатьяДДС;
        СформироватьВручную();
	Иначе 
		НачалоПериода = ДобавитьМесяц(КонецДня(ТекущаяДатаСеанса()), -1) + 1;
		КонецПериода = КонецДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНастройки(Настройки)
	
	ОбщегоНазначения.УстановитьЭлементПользовательскихНастроек(Настройки.ПараметрыДанных, "НачалоПериода", НачалоПериода);
	ОбщегоНазначения.УстановитьЭлементПользовательскихНастроек(Настройки.ПараметрыДанных, "КонецПериода", КонецПериода);
	ОбщегоНазначения.УстановитьЭлементОтбора(Настройки.Отбор, "СтатьяДДС", СтатьяДДС, ВидСравненияКомпоновкиДанных.ВИерархии);
	
КонецПроцедуры	

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;      
	
	СтруктураРасшифровки = ОбщегоНазначенияСервер.ПолучитьСтруктуруРасшифровки(Расшифровка, ЭтаФорма.ДанныеРасшифровки);
	
	Если СтруктураРасшифровки.Свойство("Документ") Тогда
		ОткрытьЗначениеАсинх(СтруктураРасшифровки.Документ);
	КонецЕсли;
	
КонецПроцедуры
