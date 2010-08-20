import re;
from types import FunctionType;
from types import MethodType;
from types import ModuleType;
from types import BuiltinFunctionType;
from types import BuiltinMethodType;

class PythonDoc_PSD117(object):

    class DocStringError(Exception):
        def __init__(self, value):
            self.value = value;
        def __str__(self):
            return repr(self.value);
    
    class OldClassForPy2x: pass;
    _re_find_import = r"\s+(from\s+[\w_\.]+[\s]*import\s+[\w_\.\*]+)|\s+(import\s+[\w_\.]+)";
    _AcpTypes = (FunctionType, MethodType, ModuleType, BuiltinFunctionType, BuiltinMethodType, type, type(OldClassForPy2x)); 

    def __init__(self, code = ""):
        self._code = code;
        self._imports = [];
        self._docString = "";

    def _ExtractImports_PSD117(self):
        imports = re.findall(PythonDoc_PSD117._re_find_import, self._code);
        for i in imports:
           self._imports += ["".join(i)];

    def GetDocString_PSD117(self, objStr_PSD117):
        self._ExtractImports_PSD117();
        for i in self._imports:
            try: exec(i);
            except(ImportError, SyntaxError): pass;

        try:
            obj_PSD117 = eval(objStr_PSD117);
        except(NameError, AttributeError, SyntaxError, BaseException, Exception) as e:
            if(isinstance(e, (NameError, AttributeError, SyntaxError))):
                errMsg = str(e);
            else:
                errMsg = repr(objStr_PSD117) + " its a wrong?";
            raise PythonDoc_PSD117.DocStringError(errMsg);

        if(isinstance(obj_PSD117, PythonDoc_PSD117._AcpTypes)):
            self._docString += str(obj_PSD117.__doc__);
        else:
            self._docString = objStr_PSD117 + " is an instance of " + str(type(obj_PSD117));
        return self._docString;

def main_PSD117(code, objStr):

    pd = PythonDoc_PSD117(code);
    try:
        s = objStr + "->>>\n" + pd.GetDocString_PSD117(objStr);
        print(s);
    except(PythonDoc_PSD117.DocStringError) as e:
        print("error: " + e.value);
