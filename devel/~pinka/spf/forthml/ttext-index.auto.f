






CONCEIVE 
`SEARCH & EXEC, 
`NIP & EXEC, 
`NIP & EXEC, 
BIRTH `CONTAINS NAMING- 
CONCEIVE 
`ROT & EXEC, 
`OVER & EXEC, 
`ULT & EXEC, ZBFW, 
`2DROP & EXEC, 
`DROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`TUCK & EXEC, 
`EQUAL & EXEC, 
BIRTH `STARTS-WITH NAMING- 
CONCEIVE 
`DUP & EXEC, 
`>R & EXEC, 
`2SWAP & EXEC, 
`DUP & EXEC, 
`R@ & EXEC, 
`ULT & EXEC, ZBFW, 
`2DROP & EXEC, 
`2DROP & EXEC, 
`RDROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`R@ & EXEC, 
`- & EXEC, 
`+ & EXEC, 
`R> & EXEC, 
`EQUAL & EXEC, 
BIRTH `ENDS-WITH NAMING- 
CONCEIVE 
`DUP & EXEC, 
`>R & EXEC, 
`SEARCH & EXEC, ZBFW, 
`SWAP & EXEC, 
`R@ & EXEC, 
`+ & EXEC, 
`SWAP & EXEC, 
`R> & EXEC, 
`- & EXEC, EXIT, RFW 
`RDROP & EXEC, 
`DROP & EXEC, 0 LIT, 
BIRTH `SUBSTRING-AFTER NAMING- 
CONCEIVE 3 LIT, 
`PICK & EXEC, 
`>R & EXEC, 
`SEARCH & EXEC, ZBFW, 
`DROP & EXEC, 
`R> & EXEC, 
`TUCK & EXEC, 
`- & EXEC, EXIT, RFW 
`RDROP & EXEC, 
`DROP & EXEC, 0 LIT, 
BIRTH `SUBSTRING-BEFORE NAMING- 
CONCEIVE 3 LIT, 
`PICK & EXEC, 
`>R & EXEC, 
`DUP & EXEC, 
`>R & EXEC, 
`SEARCH & EXEC, ZBFW, 
`OVER & EXEC, 
`R@ & EXEC, 
`+ & EXEC, 
`SWAP & EXEC, 
`R> & EXEC, 
`- & EXEC, 
`ROT & EXEC, 
`R@ & EXEC, 
`- & EXEC, 
`R> & EXEC, 
`SWAP & EXEC, 
`TRUE & EXEC, EXIT, RFW 
`2R> & EXEC, 
`2DROP & EXEC, 
`FALSE & EXEC, 
BIRTH `SPLIT- NAMING- 
CONCEIVE 
`DUP & EXEC, 
`>R & EXEC, 3 LIT, 
`PICK & EXEC, 
`>R & EXEC, 
`SEARCH & EXEC, ZBFW, 
`SWAP & EXEC, 
`R@ & EXEC, 
`OVER & EXEC, 
`R> & EXEC, 
`- & EXEC, 
`2SWAP & EXEC, 
`R@ & EXEC, 
`+ & EXEC, 
`SWAP & EXEC, 
`R> & EXEC, 
`- & EXEC, 
`TRUE & EXEC, EXIT, RFW 
`2R> & EXEC, 
`2DROP & EXEC, 
`FALSE & EXEC, 
BIRTH `SPLIT NAMING- 
CONCEIVE 2 LIT, 
`PICK & EXEC, 
`OVER & EXEC, 
`ULT & EXEC, ZBFW, 
`2DROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`DUP & EXEC, 
`>R & EXEC, 3 LIT, 
`PICK & EXEC, 
`R@ & EXEC, 
`EQUAL & EXEC, 
`0EQ & EXEC, ZBFW, 
`RDROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`SWAP & EXEC, 
`R@ & EXEC, 
`+ & EXEC, 
`SWAP & EXEC, 
`R> & EXEC, 
`- & EXEC, 
`TRUE & EXEC, 
BIRTH `MATCH-STARTS NAMING- 

