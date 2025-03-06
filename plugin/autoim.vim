"""""""""""""""""""""""""""
"AutoIM
"""""""""""""""""""""""""""
vim9script

# Define path variables for AppleScript files
const change_en_script_path = expand('<sfile>:p:h') .. "/change_en.scpt"
const change_en_command = 'osascript ' .. change_en_script_path
const change_ch_script_path = expand('<sfile>:p:h') .. "/change_ch.scpt"
const change_ch_command = 'osascript ' .. change_ch_script_path

# Function to switch input method based on event
def AutoIM(event: string)
  if event == 'leave'
    system(change_en_command)
  else # event == 'enter'
    system(change_ch_command)
  endif
enddef

# Set up autocmds for switching input method
augroup AutoIM
  autocmd!
  autocmd InsertEnter * AutoIM("enter")
  autocmd InsertLeave * AutoIM("leave")
augroup END
