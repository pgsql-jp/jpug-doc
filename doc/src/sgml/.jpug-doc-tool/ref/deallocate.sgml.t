␝ <indexterm zone="sql-deallocate">
  <primary>prepared statements</primary>
  <secondary>removing</secondary>
 </indexterm>
␟␟ <indexterm zone="sql-deallocate">
  <primary>プリペアド文</primary>
  <secondary>の削除</secondary>
 </indexterm>␞␞␞
␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DEALLOCATE</refname>␟  <refpurpose>deallocate a prepared statement</refpurpose>␟  <refpurpose>プリペアド文の割り当てを解除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DEALLOCATE</command> is used to deallocate a previously
   prepared SQL statement. If you do not explicitly deallocate a
   prepared statement, it is deallocated when the session ends.␟<command>DEALLOCATE</command>を使用して、過去にプリペアドSQL文の割り当てを解除します。
プリペアド文を明示的に割り当て解除しなかった場合、セッションが終了した時に割り当てが解除されます。␞␞  </para>␞
␝  <para>␟   For more information on prepared statements, see <xref
   linkend="sql-prepare"/>.␟プリペアド文に関する詳細については<xref linkend="sql-prepare"/>を参照してください。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      This key word is ignored.␟このキーワードは無視されます。␞␞     </para>␞
␝     <para>␟      The name of the prepared statement to deallocate.␟割り当てを解除する、プリペアド文の名前です。␞␞     </para>␞
␝     <para>␟      Deallocate all prepared statements.␟プリペアド文の割り当てをすべて解除します␞␞     </para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   The SQL standard includes a <command>DEALLOCATE</command>
   statement, but it is only for use in embedded SQL.␟<command>DEALLOCATE</command>文は標準SQLにもありますが、埋め込みSQLでの使用のみに用途が限定されています。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