CONCEIVE 
`DUP & EXEC, ZBFW, 
`SWAP & EXEC, 
`CHAR+ & EXEC, 
`SWAP & EXEC, 
`CHAR- & EXEC, EXIT, RFW 

BIRTH `TAIL NAMING- 
CONCEIVE 
`DUP & EXEC, ZBFW, 
`DROP & EXEC, 
`/CHAR & EXEC, EXIT, RFW 

BIRTH `HEAD NAMING- 
CONCEIVE 
`2DUP & EXEC, 
`HEAD & EXEC, 
`2SWAP & EXEC, 
`TAIL & EXEC, 
BIRTH `HEAD|TAIL NAMING- 
CONCEIVE 
`2DUP & EXEC, 
`TAIL & EXEC, 
`2SWAP & EXEC, 
`HEAD & EXEC, 
BIRTH `TAIL|HEAD NAMING- 



CONCEIVE 
`DUP & EXEC, 
`0= & EXEC, ZBFW, 
`DROP & EXEC, EXIT, RFW 
`DUP & EXEC, 1 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`LIT, & EXEC, EXIT, RFW 
`DUP & EXEC, 2 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`LIT, & EXEC, `LIT, & LIT, 
`EXEC, & EXEC, EXIT, RFW 
`1- & EXEC, 
`SWAP & EXEC, 
`LIT, & EXEC, 
`LIT, & EXEC, GERM LIT, 
`EXEC, & EXEC, 
BIRTH `TS-LIT NAMING- 
CONCEIVE 
`DUP & EXEC, 
`0= & EXEC, ZBFW, 
`DROP & EXEC, 
`EXECUTE & EXEC, EXIT, RFW 
`DUP & EXEC, 1 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`EXEC, & EXEC, EXIT, RFW 
`DUP & EXEC, 2 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`LIT, & EXEC, `EXEC, & LIT, 
`EXEC, & EXEC, EXIT, RFW 
`1- & EXEC, 
`SWAP & EXEC, 
`LIT, & EXEC, 
`LIT, & EXEC, GERM LIT, 
`EXEC, & EXEC, 
BIRTH `TS-EXEC NAMING- 
CONCEIVE 
`DUP & EXEC, 
`0= & EXEC, ZBFW, 
`DROP & EXEC, EXIT, RFW 
`DUP & EXEC, 1 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`SLIT, & EXEC, EXIT, RFW 
`DUP & EXEC, 2 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`SLIT, & EXEC, `SLIT, & LIT, 
`EXEC, & EXEC, EXIT, RFW 
`1- & EXEC, 
`-ROT & EXEC, 
`SLIT, & EXEC, 
`LIT, & EXEC, GERM LIT, 
`EXEC, & EXEC, 
BIRTH `TS-SLIT NAMING- 
CONCEIVE 
`DUP & EXEC, 
`0= & EXEC, ZBFW, 
`DROP & EXEC, EXIT, RFW 
`DUP & EXEC, 1 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`2LIT, & EXEC, EXIT, RFW 
`DUP & EXEC, 2 LIT, 
`= & EXEC, ZBFW, 
`DROP & EXEC, 
`2LIT, & EXEC, `2LIT, & LIT, 
`EXEC, & EXEC, EXIT, RFW 
`1- & EXEC, 
`-ROT & EXEC, 
`2LIT, & EXEC, 
`LIT, & EXEC, GERM LIT, 
`EXEC, & EXEC, 
BIRTH `TS-2LIT NAMING- 

ALIGN HERE 0 , CONCEIVE LIT, BIRTH `STATE NAMING- 


