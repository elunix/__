public variable INSTALLATION = 1;  % required

private variable vers_int = _slang_version;
private variable min_compat = 20301;
private variable min_compat_str = "pre2.3.1-";
private variable min_patchlevel = 85;
private variable max_compat = 20302;
private variable max_compat_str = "2.3.2";
private variable max_patchlevel = 0;
private variable prequis = [
     "PREQUISITIES: (usually the -devel packages)",
     "",
     "  pcre libs and headers",
     "  ssl libs and headers (can also be libressl, tested on Void Linux)",
     "  curl libs and headers",
     "  git"];

if (any ("--help" == __argv or  "-h" == __argv))
  {
  () = array_map (Integer_Type, &fprintf, stderr, "%s\n",
    [
     "INSTALLATION OPTIONS:",
     "",
     "  -v|--verbose   be verbose",
     "  --no-color     don't colorize the output",
     "  --debug        compile modules with debug flags",
     "  --no-x         don't compile X code (xlib headers and libs are required)",
     "  --compile=no   don't compile modules (usefull _only_ at later installations)",
     "  -W|--warnings  enable warnings (some checks for executables)",
     "",
     prequis,
     "",
     "NOTE:",
     "This application targets S-Lang development tree and uses its latest features",
     "  git://git.jedsoft.org/git/slang.git",
     "because of that, there few chances to work with formal S-Lang releases,",
     "that might also lack fixes from slang development",
     "",
     "Last working minimum slang version: " + min_compat_str + string (min_patchlevel),
     "Last working maximum slang version: " + max_compat_str + string (max_patchlevel)
    ]);

  exit (0);
  }

private variable slang_instr =
strjoin ("# " + prequis, "\n") + `

git clone git://git.jedsoft.org/git/slang.git && \
cd slang                                      && \
./configure && make && sudo make install      && \
sudo ldconfig -v`;

ifnot (min_compat <= vers_int)
  {
  () = fprintf (stderr, "your slang version (%s) is old and not compatible\n%s\n\n%s\n%s\n",
     _slang_version_string,
     "slang atleast patchlevel " + min_compat_str + string (min_patchlevel) +" is required",
     "to install slang issue:", slang_instr);
  exit (1);
  }

if (min_compat == vers_int)
  ifnot (strncmp (_slang_version_string, min_compat_str, strlen (min_compat_str)))
    if (atoi (_slang_version_string[[strlen (min_compat_str):]]) < min_patchlevel)
      {
      () = fprintf (stderr, "your slang version (%s) is old and not compatible\n%s\n\n%s\n%s\n",
        _slang_version_string,
        "S-Lang atleast patchlevel " + min_compat_str + string (min_patchlevel) + " is required",
        "to install slang issue:", slang_instr);
      exit (1);
      }

if (max_compat < vers_int)
  {
  () = fprintf (stderr, "your slang (%s) version is new and not compatible\n%s\n",
     _slang_version_string,
     "slang minimum version: " + max_compat_str + string (max_patchlevel));
  exit (1);
  }

public variable DEBUG = any ("--debug" == __argv);

public variable OSNAME  = uname.sysname;
public variable MACHINE = uname.machine;

private variable SRC_PATH =
  (SRC_PATH = path_concat (getcwd (), path_dirname (__FILE__)),
    SRC_PATH[[-2:]] == "/."
      ? substr (SRC_PATH, 1, strlen (SRC_PATH) - 2)
      : SRC_PATH);
private variable
  SRC_C_PATH = SRC_PATH + "/C",
  SRC_MODULE_PATH = SRC_C_PATH + "/slang-modules",
  SRC_INTER_PATH  = SRC_C_PATH + "/interp",
  SRC_TMP_PATH = SRC_PATH + "/tmp",
  WARNINGS = any ("--warnings" == __argv or "-W" == __argv),
  VERBOSE = any ("--verbose" == __argv or "-v" == __argv),
  NOCOLOR = any ("--no-color" == __argv),
  X = [1, 0][any ("--no-x" == __argv)],
  DONT_COMPILE_MODULES = any ("--compile=no" == __argv),
  OUTCOLOR = NOCOLOR ? "" : "\e[37m",
  ERRCOLOR = NOCOLOR ? "" : "\e[31m",
  ESCCOLOR = NOCOLOR ? "" : "\e[m",
  CC = "gcc";

private variable REQ_EXECUTABLES = ["sudo"];
private variable IMP_EXECUTABLES = ["diff", "git", "patch"];
private variable  OPT_EXECUTABLES = [
  "mplayer", "tar", "unzip", "xz", "bzip2", "gzip", "ps", "ip", "iw",
  "wpa_supplicant", "dhcpcd", "ping", "xinit", "xauth", "urxvtd",
  "setxkbmap", "xmodmap", "mcookie", "amixer", "cc", "groff", "col",
  "mount", "umount", "findmnt", "file"];
private variable MODULES = [
  "__", "getkey", "crypto", "curl", "slsmg", "socket", "fork", "pcre", "rand",
  "iconv", "json", "taglib", "fd", "hunspell", "tcc"];
private variable FLAGS = [
  "-lm -lpam", "", "-lssl", "-lcurl", "", "", "", "-lpcre", "", "", "",
  "-ltag_c", "", "-lhunspell-1.6", "-ltcc"];
private variable DEF_FLAGS =
  "-I" + SRC_C_PATH + "/include -I../../include -I/usr/local/include -g -O2 -Wl,-R/usr/local/lib --shared -fPIC";
private variable DEB_FLAGS =
  "-Wall -Wformat=2 -W -Wunused -Wundef -pedantic -Wno-long-long\
 -Winline -Wmissing-prototypes -Wnested-externs -Wpointer-arith\
 -Wcast-align -Wshadow -Wstrict-prototypes -Wextra -Wc++-compat\
 -Wlogical-op";
