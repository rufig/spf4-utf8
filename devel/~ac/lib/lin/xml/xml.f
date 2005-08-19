( ������ XML ����� ���������� LIBXML2
  ~ac: ��������� ����� so-xt.f 18.08.2005
  $Id$

  ��� ���������� ����� ��������� dll:
  libxml2.dll iconv.dll zlib1.dll   
  libcurl.dll zlibwapi.dll
)  
  
WARNING @ WARNING 0!
REQUIRE SO            ~ac/lib/ns/so-xt.f
REQUIRE STR@          ~ac/lib/str5.f
REQUIRE GET-FILE      ~ac/lib/lin/curl/curl.f
WARNING !

ALSO SO NEW: libxml2.dll

\ struct _xmlNode {
0
\    void           *_private;	/* application data */
CELL -- x._private
\    xmlElementType   type;	/* type number, must be second ! */
CELL -- x.type
\    const xmlChar   *name;      /* the name of the node, or the entity */
CELL -- x.name
\    struct _xmlNode *children;	/* parent->childs link */
CELL -- x.children
\    struct _xmlNode *last;	/* last child link */
CELL -- x.last
\    struct _xmlNode *parent;	/* child->parent link */
CELL -- x.parent
\    struct _xmlNode *next;	/* next sibling link  */
CELL -- x.next
\    struct _xmlNode *prev;	/* previous sibling link  */
CELL -- x.prev
\    struct _xmlDoc  *doc;	/* the containing document */
CELL -- x.doc
\    /* End of common part */
\    xmlNs           *ns;        /* pointer to the associated namespace */
CELL -- x.ns
\    xmlChar         *content;   /* the content */
CELL -- x.content
\    struct _xmlAttr *properties;/* properties list */
CELL -- x.properties
\    xmlNs           *nsDef;     /* namespace definitions on this node */
CELL -- x.nsDef
\    void            *psvi;	/* for type/PSVI informations */
CELL -- x.psvi
\    unsigned short   line;	/* line number */
CELL -- x.line
\    unsigned short   extra;	/* extra data for XPath/XSLT */
CELL -- x.extra
\ };
CONSTANT /xmlNode

1 CONSTANT XML_ELEMENT_NODE

0
CELL -- xpo.type       \ xmlXPathObjectType
CELL -- xpo.nodesetval \ xmlNodeSetPtr
CELL -- xpo.boolval    \ int
  12 -- xpo.floatval   \ double
CELL -- xpo.stringval  \ xmlChar
CELL -- xpo.user       \ void
CELL -- xpo.index      \ int
CELL -- xpo.user2      \ void
CELL -- xpo.index2     \ int
CONSTANT /xmlXPathObject

0
CELL -- xns.nodeNr     \ int : number of nodes in the set
CELL -- xns.nodeMax    \ int : size of the array as allocated
CELL -- xns.nodeTab    \ xmlNodePtr : array of nodes in no particular order @
CONSTANT /xmlNodeSet

USER RECURSE-LEVEL
: 1-! DUP @ 1- SWAP ! ;
VECT vlistNodes

: attrDump ( node -- )
  x.properties @
  BEGIN
    DUP
  WHILE
\    DUP x.type @ . \ 2
    DUP x.name @ ASCIIZ> SPACE TYPE 
    DUP x.children @ ?DUP 
        IF \ x.name -> "text"
           x.content @ ?DUP IF ." ='" ASCIIZ> TYPE ." '" THEN 
        THEN
        x.next @
  REPEAT DROP
;
: nodeDump ( node -- )
  CR DUP x.name @ ASCIIZ> RECURSE-LEVEL @ 4 * SPACES ." <" TYPE
  DUP attrDump
  ." >"
\    DUP x.line ." line=" @ .
    DUP x.children @ ?DUP IF RECURSE-LEVEL 1+! vlistNodes RECURSE-LEVEL 1-! THEN

  CR DUP x.name @ ASCIIZ> RECURSE-LEVEL @ 4 * SPACES ." </" TYPE ." >"
  DROP
;
: listNodes ( node -- )
  BEGIN
    DUP
  WHILE
    DUP x.type @ XML_ELEMENT_NODE =
    IF DUP nodeDump
    ELSE
       DUP x.children @ ?DUP IF RECURSE-LEVEL 1+! RECURSE RECURSE-LEVEL 1-! THEN
    THEN
        x.next @
  REPEAT DROP
;
' listNodes TO vlistNodes

: dumpNodeSet { res -- }
  res xpo.nodesetval @ ?DUP
  IF xns.nodeNr @ 0
     ?DO
        res xpo.nodesetval @ xns.nodeTab @ I CELLS + @
        x.children @ ( listNodes)
\          1 SWAP doc 3 xmlNodeListGetString ASCIIZ> TYPE CR \ ���� � �� ᠬ��, ��� �뤥����� �����
        ?DUP IF x.content @ ?DUP IF ASCIIZ> TYPE CR THEN THEN
      LOOP
  THEN
;
: dumpBool xpo.boolval @ . ;
: dumpFloat xpo.floatval 12 DUMP ;
: dumpString xpo.stringval @ ASCIIZ> TYPE ;

