# softmul
Proving that a system with software trap handlers for unimplemented instructions behaves as if they were implemented in hardware

### Checking the line number counts

The lines of code numbers in the paper can be reproduced as follows.
First, note that `loc/all-files.txt` assigns a category to each file.
To check that we did not miss any file, run

```
loc/completenesscheck.sh
```

whose output should be empty (it lists all .v files that recursive `find` finds in `src` but are not listed in `loc/all-files.txt`).
Then, run

```
python loc/allcount.py < loc/all-files.txt
```

which parses the annotations like eg `(*tag:proof*)` or `(*tag:obvious*)`, and whenever it encounters such a tag, it changes the line counter to be incremented.
It outputs two `.tex` files, and you can run

```
cat loc.tex
```

to inspect them and compare them to the values reported in the paper.