private variable MODULES_THAT_DONT_EXIT_ON_ERR = ["taglib", "hunspell", "tcc"];
private variable MODULES_THAT_FAILED = String_Type[0];
private variable CLASSES = [
  "Api",  "Input",  "Smg",   "Rand",  "Crypt", "Os",
  "Opt",  "String", "Rline", "Proc",  "Sock",  "Subst",
  "Sync", "Devel",  "Spell", "Ved",   "Curl",  "Json",
  "Time", "Scm",    "App",   "Com",   "Hw",    "Net",
  ];

if (X)
  {
  MODULES = [MODULES, "xsrv", "xclient", "xsel"];
  FLAGS = [FLAGS, "-lX11", "-lX11 -lXtst", "-lX11"];
  CLASSES = [CLASSES, "Xsrv", "Xclnt"];
  }

private variable THESE = Assoc_Type[String_Type];

THESE["__me__"] = `public variable This = This->__INIT__ ("__INSTALL__";` +
    `name = "__INSTALL__", shell = 0, smg = 0, ved = 0, err_handler = NULL, at_exit = NULL, exit = NULL);`;

THESE["__"] = `public variable This = This->__INIT__ ("__");`;

THESE["__COMMAND__"] = `public variable This = This->__INIT__ ("__COMMAND__";` +
    `shell = 0, smg = 0, ved = 0);`;

THESE["__APP__"] =
`public variable This = __init_this;
`;

public variable io;

private define __exit_me__ (self, msg, code)
{
  self.at_exit ();

  ifnot (NULL == msg)
    (@(code ? io.tostderr : io.tostdout)) (io, msg);

  exit (code);
}

private define __at_exit__ (self)
{
}

public variable This = struct {exit = &__exit_me__, at_exit = &__at_exit__};

private define __sigint_handler__ (sig)
{
  This.exit ("process interrupted by the user", 130);
}

signal (SIGINT, &__sigint_handler__);

%public variable APP_ERR, App;

public define send_msg_dr ();

private define __err_handler__ (self, s)
{
  self.exit (NULL, 1);
}

public define __use_namespace (ns)
{
  try
    use_namespace (ns);
  catch NamespaceError:
    {
    eval (`sleep (0.0001);`, ns);
    use_namespace (ns);
    }
}

define is_type (st, type)
{
  NULL == st ? 0 : stat_is (type, st.st_mode);
}

define isdirectory (dir)
{
  if (-1 == access (dir, F_OK))
    return 0;

  is_type (stat_file (dir), "dir");
}

define which (exec)
{
  variable
    ar,
    path = getenv ("PATH");

  if (NULL == path)
    return NULL;

  path = strchop (path, path_get_delimiter, 0);
  path = array_map (String_Type, &path_concat, path, exec);
  path = path[wherenot (array_map (Integer_Type, &isdirectory, path))];
  ar = wherenot (array_map (Integer_Type, &access, path, X_OK));

  length (ar) ? path[ar][0] : NULL;
}

variable OBJDUMP_BIN = which ("objdump");
variable LD_LIBRARY_PATH = ["/usr/local/lib", "/lib", "/usr/lib", NULL, NULL];

if (MACHINE == "x86_64")
  {
  LD_LIBRARY_PATH[-2] = "/lib64";
  LD_LIBRARY_PATH[-1] = "/usr/lib64";
  }

LD_LIBRARY_PATH = LD_LIBRARY_PATH[wherenot (_isnull (LD_LIBRARY_PATH))];

define __init_lib_path__ ()
{
  variable i, st;
  _for i (0, length (LD_LIBRARY_PATH) - 1)
    if (NULL == (st = lstat_file (LD_LIBRARY_PATH[i]), st) ||
        stat_is ("lnk", st.st_mode))
      LD_LIBRARY_PATH[i] = NULL;

  LD_LIBRARY_PATH = LD_LIBRARY_PATH[wherenot (_isnull (LD_LIBRARY_PATH))];
}

define obj_depends (obj)
{
  if (NULL == OBJDUMP_BIN)
    return NULL;

  variable fp = popen (OBJDUMP_BIN + " --private-headers " + obj, "r");
  if (NULL == fp)
    return NULL;

  variable objs = fgetslines (fp);
  variable i;
  variable pat = "NEEDED";

  _for i (0, length (objs) - 1)
    ifnot (string_match (objs[i], pat))
      objs[i] = NULL;
    else
      objs[i] = strtok (objs[i])[1];

  objs = objs[wherenot (_isnull (objs))];

  variable
    ar = String_Type[0],
    b = Char_Type[length (objs)];

   _for i (0, length (LD_LIBRARY_PATH) - 1)
     ar = [ar, strtrim_end (LD_LIBRARY_PATH[i], "/") + "/" +
       listdir (LD_LIBRARY_PATH[i])];

  variable ii;
  _for i (0, length (objs) - 1)
     {
     pat = objs[i];
     _for ii (0, length (ar) - 1)
       if (string_match (ar[ii], pat))
         {
         b[i] = 1;
         objs[i] += " => " + ar[ii];
         break;
         }
       }

  objs[wherenot (b)] += " => not found";
  objs;
}

define is_obj_depends_on (obj, lib)
{
  variable shared = qualifier ("libs", obj_depends (obj));
  if (NULL == shared)
    return -1;

  variable pat = "^lib" + lib + "\\.so\\.\\d?";
  variable i;
  _for i (0, length (shared) - 1)
    if (string_match (shared[i], pat))
     return 1;

  0;
}

define find_lib (lib)
{
  variable
    i, ii, ar, path,
    pat = "/lib" + lib + "\\.so\\.\\d?";

  _for i (0, length (LD_LIBRARY_PATH) - 1)
    {
    path = strtrim_end (LD_LIBRARY_PATH[i], "/") + "/";
    ar = path + listdir (path);

    _for ii (0, length (ar) - 1)
      if (string_match (ar[ii], pat))
        return ar[ii];
    }

  NULL;
}

__init_lib_path__;

__use_namespace ("io");

private variable iofp, ioclr, ioargs;

