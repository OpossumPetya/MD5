MD5
===

Lists MD5 hashes of all files in specified directory.

- Current directory is used by default.
- File name and dize is also displayed by default.
- /b[are] switch is available to list MD5 hashes only


Complite to .EXE
================

Complite to .exe with PAR::PAcker:

`pp --info=FileVersion=1.0.0.0 --icon icon_md5.ico -o md5.exe md5.pl`

Help
====

Displays MD5 hashes of files in a directory.

    MD5.PL [drive:][path] [/b]

      [drive:][path]
                Specifies drive and/or directory to process.
                The current directory is processed by default.

      /b        Bare format (prints only MD5 hash).
