use strict;
use warnings;
use utf8;
use Test::More;
use Text::Markdown::Slidy;

my $text = <<'...';


Title1
======
abcde
fg

Title2
------
hoge

...

is_deeply [Text::Markdown::Slidy::_split_slides($text)], ['Title1
======
abcde
fg
',
'Title2
------
hoge'
];

is markdown($text), <<'...';
<div class="slide">
<h1>Title1</h1>

<p>abcde
fg</p>
</div>

<div class="slide">
<h2>Title2</h2>

<p>hoge</p>
</div>
...

done_testing;