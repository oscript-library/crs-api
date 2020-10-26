// Идентификатор версии хранилища (GUID)
Перем Идентификатор Экспорт;
// Порядковый номер версии хранилища
Перем Номер Экспорт;
// Дата версии хранилища
Перем Дата Экспорт;
// Внутренняя версия конфигурации
Перем ВнутренняяВерсия Экспорт;
// Версия конфигурации
Перем Версия Экспорт;
// Автор версии в хранилище
Перем Пользователь Экспорт;
// Номер версии платформы 1С
Перем Версия1С Экспорт;
// Комментарий к версии хранилища
Перем Комментарий Экспорт;
// Данные файла конфигурации
Перем Данные Экспорт;

Процедура ПриСозданииНаСервере()
	Пароль = Неопределено;
КонецПроцедуры

// Заполняет объект на основе входящих данных
//
// Параметры:
//   ВходящиеДанные - Соответствие - результат разбора XML с помощью библиотеки xmp-parser
//
Процедура Заполнить(ВходящиеДанные) Экспорт
	
	info = ВходящиеДанные["info"];

	Идентификатор    = ЗначениеСвойства(info, "versionID");
	Номер            = info["verNum"];
	Дата             = ВычислитьДату(ЗначениеСвойства(info, "date"));
	Пользователь     = ЗначениеСвойства(info, "userID");
	Версия           = ЗначениеСвойства(info, "code");
	ВнутренняяВерсия = СтрШаблон("%1.%2", info["cvermajor"], info["cverminor"]);
	Версия1С         = СтрШаблон("%1.%2.%3.%4",
	                             ЗначениеСвойства(info, "pvermajor"),
	                             ЗначениеСвойства(info, "pverminor"),
	                             ЗначениеСвойства(info, "pverbuild"),
	                             ЗначениеСвойства(info, "pverrevis"));
	Комментарий      = info["comment"];
	Данные           = Неопределено;
	Если НЕ info.Получить("file") = Неопределено Тогда
		Данные       = Base64Значение(info["file"]);
	КонецЕсли;

КонецПроцедуры

Функция ЗначениеСвойства(ВходящиеДанные, ИмяСвойства)
	Возврат ВходящиеДанные[ИмяСвойства]._Атрибуты["value"];
КонецФункции

Функция ВычислитьБулево(Знач ВходящееЗначение)
	Возврат НРег(ВходящееЗначение) = "true";
КонецФункции

Функция ВычислитьДату(Знач ВходящееЗначение)
	Возврат ПрочитатьДатуJSON(ВходящееЗначение + "Z", ФорматДатыJSON.ISO);
КонецФункции