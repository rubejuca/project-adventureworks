@echo off
echo ========================================
echo Ejecutar proyecto AdventureWorks
echo ========================================
echo.

REM Establecer el PATH para incluir Flutter en la ubicaci¢n especificada
set PATH=%PATH%;C:\src\flutter\bin

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
        echo 4. Ejecutar en dispositivo predeterminado
        echo.
        
        set /p OPCION="Selecciona una opci¢n (1-4): "
        
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
        ) else if "%OPCION%"=="4" (
            echo Ejecutando en dispositivo predeterminado...
            flutter run
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
    echo ERROR: Flutter no se encuentra en C:\src\flutter\bin
    echo.
    echo Verifica que Flutter est‚ correctamente instalado en esa ubicaci¢n
    echo o ejecuta run_with_flutter_path.bat para ingresar la ruta manualmente
)

echo.
pause