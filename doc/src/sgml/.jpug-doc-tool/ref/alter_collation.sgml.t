␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>ALTER COLLATION</refname>␟  <refpurpose>change the definition of a collation</refpurpose>␟  <refpurpose>照合順序の定義を変更する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER COLLATION</command> changes the definition of a
   collation.␟<command>ALTER COLLATION</command>は照合順序の定義を変更します。␞␞  </para>␞
␝  <para>␟   You must own the collation to use <command>ALTER COLLATION</command>.
   To alter the owner, you must be able to <literal>SET ROLE</literal> to the
   new owning role, and that role must have <literal>CREATE</literal>
   privilege on the collation's schema.
   (These restrictions enforce that altering the
   owner doesn't do anything you couldn't do by dropping and recreating the
   collation. However, a superuser can alter ownership of any collation
   anyway.)␟<command>ALTER COLLATION</command>を使用するためには照合順序を所有していなければなりません。
所有者を変更するためには、新しい所有者ロールに対して<literal>SET ROLE</literal>ができなければなりません。また、そのロールが照合順序のスキーマにおける<literal>CREATE</literal>権限を持たなければなりません。
（この制限により、照合順序の削除と再作成を行ってもできないことが所有者の変更で行えないようにします。
ただし、スーパーユーザはすべての照合順序の所有者を変更することができます。）␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      The name (optionally schema-qualified) of an existing collation.␟既存の照合順序の名前（スキーマ修飾可）です。␞␞     </para>␞
␝     <para>␟      The new name of the collation.␟照合順序の新しい名前です。␞␞     </para>␞
␝     <para>␟      The new owner of the collation.␟照合順序の新しい所有者です。␞␞     </para>␞
␝     <para>␟      The new schema for the collation.␟照合順序の新しいスキーマです。␞␞     </para>␞
␝     <para>␟      Update the collation's version.
      See <xref linkend="sql-altercollation-notes"/> below.␟照合順序のバージョンを更新します。
以下の<xref linkend="sql-altercollation-notes"/>を参照してください。␞␞     </para>␞
␝␟ <refsect1 id="sql-altercollation-notes" xreflabel="Notes">␟ <refsect1 id="sql-altercollation-notes" xreflabel="注釈">␞␞␞
␝ <refsect1 id="sql-altercollation-notes" xreflabel="Notes">␟  <title>Notes</title>␟  <title>注釈</title>␞␞␞
␝  <para>␟   When a collation object is created, the provider-specific version of the
   collation is recorded in the system catalog.  When the collation is used,
   the current version is
   checked against the recorded version, and a warning is issued when there is
   a mismatch, for example:␟照合順序オブジェクトを作成する時に、照合順序の提供者固有のバージョンがシステムカタログに記録されます。
照合順序が使われるとき、現在のバージョンと記録されているバージョンが比較され、不適合の場合は以下の例のように警告が発行されます。␞␞<screen>␞
␝</screen>␟   A change in collation definitions can lead to corrupt indexes and other
   problems because the database system relies on stored objects having a
   certain sort order.  Generally, this should be avoided, but it can happen
   in legitimate circumstances, such as when upgrading the operating system
   to a new major version or when
   using <command>pg_upgrade</command> to upgrade to server binaries linked
   with a newer version of ICU.  When this happens, all objects depending on
   the collation should be rebuilt, for example,
   using <command>REINDEX</command>.  When that is done, the collation version
   can be refreshed using the command <literal>ALTER COLLATION ... REFRESH
   VERSION</literal>.  This will update the system catalog to record the
   current collation version and will make the warning go away.  Note that this
   does not actually check whether all affected objects have been rebuilt
   correctly.␟データベースシステムは、保存されたオブジェクトが一定のソート順になっていることに依存しているため、照合順序を変更するとインデックスが破損するなどといった問題につながります。
一般的にこれは避けるべきですが、オペレーティングシステムを新しいメジャーバージョンにアップグレードしたり、<command>pg_upgrade</command>を使って新しいバージョンのICUライブラリとリンクされたサーバのバイナリへとアップグレードしたりする場合など、仕方のない場合もあります。
これが発生する場合は、照合順序に依存するすべてのオブジェクトを、例えば<command>REINDEX</command>を使って再構築します。
これがされれば、照合順序のバージョンをコマンド<literal>ALTER COLLATION ... REFRESH VERSION</literal>を使って更新できます。
これにより、システムカタログが更新されて照合順序の現在のバージョンが記録され、警告が出なくなります。
これは、影響を受けるすべてのオブジェクトが正しく再構築されたかどうかを実際に確認するわけではないことに注意してください。␞␞  </para>␞
␝  <para>␟   When using collations provided by <literal>libc</literal>, version
   information is recorded on systems using the GNU C library (most Linux
   systems), FreeBSD and Windows.  When using collations provided by ICU, the
   version information is provided by the ICU library and is available on all
   platforms.␟<literal>libc</literal>が提供する照合順序を使う場合、GNU Cライブラリ(ほとんどのLinuxシステム)、FreeBSD、Windowsを使ってバージョン情報がシステムに記録されます。
ICUが提供する照合順序を使う場合、バージョン情報はICUライブラリにより提供され、すべてのプラットフォームで利用できます。␞␞  </para>␞
␝   <para>␟    When using the GNU C library for collations, the C library's version
    is used as a proxy for the collation version.  Many Linux distributions
    change collation definitions only when upgrading the C library, but this
    approach is imperfect as maintainers are free to back-port newer
    collation definitions to older C library releases.␟照合順序にGNU Cライブラリを使う場合、Cライブラリのものは照合順序のプロキシとして使われます。
多くのLinuxのディストリビューションではCライブラリをアップデートする時にのみ照合順序の定義を変更しますが、メンテナは新しい照合順序の定義を古いCライブラリのリリースに自由にバックポートできますので、この方法は不完全なものです。␞␞   </para>␞
␝   <para>␟    When using Windows for collations, version information is only available
    for collations defined with BCP 47 language tags such as
    <literal>en-US</literal>.␟照合順序にWindowsを使う場合、バージョン情報は、<literal>en-US</literal>のようなBCP 47言語タグで定義された照合順序のみが利用可能です。␞␞   </para>␞
␝  <para>␟   For the database default collation, there is an analogous command
   <literal>ALTER DATABASE ... REFRESH COLLATION VERSION</literal>.␟データベースのデフォルト照合順序に対しては、類似のコマンド<literal>ALTER DATABASE ... REFRESH COLLATION VERSION</literal>があります。␞␞  </para>␞
␝  <para>␟   The following query can be used to identify all collations in the current
   database that need to be refreshed and the objects that depend on them:␟以下の問い合わせを使って、現在のデータベース内の更新が必要なすべての照合順序と、それに依存するオブジェクトを特定することができます。␞␞<programlisting><![CDATA[␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To rename the collation <literal>de_DE</literal> to
   <literal>german</literal>:␟照合順序<literal>de_DE</literal>の名前を<literal>german</literal>に変更します。␞␞<programlisting>␞
␝  <para>␟   To change the owner of the collation <literal>en_US</literal> to
   <literal>joe</literal>:␟照合順序<literal>en_US</literal>の所有者を<literal>joe</literal>に変更します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   There is no <command>ALTER COLLATION</command> statement in the SQL
   standard.␟標準SQLには<command>ALTER COLLATION</command>文はありません。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟ALTER COLLATION "en_US" OWNER TO joe; </programlisting></para> </programlisting></para>␟no translation␞␞␞