private define ioproc ()
{
  if (1 == length (ioargs) && typeof (ioargs[0]) == Array_Type &&
    any ([String_Type, Integer_Type, UInteger_Type, Char_Type] == _typeof (ioargs[0])))
    {
    ioargs = ioargs[0];

    () = array_map (Integer_Type, &fprintf, iofp, "%s%S%S%s", ioclr, ioargs,
      qualifier_exists ("n") ? "" : "\n", ESCCOLOR);

    return;
    }

  variable fmt = "%S";
  if (length (ioargs))
    loop (length (ioargs)) fmt += "%S ";

  fmt += ESCCOLOR + "%S";

  () = fprintf (stdout, fmt, ioclr, __push_list (ioargs),
       qualifier_exists ("n") ? "" : "\n");
}

private define __tostdout__ ()
{
  iofp = stdout;
  ioclr = OUTCOLOR;
  ioargs = __pop_list (_NARGS - 1);
  pop;
  ioproc (;;__qualifiers);
}

private define __tostderr__ ()
{
  iofp = stderr;
  ioclr = ERRCOLOR;
  ioargs = __pop_list (_NARGS - 1);
  pop;
  ioproc (;;__qualifiers);
}

public variable io = struct {tostdout = &__tostdout__, tostderr = &__tostderr__};

__use_namespace ("Exc");

private define isnot_an_exception (e)
{
  NULL == e || Struct_Type != typeof (e) ||
  NULL == wherefirst (get_struct_field_names (e) == "object") ||
  8 != length (get_struct_field_names (e));
}

private define __format_exc__ (self, e)
{
  if (NULL == e)
    e = __get_exception_info;

  if (isnot_an_exception (e))
    e = struct {error = 0, description = "", file = "", line = 0, function = "", object, message = "",
    Exception = "No exception in the stack"};

  strchop (sprintf ("Exception: %s\n\
Message:     %s\n\
Object:      %S\n\
Function:    %s\n\
Line:        %d\n\
File:        %s\n\
Description: %s\n\
Error:       %d",
    _push_struct_field_values (e)), '\n', 0);
}

private define __print_exc__ (self, e)
{
  if (0 == isnot_an_exception (e) ||
     (0 == (e = __get_exception_info, isnot_an_exception (e))))
    io.tostderr (self.fmt (e));

  while (isnot_an_exception (e) == 0 == isnot_an_exception (e.object))
    {
    io.tostderr (self.fmt (e.object));
    e = e.object;
    }
}

public variable Exc = struct {print = &__print_exc__, fmt = &__format_exc__};

__use_namespace ("Install");

if (-1 == chdir (SRC_PATH))
  This.exit (sprintf ("%s, couldn't change directory: %s\n",
    SRC_PATH, errno_string (errno)), 1);

ifnot (access (SRC_TMP_PATH, F_OK))
  if (0 == stat_is ("dir", stat_file (SRC_TMP_PATH).st_mode))
    This.exit (SRC_TMP_PATH + " is not a directory", 1);
  else
    if (-1 == access (SRC_TMP_PATH, R_OK|W_OK))
      This.exit (SRC_TMP_PATH +  " is not writable", 1);
    else ();
else
  if (-1 == mkdir (SRC_TMP_PATH))
    This.exit ("cannot create directory " + SRC_TMP_PATH + "\n" +
      errno_string (errno), 1);

private define readfile (fname)
{
  if (-1 == access (fname, F_OK|R_OK))
    This.exit (sprintf ("IO_Read_Error::read, %S, %s", fname, errno_string (errno)), 1);

  variable fd = open (fname, O_RDONLY);

  if (NULL == fd)
    This.exit (sprintf ("IO::read file descriptor: %S", errno_string (errno)), 1);

  variable buf;
  variable str = "";

  () = lseek (fd, qualifier ("offset", 0), qualifier ("seek_pos", SEEK_SET));

  while (read (fd, &buf, 4096) > 0)
    str += buf;

  str;
}

private define writefile (__fn__, __buf__)
{
  variable fd = open (__fn__, O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);

  if (NULL == fd)
    This.exit ("failed to write to " + __fn__ + ", " + errno_string (errno), 1);

  if (-1 == write (fd, __buf__))
    This.exit ("failed to write to " + __fn__ + ", " + errno_string (errno), 1);

  if (-1 == close (fd))
    This.exit ("failed to close fd, while writing to " + __fn__ + ", " + errno_string (errno), 1);
}

private define __compile_module__ (__dir__, __module__)
{
  variable
    CC_COM = CC + " " + __dir__ + "/" + __module__  + " " +
      DEF_FLAGS + " " + (DEBUG ? DEB_FLAGS : "") + " " + " -o " +
      SRC_TMP_PATH + "/" + path_basename_sans_extname (__module__) + ".so";

  if (VERBOSE)
    io.tostdout ("compiling " + __module__);

  if (system (CC_COM))
    This.exit ("failed to compile " + __module__, 1);
}

private define __build_module__ (i)
{
  variable
    CC_COM = CC + " " +
      SRC_MODULE_PATH + "/" +  MODULES[i] + "/" + MODULES[i] + "-module.c " +
      DEF_FLAGS + " " + (DEBUG ? DEB_FLAGS : "") + " -o " +
      SRC_TMP_PATH + "/" + MODULES[i] + "-module.so " + FLAGS[i];

  if (VERBOSE)
    io.tostdout ("compiling " + MODULES[i] + "-module.c");

  if (system (CC_COM))
    ifnot (any (MODULES[i] == MODULES_THAT_DONT_EXIT_ON_ERR))
      This.exit ("failed to compile " + MODULES[i], 1);
    else
      {
      MODULES_THAT_FAILED = [MODULES_THAT_FAILED, MODULES[i]];
      io.tostderr ("failed to compile " + MODULES[i] +
        " module, but which is not a requirenment");
      }
}

__build_module__ (0);

% some libraries, like libcurl can be linked against a dozen of libraries,
% like nghttp2 and ssh2 in this case - 
% try to catch those

define __init_flags__ ()
{
  variable curl_l = find_lib ("curl");
  if (NULL == curl_l)
    This.exit ("libcurl is not installed");

  variable idx = wherefirst (MODULES == "curl");
  variable curl_libs = obj_depends (curl_l);
  variable libs = ["nghttp2", "ssh2", "ssl"];
  variable i;

  _for i (0, length (libs) - 1)
    if (is_obj_depends_on (curl_l, libs[i];libs = curl_libs))
      FLAGS[idx] += " -l" + libs[i];
}

