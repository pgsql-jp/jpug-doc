␝<sect1 id="hstore" xreflabel="hstore">␟ <title>hstore &mdash; hstore key/value datatype</title>␟ <title>hstore &mdash; hstoreキー/値データ型</title>␞␞␞
␝ <para>␟  This module implements the <type>hstore</type> data type for storing sets of
  key/value pairs within a single <productname>PostgreSQL</productname> value.
  This can be useful in various scenarios, such as rows with many attributes
  that are rarely examined, or semi-structured data.  Keys and values are
  simply text strings.␟本モジュールはキー、値の組み合わせの集合を単一の<productname>PostgreSQL</productname>値に格納するための<type>hstore</type>データ型を実装します。
あまり厳密に検査されない属性を多く持つ行や半構造化データなど、多くの状況で有用になる可能性があります。
キーと値は単純なテキスト文字列です。␞␞ </para>␞
␝ <para>␟  This module is considered <quote>trusted</quote>, that is, it can be
  installed by non-superusers who have <literal>CREATE</literal> privilege
  on the current database.␟このモジュールは<quote>trusted</quote>と見なされます。つまり、現在のデータベースに対して<literal>CREATE</literal>権限を持つ非スーパーユーザがインストールできます。␞␞ </para>␞
␝ <sect2 id="hstore-external-rep">␟  <title><type>hstore</type> External Representation</title>␟  <title><type>hstore</type>の外部表現</title>␞␞␞
␝␟   The text representation of an <type>hstore</type>, used for input and output,
   includes zero or more <replaceable>key</replaceable> <literal>=&gt;</literal>
   <replaceable>value</replaceable> pairs separated by commas. Some examples:␟入力および出力で使用される<type>hstore</type>値のテキスト表現はカンマで区切られた、ゼロ以上の<replaceable>key</replaceable> <literal>=&gt;</literal> <replaceable>value</replaceable>という組み合わせを含みます。
以下に例を示します。␞␞␞
␝␟   The order of the pairs is not significant (and may not be reproduced on
   output). Whitespace between pairs or around the <literal>=&gt;</literal> sign is
   ignored. Double-quote keys and values that include whitespace, commas,
   <literal>=</literal>s or <literal>&gt;</literal>s. To include a double quote or a
   backslash in a key or value, escape it with a backslash.␟組み合わせの順序は重要ではありません（出力時に再現されないこともあります）。
組み合わせ間や<literal>=&gt;</literal>記号の前後の空白文字は無視されます。
キーや値が空白文字、カンマ、<literal>=</literal>、<literal>&gt;</literal>を含む場合は二重引用符でくくります。
キーや値に二重引用符やバックスラッシュを含めるには、バックスラッシュでエスケープしてください。␞␞  </para>␞
␝  <para>␟   Each key in an <type>hstore</type> is unique. If you declare an <type>hstore</type>
   with duplicate keys, only one will be stored in the <type>hstore</type> and
   there is no guarantee as to which will be kept:␟<type>hstore</type>内の各キーは一意です。
重複するキーを持つ<type>hstore</type>を宣言すると、<type>hstore</type>には1つしか保存されません。
またどちらが残るかは保証されません。␞␞␞
␝  <para>␟   A value (but not a key) can be an SQL <literal>NULL</literal>. For example:␟値はSQLの<literal>NULL</literal>を取ることができます（キーは不可）。
以下に例を示します。␞␞␞
␝␟   The <literal>NULL</literal> keyword is case-insensitive. Double-quote the
   <literal>NULL</literal> to treat it as the ordinary string <quote>NULL</quote>.␟<literal>NULL</literal>キーワードは大文字小文字の区別をしません。
<literal>null</literal>を普通の文字列<quote>NULL</quote>として扱うためには二重引用符でくくってください。␞␞  </para>␞
␝  <para>␟   Keep in mind that the <type>hstore</type> text format, when used for input,
   applies <emphasis>before</emphasis> any required quoting or escaping. If you are
   passing an <type>hstore</type> literal via a parameter, then no additional
   processing is needed. But if you're passing it as a quoted literal
   constant, then any single-quote characters and (depending on the setting of
   the <varname>standard_conforming_strings</varname> configuration parameter)
   backslash characters need to be escaped correctly. See
   <xref linkend="sql-syntax-strings"/> for more on the handling of string
   constants.␟入力として使用される場合<type>hstore</type>テキスト書式は、<emphasis>前もって</emphasis>必要な引用符付けやエスケープ処理を適用することに注意してください。
