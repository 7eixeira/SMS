
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"               
#INCLUDE "fileio.ch"      
#INCLUDE "tbiConn.ch"
#INCLUDE "ap5mail.ch"

// JOSE TEIXEIRA | BOSSWARE

#DEFINE __EOF "*"
#DEFINE __FILE_ERROR -1
#DEFINE __TRUE__  .T.
#DEFINE __FALSE__  .F.
#DEFINE __CONNECT 'TOPCONN'  
#DEFINE __LOG "*"          
#DEFINE __END_SERVICE__ EXIT
#DEFINE __USERFUNCTION "U_"
#DEFINE __EXTENSION__  '*.TXT'       
#DEFINE __TAB ","
#DEFINE __ASPAS '"'
#DEFINE  __ENTER__ CHR( 13 ) + CHR( 10 )                
#DEFINE __USADO      "€€€€€€€€€€€€€€"   // USADO
#DEFINE __NUSADO     "€€€€€€€€€€€€€€€"  // Não Usado
#DEFINE __RESERV     "€€"               // NO USADO / NO BROWSE
#DEFINE __RESERVE_W  "þÀ"               // USADO / NO BROWSE
#DEFINE __OBRIGA     "€"                // OBRIGATORIO



/*
####################################################################################################
## 												  												  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY  | DATA | 15/05/2016                                                       ##
##                                                                                                ##
##                                                                                                ##
##           C L A S S E     P A R A    E N V I  O      D E      S M S                            ##
##                                                                                                ##
##                                                                                                ##
##                                                                                                ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


class TSMS

   data __this 
   data lNew as logical 
   data clsName
   

   method send( cMsg, cNumero ) 
   method thisObject(obj) 
   method New( cClsName ) constructor  
   method getParam()
   method getStatus()
     
endclass           
          


method New( cClsName ) class TSMS
local cPathLog  :=  GetSrvProfString("Startpath","") + 'TSMS\'

  ::lNew:= .T.  
                               
  IF;
     !Empty(ALLTRIM(cClsName ))
     ::clsName := cClsName
  Else
     ::clsName := 'NO_CLS'
  EndIF   

//IF !File(cPathLog+"sms.end" ) 
//	__createKey( cPathLog ) 
//EndIF



IF File(cPathLog+"TSMS.ATS" ) 
     ConOut(PadC(" -- BOSSWARE SMS SEND -- BLOCKED ! ",80))
EndIF 	     

 
return nil

/*     
####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                                            ##
##------------------------------------------------------------------------------------------------##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/

 
method send( cMsg, cNumero ) class TSMS
local cEnv 	 := GetEnvServer() 
local lStart := __TRUE__
local cPathLog  :=  GetSrvProfString("Startpath","") + 'TSMS\'
local cEmp := "" 
local cFil := ""
local cEmpresa := ""
local __APPUSER 
local __BLOCK_PROCESS := {}
local aRet := {}
local __cNAlias
local nI := 0
local nY := 1
local aSMS := {}
local cServerIni := GetAdv97()
local cSecao := "TSMS"
local cPorta := "PORT"
local cEmail := "SPED"
local cLog   := "TLOG"

local __BLOCK := {||}
local __BLOCK_PROCESS						  							    
local aData
local __INIT
local __TIME
local cTime 
local lProcess := .F.
local __DATA 
local lOpen 
local __IDHd 
local __nInterval
local aSMSParam := {}
local lRet  
local nHdll
local cString := ""
                               
   	         			
	
//		__IDHd := LS_GetID()
aSMSParam := ::getParam()
cString := ALLTRIM (  aSMSParam[1]+":"+aSMSParam[2]+",N,8,1" )



AADD( aSMS,   'AT+CMGF=1' )
AADD( aSMS,   'AT+CMGS="+55' +cNumero +'"' )
AADD( aSMS,   ALLTRIM( cMsg ) )


lRet := MsOpenPort(@nHdll, cString )                                  

IF lRet

	      ConOut(PadC(" -- BOSSWARE SMS SEND --  ",80))
	     
	      /*
          MsWrite(nHdll,"AT+CMGF=1" )  
          MsWrite(nHdll,CHR(13) )

          MsWrite(nHdll,ALLTRIM( 'AT+CMGS="+55"'+cNumero+'"') )            

          MsWrite(nHdll,CHR(13) )

          MsWrite(nHdll,CHR(26) )                                          

          MsClosePort(nHdll)   
          */
          
          

          MsWrite(nHdll,"AT+CMGF=1" )  
          MsWrite(nHdll,CHR(13) )
