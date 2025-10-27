var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Drag Over:K2:13)
		
		Case of 
			: (["files"].includes($event.objectName))
				return Form:C1466.onFilesDragOver()
		End case 
		
		return -1
		
End case 
