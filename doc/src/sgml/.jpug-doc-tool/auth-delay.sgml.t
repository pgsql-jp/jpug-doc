␝<sect1 id="auth-delay" xreflabel="auth_delay">␟ <title>auth_delay &mdash; pause on authentication failure</title>␟ <title>auth_delay &mdash; 認証エラー時に一時停止</title>␞␞␞
␝ <para>␟  <filename>auth_delay</filename> causes the server to pause briefly before
  reporting authentication failure, to make brute-force attacks on database
  passwords more difficult.  Note that it does nothing to prevent
  denial-of-service attacks, and may even exacerbate them, since processes
  that are waiting before reporting authentication failure will still consume
  connection slots.␟<filename>auth_delay</filename>はパスワードの総当たり攻撃をより難しくするために認証エラーの報告を行う前にわずかにサーバを停止させます。
これはDoS攻撃を防ぐためのものでは無いことに注意してください。認証エラーを待たせ、コネクションスロットを消費させるため、DoS攻撃の影響を増長させるかもしれません。␞␞ </para>␞
␝ <para>␟  In order to function, this module must be loaded via
  <xref linkend="guc-shared-preload-libraries"/> in <filename>postgresql.conf</filename>.␟この機能を有効にするためには<filename>postgresql.conf</filename>の <xref linkend="guc-shared-preload-libraries"/>よりモジュールをロードする必要があります。␞␞ </para>␞
␝     <indexterm>
      <primary><varname>auth_delay.milliseconds</varname> configuration parameter</primary>
     </indexterm>
␟␟     <indexterm>
      <primary><varname>auth_delay.milliseconds</varname>設定パラメータ</primary>
     </indexterm>␞␞␞
␝ <sect2 id="auth-delay-configuration-parameters">␟  <title>Configuration Parameters</title>␟  <title>設定パラメータ</title>␞␞␞
␝     <para>␟      The number of milliseconds to wait before reporting an authentication
      failure.  The default is 0.␟指定されたミリ秒数認証エラーを返す前に待機します。デフォルトは0です。␞␞     </para>␞
␝  <para>␟   These parameters must be set in <filename>postgresql.conf</filename>.
   Typical usage might be:␟これらのパラメータを<filename>postgresql.conf</filename>ファイルに設定する必要があります。典型的な使用方法は以下のようになります。␞␞  </para>␞
␝ <sect2 id="auth-delay-author">␟  <title>Author</title>␟  <title>作者</title>␞␞␞
␝␟KaiGai Kohei <email>kaigai@ak.jp.nec.com</email>␟no translation␞␞␞
