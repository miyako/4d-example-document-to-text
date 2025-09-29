Class constructor
	
Function onLoad() : cs:C1710.TEST
	
	Form:C1466.files:={col: []; sel: Null:C1517; item: Null:C1517; pos: Null:C1517}
	
	return This:C1470
	
Function onUnload() : cs:C1710.TEST
	
	return This:C1470
	
Function onFilesDragOver() : Integer
	
	$path:=Get file from pasteboard:C976(1)
	
	If (Test path name:C476($path)=Is a folder:K24:2)
		return 0  //accept
	Else 
		return -1  //reject
	End if 
	
Function onFilesDrop() : cs:C1710.TEST
	
	$path:=Get file from pasteboard:C976(1)
	
	If (Test path name:C476($path)=Is a folder:K24:2)
		
		var $col : Collection
		$col:=[]
		
		var $folder : 4D:C1709.Folder
		$folder:=Folder:C1567($path; fk platform path:K87:2)
		
		var $file : 4D:C1709.File
		For each ($file; $folder.files(fk ignore invisible:K87:22 | fk recursive:K87:7))
			$col.push({icon: $file.getIcon(64); fullName: $file.fullName})
		End for each 
	End if 
	
	Form:C1466.files.col:=$col
	
	return This:C1470