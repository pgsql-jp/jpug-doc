␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>CREATE ACCESS METHOD</refname>␟  <refpurpose>define a new access method</refpurpose>␟  <refpurpose>新しいアクセスメソッドを定義する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>CREATE ACCESS METHOD</command> creates a new access method.␟<command>CREATE ACCESS METHOD</command>は新しいアクセスメソッドを作成します。␞␞  </para>␞
␝  <para>␟   The access method name must be unique within the database.␟アクセスメソッドの名前はデータベース内で一意でなければなりません。␞␞  </para>␞
␝  <para>␟   Only superusers can define new access methods.␟スーパーユーザのみが新しいアクセスメソッドを定義できます。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of the access method to be created.␟作成するアクセスメソッドの名前です。␞␞     </para>␞
␝     <para>␟      This clause specifies the type of access method to define.
      Only <literal>TABLE</literal> and <literal>INDEX</literal>
      are supported at present.␟この句では定義するアクセスメソッドの型を指定します。
現在のところ、<literal>TABLE</literal>と<literal>INDEX</literal>だけがサポートされています。␞␞     </para>␞
␝     <para>␟      <replaceable class="parameter">handler_function</replaceable> is the
      name (possibly schema-qualified) of a previously registered function
      that represents the access method.  The handler function must be
      declared to take a single argument of type <type>internal</type>,
      and its return type depends on the type of access method;
      for <literal>TABLE</literal> access methods, it must
      be <type>table_am_handler</type> and for <literal>INDEX</literal>
      access methods, it must be <type>index_am_handler</type>.
      The C-level API that the handler function must implement varies
      depending on the type of access method. The table access method API
      is described in <xref linkend="tableam"/> and the index access method
      API is described in <xref linkend="indexam"/>.␟<replaceable class="parameter">handler_function</replaceable>はアクセスメソッドを表す、事前に登録された関数の名前（スキーマ修飾可）です。
ハンドラ関数は<type>internal</type>型の引数を1つだけ取るものとして定義される必要があります。
戻り値の型はアクセスメソッドの型に依存し、<literal>TABLE</literal>アクセスメソッドの場合は<type>table_am_handler</type>でなければならず、<literal>INDEX</literal>のアクセスメソッドの場合は<type>index_am_handler</type>でなければなりません。
ハンドラ関数が実装しなければならないC言語でのAPIはアクセスメソッドの型によって変わります。
TABLEのアクセスメソッドのAPIについては<xref linkend="tableam"/>で、INDEXのアクセスメソッドのAPIについては<xref linkend="indexam"/>で説明されています。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Create an index access method <literal>heptree</literal> with
   handler function <literal>heptree_handler</literal>:␟INDEXのアクセスメソッド<literal>heptree</literal>をハンドラ関数<literal>heptree_handler</literal>で作成するには、次のようにします。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>CREATE ACCESS METHOD</command> is a
   <productname>PostgreSQL</productname> extension.␟<command>CREATE ACCESS METHOD</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟CREATE ACCESS METHOD heptree TYPE INDEX HANDLER heptree_handler; </programlisting></para> </programlisting></para>␟no translation␞␞␞
