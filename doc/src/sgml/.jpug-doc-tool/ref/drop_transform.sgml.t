␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP TRANSFORM</refname>␟  <refpurpose>remove a transform</refpurpose>␟  <refpurpose>変換を削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1 id="sql-droptransform-description">␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP TRANSFORM</command> removes a previously defined transform.␟<command>DROP TRANSFORM</command>は以前に定義された変換を削除します。␞␞  </para>␞
␝  <para>␟   To be able to drop a transform, you must own the type and the language.
   These are the same privileges that are required to create a transform.␟変換を削除するには、型と言語を所有していなければなりません。
これらは変換を作成するのに必要とされるのと同じ権限です。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the transform does not exist. A notice is issued
      in this case.␟変換が存在しない場合にエラーを発生させません。
この場合、注意が発行されます。␞␞     </para>␞
␝      <para>␟       The name of the data type of the transform.␟変換のデータ型の名前です。␞␞      </para>␞
␝      <para>␟       The name of the language of the transform.␟変換の言語の名前です。␞␞      </para>␞
␝      <para>␟       Automatically drop objects that depend on the transform,
       and in turn all objects that depend on those objects
       (see <xref linkend="ddl-depend"/>).␟変換に依存するオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞      </para>␞
␝      <para>␟       Refuse to drop the transform if any objects depend on it.  This is the
       default.␟変換に依存するオブジェクトがある場合は、変換を削除しません。
これがデフォルトです。␞␞      </para>␞
␝ <refsect1 id="sql-droptransform-examples">␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To drop the transform for type <type>hstore</type> and language
   <literal>plpython3u</literal>:␟<type>hstore</type>型で言語<literal>plpython3u</literal>の変換を削除するには次のようにします。␞␞<programlisting>␞
␝ <refsect1 id="sql-droptransform-compat">␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   This form of <command>DROP TRANSFORM</command> is a
   <productname>PostgreSQL</productname> extension.  See <xref
   linkend="sql-createtransform"/> for details.␟この構文の<command>DROP TRANSFORM</command>は<productname>PostgreSQL</productname>の拡張です。
詳しくは<xref linkend="sql-createtransform"/>を参照してください。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP TRANSFORM FOR hstore LANGUAGE plpython3u; </programlisting></para> </programlisting></para>␟no translation␞␞␞
