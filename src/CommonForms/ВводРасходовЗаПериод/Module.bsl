
&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

Процедура ОбновитьНаСервере()
	
	// заполним существующими документами по счёту
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	БанковскаяТранзакция.Ссылка,
	|	БанковскаяТранзакция.Дата,
	|	БанковскаяТранзакция.КраткоеСодержание,
	|	БанковскаяТранзакция.Содержание,
	|	БанковскаяТранзакция.ВидДвижения,
	|	БанковскаяТранзакция.Валюта,
	|	БанковскаяТранзакция.Сумма
	|ПОМЕСТИТЬ Транзакции
	|ИЗ
	|	Документ.БанковскаяТранзакция КАК БанковскаяТранзакция
	|ГДЕ
	|	БанковскаяТранзакция.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И БанковскаяТранзакция.Счет = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходДенежныхСредств.Ссылка,
	|	РасходДенежныхСредств.Дата,
	|	РасходДенежныхСредств.СтатьяДДС,
	|	РасходДенежныхСредств.Валюта,
	|	РасходДенежныхСредств.Сумма,
	|	РасходДенежныхСредств.Курс,
	|	РасходДенежныхСредств.Кратность,
	|	РасходДенежныхСредств.Комментарий,
	|	РасходДенежныхСредств.БанковскаяТранзакция,
	|	ЗНАЧЕНИЕ(Перечисление.ВидДвиженияДС.Расход) Как ВидДвижения
	|Поместить СуществующиеРасходы
	|ИЗ
	|	Документ.РасходДенежныхСредств КАК РасходДенежныхСредств
	|ГДЕ
	|	РасходДенежныхСредств.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И РасходДенежныхСредств.Счет = &Счет
	|
	|Объединить
	|
	|ВЫБРАТЬ
	|	ПриходДенежныхСредств.Ссылка,
	|	ПриходДенежныхСредств.Дата,
	|	ПриходДенежныхСредств.СтатьяДДС,
	|	ПриходДенежныхСредств.Валюта,
	|	ПриходДенежныхСредств.Сумма,
	|	ПриходДенежныхСредств.Курс,
	|	ПриходДенежныхСредств.Кратность,
	|	ПриходДенежныхСредств.Комментарий,
	|	ПриходДенежныхСредств.БанковскаяТранзакция,
	|	ЗНАЧЕНИЕ(Перечисление.ВидДвиженияДС.Доход)
	|ИЗ
	|	Документ.ПриходДенежныхСредств КАК ПриходДенежныхСредств
	|ГДЕ
	|	ПриходДенежныхСредств.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ПриходДенежныхСредств.Счет = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Неопределено Как Документ,
	|	Транзакции.ВидДвижения Как ВидДвижения,
	|	Транзакции.Дата,
	|	Неопределено Как Статья,
	|	Транзакции.Валюта,
	|	Транзакции.Сумма,
	|	1 Как Курс,
	|	1 Как Кратность,
	|	Транзакции.Содержание Как Комментарий,
	|	Транзакции.Ссылка Как БанковскаяТранзакция,
	|	Транзакции.Дата Как ДатаТранзакции
	|ИЗ
	|	Транзакции КАК Транзакции
	|		ЛЕВОЕ СОЕДИНЕНИЕ СуществующиеРасходы КАК СуществующиеРасходы
	|		ПО Транзакции.Ссылка = СуществующиеРасходы.БанковскаяТранзакция
	|ГДЕ
	|	СуществующиеРасходы.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СуществующиеРасходы.Ссылка,
	|	СуществующиеРасходы.ВидДвижения,
	|	СуществующиеРасходы.Дата,
	|	СуществующиеРасходы.СтатьяДДС,
	|	СуществующиеРасходы.Валюта,
	|	СуществующиеРасходы.Сумма,
	|	СуществующиеРасходы.Курс,
	|	СуществующиеРасходы.Кратность,
	|	СуществующиеРасходы.Комментарий,
	|	СуществующиеРасходы.БанковскаяТранзакция,
	|	ЕстьNull(Транзакции.Дата, СуществующиеРасходы.Дата)
	|ИЗ
	|	СуществующиеРасходы КАК СуществующиеРасходы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Транзакции КАК Транзакции
	|		ПО СуществующиеРасходы.БанковскаяТранзакция = Транзакции.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаТранзакции";
	Запрос.УстановитьПараметр("НачалоПериода", 		НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", 	ОкончаниеПериода);
	Запрос.УстановитьПараметр("Счет", 				Счет);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДеревоДокументов.ПолучитьЭлементы.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		Ветвь = ДеревоДокументов.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(Ветвь, Выборка);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыписку(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Счет", Счет);
	ОткрытьФорму("ОбщаяФорма.ЗагрузкаВыпискиБанка", ПараметрыФормы);
	
КонецПроцедуры
	

// документ без банковской транзакции запретим разбивать
