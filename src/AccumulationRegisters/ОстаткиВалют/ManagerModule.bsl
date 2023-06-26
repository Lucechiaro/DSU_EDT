
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ОтразитьПоступлениеВалюты(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПеремещениеДенежныхСредств") 
		И ДокументОбъект.ВалютаНазначения <> ОбщийПовтИсп.ОсновнаяВалютаУчета() Тогда
		
		Сумма 	= ДокументОбъект.СуммаНазначения;
		Валюта 	= ДокументОбъект.ВалютаНазначения;
		КурсОперации = ДокументОбъект.Курс /  ДокументОбъект.Кратность;
				
		Если ДокументОбъект.Валюта = ОбщийПовтИсп.ОсновнаяВалютаУчета() Тогда
			СуммаУчетная = ДокументОбъект.Сумма;
		Иначе
			СуммаУчетная = ПолучитьУчетнуюСуммуИзНабораЗаписей(ДокументОбъект.Движения.ОстаткиВалют,
																ВидДвиженияНакопления.Расход);
		КонецЕсли;	
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПриходДенежныхСредств") 
		И ДокументОбъект.Валюта <> ОбщийПовтИсп.ОсновнаяВалютаУчета() Тогда 	
		
		Сумма 			= ДокументОбъект.Сумма;
		Валюта 			= ДокументОбъект.Валюта;
		СуммаУчетная 	= ДокументОбъект.Сумма * ДокументОбъект.Курс / ДокументОбъект.Кратность;
		КурсОперации 	= ДокументОбъект.Курс /  ДокументОбъект.Кратность;
		
	Иначе
			
		Возврат;	
		
	КонецЕсли;	
	
	ОстаткиВалют = ДокументОбъект.Движения.ОстаткиВалют;
	
	Запись = ОстаткиВалют.ДобавитьПриход();
	Запись.Период 		= ДокументОбъект.Дата;
	Запись.Валюта 		= Валюта;
	Запись.Сумма 		= Сумма;
	Запись.СуммаУчетная = СуммаУчетная;
	Запись.ВзвешенныйКурс 	= Окр(СуммаУчетная / Сумма, 2);
	Запись.КурсОперации = Окр(КурсОперации, 2);
	Запись.УчетныйКурс 	= ОбщийПовтИсп.КурсВалюты(Валюта, ДокументОбъект.Дата).КурсККратности;
	
	ОстаткиВалют.Записывать = Истина;

КонецПроцедуры

Процедура ОтразитьСписаниеВалюты(ДокументОбъект) Экспорт
	
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПеремещениеДенежныхСредств") 
		И ДокументОбъект.Валюта <> ОбщийПовтИсп.ОсновнаяВалютаУчета() Тогда
		
		Сумма 	= ДокументОбъект.Сумма;
		Валюта 	= ДокументОбъект.Валюта;
		КурсОперации = ДокументОбъект.Курс /  ДокументОбъект.Кратность;
	
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.РасходДенежныхСредств") 
		И ДокументОбъект.Валюта <> ОбщийПовтИсп.ОсновнаяВалютаУчета() Тогда 	
		
		Сумма 	= ДокументОбъект.Сумма;
		Валюта 	= ДокументОбъект.Валюта;
		КурсОперации = ДокументОбъект.Курс /  ДокументОбъект.Кратность;
		
	Иначе
			
		Возврат;	
		
	КонецЕсли;
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ОстаткиВалют");
		ЭлементБлокировки.УстановитьЗначение("Валюта", Валюта);
		Блокировка.Заблокировать();
		
	Исключение
		
		ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначения.СообщитьПользователю("Не удалось провести списание валюты!");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);		
		Возврат;
		
	КонецПопытки;

	СуммаУчетная = ПолучитьУчетнуюСуммуОстатка(ДокументОбъект.МоментВремени(), Валюта, Сумма);
	
	НаборЗаписей = ДокументОбъект.Движения.ОстаткиВалют;
	
	Запись = НаборЗаписей.ДобавитьРасход();
	Запись.Период 		= ДокументОбъект.Дата;
	Запись.Валюта 		= Валюта;
	Запись.Сумма 		= Сумма;
	Запись.СуммаУчетная = СуммаУчетная;
	Запись.ВзвешенныйКурс 	= Окр(СуммаУчетная / Сумма, 2);
	Запись.КурсОперации = Окр(КурсОперации, 2);
	Запись.УчетныйКурс 	= ОбщийПовтИсп.КурсВалюты(Валюта, ДокументОбъект.Дата).КурсККратности;
	
	НаборЗаписей.Записывать = Истина;

КонецПроцедуры	

Функция ПолучитьУчетнуюСуммуИзНабораЗаписей(НаборЗаписей, ВидДвижения) Экспорт
	
	СуммаУчетная = 0;
	
	Для Каждого Запись Из НаборЗаписей Цикл
		
		Если Запись.ВидДвижения = ВидДвижения Тогда
			
			СуммаУчетная = Запись.СуммаУчетная;
			Прервать;
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат СуммаУчетная;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьУчетнуюСуммуОстатка(МоментВремени, Валюта, СуммаВВалюте)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОстаткиВалютОстатки.СуммаОстаток,
	|	ОстаткиВалютОстатки.СуммаУчетнаяОстаток
	|ИЗ
	|	РегистрНакопления.ОстаткиВалют.Остатки(&Граница, Валюта = &Валюта) КАК ОстаткиВалютОстатки";
	Запрос.УстановитьПараметр("Граница", Новый Граница(МоментВремени,  ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Валюта", 	Валюта);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		УчетнаяСумма = 0;
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.СуммаОстаток > СуммаВВалюте Тогда
			УчетнаяСумма = Окр(Выборка.СуммаУчетнаяОстаток * СуммаВВалюте / Выборка.СуммаОстаток, 2);
		Иначе
			УчетнаяСумма = Выборка.СуммаУчетнаяОстаток;	
		КонецЕсли;		
			
	КонецЕсли;
			
	Возврат УчетнаяСумма;	
	
КонецФункции

#КонецОбласти

#КонецЕсли

