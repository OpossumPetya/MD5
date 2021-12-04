MD5
===

Print MD5 hashes of files in specified directory (wildcards accepted). Also works for a single file.

- Current directory is used by default
- File name and size are also displayed by default
- `/b` (bare) switch is available to list MD5 hashes only. Files are still processed in Alphabetical order (case ignored).


Usage
=====

    Displays MD5 hashes of files in a directory.

    MD5.PL [drive:][path] [/b]

      [drive:][path]
                Specifies drive and/or directory or file to process.
                The current directory is processed by default.

      /b        Bare format (prints only MD5 hash).
      /?        Print this help.

How to pack to .EXE
===================

Pack to `.exe` file with [PAR::Packer](https://metacpan.org/pod/pp):

`pp -o md5.exe md5.pl`

To do
=====

- Recursively process subdirectories (`/s`)
- Quiet mode (`/q`) - do not print failed attempts (ex.: no access rights to a file)
- Flexible/configurable output (templates: MD5 hash, file name, file size, directory name, directory path)
- Handle "no permission" directories
- Add tests!

Changes
=======

2021-12-04
* Tidied up internals.

Previously
* Added processing of a single file
