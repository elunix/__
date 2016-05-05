new_exception ("ClassError", AnyError, "Base Class Error");

typedef struct
  {
  val,
  type,
  const
  } Var_Type;

typedef struct
  {
  funcref,
  nargs,
  const,
  } Fun_Type;

typedef struct
  {
  __name,
  err_handler,
  } Self_Type;

typedef struct
  {
  name,
  super,
  path,
  isself,
  } Class_Type;

typedef struct
  {
  appname,
  argv,
  shell,
  ved,
  os,
  is_tty,
  is_smg,
  stderrFn,
  stderrFd,
  stdoutFn,
  stdoutFd,
  stdouttype,
  tmpdir,
  appdir,
  datadir,
  at_exit,
  err_handler,
  exit,
  framesize_fun,
  frames,
  max_frames,
  isatsession,
  isscreenactive,
  isachild,
  } ThisProg_Type;

typedef struct
  {
  null
  } AString_Type;

typedef struct
  {
  null
  } AInteger_Type;

public variable This, Smg, Input, LINES, COLUMNS;

