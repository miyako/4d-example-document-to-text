var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		If (OB Instance of:C1731(Form:C1466; cs:C1710.TEST))
			Form:C1466.onLoad()
		Else 
			//do not run this from form editor
			ARRAY LONGINT:C221($events; 0)
			OBJECT SET EVENTS:C1239(*; ""; $events; Enable events disable others:K42:37)
		End if 
		
	: ($event.code=On Unload:K2:2)
		
		Form:C1466.onUnload()
		
	: ($event.code=On Drag Over:K2:13)
		
		Case of 
			: (["files"].includes($event.objectName))
				return Form:C1466.onFilesDragOver()
		End case 
		
		return -1
		
	: ($event.code=On Drop:K2:12)
		
		Case of 
			: (["files"].includes($event.objectName))
				Form:C1466.onFilesDrop()
		End case 
		
	: ($event.code=On Selection Change:K2:29)
		
		Case of 
			: (["files"].includes($event.objectName))
				Form:C1466.onFilesSelect()
		End case 
		
End case 