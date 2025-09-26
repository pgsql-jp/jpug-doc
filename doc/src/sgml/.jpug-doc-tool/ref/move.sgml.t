␝ <indexterm zone="sql-move">
  <primary>cursor</primary>
  <secondary>MOVE</secondary>
 </indexterm>
␟␟ <indexterm zone="sql-move">
  <primary>カーソル</primary>
  <secondary>MOVE</secondary>
 </indexterm>␞␞␞
␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>MOVE</refname>␟  <refpurpose>position a cursor</refpurpose>␟  <refpurpose>カーソルの位置を決める</refpurpose>␞␞ </refnamediv>␞
␝␟<phrase>where <replaceable class="parameter">direction</replaceable> can be one of:</phrase>␟<phrase>ここで<replaceable class="parameter">direction</replaceable>は以下の一つです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>MOVE</command> repositions a cursor without retrieving any data.
   <command>MOVE</command> works exactly like the <command>FETCH</command>
   command, except it only positions the cursor and does not return rows.␟<command>MOVE</command>はデータを取り出すことなくカーソルの位置を変更します。
<command>MOVE</command>は<command>FETCH</command>コマンドとまったく同じように動作しますが、カーソルの位置を変えるだけで行を返しません。␞␞  </para>␞
␝  <para>␟   The parameters for the <command>MOVE</command> command are identical to
   those of the <command>FETCH</command> command; refer to
   <xref linkend="sql-fetch"/>
   for details on syntax and usage.␟<command>MOVE</command>コマンドのパラメータは<command>FETCH</command>コマンドと同一です。
構文と使用方法についての詳細は<xref linkend="sql-fetch"/>を参照してください。␞␞  </para>␞
␝ <refsect1>␟  <title>Outputs</title>␟  <title>出力</title>␞␞␞
␝  <para>␟   On successful completion, a <command>MOVE</command> command returns a command
   tag of the form␟正常に終了すると、<command>MOVE</command>は以下の形式のコマンドタグを返します。␞␞<screen>␞
␝</screen>␟   The <replaceable class="parameter">count</replaceable> is the number
   of rows that a <command>FETCH</command> command with the same parameters
   would have returned (possibly zero).␟<replaceable class="parameter">count</replaceable>は同じパラメータを与えた<command>FETCH</command>コマンドが返すはずの行数です
（この値は0の場合もあります）。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝-- Skip the first 5 rows:␟-- Skip the first 5 rows:␟-- 最初の5行をスキップします。␞␞MOVE FORWARD 5 IN liahona;␞
␝-- Fetch the 6th row from the cursor liahona:␟-- Fetch the 6th row from the cursor liahona:␟-- liahonaカーソル内の6行目を抽出します。␞␞FETCH 1 FROM liahona;␞
␝-- Close the cursor liahona and end the transaction:␟-- Close the cursor liahona and end the transaction:␟-- カーソルliahonaを閉じ、トランザクションを終了します。␞␞CLOSE liahona;␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>MOVE</command> statement in the SQL standard.␟標準SQLには<command>MOVE</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
