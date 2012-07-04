use strict;
use warnings;

use File::Spec;
use Digest::MD5 qw(md5 md5_hex);

use constant {
    ARG_BARE    => '/b',    # bare format = list only MD5 hashes
    DEFAULT_DIR => ".\\",   # current directory
};

my $dir = shift;            # shifts from @ARGV
my $arg = $ARGV[0] || "";


# if no arguments specified, then process current directory
$dir = DEFAULT_DIR unless defined $dir;

# user specifically asked for help...
if( $dir eq '/?' || $dir eq '-h' || $dir eq '--help' )
{
    my( undef, undef, $script_file ) = File::Spec->splitpath( $0 );
    $script_file = uc $script_file;

    print << "HOW_TO_USE";

Displays MD5 hashes of files in a directory.

$script_file [drive:][path] [/b]

  [drive:][path]
            Specifies drive and/or directory to process.
            The current directory is processed by default.

  @{[ ARG_BARE ]}\t    Bare format (prints only MD5 hash).
    
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

opendir( my $DH, $dir ) or die "$!";
    
    my @files = sort grep { -f "$dir\\$_" } readdir $DH;

    for( @files ) {
        my $file_name = $_;         # only name of the file
        my $file_path = "$dir\\$_"; # full path to a file
        
        if( open( my $FH, $file_path ) ) {
            binmode( $FH );
            
            print Digest::MD5->new->addfile($FH)->hexdigest;
            if( lc $arg ne ARG_BARE) {
                print " - $file_name (".( -s $file_path ).")";
            }
            print "\n";
            
            close $FH;
        }
        else {
            print "$file_name skipped: $!\n";
        }
    }

closedir $DH;
