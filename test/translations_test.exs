
defmodule TranslationsTest do
  use ExUnit.Case
  doctest Translations

  test "test some the generated code from glibc localedata" do
    assert Translations.weekday_names_abbr(:en) == {:ok,
                                                    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]}

    assert Translations.weekday_names(:ja) == {:ok,
                                               ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]}

    assert Translations.month_names(:da) == {:ok,
                                             ["januar", "februar", "marts", "april",
                                              "maj", "juni", "juli", "august",
                                              "september", "oktober", "november", "december"]}
    assert Translations.weekday_names_abbr(:de) == {:ok, ["So", "Mo", "Di", "Mi", "Do", "Fr", "Sa"]}
    assert Translations.weekday_names(:"zh-TW") == {:ok,
                                                   ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]}

  end
end