パラメータとして<type>hstore</type>リテラルを渡す場合、追加処理は必要ありません。
しかし、引用符付けしたリテラル定数として渡す場合には、単一引用符および(<varname>standard_conforming_strings</varname>設定パラメータに依存しますが)バックスラッシュ文字をすべて正しくエスケープしなければなりません。
文字列定数の取り扱いについては<xref linkend="sql-syntax-strings"/>を参照してください。␞␞  </para>␞
␝  <para>␟   On output, double quotes always surround keys and values, even when it's
   not strictly necessary.␟出力の場合、厳密に必要がない場合であっても、常にキーと値は二重引用符でくくられます。␞␞  </para>␞
␝ <sect2 id="hstore-ops-funcs">␟  <title><type>hstore</type> Operators and Functions</title>␟  <title><type>hstore</type>の演算子と関数</title>␞␞␞
␝  <para>␟   The operators provided by the <literal>hstore</literal> module are
   shown in <xref linkend="hstore-op-table"/>, the functions
   in <xref linkend="hstore-func-table"/>.␟<literal>hstore</literal>モジュールで提供される演算子を<xref linkend="hstore-op-table"/>に、関数を<xref linkend="hstore-func-table"/>に示します。␞␞  </para>␞
␝  <table id="hstore-op-table">␟   <title><type>hstore</type> Operators</title>␟   <title><type>hstore</type>の演算子</title>␞␞    <tgroup cols="1">␞
␝       <entry role="func_table_entry"><para role="func_signature">␟        Operator␟        演算子␞␞       </para>␞
␝       <para>␟        Description␟        説明␞␞       </para>␞
␝       <para>␟        Example(s)␟        例␞␞       </para></entry>␞
␝       <para>␟        Returns value associated with given key, or <literal>NULL</literal> if
        not present.␟与えられたキーに対応する値を、存在しなければ<literal>NULL</literal>を返します。␞␞       </para>␞
␝       <para>␟        Returns values associated with given keys, or <literal>NULL</literal>
        if not present.␟与えられたキーに対応する値を、存在しなければ<literal>NULL</literal>を返します。␞␞       </para>␞
␝       <para>␟        Concatenates two <type>hstore</type>s.␟2つの<type>hstore</type>を連結します。␞␞       </para>␞
␝       <para>␟        Does <type>hstore</type> contain key?␟<type>hstore</type>がキーを含むか？␞␞       </para>␞
␝       <para>␟        Does <type>hstore</type> contain all the specified keys?␟<type>hstore</type>が指定したキーをすべて含むか？␞␞       </para>␞
␝       <para>␟        Does <type>hstore</type> contain any of the specified keys?␟<type>hstore</type>が指定したキーのいずれかを含むか？␞␞       </para>␞
␝       <para>␟        Does left operand contain right?␟左辺は右辺を含むか？␞␞       </para>␞
␝       <para>␟        Is left operand contained in right?␟左辺は右辺に含まれるか？␞␞       </para>␞
␝       <para>␟        Deletes key from left operand.␟左辺からキーを削除します。␞␞       </para>␞
␝       <para>␟        Deletes keys from left operand.␟左辺からキー(複数)を削除します。␞␞       </para>␞
␝       <para>␟        Deletes pairs from left operand that match pairs in the right operand.␟右辺の組み合わせに一致する組み合わせを左辺から削除します。␞␞       </para>␞
␝       <para>␟        Replaces fields in the left operand (which must be a composite type)
        with matching values from <type>hstore</type>.␟左辺(複合型でなければなりません)のフィールドを<type>hstore</type>の対応する値で置換します。␞␞       </para>␞