__init_flags__;

ifnot (DONT_COMPILE_MODULES)
  {
  __build_module__ (1);
  __build_module__ (2);
  __build_module__ (3);
  }

import (SRC_TMP_PATH + "/__", "Global");

__WNsize ();

SRC_PATH       = realpath (SRC_PATH);
SRC_TMP_PATH   = realpath (SRC_TMP_PATH);

private variable
  ROOT_PATH      = realpath (SRC_PATH + "/.."),
  STD_PATH       = ROOT_PATH + "/std",
  TMP_PATH       = ROOT_PATH + "/tmp",
  BIN_PATH       = ROOT_PATH + "/bin",
  USER_PATH      = ROOT_PATH + "/usr",
  LOCAL_PATH     = ROOT_PATH + "/local";

private variable
  STD_CLASS_PATH = STD_PATH + "/__",
  STD_LIB_PATH   = STD_PATH + "/___",
  STD_C_PATH     = STD_PATH + "/C",
  STD_CMACH_PATH = STD_C_PATH + "/" + MACHINE,
  STD_MODULE_PATH= STD_CMACH_PATH + "/slang-modules",
  STD_CLIB_PATH  = STD_CMACH_PATH + "/lib",
  STD_CINC_PATH  = STD_CMACH_PATH + "/include",
  STD_CSHARE_PATH= STD_CMACH_PATH + "/share",
  STD_CBIN_PATH  = STD_CMACH_PATH + "/bin",
  STD_APP_PATH   = STD_PATH + "/app",
  STD_COM_PATH   = STD_PATH + "/com",
  STD_DATA_PATH  = STD_PATH + "/data";

private variable
  SRC_PROTO_PATH = SRC_PATH + "/_",
  SRC_CLASS_PATH = SRC_PATH + "/__",
  SRC_LIB_PATH   = SRC_PATH + "/___",
  SRC_C_PATH     = SRC_PATH + "/C",
  SRC_APP_PATH   = SRC_PATH + "/app",
  SRC_COM_PATH   = SRC_PATH + "/com",
  SRC_DATA_PATH  = SRC_PATH + "/data";

private variable
  USER_COM_PATH    = USER_PATH + "/com",
  USER_APP_PATH    = USER_PATH + "/app",
  USER_LIB_PATH    = USER_PATH + "/___",
  USER_CLS_PATH    = USER_PATH + "/__",
  USER_DATA_PATH   = USER_PATH + "/data",
  USER_C_PATH      = USER_PATH + "/C",
  USER_CMACH_PATH  = USER_C_PATH + "/" + MACHINE,
  USER_CLIB_PATH   = USER_CMACH_PATH + "/lib",
  USER_CBIN_PATH   = USER_CMACH_PATH + "/bin",
  USER_CSHARE_PATH = USER_CMACH_PATH + "/share",
  USER_CINC_PATH   = USER_CMACH_PATH + "/include",
  USER_MODULE_PATH = USER_CMACH_PATH + "/slang-modules";

private variable
  SRC_USER_PATH        = SRC_PATH + "/usr",
  SRC_USER_COM_PATH    = SRC_USER_PATH + "/com",
  SRC_USER_APP_PATH    = SRC_USER_PATH + "/app",
  SRC_USER_LIB_PATH    = SRC_USER_PATH + "/___",
  SRC_USER_CLASS_PATH  = SRC_USER_PATH + "/__",
  SRC_USER_C_PATH      = SRC_USER_PATH + "/C",
  SRC_USER_MODULE_PATH = SRC_USER_PATH + "/C/" + MACHINE + "/slang-modules",
  SRC_USER_DATA_PATH   = SRC_USER_PATH + "/data";

private variable
  LOCAL_COM_PATH       = LOCAL_PATH + "/com",
  LOCAL_APP_PATH       = LOCAL_PATH + "/app",
  LOCAL_CLASS_PATH     = LOCAL_PATH + "/__",
  LOCAL_LIB_PATH       = LOCAL_PATH + "/___";

private variable
  SRC_LOCAL_PATH       = SRC_PATH + "/local",
  SRC_LOCAL_COM_PATH   = SRC_LOCAL_PATH + "/com",
  SRC_LOCAL_APP_PATH   = SRC_LOCAL_PATH + "/app",
  SRC_LOCAL_CLASS_PATH = SRC_LOCAL_PATH + "/__",
  SRC_LOCAL_LIB_PATH   = SRC_LOCAL_PATH + "/___";

private variable INST_PATHS = [
  ROOT_PATH, STD_PATH, TMP_PATH, BIN_PATH, USER_PATH,
  USER_APP_PATH, USER_COM_PATH, USER_CLS_PATH, USER_DATA_PATH, USER_LIB_PATH,
  USER_C_PATH, USER_CMACH_PATH, USER_CLIB_PATH, USER_MODULE_PATH, USER_CINC_PATH,
  USER_CSHARE_PATH, USER_CBIN_PATH,
  STD_C_PATH, STD_CMACH_PATH, STD_MODULE_PATH, STD_CLIB_PATH, STD_CINC_PATH,
  STD_CSHARE_PATH, STD_CBIN_PATH,
  STD_CLASS_PATH, STD_DATA_PATH, STD_APP_PATH, STD_COM_PATH, STD_LIB_PATH,
  LOCAL_PATH, LOCAL_COM_PATH, LOCAL_APP_PATH, LOCAL_CLASS_PATH, LOCAL_LIB_PATH];

private variable SLSH_BIN = BIN_PATH + "/__slsh_" + MACHINE;
private variable SLSH_LNK = BIN_PATH + "/__slsh";

private define __eval__ (__buf__)
{
  try
    eval (__buf__);
  catch AnyError:
    {
    __buf__ = strchop (__buf__, '\n', 0);

    io.tostderr (strjoin (array_map (String_Type, &sprintf, "%d| %s",
      [1:length (__buf__)], __buf__), "\n"));

    Exc.print (__get_exception_info);
    This.exit ("Evaluation Error", 1);
    }
}

