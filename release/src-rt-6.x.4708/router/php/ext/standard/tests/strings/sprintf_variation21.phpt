--TEST--
Test sprintf() function : usage variations - char formats with integer values
--FILE--
<?php
/* Prototype  : string sprintf(string $format [, mixed $arg1 [, mixed ...]])
 * Description: Return a formatted string
 * Source code: ext/standard/formatted_print.c
*/

echo "*** Testing sprintf() : char formats with integer values ***\n";

// array of integer values
$integer_values = array(
  0,
  1,
  -1,
  -2147483648, // max negative integer value
  -2147483647,
  2147483647,  // max positive integer value
  2147483640,
  0x123B,      // integer as hexadecimal
  0x12ab,
  0Xfff,
  0XFA,
  -0x80000000, // max negative integer as hexadecimal
  0x7fffffff,  // max positive integer as hexadecimal
  0x7FFFFFFF,  // max positive integer as hexadecimal
  0123,        // integer as octal
  01,       // should be quivalent to octal 1
  -020000000000, // max negative integer as octal
  017777777777  // max positive integer as octal
);

// array of char formats
$char_formats = array(
  "%c", "%hc", "%lc",
  "%Lc", " %c", "%c ",
  "\t%c", "\n%c", "%4c",
  "%30c", "%[a-bA-B@#$&]", "%*c"
);

$count = 1;
foreach($integer_values as $integer_value) {
  echo "\n-- Iteration $count --\n";

  foreach($char_formats as $format) {
    var_dump( sprintf($format, $integer_value) );
  }
  $count++;
};

echo "Done";
?>
--EXPECTF--
*** Testing sprintf() : char formats with integer values ***

-- Iteration 1 --
string(1) " "
string(1) "c"
string(1) " "
string(1) "c"
string(2) "  "
string(2) "  "
string(2) "	 "
string(2) "
 "
string(1) " "
string(1) " "
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 2 --
string(1) ""
string(1) "c"
string(1) ""
string(1) "c"
string(2) " "
string(2) " "
string(2) "	"
string(2) "
"
string(1) ""
string(1) ""
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 3 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 4 --
string(1) " "
string(1) "c"
string(1) " "
string(1) "c"
string(2) "  "
string(2) "  "
string(2) "	 "
string(2) "
 "
string(1) " "
string(1) " "
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 5 --
string(1) ""
string(1) "c"
string(1) ""
string(1) "c"
string(2) " "
string(2) " "
string(2) "	"
string(2) "
"
string(1) ""
string(1) ""
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 6 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 7 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 8 --
string(1) ";"
string(1) "c"
string(1) ";"
string(1) "c"
string(2) " ;"
string(2) "; "
string(2) "	;"
string(2) "
;"
string(1) ";"
string(1) ";"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 9 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 10 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 11 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 12 --
string(1) " "
string(1) "c"
string(1) " "
string(1) "c"
string(2) "  "
string(2) "  "
string(2) "	 "
string(2) "
 "
string(1) " "
string(1) " "
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 13 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 14 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 15 --
string(1) "S"
string(1) "c"
string(1) "S"
string(1) "c"
string(2) " S"
string(2) "S "
string(2) "	S"
string(2) "
S"
string(1) "S"
string(1) "S"
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 16 --
string(1) ""
string(1) "c"
string(1) ""
string(1) "c"
string(2) " "
string(2) " "
string(2) "	"
string(2) "
"
string(1) ""
string(1) ""
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 17 --
string(1) " "
string(1) "c"
string(1) " "
string(1) "c"
string(2) "  "
string(2) "  "
string(2) "	 "
string(2) "
 "
string(1) " "
string(1) " "
string(11) "a-bA-B@#$&]"
string(1) "c"

-- Iteration 18 --
string(1) "?"
string(1) "c"
string(1) "?"
string(1) "c"
string(2) " ?"
string(2) "? "
string(2) "	?"
string(2) "
?"
string(1) "?"
string(1) "?"
string(11) "a-bA-B@#$&]"
string(1) "c"
Done