␝       <para>␟        Converts <type>hstore</type> to an array of alternating keys and
        values.␟<type>hstore</type>をキーと値が交互に並んだ配列に変換します。␞␞       </para>␞
␝       <para>␟        Converts <type>hstore</type> to a two-dimensional key/value array.␟<type>hstore</type>をキーと値の2次元配列に変換します。␞␞       </para>␞
␝  <table id="hstore-func-table">␟   <title><type>hstore</type> Functions</title>␟   <title><type>hstore</type>の関数</title>␞␞    <tgroup cols="1">␞
␝       <entry role="func_table_entry"><para role="func_signature">␟        Function␟        関数␞␞       </para>␞
␝       <para>␟        Description␟        説明␞␞       </para>␞
␝       <para>␟        Example(s)␟        例␞␞       </para></entry>␞
␝       <para>␟        Constructs an <type>hstore</type> from a record or row.␟レコードまたは行から<type>hstore</type>を生成します。␞␞       </para>␞
␝       <para>␟        Constructs an <type>hstore</type> from an array, which may be either
        a key/value array, or a two-dimensional array.␟配列から<type>hstore</type>を生成します。配列はキー、値の配列でも2次元の配列でも構いません。␞␞       </para>␞
␝       <para>␟        Constructs an <type>hstore</type> from separate key and value arrays.␟キー、値で分けた配列から<type>hstore</type>を作成します。␞␞       </para>␞
␝       <para>␟        Makes a single-item <type>hstore</type>.␟<type>hstore</type>型の単一項目を作成します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s keys as an array.␟<type>hstore</type>のキーを配列として取り出します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s keys as a set.␟<type>hstore</type>のキーを集合として取り出します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s values as an array.␟<type>hstore</type>の値を配列として取り出します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s values as a set.␟<type>hstore</type>の値を集合として取り出します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s keys and values as an array of
        alternating keys and values.␟<type>hstore</type>のキーと値を、キーと値が交互に並んだ配列として取り出します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s keys and values as a two-dimensional
        array.␟<type>hstore</type>のキーと値を、2次元の配列として取り出します。␞␞       </para>␞
␝       <para>␟        Converts an <type>hstore</type> to a <type>json</type> value,
        converting all non-null values to JSON strings.␟非nullの値をすべてJSON文字列に変換しながら、<type>hstore</type>を<type>json</type>値に変換します。␞␞       </para>␞
␝       <para>␟        This function is used implicitly when an <type>hstore</type> value is
        cast to <type>json</type>.␟この関数は<type>hstore</type>値が<type>json</type>にキャストされるときに暗黙的に使用されます。␞␞       </para>␞
␝       <para>␟        Converts an <type>hstore</type> to a <type>jsonb</type> value,
        converting all non-null values to JSON strings.␟非nullの値をすべてJSON文字列に変換しながら、<type>hstore</type>を<type>jsonb</type>値に変換します。␞␞       </para>␞
␝       <para>␟        This function is used implicitly when an <type>hstore</type> value is
        cast to <type>jsonb</type>.␟この関数は<type>hstore</type>値が<type>jsonb</type>にキャストされるときに暗黙的に使用されます。␞␞       </para>␞
␝       <para>␟        Converts an <type>hstore</type> to a <type>json</type> value, but
        attempts to distinguish numerical and Boolean values so they are
        unquoted in the JSON.␟<type>hstore</type>を<type>json</type>値に変換します。ですが、数値およびブール値を識別しようとするため、その2つはJSON中では引用符が付きません。␞␞       </para>␞
␝       <para>␟        Converts an <type>hstore</type> to a <type>jsonb</type> value, but
        attempts to distinguish numerical and Boolean values so they are
        unquoted in the JSON.␟<type>hstore</type>を<type>jsonb</type>値に変換します。ですが、数値およびブール値を識別しようとするため、その2つはJSON中では引用符が付きません。␞␞       </para>␞
␝       <para>␟        Extracts a subset of an <type>hstore</type> containing only the
        specified keys.␟指定されたキーだけを含む<type>hstore</type>の部分集合を取り出します。␞␞       </para>␞
