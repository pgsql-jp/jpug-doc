␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP AGGREGATE</refname>␟  <refpurpose>remove an aggregate function</refpurpose>␟  <refpurpose>集約関数を削除する</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable>aggregate_signature</replaceable> is:</phrase>␟<phrase>ここで<replaceable>aggregate_signature</replaceable>は以下の通りです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP AGGREGATE</command> removes an existing
   aggregate function. To execute this command the current
   user must be the owner of the aggregate function.␟<command>DROP AGGREGATE</command>を実行すると、既存の集約関数定義を削除することができます。
このコマンドを実行するには、現在のユーザがその集約関数を所有している必要があります。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the aggregate does not exist. A notice is issued
      in this case.␟集約が存在しない場合でもエラーになりません。
この場合注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name (optionally schema-qualified) of an existing aggregate function.␟      既存の集約関数の名前です（スキーマ修飾名も可）。␞␞     </para>␞
␝     <para>␟      The mode of an argument: <literal>IN</literal> or <literal>VARIADIC</literal>.
      If omitted, the default is <literal>IN</literal>.␟引数のモードで、<literal>IN</literal>または<literal>VARIADIC</literal>です。
省略した場合のデフォルトは<literal>IN</literal>です。␞␞     </para>␞
␝     <para>␟      The name of an argument.
      Note that <command>DROP AGGREGATE</command> does not actually pay
      any attention to argument names, since only the argument data
      types are needed to determine the aggregate function's identity.␟引数の名前です。
<command>DROP AGGREGATE</command>は実際には引数の名前を無視することに注意してください。
これは、集約関数の本体を特定するのに必要になるのは、引数のデータ型だけだからです。␞␞     </para>␞
␝     <para>␟      An input data type on which the aggregate function operates.
      To reference a zero-argument aggregate function, write <literal>*</literal>
      in place of the list of argument specifications.
      To reference an ordered-set aggregate function, write
      <literal>ORDER BY</literal> between the direct and aggregated argument
      specifications.␟集約関数の操作対象となる入力データ型です。
引数を持たない関数を参照する場合は、引数指定の一覧の場所に<literal>*</literal>を記述してください。
順序集合集約関数を参照する場合は、直接引数と集約引数の指定の間に<literal>ORDER BY</literal>を記述してください。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the aggregate function
      (such as views using it),
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟その集約関数に依存しているオブジェクト（集約関数を利用しているビューなど）を自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the aggregate function if any objects depend on
      it.  This is the default.␟依存しているオブジェクトがある場合、その集約関数の削除要求を拒否します。
こちらがデフォルトです。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝   <para>␟    Alternative syntaxes for referencing ordered-set aggregates
    are described under <xref linkend="sql-alteraggregate"/>.␟順序集合集約を参照するための代替となる構文については、<xref linkend="sql-alteraggregate"/>に記述されています。␞␞   </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To remove the aggregate function <literal>myavg</literal> for type
   <type>integer</type>:␟<type>integer</type>型の<literal>myavg</literal>集約関数を削除します。␞␞<programlisting>␞
␝  <para>␟   To remove the hypothetical-set aggregate function <literal>myrank</literal>,
   which takes an arbitrary list of ordering columns and a matching list
   of direct arguments:␟順序列の任意のリストと直接引数の適合するリストをとる、仮想集合集約関数<literal>myrank</literal>を削除します。␞␞<programlisting>␞
␝  <para>␟   To remove multiple aggregate functions in one command:␟複数の集約関数を1つのコマンドで削除します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP AGGREGATE</command> statement in the SQL
   standard.␟標準SQLには、<command>DROP AGGREGATE</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP AGGREGATE myavg(integer), myavg(bigint); </programlisting></para> </programlisting></para>␟no translation␞␞␞
