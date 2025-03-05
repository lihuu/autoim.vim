"""""""""""""""""""""""""""
"AutoIM
"""""""""""""""""""""""""""
let s:change_en_script_path = expand('<sfile>:p:h') . "/change_en.scpt"
let s:change_en_command = 'osascript ' . s:change_en_script_path
let s:change_ch_script_path = expand('<sfile>:p:h') . "/change_ch.scpt"
let s:change_ch_command = 'osascript ' . s:change_ch_script_path

function! AutoIM(event)
	if a:event == 'leave'
		let tmp = system(s:change_en_command)
	else " a:event == 'enter'
		let tmp = system(s:change_ch_command)
	end
endfunction

autocmd InsertEnter * call AutoIM("enter")
autocmd InsertLeave * call AutoIM("leave")
