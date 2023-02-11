#Область ОписаниеПеременных

&НаКлиенте
Перем ДниНедели;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ДокументКомиссии) Тогда
		НаличиеКомиссии = Объект.ДокументКомиссии.Проведен;
		ЗаполнитьРеквизитыКомисииИзДокументаРасхода();
	Иначе
		КурсКомиссии = 1;
		КратностьКомиссии = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьРеквизитовКомиссии();
	
	ДниНедели = ОбщегоНазначенияКлиент.ПолучитьСоответствиеДнейНедели();
	ОбщегоНазначенияКлиент.ОбновитьНадписьДеньНедели(Элементы.ДеньНедели, ДниНедели, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если (Объект.УчитыватьВДоходах Или Объект.УчитыватьВРасходах) И Не ЗначениеЗаполнено(Объект.СтатьяДДС) Тогда
		
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Не заполнена статья движения!");
				
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	 // создадим документ
	Если НаличиеКомиссии Тогда
		
		// получим объект у существующей ссылки или создадим новый объект
		Если Не ЗначениеЗаполнено(ТекущийОбъект.ДокументКомиссии) Тогда
			ДокументКомиссии = Документы.РасходДенежныхСредств.СоздатьДокумент();
			ДокументКомиссии.Дата = ТекущийОбъект.Дата;
			ДокументКомиссии.СтатьяДДС = Справочники.СтатьиДДС.Комиссия;
			ДокументКомиссии.Записать();
			ТекущийОбъект.ДокументКомиссии = ДокументКомиссии.Ссылка;
		Иначе
			ДокументКомиссии = ТекущийОбъект.ДокументКомиссии.ПолучитьОбъект();
		КонецЕсли;	        
		
		// перепишем в него все данные из формы
		ЗаполнитьДокументРасходаИзРеквизитовКомиссии(ДокументКомиссии);
		                   
		// запишем/проведем документ
		ЗаписатьДокументКомиссии(ДокументКомиссии);

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаличиеКомиссииПриИзменении(Элемент)
	
	ПриИзменииФлагаНаличиеКомиссии();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументКомиссииПриИзменении(Элемент)
	
	ПриИзмененииДокументаКомиссии();	
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиент.ОбновитьНадписьДеньНедели(Элементы.ДеньНедели, ДниНедели, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзменииФлагаНаличиеКомиссии()
	
	ОбновитьДоступностьРеквизитовКомиссии();
	
	Если ЗначениеЗаполнено(Объект.ДокументКомиссии) Тогда
		ЗаписатьДокументКомиссии(Объект.ДокументКомиссии.ПолучитьОбъект());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьРеквизитовКомиссии()
	
	Элементы.ДанныеКомиссии.Доступность = НаличиеКомиссии;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДокументКомиссии(ДокументКомиссии)
	
	Если ДокументКомиссии.ПометкаУдаления Тогда
		ДокументКомиссии.УстановитьПометкуУдаления(Ложь);
	КонецЕсли;
			
	ДокументКомиссии.Записать(?(НаличиеКомиссии И Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.ОтменаПроведения), РежимПроведенияДокумента.Неоперативный);
		
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьРеквизитыКомисииИзДокументаРасхода()
	
	КурсКомиссии 	= Объект.ДокументКомиссии.Курс;
	КратностьКомиссии = Объект.ДокументКомиссии.Кратность;
	ВалютаКомиссии 	= Объект.ДокументКомиссии.Валюта;
	СчетКомиссии 	= Объект.ДокументКомиссии.Счет;
	СуммаКомиссии 	= Объект.ДокументКомиссии.Сумма;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументРасходаИзРеквизитовКомиссии(ДокументРасхода)
	
	ДокументРасхода.Курс 		= КурсКомиссии;
	ДокументРасхода.Кратность 	= КратностьКомиссии;
	ДокументРасхода.Валюта 		= ВалютаКомиссии;
	ДокументРасхода.Счет 		= СчетКомиссии;
	ДокументРасхода.Сумма 		= СуммаКомиссии;
	
КонецПроцедуры	

&НаСервере
Процедура ПриИзмененииДокументаКомиссии()
	
	НаличиеКомиссии = ЗначениеЗаполнено(Объект.ДокументКомиссии);   
	ОбновитьДоступностьРеквизитовКомиссии();
	ЗаполнитьРеквизитыКомисииИзДокументаРасхода();
	
КонецПроцедуры

#КонецОбласти
