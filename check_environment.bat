@echo off
echo ========================================
echo Verificaci¢n del entorno de desarrollo
echo ========================================
echo.

echo Verificando versi¢n de Windows...
ver
echo.

echo Verificando PowerShell...
where powershell >nul 2>&1
if %errorlevel% == 0 (
    echo ¡PowerShell est  disponible!
) else (
    echo PowerShell no est  disponible
)
echo.

echo Verificando instalaci¢n de Flutter...
where flutter >nul 2>&1
if %errorlevel% == 0 (
    echo ¡Flutter est  instalado!
    flutter --version
    echo.
    
    echo Verificando configuraci¢n de Flutter...
    flutter doctor
) else (
    echo.
    echo ¡Flutter NO est  instalado o no est  en el PATH!
    echo.
    echo Instrucciones para instalar Flutter:
    echo 1. Descarga Flutter desde: https://docs.flutter.dev/get-started/install/windows
    echo 2. Extrae el archivo en C:\src\flutter
    echo 3. Agrega C:\src\flutter\bin a tu variable PATH
    echo 4. Reinicia tu terminal
)
echo.

echo Verificando Java (requerido para Android)...
where java >nul 2>&1
if %errorlevel% == 0 (
    echo ¡Java est  instalado!
    java -version
) else (
    echo Java no est  instalado (puede ser requerido para Android)
)
echo.

echo Verificando Android Studio (opcional pero recomendado)...
if exist "C:\Program Files\Android\Android Studio\bin\studio64.exe" (
    echo ¡Android Studio est  instalado!
) else (
    echo Android Studio no est  instalado
    echo Puedes descargarlo desde: https://developer.android.com/studio
)
echo.

echo Verificando directorio del proyecto...
if exist "c:\Users\pedri\Documents\project-adventureworks\pubspec.yaml" (
    echo ¡Directorio del proyecto encontrado!
) else (
    echo No se encontr¢ el directorio del proyecto
)
echo.

echo ========================================
echo Resumen
echo ========================================
echo Si Flutter est  correctamente instalado y en el PATH,
echo puedes ejecutar el proyecto con:
echo.
echo   cd c:\Users\pedri\Documents\project-adventureworks
echo   flutter pub get
echo   flutter run
echo.
echo Para ejecutar en Chrome:
echo   flutter run -d chrome
echo.

pause