ALIGN HERE 0 , CONCEIVE LIT, BIRTH `M NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, -5005 LIT, 
`THROW & EXEC, RFW 
`M & EXEC, 
`1+! & EXEC, 
BIRTH `INC-M NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, 
`0= & EXEC, ZBFW, -5004 LIT, 
`THROW & EXEC, RFW 
`M & EXEC, 
`1-! & EXEC, 
BIRTH `DEC-M NAMING- 
CONCEIVE 
`STATE & EXEC, 
`1+! & EXEC, 
BIRTH `INC-S NAMING- 
CONCEIVE 
`STATE & EXEC, 
`@ & EXEC, 
`0= & EXEC, ZBFW, -5004 LIT, 
`THROW & EXEC, RFW 
`STATE & EXEC, 
`1-! & EXEC, 
BIRTH `DEC-S NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-LIT & EXEC, GERM LIT, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, EXIT, RFW RFW 
`STATE & EXEC, 
`@ & EXEC, 
`TS-LIT & EXEC, 
BIRTH `T-LIT NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-LIT & EXEC, GERM LIT, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, EXIT, RFW RFW 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, 
BIRTH `T-EXEC NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-SLIT & EXEC, GERM LIT, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, EXIT, RFW RFW 
`STATE & EXEC, 
`@ & EXEC, 
`TS-SLIT & EXEC, 
BIRTH `T-SLIT NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-2LIT & EXEC, GERM LIT, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, EXIT, RFW RFW 
`STATE & EXEC, 
`@ & EXEC, 
`TS-2LIT & EXEC, 
BIRTH `T-2LIT NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-LIT & EXEC, GERM LIT, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, EXIT, RFW RFW 

BIRTH `M-LIT NAMING- 
CONCEIVE 
`M & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, ZBFW, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-LIT & EXEC, GERM LIT, 
`STATE & EXEC, 
`@ & EXEC, 
`TS-EXEC & EXEC, EXIT, RFW RFW 
`EXECUTE & EXEC, 
BIRTH `M-EXEC NAMING- 
CONCEIVE 
`DEC-S & LIT, 
`M-EXEC & EXEC, 
BIRTH `M-DEC-STATE NAMING- 
CONCEIVE 
`INC-S & LIT, 
`M-EXEC & EXEC, 
BIRTH `M-INC-STATE NAMING- 




CONCEIVE 
`DUP & EXEC, 1 LIT, 
`ULT & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`2DUP & EXEC, 
`OVER & EXEC, 
`C@ & EXEC, `- DROP C@ LIT, 
`= & EXEC, 
`DUP & EXEC, 
`>R & EXEC, ZBFW, 
`1- & EXEC, 
`SWAP & EXEC, 
`CHAR+ & EXEC, 
`SWAP & EXEC, RFW 0 LIT, 0 LIT, 
`2SWAP & EXEC, 
`>NUMBER & EXEC, 
`NIP & EXEC, ZBFW, 
`RDROP & EXEC, 
`2DROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`R> & EXEC, ZBFW, 
`DNEGATE & EXEC, RFW 
`2SWAP & EXEC, 
`2DROP & EXEC, 
`TRUE & EXEC, 
BIRTH `I-DLIT NAMING- 
CONCEIVE 
`I-DLIT & EXEC, ZBFW, 
`D>S & EXEC, 
`TRUE & EXEC, EXIT, RFW 
`FALSE & EXEC, 
BIRTH `I-LIT NAMING- 
CONCEIVE 
`DUP & EXEC, 2 LIT, 
`ULT & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`2DUP & EXEC, 
`1- & EXEC, 
`CHARS & EXEC, 
`+ & EXEC, 
`C@ & EXEC, `. DROP C@ LIT, 
`= & EXEC, ZBFW, 
`1- & EXEC, 
`I-DLIT & EXEC, ZBFW, 
`TRUE & EXEC, EXIT, RFW 
`1+ & EXEC, RFW 
`FALSE & EXEC, 
BIRTH `I-DLIT-FORM NAMING- 
CONCEIVE 
`DUP & EXEC, 3 LIT, 
`ULT & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`OVER & EXEC, 2 LIT, `0x SLIT, 
`CEQUAL & EXEC, 
`0EQ & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`OVER & EXEC, 
`CHAR+ & EXEC, 
`CHAR+ & EXEC, 
`OVER & EXEC, 2 LIT, 
`- & EXEC, 
`BASE & EXEC, 
`@ & EXEC, 
`>R & EXEC, 
`HEX & EXEC, 
`I-LIT & EXEC, 
`R> & EXEC, 
`BASE & EXEC, 
`! & EXEC, ZBFW, 
`NIP & EXEC, 
`NIP & EXEC, 
`TRUE & EXEC, EXIT, RFW 
`2DROP & EXEC, 
`FALSE & EXEC, 
BIRTH `I-HLIT-FORM NAMING- 
CONCEIVE 
`DUP & EXEC, 2 LIT, 
`ULT & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`OVER & EXEC, 
`C@ & EXEC, `` DROP C@ LIT, 
`NEQ & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`1- & EXEC, 
`SWAP & EXEC, 
`CHAR+ & EXEC, 
`SWAP & EXEC, 
`TRUE & EXEC, 
BIRTH `I-SLIT-FORM NAMING- 
CONCEIVE 
`SFIND & EXEC, 
`0NEQ & EXEC, 
BIRTH `I-NATIVE NAMING- 



CONCEIVE 
`STATE & EXEC, 
`@ & EXEC, 
BIRTH `STATE? NAMING- 
CONCEIVE 
`STATE & EXEC, 
`@ & EXEC, 
`0EQ & EXEC, 
BIRTH `STATE0? NAMING- 