␝       <para>␟        Extracts an <type>hstore</type>'s keys and values as a set of records.␟<type>hstore</type>のキーと値をレコードの集合として取り出します。␞␞       </para>␞
␝       <para>␟        Does <type>hstore</type> contain key?␟<type>hstore</type>がキーを含むか？␞␞       </para>␞
␝       <para>␟        Does <type>hstore</type> contain a non-<literal>NULL</literal> value
        for key?␟<type>hstore</type>がキーに対して非<literal>NULL</literal>の値を含むか？␞␞       </para>␞
␝       <para>␟        Deletes pair with matching key.␟キーに一致する組み合わせを削除します。␞␞       </para>␞
␝       <para>␟        Deletes pairs with matching keys.␟キー(複数)に一致する組み合わせを削除します。␞␞       </para>␞
␝       <para>␟        Deletes pairs matching those in the second argument.␟第2引数内の組み合わせと一致する組み合わせを削除します。␞␞       </para>␞
␝       <para>␟        Replaces fields in the left operand (which must be a composite type)
        with matching values from <type>hstore</type>.␟左辺(複合型でなければなりません)のフィールドを<type>hstore</type>の対応する値で置換します。␞␞       </para>␞
␝  <para>␟   In addition to these operators and functions, values of
   the <type>hstore</type> type can be subscripted, allowing them to act
   like associative arrays.  Only a single subscript of type <type>text</type>
   can be specified; it is interpreted as a key and the corresponding
   value is fetched or stored.  For example,␟この演算子や関数に加えて、<type>hstore</type>型の値は添字を付けることができ、その場合、連想配列のように振る舞います。
<type>text</type>型の単一の添字のみが指定可能です。添字はキーとして解釈され、対応する値が取り出されたり、保存されたりします。
以下に例を示します。␞␞␞
␝␟   A subscripted fetch returns <literal>NULL</literal> if the subscript
   is <literal>NULL</literal> or that key does not exist in
   the <type>hstore</type>.  (Thus, a subscripted fetch is not greatly
   different from the <literal>-&gt;</literal> operator.)
   A subscripted update fails if the subscript is <literal>NULL</literal>;
   otherwise, it replaces the value for that key, adding an entry to
   the <type>hstore</type> if the key does not already exist.␟添字が<literal>NULL</literal>の場合や、そのキーが<type>hstore</type>内に存在しない場合には、添字による取り出しは<literal>NULL</literal>を返します。
(ですので、添字による取り出しは<literal>-&gt;</literal>演算子とそれほど異なりません。)
添字が<literal>NULL</literal>の場合には、添字による更新は失敗します。そうでなければ、そのキーに対応する値を置き換え、キーがまだ存在していなければ<type>hstore</type>にエントリを追加します。␞␞  </para>␞
␝ <sect2 id="hstore-indexes">␟  <title>Indexes</title>␟  <title>インデックス</title>␞␞␞
␝  <para>␟   <type>hstore</type> has GiST and GIN index support for the <literal>@&gt;</literal>,
   <literal>?</literal>, <literal>?&amp;</literal> and <literal>?|</literal> operators. For example:␟<type>hstore</type>は<literal>@&gt;</literal>、<literal>?</literal>、<literal>?&amp;</literal>および<literal>?|</literal>演算子向けのGiSTおよびGINインデックスをサポートします。
以下に例を示します。␞␞  </para>␞
␝  <para>␟   <literal>gist_hstore_ops</literal> GiST opclass approximates a set of
   key/value pairs as a bitmap signature.  Its optional integer parameter
   <literal>siglen</literal> determines the
   signature length in bytes.  The default length is 16 bytes.
   Valid values of signature length are between 1 and 2024 bytes.  Longer
   signatures lead to a more precise search (scanning a smaller fraction of the index and
   fewer heap pages), at the cost of a larger index.␟<literal>gist_hstore_ops</literal> GiST演算子クラスはキー/値の集合をビットマップ署名として近似します。
