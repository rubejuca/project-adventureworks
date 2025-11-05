@echo off
echo ========================================
echo Ejecutar proyecto AdventureWorks
echo ========================================
echo.

REM Cambiar al directorio del proyecto
cd /d "c:\Users\pedri\Documents\project-adventureworks"

echo Verificando instalaci¢n de Flutter...
where flutter >nul 2>&1
if %errorlevel% == 0 (
    echo ¡Flutter est  instalado!
    echo.
    
    echo Actualizando dependencias...
    flutter pub get
    if %errorlevel% == 0 (
        echo.
        echo Dependencias actualizadas correctamente
        echo.
        
        echo Selecciona el dispositivo donde quieres ejecutar la aplicaci¢n:
        echo 1. Chrome (web)
        echo 2. Dispositivo Android (si est  conectado)
        echo 3. Emulador Android (si est  configurado)
        echo 4. Escritorio (Windows)
        echo 5. Lista todos los dispositivos disponibles
        echo.
        
        set /p OPCION="Selecciona una opci¢n (1-5): "
        
        if "%OPCION%"=="1" (
            echo Ejecutando en Chrome...
            pushd .
            cd /d "c:\Users\pedri\Documents\project-adventureworks"
            flutter run -d chrome
            popd
        ) else if "%OPCION%"=="2" (
            echo Ejecutando en dispositivo Android...
            pushd .
            cd /d "c:\Users\pedri\Documents\project-adventureworks"
            flutter run -d android
            popd
        ) else if "%OPCION%"=="3" (
            echo Ejecutando en emulador Android...
            pushd .
            cd /d "c:\Users\pedri\Documents\project-adventureworks"
            flutter run -d emulator
            popd
        ) else if "%OPCION%"=="4" (
            echo Ejecutando en Windows...
            pushd .
            cd /d "c:\Users\pedri\Documents\project-adventureworks"
            flutter run -d windows
            popd
        ) else if "%OPCION%"=="5" (
            echo Listando dispositivos disponibles...
            flutter devices
            echo.
            echo Ejecuta este script nuevamente para seleccionar un dispositivo
        ) else (
            echo Opci¢n no v lida. Ejecutando en dispositivo predeterminado...
            pushd .
            cd /d "c:\Users\pedri\Documents\project-adventureworks"
            flutter run
            popd
        )
    ) else (
        echo.
        echo ERROR: No se pudieron actualizar las dependencias
        echo Verifica tu conexi¢n a internet y vuelve a intentarlo
    )
) else (
    echo.
    echo ERROR: Flutter no est  instalado o no est  en el PATH
    echo.
    echo Ejecuta primero check_flutter.bat para verificar la instalaci¢n
)

echo.
pause