private define __compile_slsh__ ()
{
  variable
    CC_COM = CC + " -g -O2 "  + (DEBUG ? DEB_FLAGS : "") + " " +
      SRC_INTER_PATH + "/__slsh.c -o " + SRC_TMP_PATH + "/__slsh -lslang -lm -lpam";

  if (system (CC_COM))
    This.exit ("failed to compile " + SRC_TMP_PATH + "/__slsh.c", 1);
}

private define __bytecompile__ (__sl__)
{
  try
    byte_compile_file (__sl__, 0);
  catch AnyError:
    {
    io.tostderr (__get_exception_info.message, __get_exception_info.line);
    Exc.print (__get_exception_info);
    This.exit ("failed to byte compile " + __sl__, 1);
    }
}

private define __read___ (this)
{
  variable __buf__ =
`ifnot (__is_initialized (&$0))
$0 = realpath ((($0 = path_concat (getcwd (), path_dirname (__FILE__)),
    $0[[-2:]] == "/."
      ? substr ($0, 1, strlen ($0) - 2)
      : $0)) + "/../..");

private variable __SRC_CPATHS = [
  $0 + "/__/__",
  $0 + "/__/local/__",
  $0 + "/__/usr/__"];

private variable __CPATHS = [
  $0 + "/std/__",
  $0 + "/local/__",
  $0 + "/usr/__"];

private variable __LPATHS = [
  $0 + "/std/___",
  $0 + "/local/___",
  $0 + "/usr/___"];

set_import_module_path (
    $0 + "/usr/C/" + uname.machine + "/slang-modules:" +
    $0 + "/std/C/" + uname.machine + "/slang-modules:" +
    get_import_module_path);

`;

  __buf__ += readfile (SRC_PROTO_PATH + "/__alfa.sl");
  __buf__ += readfile (SRC_PROTO_PATH + "/__slang.sl");
  __buf__ += readfile (SRC_PROTO_PATH + "/__F.sl");
  __buf__ += readfile (SRC_PROTO_PATH + "/__This.sl");
  __buf__ += readfile (SRC_PROTO_PATH + "/__vita.sl");
  __buf__ += this + "\n\n";
  __buf__ += readfile (SRC_PROTO_PATH + "/__.sl");
  __buf__ += readfile (SRC_PROTO_PATH + "/__gama.sl");
  __buf__;
}

private define __me__ ()
{
  variable __buf__ = __read___ (THESE["__me__"]);

  () = chdir (SRC_CLASS_PATH);
  __eval__  (__buf__);
  () = chdir (SRC_PATH);
}

private define __ ()
{
  variable __buf__ = __read___ (THESE["__"]);
  __buf__ += `Class.load ("Input");`;

  writefile (SRC_TMP_PATH + "/__.sl", __buf__);

  __bytecompile__ (SRC_TMP_PATH + "/__.sl");
}

private define __read_com__ ()
{
  variable __buf__ =  "";
  __buf__ += __read___ (THESE["__COMMAND__"]);
  __buf__ += readfile (SRC_PROTO_PATH + "/__com.sl");
  __buf__;
}

private define __com__ ()
{
  variable __buf__ =  __read_com__;

  writefile (SRC_TMP_PATH + "/__com.sl", __buf__);

  __bytecompile__ (SRC_TMP_PATH + "/__com.sl");
}

private define __read_app__ ()
{
  variable __buf__ =  "";
  __buf__ += __read___ (THESE["__APP__"]);
  __buf__ += readfile (SRC_PROTO_PATH + "/__app.sl");
  __buf__;
}

private define __app__ ()
{
  variable __buf__ =  __read_app__;

  writefile (SRC_TMP_PATH + "/__app.sl", __buf__);

  __bytecompile__ (SRC_TMP_PATH + "/__app.sl");
}

private define __profile__ ()
{
  variable __buf__ = readfile (SRC_PROTO_PATH + "/__profile.sl");

  writefile (SRC_TMP_PATH + "/__profile.sl", __buf__);

  __bytecompile__ (SRC_TMP_PATH + "/__profile.sl");
}

private variable LIBS = Assoc_Type[Ref_Type];

LIBS["__me__"] = &__me__;
LIBS["__"] = &__;
LIBS["__com__"] = &__com__;
LIBS["__app__"] = &__app__;
LIBS["__profile__"] = &__profile__;

private variable BYTECOMPILED = ["__", "__com", "__app", "__profile"];

private define __build__ (l)
{
  (@LIBS[l]);
}

eval ("static define COLOR ();", "Smg");

__build__ ("__me__");

This.exit = &__exit_me__;
This.err_handler = &__err_handler__;
This.at_exit = &__at_exit__;
This.has.max_frames = 2;

private define __build_modules__ ()
{
  variable i;
  _for i (4, length (MODULES) - 1)
    __build_module__ (i);
}

private define __install_modules__ ()
{
  variable i;
  _for i (0, length (MODULES) - 1)
    if (-1 == rename (SRC_TMP_PATH + "/" + MODULES[i] + "-module.so",
        STD_MODULE_PATH + "/" + MODULES[i] + "-module.so"))
      if (0 == any (MODULES[i] == MODULES_THAT_DONT_EXIT_ON_ERR) ||
          0 == any (MODULES[i] == MODULES_THAT_FAILED))
        This.exit ("failed to rename " + SRC_TMP_PATH + "/" + MODULES[i] + "-module.so to " +
          STD_MODULE_PATH + "\n" + errno_string (errno), 1);
}

private define __install_bytecompiled__ ()
{
  variable i;
  _for i (0, length (BYTECOMPILED) - 1)
    if (-1 == rename (SRC_TMP_PATH + "/" + BYTECOMPILED[i] + ".slc",
       STD_CLASS_PATH + "/" + BYTECOMPILED[i] + ".slc"))
     This.exit ("failed to rename " + SRC_TMP_PATH + "/" +
       BYTECOMPILED[i] + ".slc to " + STD_PATH + "/" +
       BYTECOMPILED[i] + ".slc" + "\n" + errno_string (errno), 1);
}

