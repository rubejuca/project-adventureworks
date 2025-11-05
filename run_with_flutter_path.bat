@echo off
echo ========================================
echo Ejecutar proyecto AdventureWorks con Flutter PATH
echo ========================================
echo.

REM Solicitar la ruta de instalaci¢n de Flutter al usuario
echo Por favor, ingresa la ruta donde tienes instalado Flutter
echo (Ejemplo: C:\src\flutter o C:\Users\TuNombre\flutter)
echo.
set /p FLUTTER_PATH="Ruta de Flutter: "

REM Verificar que la ruta existe
if not exist "%FLUTTER_PATH%\bin\flutter.bat" (
    echo.
    echo ERROR: No se encontr¢ Flutter en la ruta especificada
    echo Verifica que la ruta sea correcta y que Flutter est‚ instalado all¡
    echo.
    pause
    exit /b
)

REM Establecer el PATH para incluir Flutter
set PATH=%PATH%;%FLUTTER_PATH%\bin

echo.
echo Verificando instalaci¢n de Flutter...
where flutter >nul 2>&1
if %errorlevel% == 0 (
    echo ¡Flutter est  disponible!
    echo.
    
    REM Cambiar al directorio del proyecto
    cd /d "c:\Users\pedri\Documents\project-adventureworks"
    
    echo Actualizando dependencias...
    flutter pub get
    if %errorlevel% == 0 (
        echo.
        echo Dependencias actualizadas correctamente
        echo.
        
        echo Selecciona el dispositivo donde quieres ejecutar la aplicaci¢n:
        echo 1. Chrome (web)
        echo 2. Windows (escritorio)
        echo 3. Lista todos los dispositivos disponibles
        echo.
        
        set /p OPCION="Selecciona una opci¢n (1-3): "
        
        if "%OPCION%"=="1" (
            echo Ejecutando en Chrome...
            flutter run -d chrome
        ) else if "%OPCION%"=="2" (
            echo Ejecutando en Windows...
            flutter run -d windows
        ) else if "%OPCION%"=="3" (
            echo Listando dispositivos disponibles...
            flutter devices
            echo.
            echo Ejecuta este script nuevamente para seleccionar un dispositivo
        ) else (
            echo Opci¢n no v lida. Ejecutando en dispositivo predeterminado...
            flutter run
        )
    ) else (
        echo.
        echo ERROR: No se pudieron actualizar las dependencias
        echo Verifica tu conexi¢n a internet y vuelve a intentarlo
    )
) else (
    echo.
    echo ERROR: Flutter no se encuentra incluso despu‚s de establecer el PATH
    echo.
    echo Verifica que Flutter est‚ instalado correctamente en %FLUTTER_PATH%
)

echo.
pause