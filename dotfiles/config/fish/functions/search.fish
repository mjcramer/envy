# Defined in - @ line 1
function search --description "Search code files for matching regex" 
	find $argv[1] -type f \
		\( -iname '*.scala' -o -iname '*.sbt' -o -iname '*.py' \) \
		-exec grep -Hn $argv[2] {} \;
end
