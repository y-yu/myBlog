use 5.14.0;

my $result = `wget -O - --no-check-certificate --header="Content-Type: text/plain" --post-file="$ARGV[0]" https://api.github.com/markdown/raw`;

open my $fh, ">", $ARGV[1];

say $fh "<html>\n<head>";
say $fh '<link href="./css/reset.css" rel="stylesheet" type="text/css" />';
say $fh '<link href="./css/960.css" rel="stylesheet" type="text/css" />';
say $fh '<link href="./css/uv_active4d.css" rel="stylesheet" type="text/css" />';
say $fh '<link href="./css/documentation.css" media="screen" rel="stylesheet" type="text/css">';
say $fh '<link href="./css/pygments.css" media="screen" rel="stylesheet" type="text/css">';
say $fh '<link href="./css/documentation.css" media="screen" rel="stylesheet" type="text/css">';
say $fh '<link href="./css/my.css" media="screen" rel="stylesheet" type="text/css">';
say $fh '</head><body><div id="content">';

say $fh $result;

say $fh '</div></body></html>';

close $fh;
