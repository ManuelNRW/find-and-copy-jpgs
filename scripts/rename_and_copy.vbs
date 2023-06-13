call rename_and_copy

sub rename_and_copy
    
    call create_destination_folder

    dim file_Name
    file_Name = get_random_img_filename()

    call to_current_filename(file_Name)

    call open_picture()

    dim img_type
    img_type = get_img_type()
    if img_type = "null" then
        msgbox "Es wurde kein g" & chr(252) & "ltiger Bildtyp angegeben!"
        exit sub
    end if

    dim img_attr
    img_attr = get_img_attr(file_Name)
    if img_attr = "" then
        msgbox "Es wurde kein g" & chr(252) & "ltiges Bildattribut gesetzt!"
        exit sub
    end if

    dim img_number
    img_number = get_img_number(img_type, img_attr)

    call rename_and_move(img_type & img_number & "_" & img_attr & ".jpg")

end sub

sub create_destination_folder()

    if IsFolderAvailable(".\benannt", "") = false then

        Set fso = CreateObject("Scripting.FileSystemObject")
        fso.CreateFolder(".\benannt")

    end if

end sub

function IsFolderAvailable(folderPath, msg)

    Set fsAvailable = CreateObject("Scripting.FileSystemObject")

    If fsAvailable.FolderExists(folderPath) Then
        IsFolderAvailable = true
    Else
        if msg <> "" then msgbox msg
        IsFolderAvailable = false
    End If

end function

function IsFileAvailable(folderPath, msg)

    Set fsAvailable = CreateObject("Scripting.FileSystemObject")

    If fsAvailable.fileExists(folderPath) Then
        IsFileAvailable = true
    Else
        if msg <> "" then msgbox msg
        IsFileAvailable = false
    End If

end function

sub open_picture()

    Set objShell = CreateObject("WScript.Shell")
    objShell.Run ".\currentfile.jpg", 1, False

end sub

function get_random_img_filename()

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(".\")

    For Each objFile In objFolder.Files
		If LCase(Right(objFile.Name, 4)) = ".jpg" Then
			get_random_img_filename = objFile.Name
            exit for
		End If
	Next

end function

function get_img_attr(file_Name)

    get_img_attr = inputbox("Bitte geben Sie die Artikelattribute mit Komma separiert ein. Pfad:"  & chr(10) & file_Name,"Artikelattribute")

end function

function get_img_type()

    img_type = inputbox("Bitte geben Sie den Bildtyp an:" & chr(10) & "1 = Freisteller" & chr(10) & "2 = Detailbild" & chr(10) & "3 = Bema" & chr(223) &  "ung" & chr(10) & "4 = Mileu" & chr(10) & "5 = Sonstiges","Bildtyp")


    if isnumeric(img_type) = false then
    get_img_type = "null"
    elseif cint(img_type) = 1 then
    get_img_type = "clipping_"
    elseif cint(img_type) = 2 then
    get_img_type = "detail_"
    elseif cint(img_type) = 3 then
    get_img_type = "dimensions_"
    elseif cint(img_type) = 4 then
    get_img_type = "mileu_"
    elseif cint(img_type) = 5 then
    get_img_type = "_"
    else
    get_img_type = "null"
    end if

end function

function get_img_number(img_type, img_attr)

    dim i 

    i = 1

    do While IsFileAvailable(".\benannt\" & img_type & i & "_" & img_attr & ".jpg", "") = True

        
        i = i + 1
    loop

    get_img_number = i

end function

sub rename_and_move(file_Name_New)

    dim fso
    Set fso = CreateObject("Scripting.FileSystemObject")
    fso.MoveFile ".\currentfile.jpg",  ".\benannt\" & file_Name_New

end sub


sub to_current_filename(file_Name)
    Set fso = CreateObject("Scripting.FileSystemObject")
    fso.MoveFile ".\" & file_Name, ".\" & "currentfile.jpg"
end sub
