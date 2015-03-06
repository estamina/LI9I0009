!=============================================================================
! Author:  Marcel Lakatos (SIEMENS PSE ECT MSP4; SLOVAKIA; marcel.lakatos@siemens.com)
! TC name: AN5I0201
! Description: PIT: INVITE on P-CSCF (originating side);
!                   Forwarding Emergency Requests of registered user to E-CSCF
!                 
!              (all with using envelope macros)
!
! (c) 2006 Siemens AG
!==============================================================================
#ASSIGN {%cfgAuthenticationMethod} 'PoCDig'
#CONST cfgOeq     '-oeq'
#ASSIGN {%cfgQop} 'auth'

#INCLUDE $STC_TEMP_PATH/config.inc
#INCLUDE $STC_TEMP_PATH/subscribers.inc
#INCLUDE $CC_IIT_COMMON_SIP_PATH/CommonMacros.inc

!BM
#ASSIGN {%cmdpRECEIVEIgnore} 'P-NokiaSiemens.Session-Info P-Asserted-Identity Proxy-Authorization P-com.Siemens.Corr-ID P-com.Session-Info'
!#ASSIGN {%cmdpRECEIVEIgnore} 'P-NokiaSiemens.Session-Info'

! ____  P-CSCF communicates on KGW port (by default 5066) propagated from .exp as PCSCF_PRT const
#ASSIGN {%mgvPcscfPort_old}         '$mgvPcscfPort'
#ASSIGN {%mgvPcscfPort}             '$PCSCF_PRT'
!#ASSIGN {%cmdpSENDDestPort}         '$mgvPcscfPort'
#ASSIGN {%BGCF_Port}             '5050'

#CONST RESUME_TIMEOUT '500000'
#TIMER ReadyTimer1_2 -a wait_for -v $RESUME_TIMEOUT -log 1

#DEFMACRO id3
#BEGIN
P-NokiaSiemens.Session-Info: bearer=yes; corrID=%trash1; originator=<$usdSUBSCRIBER_A_PUBLIC_ID>\r
P-com.Session-Info: corrID=%trash2
#EDEFMACRO
#ASSIGN {%mySupp3} '$MACRO2STRING(id3)'


!-------- predefine macros ---------------------------------------------------
$MACRO(cuPredefineObject, 'cmReceiveINVITE_Initial', '',  'user1', 'user2', 'ses', 'mheRequestLine_RequestUri', 'sip:$usd$lcTERM_SIP_NAME@$usd$lcTERM_IP_ADDRESS:$usd$lcTERM_PORT;user=phone')
$MACRO(cuPredefineObject, 'cmReceiveINVITE_Initial', '',  'user1', 'user2', 'ses', 'mhPCalledPartyId', '')
!------------------------------------------------------------------------------

#ASSIGN {%cmdpRECEIVEIgnore} 'P-NokiaSiemens.Session-Info P-com.Session-Info Record-Route Via P-Charging-Vector Proxy-Authorization'
!#ASSIGN {%cmdpRECEIVEIgnore} 'P-NokiaSiemens.Session-Info Record-Route Via Proxy-Authorization'
#ASSIGN {%cmdpSENDDestAddress} '$TESTBED1_IP4_SCSCF1_MW_IP'
#ASSIGN {%cmdpSENDDestPort} '$BGCF_Port'


#DEFMACRO id1
#BEGIN
P-NokiaSiemens.Session-Info: bearer=yes
#EDEFMACRO

#ASSIGN {%mySupp1} '$MACRO2STRING(id1)'

!$MACRO(cuPredefineObject, 'cmSendINVITE_Initial_200', '', 'user1', 'user2', 'ses', 'mhSupplementaryEntry', 'P-NokiaSiemens.Session-Info: bearer=yes')
!$MACRO(cuPredefineObject, 'cmSendINVITE_Initial_200', '', 'user1', 'user2', 'ses', 'mhSupplementaryEntry', $mySupp1)
 
!-------- establish session ---------------------------------------------------
$MACRO(cmEstablishSessionTerm,       'user1', 'user2', 'ses', '$lcORIG,$lcTERM')
!$MACRO(cmSendINVITE_Initial_200,       'user1', 'user2', 'ses', '$lcTERM,$lcORIG')
!$MACRO(cmReceiveACK_Initial,       'user1', 'user2', 'ses', '$lcORIG,$lcTERM')

!------------------------------------------------------------------------------

!#ASSIGN {%cmdpRECEIVEIgnore} ''
#ASSIGN {%mgvPcscfPort}             '$mgvPcscfPort_old'
#ASSIGN {%cmdpSENDDestPort} '5090'
!-------- release session -----------------------------------------------------
$MACRO(cmReleaseSessionTerm,         'user1', 'user2', 'ses', '$lcORIG,$lcTERM')
!------------------------------------------------------------------------------