//          Alert( MSRead(nHdll,"AT+CMGF=1") )
//        MsWrite(nHdll,'AT+CMGS="+5587981125778"' )            
//          MsWrite(nHdll,'AT+CMGS="+5581999259770"' )            
          MsWrite(nHdll,aSMS[2] )            
          MsWrite(nHdll,CHR(13) )
          MsWrite(nHdll, cMsg )                      
          MsWrite(nHdll,CHR(13) )                                
          MsWrite(nHdll,CHR(26) )                                          
          MsWrite(nHdll,'AT+CMGR=1')
          MsWrite(nHdll,CHR(13) )             
//          Alert( MSRead(nHdll,"AT+CMGR=1") )          
          MsClosePort(nHdll)             
          
	      ConOut(PadC(" -- BOSSWARE SMS SEND   [ " +  cNumero   + " ] " + " -- " + Time() ,80)) 

Else	      
	      ConOut(PadC(" -- BOSSWARE SMS SEND -- FAILED ! ",80))	      
	      
EndIF



Return

/*     
####################################################################################################
## 																								  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                                              		      ##
##------------------------------------------------------------------------------------------------##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/


method getParam() class TSMS
local aParam := {}

local cServerIni := GetAdv97()
local cSecao := "TSMS"
local cPort := "PORT"
local cSpeed := "SPEED"
local cSend   := "SEND"
local cLog  := "LOG"                                                                 



AADD( aParam, GetPvProfString(cSecao, cPort, "@@", cServerIni)  )
AADD( aParam, GetPvProfString(cSecao, cSpeed, "@@", cServerIni) )
AADD( aParam, GetPvProfString(cSecao, cSend, "@@", cServerIni)  )
AADD( aParam, GetPvProfString(cSecao, cLog, "@@", cServerIni)  )

return aParam


method getStatus( ) class TSMS
local cEnv 	 := GetEnvServer() 
local lStart := __TRUE__
local cPathLog  :=  GetSrvProfString("Startpath","") + 'TSMS\'
local cEmp := "" 
local cFil := ""
local cEmpresa := ""
local __APPUSER 
local __BLOCK_PROCESS := {}
local aRet := {}
local __cNAlias
local nI := 0
local nY := 1
local aSMS := {}
local cServerIni := GetAdv97()
local cSecao := "TSMS"
local cPorta := "PORT"
local cEmail := "SPED"
local cLog   := "TLOG"

local __BLOCK := {||}
local __BLOCK_PROCESS						  							    
local aData
local __INIT
local __TIME
local cTime 
local lProcess := .F.
local __DATA 
local lOpen 
local __IDHd 
local __nInterval
local aSMSParam := {}
local lRet  
local nHdll
local cString := ""
                               
   	         			
	

aSMSParam := ::getParam()
cString := ALLTRIM (  aSMSParam[1]+":"+aSMSParam[2]+",N,8,1" )


lRet := MsOpenPort(@nHdll, cString )                                  

IF lRet

	      ConOut(PadC(" -- BOSSWARE SMS STATUS -- [ OK ]",80))
          


Else	      
	      ConOut(PadC(" -- BOSSWARE SMS STATUS -- [ FAILED!] ",80))	      
	      
EndIF



Return lRet

/*     

####################################################################################################
## 												  ##												  ##																						
## BY      : JOSE TEIXEIRA                                                                        ##
##------------------------------------------------------------------------------------------------##
## BOSSWARE TECHNOLOGY                                       			                  ##
##------------------------------------------------------------------------------------------------##
####################################################################################################
*/



Static Function __createKey( cPathLog )
local cServerIni := GetAdv97()
WritePProString('TSMS', 'PORT', 'COM1', cServerIni )  
WritePProString('TSMS', 'SPEED', '9600', cServerIni )  
WritePProString('TSMS', 'SEND', '1', cServerIni )  
WritePProString('TSMS', 'LOG', '\TSMS', cServerIni )  
 

MAKEDIR( cPathLog )
MAKEDIR( cPathLog+'\TSMS' )         

Return NIL


User Function FWTSMS( cMsg, cNumero )
private lEnvSMS := SuperGetMV("ES_ENVSMS", ,.T. )      
private oTSMS := TSMS():New('SMS')   


IF lEnvSMS    //  permite envio de sms
	oTSMS:Send( @cMsg, @cNumero ) 
EndIF
                  
Return


User Function SSMS(  )
	U_FWTSMS( ' Prezado cliente, identificamos titulos em atraso. Caso pagos, desconsidere esse aviso. Ligue: 8796007776', 'AQUI_O_CELULAR_DESTINO' )

Return


