@echo off
setlocal enabledelayedexpansion

echo === Iniciando proceso de configuración ===
echo [1] Verificando instalación de conda...
call conda --version
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Conda no está instalado o no está en el PATH
    pause
    exit /b 1
)
echo [OK] Conda encontrado

set ENV_NAME=techrentals_env
echo [2] Verificando si existe el entorno %ENV_NAME%...

call conda env list | findstr /C:"%ENV_NAME%" > nul
if !ERRORLEVEL! neq 0 (
    echo [3] Creando nuevo entorno conda: %ENV_NAME%
    call conda create -y -n %ENV_NAME% python=3.9
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] No se pudo crear el entorno conda
        pause
        exit /b 1
    )
    
    echo [4] Activando el entorno %ENV_NAME%...
    call activate %ENV_NAME%
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] No se pudo activar el entorno conda
        pause
        exit /b 1
    )
    
    echo [5] Instalando dependencias...
    call conda install -y sqlite
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] No se pudo instalar sqlite
        pause
        exit /b 1
    )
    call pip install flask
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] No se pudo instalar flask
        pause
        exit /b 1
    )
    
    echo.
    echo Entorno configurado correctamente con:
    echo - Python 3.9
    echo - SQLite3
    echo - Flask
) else (
    echo [3] El entorno %ENV_NAME% ya existe
    echo [4] Activando el entorno existente...
    call activate %ENV_NAME%
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] No se pudo activar el entorno conda
        pause
        exit /b 1
    )
    echo [OK] Entorno activado correctamente
)

echo.
echo [6] Iniciando aplicación...
python app.py
if !ERRORLEVEL! neq 0 (
    echo [ERROR] La aplicación falló con código de error !ERRORLEVEL!
)

echo.
echo === Proceso completado ===
REM Mantener la ventana abierta
pause
endlocal
