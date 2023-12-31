% A variant of BibTeX standard bibliography style `apsr' (one of the harvard family)
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1991, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, abbrv.bst, agsm.bst,
       % dcu.bst or kluwer.bst, jmr.bst, apsr.bst.
	% This restriction helps ensure that all standard styles are identical.
	% The file harvard.tex has the documentation for this style.

% ACKNOWLEDGEMENT:
%   This document is a modified version of alpha.bst to which it owes much of
%   its functionality.

% AUTHOR
%   Peter Williams, Key Centre for Design Quality, Sydney University
%   e-mail: peterw@archsci.arch.su.oz.au

% Additional changes by Bernd Beber, Columbia University, bhb2102@columbia.edu (August 2008)
% Includes fixes for some minor formatting inconsistencies between current requirements for
% the American Political Science Review and the style file apsr.bst distributed with the harvard LaTeX package:
% * A comma is now placed before the word "and" when it separates author names in the bibliography;
% * A comma is placed before the word "and" when it separates author names for in-text citations with more than two authors;
% * A space is added between journal volume and issue, and colon and page numbers;
% * For BibTeX item incollection, the chapter title is now quoted.

%Additional changes by Michael P. Fix (mpfix1@gmail.com) and Susanne Schorpp (SCHORPP@mailbox.sc.edu), University of South Carolina (November 2009)
% Includes fixes for minor formatting inconsistencies between the style file apsr.bst and the most recent revision of the APSA Style Manual for Political Science:
%*Month is now placed in article citations in place of issue number, unless month is empty in which case issue number used
%* The space between volume and month has been removed for article citations
%* The ampersand symbol has been replaced with the word "and" to separate lists of two or more authors


ENTRY
 { address
   author
   booktitle
   branch             % for Congressional reports
   chapter
   committee          % for Congressional reports
   computerfile       % for ICPSR
   computerfileyear   % for ICPSR
   congress           % for Congressional reports
   distributor        % for ICPSR
   distributoraddress % for ICPSR
   distributoryear    % for ICPSR
   district           % for court_case
   edition
   editor
   firstpage          % for court_case
   howpublished
   institution
   journal
   key
   month
   monthday
   note
   number
   organization
   originalyear
   pages
   producer        % for ICPSR
   produceraddress % for ICPSR
   produceryear    % for ICPSR
   publisher
   school
   series
   session         % for Congressional reports
   source
   title
   type
   URL
   volume
   year
 }
 { field.used etal.allowed etal.required} %%%XXX change
 { extra.label sort.label list.year }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
 #1 'mid.sentence :=
 #2 'after.sentence :=
 #3 'after.block :=
}

STRINGS { s t f }

FUNCTION {output.nonnull}
{ 's :=
 output.state mid.sentence =
   { " " * write$ }
   { output.state after.block =
	{ add.period$ write$
	  newline$
	  %"\newblock " write$ % This adds a second space between year and book/article title in bibliography.
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
     if$
     mid.sentence 'output.state :=
   }
 if$
 s
}

FUNCTION {output}
{ duplicate$ empty$
   'pop$
   'output.nonnull
 if$
}

FUNCTION {output.check}
{ 't :=
 duplicate$ empty$
   { pop$ "empty " t * " in " * cite$ * warning$ }
   'output.nonnull
 if$
}

FUNCTION {item.check}
{ 't :=
 empty$
   { "empty " t * " in " * cite$ * warning$ }
   { skip$ }
 if$
}

FUNCTION {fin.entry}
{ add.period$
 write$
 newline$
}

FUNCTION {new.block}
{ output.state before.all =
   'skip$
   { after.block 'output.state := }
 if$
}

FUNCTION {not}
{   { #0 }
   { #1 }
 if$
}

FUNCTION {and}
{   'skip$
   { pop$ #0 }
 if$
}

FUNCTION {or}
{   { pop$ #1 }
   'skip$
 if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
   { pop$ "" }
   'skip$
 if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
   { pop$ "" }
   { "{\em " swap$ * "}" * }
 if$
}

FUNCTION {embolden}
{ duplicate$ empty$
   { pop$ "" }
   { "{\bf " swap$ * "}" * }
 if$
}

% Material for Tristan Miller's find.replace BibTeX function:
% see http://www.nothingisreal.com/biblet/.
INTEGERS{ l }
FUNCTION{ string.length }
{
 #1 'l :=
 {duplicate$ duplicate$ #1 l substring$ = not}
   {l #1 + 'l :=}
 while$
 pop$ l
}
STRINGS{replace find text}
INTEGERS {find_length}
FUNCTION {find.replace}
{ 'replace :=
 'find :=
 'text :=
 find string.length 'find_length :=
 ""
   { text empty$ not }
   { text #1 find_length substring$ find =
       { replace *
     text #1 find_length + global.max$ substring$ 'text :=
       }
   { text #1 #1 substring$ *
     text #2 global.max$ substring$ 'text :=
   }
     if$
   }
 while$
}
% End of material for Tristan Miller's find.replace BibTeX function:


FUNCTION {write.url}
{ URL empty$
   { skip$ }
   { "\harvardurl{" URL * "}" * add.period$ write$ newline$}    %{ "\newline\harvardurl{" URL * "}" * write$ newline$ }
 if$
}

FUNCTION {quote}
{ duplicate$ empty$
   { pop$ "" }
   { "``" swap$ * "''" * }
 if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.rem.names}
{ 's :=
 'f :=
 #2 'nameptr :=
 s num.names$ 'numnames :=
 numnames #1 - 'namesleft :=
   { namesleft #0 > }
   { s nameptr f format.name$ 't :=
     nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { t "others" =
		{ " et~al." * }
		{ numnames #2 >
			{ ", and " * t * }
			{ ", and " * t * }
			if$
		}
	      if$
	    }
	  if$
	}
	't
     if$
     nameptr #1 + 'nameptr :=
     namesleft #1 - 'namesleft :=
   }
 while$
}

FUNCTION {format.rem.names.editors} {
 's :=
 'f :=
 #2 'nameptr :=
 s num.names$ 'numnames :=
 numnames #1 - 'namesleft :=
 { namesleft #0 > }
   { s nameptr f format.name$ 't :=
     nameptr #1 >
       { namesleft #1 >
           { ", " * t * }
           { t "others" =
               { " et~al." * }
               { % begin if loop for editor commas in citations
                 numnames #2 >
                   { ", \harvardand\ " * t * }
                   { " \harvardand\ " * t * }
                 if$
               } % end if loop for editor commas in citations
           if$
           }
       if$
       }
       't
     if$
     nameptr #1 + 'nameptr :=
     namesleft #1 - 'namesleft :=
   }
 while$
}

STRINGS  { nametocheck }
INTEGERS { namestartlength nameendlength }
FUNCTION {format.names.roman.numerals}
{ 'nametocheck :=                                                % nametocheck     = text passed to this function
 nametocheck string.length 'nameendlength :=                    % nameendlength   = total length of passed text
 nametocheck string.length #4 - 'namestartlength :=             % namestartlength = position three characters before string end
 nametocheck namestartlength nameendlength substring$ ", III" = % if the last characters are ", III"
   { nametocheck ", III"  "~III"  find.replace}                      % do this
   { nametocheck namestartlength nameendlength substring$ ", IV" =   % else if the last three characters are ", IV"
     { nametocheck ", IV"  "~IV"  find.replace}                          % do this
     { nametocheck ", II"  "~II"  find.replace}                          % else do this
     if$
   }
 if$
}

FUNCTION {format.authors}
{ author empty$
   { "" }
   { author #1 "{vv~}{ll}{, jj}{, ff}" format.name$
     "{ff }{vv~}{ll}{, jj}" author format.rem.names format.names.roman.numerals
   }
 if$
}

FUNCTION {format.editors}
{ editor empty$
   { "" }
   { editor #1 "{vv~}{ll}{, jj}{, ff}" format.name$
     "{ff }{vv~}{ll}{, jj}" editor format.rem.names.editors % format.rem.names
     editor num.names$ #1 >
	{ ", eds" * }
	{ ", ed." * }
     if$
   }
 if$
}

FUNCTION {format.editors.reverse}
{ editor empty$
   { "" }
   { ", ed. "
     editor #1 "{ff }{vv~}{ll}{, jj}" format.name$ *
     "{ff }{vv~}{ll}{, jj}" editor format.rem.names.editors % format.rem.names
   }
 if$
}

STRINGS  { texttocheck }
INTEGERS { titlestartlength titleendlength }
FUNCTION {format.final_apostrophe}
{ 'texttocheck :=                                                  % text passed to this function
 texttocheck string.length 'titleendlength :=                     % total length of passed text
 texttocheck string.length #2 - 'titlestartlength :=              % three characters before
 texttocheck titlestartlength titleendlength substring$ ".'." =   % if the last three characters are ".'."
   { texttocheck ".'."  ".'"  find.replace}                             % do this
   { texttocheck "?'."  "?'"  find.replace}                             % else do this
 if$
}

FUNCTION {format.title}
{ title empty$
   { "" }
   { title add.period$ format.final_apostrophe }
 if$
}


FUNCTION {n.dashify}
{ 't :=
 ""
   { t empty$ not }
   { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
     if$
   }
 while$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {format.court_case.title}
{ " v. "  "\textnormal{ v. }"  find.replace
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
   { "~" }
   { " " }
 if$
 swap$ * *
}

FUNCTION {either.or.check}
{ empty$
   'pop$
   { "can't use both " swap$ * " fields in " * cite$ * warning$ }
 if$
}

FUNCTION {format.bvolume}
{ volume empty$
   { "" }
   { "Vol." volume tie.or.space.connect
     series empty$
	'skip$
	{ " of " * series emphasize * }
     if$
     "volume and number" number either.or.check
   }
 if$
}

FUNCTION {format.number.series}
{ volume empty$
   { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " {\em in} " * series quote * }
	  if$
	}
     if$
   }
   { "" }
 if$
}

FUNCTION {format.edition}
{ edition empty$
   { "" }
   { output.state mid.sentence =
	{ edition "l" change.case$ " ed." * }
	{ edition "t" change.case$ " ed." * }
     if$
   }
 if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
 #0 'multiresult :=
   { multiresult not
     t empty$ not
     and
   }
   { t #1 #1 substring$
     duplicate$ "-" =
     swap$ duplicate$ "," =
     swap$ "+" =
     or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
     if$
   }
 while$
 multiresult
}

FUNCTION {format.pages}
{ pages empty$
   { "" }
   { pages multi.page.check
	{ "pp.~" pages n.dashify * }
	{ "p.~" pages * }
     if$
   }
 if$
}

FUNCTION {format.address}
{ address empty$
   { "" }
   { address ": " *
   }
 if$
}

FUNCTION {format.num}
{ number empty$
 'skip$
 { "(" number * ")" * *
 }
 if$
}

FUNCTION {format.vol.mon.num.pages}
{ % volume field.or.null
 volume empty$
   {""}
   { " " * volume field.or.null }
 if$
 month empty$
   'format.num
   { "(" month *  ")" * *
     volume empty$
 	    { "there's a number but no volume in " cite$ * warning$ }
       'skip$
	  if$
   }
 if$
 pages empty$
   'skip$
   { duplicate$ empty$
	    { ": " * pages n.dashify * } % { pop$ format.pages }
	    { ": " * pages n.dashify * }
     if$
   }
 if$
}


FUNCTION {format.chapter.pages}
{ chapter empty$
   'format.pages
   { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
     if$
     chapter tie.or.space.connect
     pages empty$
	'skip$
	{ ", " * format.pages * }
     if$
   }
 if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
   { "" }
   { editor empty$
	{ " In " booktitle emphasize * }
	{ " In " booktitle emphasize * format.editors.reverse * }
     if$
   }
 if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
 month empty$ year empty$ note empty$
 and and and and and
 key empty$ not and
   { "all relevant fields are empty in " cite$ * warning$ }
   'skip$
 if$
}

FUNCTION {format.thesis.type}
{ type empty$
   'skip$
   { pop$
     type "t" change.case$
   }
 if$
}

FUNCTION {format.tr.number}
{ type empty$
   { "Technical Report" }
   'type
 if$
 number empty$
   { "t" change.case$ }
   { number tie.or.space.connect }
 if$
}

FUNCTION {format.article.crossref}
{ key empty$
   { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "in {\em " journal * "\/} \cite{" * crossref * "}" *}
     if$
   }
   { "{\em in} \citeasnoun{" crossref * "}" * }
 if$

}

FUNCTION {format.book.crossref}
{ volume empty$
   { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
     "in "
   }
   { "Vol." volume tie.or.space.connect
     " of " *
   }
 if$
 editor empty$
 editor field.or.null author field.or.null =
 or
   { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { "{\em " * series * "\/} \cite{" * crossref * "}" *}
	  if$
	}
	{ " \citeasnoun{" * crossref * "}" * }
     if$
   }
   { " \citeasnoun{" * crossref * "}" * }
 if$
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
 editor field.or.null author field.or.null =
 or
   { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { "in {\em " booktitle * "\/}" * " \cite{" * crossref * "}" *}
	  if$
	}
	{ "{\em in} \citeasnoun{" crossref * "}" * }
     if$
   }
   { "{\em in} \citeasnoun{" crossref * "}" * }
 if$

}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
 'len :=
 s #1 len substring$ =
   { s len #1 + global.max$ substring$ }
   's
 if$
}

INTEGERS { ind tsslen }

STRINGS { tss ret rss istr }

FUNCTION {replace.substring}{
 'rss :=
 'tss :=
 'istr :=
 "" 'ret :=
 tss text.length$ 'tsslen :=
 #1 'ind :=
   { istr ind tsslen substring$ "" = not }
   { istr ind tsslen substring$ tss =
       { ret rss * 'ret :=
         ind tsslen + 'ind :=
       }
       { ret istr ind #1 substring$ * 'ret :=
         ind #1 + 'ind :=
       }
     if$
   }
 while$
 ret
}

FUNCTION {format.lab.names.full}
{ 's :=
 #1 'nameptr :=
 s num.names$ 'numnames :=
 numnames 'namesleft :=
   { namesleft #0 > }
   { s nameptr "{vv~}{ll}" format.name$ 't :=
     nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { t "others" =
		{ " et~al." * }
		{ numnames #2 >
			{ ", and " * t * }
			{ " and " * t * }
			if$
		}
	      if$
	    }
	  if$
	}
	't
     if$
     nameptr #1 + 'nameptr :=
     namesleft #1 - 'namesleft :=
   }
 while$
}

FUNCTION {format.lab.names.abbr}
{ 's :=
 s num.names$ 'numnames :=
 numnames #1 >
   { numnames #3 >
	{ s #1 "{vv~}{ll}" format.name$ " et~al." * }
	{ s format.lab.names.full }
     if$
   }
   { s #1 "{vv~}{ll}" format.name$ }
 if$
}

INTEGERS { author.field editor.field organization.field title.field key.field }

FUNCTION {init.field.constants}
{ #0 'author.field :=
 #1 'editor.field :=
 #2 'organization.field :=
 #3 'title.field :=
 #4 'key.field :=
}

FUNCTION {make.list.label}
{ author.field field.used =
   { format.authors }
   { editor.field field.used =
       { format.editors }
       { organization.field field.used =
           { "The " #4 organization chop.word #3 text.prefix$ }
           { title.field field.used =
               { format.btitle }
               { key.field field.used =
                   { key #3 text.prefix$ }
                   { "Internal error :001 on " cite$ * " label" * warning$ }
                 if$
               }
             if$
           }
         if$
       }
     if$
   }
 if$
}

FUNCTION {make.full.label}
{ author.field field.used =
   { author format.lab.names.full }
   { editor.field field.used =
       { editor format.lab.names.full }
       { organization.field field.used =
           { "The " #4 organization chop.word #3 text.prefix$ }
           { title.field field.used =
               { format.btitle }
               { key.field field.used =
                   { key #3 text.prefix$ }
                   { "Internal error :001 on " cite$ * " label" * warning$ }
                 if$
               }
             if$
           }
         if$
       }
     if$
   }
 if$
}

FUNCTION {make.abbr.label} %%%XXX change
{
 etal.allowed
   { author.field field.used =
       { author format.lab.names.abbr }
       { editor.field field.used =
           { editor format.lab.names.abbr }
           { organization.field field.used =
               { "The " #4 organization chop.word #3 text.prefix$ }
               { title.field field.used =
                   { format.btitle }
                   { key.field field.used =
                       { key #3 text.prefix$ }
                       {"Internal error :001 on " cite$ * " label" * warning$ }
                     if$
                   }
                 if$
               }
             if$
           }
         if$
       }
     if$
   }
   { make.full.label }
 if$
}

FUNCTION {output.bibitem}
{ newline$
 etal.allowed        %%%XXX change
 etal.required
 and
   {
     "\harvarditem[" write$
     make.abbr.label write$
     "]{" write$
   }
   {
     "\harvarditem{" write$
   }
 if$
 make.full.label write$
 "}{" write$
 list.year "N.d." =
   { list.year "l" change.case$ write$ } % if year label would be written as "N.d.", write "n.d." instead
   { list.year write$ }
 if$ % list.year write$
 "}{" write$
 cite$ write$
 "}" write$
 newline$
 ""
 before.all 'output.state :=
}


FUNCTION {output.bibitem.congressional}
{ newline$
 "\bibitem[" write$
 "U.S. " write$
 branch write$
 "(" write$
 originalyear missing$
   {}
   {
      "{[}" originalyear * write$
      "{]} " write$
   }
 if$
 list.year "N.d." =
   { list.year "l" change.case$ write$ } % if year label would be written as "N.d.", write "n.d." instead
   { list.year write$ }
 if$
 ")]{" write$
 cite$ write$
 "}" write$
 newline$
 ""
 before.all 'output.state :=
}


FUNCTION {list.label.output}
{ make.list.label add.period$ " " * write$
}

FUNCTION {article}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author "author" item.check
 title.field field.used =
   { skip$ }
   { format.title quote "title" output.check }
 if$
 crossref missing$
   { journal emphasize "journal" duplicate$ item.check
     year empty$
       { ". Forthcoming" * output new.block }
       { "" * format.vol.mon.num.pages * output } % { " " * format.vol.mon.num.pages * output }
     if$
    }
   { format.article.crossref output.nonnull
     format.pages output
   }
 if$
 new.block
 fin.entry
}

FUNCTION {book}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author empty$
   { editor "author and editor" item.check }
   { crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
     if$
   }
 if$
 title.field field.used =
   { skip$ }
   { format.btitle "title" output.check }
 if$
 new.block
 crossref missing$
   { format.bvolume output
     format.number.series output
     format.edition output
     format.address output
     publisher "publisher" output.check
   }
   { format.book.crossref output.nonnull
     format.edition output
   }
 if$
 new.block
 fin.entry
}

FUNCTION {booklet}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 title.field field.used =
   { skip$ }
   { format.title quote "title" output.check }
 if$
 format.address output
 howpublished output
 new.block
 fin.entry
}

FUNCTION {court_case}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 volume output
 source output
 firstpage output
 new.block
 %district missing$
 %  { skip$ }
 %  { "(" district * ")" * output }
 %if$
 fin.entry
 write.url
 empty.misc.check
}


FUNCTION {ICPSR}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 computerfileyear empty$
   { computerfile add.period$ output }
   { computerfile ", " * output
     computerfileyear output }
 if$
 number empty$
   { "[computer file]" add.period$ output }
   { "[computer file] (Study " number * ")." * output }
 if$
 "ICPSR version. " output
 produceraddress empty$
   { producer output }
   { produceraddress ": " * producer * output }
 if$
 produceryear empty$
   { "[producer]." output }
   { "[producer], " produceryear * add.period$ output }
 if$
 distributor empty$
   { "Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], " output }
   { distributoraddress empty$
       { distributor " [distributor], " * output }
       { distributoraddress ": " * distributor * output }
     if$ }
 if$
 distributoryear empty$
   { year output.nonnull }
   { distributoryear add.period$ output }
 if$
 %title.field field.used =
 %  { skip$ }
 %  { format.title quote "title" output.check }
 %if$
 new.block
 note output
 fin.entry
 write.url
}


FUNCTION {congressional}
{ %"U.S. Congress" author :=
 output.bibitem.congressional
 "U.S. Congress. " write$
 branch add.period$ " " * write$
 committee empty$
   {}
   { committee add.period$ " " * output }
 if$
 list.year output.nonnull
 new.block
 congress empty$
   {}
   { session empty$
     { congress "~Cong. " * output }
     { congress "~Cong.," * output
       session "~sess." * output }
     if$
   }
 if$
 note output
 fin.entry
 write.url
}



FUNCTION {inbook}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author empty$
   { editor "author and editor" item.check }
   { crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
     if$
   }
 if$
 title.field field.used =
   { skip$ }
   { format.btitle "title" output.check }
 if$
 new.block
 crossref missing$
   { format.bvolume output
     format.number.series output
     format.edition output
     format.address output
     publisher "publisher" output.check
   }
   { format.book.crossref output.nonnull
     format.edition output
   }
 if$
 format.chapter.pages "chapter and pages" output.check
 new.block
 fin.entry
 }

FUNCTION {incollection}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 title.field field.used =
   { skip$ }
   { format.title quote "title" output.check }
 if$
 author "author" item.check
 crossref missing$
   { format.in.ed.booktitle "booktitle" output.check
     new.block
     format.edition output
     format.bvolume output
     format.number.series output
     format.address output
     publisher "publisher" output.check
   }
   { format.incoll.inproc.crossref output.nonnull
   }
 if$
 format.chapter.pages output
 new.block
 fin.entry
}


FUNCTION {inproceedings}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 title.field field.used =
   { skip$ }
   { format.title quote "title" output.check }
 if$
 author "author" item.check
 crossref missing$
   { booktitle empty$
       { skip$ }
      {
         format.in.ed.booktitle "booktitle" output.check
         new.block
       }
     if$
     format.bvolume output
     format.number.series output
     address empty$
       { organization output
         publisher output
       }
       { organization output
             %format.address output.nonnull
                   ", " * address output.nonnull
         %publisher output
       }
     if$
   }
   { format.incoll.inproc.crossref output.nonnull
   }
 if$
 format.pages output
 new.block
 note output
 fin.entry
 %write.url
}




FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 title.field field.used =
   { skip$ }
   { format.btitle "title" output.check }
 if$
 new.block
 format.edition output
 new.block
 author empty$
   { organization empty$
	{ format.address output }
	'skip$
     if$
   }
   { format.address output
     organization output  
   }
 if$
 new.block
 fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author "author" item.check
 title.field field.used =
   { skip$ }
   { format.title "title" output.check }
 if$
 "Master's thesis" format.thesis.type output.nonnull
 school "school" output.check
 format.address output
 new.block
 fin.entry
}

FUNCTION {misc}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 title.field field.used =
   { skip$ }
   { format.title quote output }
 if$
 howpublished output
 new.block
 fin.entry
 empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author "author" item.check
 title.field field.used =
   { skip$ }
   { format.title quote "title" output.check } % { title "title" output.check }
 if$
 "Ph.D. diss." format.thesis.type output.nonnull % "PhD thesis" format.thesis.type output.nonnull
 school "school" output.check
 % format.address output
 new.block
 fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 title.field field.used =
   { skip$ }
   { format.btitle "title" output.check }
 if$
 new.block
 format.bvolume output
 format.number.series output
 address empty$
   { editor empty$
	{ skip$ }
	{ organization output
	}
     if$
     publisher output
   }
   { editor empty$
	'skip$
	{ organization output }
     if$
     format.address output.nonnull
     publisher output
   }
 if$
 new.block
 fin.entry
}

FUNCTION {techreport}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author "author" item.check
 title.field field.used =
   { skip$ }
   { format.title "title" output.check }
 if$
 format.tr.number output.nonnull
 institution "institution" output.check
 format.address output
 new.block
 fin.entry
}

%FUNCTION {unpublished}
%{ output.bibitem
%  list.label.output
%  list.year output.nonnull
%  new.block
%  author "author" item.check
%  title.field field.used =
%    { skip$ }
%    { format.title quote "title" output.check }
%  if$
%  fin.entry
%}

FUNCTION {unpublished}
{ output.bibitem
 list.label.output
 monthday empty$
   { list.year output.nonnull }
   { list.year " " * monthday * output.nonnull }
 if$
 new.block
 author "author" item.check
 title.field field.used =
   { skip$ }
   { format.title quote "title" output.check }
 if$
 note "note" output.check
 fin.entry
 new.block
 %write.url
}

FUNCTION {electronic}
{ output.bibitem
 list.label.output
 list.year output.nonnull
 new.block
 author empty$
   { editor "author and editor" item.check }
   { crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
     if$
   }
 if$
 title.field field.used =
   { skip$ }
   { format.btitle "title" output.check }
 if$  
 new.block
 author empty$
   { organization empty$
	{ format.address output }
	'skip$
     if$
   }
   { format.address output
     organization output  
   }
 if$
 "[Computer file]" output
 new.block
 fin.entry
}


FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
{"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

EXECUTE {init.field.constants}

FUNCTION {sortify}
{ purify$
 "l" change.case$
}

FUNCTION {sortify.names}
{ " \harvardand\ " " " replace.substring
 " et~al." " zzz" replace.substring
 sortify
}

FUNCTION {author.key.label}
{ author empty$
   { key empty$
	{ title.field 'field.used := }
	{ key.field 'field.used := }
     if$
   }
   { author.field 'field.used := }
 if$
}

FUNCTION {author.editor.key.label}
{ author empty$
   { editor empty$
	{ key empty$
	    { title.field 'field.used := }
	    { key.field 'field.used := }
	  if$
 	}
	{ editor.field 'field.used := }
     if$
   }
   { author.field 'field.used := }
 if$
}

FUNCTION {author.key.organization.label}
{ author empty$
   { key empty$
	{ organization empty$
	    { title.field 'field.used := }
	    { organization.field 'field.used := }
	  if$
	}
	{ key.field 'field.used := }
     if$
   }
   { author.field 'field.used := }
 if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
   { key empty$
	{ organization empty$
	    { title.field 'field.used := }
	    { organization.field 'field.used := }
	  if$
	}
	{ key.field 'field.used := }
     if$
   }
   { editor.field 'field.used := }
 if$
}

FUNCTION {sort.format.title}
{ 't :=
 "A " #2
   "An " #3
     "The " #4 t chop.word
   chop.word
 chop.word
 sortify
 #1 global.max$ substring$
}

FUNCTION {calc.label} %%%XXX change
{ make.abbr.label
 title.field field.used =
   { sort.format.title }
   { sortify.names }
 if$
 year field.or.null purify$ #-1 #4 substring$ sortify
 *
 'sort.label :=
}

FUNCTION {preliminaries} %%%XXX change
{ type$ "book" =
 type$ "inbook" =
 or
   'author.editor.key.label
   { type$ "proceedings" =
	'editor.key.organization.label
	{ type$ "manual" =
	    'author.key.organization.label
	    'author.key.label
	  if$
	}
     if$
   }
 if$
 author.field field.used = %%%XXX change
   {
     author num.names$ #2 >
       { #1 }
       { #0 }
     if$
     'etal.required :=
   }
   {
     editor.field field.used = 
       {
         editor num.names$ #2 >
           { #1 }
           { #0 }
         if$
       }
       { #0 }
     if$
     'etal.required :=
   }
 if$
 #1 'etal.allowed :=
}

FUNCTION {first.presort}
{ calc.label
 sort.label
 title.field field.used =
   { skip$ }
   { "    "
     *
     make.list.label sortify.names
     *
     "    "
     *
     title field.or.null
     sort.format.title
     *
   }
 if$
 #1 entry.max$ substring$
 'sort.key$ :=
}

ITERATE {preliminaries}

ITERATE {first.presort}

SORT

STRINGS { last.sort.label next.extra last.full.label}

INTEGERS { last.extra.num last.etal.allowed}

FUNCTION {initialize.confusion}
{ #0 int.to.chr$ 'last.sort.label :=
 #0 int.to.chr$ 'last.full.label :=
 #1 'last.etal.allowed :=
}

FUNCTION {confusion.pass}
{ last.sort.label sort.label =
   { last.etal.allowed 
       { last.full.label make.full.label sortify.names =
           { skip$ }
           { #0 'etal.allowed :=
             #0 'last.etal.allowed :=
           }
         if$
       }
       { #0 'etal.allowed := }
     if$
   }
   { sort.label 'last.sort.label :=
     make.full.label sortify.names 'last.full.label :=
     #1 'last.etal.allowed :=
   }
 if$
}

EXECUTE {initialize.confusion}

ITERATE {confusion.pass}

EXECUTE {initialize.confusion}

REVERSE {confusion.pass}

FUNCTION {initialize.last.extra.num}
{ #0 int.to.chr$ 'last.sort.label :=
 "" 'next.extra :=
 #0 'last.extra.num :=
}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
   { last.extra.num #1 + 'last.extra.num :=
     last.extra.num int.to.chr$ 'extra.label :=
   }
   { "a" chr.to.int$ 'last.extra.num :=
     "" 'extra.label :=
     sort.label 'last.sort.label :=
   }
 if$
}

FUNCTION {reverse.pass}
{ next.extra "b" =
   { "a" 'extra.label := }
   'skip$
 if$
 year empty$
   { "N.d." extra.label emphasize * 'list.year := }
   { year extra.label * 'list.year := }    % { year extra.label emphasize * 'list.year := }
 if$
 extra.label 'next.extra :=
}

ITERATE {first.presort}

SORT

EXECUTE {initialize.last.extra.num}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {second.presort}
{ make.list.label
 title.field field.used =
   { sort.format.title }
   { sortify.names }
 if$
 "    "
 *
 list.year field.or.null sortify
 *
 "    "
 *
 title.field field.used =
   { skip$ }
   { title field.or.null
     sort.format.title
     *
   }
 if$
 #1 entry.max$ substring$
 'sort.key$ :=
}

ITERATE {second.presort}

SORT

FUNCTION {begin.bib}
{ preamble$ empty$
   'skip$
   { "\harvardpreambledefs{%" write$ newline$
     preamble$ write$ "}" write$ newline$
     "\harvardpreambletext{%" write$ newline$
     preamble$ write$ "}" write$ newline$ }
 if$
 "\begin{thebibliography}{xx}" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
 "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}


