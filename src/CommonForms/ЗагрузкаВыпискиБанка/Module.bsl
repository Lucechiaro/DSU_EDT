#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Счет", Счет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	РеквизитыСчета = ПолучитьРеквизитыСчета(Счет);
	ФорматВыписки = РеквизитыСчета.ФорматВыписки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрочитатьВыписку(Команда)
	
	Если ФорматВыписки.Пустая() Тогда
		
		ПоказатьПредупреждение(, "Укажите формат выписки!");
		Возврат;
		
	КонецЕсли;	
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ООВыборФайла = Новый ОписаниеОповещения("ООВыборФайлаЗавершение", ЭтотОбъект);
	Диалог.Показать(ООВыборФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТранзакции(Команда)
	
	СохранитьТранзакцииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ООВыборФайлаЗавершение(ИменаФайлов, ДополнительныеСвойства) Экспорт
	
	Если ИменаФайлов <> Неопределено И ИменаФайлов.Количество() > 0 Тогда
		
		// ToDo
		// скопируем файл во временный каталог, чтобы избежать ошибки доступа
		ДвоичныеДанные = Новый ДвоичныеДанные(ИменаФайлов[0]);
		АдресВХ = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		ПрочитатьВыпискуНаСервере(АдресВХ);
		
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура ПрочитатьВыпискуНаСервере(АдресВХ)
	
	ДвоичныеДанные 	= ПолучитьИзВременногоХранилища(АдресВХ);
	ИмяФайла 		= ПолучитьИмяВременногоФайла();
	ДвоичныеДанные.Записать(ИмяФайла);
	
	Если ФорматВыписки = ПредопределенноеЗначение("Перечисление.ФорматыВыписки.Тинькофф") Тогда
		РазобратьВыпискуТинькофф(ИмяФайла);
	КонецЕсли;	 
		
	УдалитьФайлы(ИмяФайла);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыСчета(Счет)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Счета.ФорматВыписки
	|ИЗ
	|	Справочник.Счета КАК Счета
	|ГДЕ
	|	Счета.Ссылка = &Счет";
	Запрос.УстановитьПараметр("Счет", Счет);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Структура("ФорматВыписки");
	
	Если Выборка.Следующий() Тогда
		Результат.ФорматВыписки = Выборка.ФорматВыписки;
	КонецЕсли;	
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция Модуль(Число)
	
	Если Число > 0 Тогда
		Модуль = Число;
	Иначе
		Модуль = -Число;
	КонецЕсли;
			
	Возврат Модуль;		
	
КонецФункции

&НаСервере
Процедура СохранитьТранзакцииНаСервере()
	
	Для Каждого СтрокаТранзакции Из ТаблицаТранзакций Цикл
		
		Если СтрокаТранзакции.ДокументТранзакции.Пустая() Тогда
			ДокументТранзакции = Документы.БанковскаяТранзакция.СоздатьДокумент();
		Иначе
			ДокументТранзакции = СтрокаТранзакции.ДокументТранзакции.ПолучитьОбъект();
		КонецЕсли;		
		 
		 ЗаполнитьТранзакцию(ДокументТранзакции, СтрокаТранзакции);
		 
		 ДокументТранзакции.Записать();
		 СтрокаТранзакции.ДокументТранзакции = ДокументТранзакции.Ссылка;
		
	КонецЦикла;	
	
КонецПроцедуры	
	
&НаСервере
Процедура ЗаполнитьСуществующиеТранзакции()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаТранзакций.ИдентификаторТранзакции
	|ПОМЕСТИТЬ ИдентификаторыТранзакций
	|ИЗ
	|	&ТаблицаТранзакций КАК ТаблицаТранзакций
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанковскаяТранзакция.Ссылка,
	|	БанковскаяТранзакция.ИдентификаторТранзакции
	|ИЗ
	|	ИдентификаторыТранзакций КАК ИдентификаторыТранзакций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БанковскаяТранзакция КАК БанковскаяТранзакция
	|		ПО БанковскаяТранзакция.ИдентификаторТранзакции = ИдентификаторыТранзакций.ИдентификаторТранзакции";
	Запрос.УстановитьПараметр("ТаблицаТранзакций", ТаблицаТранзакций.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Отбор = Новый Структура("ИдентификаторТранзакции");
	
	Пока Выборка.Следующий() Цикл
		
		Отбор.ИдентификаторТранзакции = Выборка.ИдентификаторТранзакции;
		СтрокиТаблицы = ТаблицаТранзакций.НайтиСтроки(Отбор);
		
		Если СтрокиТаблицы.Количество() > 0 Тогда
			СтрокиТаблицы[0].ДокументТранзакции = Выборка.Ссылка;
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры		

&НаСервере
Процедура ЗаполнитьТранзакцию(ДокументТранзакции, СтрокаТранзакции)
	
	ЗаполнитьЗначенияСвойств(ДокументТранзакции, СтрокаТранзакции);
	ДокументТранзакции.Дата = СтрокаТранзакции.ДатаПоБанку;
	ДокументТранзакции.Счет = Счет;
	
КонецПроцедуры	
	
&НаСервере
Процедура ЗаполнитьВалюты()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Валюты.Ссылка,
	|	Валюты.КодВалюты
	|ИЗ
	|	Справочник.Валюты КАК Валюты";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Валюты = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		Валюты.Вставить(СокрЛП(Выборка.КодВалюты), Выборка.Ссылка);
	КонецЦикла;	
	
	Для Каждого СтрокаТранзакции Из ТаблицаТранзакций Цикл
		СтрокаТранзакции.Валюта = Валюты.Получить(СтрокаТранзакции.КодВалюты);
	КонецЦикла;	
	
КонецПроцедуры	

#Область РазборВыпискиТинькофф

&НаСервере
Функция РазобратьСтрокуВыпискиТинькофф(СтрокаВыписки)
	
	МассивПоказателей = Новый Массив;
	ПредыдущийИндекс = 0;
	
	Пока Истина Цикл
		
		ТекущийИндекс = СтрНайти(СтрокаВыписки, ",", , ПредыдущийИндекс + 1);
		ПозицияКавычек = СтрНайти(СтрокаВыписки, """", , ПредыдущийИндекс + 1);
		ЭтоЗначениеЯчейки = ПозицияКавычек > 0 И ПозицияКавычек < ТекущийИндекс;

		Если ЭтоЗначениеЯчейки Тогда

			ПозицияЗакрывающихКавычек =  СтрНайти(СтрокаВыписки, """", , ПозицияКавычек + 1);
			
			Если ПозицияЗакрывающихКавычек = СтрДлина(СтрокаВыписки) Тогда // выходим на конец строки
				ТекущийИндекс = 0;
			Иначе
				ТекущийИндекс = СтрНайти(СтрокаВыписки, ",", , ПозицияЗакрывающихКавычек + 1);
			КонецЕсли;	

		КонецЕсли;

		Если ТекущийИндекс = 0 Тогда

			ЗначениеСтрокой = Сред(СтрокаВыписки, ПредыдущийИндекс + 1, СтрДлина(СтрокаВыписки) - ПредыдущийИндекс - 1);
			МассивПоказателей.Добавить(ЗначениеСтрокой);
			Прервать;

		Иначе

			ЗначениеСтрокой = Сред(СтрокаВыписки, ПредыдущийИндекс + 1, ТекущийИндекс - ПредыдущийИндекс - 1);
			МассивПоказателей.Добавить(ЗначениеСтрокой);
			ПредыдущийИндекс = ТекущийИндекс;

		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат МассивПоказателей;
	
КонецФункции	

&НаСервере
Процедура РазобратьВыпискуТинькофф(ИмяФайла)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла, КодировкаТекста.UTF8);
	
	ТаблицаТранзакций.Очистить();
	
	Для НомерСтроки = 2 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		
		МассивПоказателей = РазобратьСтрокуВыпискиТинькофф(ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки));
		ДобавитьСтрокуТранзакцииТинькофф(МассивПоказателей);
		
	КонецЦикла;	
	
	ЗаполнитьВалюты();
	ЗаполнитьСуществующиеТранзакции();
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьСтрокуТранзакцииТинькофф(МассивПоказателей)
	
	СтатусТранзакции = МассивПоказателей[3];
	
	Если СтрСравнить(СтатусТранзакции, "OK") <> 0 Тогда
		Возврат;
	КонецЕсли;	
		
	Сумма = Число(СтрЗаменить(МассивПоказателей[4], """", ""));
	
	Если Сумма = 0 Тогда
		Возврат;
	ИначеЕсли Сумма > 0 Тогда	
		ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияДС.Доход");
	Иначе
		ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияДС.Расход");	
	КонецЕсли;
	
	Дата = Дата(МассивПоказателей[0]);
		
	СтрокаТранзакции = ТаблицаТранзакций.Добавить();
	СтрокаТранзакции.ВидДвижения 		= ВидДвижения;
	СтрокаТранзакции.ДатаОперации 		= НачалоДня(Дата);
	СтрокаТранзакции.ДатаПоБанку 		= Дата;
	СтрокаТранзакции.Сумма 				= Модуль(Сумма);
	СтрокаТранзакции.Содержание 		= МассивПоказателей[11];
	СтрокаТранзакции.КраткоеСодержание	= МассивПоказателей[9];
	СтрокаТранзакции.ИдентификаторКорреспондента = МассивПоказателей[10];
	СтрокаТранзакции.КодВалюты 			= МассивПоказателей[5];
	СтрокаТранзакции.ИдентификаторТранзакции = СтрокаТранзакции.КодВалюты + Строка(СтрокаТранзакции.ДатаПоБанку) 
											+ Строка(СтрокаТранзакции.Сумма);
									
КонецПроцедуры

#КонецОбласти

#КонецОбласти