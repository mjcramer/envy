# Defined in - @ line 1
function search --description "Search code files for matching regex" 
	find $argv[1] -type f -exec grep -EHIn $argv[2] {} \;
end
