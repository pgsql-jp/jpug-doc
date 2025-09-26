␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refname>DROP PUBLICATION</refname>␟  <refpurpose>remove a publication</refpurpose>␟  <refpurpose>パブリケーションを削除する</refpurpose>␞␞ </refnamediv>␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>DROP PUBLICATION</command> removes an existing publication from
   the database.␟<command>DROP PUBLICATION</command>は既存のパブリケーションをデータベースから削除します。␞␞  </para>␞
␝  <para>␟   A publication can only be dropped by its owner or a superuser.␟パブリケーションはその所有者またはスーパーユーザによってのみ削除することができます。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝     <para>␟      Do not throw an error if the publication does not exist. A notice is
      issued in this case.␟パブリケーションが存在しない場合でもエラーになりません。
この場合、注意メッセージが発行されます。␞␞     </para>␞
␝     <para>␟      The name of an existing publication.␟既存のパブリケーションの名前です。␞␞     </para>␞
␝     <para>␟      These key words do not have any effect, since there are no dependencies
      on publications.␟パブリケーションに依存するものはないので、これらのキーワードは何も効果がありません。␞␞     </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   Drop a publication:␟パブリケーションを削除します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>DROP PUBLICATION</command> is a <productname>PostgreSQL</productname>
   extension.␟<command>DROP PUBLICATION</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1>␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟DROP PUBLICATION mypublication; </programlisting></para> </programlisting></para>␟no translation␞␞␞
