
Процедура ОбработкаПроведения(Отказ, Режим)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// курс и кратность - это курс и кратность валюты назначения
		
	Если ИнвертироватьКурс Тогда
		ПересчитаннаяСумма = Сумма / Курс * Кратность;
	Иначе
		ПересчитаннаяСумма = Сумма * Курс / Кратность;
	КонецЕсли;
	
	// движения по регистру "Остатки по счетам"
	ДвижениеРасход = Движения.ОстаткиПоСчетам.ДобавитьРасход();
	ЗаполнитьЗначенияСвойств(ДвижениеРасход, Ссылка);
	ДвижениеРасход.Сумма = Сумма;
	ДвижениеРасход.Период = Дата;
	
	ДвижениеПриход = Движения.ОстаткиПоСчетам.ДобавитьПриход();
	ДвижениеПриход.Счет = СчетНазначения;
	ДвижениеПриход.Валюта = ВалютаНазначения;
	ДвижениеПриход.Период = Дата;
	ДвижениеПриход.Сумма = СуммаНазначения;
	
	// движения по регистру "Планируемые покупки"
	Если ЗначениеЗаполнено(ПланируемаяПокупка) Тогда
		ДвижениеПП = Движения.ОстаткиПланируемыхПокупок.ДобавитьРасход();
		ДвижениеПП.Период = Дата;
		ДвижениеПП.ПланируемаяПокупка = ПланируемаяПокупка;
		ДвижениеПП.Сумма = ПересчитаннаяСумма;
	КонецЕсли;
	
	Если УчитыватьВРасходах Тогда
		
		ДвижениеРасходы = Движения.Расходы.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеРасходы, Ссылка);
		ДвижениеРасходы.СуммаУчетн = ПересчитаннаяСумма;	
		ДвижениеРасходы.Период = Дата;
		
	КонецЕсли;	
	
	Если УчитыватьВДоходах Тогда
		
		ДвижениеДоходы = Движения.Доходы.Добавить();
		ДвижениеДоходы.Валюта = ВалютаНазначения;
		ДвижениеДоходы.СтатьяДДС = СтатьяДДС;
		ДвижениеДоходы.Сумма = СуммаНазначения;
		ДвижениеДоходы.СуммаУчетн = ПересчитаннаяСумма;	
		ДвижениеДоходы.Период = Дата;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	

	// если распроводим документ перемещения, то принудительно распроводим документ комиссии
	Если ЗначениеЗаполнено(ДокументКомиссии) И ДокументКомиссии.Проведен Тогда
		
		ДокументКомиссииОбъект = ДокументКомиссии.ПолучитьОбъект();
		ДокументКомиссииОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ДокументКомиссии) Тогда
	     ДокументКомиссииОбъект = ДокументКомиссии.ПолучитьОбъект();
		 ДокументКомиссииОбъект.Записать(РежимЗаписи, РежимПроведения);
	 КонецЕсли;
	 
	Дата = НачалоДня(Дата);
	
КонецПроцедуры



