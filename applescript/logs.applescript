#!/usr/bin/osascript

launch "iTerm"

tell application "iTerm"
	activate
	
	set myterm to (make new terminal)
	tell myterm
		set number of columns to 233
		set number of rows to 66
		launch session "Logs"
		tell the last session
			write text "unset PROMPT_COMMAND"
			write text "tail -f -n 100 /usr/local/var/log/mysql/mysql-general.log"
			set name to "MySQL Logs"
		end tell
		launch session "Logs"
		tell the last session
			write text "unset PROMPT_COMMAND"
			write text "tail -f -n 100 /usr/local/var/log/redis.log"
			set name to "Redis Logs"
		end tell
		launch session "Logs"
		tell the last session
			write text "unset PROMPT_COMMAND"
			write text "tail -f -n 100 /usr/local/var/log/kestrel/kestrel.log"
			set name to "Kestrel Logs"
		end tell
	end tell
end tell