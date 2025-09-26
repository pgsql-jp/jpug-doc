␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟<refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>UNLISTEN</refname>␟  <refpurpose>stop listening for a notification</refpurpose>␟  <refpurpose>通知の監視を停止する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>UNLISTEN</command> is used to remove an existing
   registration for <command>NOTIFY</command> events.
   <command>UNLISTEN</command> cancels any existing registration of
   the current <productname>PostgreSQL</productname> session as a
   listener on the notification channel named <replaceable
   class="parameter">channel</replaceable>.  The special wildcard
   <literal>*</literal> cancels all listener registrations for the
   current session.␟<command>UNLISTEN</command>を使うと、既存の<command>NOTIFY</command>イベントの登録を削除することができます。
<command>UNLISTEN</command>は、現在の<productname>PostgreSQL</productname>セッションにある、<replaceable class="parameter">name</replaceable>という名前の通知チャネルのリスナ登録を取り消します。
ワイルドカード<literal>*</literal>を指定すると、現在のセッションにある全てのリスナ登録が取り消されます。␞␞  </para>␞
␝  <para>␟   <xref linkend="sql-notify"/>
   contains a more extensive
   discussion of the use of <command>LISTEN</command> and
   <command>NOTIFY</command>.␟<xref linkend="sql-notify"/>には、<command>LISTEN</command>と<command>NOTIFY</command>についてのより広範な説明があります。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Name of a notification channel (any identifier).␟通知チャネルの名称です（任意の識別子）。␞␞     </para>␞
␝     <para>␟      All current listen registrations for this session are cleared.␟このセッションにおける、全ての監視登録をクリアします。␞␞     </para>␞
␝ <refsect1>␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   You can unlisten something you were not listening for; no warning or error
   will appear.␟監視を行っていない通知チャネルに対してもこのコマンドは実行できます。
警告やエラーは表示されません。␞␞  </para>␞
␝  <para>␟   At the end of each session, <command>UNLISTEN *</command> is
   automatically executed.␟   セッション終了時に、自動的に<command>UNLISTEN *</command>が実行されます。␞␞  </para>␞
␝  <para>␟   A transaction that has executed <command>UNLISTEN</command> cannot be
   prepared for two-phase commit.␟<command>UNLISTEN</command>を実行したトランザクションは二相コミット用を準備することはできません。␞␞  </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To make a registration:␟   登録を行います。␞␞␞
␝  <para>␟   Once <command>UNLISTEN</command> has been executed, further <command>NOTIFY</command>
   messages will be ignored:␟<command>UNLISTEN</command>が実行されると、その後の<command>NOTIFY</command>メッセージは無視されます。␞␞␞
␝-- no NOTIFY event is received␟-- no NOTIFY event is received␟-- NOTIFYイベントを受け取りません。␞␞</programlisting></para>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>UNLISTEN</command> command in the SQL standard.␟   標準SQLには<command>UNLISTEN</command>コマンドはありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
