␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP OPERATOR</refname>␟  <refpurpose>remove an operator</refpurpose>␟  <refpurpose>演算子を削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP OPERATOR</command> drops an existing operator from
   the database system.  To execute this command you must be the owner
   of the operator.␟<command>DROP OPERATOR</command>はデータベースシステムから既存の演算子を削除します。
このコマンドを実行するには、その演算子の所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the operator does not exist. A notice is issued
      in this case.␟演算子が存在しない場合でもエラーになりません。
この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an existing operator.␟既存の演算子の名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      The data type of the operator's left operand; write
      <literal>NONE</literal> if the operator has no left operand.␟演算子の左オペランドのデータ型です。
演算子に左オペランドがない場合は、<literal>NONE</literal>と記述します。␞␞     </para>␞
␝     <para>␟      The data type of the operator's right operand.␟演算子の右オペランドのデータ型です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the operator (such as views
      using it), and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟演算子に依存するオブジェクト（その演算子を使用するビューなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the operator if any objects depend on it.  This
      is the default.␟依存するオブジェクトがある場合、演算子の削除を拒否します。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Remove the power operator <literal>a^b</literal> for type <type>integer</type>:␟<type>integer</type>型の累乗を求める演算子<literal>a^n</literal>を削除します。␞␞<programlisting>␞
␝  <para>␟   Remove the bitwise-complement prefix operator
   <literal>~b</literal> for type <type>bit</type>:␟<type>bit</type>型のビット列の補数を求める前置演算子<literal>~b</literal>を削除します。␞␞<programlisting>␞
␝  <para>␟   Remove multiple operators in one command:␟複数の演算子を1つのコマンドで削除します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP OPERATOR</command> statement in the SQL standard.␟標準SQLには<command>DROP OPERATOR</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP OPERATOR ~ (none, bit), ^ (integer, integer); </programlisting></para> </programlisting></para>␟no translation␞␞␞
