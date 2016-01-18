
defmodule TranslationsTest do
  use ExUnit.Case
  doctest Translations

  test "test some the generated code from glibc localedata" do
    assert Translations.weekday_names_abbr(:en_US) == {:ok,
                                                    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]}
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
    assert Translations.weekday_names(:ko) == {:ok,
                                               ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일",
                                                "토요일"]}
    assert Translations.weekday_names(:hi_IN) == {:ok,
                                                  ["रविवार ", "सोमवार ", "मंगलवार ", "बुधवार ", "गुरुवार ",
                                                   "शुक्रवार ", "शनिवार "]}

    # assert Translations.month_names_abbr(:csb) == {:ok, ["stë", "gro", "str", "łżë", "môj", "cze", "lëp", "zél", "séw", "ruj", "lës", "gòd"]}
    # assert Translations.month_names(:csb) == {:ok,
    #                                             ["stëcznik", "gromicznik", "strëmiannik", "łżëkwiôt", "môj", "czerwińc", "lëpińc", "zélnik", "séwnik", "rujan", "lëstopadnik", "gòdnik"]}

    assert Translations.weekday_names(:unknown) == {:error, :unknown}
  end
end
