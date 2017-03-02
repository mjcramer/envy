read -r -d '' VAR <<-'EOF'
	abc'asdf"
	$(dont-execute-this)
	foo"bar"''
EOF

echo "$VAR"
