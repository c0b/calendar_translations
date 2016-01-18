
defmodule Translations do

  # convert a list of
  #    "<U0053><U0075><U006E>";"<U004D><U006F><U006E>";"<U0054><U0075><U0065>";
  #    "<U0057><U0065><U0064>";"<U0054><U0068><U0075>";"<U0046><U0072><U0069>";"<U0053><U0061><U0074>"
  # into a list of utf-8 names
  #    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
  convert = fn(raw_code) ->
    String.split(raw_code, ";")
    |> Enum.map(fn (item) ->
      for [_, unichr] <- Regex.scan(~r/<u([0-9a-f]{4})>/i, item) do
        << String.to_integer(unichr, 16) :: utf8 >>
      end
      |> Enum.join
    end)
  end

  @names %{"abday" => :weekday_names_abbr,
           "day"   => :weekday_names,
           "abmon" => :month_names_abbr,
           "mon"   => :month_names,
           "d_t_fmt" => :date_time_format,
           "d_fmt" => :date_format,
           "t_fmt" => :time_format,
           "t_fmt_ampm" => :ampm_format,
           "am_pm" => :ampm_abbr,
           "date_fmt" => :full_date_fmt,
          }

  process_entry = fn(chunk, {lang, aliases}) ->
    [ word, rest ] = String.split(chunk, ~r{\s}, parts: 2)
    case @names[word] do
      nil -> :ok
      name ->
        def unquote(name)(unquote(lang)), do: {:ok, unquote(convert.(rest))}
        for ali <- aliases do
          def unquote(name)(unquote(ali)), do: unquote(name)(unquote(lang))
        end
    end
  end

  process_line = fn (line, {lino, in_time_section, chunk, lang}) ->
    line = String.rstrip(line)
    unless line == "END LC_TIME" do
      cond do
        line == "LC_TIME" ->
          in_time_section = true
        line == "" or line =~ ~r/^%/ ->
          :ok
        in_time_section ->
          chunk = chunk <> String.rstrip(line, ?/)
          if !String.ends_with?(line, "/") do
            process_entry.(chunk, lang)
            chunk = ""
          end
        true -> :ok
      end

      {:cont, {lino+1, in_time_section, chunk, lang}}
    else
      {:halt, :ok}
    end
  end

  # @glibc_locale "https://sourceware.org/git/?p=glibc.git;a=blob_plain;f=localedata/locales/"

  # the full list can be retrieved from SUPPORTED file, may worth to write another preprocessor
  # https://sourceware.org/git/?p=glibc.git;a=blob_plain;f=localedata/SUPPORTED
  # format:
  #     keyword: aliases
  @locale_list [en_US: [:en, :"en-US"],
                en_GB: [:"en-GB"],
                en_SG: [:"en-SG"],
                en_AU: [:"en-AU"],
                en_NZ: [:"en-NZ"],
                bn_IN: [:bn, :"bn-IN"],
                bn_BD: [:"bn-BD"],
                ca_FR: [:ca, :"ca-FR"],
                csb_PL: [:csb, :"csb-PL"],
                da_DK: [:da],
                de_DE: [:de, :"de-DE"],
                de_LU: [:"de-LU"],
                es_ES: [:es],
                nl_NL: [:nl],
                fr_FR: [:fr, :"fr-FR"],
                fr_CA: [:"fr-CA"],
                hi_IN: [:hi, :"hi-IN"],
                hu_HU: [:hu, :"hu-HU"],
                it_CH: [:"it-CH"],
                it_IT: [:it, :"it-IT"],
                ja_JP: [:ja, :"ja-JP"],
                ko_KR: [:ko, :"ko-KR"],
                lv_LV: [:lv, :"lv-LV"],
                ru_RU: [:ru, :"ru-RU"],
                ug_CN: [:ug, :"ug-CN"],
                vi_VN: [:vi, :"vi-VN"],
                wo_SN: [:wo, :"wo-SN"],
                zh_TW: [:"zh-TW"],
                zh_HK: [:"zh-HK"],
                zh_SG: [:"zh-SG"],
                zh_CN: [:zh, :"zh-CN"],
               ]

  # get the latest localedata to local instead of retrieve from Internet every time
  #   git archive --remote git://sourceware.org/git/glibc.git master localedata/locales | tar -xvv

  # HTTPotion.start
  localedef = fn {lang, aliases} ->
    # %HTTPotion.Response{body: body, status_code: 200} =
    #   HTTPotion.get(@glibc_locale <> :erlang.atom_to_binary(lang, :utf8))
    # String.split(body, ~r/\n/)
    File.stream!("./localedata/locales/" <> :erlang.atom_to_binary(lang, :utf8))
    |> Enum.reduce_while({0, false, "", {lang, aliases}}, process_line)
  end

  @locale_list
  |> Enum.each(localedef)

  # generate a list of default function clausess,
  #     to return {:error, :unknown} as the last
  #
  #     def weekday_names_abbr(_) -> {:error, :unknown}
  #         weekday_names,
  #         month_names_abbr,
  #         month_names,
  #         date_time_format,
  #         date_format,
  #         time_format,
  #         ampm_format,
  #         ampm_abbr,
  #         full_date_fmt,
  for {_key, name} <- @names do
    def unquote(name)(_), do: {:error, :unknown}
  end

end
