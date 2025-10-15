Class constructor
	
Function onLoad() : cs:C1710.TEST
	
	Form:C1466.files:={col: []; sel: Null:C1517; item: Null:C1517; pos: Null:C1517}
	
	return This:C1470
	
Function onUnload() : cs:C1710.TEST
	
	return This:C1470
	
Function onChunk($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $file : Variant
	$file:=$params.context
	
	var $item : Object
	$item:=Form:C1466.files.col.query("file.path == :1"; $file.path).first()
	
	If ($item#Null:C1517)
		
		If ($worker.responseError#"")
			$item.chunk:=$worker.responseError
		Else 
			$item.chunk:=JSON Parse:C1218($worker.response; Is collection:K8:32)
		End if 
		
	End if 
	
Function onExtract($worker : 4D:C1709.SystemWorker; $params : Object)
	
	var $file : 4D:C1709.File
	$file:=$params.context
	
	var $item : Object
	$item:=Form:C1466.files.col.query("file.path == :1"; $file.path).first()
	
	If ($item#Null:C1517)
		
		If ($worker.responseError#"")
			$item.text:=$worker.responseError
		Else 
			$item.text:=$worker.response
			
			var $text_splitter : cs:C1710.text_splitter.text_splitter
			$text_splitter:=cs:C1710.text_splitter.text_splitter.new()
			$text_splitter.chunk({data: $file; file: $item.text; capacity: "100..200"; overlap: 70; tiktoken: True:C214}; Form:C1466.onChunk)
			
		End if 
		
	End if 
	
Function onFilesSelect() : cs:C1710.TEST
	
	var $item : Object
	$item:=Form:C1466.files.item
	
	If ($item=Null:C1517)
		Form:C1466.text:=""
		Form:C1466.chunk:=Null:C1517
	Else 
		Form:C1466.text:=$item.text
		Form:C1466.chunk:=$item.chunk
	End if 
	
	return This:C1470
	
Function onFilesDragOver() : Integer
	
	$path:=Get file from pasteboard:C976(1)
	
	If (Test path name:C476($path)=Is a folder:K24:2) || (Test path name:C476($path)=Is a document:K24:1)
		return 0  //accept
	Else 
		return -1  //reject
	End if 
	
Function onFilesDrop() : cs:C1710.TEST
	
	var $col : Collection
	$col:=[]
	
	$path:=Get file from pasteboard:C976(1)
	
	Case of 
		: (Test path name:C476($path)=Is a folder:K24:2)
			var $folder : 4D:C1709.Folder
			$folder:=Folder:C1567($path; fk platform path:K87:2)
			var $file : 4D:C1709.File
			For each ($file; $folder.files(fk ignore invisible:K87:22 | fk recursive:K87:7))
				$col.push({file: $file; icon: $file.getIcon(64); fullName: $file.fullName; extension: $file.extension})
			End for each 
		Else 
			$i:=1
			var $file : 4D:C1709.File
			Repeat 
				$file:=File:C1566($path; fk platform path:K87:2)
				$col.push({file: $file; icon: $file.getIcon(64); fullName: $file.fullName; extension: $file.extension})
				$i+=1
				$path:=Get file from pasteboard:C976($i)
			Until ($path="")
			
	End case 
	
	Form:C1466.files.col:=$col
	Form:C1466.text:=""
	Form:C1466.chunk:=Null:C1517
	
	var $extract : cs:C1710.extract.extract
	var $files; $tasks : Collection
	var $extension : Text
	var $extensions : Collection
	
	$extensions:=cs:C1710.extract.formats.new().extensions
	
	For each ($extension; $extensions)
		
		$extract:=cs:C1710.extract.extract.new($extension)
		$files:=Form:C1466.files.col.query("extension == :1"; $extension).extract("file")
		
		$tasks:=[]
		For each ($file; $files)
			$tasks.push({file: $file.getContent(); data: $file})
		End for each 
		
		$extract.getText($tasks; This:C1470.onExtract)
		
	End for each 
	
	return This:C1470