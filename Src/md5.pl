
use v5.10; # so filetest ops can stack / https://perldoc.perl.org/functions/-X.html
use strict;
use warnings;

use File::DosGlob 'glob';
use File::Spec;
use Digest::MD5 qw(md5 md5_hex);

use constant {
    ARG_BARE    => '/b',    # bare format = list only MD5 hashes
    DEFAULT_DIR => ".\\",   # current directory
};

my $dir = shift;            # shifts from @ARGV
my $arg = $ARGV[0] || "";

my $CURRENT_DIR = '';

# if no arguments specified, then process current directory
$dir = DEFAULT_DIR unless defined $dir;

# user specifically asked for help...
if( $dir eq '/?' || $dir eq '/h' || $dir eq '-h' || $dir eq '--help' )
{
    my( undef, undef, $script_file ) = File::Spec->splitpath( $0 );
    $script_file = uc $script_file;

    print << "HOW_TO_USE";

Displays MD5 hashes of files in a directory.

$script_file [drive:][path] [/b]

  [drive:][path]
            Specifies drive and/or directory or file to process.
            The current directory is processed by default.

  @{[ ARG_BARE ]}\t    Bare format (prints only MD5 hash).
  /?\t    Print this help.

HOW_TO_USE
    exit;
}

# first argument was "use bare format" -- process DEFAULT_DIR with this option
if( lc $dir eq ARG_BARE ) {
    $dir = DEFAULT_DIR;
    $arg = ARG_BARE;
}

# removes backslash if present and converts relative paths to absolute
# for example: "\windows\system32\..\fonts\" => "c:\windows\fonts"
$dir = File::Spec->rel2abs( File::Spec->canonpath( $dir ) );

if( -e -f $dir ) {
    # say "process single file";
    my( $vol, $dir, $file ) = File::Spec->splitpath( $dir );
    chop $dir; # remove trailing slash
    process_file( $vol.$dir, $file );
}
elsif( -e $dir ) {
    # say "process single directory";
    opendir my $DH, $dir or die "$!";
    my @files = 
        sort { "\L$a" cmp "\L$b" }
        grep { -f "$dir\\$_" } 
        readdir $DH;
    for my $file (@files) {
        process_file( $dir, $file );
    }
    closedir $DH;
}
else {
    # say "process path w/ wildcards";
    my @files = glob $dir;
    for my $file (
        sort { "\L$a" cmp "\L$b" }
        grep { -f "$_" } 
        @files
    ){
        my( $vol, $dir, $file ) = File::Spec->splitpath($file);
        my $d = $vol.$dir;
        $CURRENT_DIR = $d, say "\n  $d\n" if $CURRENT_DIR ne $d;
        process_file( $dir, $file );
    }
}

exit 0;

# ===========================================================================

sub process_file {
    my $dir  = shift;
    my $file = shift;
    
    my $ret = 0;
    my $file_path = "$dir\\$file";
    
    if( open( my $FH, $file_path ) ) {
        binmode $FH;
        print Digest::MD5->new->addfile($FH)->hexdigest;
        if( lc $arg ne ARG_BARE ) {
            print " - $file (".( -s $file_path ).")";
        }
        print "\n";
        close $FH;
    }
    else {
        print "$file skipped: $!\n";
        $ret = 1;
    }
    
    return $ret;
}