オプションの整数パラメータ<literal>siglen</literal>は、署名の長さをバイト単位で決定します。
デフォルトの署名の長さは16バイトです。
署名の長さの有効な値は1から2024バイトまでです。
長い署名では、インデックスはより大きくなってしまいますが、(インデックスのより小さな部分とより少ないヒープページをスキャンすることで)検索がより正確になります。␞␞  </para>␞
␝  <para>␟   Example of creating such an index with a signature length of 32 bytes:␟署名の長さが32バイトのインデックスを作成する例␞␞<programlisting>␞
␝  <para>␟   <type>hstore</type> also supports <type>btree</type> or <type>hash</type> indexes for
   the <literal>=</literal> operator. This allows <type>hstore</type> columns to be
   declared <literal>UNIQUE</literal>, or to be used in <literal>GROUP BY</literal>,
   <literal>ORDER BY</literal> or <literal>DISTINCT</literal> expressions. The sort ordering
   for <type>hstore</type> values is not particularly useful, but these indexes
   may be useful for equivalence lookups. Create indexes for <literal>=</literal>
   comparisons as follows:␟<type>hstore</type>はまた、<literal>=</literal>演算子向けに<type>btree</type>または<type>hash</type>インデックスをサポートします。
これにより<type>hstore</type>の列を<literal>UNIQUE</literal>と宣言すること、また、<literal>GROUP BY</literal>、<literal>ORDER BY</literal>、<literal>DISTINCT</literal>の式で使用することができます。
<type>hstore</type>値のソート順序付けはあまり有用ではありません。
しかしこれらのインデックスは同値検索の際に有用になるかもしれません。
<literal>=</literal>比較用のインデックスを以下のように作成します。␞␞  </para>␞
␝ <sect2 id="hstore-examples">␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Add a key, or update an existing key with a new value:␟キーを追加、または、既存のキーを新しい値で更新します。␞␞<programlisting>␞
␝</programlisting>␟   Another way to do the same thing is:␟同じことを行なう他の方法を以下に示します。␞␞<programlisting>␞
␝</programlisting>␟   If multiple keys are to be added or changed in one operation,
   the concatenation approach is more efficient than subscripting:␟1つの操作で複数のキーを追加したり変更したりする場合には、連結する方が添字を使うよりも効率的です。␞␞<programlisting>␞
␝  <para>␟   Delete a key:␟キーを削除します。␞␞<programlisting>␞
␝  <para>␟   Convert a <type>record</type> to an <type>hstore</type>:␟<type>record</type>を<type>hstore</type>に変換します。␞␞<programlisting>␞
␝  <para>␟   Convert an <type>hstore</type> to a predefined <type>record</type> type:␟<type>hstore</type>を事前に定義された<type>record</type>型に変換します。␞␞<programlisting>␞
␝  <para>␟   Modify an existing record using the values from an <type>hstore</type>:␟<type>hstore</type>の値を使用して既存のレコードを変更します。␞␞<programlisting>␞
␝ <sect2 id="hstore-statistics">␟  <title>Statistics</title>␟  <title>統計情報</title>␞␞␞
␝  <para>␟   The <type>hstore</type> type, because of its intrinsic liberality, could
   contain a lot of different keys. Checking for valid keys is the task of the
   application. The following examples demonstrate several techniques for
   checking keys and obtaining statistics.␟内在する自由度のため、<type>hstore</type>型は異なるキーを多く含むことができます。
有効なキーを検査することはアプリケーション側の作業です。
以下の例では、キー検査および統計情報の入手に関する複数の技法を示します。␞␞  </para>␞
␝  <para>␟   Simple example:␟簡単な例を示します。␞␞<programlisting>␞
␝  <para>␟   Using a table:␟テーブルを使用する例です。␞␞<programlisting>␞
␝  <para>␟   Online statistics:␟オンライン統計値です。␞␞<programlisting>␞
␝ <sect2 id="hstore-compatibility">␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   As of PostgreSQL 9.0, <type>hstore</type> uses a different internal
   representation than previous versions. This presents no obstacle for
   dump/restore upgrades since the text representation (used in the dump) is
   unchanged.␟PostgreSQL 9.0から<type>hstore</type>の内部表現はこれまでから変更されました。
