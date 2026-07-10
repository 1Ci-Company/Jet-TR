
&AtServer
Function SendTestSMSAtServer(Number, MessageText)
	Return TwilioSms.sendSMS(Number, MessageText);
EndFunction

&AtClient
Procedure SendTestSMS(Command)	
	
	Result = SendTestSMSAtServer(Number, MessageText);
	
	If Result Then 
		ShowMessageBox(, NStr("en = 'SMS sent successfully!'; tr = 'SMS Başarıyla Gönderildi!'"));
	Else 
		ShowMessageBox(, NStr("en = 'SMS sending failed. Check the messages in the bottom panel.'; tr = 'SMS Gönderimi Başarısız Oldu. Alt paneldeki mesajları kontrol edin.'"));
	EndIf;

EndProcedure