CONCEIVE 
`SP@ & EXEC, 
`>R & EXEC, 
`EXECUTE & EXEC, 
`SP@ & EXEC, 
`R> & EXEC, 
`EQ & EXEC, 
`0EQ & EXEC, ZBFW, -5010 LIT, 
`THROW & EXEC, RFW 

BIRTH `EXECUTE-BALANCED(+1) NAMING- 
CONCEIVE 
`>R & EXEC, `:: SLIT, 
`SPLIT- & EXEC, 
`0EQ & EXEC, ZBFW, 
`R> & EXEC, 
`SEARCH-WORDLIST & EXEC, EXIT, RFW 
`R> & EXEC, 
`SEARCH-WORDLIST & EXEC, 
`0EQ & EXEC, ZBFW, 
`2DROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`EXECUTE-BALANCED(+1) & EXEC, GERM gtCS BBW, 

BIRTH `(I-QNATIVE) NAMING- 
CONCEIVE 
`2DUP & EXEC, `:: SLIT, 
`SPLIT- & EXEC, 
`0EQ & EXEC, ZBFW, 
`2DROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`I-NATIVE & EXEC, 
`0EQ & EXEC, ZBFW, 
`2DROP & EXEC, 
`2DROP & EXEC, 
`FALSE & EXEC, EXIT, RFW 
`EXECUTE-BALANCED(+1) & EXEC, 
`(I-QNATIVE) & EXEC, 
`0EQ & EXEC, ZBFW, 
`FALSE & EXEC, EXIT, RFW 
`NIP & EXEC, 
`NIP & EXEC, 
`TRUE & EXEC, 
BIRTH `I-QNATIVE NAMING- 

CONCEIVE 
`I-SLIT-FORM & EXEC, ZBFW, 
`T-SLIT & EXEC, EXIT, RFW 
`I-NATIVE & EXEC, ZBFW, 
`T-EXEC & EXEC, EXIT, RFW 
`I-QNATIVE & EXEC, ZBFW, 
`T-EXEC & EXEC, EXIT, RFW 
`I-LIT & EXEC, ZBFW, 
`T-LIT & EXEC, EXIT, RFW 
`I-HLIT-FORM & EXEC, ZBFW, 
`T-LIT & EXEC, EXIT, RFW 
`I-DLIT-FORM & EXEC, ZBFW, 
`T-2LIT & EXEC, EXIT, RFW 
`CR & EXEC, 
`TYPE & EXEC, 
`CR & EXEC, -321 LIT, 
`THROW & EXEC, 
BIRTH `T-NAME NAMING- 
CONCEIVE 
MBW 
`FINE-HEAD & EXEC, 
`SPLIT-WHITE-FORCE & EXEC, 
`2>R & EXEC, 
`DUP & EXEC, ZBFW2, 
`T-NAME & EXEC, 
`2R> & EXEC, BBW, RFW 
`2DROP & EXEC, 
`RDROP & EXEC, 
`RDROP & EXEC, 
BIRTH `T-PLAIN NAMING- 






