function TranslationScr() {
    enum LOCALE {EN, RU}
    global.locale = LOCALE.EN;
    InitTranslations();
}

function InitTranslations() {
    global.locaData = load_csv("BallerDialogues.csv");
    var hh = ds_grid_height(global.locaData);
    var translations = ds_map_create();
    for (var i = 0; i < hh; i++) {
        ds_map_add(translations, global.locaData[# 0, i], i);
    }
    global.translations = translations;
}

function Text(key) {
    var text = "";
    if (global.translations[? key] != undefined) {
        text = global.locaData[# 1 + global.locale, global.translations[? key]];
        var a = argument_count > 1 ? argument[1] : "";
        text = string_replace_all(text, "{a}", a);
    } else {
        text = key;
    }
    return text;
}