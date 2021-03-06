﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдра) Экспорт
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОбъектовМетаданных = СтруктураОбъектовМетаданных(ОтборПоПрефиксу, ПрефиксОбъектов);
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		Если ЭлементСтруктурыОбъектовМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ЭлементСтруктурыОбъектовМетаданных.Ключ, Истина);
		Для Каждого СтруктураОбъектаМетаданных Из ЭлементСтруктурыОбъектовМетаданных.Значение Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьУстаревшийТипДанных", 
				НаборТестов.ПараметрыТеста(СтруктураОбъектаМетаданных.ПолноеИмя), 
				СтруктураОбъектаМетаданных.ИмяТеста);
		КонецЦикла;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоПрефиксу = Ложь;
	ПропускатьОбъектыСПрефиксомУдалить = Ложь;
	ПрефиксОбъектов = "";
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Настройки.Свойство("Параметры") И Настройки["Параметры"].Свойство("ПропускатьОбъектыСПрефиксомУдалить") Тогда
		ПропускатьОбъектыСПрефиксомУдалить = Настройки["Параметры"].ПропускатьОбъектыСПрефиксомУдалить;
	КонецЕсли;
	
	Если Настройки.Свойство("Параметры") И Настройки.Параметры.Свойство("Префикс") Тогда
		ПрефиксОбъектов = Настройки.Параметры.Префикс;		
	КонецЕсли;
		
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки[ИмяТеста()].ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("НеПроверятьДополнительныеРеквизиты") Тогда
		НеПроверятьДополнительныеРеквизиты = Настройки[ИмяТеста()].НеПроверятьДополнительныеРеквизиты;
	КонецЕсли;
	
	Если Настройки.Свойство(ИмяТеста()) И Настройки[ИмяТеста()].Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)
		
	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки[ИмяТеста()].ИсключенияИзПроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьУстаревшийТипДанных(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	
	Результат = ПроверитьУстаревшийТипДанных(ПолноеИмяМетаданных);
	Если Результат <> "" И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ПропускатьТест.ТекстСообщения);
	Иначе
		Утверждения.Проверить(Результат = "", ТекстСообщения(ПолноеИмяМетаданных, Результат));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьУстаревшийТипДанных(ПолноеИмяМетаданных)
	
	Результат = "";
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	ПрефиксИмени = "УДАЛИТЬ";
	ПрефиксСинонима = "(не используется)";
		
	Если Лев(ВРег(ОбъектМетаданных.Имя), СтрДлина(ПрефиксИмени)) <> ПрефиксИмени Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ", ", "");
		Результат = Результат + Разделитель + НСтр("ru = 'имя не содержит префикса ""Удалить""'");
	КонецЕсли;	
	
	Если Лев(НРег(ОбъектМетаданных.Синоним), СтрДлина(ПрефиксСинонима)) <> ПрефиксСинонима Тогда
		Разделитель = ?(ЗначениеЗаполнено(Результат), ", ", "");
		Результат = Результат + Разделитель + НСтр("ru = 'синоним не содержит префикса ""(не используется)""'");
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
		
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных, Результат)

	ШаблонСообщения = НСтр("ru = 'Свойство ""%1"" : %2'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных, Результат);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция СтруктураОбъектовМетаданных(ОтборПоПрефиксу, ПрефиксОбъектов)
	
	МассивОбъектовМетаданных = МассивОбъектовМетаданных();
	СтроковыеУтилиты = СтроковыеУтилиты();
		
	СтруктураОбъектовМетаданных = Новый Структура;
	Для Каждого ЭлементСоответствия Из МассивОбъектовМетаданных Цикл
		СтруктураОбъектовМетаданных.Вставить(ЭлементСоответствия, Новый Массив);
	КонецЦикла;
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[ЭлементСтруктурыОбъектовМетаданных.Ключ] Цикл
				
			Параметры = Новый Структура;
			Параметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
			Параметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			Параметры.Вставить("ИмяМетаданных", ЭлементСтруктурыОбъектовМетаданных.Ключ);
			Параметры.Вставить("ОтборПоПрефиксу", ОтборПоПрефиксу);
			Параметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			Параметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);

			ОбработатьОбъектМетаданных(Параметры);
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "Измерения");
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "Ресурсы");
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "Реквизиты");
			ОбработатьЭлементыОбъектаМетаданных(Параметры, "РеквизитыАдресации");
			ОбработатьТабличныеЧастиОбъектаМетаданных(Параметры, "ТабличныеЧасти");
									
		КонецЦикла;
	КонецЦикла;
	
	Возврат СтруктураОбъектовМетаданных;

КонецФункции 

