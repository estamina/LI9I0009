!=============================================================================
! Author:  Marcel Lakatos (SIEMENS PSE ECT MSP4; SLOVAKIA; marcel.lakatos@siemens.com)
! TC name: AN5I0201
! Description: PIT: INVITE on P-CSCF (originating side);
!                   Forwarding Emergency Requests of registered user to E-CSCF
!
! (c) 2007 Siemens AG
!==============================================================================
#ASSIGN {%cfgAuthenticationMethod} 'PoCDig'
#CONST cfgOeq     '-oeq'
#ASSIGN {%cfgQop} 'auth'

#INCLUDE $STC_TEMP_PATH/config.inc
#INCLUDE $STC_TEMP_PATH/subscribers.inc
#INCLUDE $CC_IIT_COMMON_SIP_PATH/CommonMacros.inc

! ____  P-CSCF communicates on KGW port (by default 5066) propagated from .exp as PCSCF_PRT const

#ASSIGN {%mgvPcscfPort}             '$PCSCF_PRT'
#ASSIGN {%cmdpSENDDestPort}         '$mgvPcscfPort'
!BM
!#ASSIGN {%cmdpRECEIVEIgnore} 'P-NokiaSiemens.Session-Info P-Asserted-Identity Proxy-Authorization P-com.Siemens.Corr-ID'
#ASSIGN {%cmdpRECEIVEIgnore} 'P-NokiaSiemens.Session-Info Authentication-Info'


#ASSIGN {%CALLID_INV} '$P_RND@$usdUSERPSTN_IP_ADDRESS' 

#DEFMACRO id1
#BEGIN
P-NokiaSiemens.Session-Info: corrID=$CALLID_INV; originator=<$usdUSERPSTN_PUBLIC_ID>; <$usdUSERPSTN_PUBLIC_ID>\r
!P-com.Session-Info: corrID=$CALLID_INV; <$usdUSERPSTN_PUBLIC_ID>
#EDEFMACRO
#ASSIGN {%mySupp1} '$MACRO2STRING(id1)'
 
!-------- registration --------------------------------------------------------
$MACRO(cmRegistration,              'user1', '', 'reg', '$lcORIG')
!------------------------------------------------------------------------------
!$MACRO(cuPredefineObject, 'cmSendINVITE_Initial', '',  'user1', 'user2', 'ses', 'mhSupplementaryEntry', 'P-Asserted-Identity: <$usdUSEREMERGENCY_PUBLIC_ID>, <$usdUSERPSTN_PUBLIC_ID>')
!$MACRO(cuPredefineObject, 'cmSendINVITE_Initial', '', 'user1', 'user2', 'ses', 'mhSupplementaryEntry', $mySupp1) 
!-------- predefine of objects ------------------------------------------------
$MACRO(cuPredefineObject, 'cmSendINVITE_Initial', '',  'user1', 'user2', 'ses', 'mhRoute', 'Route: <sip:$TESTBED1_IP4_PCSCF1_GM_NAME:$PCSCF_PRT>')
$MACRO(cuPredefineObject, 'cmReceiveINVITE_Initial_200', '',  'user1', 'user2', 'ses', 'mhPAssertedIdentity', '')
$MACRO(cuPredefineObject, 'cmReceiveINVITE_Initial_200', '',  'user1', 'user2', 'ses', 'mhPComSiemensCallingPartyId', '')
!------------------------------------------------------------------------------

#CONST RESUME_TIMEOUT '100000'
#TIMER ReadyTimer1_1 -a wait_for -v $RESUME_TIMEOUT -log 1

#ASSIGN {%cmdpRECEIVEIgnore} 'Record-Route Via P-Asserted-Identity P-Com.Siemens.Calling-Party-ID'
 
!-------- establish session ---------------------------------------------------
$MACRO(cmEstablishSessionOrig,       'user1', 'user2', 'ses', '$lcORIG,$lcTERM')
!------------------------------------------------------------------------------

!-------- release session -----------------------------------------------------
$MACRO(cmReleaseSessionOrig,         'user1', 'user2', 'ses', '$lcORIG,$lcTERM')
!------------------------------------------------------------------------------

!-------- de-registration -----------------------------------------------------
$MACRO(cmDeregistration,            'user1', '', 'reg', '$lcORIG')
!------------------------------------------------------------------------------

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