private variable exclude_dirs = [".git", "dev", "C"];
private variable exclude_files = ["README.md", "___.sl"];
private variable exclude_class_for_removal =
  array_map (String_Type, &sprintf, "%s.slc", BYTECOMPILED);

private define clean_classes (file, st)
{
  if (path_extname (file) == ".slc" &&
      0 == any (path_basename (file) == exclude_class_for_removal))
    if (-1 == remove (file))
      This.exit ("Failed to remove", file);

  1;
}

private define lib_dir_callback (dir, st, src_path, dest_path)
{
  if (any (exclude_dirs == path_basename (dir)))
    return 0;

  if (-1 == Dir.make (strreplace (dir, src_path, dest_path), 0755))
    This.exit ("can't make directory", 1);

  1;
}

private define __copy_files (src, dest, st_src)
{
  variable st_dest = stat_file (dest);
  variable opts = struct
      {
      interactive = 0,
      no_clobber = 0,
      force = 1,
      make_backup = 0,
      only_update = 0,
      permissions = 1,
      no_dereference = 0,
      };

  return File.__copy__ (src, dest, st_src, st_dest, opts;verbose = 0);
}

private define file_callback_libs (file, st, src_path, dest_path, bytecompile)
{
  if (any (exclude_files == path_basename (file)))
    return 1;

  if (path_extname (file) == ".sl" && bytecompile)
    {
    variable bytecompiled = file + "c";
    variable dest = strreplace (bytecompiled, src_path, dest_path);

    __bytecompile__ (file);

    if (-1 == rename (bytecompiled, dest))
      This.exit ("failed to rename " + bytecompiled + " to " + dest + "\n" +
        errno_string (errno), 1);

    return 1;
    }

  dest = strreplace (file, src_path, dest_path);

  ifnot (path_extname (file) == ".slc")
    {
    if (-1 == __copy_files (file, dest, st))
      This.exit ("failed to copy " + file + " to " + dest + "\n" +
        errno_string (errno), 1);
    }
  else
    if (-1 == rename (file, dest))
      This.exit ("failed to rename " + file + " to " + dest + "\n" +
        errno_string (errno), 1);

  1;
}

private define __scripts_dir_callback__ (dir, st)
{
  variable com = path_basename (dir);

  ifnot (strlen (com))
    return 1;

  if (-1 == symlink ("COM.sl", "__" + com))
    if (EEXIST == errno && readlink ("__" + com) == "COM.sl")
      return 1;
    else
      This.exit ("Couldn't create symbolic link " +  errno_string (errno), 1);

  1;
}

private define __install_scripts__ ()
{
  () = chdir (BIN_PATH);
  variable scr = `#!` + BIN_PATH + "/__slsh\n\n" +
    `if ("COM.sl" == path_basename (__argv[0]))
  {
  () = fprintf (stderr, "you cannot call directly this script\n");
  exit (1);
  }` + "\n\n" +
  `variable ROOTPATH = (ROOTPATH = path_concat (getcwd (), path_dirname (__FILE__)),
  ROOTPATH[[-2:]] == "/."
  ? substr (ROOTPATH, 1, strlen (ROOTPATH) - 2)
  : ROOTPATH);

ROOTPATH = realpath (ROOTPATH + "/..");

() = evalfile ("` + STD_CLASS_PATH + `/__com");`;

  writefile (BIN_PATH + "/COM.sl", scr);

  if (-1 == chmod (BIN_PATH + "/COM.sl", 0755))
    This.exit ("cannot change mode to " + BIN_PATH + "/COM.sl " +
      errno_string (errno), 1);

  Dir.walk (SRC_COM_PATH + "/", &__scripts_dir_callback__, NULL);

  () = chdir (SRC_PATH);
}

private define __apps_dir_callback__ (dir, st)
{
  variable app = path_basename (dir);

  ifnot (strlen (app))
    return 1;

  if (-1 == symlink ("APP.sl", "__" + app))
    if (EEXIST == errno && readlink ("__" + app) == "APP.sl")
      return 0;
    else
      This.exit ("Couldn't create symbolic link " +  errno_string (errno), 1);

  0;
}

private define __install_apps__ ()
{
  () = chdir (BIN_PATH);
  variable app = `#!` + BIN_PATH + "/__slsh\n\n" +
    `if ("APP.sl" == path_basename (__argv[0]))
  {
  () = fprintf (stderr, "you cannot call directly this script\n");
  exit (1);
  }` + "\n\n" +
  `variable ROOTPATH = (ROOTPATH = path_concat (getcwd (), path_dirname (__FILE__)),
  ROOTPATH[[-2:]] == "/."
  ? substr (ROOTPATH, 1, strlen (ROOTPATH) - 2)
  : ROOTPATH);

ROOTPATH = realpath (ROOTPATH + "/..");

() = evalfile ("` + STD_CLASS_PATH + `/__app");`;

  writefile (BIN_PATH + "/APP.sl", app);

  if (-1 == chmod (BIN_PATH + "/APP.sl", 0755))
    This.exit ("cannot change mode to " + BIN_PATH + "/APP.sl " +
      errno_string (errno), 1);

  Dir.walk (SRC_APP_PATH + "/", &__apps_dir_callback__, NULL);

  ifnot (access (SRC_USER_APP_PATH, F_OK))
    Dir.walk (SRC_USER_APP_PATH + "/", &__apps_dir_callback__, NULL);

  () = chdir (SRC_PATH);
}

private define __filter_classes__ ()
{
  This.system."supports?"["hunspell"] = (NULL != find_lib ("hunspell-1.6"));

  ifnot (This.system."supports?"["hunspell"])
    {
    CLASSES[wherefirst ("Spell" == CLASSES)] = NULL;
    CLASSES = CLASSES[wherenot (_isnull (CLASSES))];
    }
}

