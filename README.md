MD5
===

Lists MD5 hashes of all files in specified directory.

- Current directory is used by default
- File name and size are also displayed by default
- `/b`[are] switch is available to list MD5 hashes only. Files are still processed in Alphabetical order (case ignored).


Help
====

    Displays MD5 hashes of files in a directory.

    MD5.PL [drive:][path] [/b]

      [drive:][path]
                Specifies drive and/or directory or file to process.
                The current directory is processed by default.

      /b        Bare format (prints only MD5 hash).
      /?        Print this help.

Compile to .EXE
===============

Complite to .exe with PAR::Packer:

`pp --info=FileVersion=1.0.0.0 --icon icon_md5.ico -o md5.exe md5.pl`

To do
=====

- Process arguments using light CPAN module
- Recursively process subdirectories (`/s`)
- Flexible/configurable output (templates for MD5: file name, file size, directory name, directory path)
- Quiet mode (`/q`) - do not print failed attempts (for example, when no rights to open a file error is encountered)
- Handle "no permission" directories
- Add tests!

Changes
=======

v1.0.1.0
* Added processing of a single file
