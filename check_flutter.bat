@echo off
echo ========================================
echo Verificando instalaci¢n de Flutter...
echo ========================================
where flutter >nul 2>&1
if %errorlevel% == 0 (
    echo ¡Flutter est  instalado!
    echo.
    flutter --version
    echo.
    echo ========================================
    echo Verificando dispositivo predeterminado...
    echo ========================================
    flutter devices
) else (
    echo.
    echo ¡Flutter NO est  instalado o no est  en el PATH!
    echo.
    echo Instrucciones para instalar Flutter:
    echo 1. Descarga Flutter desde: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extrae el archivo en C:\src\flutter
    echo 3. Agrega C:\src\flutter\bin a tu variable PATH
    echo 4. Reinicia tu terminal
    echo.
    echo Ejecuta este script nuevamente despu‚s de instalar Flutter
)
echo.
pause