ALIGN HERE 0 , CONCEIVE LIT, BIRTH `chain-current NAMING- 
ALIGN HERE 0 , CONCEIVE LIT, BIRTH `chain-context NAMING- 
CONCEIVE 0 LIT, 
`, & EXEC, 
`HERE & EXEC, 
`SWAP & EXEC, 
`, & EXEC, 
`chain-current & EXEC, 
`@ & EXEC, 
`BIND-NODE & EXEC, 
BIRTH `advice-before NAMING- 
CONCEIVE 0 LIT, 
`, & EXEC, 
`HERE & EXEC, 
`SWAP & EXEC, 
`, & EXEC, 
`chain-current & EXEC, 
`@ & EXEC, 
`BIND-NODE-TAIL & EXEC, 
BIRTH `advice-after NAMING- 
CONCEIVE 
`chain-context & EXEC, 
`@ & EXEC, 
`DUP & EXEC, 
`0EQ & EXEC, ZBFW, EXIT, RFW 
`@ & EXEC, MBW 
`DUP & EXEC, ZBFW2, 
`DUP & EXEC, 
`>R & EXEC, 
`@ & EXEC, 
`EXECUTE & EXEC, ZBFW, 
`RDROP & EXEC, 
`TRUE & EXEC, EXIT, RFW 
`R> & EXEC, 
`CELL- & EXEC, 
`@ & EXEC, BBW, RFW 


BIRTH `perform-chain NAMING- 
CONCEIVE 
`perform-chain & EXEC, ZBFW, EXIT, RFW 
`ABORT & EXEC, 
BIRTH `perform-chain-sure NAMING- 

ALIGN HERE 0 , CONCEIVE LIT, BIRTH `rules-default NAMING-  rules-default DUP chain-current ! chain-context !

 CONCEIVE 
`advice-after & EXEC, 
BIRTH `advice-rule-after NAMING- 
CONCEIVE 
`advice-before & EXEC, 
BIRTH `advice-rule-before NAMING- 
CONCEIVE 
`perform-chain & EXEC, ZBFW, EXIT, RFW -5321 LIT, 
`THROW & EXEC, 
BIRTH `trans-node-force NAMING- 
CONCEIVE 
`chain-context & EXEC, 
`@ & EXEC, 
`>R & EXEC, 
`chain-context & EXEC, 
`! & EXEC, 
`trans-node-force & EXEC, 
`R> & EXEC, 
`chain-context & EXEC, 
`! & EXEC, 
BIRTH `apply-rules NAMING- 


CONCEIVE `: SLIT, 
`SPLIT- & EXEC, 
`0= & EXEC, ZBFW, 
`2DUP & EXEC, `# SLIT, 
`STARTS-WITH & EXEC, ZBFW, 0 LIT, 0 LIT, EXIT, RFW 0 LIT, 0 LIT, RFW 
`Namespace-uri-for-prefix & EXEC, 
BIRTH `name-n-uri NAMING- 
CONCEIVE 
`cnode & EXEC, 
`>R & EXEC, 
`FirstChild & EXEC, MBW 
`cnode & EXEC, ZBFW2, 
`trans-node-force & EXEC, 
`NextSibling & EXEC, BBW, RFW 
`R> & EXEC, 
`cnode! & EXEC, 
BIRTH `trans-childs NAMING- 
CONCEIVE 
`cnode & EXEC, 
`>R & EXEC, 
`documentElement & EXEC, 
`cnode! & EXEC, 
`trans-childs & EXEC, 
`R> & EXEC, 
`cnode! & EXEC, 
BIRTH `trans-document NAMING- 



