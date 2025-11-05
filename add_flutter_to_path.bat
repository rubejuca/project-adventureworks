@echo off
echo ========================================
echo Agregar Flutter al PATH del sistema
echo ========================================
echo.
echo Este script te ayudar  a agregar Flutter al PATH del sistema.
echo.
echo NOTA: Debes ejecutar este script como Administrador
echo.
echo Presiona cualquier tecla para continuar o Ctrl+C para cancelar...
pause >nul

echo.
echo Verificando si se est  ejecutando como administrador...
net session >nul 2>&1
if %errorlevel% == 0 (
    echo ¡Ejecut ndose como administrador!
) else (
    echo.
    echo ERROR: Este script debe ejecutarse como Administrador
    echo.
    echo Por favor, haz clic derecho en el archivo y selecciona "Ejecutar como administrador"
    echo.
    pause
    exit /b
)

echo.
echo Ingrese la ruta donde instal¢ Flutter (por ejemplo: C:\src\flutter):
set /p FLUTTER_PATH="Ruta: "

if exist "%FLUTTER_PATH%\bin\flutter.bat" (
    echo.
    echo Agregando %FLUTTER_PATH%\bin al PATH del sistema...
    
    REM Obtener el PATH actual
    for /f "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path') do set "MACHINE_PATH=%%b"
    
    REM Verificar si la ruta ya est  en el PATH
    echo %MACHINE_PATH% | find /i "%FLUTTER_PATH%\bin" >nul
    if %errorlevel% == 0 (
        echo.
        echo ¡La ruta ya est  en el PATH del sistema!
    ) else (
        REM Agregar la nueva ruta al PATH
        setx PATH "%MACHINE_PATH%;%FLUTTER_PATH%\bin" /M
        echo.
        echo ¡Ruta agregada exitosamente al PATH del sistema!
        echo.
        echo Reinicia tu terminal para aplicar los cambios.
    )
) else (
    echo.
    echo ERROR: No se encontr¢ Flutter en la ruta especificada
    echo Verifica que la ruta sea correcta y que Flutter est‚ instalado all¡
)

echo.
pause