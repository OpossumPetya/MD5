
use v5.10;
    # stackable filetest ops :: https://perldoc.perl.org/functions/-X.html
    # say()
    # defined-or
use strict;
use warnings;

use Getopt::Long qw/:config prefix_pattern=(--|-|\/) long_prefix_pattern=(--|\/)/;
use File::DosGlob 'glob';
use File::Spec;
use Digest::MD5 qw/md5 md5_hex/;

use constant DEFAULT_DIR => ".\\";

my %config = (
    opt_Bare      => 0,
    opt_Subdirs   => 0,
    opt_Quiet     => 0,
    opt_PrintHelp => 0,
);

GetOptions (
    "bare|b"    => \$config{opt_Bare},      # do not print file names / only print MD5 hashes
    "quiet|q"   => \$config{opt_Quiet},     # do not print access errors on files/folders
    "subdir|s"  => \$config{opt_Subdirs},   # recursevly process subdirectories
    "help|h|?"  => \$config{opt_PrintHelp}, # print usage help
) or print_usage(), exit;

print_usage(), exit if $config{opt_PrintHelp};

# ===========================================================================

my $opt_Dir = shift @ARGV // DEFAULT_DIR;

# removes backslash if present, and converts relative paths to absolute
# for example: "\windows\system32\..\fonts\" => "c:\windows\fonts"
$opt_Dir = File::Spec->rel2abs( File::Spec->canonpath($opt_Dir) );

if ( -e -f $opt_Dir ) {
    # say "process single file";
    my ($vol, $dir, $file) = File::Spec->splitpath($opt_Dir);
    chop $dir; # remove trailing backslash
    process_file($vol.$dir, $file);
}
elsif ( -e $opt_Dir ) {
    # say "process single directory";
    opendir my $DH, $opt_Dir or die "$!";
    my @files = 
        sort { "\L$a" cmp "\L$b" }
        grep { -f "$opt_Dir\\$_" } 
        readdir $DH;
    for my $file (@files) {
        process_file($opt_Dir, $file);
    }
    closedir $DH;
}
else {
    # say "process path w/ wildcards";
    my @files = glob $opt_Dir;
    my ($cur_vol, $cur_dir, undef) = File::Spec->splitpath($opt_Dir);
    say "\n  $cur_vol$cur_dir\n";
    for my $file (
        sort { "\L$a" cmp "\L$b" }
        grep { -f "$_" } 
        @files
    ){
        my ($vol, $dir, $file) = File::Spec->splitpath($file);
        process_file($vol.$dir, $file);
    }
}

exit 0;

# ===========================================================================

sub process_file {
    my $dir  = shift;
    my $file = shift;
    
    my $ret = 0;
    my $file_path = "$dir\\$file";
    
    if ( open(my $FH, $file_path) ) {
        binmode $FH;
        print Digest::MD5->new->addfile($FH)->hexdigest;
        print " - $file (".( -s $file_path ).")" unless $config{opt_Bare};
        print "\n";
        close $FH;
    } else {
        say "$file skipped: $!";
        $ret = 1;
    }
    
    return $ret;
}

sub print_usage {
    my (undef, undef, $script_file) = File::Spec->splitpath($0);
    $script_file = uc $script_file;

    print <<~ "HOW_TO_USE";

        Displays MD5 hashes of files in a directory.

        $script_file [drive:][path] [/b]

        [drive:][path]
                  Specifies drive and/or directory or file to process.
                  The current directory is processed by default.

        /b\t    Bare format (prints only MD5 hash).
        /?\t    Print this help.
      HOW_TO_USE
}