private define __bytecompile_classes__ ()
{
  __filter_classes__;

  variable i;
  variable c;

  _for i (0, length (CLASSES) - 1)
    {
    c = SRC_CLASS_PATH + "/" + CLASSES[i] + "/" + CLASSES[i] + ".slc";

    ifnot (access (c, F_OK))
      if (-1 == remove (c))
        This.exit ("failed to remove already bytecompiled class: " + c +
         ", error: " + errno_string (errno), 1);

    if (VERBOSE)
      io.tostdout ("compiling", CLASSES[i]);

    Class.load (CLASSES[i]);
    }
}

private define __compile_user_module__ (module, st)
{
  module = path_basename (module);
  __compile_module__ (SRC_USER_MODULE_PATH, module);

  module = SRC_TMP_PATH + "/" + path_basename_sans_extname (module) + ".so";

  if (-1 == rename (module, USER_MODULE_PATH + "/" + path_basename (module)))
    This.exit ("failed to rename " + module + " to " + USER_MODULE_PATH, 1);
}

private define __main__ ()
{
  variable i;
  _for i (0, length (INST_PATHS) - 1)
    Dir.make (INST_PATHS[i], File->PERM["_PUBLIC"]);

  if (VERBOSE)
    io.tostdout ("bytecompiling __");

  __build__ ("__");

  if (VERBOSE)
    io.tostdout ("bytecompiling __com");

  __build__ ("__com__");

  if (VERBOSE)
    io.tostdout ("bytecompiling __app");

  __build__ ("__app__");

  if (VERBOSE)
    io.tostdout ("bytecompiling __profile");

  __build__ ("__profile__");

  if (VERBOSE)
    io.tostdout ("compiling __slsh.c");

  __compile_slsh__;

  ifnot (DONT_COMPILE_MODULES)
    __build_modules__;

  set_import_module_path (get_import_module_path + ":" + SRC_TMP_PATH +
    ":" + STD_MODULE_PATH);

  Dir.walk (SRC_LIB_PATH, &lib_dir_callback, &file_callback_libs;
    dargs = {SRC_LIB_PATH, STD_LIB_PATH},
    fargs = {SRC_LIB_PATH, STD_LIB_PATH, 1});

  __bytecompile_classes__;

  ifnot (DONT_COMPILE_MODULES)
    {
    if (VERBOSE)
      io.tostdout ("installing modules to", STD_MODULE_PATH);

    __install_modules__;
    }

  if (VERBOSE)
    io.tostdout ("installing", SRC_TMP_PATH + "/__slsh to", BIN_PATH);

  if (-1 == rename (SRC_TMP_PATH + "/__slsh", SLSH_BIN))
    This.exit ("failed to rename " + SRC_TMP_PATH + "/__slsh to " + BIN_PATH +
      "\n" + errno_string (errno), 1);

  () = chdir (BIN_PATH);

  loop (1)
  if (-1 == symlink (SLSH_BIN, SLSH_LNK))
    ifnot (EEXIST == errno)
      This.exit ("Couldn't create symbolic link " +  errno_string (errno), 1);
    else
      if (readlink (SLSH_LNK) == SLSH_BIN)
        break;
      else
        if (-1 == remove (SLSH_LNK))
          This.exit ("Couldn't remove link: " + SLSH_LNK + "\n" +
             errno_string (errno), 1);
        else
          if (-1 == symlink (SLSH_BIN, SLSH_LNK))
            This.exit ("Couldn't create symbolic link " +  errno_string (errno), 1);

  if (-1 == chmod (BIN_PATH + "/__slsh", 0755))
    This.exit ("cannot change mode to " + BIN_PATH + "/__slsh\n" +
      errno_string (errno), 1);

  () = chdir (SRC_PATH);

  if (VERBOSE)
    io.tostdout ("installing bytecompiled libraries");

  __install_bytecompiled__;

  if (VERBOSE)
    io.tostdout ("installing libraries");

  Dir.walk (STD_CLASS_PATH, NULL, &clean_classes);

  Dir.walk (SRC_CLASS_PATH, &lib_dir_callback, &file_callback_libs;
    dargs = {SRC_CLASS_PATH, STD_CLASS_PATH},
    fargs = {SRC_CLASS_PATH, STD_CLASS_PATH, 0});

  if (VERBOSE)
    io.tostdout ("installing commands");

  Dir.walk (SRC_COM_PATH, &lib_dir_callback, &file_callback_libs;
    dargs = {SRC_COM_PATH, STD_COM_PATH},
    fargs = {SRC_COM_PATH, STD_COM_PATH, 1});

  __install_scripts__;
  __install_apps__;

  Dir.walk (SRC_DATA_PATH, &lib_dir_callback, &file_callback_libs;
    dargs = {SRC_DATA_PATH, STD_DATA_PATH},
    fargs = {SRC_DATA_PATH, STD_DATA_PATH, 1});

  Dir.walk (SRC_APP_PATH, &lib_dir_callback, &file_callback_libs;
    dargs = {SRC_APP_PATH, STD_APP_PATH},
    fargs = {SRC_APP_PATH, STD_APP_PATH, 1});

  ifnot (access (SRC_USER_PATH, F_OK|R_OK))
    {
    ifnot (access (SRC_USER_COM_PATH, F_OK|R_OK))
      Dir.walk (SRC_USER_COM_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_USER_COM_PATH, USER_COM_PATH},
        fargs = {SRC_USER_COM_PATH, USER_COM_PATH, 1});

    ifnot (access (SRC_USER_DATA_PATH, F_OK|R_OK))
      Dir.walk (SRC_USER_DATA_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_USER_DATA_PATH, USER_DATA_PATH},
        fargs = {SRC_USER_DATA_PATH, USER_DATA_PATH, 1});

    ifnot (access (SRC_USER_APP_PATH, F_OK|R_OK))
      Dir.walk (SRC_USER_APP_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_USER_APP_PATH, USER_APP_PATH},
        fargs = {SRC_USER_APP_PATH, USER_APP_PATH, 1});

    Dir.walk (USER_CLS_PATH, NULL, &clean_classes);

    ifnot (access (SRC_USER_CLASS_PATH + "/__app.sl", F_OK|R_OK))
      __bytecompile__ (SRC_USER_CLASS_PATH + "/__app.sl");

    ifnot (access (SRC_USER_CLASS_PATH, F_OK|R_OK))
      Dir.walk (SRC_USER_CLASS_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_USER_CLASS_PATH, USER_CLS_PATH},
        fargs = {SRC_USER_CLASS_PATH, USER_CLS_PATH, 0});

    ifnot (access (SRC_USER_LIB_PATH, F_OK|R_OK))
      Dir.walk (SRC_USER_LIB_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_USER_LIB_PATH, USER_LIB_PATH},
        fargs = {SRC_USER_LIB_PATH, USER_LIB_PATH, 1});

    ifnot (access (SRC_USER_APP_PATH, F_OK|R_OK))
      {
      () = chdir (BIN_PATH);
      Dir.walk (SRC_USER_APP_PATH + "/", &__apps_dir_callback__, NULL);
      () = chdir (SRC_PATH);
      }

    ifnot (access (SRC_USER_COM_PATH, F_OK|R_OK))
      {
      () = chdir (BIN_PATH);
      Dir.walk (SRC_USER_COM_PATH + "/", &__scripts_dir_callback__, NULL);
      () = chdir (SRC_PATH);
      }

   ifnot (access (SRC_USER_C_PATH, F_OK|R_OK))
     Dir.walk (SRC_USER_C_PATH, NULL, &__compile_user_module__);
   }

  ifnot (access (SRC_LOCAL_PATH, F_OK|R_OK))
    {
    ifnot (access (SRC_LOCAL_COM_PATH, F_OK|R_OK))
      Dir.walk (SRC_LOCAL_COM_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_LOCAL_COM_PATH, LOCAL_COM_PATH},
        fargs = {SRC_LOCAL_COM_PATH, LOCAL_COM_PATH, 1});

    ifnot (access (SRC_LOCAL_APP_PATH, F_OK|R_OK))
      Dir.walk (SRC_LOCAL_APP_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_LOCAL_APP_PATH, LOCAL_APP_PATH},
        fargs = {SRC_LOCAL_APP_PATH, LOCAL_APP_PATH, 1});

    Dir.walk (LOCAL_CLASS_PATH, NULL, &clean_classes);

    ifnot (access (SRC_LOCAL_CLASS_PATH + "/__app.sl", F_OK|R_OK))
      __bytecompile__ (SRC_LOCAL_CLASS_PATH + "/__app.sl");

    ifnot (access (SRC_LOCAL_CLASS_PATH, F_OK|R_OK))
      Dir.walk (SRC_LOCAL_CLASS_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_LOCAL_CLASS_PATH, LOCAL_CLASS_PATH},
        fargs = {SRC_LOCAL_CLASS_PATH, LOCAL_CLASS_PATH, 0});

    ifnot (access (SRC_LOCAL_LIB_PATH, F_OK|R_OK))
      Dir.walk (SRC_LOCAL_LIB_PATH, &lib_dir_callback, &file_callback_libs;
        dargs = {SRC_LOCAL_LIB_PATH, LOCAL_LIB_PATH},
        fargs = {SRC_LOCAL_LIB_PATH, LOCAL_LIB_PATH, 1});

    ifnot (access (SRC_LOCAL_APP_PATH, F_OK|R_OK))
      {
      () = chdir (BIN_PATH);
      Dir.walk (SRC_LOCAL_APP_PATH + "/", &__apps_dir_callback__, NULL);
      () = chdir (SRC_PATH);
      }

    ifnot (access (SRC_LOCAL_COM_PATH, F_OK|R_OK))
      {
      () = chdir (BIN_PATH);
      Dir.walk (SRC_LOCAL_COM_PATH + "/", &__scripts_dir_callback__, NULL);
      () = chdir (SRC_PATH);
      }
   }

  ifnot (WARNINGS)
    This.exit ("installation completed", 0);

  variable warnings = ["Warnings:\n"];

  ifnot (string_match ("$PATH"$, BIN_PATH))
    warnings = [warnings, BIN_PATH, "is not a part of $PATH\n" +
      BIN_PATH + " should be added to the $PATH environment variable\n" +
      "relative paths should work however\n"];

  if (NULL == getenv ("XAUTHORITY"))
    warnings = [warnings, "XAUTHORITY environment variable isn't set.\nThis is" +
      " normal if you are not logged in X but not if don't\n"];

  if (NULL == getenv ("TERM"))
    warnings = [warnings, "TERM environment variable isn't set.\n" +
      "The programm will refuse to work\n"];

  variable lang = getenv ("LANG");

  if (NULL == lang)
    warnings = [warnings, "LANG environment variable isn't set.\n" +
      "The programm will refuse to work\n"];
  else
    if (5 > strlen (lang) || "UTF-8" != substr (lang, strlen (lang) - 4, -1))
      warnings = [warnings, "locale: " + lang + " isn't UTF-8 (Unicode), or misconfigured\n", +
      "The programm will refuse to work\n"];

  if (NULL == getenv ("HOME"))
    warnings = [warnings, "HOME environment variable isn't set.\n" +
      "The programm will refuse to work\n"];

  if (NULL == getenv ("PATH"))
    warnings = [warnings, "PATH environment variable isn't set.\n" +
      "The programm will refuse to work\n"];

  _for i (0, length (REQ_EXECUTABLES) - 1)
    if (NULL == which (REQ_EXECUTABLES[i]))
      warnings = [warnings, REQ_EXECUTABLES[i] + " is not installed, " +
        "The programm will refuse to work\n"];

  _for i (0, length (IMP_EXECUTABLES) - 1)
    if (NULL == which (IMP_EXECUTABLES[i]))
      warnings = [warnings, IMP_EXECUTABLES[i] + " is not installed, " +
        "some critical functions won't be available"];

  _for i (0, length (OPT_EXECUTABLES) - 1)
    if (NULL == which (OPT_EXECUTABLES[i]))
      warnings = [warnings, OPT_EXECUTABLES[i] + " is not installed, " +
        "some functions won't be available"];

  if (length (warnings) > 1)
    io.tostderr (warnings);

  This.exit ("installation completed", 0);
}

__main__ ();
