␝  <manvolnum>7</manvolnum>␟  <refmiscinfo>SQL - Language Statements</refmiscinfo>␟  <refmiscinfo>SQL - 言語</refmiscinfo>␞␞ </refmeta>␞
␝  <refpurpose>␟   change the definition of an extension␟拡張の定義を変更する␞␞  </refpurpose>␞
␝␟<phrase>where <replaceable class="parameter">member_object</replaceable> is:</phrase>␟<phrase>ここで<replaceable class="parameter">member_object</replaceable>は以下の通りです。</phrase>␞␞␞
␝␟<phrase>and <replaceable>aggregate_signature</replaceable> is:</phrase>␟<phrase>また<replaceable>aggregate_signature</replaceable>は以下の通りです。</phrase>␞␞␞
␝ <refsect1>␟  <title>Description</title>␟  <title>説明</title>␞␞␞
␝  <para>␟   <command>ALTER EXTENSION</command> changes the definition of an installed
   extension.  There are several subforms:␟<command>ALTER EXTENSION</command>はインストールされた拡張の定義を変更します。
複数の副構文があります。␞␞␞
␝     <para>␟      This form updates the extension to a newer version.  The extension
      must supply a suitable update script (or series of scripts) that can
      modify the currently-installed version into the requested version.␟この構文は拡張を新しいバージョンに更新します。
拡張は、現在インストールされているバージョンから要求するバージョンに変更することができる、適切な更新スクリプト（またはスクリプト群）を提供しなければなりません。␞␞     </para>␞
␝     <para>␟      This form moves the extension's objects into another schema. The
      extension has to be <firstterm>relocatable</firstterm> for this command to
      succeed.␟この構文は拡張のオブジェクトを別のスキーマに移動します。
このコマンドを成功させるためには、拡張は<firstterm>再配置可能</firstterm>でなければなりません。␞␞     </para>␞
␝     <para>␟      This form adds an existing object to the extension.  This is mainly
      useful in extension update scripts.  The object will subsequently
      be treated as a member of the extension; notably, it can only be
      dropped by dropping the extension.␟この構文は既存のオブジェクトを拡張に追加します。
これは主に拡張の更新スクリプトで有用です。
オブジェクトはその後拡張のメンバとして扱われます。
特に、オブジェクトの削除は拡張の削除によってのみ可能です。␞␞     </para>␞
␝     <para>␟      This form removes a member object from the extension.  This is mainly
      useful in extension update scripts.  The object is not dropped, only
      disassociated from the extension.␟この構文は拡張からメンバオブジェクトを削除します。
これは主に拡張の更新スクリプトで有用です。
オブジェクトは削除されません。拡張との関連がなくなるだけです。␞␞     </para>␞
␝␟   See <xref linkend="extend-extensions"/> for more information about these
   operations.␟これらの操作の詳細については<xref linkend="extend-extensions"/>を参照してください。␞␞  </para>␞
␝  <para>␟   You must own the extension to use <command>ALTER EXTENSION</command>.
   The <literal>ADD</literal>/<literal>DROP</literal> forms require ownership of the
   added/dropped object as well.␟<command>ALTER EXTENSION</command>を使用するためには拡張の所有者でなければなりません。
<literal>ADD</literal>/<literal>DROP</literal>構文では追加されるオブジェクトまたは削除されるオブジェクトの所有者でもなければなりません。␞␞  </para>␞
␝ <refsect1>␟  <title>Parameters</title>␟  <title>パラメータ</title>␞␞␞
␝      <para>␟       The name of an installed extension.␟インストールされた拡張の名前です。␞␞      </para>␞
␝      <para>␟       The desired new version of the extension.  This can be written as
       either an identifier or a string literal.  If not specified,
       <command>ALTER EXTENSION UPDATE</command> attempts to update to whatever is
       shown as the default version in the extension's control file.␟更新したい新しい拡張のバージョンです。
これは識別子または文字列リテラルのいずれかで記述することができます。
指定がない場合、<command>ALTER EXTENSION UPDATE</command>は拡張の制御ファイル内でデフォルトバージョンとして示されるものへの更新を試行します。␞␞      </para>␞
␝      <para>␟       The new schema for the extension.␟拡張の新しいスキーマです。␞␞      </para>␞
␝      <para>␟       The name of an object to be added to or removed from the extension.
       Names of tables,
       aggregates, domains, foreign tables, functions, operators,
       operator classes, operator families, procedures, routines, sequences, text search objects,
       types, and views can be schema-qualified.␟拡張に追加する、または、拡張から削除するオブジェクトの名前です。
