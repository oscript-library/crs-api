Функция ТелоЗапросаНаСозданиеХранилища(Параметры) Экспорт
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
		|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + Параметры.ИмяХранилища + """ name=""DevDepotAdmin_createDevDepot"" version=""" + Параметры.ВерсияПлатформы + """>
		|<crs:params>
		|<crs:alias value=""" + Параметры.ИмяХранилища + """/>
		|<crs:rootID value=""" + КорневойИдентификаторКонфигурации() + """/>
		|<crs:adminName value=""" + Параметры.ИмяПользователя + """/>
		|<crs:adminPassword value=""" + Параметры.ХешПароляПользователя + """/>
		|<crs:code value=""""/>
		|<crs:features/>
		|<crs:snapshots>
		|<crs:data>" + Параметры.ШаблонКонфигурации + "</crs:data>
		|</crs:snapshots>
		|<crs:hashedVersionID value=""false""/>
		|</crs:params>
		|</crs:call>";
	Возврат ТелоЗапроса;
КонецФункции

Функция ТелоЗапросаНаПодключение(Параметры) Экспорт
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
		|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + Параметры.ИмяХранилища + """ name=""DevDepot_depotInfo"" 
		|version=""" + Параметры.ВерсияПлатформы + """>
		|<crs:auth user=""" + Параметры.ПользовательХранилища + """ password=""" + Параметры.ХешПароляПользователя + """/>
		|<crs:params/>
		|</crs:call>";
	Возврат ТелоЗапроса;
КонецФункции

Функция ТелоЗапросаНаСозданиеПользователя(Параметры) Экспорт
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
		|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + Параметры.ИмяХранилища + """ name=""UserManager_addUser"" version=""" + Параметры.ВерсияПлатформы + """>
		|<crs:auth user=""" + Параметры.ПользовательХранилища + """ password=""" + Параметры.ХешПользователяХранилища + """ />
		|<crs:bind bindID=""" + Параметры.ИдентификаторПодключения + """ />
		|<crs:params>
		|<crs:user>
		|<crs:id value=""" + Параметры.ИдентификаторОперации + """ />
		|<crs:name value=""" + Параметры.ИмяПользователя + """ />
		|<crs:password value=""" + Параметры.ХешНовогоПароля + """ />
		|<crs:rights value=""" + Параметры.Роль + """ />
		|</crs:user>
		|</crs:params>
		|</crs:call>";
	Возврат ТелоЗапроса;
КонецФункции

Функция ТелоЗапросаПоискаПользователя(Параметры) Экспорт
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
		|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + Параметры.ИмяХранилища + """ name=""UserManager_depotUserByName"" version=""" + Параметры.ВерсияПлатформы + """>
		|<crs:auth user=""" + Параметры.ПользовательХранилища + """ password=""" + Параметры.ХешПользователяХранилища + """ />
		|<crs:bind bindID=""" + Параметры.ИдентификаторПодключения + """/>
		|<crs:params>
		|<crs:name value=""" + Параметры.ИмяПользователя + """/>
		|</crs:params>
		|</crs:call>";
	Возврат ТелоЗапроса;
КонецФункции

Функция ТелоЗапросаНаУдалениеПользователя(Параметры) Экспорт
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
		|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + Параметры.ИмяХранилища + """ name=""UserManager_removeUser"" version=""" + Параметры.ВерсияПлатформы + """>
		|<crs:auth user=""" + Параметры.ПользовательХранилища + """ password=""" + Параметры.ХешПользователяХранилища + """ />
		|<crs:bind bindID=""" + Параметры.ИдентификаторПодключения + """/>
		|<crs:params>
		|<crs:id value=""" + Параметры.ИдентификаторПользователя + """/>
		|</crs:params>
		|</crs:call>";
	Возврат ТелоЗапроса;
КонецФункции

Функция ТелоЗапросаНаПолучениеСпискаПользователей(Параметры) Экспорт
	ТелоЗапроса = "<?xml version=""1.0"" encoding=""UTF-8""?>
		|<crs:call xmlns:crs=""http://v8.1c.ru/8.2/crs"" alias=""" + Параметры.ИмяХранилища + """ name=""DevDepot_devObjectsStatistic"" version=""" + Параметры.ВерсияПлатформы + """>
		|<crs:auth user=""" + Параметры.ПользовательХранилища + """ password=""" + Параметры.ХешПользователяХранилища + """ />
		|<crs:bind bindID=""" + Параметры.ИдентификаторПодключения + """/>
		|<crs:params>
		|<crs:objRefs/>
		// фильтр
		|<crs:removed value=""true""/> 
		|</crs:params>
		|</crs:call>";
	Возврат ТелоЗапроса;
КонецФункции

Функция КорневойИдентификаторКонфигурации()
	Возврат "c9dd0f2c-4ed0-484a-baad-56494aa67301";
КонецФункции