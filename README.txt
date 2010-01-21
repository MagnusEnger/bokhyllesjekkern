bokhylla.pl - compare a list of ISBNs to the digitized holdings of the Norwegian National Library (NB). 

BACKGROUND

The National Library of Norway (NB) is digitizing its collections. These fall into three categories: 
* Materials that are public domain
* Materials that are not public domain, but that can be made avialable online because NB has made a deal with the authors' organizations about compensation. The deal is available here: http://www.nb.no/pressebilder/Contract_NationalLibraryandKopinor.pdf
* Materials that are noe public domain and not covered by the deal described above - these are noe available to the public. 

The materials that are publicly avialable can be accessed through Bokhylla (The Bookshelf): http://www.nb.no/bokhylla

More information in Norwegian: 
http://www.nb.no/bokhylla/om/om-bokhylla
http://www.nb.no/nbdigital/beta/ 

The holdings in the different categories are described in certain files, see below. 

PREPARATIONS

1. Get hold of ISBNs. 

If you use Koha as your ILS, you can log on to MySQL from the command line and run this query:

mysql> SELECT DISTINCT isbn FROM biblioitems WHERE isbn != '' INTO OUTFILE '/tmp/isbn.txt';

This will give you a list of all the distinct ISBNs in your catalogue, in a file called /tmp/isbn.txt. This list may contain some extra information, and if a record has more than one ISBN you will get things like "isbn1 | isbn2", so a bit of manual cleaning up may be called for. 

2. Get hold of the files from NB

Download the files you want/need from here: 
http://nb.no/nbdigital/bokliste/

There are 4 files: 

1 Bokhylla iht. avtalen     -> bokhylla_02.txt            -> Books that NB pay authors to make available
2 Tilgjengelig på Internett -> tilgjengelig_internett.txt -> The sum of 1 and 3
3 I det fri                 -> public.txt                 -> Books in the public domain
4 Totalt                    -> totalt.txt                 -> 2 + books that are not available outside NB

Download the file(s) you need to your computer. 

RUNNING THE SCRIPT

Usage:
    ./bokhylla.pl -i /tmp/public.txt -s /tmp/isbn.txt > my_digital_books.txt

Options:
    -b, --bokhyllafile
        Name of the file from Bokhylla to be read, see
        http://nb.no/nbdigital/bokliste/

    -i, --isbnfile
        File containing the ISBNs, one pr line.

    -v, --verbose
        Verbose output, including found ISBNs and titles.

    -h, -?, --help
        Prints this help message and exits.
        
LICENSE

Copyright 2010 Magnus Enger Libriotech
 
This file is part of Bokhyllesjekker'n.
 
Bokhyllesjekker'n is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
 
Bokhyllesjekker'n is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with Bokhyllesjekker'n. If not, see <http://www.gnu.org/licenses/>.
 
Source code available from:
http://github.com/MagnusEnger/bokhyllesjekkern/