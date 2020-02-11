.PHONY : book
book :
	Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

.PHONY : clean
clean :
	rm -rf docs/
	rm -rf _bookdown_files/
	Rscript -e "bookdown::clean_book()"
	Rscript -e "bookdown::clean_book(TRUE)"
	mv google_analytics.html google_analytics.bkup && rm -f *.html && mv google_analytics.bkup google_analytics.html
	mv README.md README.bkup && rm -f *.md && mv README.bkup README.md
	rm -f *.rds
	rm -f *.bak
