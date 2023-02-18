#Область ПрограммныйИнтерфейс

Функция ПолучитьТаблицуАктуальностиКурсов(ДатаКурсов, флгТолькоНеактуальныеКурсы = Ложь) Экспорт
	
	// TODO перенести в модуль менеджера регистра сведений
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Период,
	|	КурсыВалютСрезПоследних.Валюта
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(
	|			&ДатаКурсов, Валюта В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					Остатки.Валюта
	|				ИЗ
	|					РегистрНакопления.ОстаткиПоСчетам.Остатки(&ДатаКурсов, Валюта.Используется И Валюта <> &ВалютаУчета) КАК Остатки)
	|			) КАК КурсыВалютСрезПоследних"
	+ ?(флгТолькоНеактуальныеКурсы, " Где КурсыВалютСрезПоследних.Период < НачалоПериода(&ДатаКурсов, День)", "");
	Запрос.УстановитьПараметр("ДатаКурсов", КонецДня(ДатаКурсов));
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ОсновнаяВалютаУчета.Получить());
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции	                                             

Функция КурсыВалютАктуальны(ДатаКурсов) Экспорт 
	
	ТаблицаКурсов = ПолучитьТаблицуАктуальностиКурсов(ДатаКурсов, Истина);
	Возврат ТаблицаКурсов.Количество() = 0;
	
КонецФункции	

Процедура ОбновитьТочкуАктуальности() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МАКСИМУМ(ТочкиАктуальностиСрезПоследних.Период) КАК ДатаАктуальности
	               |ПОМЕСТИТЬ ДатыАктуальности
	               |ИЗ
	               |	РегистрСведений.ТочкиАктуальности.СрезПоследних КАК ТочкиАктуальностиСрезПоследних
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТочкиАктуальностиСрезПоследних.Период КАК Дата,
	               |	СУММА(ТочкиАктуальностиСрезПоследних.СуммаУчетн) КАК Сумма
	               |ИЗ
	               |	РегистрСведений.ТочкиАктуальности.СрезПоследних КАК ТочкиАктуальностиСрезПоследних
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ДатыАктуальности КАК ДатыАктуальности
	               |		ПО ТочкиАктуальностиСрезПоследних.Период = ДатыАктуальности.ДатаАктуальности
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТочкиАктуальностиСрезПоследних.Период";
	ТабЗапрос = Запрос.Выполнить().Выгрузить();			   
	ПараметрыСеанса.ТочкаАктуальности = Новый ФиксированнаяСтруктура("Дата,Сумма", ТабЗапрос[0].Дата, ТабЗапрос[0].Сумма);
	
КонецПроцедуры	

Процедура УстановитьЭлементПользовательскихНастроек(Настройки, ИмяПараметра, ЗначениеПараметра) Экспорт
	
	ВыборкаПараметров = Настройки.Элементы;
	Параметр = Новый ПараметрКомпоновкиДанных(ИмяПараметра);
	
	Для Каждого ТекЭлемент Из ВыборкаПараметров Цикл
		Если ТипЗнч(ТекЭлемент) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			Если ТекЭлемент.Параметр = Параметр Тогда
				ТекЭлемент.Значение = ЗначениеПараметра;
				ТекЭлемент.Использование = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЭлементОтбора(Настройки, ИмяПараметра, ЗначениеПараметра, ВидСравнения = Неопределено) Экспорт
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;	
	
	ВыборкаПараметров = Настройки.Элементы;
	Параметр = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	
	Для Каждого ТекЭлемент Из ВыборкаПараметров Цикл
		
		Если ТипЗнч(ТекЭлемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		
			Если ТекЭлемент.ЛевоеЗначение = Параметр Тогда
			
				ТекЭлемент.ПравоеЗначение = ЗначениеПараметра;
				ТекЭлемент.ВидСравнения = ВидСравнения;
				ТекЭлемент.Использование = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСтруктуруРасшифровки(Расшифровка, ДанныеРасшифровки) Экспорт 
	
	СтруктураРасшифровки = Новый Структура;
	Коллекция = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	Элемент = Коллекция.Элементы[Расшифровка];
	ОбработатьПолеРасшифровки(Элемент, СтруктураРасшифровки);
	
	Возврат СтруктураРасшифровки;
	
КонецФункции

Процедура ОбработатьПолеРасшифровки(Элемент, СтруктураРасшифровки) Экспорт 

	Если ТипЗнч(Элемент) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда 
		
		ПоляЭлемента = Элемент.ПолучитьПоля();	
		
		Для Каждого ПолеЭлемента Из ПоляЭлемента Цикл
			
			Попытка
				СтруктураРасшифровки.Вставить(СтрЗаменить(ПолеЭлемента.Поле, ".", ""), ПолеЭлемента.Значение);
			Исключение
				ОбщийКлиентСервер.СообщитьПользователю("Ошибка получения расшифровки");
			КонецПопытки;
			
		КонецЦикла;	
		
	КонецЕсли;
	
	РодителиПоля = Элемент.ПолучитьРодителей();
	
	Для Каждого РодительПоля Из РодителиПоля Цикл
		ОбработатьПолеРасшифровки(РодительПоля, СтруктураРасшифровки)
	КонецЦикла;	
	
КонецПроцедуры

Процедура СообщитьПользователю(ТекстСообщения) Экспорт
	
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Сообщить();
	
КонецПроцедуры

#КонецОбласти
	