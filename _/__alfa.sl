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
  name,
  super,
  path,
  isself,
  } Class_Type;

typedef struct
  {
  null
  } AString_Type;

typedef struct
  {
  null
  } AInteger_Type;

