@echo off
setlocal enabledelayedexpansion

rem Mod info
set "MOD_DIR=ResolutionUnlock"

rem Install locations
set "VOL1_DIR=C:\Program Files (x86)\Steam\steamapps\common\MegaMan_BattleNetwork_LegacyCollection_Vol1"
set "VOL2_DIR=C:\Program Files (x86)\Steam\steamapps\common\MegaMan_BattleNetwork_LegacyCollection_Vol2"

rem Build folder
set "BUILD_DIR=_build"
set "BUILD_MOD_DIR=!BUILD_DIR!\!MOD_DIR!"
set "INSTALL_DIR_VOL1=!VOL1_DIR!\exe\mods\!MOD_DIR!"
set "INSTALL_DIR_VOL2=!VOL2_DIR!\exe\mods\!MOD_DIR!"

set "TARGET=%1"
if /I [%1]==[] (
	set "TARGET=release"
)

if /I [!TARGET!]==[clean] (
	set "DO_CLEAN=1"
)
if /I [!TARGET!]==[install] (
	set "DO_UNINSTALL=1"
	set "DO_INSTALL=1"
)
if /I [!TARGET!]==[uninstall] (
	set "DO_UNINSTALL=1"
)
if /I [!TARGET!]==[debug] (
	set "DO_BUILD=1"
	set "CARGO_OPTS="
	set "TARGET_DIR=debug"
	set "COPY_PDB=1"
)
if /I [!TARGET!]==[release] (
	set "DO_BUILD=1"
	set "CARGO_OPTS=--release"
	set "TARGET_DIR=release"
)

if defined DO_CLEAN (
	echo Running cargo clean...
	cargo clean ^
		1> nul || goto :error
	echo Removing build folder...
	if exist "!BUILD_DIR!" (
		rmdir /S /Q "!BUILD_DIR!" ^
			1> nul || goto :error
	)
	echo.
)
if defined DO_BUILD (
	rem Build mod
	echo Building for Volume 1 ^& 2...

	rem Clean build folder
	call :clean_folder "!BUILD_DIR!"
	call :clean_folder "!BUILD_MOD_DIR!"

	echo Running cargo build...
	cargo build !CARGO_OPTS! ^
		1> nul || goto :error

	echo Copying mod files...
	copy "target\!TARGET_DIR!\patch.dll" "!BUILD_MOD_DIR!" ^
		1> nul || goto :error
	if defined COPY_PDB (
		copy "target\!TARGET_DIR!\patch.*" "!BUILD_MOD_DIR!" ^
			1> nul || goto :error
	)
	copy /Y "info.toml" "!BUILD_MOD_DIR!\info.toml" ^
		1> nul || goto :error
	copy /Y "init.lua" "!BUILD_MOD_DIR!\init.lua" ^
		1> nul || goto :error
	copy /Y "mod_readme.md" "!BUILD_MOD_DIR!\README.md" ^
		1> nul || goto :error
	copy /Y "license.txt" "!BUILD_MOD_DIR!\license.txt" ^
		1> nul || goto :error
	echo.

	rem Copy miscellaneous files
	copy /Y "readme.md" "!BUILD_DIR!\readme.txt" ^
		1> nul || goto :error
)
if defined DO_UNINSTALL (
	if exist "!VOL1_DIR!" (
		echo Uninstalling for Volume 1...
		if exist "!INSTALL_DIR_VOL1!" (
			rmdir /S /Q "!INSTALL_DIR_VOL1!" ^
				1> nul || goto :error
		)
	) else (
		echo Volume 1 not installed; skipping...
	)
	if exist "!VOL2_DIR!" (
		echo Uninstalling for Volume 2...
		if exist "!INSTALL_DIR_VOL2!" (
			rmdir /S /Q "!INSTALL_DIR_VOL2!" ^
				1> nul || goto :error
		)
	) else (
		echo Volume 2 not installed; skipping...
	)
	echo.
)
if defined DO_INSTALL (
	if exist "!VOL1_DIR!" (
		if exist "!BUILD_MOD_DIR!" (
			echo Installing for Volume 1...

			echo Copying mod folder...
			if exist "!INSTALL_DIR_VOL1!" (
				del /F /S /Q "!INSTALL_DIR_VOL1!\*" 1> nul || goto :error
			) else (
				mkdir "!INSTALL_DIR_VOL1!" 1> nul || goto :error
			)
			robocopy /E "!BUILD_MOD_DIR!" "!INSTALL_DIR_VOL1!" 1> nul
			if errorlevel 8 goto :error
		) else (
			echo Volume 1 not built; skipping...
		)
	) else (
		echo Volume 1 not installed; skipping...
	)
	if exist "!VOL2_DIR!" (
		if exist "!BUILD_MOD_DIR!" (
			echo Installing for Volume 2...

			echo Copying mod folder...
			if exist "!INSTALL_DIR_VOL2!" (
				del /F /S /Q "!INSTALL_DIR_VOL2!\*" 1> nul || goto :error
			) else (
				mkdir "!INSTALL_DIR_VOL2!" 1> nul || goto :error
			)
			robocopy /E "!BUILD_MOD_DIR!" "!INSTALL_DIR_VOL2!" 1> nul
			if errorlevel 8 goto :error
		) else (
			echo Volume 2 not built; skipping...
		)
	) else (
		echo Volume 2 not installed; skipping...
	)
	echo.
)

:done
echo Done.
echo.
exit /b 0

:error
echo Error occurred, failed to build.
echo.
exit /b 1

:clean_folder
if exist "%1" (
	del /F /S /Q "%1\*" 1> nul || goto :error
) else (
	mkdir "%1" 1> nul || goto :error
)
