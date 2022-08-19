@ECHO OFF

:: new param style - I likey

SET c=0
SET f=0
SET u=
SET h=0
SET v=0

:initial
IF "%1"=="" GOTO start
SET aux=%1:^/=-%
IF "%aux%"=="-f" (
    SET f=1
    SHIFT
    GOTO initial
)
IF "%aux%"=="-c" (
    SET c=1
    SHIFT
    GOTO initial 
)
IF "%aux%"=="-h" (
    SET h=1
    SHIFT
    GOTO initial
)
IF "%aux%"=="-?" (
    SET h=1
    SHIFT
    GOTO initial
)
IF "%aux%"=="-v" (
    SET v=1
    SHIFT
    GOTO initial
)
IF "%aux%"=="-u" (
    SET u=%2
    SHIFT
    SHIFT
    GOTO initial 
)
ECHO "%1" is not a valid parameter. Breaking now.
ECHO ...
SET ERRORLEVEL=45
PAUSE > NUL
GOTO done

:: parameter checking

:start
IF "%u%"==""(
	:: no special user needed
) ELSE (
	GOTO user
)
IF %c%+%f%+%h% > 1(
	ECHO You entered non-combinable parameters (so more than one non-u and non-v param)
	ECHO ...
	PAUSE > NUL
	GOTO done
)
IF %c%==1(
	goto check
)
IF %f%==1(
	goto force
)
IF %h%==1(
	goto help
)
IF %c%+%f%+%h% == 0(
	goto blank
)
ECHO You reached code that should be unreachable. Err, contact the author, I guess?
SET ERRORLEVEL=999
ECHO ...
PAUSE > NUL
GOTO done



:user

:: use given user than running user for %userprofile%

SET USERPROFILE=C:\users\%u%
SET u=
GOTO start




:blank

:: normal operation

REG QUERY "HKLM\SOFTWARE\Microsoft\Command Processor" /v AutoRun >C:\temp\tmpfile.tmp 2>NUL
SET /p var=<C:\temp\tmpfile.tmp
>NUL find "AutoRun" C:\temp\tmpfile.tmp && (
	DEL C:\temp\tmpfile.tmp
	GOTO error
) || (
	DEL C:\temp\tmpfile.tmp
	GOTO on
)
:on
IF EXIST C:\Temp\alias.bat GOTO error2
IF EXIST %userprofile%\bin\grep.cmd GOTO error2
IF EXIST %userprofile%\bin\man.cmd GOTO error2
REG ADD "HKLM\SOFTWARE\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d C:\Temp\alias.bat
TYPE NUL > C:\Temp\alias.bat
TYPE NUL > %userprofile%\bin\grep.cmd
TYPE NUL > %userprofile%\bin\man.cmd
GOTO builders
:error
:: reg value already exists so we have trouble potentially.
SET ERRORLEVEL=1
ECHO The reg key value we use was already existing so we're gonna break now cause no -f flag was specified. I can error messages.
ECHO ...
PAUSE > NUL
GOTO done
:error2
:: file already exists so trouble yada yada
SET ERRORLEVEL=2
ECHO (one of) The file(s) we use was already existing so we're gonna break now cause no -f flag was specified. I can error messages.
ECHO ...
PAUSE > NUL
GOTO done




:force

:: no matter what, remake the build

REG ADD "HKLM\SOFTWARE\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d C:\Temp\alias.bat /f
TYPE NUL > C:\Temp\alias.bat
TYPE NUL > %userprofile%\bin\grep.cmd
TYPE NUL > %userprofile%\bin\man.cmd
GOTO builders




:check

:: don't do shit, just check


REG QUERY "HKLM\SOFTWARE\Microsoft\Command Processor" /v AutoRun >C:\temp\tmpfile.tmp 2>NUL
SET /p var=<C:\temp\tmpfile.tmp
>NUL find "AutoRun" C:\temp\tmpfile.tmp && (
	DEL C:\temp\tmpfile.tmp
	ECHO check 1 ok
	GOTO yep
) || (
	DEL C:\temp\tmpfile.tmp
	GOTO nope
)
:yep
IF EXIST C:\Temp\alias.bat (ECHO check 2 okay) ELSE (GOTO nope)
IF EXIST %userprofile%\bin\grep.cmd (ECHO check 3 okay) ELSE (GOTO nope)
IF EXIST %userprofile%\bin\man.cmd (ECHO check 4 okay) ELSE (GOTO nope)
ECHO All checks okay - note we didn't check contents of files, that's your responsibility.
ECHO ...
PAUSE > NUL
GOTO done
:nope
ECHO Something's amiss - install is not success.
ECHO ...
PAUSE > NUL
GOTO done




:help

:: display help page

ECHO -f forces, so overrides everything and sets defaults - be careful!
ECHO -c checks, so does nothing but tell you whether the correct files are found - contents notwithstanding 
ECHO -u uses a different user so if you run-as-admin for regedit purposes, provide -u ^<your-username^> here pls
ECHO -v is the verbose flag which right now does jack-all
ECHI -h shows this help page
ECHO ...
PAUSE > NUL
GOTO done




:done

:: bye-bye
DEL C:\temp\tmpfile.tmp >NUL 2>&1
EXIT /b %ERRORLEVEL%





:builders

:: alias.bat builder
	ECHO @ECHO OFF >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO :: PATH fuckery >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO SET PATH=^%PATH^%;^%userprofile^%\bin >> C:\Temp\alias.bat
	ECHO 	:: Cause for some reason I can install ssh without issue, but it never gets added to path >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO :: Commands >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO DOSKEY ls=dir /Q $* >> C:\Temp\alias.bat
	ECHO DOSKEY alias="C:\Program Files\Notepad++\Notepad++.exe" C:\Temp\alias.bat >> C:\Temp\alias.bat
	ECHO DOSKEY npp="C:\Program Files\Notepad++\Notepad++.exe" $* >> C:\Temp\alias.bat
	ECHO DOSKEY pingy=ping /t $* >> C:\Temp\alias.bat
	ECHO DOSKEY bye=exit >> C:\Temp\alias.bat
	ECHO DOSKEY IFconfig=ipconfig /all >> C:\Temp\alias.bat
	ECHO DOSKEY cat=type $* >> C:\Temp\alias.bat
	ECHO DOSKEY touch=type NUL ^>> $* >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO :: Cause I want cmd to start in C:\ >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
	ECHO C: >> C:\Temp\alias.bat
	ECHO.>> C:\Temp\alias.bat
:: grep.cmd builder
	ECHO @ECHO OFF >> %userprofile%\bin\grep.cmd
	ECHO findstr /i ^%1 >> %userprofile%\bin\grep.cmd
:: man.cmd builder
	ECHO @ECHO OFF >> %userprofile%\bin\man.cmd
	ECHO ^%~1 /? ^| less >> %userprofile%\bin\man.cmd
GOTO done