テーブル、集約、ドメイン、外部テーブル、関数、演算子、演算子クラス、演算子族、プロシージャ、ルーチン、シーケンス、全文検索オブジェクト、型、ビューの名前はスキーマ修飾可能です。␞␞      </para>␞
␝      <para>␟       The name of the source data type of the cast.␟キャストの変換元データ型の名前です。␞␞      </para>␞
␝      <para>␟       The name of the target data type of the cast.␟キャストの変換先データ型の名前です。␞␞      </para>␞
␝      <para>␟       The mode of a function, procedure, or aggregate
       argument: <literal>IN</literal>, <literal>OUT</literal>,
       <literal>INOUT</literal>, or <literal>VARIADIC</literal>.
       If omitted, the default is <literal>IN</literal>.
       Note that <command>ALTER EXTENSION</command> does not actually pay
       any attention to <literal>OUT</literal> arguments, since only the input
       arguments are needed to determine the function's identity.
       So it is sufficient to list the <literal>IN</literal>, <literal>INOUT</literal>,
       and <literal>VARIADIC</literal> arguments.␟関数、プロシージャ、または集約の引数のモードで<literal>IN</literal>、<literal>OUT</literal>、<literal>INOUT</literal>、<literal>VARIADIC</literal>のいずれかです。
省略時のデフォルトは<literal>IN</literal>です。
関数を識別するためには入力引数だけが必要ですので、実際のところ<command>ALTER EXTENSION</command>は<literal>OUT</literal>引数を考慮しないことに注意してください。
このため<literal>IN</literal>、<literal>INOUT</literal>および<literal>VARIADIC</literal>引数を列挙するだけで十分です。␞␞      </para>␞
␝      <para>␟       The name of a function, procedure, or aggregate argument.
       Note that <command>ALTER EXTENSION</command> does not actually pay
       any attention to argument names, since only the argument data
       types are needed to determine the function's identity.␟関数、プロシージャ、または集約の引数の名前です。
関数を識別するためには入力引数だけが必要ですので、実際のところ<command>ALTER EXTENSION</command>は引数名を考慮しないことに注意してください。␞␞      </para>␞
␝      <para>␟       The data type of a function, procedure, or aggregate argument.␟関数、プロシージャ、または集約の引数のデータ型です。␞␞      </para>␞
␝      <para>␟       The data type(s) of the operator's arguments (optionally
       schema-qualified).  Write <literal>NONE</literal> for the missing argument
       of a prefix operator.␟演算子の引数のデータ型（スキーマ修飾可）です。
前置演算子における存在しない引数には<literal>NONE</literal>と記述してください。␞␞      </para>␞
␝      <para>␟       This is a noise word.␟これは無意味な単語です。␞␞      </para>␞
␝      <para>␟       The name of the data type of the transform.␟変換のデータ型の名前です。␞␞      </para>␞
␝      <para>␟       The name of the language of the transform.␟変換の言語の名前です。␞␞      </para>␞
␝ <refsect1>␟  <title>Examples</title>␟  <title>例</title>␞␞␞
␝  <para>␟   To update the <literal>hstore</literal> extension to version 2.0:␟<literal>hstore</literal>拡張をバージョン2.0に更新します。␞␞<programlisting>␞
␝  <para>␟   To change the schema of the <literal>hstore</literal> extension
   to <literal>utils</literal>:␟<literal>hstore</literal>拡張のスキーマを<literal>utils</literal>に変更します。␞␞<programlisting>␞
␝  <para>␟   To add an existing function to the <literal>hstore</literal> extension:␟<literal>hstore</literal>拡張に既存の関数を追加します。␞␞<programlisting>␞
␝ <refsect1>␟  <title>Compatibility</title>␟  <title>互換性</title>␞␞␞
␝  <para>␟   <command>ALTER EXTENSION</command> is a <productname>PostgreSQL</productname>
   extension.␟<command>ALTER EXTENSION</command>は<productname>PostgreSQL</productname>の拡張です。␞␞  </para>␞
␝ <refsect1 id="sql-alterextension-see-also">␟  <title>See Also</title>␟  <title>関連項目</title>␞␞␞
␝␟ALTER EXTENSION hstore ADD FUNCTION populate_record(anyelement, hstore); </programlisting></para> </programlisting></para>␟no translation␞␞␞
