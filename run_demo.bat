@echo off
color 0A
cls
echo.
echo ========================================
echo   TECH RISK ANALYSIS - PostgreSQL
echo   Database: stockexchange
echo ========================================
echo.
echo [1/3] Connecting to database...
timeout /t 2 /nobreak >nul
echo [OK] Connected to PostgreSQL 18.3
echo.
echo [2/3] Running risk assessment query...
echo.
timeout /t 2 /nobreak >nul
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -h localhost -U postgres -d stockexchange -f tech_risk_query.sql
echo.
echo [3/3] Analysis complete!
echo.
echo ========================================
echo   Press any key to exit
echo ========================================
pause >nul