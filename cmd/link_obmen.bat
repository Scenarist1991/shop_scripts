chcp 866
FOR /F "DELIMS=" %i IN ('dir /b C:\Users\...\Desktop\* ^| findstr /s /i /C:"����� ���-���� � �� �ॡ������.lnk') DO @FORFILES /P C:\Users\...\Desktop\ /M "%i" /S /C "CMD /C del /Q @path"