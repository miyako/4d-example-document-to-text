var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.onLoad()
		
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
				return Form:C1466.onFilesDrop()
		End case 
		
End case 