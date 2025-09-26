␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER EVENT TRIGGER</refname>␟  <refpurpose>change the definition of an event trigger</refpurpose>␟  <refpurpose>イベントトリガの定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER EVENT TRIGGER</command> changes properties of an
   existing event trigger.␟<command>ALTER EVENT TRIGGER</command>は既存のイベントトリガの属性を変更します。␞␞  </para>␞
␝  <para>␟   You must be superuser to alter an event trigger.␟イベントトリガを変更するためにはスーパーユーザでなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name of an existing trigger to alter.␟変更する既存のトリガの名前です。␞␞     </para>␞
␝     <para>␟      The user name of the new owner of the event trigger.␟イベントトリガの新しい所有者となるユーザの名前です。␞␞     </para>␞
␝     <para>␟      The new name of the event trigger.␟イベントトリガの新しい名前です。␞␞     </para>␞
␝     <para>␟      These forms configure the firing of event triggers.  A disabled trigger
      is still known to the system, but is not executed when its triggering
      event occurs.  See also <xref linkend="guc-session-replication-role"/>.␟この構文はイベントトリガの発行処理を設定します。
無効化されたトリガはまだシステムで認識されていますが、きっかけとなるイベントが起きたとしても実行されません。
<xref linkend="guc-session-replication-role"/>も参照してください。␞␞     </para>␞
␝ <refsect1 id="sql-alterventtrigger-compatibility">␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER EVENT TRIGGER</command> statement in the
   SQL standard.␟標準SQLには<command>ALTER EVENT TRIGGER</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
