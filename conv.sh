function md2org
	for file in $argv
		set year (echo $file | cut -d- -f1)
		set date (echo $file | cut -d- -f1-3)
		set slug (echo $file | cut -d- -f4- | cut -d. -f1)

		mkdir -p ~/blog/articles/$year
		set f ~/blog/articles/$year/$slug.org

		echo "#+"(grep -m 1 '^title:' $file) > $f
		echo "#+date: $date" >> $f

		if set abstract (grep -m 1 '^abstract:' $file)
			set abstract (echo $abstract | sed 's/abstract: //')
			echo "#+begin_abstract" >> $f
			echo $abstract >> $f
			echo "#+end_abstract" >> $f
		end

		if set tags (grep -m 1 '^tags:' $file)
			set tags (sed 's/tags: //' | tr -d '[,]')
			for tag in $tags
				echo "#+index: $tag" >> $f
			end
		end

		echo >> $f

		sed '/^---$/,/^---$/d' $file \
		| pandoc --no-highlight \
		-f markdown+backtick_code_blocks+fenced_code_attributes \
		-t org \
		>> $f

		echo $year -- $date -- $slug
	end
end
