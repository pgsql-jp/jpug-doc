␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP FUNCTION</refname>␟  <refpurpose>remove a function</refpurpose>␟  <refpurpose>関数を削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP FUNCTION</command> removes the definition of an existing
   function. To execute this command the user must be the
   owner of the function. The argument types to the
   function must be specified, since several different functions
   can exist with the same name and different argument lists.␟<command>DROP FUNCTION</command>は既存の関数定義を削除します。
このコマンドを実行できるのは、その関数の所有者のみです。
関数の引数の型は必ず指定しなければなりません。
異なる引数を持つ同じ名前の関数が複数存在する可能性があるからです。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the function does not exist. A notice is issued
      in this case.␟関数が存在しない場合でもエラーになりません。
この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an existing function.  If no
      argument list is specified, the name must be unique in its schema.␟既存の関数の名前です（スキーマ修飾名も可）。
引数リストを指定しない場合、名前はスキーマ内で一意でなければなりません。␞␞     </para>␞
␝     <para>␟      The mode of an argument: <literal>IN</literal>, <literal>OUT</literal>,
      <literal>INOUT</literal>, or <literal>VARIADIC</literal>.
      If omitted, the default is <literal>IN</literal>.
      Note that <command>DROP FUNCTION</command> does not actually pay
      any attention to <literal>OUT</literal> arguments, since only the input
      arguments are needed to determine the function's identity.
      So it is sufficient to list the <literal>IN</literal>, <literal>INOUT</literal>,
      and <literal>VARIADIC</literal> arguments.␟引数のモードで、<literal>IN</literal>、<literal>OUT</literal>、<literal>INOUT</literal>、<literal>VARIADIC</literal>のいずれかです。
省略された場合のデフォルトは<literal>IN</literal>です。
関数の識別を行うには入力引数のみが必要ですので、実際には<command>DROP FUNCTION</command>が<literal>OUT</literal>引数を無視することに注意してください。
ですので、<literal>IN</literal>、<literal>INOUT</literal>、および<literal>VARIADIC</literal>引数を列挙することで十分です。␞␞     </para>␞
␝     <para>␟      The name of an argument.
      Note that <command>DROP FUNCTION</command> does not actually pay
      any attention to argument names, since only the argument data
      types are needed to determine the function's identity.␟引数の名前です。
関数の識別を行うには引数のデータ型のみが必要ですので、実際には<command>DROP FUNCTION</command>は引数の名前を無視することに注意してください。␞␞     </para>␞
␝     <para>␟      The data type(s) of the function's arguments (optionally
      schema-qualified), if any.␟もしあれば、その関数の引数のデータ型（スキーマ修飾可能）です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the function (such as
      operators or triggers),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟関数に依存するオブジェクト（演算子やトリガなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the function if any objects depend on it.  This
      is the default.␟依存しているオブジェクトがある場合、その関数の削除を拒否します。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1 id="sql-dropfunction-examples">␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   This command removes the square root function:␟次のコマンドは平方根関数を削除します。␞␞␞
␝  <para>␟   Drop multiple functions in one command:␟複数の関数を1つのコマンドで削除します。␞␞<programlisting>␞
␝  <para>␟   If the function name is unique in its schema, it can be referred to without
   an argument list:␟関数名がスキーマ内で一意であれば、引数リストを付けなくても参照することができます。␞␞<programlisting>␞
␝</programlisting>␟   Note that this is different from␟これは以下とは異なることに注意してください。␞␞<programlisting>␞
␝</programlisting>␟   which refers to a function with zero arguments, whereas the first variant
   can refer to a function with any number of arguments, including zero, as
   long as the name is unique.␟後者は引数がゼロ個の関数を参照するのに対し、前者は引数の個数はゼロ個も含め、何個でも良く、ただし名前が一意である必要があります。␞␞  </para>␞
␝ <refsect1 id="sql-dropfunction-compatibility">␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   This command conforms to the SQL standard, with
   these <productname>PostgreSQL</productname> extensions:␟このコマンドは標準SQLに準拠していますが、以下の<productname>PostgreSQL</productname>の拡張があります。␞␞   <itemizedlist>␞
␝    <listitem>␟     <para>The standard only allows one function to be dropped per command.</para>␟     <para>標準では1コマンドで1つの関数しか削除できません。</para>␞␞    </listitem>␞
␝    <listitem>␟     <para>The <literal>IF EXISTS</literal> option</para>␟     <para><literal>IF EXISTS</literal>オプション</para>␞␞    </listitem>␞
␝    <listitem>␟     <para>The ability to specify argument modes and names</para>␟     <para>引数のモードと名前を指定できること</para>␞␞    </listitem>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP FUNCTION sqrt(integer); </programlisting></para> </programlisting></para>␟no translation␞␞␞
␝␟DROP FUNCTION sqrt(integer), sqrt(bigint); </programlisting></para> </programlisting></para>␟no translation␞␞␞
␝␟</itemizedlist></para> </itemizedlist></para>␟no translation␞␞␞