ALIGN HERE 0 , CONCEIVE LIT, BIRTH `_document-storage NAMING- 
ALIGN HERE 0 , CONCEIVE LIT, BIRTH `_document-top NAMING- 
CONCEIVE 
`_document-storage & EXEC, 
`@ & EXEC, 
`DUP & EXEC, ZBFW, EXIT, RFW 
`DROP & EXEC, 256000 LIT, 
`NEW-STORAGE & EXEC, 
`DUP & EXEC, 
`_document-storage & EXEC, 
`! & EXEC, 
BIRTH `document-storage NAMING- 
CONCEIVE 
`DISMOUNT & EXEC, 
`>R & EXEC, 
`document-storage & EXEC, 
`MOUNT & EXEC, 0 LIT, 
`, & EXEC, 
`HERE & EXEC, 
`_document-top & EXEC, 
`BIND-NODE & EXEC, 
`, & EXEC, 
`S", & EXEC, 
`DISMOUNT & EXEC, 
`DROP & EXEC, 
`R> & EXEC, 
`MOUNT & EXEC, 
BIRTH `push-document NAMING- 
CONCEIVE 
`DISMOUNT & EXEC, 
`>R & EXEC, 
`document-storage & EXEC, 
`MOUNT & EXEC, 
`_document-top & EXEC, 
`UNBIND-NODE & EXEC, 
`CELL- & EXEC, 
`HERE & EXEC, 
`- & EXEC, 
`ALLOT & EXEC, 
`DISMOUNT & EXEC, 
`DROP & EXEC, 
`R> & EXEC, 
`MOUNT & EXEC, 
BIRTH `drop-document NAMING- 
CONCEIVE 
`_document-top & EXEC, 
`@ & EXEC, 
`CELL+ & EXEC, 
`COUNT & EXEC, 
BIRTH `document-url NAMING- 
CONCEIVE 
`document-url & EXEC, 
`CUT-PATH & EXEC, 
BIRTH `document-base NAMING- 
CONCEIVE 
`_document-top & EXEC, 
`@ & EXEC, 
`0= & EXEC, ZBFW, EXIT, RFW 
`DISMOUNT & EXEC, 
`>R & EXEC, 
`document-storage & EXEC, 
`MOUNT & EXEC, 
`HERE & EXEC, 
`>R & EXEC, 
`document-base & EXEC, 
`S, & EXEC, 
`S, & EXEC, 
`R> & EXEC, 
`HERE & EXEC, 
`OVER & EXEC, 
`- & EXEC, 0 LIT, 
`, & EXEC, 
`DISMOUNT & EXEC, 
`DROP & EXEC, 
`R> & EXEC, 
`MOUNT & EXEC, 
BIRTH `document-based-url NAMING- 
CONCEIVE 
`_document-top & EXEC, 
`@ & EXEC, 
`0= & EXEC, ZBFW, EXIT, RFW 
`DISMOUNT & EXEC, 
`>R & EXEC, 
`document-storage & EXEC, 
`MOUNT & EXEC, 
`HERE & EXEC, 
`>R & EXEC, 
`BaseURI & EXEC, 
`S, & EXEC, 
`S, & EXEC, 
`R> & EXEC, 
`HERE & EXEC, 
`OVER & EXEC, 
`- & EXEC, 0 LIT, 
`, & EXEC, 
`DISMOUNT & EXEC, 
`DROP & EXEC, 
`R> & EXEC, 
`MOUNT & EXEC, 
BIRTH `cnode-based-url NAMING- 


CONCEIVE 
`2DUP & EXEC, 
`DefaultLSParser & EXEC, 
`parseURI & EXEC, 
`DUP & EXEC, 
`0= & EXEC, ZBFW, -5003 LIT, 
`THROW & EXEC, RFW 
`DUP & EXEC, 
`>R & EXEC, 
`push-document & EXEC, 
`R@ & EXEC, 
`trans-document & EXEC, 
`R> & EXEC, 
`DefaultLSParser & EXEC, 
`freeDoc & EXEC, 
`drop-document & EXEC, 
BIRTH `EMBODY NAMING- 
CONCEIVE 
`2DUP & EXEC, `/ SLIT, 
`SPLIT- & EXEC, ZBFW, `: SLIT, 
`SUBSTRING-BEFORE & EXEC, 
`NIP & EXEC, ZBFW, 
`2DROP & EXEC, 
`EMBODY & EXEC, 
EXIT, 
RFW RFW 
`2DROP & EXEC, 
`cnode-based-url & EXEC, 
`EMBODY & EXEC, 
BIRTH `Embody NAMING- 



