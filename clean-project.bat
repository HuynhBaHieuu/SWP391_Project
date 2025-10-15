@echo off
echo Cleaning GO2BNB Project...

echo.
echo Step 1: Stopping any running Java processes...
taskkill /f /im java.exe 2>nul
taskkill /f /im javaw.exe 2>nul

echo.
echo Step 2: Waiting 3 seconds...
timeout /t 3 /nobreak >nul

echo.
echo Step 3: Removing target directory...
if exist target (
    rmdir /s /q target
    echo Target directory removed successfully.
) else (
    echo Target directory not found.
)

echo.
echo Step 4: Running Maven clean...
mvn clean -Dmaven.clean.failOnError=false

echo.
echo Step 5: Running Maven compile...
mvn compile

echo.
echo Step 6: Running Maven package...
mvn package

echo.
echo Project cleaned and built successfully!
pause