
&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьНаСервере();
		
КонецПроцедуры

Процедура СформироватьНаСервере()
	
	Результат.Очистить();
	
	ТабличныйДокументЛево = Новый ТабличныйДокумент;
	ТабличныйДокументПраво = Новый ТабличныйДокумент;
	
	СтатьяРасходов = Отчет.СтатьяРасходов;
	
	// подготовим данные по расходам
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РасходыОбороты.СуммаОборот КАК Сумма,
	               |	РасходыОбороты.Период КАК Период,
	               |	ВЫБОР
	               |		КОГДА &НачалоПериода > РасходыОбороты.Период
	               |			ТОГДА &НачалоПериода
	               |		ИНАЧЕ РасходыОбороты.Период
	               |	КОНЕЦ КАК НачалоПериода,
	               |	ВЫБОР
	               |		КОГДА &КонецПериода < КОНЕЦПЕРИОДА(РасходыОбороты.Период, МЕСЯЦ)
	               |			ТОГДА &КонецПериода
	               |		ИНАЧЕ КОНЕЦПЕРИОДА(РасходыОбороты.Период, МЕСЯЦ)
	               |	КОНЕЦ КАК КонецПериода,
	               |	ВЫБОР
	               |		КОГДА &НачалоПериода <= НАЧАЛОПЕРИОДА(РасходыОбороты.Период, МЕСЯЦ)
	               |				И &КонецПериода >= КОНЕЦПЕРИОДА(РасходыОбороты.Период, МЕСЯЦ)
	               |			ТОГДА 1
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК МножительПолногоМесяца,
	               |	ВЫБОР
	               |		КОГДА &НачалоПериода <= НАЧАЛОПЕРИОДА(РасходыОбороты.Период, МЕСЯЦ)
	               |				И &КонецПериода >= КОНЕЦПЕРИОДА(РасходыОбороты.Период, МЕСЯЦ)
	               |			ТОГДА 1
	               |		ИНАЧЕ 0
	               |	КОНЕЦ * РасходыОбороты.СуммаОборот КАК СуммаПолногоМесяца
	               |ИЗ
	               |	РегистрНакопления.Расходы.Обороты(&НачалоПериода, &КонецПериода, Месяц, СтатьяДДС В ИЕРАРХИИ (&СтатьяРасходов)) КАК РасходыОбороты
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	Запрос.УстановитьПараметр("НачалоПериода", Отчет.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", Отчет.КонецПериода);
	Запрос.УстановитьПараметр("СтатьяРасходов", СтатьяРасходов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	Макет = ОтчетОбъект.ПолучитьМакет("Макет");
	ОбластьДиаграмма = Макет.ПолучитьОбласть("ОбластьДиаграммы|ОбластьДиаграммаВертикаль");
	Диаграмма = ОбластьДиаграмма.Рисунки.Диаграмма.Объект;
	
	ОбластьШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|ОбластьТаблицаВертикаль");
	ОбластьСтрока = Макет.ПолучитьОбласть("СтрокаТаблицы|ОбластьТаблицаВертикаль");
	ОбластьПодвал = Макет.ПолучитьОбласть("ПодвалТаблицы|ОбластьТаблицаВертикаль");
	
	ТабличныйДокументПраво.Вывести(ОбластьШапка);
	
	Диаграмма.КоличествоСерий = 1;
	Серия = Диаграмма.Серии[0];
	Серия.Текст = ?(ЗначениеЗаполнено(СтатьяРасходов), СтатьяРасходов.Наименование, "Все расходы");
	
	Диаграмма.КоличествоТочек = 0;
	ИндексТочки = -1;
	
	СуммаИтог = 0;
	СуммаПолныхМесяцев = 0;
	КоличествоПолныхМесяцев = 0;
	
	Пока Выборка.Следующий() Цикл
		
		ПредставлениеПериода = Формат(Выборка.Период,"ДФ='MMММ ггг'" );
		
		ПараметрРасшифровки = Новый Структура;
		ПараметрРасшифровки.Вставить("СтатьяРасходов", Отчет.СтатьяРасходов);
		ПараметрРасшифровки.Вставить("НачалоПериода", Выборка.НачалоПериода);
		ПараметрРасшифровки.Вставить("КонецПериода", Выборка.КонецПериода);
		
		ИндексТочки = ИндексТочки + 1;
		Диаграмма.КоличествоТочек = ИндексТочки + 1;
		Диаграмма.УстановитьЗначение(ИндексТочки, 0, Выборка.Сумма, ПараметрРасшифровки, Выборка.Сумма);
		Диаграмма.Точки[ИндексТочки].Текст = Формат(Выборка.Период,"ДФ='MMММ ггг'" );
		
		ОбластьСтрока.Параметры.Период = ПредставлениеПериода;
		ОбластьСтрока.Параметры.Сумма = Выборка.Сумма;
		ОбластьСтрока.Параметры.ПараметрРасшифровки = ПараметрРасшифровки;
		ТабличныйДокументПраво.Вывести(ОбластьСтрока);
		
		СуммаИтог = СуммаИтог + Выборка.Сумма;
		СуммаПолныхМесяцев = СуммаПолныхМесяцев + Выборка.СуммаПолногоМесяца;
		КоличествоПолныхМесяцев = КоличествоПолныхМесяцев + Выборка.МножительПолногоМесяца;
		
	КонецЦикла;	
	
	ОбластьПодвал.Параметры.СуммаИтог = СуммаИтог;
	ОбластьПодвал.Параметры.СреднееЗаПолныйМесяц = ?(КоличествоПолныхМесяцев = 0, 0, СуммаПолныхМесяцев/КоличествоПолныхМесяцев);
	ТабличныйДокументПраво.Вывести(ОбластьПодвал);
	
	ТабличныйДокументЛево.Вывести(ОбластьДиаграмма);
	
	// делаем именно так для того, чтобы правый табличный документ корректно пристыковался справа к левому табличному документу
	// методика взята с форума mista.ru
	Результат.Вывести(ТабличныйДокументЛево.ПолучитьОбласть(1, 1, ТабличныйДокументЛево.ВысотаТаблицы, ТабличныйДокументЛево.ШиринаТаблицы));
	Результат.Присоединить(ТабличныйДокументПраво.ПолучитьОбласть(1, 1, ТабличныйДокументПраво.ВысотаТаблицы, ТабличныйДокументПраво.ШиринаТаблицы));
	
КонецПроцедуры	

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СформироватьОтчетПоДетализации(Расшифровка.НачалоПериода, Расшифровка.КонецПериода, Отчет.СтатьяРасходов);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетПоДетализации(НачалоПериода, КонецПериода, СтатьяДДС)
	
	ПараметрыРасшифровки = Новый Структура();
	ПараметрыРасшифровки.Вставить("НачалоПериода", НачалоПериода);
	ПараметрыРасшифровки.Вставить("КонецПериода", КонецПериода);
	ПараметрыРасшифровки.Вставить("СтатьяДДС", СтатьяДДС);
	ПараметрыРасшифровки.Вставить("РазворачиватьГруппировки", Истина);
	
	ОткрытьФорму("Отчет.РасходыЗаПериод.Форма", Новый Структура("Расшифровка", ПараметрыРасшифровки), , Истина);
	
КонецПроцедуры


