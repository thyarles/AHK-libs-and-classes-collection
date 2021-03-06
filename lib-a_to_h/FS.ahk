; DOC: Determines if a file or directory exists
FS_Exists(path)
{
	return FileExist(fileName) <> ""
}

; DOC: Determines if a file exists and is a file
FS_FileExists(fileName)
{
  result := FileExist(fileName)
	return result <> "" && InStr(result, "D") = 0
}

; DOC: Determines if a file exists and is a file
FS_IsFile(fileName)
{
	return FS_FileExists(fileName)
}

; DOC: Determines if a directory exists and is a directory
FS_DirExists(dirName)
{
  result := FileExist(dirName)
	return result <> "" && InStr(result, "D") > 0
}

; DOC: Determines if a directory exists and is a directory
FS_DirectoryExists(dirName)
{
	return FS_DirExists(dirName)
}

; DOC: Determines if a directory exists and is a directory
FS_IsDirectory(dirName)
{
	return FS_DirExists(dirName)
}

; DOC: Creates a file and its parent directories if necessary
FS_FileCreate(fileName, encoding="")
{
;   OutputDebug In FS_FileCreate(%fileName%, %encoding%)
	if(IsEmpty(encoding))
		encoding := "UTF-16"
	
	SplitPath, fileName, fname, dir, ext, nnoext, drv
	if(!FS_DirectoryExists(dir))
	{
		FileCreateDir, %dir%
		if ErrorLevel
    {
;       OutputDebug Could not create directory %dir%
			return false
    }
	}
	file := FileOpen(fileName, "w", encoding)
	return file
}

FS_CreateFile(fileName, encoding="")
{
  return FS_FileCreate(fileName, encoding)
}

; DOC: Creates a directory and its parent directories if necessary
FS_MkDir(dirName)
{
  FileCreateDir, %dirName%
	if ErrorLevel
		return false
  else
    return true
}

; DOC: Creates a directory and its parent directories if necessary
FS_DirectoryCreate(dirName)
{
  return FS_MkDir(dirName)
}

; DOC: Creates a directory and its parent directories if necessary
FS_CreateDirectory(dirName)
{
  return FS_MkDir(dirName)
}

; DOC: Creates a directory and its parent directories if necessary
FS_CreateDir(dirName)
{
  return FS_MkDir(dirName)
}

; DOC: Creates a directory and its parent directories if necessary
FS_DirCreate(dirName)
{
  return FS_MkDir(dirName)
}

FS_FileCount(pattern)
{
  result := 0
  Loop,%pattern%
  {
    result++
  }
  return result
}

FS_ShortcutCreate(TargetFileName, ShortcutDirectory, Description = "", recreate = false)
{
  SplitPath, TargetFileName, fileName, dirName, ext, nameNoext, drive
	shortcutFileName := ShortcutDirectory "\" nameNoext ".lnk"
	if(FS_FileExists(shortcutFileName))
	{
    if(recreate)
    {
		  FileDelete, %shortcutFileName%
      FileCreateShortcut, %TargetFileName%, %shortcutFileName%, %dirName%, , %Description%, %TargetFileName%
    }
	}
  else
  {
    FileCreateShortcut, %TargetFileName%, %shortcutFileName%, %dirName%, , %Description%, %TargetFileName%
;     MsgBox ErrorLevel = %ErrorLevel%
  }
}
FS_ShortcutRemove(TargetFileName, ShortcutDirectory, Description = "")
{
	SplitPath, TargetFileName, fileName, dirName, ext, nameNoext, drive
	shortcutFileName := ShortcutDirectory "\" nameNoext ".lnk"
	if(FS_FileExists(shortcutFileName))
	{
		FileDelete, %shortcutFileName%
	}
}

; DOC: Creates a startup shortcut for the specified file deleting the previous one
FS_StartupShortcutCreate(TargetFileName, Description = "", recreate = false)
{
	FS_ShortcutCreate(TargetFileName, A_Startup, Description, recreate)
}

; DOC: removes a startup shortcut
FS_StartupShortcutRemove(TargetFileName, Description = "")
{
	FS_ShortcutRemove(TargetFileName, A_Startup, Description = "")
}

FS_DesktopShortcutCreate(TargetFileName, Description = "", recreate = false)
{
  FS_ShortcutCreate(TargetFileName, A_Desktop, Description, recreate)
}

FS_DesktopShortcutRemove(TargetFileName, Description = "")
{
	FS_ShortcutRemove(TargetFileName, A_Desktop, Description = "")
}