␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP EVENT TRIGGER</refname>␟  <refpurpose>remove an event trigger</refpurpose>␟  <refpurpose>イベントトリガを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP EVENT TRIGGER</command> removes an existing event trigger.
   To execute this command, the current user must be the owner of the event
   trigger.␟<command>DROP EVENT TRIGGER</command>は既存のイベントトリガを削除します。
このコマンドを実行するためには、現在のユーザがイベントトリガの所有者でなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the event trigger does not exist. A notice
      is issued in this case.␟イベントトリガが存在しない場合でもエラーを発生しません。
この場合は注意が発生します。␞␞     </para>␞
␝     <para>␟      The name of the event trigger to remove.␟削除対象のイベントトリガの名前です。␞␞     </para>␞
␝     <para>␟      Automatically drop objects that depend on the trigger,
      and in turn all objects that depend on those objects
      (see <xref linkend="ddl-depend"/>).␟トリガに依存するオブジェクトを自動的に削除し、さらにそれらのオブジェクトに依存するすべてのオブジェクトも削除します（<xref linkend="ddl-depend"/>参照）。␞␞     </para>␞
␝     <para>␟      Refuse to drop the trigger if any objects depend on it.  This is
      the default.␟依存するオブジェクトが存在する場合はトリガの削除を取りやめます。
これがデフォルトです。␞␞     </para>␞
␝ <refsect1 id="sql-dropeventtrigger-examples">␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Destroy the trigger <literal>snitch</literal>:␟トリガ<literal>snitch</literal>を破棄します。␞␞␞
␝ <refsect1 id="sql-dropeventtrigger-compatibility">␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>DROP EVENT TRIGGER</command> statement in the
   SQL standard.␟<command>DROP EVENT TRIGGER</command>文は標準SQLにはありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP EVENT TRIGGER snitch; </programlisting></para> </programlisting></para>␟no translation␞␞␞
