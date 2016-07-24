defmodule Blog.Plug.Locale do
  import Plug.Conn

  def init(default), do: default

  def call(conn, default) do
    lang = case conn.params["lang"]
         || get_session(conn, :lang) 
         || parse_accept_language(hd get_req_header(conn, "accept-language")) 
         do
      nil   -> default
      lang  -> lang
    end
    Gettext.put_locale(Blog.Gettext, lang)
    # conn |> put_session(:lang, lang)
    conn
  end

  for locale <- Blog.Gettext.supported_locales do
    def parse_accept_language(<<unquote(locale), _::binary>>), do: unquote(locale)
  end
  def parse_accept_language(<<_, rest::binary>>), do: parse_accept_language(rest)
  def parse_accept_language(_), do: nil
end
