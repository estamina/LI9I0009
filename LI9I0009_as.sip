!=============================================================================
! Author:  Marcel Lakatos (SIEMENS PSE ECT MSP4; SLOVAKIA; marcel.lakatos@siemens.com)
! TC name: AN5I0201
! Description: PIT: INVITE on P-CSCF (originating side);
!                   Forwarding Emergency Requests of registered user to E-CSCF
!
! (c) 2007 Siemens AG
!==============================================================================

#INCLUDE $STC_TEMP_PATH/config.inc
#INCLUDE $STC_TEMP_PATH/subscribers.inc
#INCLUDE $CC_IIT_COMMON_SIP_PATH/CommonMacros.inc

#ASSIGN {%cfgAsAccess}        'MO'
#ASSIGN {%cfgEmergencyCall}   'yes'

#CONST AUTH_METHOD            'PoCDig'

#ASSIGN {%cmdpRECEIVEIgnore}  'P-Served-User P-com.Siemens.Access-Information P-Charging-Vector P-NokiaSiemens.Session-Info' 
!#ASSIGN {%cmdpRECEIVEIgnore}  'P-Served-User P-com.Siemens.Access-Information P-NokiaSiemens.Session-Info' 

#CONST RESUME_TIMEOUT '100000'
#TIMER ReadyTimer1_AS -a wait_for -v $RESUME_TIMEOUT -log 1







#DEFMACRO id3
#BEGIN
P-NokiaSiemens.Session-Info: bearer=yes; corrID=%trash1; originator=<$usdSUBSCRIBER_A_PUBLIC_ID>\r
P-com.Session-Info: corrID=%trash2
#EDEFMACRO
#ASSIGN {%mySupp3} '$MACRO2STRING(id3)'



!------------------------------------------------------------------------------
!$MACRO(cuPredefineObject, 'cm_AS_SendINVITE_Initial', '',  'user1', 'user2', 'sesA_AS', 'mhSupplementaryEntry', 'P-Asserted-Identity: <$usdUSEREMERGENCY_PUBLIC_ID
!$MACRO(cuPredefineObject, 'cm_AS_SendINVITE_Initial', '', 'user1', 'user2', 'sesAS_A', 'mhSupplementaryEntry', $mySupp3)

$MACRO(cuPredefineObject, 'cm_AS_ReceiveINVITE_Initial', '',  'user1', 'user2', 'sesA_AS', 'mhSupplementaryEntry', $mySupp3)



$MACRO(cm_AS_ReceiveINVITE_Initial,     'user1', 'user2', 'sesA_AS', '$lcORIG,$lcTERM')
!$MACRO(cm_AS_SendINVITE_Trying,        'user1', 'user2', 'sesA_AS', '$lcORIG,$lcTERM')


!#ASSIGN {%myPnsi} ''
#ASSIGN {%CALLID_INV} '$P_RND@$usdUSERPSTN_IP_ADDRESS'
!$MACRO(cuGetValueOfObject, cm_AS_ReceiveINVITE_Initial, '',    'user1', 'user2', 'sesA_AS', 'mhSupplementaryEntry','myPnsi')
$MACRO(cuGetValueOfObject, cm_AS_ReceiveINVITE_Initial, '',    'user1', 'user2', 'sesA_AS', 'mheCallId_String','CALLID_INV')


#DEFMACRO id1
#BEGIN
P-NokiaSiemens.Session-Info: bearer=yes; corrID=$CALLID_INV; originator=<$usdUSERPSTN_PUBLIC_ID>
#EDEFMACRO

#DEFMACRO id2
#BEGIN
$myPnsi; <$usdUSERPSTN_PUBLIC_ID>\r
#EDEFMACRO


#DEFMACRO id4
#BEGIN
P-NokiaSiemens.Session-Info: corrID=$CALLID_INV; originator=<$usdSUBSCRIBER_A_PUBLIC_ID>\r
P-com.Session-Info: corrID=$CALLID_INV; <$usdSUBSCRIBER_B_PUBLIC_ID>
#EDEFMACRO
#ASSIGN {%mySupp4} '$MACRO2STRING(id4)'

#ASSIGN {%mySupp1} '$MACRO2STRING(id1)'

#ASSIGN {%cmdpRECEIVEIgnore}  'P-Served-User P-com.Siemens.Access-Information P-Charging-Vector P-NokiaSiemens.Session-Info P-com.Session-Info' 


!$MACRO(cuPredefineObject, 'cm_AS_SendINVITE_Initial', '', 'user1', 'user2', 'sesAS_A', 'mheCallId_String', $CALLID_INV)
$MACRO(cuPredefineObject, 'cm_AS_SendINVITE_Initial', '', 'user1', 'user2', 'sesAS_A', 'mhSupplementaryEntry', $mySupp1)
$MACRO(cm_AS_SendINVITE_Initial,        'user1', 'user2', 'sesAS_A', '$lcORIG,$lcTERM')
$MACRO(cm_AS_ReceiveINVITE_Trying,      'user1', 'user2', 'sesAS_A', '$lcTERM,$lcORIG')

!$MACRO(cuPredefineObject, 'cm_AS_ReceiveINVITE_Initial_200', '', 'user1', 'user2', 'sesAS_A', 'mhSupplementaryEntry', $mySupp4)
$MACRO(cm_AS_ReceiveINVITE_Initial_200, 'user1', 'user2', 'sesAS_A', '$lcTERM,$lcORIG')


$MACRO(cm_AS_SendINVITE_Initial_200,    'user1', 'user2', 'sesA_AS', '$lcTERM,$lcORIG')

$MACRO(cm_AS_ReceiveACK_Initial,        'user1', 'user2', 'sesA_AS', '$lcORIG,$lcTERM')

$MACRO(cm_AS_SendACK_Initial,           'user1', 'user2', 'sesAS_A', '$lcORIG,$lcTERM')

$MACRO(cm_AS_ReceiveBYE,                'user1', 'user2', 'sesA_AS', '$lcORIG,$lcTERM')

$MACRO(cm_AS_SendBYE,                   'user1', 'user2', 'sesAS_A', '$lcORIG,$lcTERM')

$MACRO(cm_AS_ReceiveBYE_200,            'user1', 'user2', 'sesAS_A', '$lcTERM,$lcORIG')

$MACRO(cm_AS_SendBYE_200,               'user1', 'user2', 'sesA_AS', '$lcTERM,$lcORIG')