CREATE xpathTypes ' dumpNodeSet , ' dumpBool , ' dumpFloat , ' dumpString ,

: XML_READ_DOC_MEM { addr u -- doc }
  97 ( noerror|nowarning|recover) 0 0 u addr 5 xmlReadMemory
;
: XML_READ_DOC_MEM_ENC { enca encu addr u -- doc }
  97 ( noerror|nowarning|recover) enca 0 u addr 5 xmlReadMemory
;
: XML_READ_DOC ( addr u -- doc )
  GET-FILE DUP STR@ XML_READ_DOC_MEM SWAP STRFREE
;
: XML_READ_DOC_ENC { enca encu addr u -- doc }
  addr u GET-FILE DUP STR@ enca encu 2SWAP XML_READ_DOC_MEM_ENC SWAP STRFREE
;
: XML_XPATH_MEM { addr u xpaddr xpu \ doc ctx res -- }
  addr u XML_READ_DOC_MEM -> doc
  doc 1 xmlXPathNewContext -> ctx
  ctx xpaddr 2 xmlXPathEvalExpression -> res
  ctx 1 xmlXPathFreeContext DROP
  res IF res xpo.type @ 1- 0 MAX CELLS xpathTypes + @ res SWAP EXECUTE THEN
  res 1 xmlXPathFreeObject DROP
  doc 1 xmlFreeDoc DROP
  0 xmlCleanupParser DROP
;
: XML_XPATH { addr u xpaddr xpu \ s -- }
  addr u GET-FILE -> s
  s STR@ xpaddr xpu XML_XPATH_MEM
  s STRFREE
;
: XML_SERIALIZE { doc \ mem size -- addr2 u2 }
  ^ size ^ mem doc 3 xmlDocDumpMemory DROP mem size
;
: XML_SERIALIZE_ENC { enca encu doc \ mem size -- addr2 u2 }
  enca ^ size ^ mem doc 4 xmlDocDumpMemoryEnc DROP mem size
;
: XML_LIST_NODES { addr u \ doc -- }
  addr u XML_READ_DOC -> doc
  doc 1 xmlDocGetRootElement listNodes
  doc 1 xmlFreeDoc DROP
  0 xmlCleanupParser DROP
;
: XML_DUMP_NODES ( addr u -- ) { \ doc }
  XML_READ_DOC -> doc
  doc S" -" DROP 2 xmlSaveFile DROP
  doc 1 xmlFreeDoc DROP
  0 xmlCleanupParser DROP
;
: XML_SAVE_URL { uaddr uu faddr fu \ doc -- }
  uaddr uu XML_READ_DOC -> doc
  doc faddr 2 xmlSaveFile DROP
  doc 1 xmlFreeDoc DROP
  0 xmlCleanupParser DROP
;
: XML_SAVE_URL_ENC { enca encu uaddr uu faddr fu \ doc -- }
  enca encu uaddr uu XML_READ_DOC_ENC -> doc
  enca doc faddr 3 xmlSaveFileEnc DROP
  doc 1 xmlFreeDoc DROP
  0 xmlCleanupParser DROP
;
: XML_DOC_TEXT  ( addr u -- addr2 u2 ) { \ doc }
  XML_READ_DOC -> doc
  doc 1 xmlDocGetRootElement
\  doc H-STDOUT 3 xmlElemDump DROP
  1 xmlNodeGetContent ASCIIZ> \ ������ UTF-8
;
\ S" http://www.w3schools.com/xpath/xpath_functions.asp" XML_LIST_NODES
\ S" http://www.forth.org.ru/xpath_functions.asp.htm" S" //td[@valign='top' and starts-with(.,'fn:')]" XML_XPATH
\ S" http://forth.org.ru/log/SpfDevChangeLog.xml" S" //entry[position()<11]/*/name" XML_XPATH
\ S" <dummy/>" S" string(123)" XML_XPATH_MEM
\ S" <dummy/>" S" number(5.5)" XML_XPATH_MEM
\ S" <dummy/>" S" boolean(1)" XML_XPATH_MEM
\ S" http://www.forth.org.ru/rss.xml" S" //link" XML_XPATH
\ S" http://www.forth.org.ru/rss.xml" S" //item/description" XML_XPATH
\ S" http://www.forth.org.ru/rss.xml" S" /rss/channel/image/url" XML_XPATH

\ S" http://www.forth.org.ru/rss.xml" XML_LIST_NODES
\ S" http://www.forth.org.ru/rss.xml" XML_DUMP_NODES
\ S" http://www.forth.org.ru/rss.xml" XML_DOC_TEXT TYPE CR
\ 0 0 S" http://localhost:8989/dsf3.rem?wsdl" DROP 3 xmlReadFile .
\ S" windows-1251" S" http://www.eserv.ru/" S" eserv.xml" XML_SAVE_URL_ENC

\ S" <text attr='zz'>test</text>" XML_READ_DOC_MEM XML_SERIALIZE TYPE
\ S" http://www.forth.org.ru/rss.xml" XML_READ_DOC XML_SERIALIZE TYPE
\ S" UTF-8" S" http://www.forth.org.ru/rss.xml" XML_READ_DOC XML_SERIALIZE_ENC TYPE
