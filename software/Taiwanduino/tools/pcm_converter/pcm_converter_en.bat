@ECHO OFF
REM TaiwanDuino Drag and Drop Audio Converter (libav) v1.0
REM drag and drop multiple audio files and convert it to 8bit PCM audio 

TITLE TaiwanDuino Drag and Drop Audio Converter (libav) v1.0

SET SampleRate=16000
::TaiwanDuino SDCARD Player (TMRpcm)   					: 16000~32000
::EEPROM/Internal flash play_eeprom()/play() function	: 8000

SET LibavBuilds=http://builds.libav.org/windows/release-gpl/
SET Libav32=libav-9.18-win32
SET Libav64=libav-x86_64-w64-mingw32-11.7
SET ToolDir=%~dp0
::Check for https://libav.org/download/  <<Windows Nightly and Release Builds>>

SET ExportDir=export
::Define your output directory

IF EXIST "%PROGRAMFILES(X86)%" (SET Libav=%Libav64%) ELSE (SET Libav=%Libav32%)
IF EXIST "%ToolDir%%Libav%\usr\bin\avconv.exe" (GOTO init)

::Downloader
CLS
IF NOT EXIST "%ToolDir%wget.exe" (GOTO lostfiles)
IF NOT EXIST "%ToolDir%7za.exe" (GOTO lostfiles)
ECHO %Libav%\usr\bin\avconv.exe could not be found.
ECHO Start auto download (~30MB)
PAUSE
"%ToolDir%wget.exe" %LibavBuilds%%Libav%.7z --no-check-certificate -O "%ToolDir%%Libav%.7z"
"%ToolDir%7za.exe" -y -bd -o"%ToolDir%" x "%ToolDir%%Libav%.7z"
DEL -Q "%ToolDir%%Libav%.7z"

:init
SET Libav=%ToolDir%%Libav%\usr\bin\
TITLE TaiwanDuino Drag and Drop Audio Converter (libav) v1.0
CD %Libav% || GOTO:error
SET PATH=%Libav%;%PATH%
CLS
avconv -version
ECHO Current directory is now: "%Libav%"
ECHO The bin directory has been added to PATH
ECHO.
ECHO.
ECHO.

IF NOT EXIST "%~1" GOTO usage

:convert
TITLE TaiwanDuino Drag and Drop Audio Converter (libav) v1.0
IF "%~1"=="" GOTO end
IF NOT EXIST "%~dp1%ExportDir%" (MKDIR "%~dp1%ExportDir%")
avconv.exe -y -i %1 -ar %SampleRate% -ac 1 -acodec pcm_u8 "%~dp1%ExportDir%\%~n1.wav"
ECHO.
ECHO.
ECHO ########## File %~nx1 converted ##########
ECHO.
ECHO.
ECHO.
shift
GOTO convert

:usage
ECHO.
ECHO.
ECHO Usage:
ECHO     Make a shortcut of this converter and move it to where your audio
ECHO file(s) located. Drag your audio file(s) and drop them on the shortcut
ECHO you created. Auto downloader will only be triggered the first time you
ECHO start. The supported input file format list can be found using the 
ECHO command : avconv -formats
ECHO.
ECHO.
PAUSE
GOTO:EOF

:end
PAUSE
GOTO:EOF

:error
ECHO.
ECHO ERROR - Please contact us on https://github.com/will127534/Taiwanduino
ECHO Press any key to exit.
PAUSE >nul
GOTO:EOF

:lostfiles
ECHO.
ECHO wget.exe or 7za.exe not found
ECHO wget.exe could be download at https://eternallybored.org/misc/wget/
ECHO 7za.exe could be download at http://www.7-zip.org/download.html
ECHO Press any key to exit.
PAUSE >nul
GOTO:EOF
