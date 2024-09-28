#!/usr/bin/env expect
set PATH_TO_UMS [lindex $argv 0]

spawn "${PATH_TO_UMS}" --nox11
set timeout -1
expect "Welcome"
send -- "\r"
expect "EULA"
send -- "\r"
expect "Database backup"
# Right arrow key
send -- "OC"
send -- "\r"
expect "Installation type"
send -- "\r"
expect "UMS Web App"
send -- "\r"
expect "system requirements"
send -- "\r"
expect "Shortcuts"
send -- "\r"
expect "Installation summary"
send -- "\r"
expect {
	"Information" {
		send -- "\r"
		exp_continue
	}
	"Success" {
		send -- "\r"
	}
}
expect eof
