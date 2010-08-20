"note: this plugin needs python feature
"(ie. +python and +python3 or +python/dyn and +python3/dyn)

"Commands: 
"        :Spydoc object 
"         the "object" can be an "imported" class, module or function(/method) 
"         the command return document string corresponding to the object. 
"         else return type of the object. 
"         if the object is "unimported" the command will fail except for 
"         modules re, and FunctionType, MethodType, ModuleType, BuiltinFunctionType, 
"         BuiltinMethodType imported from module types 
"        :SpydocSV version 
"         switch version of python for current buffer(ie. dont affect other buffers) 
"         py is python2.x, py3 is python3.x 
"         else any other string, return current version. 

"Options: 
"        g:showpydoc_selected_version(default is "py") 
"        the default version of python to use when open a new buffer. 
"        and then you can use PydocSV to switch this buffer. 


"Tip:     
"        the plugin is just designed for python stardand library. 
"        if try the command with a user-defined "object", 
"        be likely to get an error "name 'object' is not defined". 

"Examples:   
"        lets say a simple python script: 
"          import sys; 
"          form sys import path; 
"          import httplib; 
"          import http.client; 
"          class Test(object): pass; 
"          t = Test(); 
"        and input following commands: 

"          :SpydocSV ver 
"           current python version is: py 

"          :Spydoc sys 
"           sys document(module) 

"          :Spydoc sys.exit 
"           sys.exit document(function) 

"          :Spydoc sys.path 
"           type of sys.path(built-in type list) 

"          :Spydoc path 
"           type of os.path(same as above) 

"          :Spydoc http.client 
"           error: name 'http' is not define 
"          :SpydocSV py3 
"          :Spydoc http.client 
"           http.client doc 

"          :Spydoc httplib 
"           error: name 'httplib' is not define 
"          :SpydocSV py 
"          :Spydoc httplib 
"           httplib doc 

"          :Spydoc Test: 
"           error: name 'Test' is not define 
"          :Spydoc t: 
"           error: name 't' is not define 
"          :Spydoc sys.ss 
"           error: 'module' object has no attribute 'ss' 
"          :Spydoc sys.exit() 
"           error: 'sys.exit()' is a wrong? 
"  
"Install details 
"                make sure "filetype plugin on" 
"                copy python_showpydoc.vim and ShowPyDoc_PSD117.py to your ftplugin
 

if exists("s:has_init")
   call s:SelectPyVersion(g:showpydoc_selected_version) 
   finish
endif

let s:has_init = 1
let $PYTHONPATH = $PYTHONPATH.";".$HOME."/vimfiles/ftplugin".";".$VIM."/vimfiles/ftplugin".";"
if !exists("g:showpydoc_selected_version")
    let g:showpydoc_selected_version = "py"
endif

function! s:DefPythonImport()
py << EOF
import vim;
from ShowPyDoc_PSD117 import PythonDoc_PSD117, main_PSD117;
EOF
endfunction
function! s:DefPython3Import()
py3 << EOF
import vim;
from ShowPyDoc_PSD117 import PythonDoc_PSD117, main_PSD117;
EOF
endfunction
call s:DefPythonImport()
call s:DefPython3Import()

function! s:DefPythonGetDoc(objStr)
py << EOF

objStr_PSD117 = vim.eval("a:objStr");
code = vim.current.buffer[:];
code = "\n".join(code);
main_PSD117(code, objStr_PSD117);

EOF
endfunction

function! s:DefPython3GetDoc(objStr)
py3 << EOF

objStr_PSD117 = vim.eval("a:objStr");
code = vim.current.buffer[:];
code = "\n".join(code);
main_PSD117(code, objStr_PSD117);

EOF
endfunction

function! s:SelectPyVersion(ver)
    if(a:ver == "py")
        let b:spydoc_selected_version = "py"
    elseif(a:ver == "py3")
        let b:spydoc_selected_version = "py3"
    else
        echo "current python version is:" b:spydoc_selected_version
    endif
endfunction

function! s:GetPyDoc(objStr)
    if b:spydoc_selected_version == "py"
        call s:DefPythonGetDoc(a:objStr)
    elseif b:spydoc_selected_version == "py3"
        call s:DefPython3GetDoc(a:objStr)
    endif
endfunction

call s:SelectPyVersion(g:showpydoc_selected_version)
command! -nargs=1 Spydoc :call s:GetPyDoc(<f-args>)
command! -nargs=1 SpydocSV :call s:SelectPyVersion(<f-args>)
