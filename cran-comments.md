## Test environments
* local R installation, R 4.4.1
* ubuntu 22.04 (on R-hub), R-devel
* windows (on R-hub), R-devel
* macos (on R-hub), R-devel

## Resubmission

I received the following comment from CRAN in my previous submission:.

> Please proofread your DESCRIPTION.
> It currently reads: "... it convert to Julian Day Number."
> I believe it should be: "...it converts to the Julian Day Number."

Fixed it.

> If there are references describing the methods in your package, please
> add these in the description field of your DESCRIPTION file in the form
> authors (year) <doi:...>
> authors (year, ISBN:...)
> or if those are not available: <https:...>
> with no space after 'doi:', 'https:' and angle brackets for
> auto-linking. (If you want to add a title as well please put it in
> quotes: "Title")

Fixed it. 
As pointed out, I corrected it so that the DOI notation comes after the author's name and the year of publication.
For references where I could only find the BibCode without ISBN or DOI, I included the BibCode and a link where the full text is listed.

> Please add \value to .Rd files regarding exported methods and explain
> the functions results in the documentation. Please write about the
> structure of the output (class) and also what the output means. (If a
> function does not return a value, please document that too, e.g.
> \value{No return value, called for side effects} or similar)
> Missing Rd-tags:
>       jcalendaR-utils.Rd: \value
>       jdn.Rd: \value

Fixed and Added it.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

* The following words are suspected to be misspelled, but they are not. Kyureki and Wareki are proper nouns in Japanese.

```
Possibly misspelled words in DESCRIPTION:
  Interconversion (3:8)
  Kyureki (8:185)
  Wareki (8:135)
```
