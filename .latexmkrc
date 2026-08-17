# Latexmk defaults for all TeX projects
$pdf_mode = 1;                   # build PDF
$synctex = 1;                    # forward/inverse search
$interaction = "nonstopmode";    # don't stop on errors
$aux_dir = "build";
$out_dir = "build";
$cleanup_includes_generated = 1;
# By default latexmk cd's into $aux_dir to run bibtex, which breaks
# \bibliography{../../biblio.bib} style relative paths (they end up resolved
# one level too high). Run bibtex from the document dir instead.
$bibtex_fudge = 0;
$pdflatex = 'pdflatex -file-line-error -shell-escape %O %S';