(ダンプ内で使用される)テキスト表現には変更がありませんので、ダンプ/リストアによる更新の妨げにはなりません。␞␞  </para>␞
␝  <para>␟   In the event of a binary upgrade, upward compatibility is maintained by
   having the new code recognize old-format data. This will entail a slight
   performance penalty when processing data that has not yet been modified by
   the new code. It is possible to force an upgrade of all values in a table
   column by doing an <literal>UPDATE</literal> statement as follows:␟バイナリによる更新の際、新しいコードで古い書式のデータを認識させることにより、上位互換が保持されます。
これには、新しいコードによりまだ変更されていないデータを処理する際に、性能の劣化を多少伴います。
以下のように<literal>UPDATE</literal>文を実行することによりテーブル列内のすべての値を強制的に更新することができます。␞␞<programlisting>␞
␝  <para>␟   Another way to do it is:␟上を行う他の方法を以下に示します。␞␞<programlisting>␞
␝</programlisting>␟   The <command>ALTER TABLE</command> method requires an
   <literal>ACCESS EXCLUSIVE</literal> lock on the table,
   but does not result in bloating the table with old row versions.␟<command>ALTER TABLE</command>による方法はテーブルに対して<literal>ACCESS EXCLUSIVE</literal>ロックを必要とします。
しかし、古いバージョンの行でテーブルが膨張することはありません。␞␞  </para>␞
␝ <sect2 id="hstore-transforms">␟  <title>Transforms</title>␟  <title>変換</title>␞␞␞
␝  <para>␟   Additional extensions are available that implement transforms for
   the <type>hstore</type> type for the languages PL/Perl and PL/Python.  The
   extensions for PL/Perl are called <literal>hstore_plperl</literal>
   and <literal>hstore_plperlu</literal>, for trusted and untrusted PL/Perl.
   If you install these transforms and specify them when creating a
   function, <type>hstore</type> values are mapped to Perl hashes.  The
   extension for PL/Python is called <literal>hstore_plpython3u</literal>.
   If you use it, <type>hstore</type> values are mapped to Python dictionaries.␟PL/Perl言語やPL/Python言語向けに<type>hstore</type>型の変換を実装した追加の拡張が入手可能です。
PL/Perl向けの拡張は、信頼されたPL/Perlに対しては<literal>hstore_plperl</literal>という名前で、信頼されないものに対しては<literal>hstore_plperlu</literal>という名前です。
関数を作成するときにこの変換をインストールして指定していれば、<type>hstore</type>の値はPerlのハッシュにマップされます。
PL/Python向けの拡張は<literal>hstore_plpython3u</literal>という名前です。
この拡張を使うと<type>hstore</type>の値はPythonの辞書型にマップされます。␞␞  </para>␞
␝   <para>␟    It is strongly recommended that the transform extensions be installed in
    the same schema as <filename>hstore</filename>.  Otherwise there are
    installation-time security hazards if a transform extension's schema
    contains objects defined by a hostile user.␟変換の拡張は<filename>hstore</filename>と同じスキーマにインストールすることを強く勧めます。
さもないと、変換の拡張のスキーマが悪意のあるユーザにより定義されたオブジェクトを含んでいた場合に、インストール時のセキュリティ問題になります。␞␞   </para>␞
␝ <sect2 id="hstore-authors">␟  <title>Authors</title>␟  <title>作者</title>␞␞␞
␝  <para>␟   Additional enhancements by Andrew Gierth <email>andrew@tao11.riddles.org.uk</email>,
   United Kingdom␟追加の改良はAndrew Gierth <email>andrew@tao11.riddles.org.uk</email>,United Kingdomによりなされました。␞␞  </para>␞
␝␟</para></entry> </para></entry>␟no translation␞␞␞
␝␟</para></entry> </para></entry>␟no translation␞␞␞
␝␟</para></entry> </para></entry>␟no translation␞␞␞
␝␟Oleg Bartunov <email>oleg@sai.msu.su</email>, Moscow, Moscow University, Russia␟no translation␞␞␞
␝␟Teodor Sigaev <email>teodor@sigaev.ru</email>, Moscow, Delta-Soft Ltd., Russia␟no translation␞␞␞
