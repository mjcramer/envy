# Defined in - @ line 1
function search --description "Search code files for matching regex" 
	find $argv[1] -type f -exec grep -EHIn --color=auto $argv[2] {} \;
end
