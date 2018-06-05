
if not exist Temp mkdir Temp
cd Temp
if not exist data mkdir data
if not exist patch mkdir patch
cd ..

if not exist %2 mkdir %2

set TosPath=%1
set RootPath=%cd%
set TempPath=%cd%\Temp
set ExtractPath=%cd%\Temp
set ExportPath=%cd%\%2



cd %RootPath%
pause
for /f %%a in (ipflist_data.txt) do (
	xcopy /y "%TosPath%\%%a" "%TempPath%\data\%%a"
	.\ipf_unpack.exe %TempPath%\data\%%a decrypt
	.\ipf_unpack.exe %TempPath%\data\%%a extract xml lua dds xac png jpg tga imctree effect skn xsd xsm xsmtime wmove bin fx fxdb ttf export lma xpm fdp fev h txt lst mp3
	
	echo D|xcopy /y "%ExtractPath%\%%a" "%ExportPath%\%%a"
	
	cd "%ExportPath%\%%a"
	
	git add --all
	git commit -m "%%a"
)
cd %RootPath%
pause



::====== temp data clear
rmdir Temp
rmdir extract
pause