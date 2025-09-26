␝<sect1 id="dict-xsyn" xreflabel="dict_xsyn">␟ <title>dict_xsyn &mdash; example synonym full-text search dictionary</title>␟ <title>dict_xsyn &mdash; 類義語の全文検索用の辞書の例</title>␞␞␞
␝ <para>␟  <filename>dict_xsyn</filename> (Extended Synonym Dictionary) is an example of an
  add-on dictionary template for full-text search.  This dictionary type
  replaces words with groups of their synonyms, and so makes it possible to
  search for a word using any of its synonyms.␟<filename>dict_xsyn</filename>（拡張類義語辞書）は全文検索用の辞書テンプレートの追加例です。
この種類の辞書は、単語を類義語の集まりに置き換え、その類義語のいずれかを使用して単語を検索できるようにします。␞␞ </para>␞
␝ <sect2 id="dict-xsyn-config">␟  <title>Configuration</title>␟  <title>設定</title>␞␞␞
␝  <para>␟   A <literal>dict_xsyn</literal> dictionary accepts the following options:␟<literal>dict_xsyn</literal>辞書は以下のオプションを受け付けます。␞␞  </para>␞
␝    <para>␟     <literal>matchorig</literal> controls whether the original word is accepted by
     the dictionary. Default is <literal>true</literal>.␟<literal>matchorig</literal>は辞書で元の単語が受け付けられるか否かを制御します。
デフォルトは<literal>true</literal>です。␞␞    </para>␞
␝    <para>␟     <literal>matchsynonyms</literal> controls whether the synonyms are
     accepted by the dictionary. Default is <literal>false</literal>.␟<literal>matchsynonyms</literal>は類義語が辞書で受け付けられるか否かを制御します。
デフォルトは<literal>false</literal>です。␞␞    </para>␞
␝    <para>␟     <literal>keeporig</literal> controls whether the original word is included in
     the dictionary's output. Default is <literal>true</literal>.␟<literal>keeporig</literal>は元の単語が辞書出力に含められるか否かを制御します。
デフォルトは<literal>true</literal>です。␞␞    </para>␞
␝    <para>␟     <literal>keepsynonyms</literal> controls whether the synonyms are included in
     the dictionary's output. Default is <literal>true</literal>.␟<literal>keepsynonyms</literal>は類義語が辞書出力に含められるか否かを制御します。
デフォルトは<literal>true</literal>です。␞␞    </para>␞
␝    <para>␟     <literal>rules</literal> is the base name of the file containing the list of
     synonyms.  This file must be stored in
     <filename>$SHAREDIR/tsearch_data/</filename> (where <literal>$SHAREDIR</literal> means
     the <productname>PostgreSQL</productname> installation's shared-data directory).
     Its name must end in <literal>.rules</literal> (which is not to be included in
     the <literal>rules</literal> parameter).␟<literal>rules</literal>は、類義語リストを含むファイルのベース名です。
このファイルは<filename>$SHAREDIR/tsearch_data/</filename>（<literal>$SHAREDIR</literal>は<productname>PostgreSQL</productname>インストレーションの共有データ用ディレクトリを示します）に格納しなければなりません。
この名前は<literal>.rules</literal>で終わらなければなりません（これは<literal>rules</literal>パラメータには含まれません）。␞␞    </para>␞
␝  <para>␟   The rules file has the following format:␟rulesファイルは以下の書式です。␞␞  </para>␞
␝    <para>␟     Each line represents a group of synonyms for a single word, which is
     given first on the line. Synonyms are separated by whitespace, thus:␟各行は、行の先頭で与えられる1つの単語に対する類義語の集まりを表します。
類義語は以下のように空白文字で区切られます。␞␞<programlisting>␞
␝    <para>␟     The sharp (<literal>#</literal>) sign is a comment delimiter. It may appear at
     any position in a line.  The rest of the line will be skipped.␟シャープ記号（<literal>#</literal>）はコメント区切り記号です。
行の任意の位置に記載することができます。
行の残りの部分は飛ばされます。␞␞    </para>␞
␝  <para>␟   Look at <filename>xsyn_sample.rules</filename>, which is installed in
   <filename>$SHAREDIR/tsearch_data/</filename>, for an example.␟例として<filename>$SHAREDIR/tsearch_data/</filename>にインストールされる<filename>xsyn_sample.rules</filename>を参照してください。␞␞  </para>␞
␝ <sect2 id="dict-xsyn-usage">␟  <title>Usage</title>␟  <title>使用方法</title>␞␞␞
␝  <para>␟   Installing the <literal>dict_xsyn</literal> extension creates a text search
   template <literal>xsyn_template</literal> and a dictionary <literal>xsyn</literal>
   based on it, with default parameters.  You can alter the
   parameters, for example␟<literal>dict_xsyn</literal>拡張機能をインストールすると、<literal>xsyn_template</literal>テキスト検索テンプレートが作成され、それに基づき、デフォルトのパラメータを持った<literal>xsyn</literal>辞書が作成されます。
例えば以下のように、パラメータを変更することができます。␞␞␞
␝␟   or create new dictionaries based on the template.␟またこのテンプレートに基づいた新しい辞書を作成することもできます。␞␞  </para>␞
␝  <para>␟   To test the dictionary, you can try␟辞書を試験するためには以下を試してください。␞␞␞
␝␟   Real-world usage will involve including it in a text search
   configuration as described in <xref linkend="textsearch"/>.
   That might look like this:␟現実世界で使用する場合は、<xref linkend="textsearch"/>で説明されるテキスト検索設定内にこれを含むようになるでしょう。
以下のようになります。␞␞␞
