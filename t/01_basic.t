use strict;
use warnings;
use utf8;
use Test::More 0.98;
use Text::Markdown::Slidy;

my @cases = ({
    name  => 'plain',
    input => q{
Title1
======
abcde
fg

Title2
------
hoge

},
    expect => q{<div class="slide">
<h1>Title1</h1>

<p>abcde
fg</p>
</div>

<div class="slide">
<h2>Title2</h2>

<p>hoge</p>
</div>
}}, {
    name => 'loose frontmatter',
    input => q{hoge: fuga
---
# Title

Title2
---

hoge},
    expect => q{<div class="slide">
<h1>Title</h1>
</div>

<div class="slide">
<h2>Title2</h2>

<p>hoge</p>
</div>
},
    meta => {hoge => 'fuga'},
}, {
    name => 'strict frontmatter',
    input => q{---
hoge: fuga
---
# Title

Title2
---

hoge},
    expect => qq{<div class="slide">
<h1>Title</h1>
</div>

<div class="slide">
<h2>Title2</h2>

<p>hoge</p>
</div>
},
    expect => q{<div class="slide">
<h1>Title</h1>
</div>

<div class="slide">
<h2>Title2</h2>

<p>hoge</p>
</div>
},
    meta => {hoge => 'fuga'},
},
);

for my $tc (@cases) {
    subtest $tc->{name}, sub {
        my $md = markdown($tc->{input});
        is $md, $tc->{expect};

        my ($md2, $meta) = markdown($tc->{input});
        is $md2, $tc->{expect};
        my $expect_meta = $tc->{meta};
        if (!$expect_meta) {
            ok !$meta;
        } else {
            is_deeply $meta, $tc->{meta};
        }
    };
}

done_testing;