&НаСервереБезКонтекста
Процедура ОбработатьОбъектМетаданных(Параметры)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, "Тип") Тогда
		Возврат;
	КонецЕсли;
	
	ТипыДанных = ОбъектМетаданных.Тип.Типы();
	
	Если ТипыДанных.Количество() = 1 И СодержитУстаревшийТипДанных(ТипыДанных) Тогда
		
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
			Возврат;
		КонецЕсли;
		
		ДобавитьЭлементКоллекцииОбъектовМетаданных(
			СтроковыеУтилиты,
			СтруктураОбъектовМетаданных[ИмяМетаданных], 
			ОбъектМетаданных);
			
	КонецЕсли;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОбработатьТабличныеЧастиОбъектаМетаданных(Параметры, ИмяКоллекции)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		ВключитьВсеЭлементы = ОтборПоПрефиксу И ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов);
		
		мПараметры = Новый Структура;
		мПараметры.Вставить("ОбъектМетаданных", ЭлементКоллекции);
		мПараметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
		мПараметры.Вставить("ИмяМетаданных", ИмяМетаданных);
		мПараметры.Вставить("ОтборПоПрефиксу", ОтборПоПрефиксу И Не ВключитьВсеЭлементы);
		мПараметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
		мПараметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
		
		ОбработатьЭлементыОбъектаМетаданных(мПараметры, "Реквизиты");
							
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОбработатьЭлементыОбъектаМетаданных(Параметры, ИмяКоллекции)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ОтборПоПрефиксу = Параметры.ОтборПоПрефиксу;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		ТипыДанных = ЭлементКоллекции.Тип.Типы();
		Если ТипыДанных.Количество() = 1 И СодержитУстаревшийТипДанных(ТипыДанных) Тогда
			
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтроковыеУтилиты,
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ЭлементКоллекции);
				
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(СтроковыеУтилиты, Коллекция, ЭлементМетаданных)

	ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
				"%1 [%2]: %3", 
				ЭлементМетаданных.ПолноеИмя(),
				ЭлементМетаданных.Синоним,
				НСтр("ru = 'Проверка устаревших типов данных'"));
	
	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("ИмяТеста", ИмяТеста);
	СтруктураЭлемента.Вставить("ПолноеИмя", ЭлементМетаданных.ПолноеИмя());
	СтруктураЭлемента.Вставить("КоличествоТипов", ЭлементМетаданных.Тип.Типы().Количество());
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаСервереБезКонтекста
Функция СодержитУстаревшийТипДанных(ТипыДанных)

	Для Каждого ТипДанных Из ТипыДанных Цикл
		Если ЭтоУстаревшийТипДанных(ТипДанных) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция МассивОбъектовМетаданных()

	МассивОбъектовМетаданных = Новый Массив;
	                                 
	МассивОбъектовМетаданных.Добавить("ПараметрыСеанса");
	МассивОбъектовМетаданных.Добавить("ОбщиеРеквизиты");
	МассивОбъектовМетаданных.Добавить("ПланыОбмена");
	МассивОбъектовМетаданных.Добавить("КритерииОтбора");
	МассивОбъектовМетаданных.Добавить("ХранилищаНастроек");
	МассивОбъектовМетаданных.Добавить("Константы");
	МассивОбъектовМетаданных.Добавить("Справочники");
	МассивОбъектовМетаданных.Добавить("Документы");
	МассивОбъектовМетаданных.Добавить("ПланыВидовХарактеристик");
	МассивОбъектовМетаданных.Добавить("ПланыСчетов");
	МассивОбъектовМетаданных.Добавить("ПланыВидовРасчета");
	МассивОбъектовМетаданных.Добавить("РегистрыСведений");
	МассивОбъектовМетаданных.Добавить("РегистрыНакопления");
	МассивОбъектовМетаданных.Добавить("РегистрыБухгалтерии");
	МассивОбъектовМетаданных.Добавить("РегистрыРасчета");
	МассивОбъектовМетаданных.Добавить("БизнесПроцессы");
	МассивОбъектовМетаданных.Добавить("Задачи");
	МассивОбъектовМетаданных.Добавить("ВнешниеИсточникиДанных");
	
	Возврат МассивОбъектовМетаданных;

КонецФункции 

&НаСервереБезКонтекста
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоУстаревшийТипДанных(ТипДанных)
	
	МетаданныеПоТипу = Метаданные.НайтиПоТипу(ТипДанных);
	Если МетаданныеПоТипу <> Неопределено Тогда
		Возврат СтрНайти(ВРег(МетаданныеПоТипу.Имя), "УДАЛИТЬ");
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции

&НаСервере
Функция ИмяТеста()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Истина;
	ПутьНастройки = "Тесты";
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Параметры") 
		И Настройки.Параметры.Свойство(ИмяТеста()) Тогда
		ВыполнятьТест = Настройки.Параметры[ИмяТеста()];	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти