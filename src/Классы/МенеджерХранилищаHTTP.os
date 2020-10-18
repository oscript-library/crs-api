#Использовать 1connector
#Использовать xml-parser

Перем Адрес;
Перем Пользователь;
Перем ХешПароля;
Перем ВерсияПлатформы;

Перем ИмяХранилища;

Процедура ПриСозданииОбъекта(Знач АдресХранилища, Знач ВерсияПлатформыХранилища)
	Адрес = АдресХранилища;
	ВерсияПлатформы = ВерсияПлатформыХранилища; 
КонецПроцедуры

Процедура Подключиться(Знач ПользовательХранилища, Знач ПарольХранилища, Знач пИмяХранилища = "maincr") Экспорт
	Пользователь = Неопределено;
	ХешПароля = Неопределено;
	
	Хеш = ХешированныйПароль(ПарольХранилища);
	
	Параметры = Новый Структура;
	Параметры.Вставить("ИмяХранилища", пИмяХранилища);
	Параметры.Вставить("ВерсияПлатформы", ВерсияПлатформы);
	Параметры.Вставить("ПользовательХранилища", ПользовательХранилища);
	Параметры.Вставить("ХешПароляПользователя", Хеш);
	
	ТелоЗапроса = МенеджерЗапросов.ТелоЗапросаНаПодключение(Параметры);
	
	Ответ = КоннекторHTTP.Post(Адрес, ТелоЗапроса);
	Если Ответ.КодСостояния = 200 Тогда
		ОтветСервиса = ОбработкаXML.ПрочитатьОтветИзТекста(Ответ.Текст());
		
		Если ОтветСервиса.ЕстьОшибка Тогда
			Сообщить(ОтветСервиса.СодержаниеОшибки);
			Возврат;
		КонецЕсли;
		
		Пользователь = ПользовательХранилища;
		ХешПароля = Хеш;
	Иначе
		ВызватьИсключение(Ответ.Текст())
	КонецЕсли;	

	ИмяХранилища = пИмяХранилища;
КонецПроцедуры

Функция АвторизацияПройдена() Экспорт
	Возврат ЗначениеЗаполнено(ХешПароля);	
КонецФункции

Процедура СоздатьПользователя(Знач ИмяПользователя, Знач ПарольПользователя, Знач Права) Экспорт
	
	ИдентификаторПодключения = Новый УникальныйИдентификатор();
	ИдентификаторОперации = Новый УникальныйИдентификатор();
	
	ХешПароляПользвателя = ХешированныйПароль(ПарольПользователя);
	
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
	|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + ИмяХранилища + """ name=""UserManager_addUser"" version=""" + ВерсияПлатформы + """>
	|<crs:auth user=""" + Пользователь + """ password=""" + ХешПароля + """ />
	|<crs:bind bindID=""" + ИдентификаторПодключения + """ />
	|<crs:params>
	|<crs:user>
	|<crs:id value=""" + ИдентификаторОперации + """ />
	|<crs:name value=""" + ИмяПользователя + """ />
	|<crs:password value=""" + ХешПароляПользвателя + """ />
	|<crs:rights value=""" + Права + """ />
	|</crs:user>
	|</crs:params>
	|</crs:call>";
	
	Ответ = КоннекторHTTP.Post(Адрес, ТелоЗапроса);
	Результат = Ответ.Текст();
	
	Если Ответ.КодСостояния = 200 Тогда
		ОтветСервиса = ОбработкаXML.ПрочитатьОтветИзТекста(Результат);
		Если ОтветСервиса.ЕстьОшибка Тогда
			ВызватьИсключение(ОтветСервиса.СодержаниеОшибки);
		КонецЕсли;
	Иначе
		ВызватьИсключение(Результат);	
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиПользователя(Знач ИмяПользователя) Экспорт
	
	ИдентификаторПодключения = Новый УникальныйИдентификатор();
	
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
	|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + ИмяХранилища + """ name=""UserManager_depotUserByName"" version=""8.3.12.1855"">
	|<crs:auth user=""" + Пользователь + """ password=""" + ХешПароля + """ />
	|<crs:bind bindID=""" + ИдентификаторПодключения + """/>
	|<crs:params>
	|<crs:name value=""" + ИмяПользователя + """/>
	|</crs:params>
	|</crs:call>";
	
	Ответ = КоннекторHTTP.Post(Адрес, ТелоЗапроса);
	Результат = Ответ.Текст();
	
	Если Ответ.КодСостояния = 200 Тогда
		ОтветСервиса = ОбработкаXML.ПрочитатьОтветИзТекста(Результат);
		Если ОтветСервиса.ЕстьОшибка Тогда
			Сообщить(ОтветСервиса.СодержаниеОшибки);
			Возврат Неопределено;
		КонецЕсли;
		
		user = ОтветСервиса.РезультатЧтения["call_return"]["_Элементы"]["user"];
		НайденныйПользователь = Новый ПользовательХранилища();
		НайденныйПользователь.Заполнить(user);
		
		Возврат НайденныйПользователь;
		
	Иначе
		Сообщить(Результат);
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Структура = ПрочитатьПользователяИзXML(Результат);
	Исключение
		Сообщить("Не удалось прочитать данные пользователя. Причина: " + ОписаниеОшибки());
		Структура = Неопределено;
	КонецПопытки;
	Возврат Структура;
	
КонецФункции

Функция УдалитьПользователя(Знач ИдентификаторПользователя) Экспорт
	
	ИдентификаторПодключения = Новый УникальныйИдентификатор();
	
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
	|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + ИмяХранилища + """ name=""UserManager_removeUser"" version=""8.3.12.1855"">
	|<crs:auth user=""" + Пользователь + """ password=""" + ХешПароля + """ />
	|<crs:bind bindID=""" + ИдентификаторПодключения + """/>
	|<crs:params>
	|<crs:id value=""" + ИдентификаторПользователя + """/>
	|</crs:params>
	|</crs:call>";
	
	Сообщить(ТелоЗапроса);
	
	Ответ = КоннекторHTTP.Post(Адрес, ТелоЗапроса);
	Результат = Ответ.Текст();
	Сообщить(Результат);
	
КонецФункции

Функция СписокПользователей() Экспорт
	СписокПользователей = Новый Массив;
	
	ИдентификаторПодключения = Новый УникальныйИдентификатор();
	
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
	|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + ИмяХранилища + """ name=""DevDepot_devObjectsStatistic"" version=""" + ВерсияПлатформы + """>
	|<crs:auth user=""" + Пользователь + """ password=""" + ХешПароля + """ />
	|<crs:bind bindID=""" + ИдентификаторПодключения + """/>
	|<crs:params>
	|<crs:objRefs/>
	// фильтр
	|<crs:removed value=""true""/> 
	|</crs:params>
	|</crs:call>";
	
	Ответ = КоннекторHTTP.Post(Адрес, ТелоЗапроса);
	ТекстОтвета = Ответ.Текст();
	Если Ответ.КодСостояния = 200 Тогда
		
		ОтветСервиса = ОбработкаXML.ПрочитатьОтветИзТекста(ТекстОтвета);
		Если ОтветСервиса.ЕстьОшибка Тогда
			Сообщить(ОтветСервиса.СодержаниеОшибки);
			Возврат СписокПользователей;
		КонецЕсли;
		
		call_return = ОтветСервиса.РезультатЧтения.Получить("call_return");
		users = call_return._Элементы.Получить("users");
		Для Каждого user Из users Цикл
			
			Пользователь = Новый ПользовательХранилища;
			Пользователь.Заполнить(user["value"]["second"]);
			
			СписокПользователей.Добавить(Пользователь);
			
		КонецЦикла;
		
	Иначе
		Сообщить(ТекстОтвета);
	КонецЕсли;
	
	Возврат СписокПользователей;
	
КонецФункции

Функция ХешированныйПароль(Знач ВходящееЗначение)
	Данные = ПолучитьДвоичныеДанныеИзСтроки(ВходящееЗначение, КодировкаТекста.UTF16, Ложь);
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(Данные);
	Возврат НРег(ПолучитьHexСтрокуИзДвоичныхДанных(ХешированиеДанных.ХешСумма));
КонецФункции

Функция ПрочитатьПользователяИзXML(Данные)
	
	Структура = Новый Структура;
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	// ИмяФайла = "D:\DATA\Develop\Project\crs-helper\tests\tmp\sample.xml";
	
	ТД = Новый ТекстовыйДокумент();
	ТД.УстановитьТекст(Данные);
	ТД.Записать(ИмяФайла, "UTF-8");
	
	ПроцессорXML = Новый СериализацияДанныхXML();
	РезультатЧтения = ПроцессорXML.ПрочитатьИзФайла(ИмяФайла);
	ПользовательXML = РезультатЧтения["call_return"]["_Элементы"]["user"];
	Информация = ПользовательXML["info"];
	Для Каждого КлючЗначение Из Информация Цикл
		Если КлючЗначение.Ключ = "id" Тогда
			Структура.Вставить("Идентификатор", КлючЗначение.Значение["_Атрибуты"]["value"]);
		ИначеЕсли КлючЗначение.Ключ = "name" Тогда
			Структура.Вставить("Имя", КлючЗначение.Значение["_Атрибуты"]["value"]);
		ИначеЕсли КлючЗначение.Ключ = "password" Тогда
			Структура.Вставить("ХешПароля", КлючЗначение.Значение["_Атрибуты"]["value"]);
		ИначеЕсли КлючЗначение.Ключ = "rights" Тогда
			Структура.Вставить("Права", КлючЗначение.Значение["_Атрибуты"]["value"]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

Функция СписокВерсийХранилища(Фильтр) Экспорт
	
	ИдентификаторПодключения = Новый УникальныйИдентификатор();
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
	|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + ИмяХранилища + """ name=""DevDepot_devDepotVersions"" version=""" + ВерсияПлатформы + """>
	|<crs:auth user=""" + Пользователь + """ password=""" + ХешПароля + """ />
	|<crs:bind bindID=""" + ИдентификаторПодключения + """ />
	|<crs:params>
	|<crs:filter>
	|<crs:mask value=""0"" />
	|<crs:beginDate value=""0001-01-01T00:00:00"" />
	|<crs:endDate value=""0001-01-01T00:00:00"" />
	|<crs:beginVerNum>4294967295</crs:beginVerNum>
	|<crs:endVerNum>4294967295</crs:endVerNum>
	|<crs:userIDs />
	|<crs:objRefs />
	|<crs:recursive value=""false"" />
	|<crs:labels value=""true"" />
	|<crs:onlyLabels value=""false"" />
	|<crs:configVersion value="""" />
	|<crs:externals />
	|<crs:noExternals />
	|</crs:filter>
	|</crs:params>
	|</crs:call>";
	
	Ответ = КоннекторHTTP.Post(Адрес, ТелоЗапроса);
	Результат = Ответ.Текст();
	
	ОтветСервиса = ОбработкаXML.ПрочитатьОтветИзТекста(Результат);
	Если ОтветСервиса.ЕстьОшибка Тогда
		Сообщить(ОтветСервиса.СодержаниеОшибки);
		Возврат Неопределено;
	КонецЕсли;

	Список = Новый Массив;

	call_return = ОтветСервиса.РезультатЧтения["call_return"];
	versions = call_return._Элементы["versions"];

	Для Каждого Version Из versions Цикл

		ВходящиеДанные = Version["value"];

		second = ВходящиеДанные["second"];
		info = second["info"];
		label = second["label"];

		Версия = Новый Структура();
		Версия.Вставить("Номер", ВходящиеДанные["first"]);
		Версия.Вставить("Идентификатор", info["versionID"]);
		Версия.Вставить("ИдентификаторПользователя", info["userID"]);
		Версия.Вставить("Дата", info["data"]);
		Версия.Вставить("Комментарий", info["comment"]);
		Если Не label = Неопределено Тогда
			//Версия.Вставить("Метка", label.Получить("comment");
		КонецЕсли;
		Список.Добавить(Версия);

	КонецЦикла;


	Возврат Список;
	
КонецФункции