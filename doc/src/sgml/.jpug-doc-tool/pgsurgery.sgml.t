␝<sect1 id="pgsurgery" xreflabel="pg_surgery">␟ <title>pg_surgery &mdash; perform low-level surgery on relation data</title>␟ <title>pg_surgery &mdash; リレーションデータに対して低レベルの手術を行う</title>␞␞␞
␝ <para>␟  The <filename>pg_surgery</filename> module provides various functions to
  perform surgery on a damaged relation. These functions are unsafe by design
  and using them may corrupt (or further corrupt) your database. For example,
  these functions can easily be used to make a table inconsistent with its
  own indexes, to cause <literal>UNIQUE</literal> or
  <literal>FOREIGN KEY</literal> constraint violations, or even to make
  tuples visible which, when read, will cause a database server crash.
  They should be used with great caution and only as a last resort.␟<filename>pg_surgery</filename>モジュールは、破損したリレーションに対して手術を行うための様々な関数を提供します。
これらの関数は設計上安全ではなく、使用することによってデータベースを破損する（あるいは既存の破損を更に拡大する）可能性があります。
たとえば、これらの関数を使用することによって簡単にテーブルは自身のインデックスと一貫性がなくなり、<literal>UNIQUE</literal>あるいは<literal>FOREIGN KEY</literal>制約の違反が生じたり、更には読み出すことによってデータベースサーバをクラッシュさせるタプルを可視状態にすることさえあります。
これらの関数は使用にあたっては十分に注意するとともに、最後の手段としてのみ使用すべきです。␞␞ </para>␞
␝ <sect2 id="pgsurgery-funcs">␟  <title>Functions</title>␟  <title>関数</title>␞␞␞
␝     <para>␟      <function>heap_force_kill</function> marks <quote>used</quote> line
      pointers as <quote>dead</quote> without examining the tuples. The
      intended use of this function is to forcibly remove tuples that are not
      otherwise accessible. For example:␟<function>heap_force_kill</function>はタプルを調べることなく<quote>使用中</quote>ラインポインタ(line pointer)に<quote>削除済み(dead)</quote>の印を付けます。
この関数はアクセスする方法がないタプルを強制的に削除するために使用することを意図しています。
例を示します。␞␞<programlisting>␞
␝     <para>␟      <function>heap_force_freeze</function> marks tuples as frozen without
      examining the tuple data. The intended use of this function is to
      make accessible tuples which are inaccessible due to corrupted
      visibility information, or which prevent the table from being
      successfully vacuumed due to corrupted visibility information.
      For example:␟<function>heap_force_freeze</function>はタプルデータを調べることなくタプルに凍結済みの印を付けます。
この関数は可視性情報が破壊されていてタプルがアクセスできなかったり、あるいは可視性が破壊されたタプルによってテーブルがバキュームできなくなったときに、タプルを強制的にアクセスできるようにするために使用することを意図しています。
例を示します。␞␞<programlisting>␞
␝ <sect2 id="pgsurgery-authors">␟  <title>Authors</title>␟  <title>作者</title>␞␞␞
␝␟Ashutosh Sharma <email>ashu.coek88@gmail.com</email>␟no translation␞␞␞
