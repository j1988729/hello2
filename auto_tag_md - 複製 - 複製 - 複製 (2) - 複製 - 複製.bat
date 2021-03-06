@ECHO OFF
::列出.md的檔案 
::forfiles /P e:\412\testhook\ /M *.rc /c "cmd /c echo @file"
::chcp 65001
::chcp 950
for /f %%b in ('forfiles /M *.md') do ( set FILE_RC=%%b
::xcopy /y %cd%\*.rc %cd%\*.rcbak
echo "hava file .md"
)
pause
echo %FILE_RC%
echo 即將git add和git commit
::pause

set /p var=請輸入commit message:
if "%var%"=="" ( echo 輸入空白，即將自動化commit message:
set var="更新文件"
) else ( echo 請再次確認commit message:%var%)

pause
::要add .md 檔案
git add %FILE_RC%
::if errorlevel 1 goto Quit

::set cmd="git commit -m "%after_VERSION%""
::set cmd="git commit -m "%var%""
::git commit -m "TTTTTT"
git commit -m "%var%"

::pause
::因為只有commit 才取的到 errorcode
::IF ERRORLEVEL 1 echo ERRORCODE_IS_%errorlevel%
IF ERRORLEVEL 1 (
    ::echo ERRORCODE_IS_%errorlevel%
    echo "commit 錯誤"
    echo "end"
    ::goto Quit
    goto gogo
)else (
    echo "success"
)

:gogo
echo %errorlevel%
echo "go on"
::pause

setlocal ENABLEDELAYEDEXPANSION
::set cmdGGG="git tag ^| findstr doc/中文/Development_instructions"


set b_tag= doc/中文/Development_instructions
echo %b_tag%
echo 111
::echo %cmdGGG%
:::for /F %%j in ( 'git tag ^| findstr %b_tag%' ) do ( set tag_flag=%%j )   
for /F %%j in ( 'git tag ^| findstr %b_tag%' ) do ( set tag_flag=%%j )   
echo tag_flag=tag:!tag_flag!
pause





for /F %%i in ('git rev-parse --short HEAD') do ( set commitid_new=%%i)
echo commitid_new=%commitid_new%
::pause


::如果??tag存在，?切?到tag,如果不存在，提示tag??，并?示已有tag,然后异常退出
if not "!tag_flag!" == "" (
　　echo "checkouting %b_tag% ....."
　　git checkout %b_tag%
)else (
　　echo "your input tag is not exist and exit ,all tag as follow:"
　　git tag
　　pause
　　exit 1
)
echo 222
pause

::echo "999"
rem 此檔案為ANSI檔案，執行.bat不會出現編碼問題}
rem 該.bat檔案在哪裡 此執行命令就會在該路徑
rem 又因為此專案需要include curl和openssl的公用程式碼
rem 依據 專案.vcxproj > <AdditionalIncludeDirectories>  > 得知路徑位置 >將其git clone到上一層，後面要注意回到該專案底下去call .bat檔案執行
rem 如果公用區專案無法clone，需要確認該專案的member成員是否有包版帳號，並且只能指定reporter權限。

rem 關於文件控板的使用，留住最後一份更新過的裝機、建置、開發、電文規格等相關的文件
rem 使用此.bat檔案，覆蓋remote上的tag，指令如下
rem 如果遇到推不上去的重複tag，需要下指令  git pull --tags -f，同步remote的tag狀態
for /F %%i in ('git rev-parse --short HEAD') do ( set commitid_old=%%i)
echo commitid_old=old:%commitid_old%
echo commitid_new=new:%commitid_new%
::pause
if "!commitid_old!" == "!commitid_new!" (
　　echo "commit id is same, not to push new tag"
)else (
　　echo "push new tag,follow *.md"
　　git tag -f !tag_flag!
　　git tag -d !tag_flag!
　　git push origin --delete !tag_flag!
　　git fetch origin --prune --prune-tags
　　git tag !tag_flag! !commitid_new!
　　git push origin !tag_flag!
)
::pause


:Quit
echo "結束 回branch master"
git checkout master
pause