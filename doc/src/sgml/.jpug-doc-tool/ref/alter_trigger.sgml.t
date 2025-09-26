␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER TRIGGER</refname>␟  <refpurpose>change the definition of a trigger</refpurpose>␟  <refpurpose>トリガ定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER TRIGGER</command> changes properties of an existing
   trigger.␟<command>ALTER TRIGGER</command>は既存のトリガのプロパティを変更します。␞␞  </para>␞
␝  <para>␟   The <literal>RENAME</literal> clause changes the name of
   the given trigger without otherwise changing the trigger
   definition.
   If the table that the trigger is on is a partitioned table,
   then corresponding clone triggers in the partitions are
   renamed too.␟<literal>RENAME</literal>句は、トリガ定義を変更せずに、指定されたトリガの名前を変更します。
トリガがあるテーブルがパーティションテーブルである場合、パーティション内の対応するクローントリガも名前が変更されます。␞␞  </para>␞
␝  <para>␟   The <literal>DEPENDS ON EXTENSION</literal> clause marks
   the trigger as dependent on an extension, such that if the extension is
   dropped, the trigger will automatically be dropped as well.␟<literal>DEPENDS ON EXTENSION</literal>句は、トリガを拡張に依存するものとして印づけます。これにより、拡張が削除されると、トリガも自動的に削除されるようになります。␞␞  </para>␞
␝  <para>␟   You must own the table on which the trigger acts to be allowed to change its properties.␟トリガのプロパティを変更するには、トリガで処理されるテーブルを所有している必要があります。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of an existing trigger to alter.␟変更の対象となる既存のトリガの名前です。␞␞     </para>␞
␝     <para>␟      The name of the table on which this trigger acts.␟このトリガで処理されるテーブルの名前です。␞␞     </para>␞
␝     <para>␟      The new name for the trigger.␟トリガの新しい名前です。␞␞     </para>␞
␝     <para>␟      The name of the extension that the trigger is to depend on (or no longer
      dependent on, if <literal>NO</literal> is specified).  A trigger
      that's marked as dependent on an extension is automatically dropped when
      the extension is dropped.␟トリガが依存する(もしくは<literal>NO</literal>が指定された場合にはもはや依存していない)拡張の名前です。
拡張に依存していると印をつけられたトリガは、拡張が削除されると自動的に削除されます。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝   <para>␟    The ability to temporarily enable or disable a trigger is provided by
    <link linkend="sql-altertable"><command>ALTER TABLE</command></link>, not by
    <command>ALTER TRIGGER</command>, because <command>ALTER TRIGGER</command> has no
    convenient way to express the option of enabling or disabling all of
    a table's triggers at once.␟トリガを一時的に有効または無効にする機能は<link linkend="sql-altertable"><command>ALTER TABLE</command></link>が提供します。
<command>ALTER TRIGGER</command>ではありません。
<command>ALTER TRIGGER</command>には、一度にテーブルのトリガを有効または無効にするオプションを表現する、簡便な方法がないからです。␞␞   </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To rename an existing trigger:␟既存のトリガの名前を変更します。␞␞<programlisting>␞
␝  <para>␟   To mark a trigger as being dependent on an extension:␟トリガが拡張に依存するという印を付けます。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>ALTER TRIGGER</command> is a <productname>PostgreSQL</productname>
   extension of the SQL standard.␟<command>ALTER TRIGGER</command>は、標準SQLに対する<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟ALTER TRIGGER emp_stamp ON emp RENAME TO emp_track_chgs; </programlisting></para> </programlisting></para>␟no translation␞␞␞
␝␟ALTER TRIGGER emp_stamp ON emp DEPENDS ON EXTENSION emplib; </programlisting></para> </programlisting></para>␟no translation␞␞␞
