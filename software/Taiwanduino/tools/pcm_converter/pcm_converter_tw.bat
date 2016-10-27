@ECHO OFF
REM TaiwanDuino 可拖曳音訊轉檔程式 (使用libav) v1.0
REM 使用滑鼠拖曳的方式來把影片/音訊檔案轉檔成 TaiwanDuino 可直接撥放的 8bit PCM 音效

TITLE TaiwanDuino 可拖曳音訊轉檔程式 (使用libav) v1.0

SET SampleRate=16000
::TaiwanDuino SD卡專用撥放器 (TMRpcm)				建議取樣頻率: 16000~32000
::外部EEPROM/內部記憶體 play_eeprom()/play()函式	建議取樣頻率: 8000

SET LibavBuilds=http://builds.libav.org/windows/release-gpl/
SET Libav32=libav-9.18-win32
SET Libav64=libav-x86_64-w64-mingw32-11.7
SET ToolDir=%~dp0
::關於libav轉檔器線上下載位置 https://libav.org/download/  <<Windows Nightly and Release Builds>>

SET ExportDir=export
::輸出後要集中儲存的資料夾

IF EXIST "%PROGRAMFILES(X86)%" (SET Libav=%Libav64%) ELSE (SET Libav=%Libav32%)
IF EXIST "%ToolDir%%Libav%\usr\bin\avconv.exe" (GOTO init)

::Downloader
CLS
IF NOT EXIST "%ToolDir%wget.exe" (GOTO lostfiles)
IF NOT EXIST "%ToolDir%7za.exe" (GOTO lostfiles)
ECHO 找不到 %Libav%\usr\bin\avconv.exe 轉檔器
ECHO 需要自動下載嗎? (大約30MB流量)
PAUSE
"%ToolDir%wget.exe" %LibavBuilds%%Libav%.7z --no-check-certificate -O "%ToolDir%%Libav%.7z"
"%ToolDir%7za.exe" -y -bd -o"%ToolDir%" x "%ToolDir%%Libav%.7z"
DEL -Q "%ToolDir%%Libav%.7z"

:init
SET Libav=%ToolDir%%Libav%\usr\bin\
TITLE TaiwanDuino 可拖曳音訊轉檔程式 (使用libav) v1.0
CD %Libav% || GOTO:error
SET PATH=%Libav%;%PATH%
CLS
avconv -version
ECHO 已經進入轉檔器資料夾: "%Libav%"
ECHO 自動加入本目錄至 PATH 環境變數
ECHO.
ECHO.
ECHO.

IF NOT EXIST "%~1" GOTO usage

:convert
TITLE TaiwanDuino 可拖曳音訊轉檔程式 (使用libav) v1.0
IF "%~1"=="" GOTO end
IF NOT EXIST "%~dp1%ExportDir%" (MKDIR "%~dp1%ExportDir%")
avconv.exe -y -i %1 -ar %SampleRate% -ac 1 -acodec pcm_u8 "%~dp1%ExportDir%\%~n1.wav"
ECHO.
ECHO.
ECHO ########## 檔案 %~nx1 轉換完畢 ##########
ECHO.
ECHO.
ECHO.
shift
GOTO convert

:usage
ECHO.
ECHO.
ECHO 操作方法:
ECHO     建議將本程式%~nx0手動建立捷徑後，複製捷徑到所需要被轉換
ECHO 的檔案資料夾中，並且直接將需要轉換的一個或多個拖曳檔案拖曳至捷徑圖示上，即
ECHO 可完成轉檔。第一次使用本程式會需要自動從網路上下載必要的轉檔器( Libav )。
ECHO 顯示本程式所支援的輸入格式請參考以下指令：
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
ECHO 錯誤 請回報本問題至 https://github.com/will127534/Taiwanduino
ECHO 感謝您
PAUSE
GOTO:EOF

:lostfiles
ECHO.
ECHO 找不到所需檔案 wget.exe 或是 7za.exe
ECHO wget.exe	的手動下載頁面： https://eternallybored.org/misc/wget/
ECHO 7za.exe	的手動下載頁面： http://www.7-zip.org/download.html
PAUSE
GOTO:EOF
