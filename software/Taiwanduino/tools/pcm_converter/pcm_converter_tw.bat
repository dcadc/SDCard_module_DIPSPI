@ECHO OFF
REM TaiwanDuino �i�즲���T���ɵ{�� (�ϥ�libav) v1.0
REM �ϥηƹ��즲���覡�ӧ�v��/���T�ɮ����ɦ� TaiwanDuino �i�������� 8bit PCM ����

TITLE TaiwanDuino �i�즲���T���ɵ{�� (�ϥ�libav) v1.0

SET SampleRate=16000
::TaiwanDuino SD�d�M�μ��� (TMRpcm)				��ĳ�����W�v: 16000~32000
::�~��EEPROM/�����O���� play_eeprom()/play()�禡	��ĳ�����W�v: 8000

SET LibavBuilds=http://builds.libav.org/windows/release-gpl/
SET Libav32=libav-9.18-win32
SET Libav64=libav-x86_64-w64-mingw32-11.7
SET ToolDir=%~dp0
::����libav���ɾ��u�W�U����m https://libav.org/download/  <<Windows Nightly and Release Builds>>

SET ExportDir=export
::��X��n�����x�s����Ƨ�

IF EXIST "%PROGRAMFILES(X86)%" (SET Libav=%Libav64%) ELSE (SET Libav=%Libav32%)
IF EXIST "%ToolDir%%Libav%\usr\bin\avconv.exe" (GOTO init)

::Downloader
CLS
IF NOT EXIST "%ToolDir%wget.exe" (GOTO lostfiles)
IF NOT EXIST "%ToolDir%7za.exe" (GOTO lostfiles)
ECHO �䤣�� %Libav%\usr\bin\avconv.exe ���ɾ�
ECHO �ݭn�۰ʤU����? (�j��30MB�y�q)
PAUSE
"%ToolDir%wget.exe" %LibavBuilds%%Libav%.7z --no-check-certificate -O "%ToolDir%%Libav%.7z"
"%ToolDir%7za.exe" -y -bd -o"%ToolDir%" x "%ToolDir%%Libav%.7z"
DEL -Q "%ToolDir%%Libav%.7z"

:init
SET Libav=%ToolDir%%Libav%\usr\bin\
TITLE TaiwanDuino �i�즲���T���ɵ{�� (�ϥ�libav) v1.0
CD %Libav% || GOTO:error
SET PATH=%Libav%;%PATH%
CLS
avconv -version
ECHO �w�g�i�J���ɾ���Ƨ�: "%Libav%"
ECHO �۰ʥ[�J���ؿ��� PATH �����ܼ�
ECHO.
ECHO.
ECHO.

IF NOT EXIST "%~1" GOTO usage

:convert
TITLE TaiwanDuino �i�즲���T���ɵ{�� (�ϥ�libav) v1.0
IF "%~1"=="" GOTO end
IF NOT EXIST "%~dp1%ExportDir%" (MKDIR "%~dp1%ExportDir%")
avconv.exe -y -i %1 -ar %SampleRate% -ac 1 -acodec pcm_u8 "%~dp1%ExportDir%\%~n1.wav"
ECHO.
ECHO.
ECHO ########## �ɮ� %~nx1 �ഫ���� ##########
ECHO.
ECHO.
ECHO.
shift
GOTO convert

:usage
ECHO.
ECHO.
ECHO �ާ@��k:
ECHO     ��ĳ�N���{��%~nx0��ʫإ߱��|��A�ƻs���|��һݭn�Q�ഫ
ECHO ���ɮ׸�Ƨ����A�åB�����N�ݭn�ഫ���@�өΦh�ө즲�ɮש즲�ܱ��|�ϥܤW�A�Y
ECHO �i�������ɡC�Ĥ@���ϥΥ��{���|�ݭn�۰ʱq�����W�U�����n�����ɾ�( Libav )�C
ECHO ��ܥ��{���Ҥ䴩����J�榡�аѦҥH�U���O�G
ECHO.
ECHO avconv -formats
ECHO.
PAUSE
GOTO:EOF

:end
PAUSE
GOTO:EOF

:error
ECHO.
ECHO ���~ �Ц^�������D�� https://github.com/will127534/Taiwanduino
ECHO �P�±z
PAUSE
GOTO:EOF

:lostfiles
ECHO.
ECHO �䤣��һ��ɮ� wget.exe �άO 7za.exe
ECHO wget.exe	����ʤU�������G https://eternallybored.org/misc/wget/
ECHO 7za.exe	����ʤU�������G http://www.7-zip.org/download.html
PAUSE
GOTO:EOF
