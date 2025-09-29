//%attributes = {}
#DECLARE($params : Object)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1; Current method name:C684; {})
	
Else 
	
	var $window : Integer
	$window:=Open form window:C675("TEST")
	SET WINDOW TITLE:C213("TEST"; $window)
	var $form : cs:C1710.TEST
	$form:=cs:C1710.TEST.new()
	DIALOG:C40("TEST"; $form; *)
	
End if 