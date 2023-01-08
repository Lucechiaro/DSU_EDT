#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода 		= НачалоНедели(ТекущаяДатаСеанса());
	ОкончаниеПериода 	= КонецНедели(ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Счет) Тогда
		ЗаполнитьТаблицуШаблонов();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	ЗаполнитьТаблицуШаблонов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоДокументов

&НаКлиенте
Процедура ДеревоДокументовПроведенПриИзменении(Элемент)
	
	Если Не ДанныеСтрокиЗаполненыКорректно(Элементы.ДеревоДокументов.ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;	
	
	ПриИзмененииСтрокиНаСервере(Элементы.ДеревоДокументов.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыписку(Команда)
	
	ПараметрыФормы = Новый Структура("Счет", Счет);
	ОткрытьФорму("ОбщаяФорма.ЗагрузкаВыпискиБанка", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	БанковскаяТранзакция.Дата,
	|	БанковскаяТранзакция.Ссылка,
	|	БанковскаяТранзакция.Валюта,
	|	БанковскаяТранзакция.ВидДвижения,
	|	БанковскаяТранзакция.Содержание,
	|	БанковскаяТранзакция.Сумма,
	|	БанковскаяТранзакция.ИдентификаторКорреспондента,
	|	БанковскаяТранзакция.КраткоеСодержание КАК КраткоеСодержаниеТранзакции,
	|	БанковскаяТранзакция.Содержание КАК СодержаниеТранзакции
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
	|	РасходДенежныхСредств.Дата,
	|	РасходДенежныхСредств.ПометкаУдаления,
	|	РасходДенежныхСредств.Проведен,
	|	РасходДенежныхСредств.Ссылка,
	|	РасходДенежныхСредств.СтатьяДДС,
	|	РасходДенежныхСредств.Валюта,
	|	РасходДенежныхСредств.Сумма,
	|	РасходДенежныхСредств.Курс,
	|	РасходДенежныхСредств.Кратность,
	|	РасходДенежныхСредств.Комментарий,
	|	РасходДенежныхСредств.БанковскаяТранзакция,
	|	ЗНАЧЕНИЕ(Перечисление.ВидДвиженияДС.Расход) Как ВидДвижения
	|Поместить СуществующиеДокументы
	|ИЗ
	|	Документ.РасходДенежныхСредств КАК РасходДенежныхСредств
	|ГДЕ
	|	РасходДенежныхСредств.Счет = &Счет
	|	И РасходДенежныхСредств.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И Не РасходДенежныхСредств.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПриходДенежныхСредств.Дата,
	|	ПриходДенежныхСредств.ПометкаУдаления,
	|	ПриходДенежныхСредств.Проведен,
	|	ПриходДенежныхСредств.Ссылка,
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
	|	ПриходДенежныхСредств.Счет = &Счет
	|	И ПриходДенежныхСредств.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И НЕ ПриходДенежныхСредств.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПеремещениеДенежныхСредств.Дата,
	|	ПеремещениеДенежныхСредств.ПометкаУдаления,
	|	ПеремещениеДенежныхСредств.Проведен,
	|	ПеремещениеДенежныхСредств.Ссылка,
	|	ПеремещениеДенежныхСредств.СтатьяДДС,
	|	ПеремещениеДенежныхСредств.ВалютаНазначения,
	|	ПеремещениеДенежныхСредств.СуммаНазначения,
	|	ПеремещениеДенежныхСредств.Курс,
	|	ПеремещениеДенежныхСредств.Кратность,
	|	ПеремещениеДенежныхСредств.Комментарий,
	|	ПеремещениеДенежныхСредств.ТранзакцияПрихода,
	|	ЗНАЧЕНИЕ(Перечисление.ВидДвиженияДС.Доход)
	|ИЗ
	|	Документ.ПеремещениеДенежныхСредств КАК ПеремещениеДенежныхСредств
	|ГДЕ
	|	ПеремещениеДенежныхСредств.СчетНазначения = &Счет
	|	И ПеремещениеДенежныхСредств.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И Не ПеремещениеДенежныхСредств.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПеремещениеДенежныхСредств.Дата,
	|	ПеремещениеДенежныхСредств.ПометкаУдаления,
	|	ПеремещениеДенежныхСредств.Проведен,
	|	ПеремещениеДенежныхСредств.Ссылка,
	|	ПеремещениеДенежныхСредств.СтатьяДДС,
	|	ПеремещениеДенежныхСредств.Валюта,
	|	ПеремещениеДенежныхСредств.Сумма,
	|	ПеремещениеДенежныхСредств.Курс,
	|	ПеремещениеДенежныхСредств.Кратность,
	|	ПеремещениеДенежныхСредств.Комментарий,
	|	ПеремещениеДенежныхСредств.ТранзакцияРасхода,
	|	ЗНАЧЕНИЕ(Перечисление.ВидДвиженияДС.Расход)
	|ИЗ
	|	Документ.ПеремещениеДенежныхСредств КАК ПеремещениеДенежныхСредств
	|ГДЕ
	|	ПеремещениеДенежныхСредств.Счет = &Счет
	|	И ПеремещениеДенежныхСредств.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И Не ПеремещениеДенежныхСредств.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Транзакции.Дата,
	|	Ложь Как ПометкаУдаления,
	|	Ложь Как Проведен,
	|	Неопределено Как Документ,
	|	Неопределено Как СтатьяДДС,
	|	Транзакции.Валюта Как Валюта,
	|	Транзакции.Сумма Как Сумма,
	|	1 Как Курс,
	|	1 Как Кратность,
	|	Транзакции.Содержание Как Комментарий,
	|	Транзакции.Ссылка Как БанковскаяТранзакция,
	|	Транзакции.ВидДвижения,
	|	Транзакции.Дата Как ДатаТранзакции,
	|	Транзакции.ИдентификаторКорреспондента,
	|	Транзакции.КраткоеСодержаниеТранзакции,
	|	Транзакции.СодержаниеТранзакции
	|ИЗ
	|	Транзакции КАК Транзакции
	|		ЛЕВОЕ СОЕДИНЕНИЕ СуществующиеДокументы КАК СуществующиеДокументы
	|		ПО Транзакции.Ссылка = СуществующиеДокументы.БанковскаяТранзакция
	|ГДЕ
	|	СуществующиеДокументы.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СуществующиеДокументы.Дата,
	|	СуществующиеДокументы.ПометкаУдаления,
	|	СуществующиеДокументы.Проведен,
	|	СуществующиеДокументы.Ссылка,
	|	СуществующиеДокументы.СтатьяДДС,
	|	СуществующиеДокументы.Валюта,
	|	СуществующиеДокументы.Сумма,
	|	СуществующиеДокументы.Курс,
	|	СуществующиеДокументы.Кратность,
	|	СуществующиеДокументы.Комментарий,
	|	СуществующиеДокументы.БанковскаяТранзакция,
	|	СуществующиеДокументы.ВидДвижения,
	|	ЕстьNull(Транзакции.Дата, СуществующиеДокументы.Дата),
	|	"""",
	|	"""",
	|	""""
	|ИЗ
	|	СуществующиеДокументы КАК СуществующиеДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Транзакции
	|		По СуществующиеДокументы.БанковскаяТранзакция = Транзакции.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаТранзакции";
	Запрос.УстановитьПараметр("Счет", 				Счет);
	Запрос.УстановитьПараметр("НачалоПериода", 		НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", 	ОкончаниеПериода);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДеревоДокументов.ПолучитьЭлементы().Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		Ветвь = ДеревоДокументов.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(Ветвь, Выборка, , "Проведен");
		
		Если ЗначениеЗаполнено(Выборка.Документ) И Выборка.Проведен Тогда
			Ветвь.Проведен = Истина;
		КонецЕсли;	
		
		ЗаполнитьДанныеПоШаблонам(Ветвь);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСтрокиНаСервере(ТекущаяСтрокаДерева)
	
	ТекущиеДанные = ДеревоДокументов.НайтиПоИдентификатору(ТекущаяСтрокаДерева);
	
	Если ТекущиеДанные.Проведен Тогда
		СоздатьОбновитьДокумент(ТекущиеДанные);
	Иначе
		УдалитьДокумент(ТекущиеДанные);	
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура СоздатьОбновитьДокумент(ТекущиеДанные)
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Документ) Тогда
		ДокументОбъект = ПолучитьНовыйДокумент(ТекущиеДанные);
	Иначе	
		ДокументОбъект = ТекущиеДанные.Документ.ПолучитьОбъект();
	КонецЕсли;	
	
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ТекущиеДанные);
	ДокументОбъект.Дата = ТекущиеДанные.ДатаТранзакции;
	ДокументОбъект.Счет = Счет; 
	
	Попытка
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
		ТекущиеДанные.Документ = ДокументОбъект.Ссылка;
		
	Исключение
		
		ТекущиеДанные.Проведен = Ложь;
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДокумент(ТекущиеДанные)
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Документ) Тогда
		
		ДокументОбъект = ТекущиеДанные.Документ.ПолучитьОбъект();
		ДокументОбъект.УстановитьПометкуУдаления(Истина);
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьНовыйДокумент(ДанныеДокумента)
	
	Если ДанныеДокумента.ВидДвижения = ПредопределенноеЗначение("Перечисление.ВидДвиженияДС.Доход") Тогда
		Возврат Документы.ПриходДенежныхСредств.СоздатьДокумент();
	Иначе
		Возврат Документы.РасходДенежныхСредств.СоздатьДокумент();
	КонецЕсли;		
	
КонецФункции

&НаКлиенте
Функция ДанныеСтрокиЗаполненыКорректно(ДанныеСтроки)
	
	ДанныеЗаполненыКорректно = Истина;
	
	Если Не ЗначениеЗаполнено(ДанныеСтроки.СтатьяДДС) Тогда
		
		Сообщить("Укажите статью!");
		ДанныеЗаполненыКорректно = Ложь;
				
	КонецЕсли;	
	
	Возврат ДанныеЗаполненыКорректно; 
	
КонецФункции	

&НаСервере
Процедура ЗаполнитьТаблицуШаблонов()
	
	Шаблоны.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	""ИдентификаторКорреспондента"" КАК ВидШаблона,
	               |	ШаблоныРазбораБанковскойВыписки.ИдентификаторКорреспондента КАК ИдентификаторКорреспондента,
	               |	"""" КАК Слово,
	               |	ШаблоныРазбораБанковскойВыписки.СтатьяДДС КАК СтатьяДДС,
	               |	ШаблоныРазбораБанковскойВыписки.УстанавливаемыйКомментарий КАК Комментарий
	               |ИЗ
	               |	Справочник.ШаблоныРазбораБанковскойВыписки КАК ШаблоныРазбораБанковскойВыписки
	               |ГДЕ
	               |	ШаблоныРазбораБанковскойВыписки.Владелец = &Владелец
	               |	И ШаблоныРазбораБанковскойВыписки.ИдентификаторКорреспондента <> """"
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	""КлючевоеСлово"",
	               |	"""",
	               |	ШаблоныРазбораБанковскойВыпискиКлючевыеСлова.Слово,
	               |	ШаблоныРазбораБанковскойВыписки.СтатьяДДС,
	               |	ШаблоныРазбораБанковскойВыписки.УстанавливаемыйКомментарий
	               |ИЗ
	               |	Справочник.ШаблоныРазбораБанковскойВыписки.КлючевыеСлова КАК ШаблоныРазбораБанковскойВыпискиКлючевыеСлова
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШаблоныРазбораБанковскойВыписки КАК ШаблоныРазбораБанковскойВыписки
	               |		ПО ШаблоныРазбораБанковскойВыпискиКлючевыеСлова.Ссылка = ШаблоныРазбораБанковскойВыписки.Ссылка
	               |ГДЕ
	               |	ШаблоныРазбораБанковскойВыписки.Владелец = &Владелец
	               |	И ШаблоныРазбораБанковскойВыпискиКлючевыеСлова.Слово <> """"
				   |";
	Запрос.УстановитьПараметр("Владелец", Счет);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Шаблоны.Добавить(), Выборка);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоШаблонам(СтрокаДанных)
	
	Если Не ЗначениеЗаполнено(СтрокаДанных.Документ) Тогда
		
		Для Каждого СтрокаШаблона Из Шаблоны Цикл
			
			Если СтрСравнить(СтрокаШаблона.ВидШаблона, "ИдентификаторКорреспондента") = 0 
				И СтрСравнить(СтрокаШаблона.ИдентификаторКорреспондента, СтрокаДанных.ИдентификаторКорреспондента) = 0 Тогда
				
				ПеренестиДанныеИзШаблонаВПлатеж(СтрокаДанных, СтрокаШаблона);
				Прервать;
				
			ИначеЕсли СтрСравнить(СтрокаШаблона.ВидШаблона, "КлючевоеСлово") = 0 Тогда
				
				Если СтрНайти(СтрокаДанных.СодержаниеТранзакции, СтрокаШаблона.Слово) <> 0 
					Или СтрНайти(СтрокаДанных.КраткоеСодержаниеТранзакции, СтрокаШаблона.Слово) <> 0 Тогда	
						
					ПеренестиДанныеИзШаблонаВПлатеж(СтрокаДанных, СтрокаШаблона);
					Прервать;	
						
				КонецЕсли;
						
			КонецЕсли;	 
			
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ПеренестиДанныеИзШаблонаВПлатеж(СтрокаДанных, СтрокаШаблона)
	
	СтрокаДанных.СтатьяДДС = СтрокаШаблона.СтатьяДДС;
	
	Если Не ПустаяСтрока(СтрокаШаблона.Комментарий) Тогда
		СтрокаДанных.Комментарий = СтрокаШаблона.Комментарий;
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти