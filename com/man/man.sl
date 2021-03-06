Class.load ("String");

private variable
  MANDIR = "/usr/share/man/",
  LOCALMANDIR = "/usr/local/share/man/",
  DATA_DIR = sprintf ("%s/man", Env->USER_DATA_PATH),
  MYMANDIR = sprintf ("%s/manhier", DATA_DIR),
  MAN_HIER = [
    array_map (String_Type, &sprintf, "%s/man%d",  MYMANDIR, [0:8]),
    MYMANDIR + "/man0p",
    MYMANDIR + "/man1p",
    MYMANDIR + "/man3p"];

private variable
  gzip = Sys.which ("gzip"),
  groff = Sys.which ("groff"),
  col = Sys.which ("col");

if (NULL == gzip)
  {
  IO.tostderr ("gzip hasn't been found in PATH");
  exit_me (1);
  }

if (NULL == groff)
  {
  IO.tostderr ("groff hasn't been found in PATH");
  exit_me (1);
  }

if (NULL == col)
  {
  IO.tostderr ("col hasn't been found in PATH");
  exit_me (1);
  }

private define rm_head_ws__ (fn, ind)
{
  variable i, line, j,
    ar = File.readlines (fn),
    len = strlen (ar);

  len--;

  _for i (0, length (ar) - 1)
    {
    line = ar[i];
    ifnot (len[i] + 1)
      continue;

    j = 1;
    while (j <= ind && j <= len[i] &&
        isblank (substr (line, j, 1)[0]))
      j++;
    ar[i] = substr (line, j, -1);
    }

  () = File.write (fn, ar);
}

define getpage (page)
{
  variable
    i,
    p,
    ar,
    st,
    match,
    matchfn,
    status,
    outfn = sprintf ("%s/Man_Page_Out.txt", MYMANDIR),
    fname = sprintf ("%s/Man_Page_Fname.txt", MYMANDIR),
    errfn = sprintf ("%s/Man_Page_Fname_ERRORS.txt", MYMANDIR),
    colfn = sprintf ("%s/Man_Page_Fname_col.txt", MYMANDIR),
    manpages = String_Type[0],
    matches = String_Type[0];

  if (".gz" == path_extname (page))
    {
    p = initproc (0, 1, 0);
    p.stdout.file = fname;

    () = p.execv ([gzip, "-dc", page], NULL);
    }
  else
    fname = page;

  p = initproc (0, 1, 1);
  p.stdout.file = outfn;
  p.stderr.file = errfn;

  status = p.execv ([groff, "-Tutf8", "-m", "man", fname], NULL);

  ar = File.readlines (errfn);

  if (length (ar))
    {
    _for i (0, length (ar) - 1)
      {
      match = string_matches (ar[i], "`.*'", 1)[0];
      if (NULL == match)
        continue;

      match = substr (match, 2, strlen (match) - 2);
      page = sprintf ("%s/%s", MANDIR, match);
      st = stat_file (page);
      if (NULL == st)
        page = sprintf ("%s.gz", page);

      st = stat_file (page);
      if (NULL == st)
        continue;
      matches = [matches, match];
      manpages = [manpages, page];
      }

    _for i (0, length (manpages) - 1)
      {
      page = manpages[i];
      match = matches[i];

      if (".gz" == path_extname (page))
        {
        matchfn = sprintf ("%s/%s", MYMANDIR, match);
        p = initproc (0, 1, 0);
        p.stdout.file = matchfn;

        status = p.execv ([gzip, "-dc", page], NULL);
        }
      else
        () = File.copy (page, sprintf ("%s/%s", MYMANDIR, match));
      }

    p = initproc (0, 1, 1);
    p.stdout.file = outfn;
    p.stderr.file = "/dev/null";

    status = p.execv ([groff, "-Tutf8", "-m", "man", "-I", MYMANDIR, fname], NULL);

    _for i (0, length (manpages) - 1)
      {
      page = manpages[i];
      match = matches[i];
      () = remove (sprintf ("%s/%s", MYMANDIR, match));
      }
    }

  p = initproc (1, openstdout, openstderr);

  p.stdin.file = outfn;

  variable rm_head_ws = __get_qualifier_as (Integer_Type, qualifier ("rm_head_ws"), NULL);

  ifnot (NULL == rm_head_ws)
    rm_head_ws__ (outfn, rm_head_ws);

  status = p.execv ([col, "-b"], NULL);

  ar = MYMANDIR + "/" + listdir (MYMANDIR);

  variable l;
  _for i (0, length (MAN_HIER) - 1)
    ifnot (NULL == (l = listdir (MAN_HIER[i]), l))
      ar = [ar, MAN_HIER[i] + "/" + l];

  _for i (0, length (ar) - 1)
    ifnot (Dir.isdirectory (ar[i]))
      () = remove (ar[i]);

  status.exit_status;
}

private define file_callback (file, st, filelist)
{
  list_append (filelist, file);

  1;
}

define main ()
{
  variable
    i,
    ar,
    pos,
    pat,
    page,
    retval,
    man_page,
    search = NULL,
    options = 0,
    cache = NULL,
    cachefile = sprintf ("%s/cache.txt", DATA_DIR),
    from_file = NULL,
    c = Opt.Parse.new (&_usage);

  if (-1 == access (DATA_DIR, F_OK))
    if (-1 == mkdir (DATA_DIR))
      {
      IO.tostderr (sprintf ("cannot create %s", DATA_DIR));
      exit_me (1);
      }

  if (-1 == access (MYMANDIR, F_OK))
    {
    if (-1 == mkdir (MYMANDIR))
      {
      IO.tostderr (sprintf ("cannot create %s", MYMANDIR));
      exit_me (1);
      }

    () = array_map (Integer_Type, &mkdir, MAN_HIER);
    }

  c.add ("search", &search;type="string");
  c.add ("caseless", &options;bor = PCRE_CASELESS);
  c.add ("from-file", &from_file;type = "string");
  c.add ("buildcache", &cache);
  c.add ("help", &_usage);
  c.add ("info", &info);

  i = c.process (__argv, 1);

  ifnot (NULL == cache)
    {
    variable
      lu = strlen (MANDIR),
      ll = strlen (LOCALMANDIR),
      ulist = {},
      llist = {};

    Dir.walk (LOCALMANDIR, NULL, &file_callback;fargs = {llist});
    llist = list_to_array (llist, String_Type);
    llist = llist[where ("man" == array_map (String_Type,  &substr, llist, ll + 1, 3))];

    Dir.walk (MANDIR, NULL, &file_callback;fargs = {ulist});
    ulist = list_to_array (ulist, String_Type);
    ulist = ulist[where ("man" == array_map (String_Type,  &substr, ulist, lu + 1, 3))];

    variable list = [llist, ulist];

    _for i (0, length (list) - 1)
      {
      variable st = stat_file (list[i]);
      if (NULL == st || stat_is ("dir", st.st_mode))
        list[i] = NULL;
      }

    list = list[wherenot (_isnull (list))];

    ifnot (length (list))
      {
      IO.tostderr ("no man page found");
      exit_me (1);
      }

    () = File.write (cachefile, list);
    variable argsfile = Env->STD_COM_PATH + "/man/pages.txt";
    list = array_map (String_Type, &path_basename_sans_extname, list);
    list = array_map (String_Type, &path_basename_sans_extname, list);
    list = array_map (String_Type, &sprintf, "%s void display %s", list, list);
    () = File.write (argsfile, list);
    exit_me (0);
    }

  ifnot (NULL == search)
    {
    if (-1 == access (cachefile, F_OK))
      {
      IO.tostderr (sprintf ("%s: cache file not found, run again with --buildcache",
        cachefile));
      exit_me (1);
      }

    cache = File.readlines (cachefile);
    pat = pcre_compile (search, options);
    if (path_is_absolute (search))
      pos = 0;
    else
      pos = strlen (MANDIR) + 4;

    man_page = String_Type[0];

    _for i (0, length (cache) - 1)
      if (pcre_exec (pat, cache[i], pos))
        man_page = [man_page, cache[i]];

    ifnot (length (man_page))
      {
      IO.tostderr (sprintf ("%s: no man page matches the regexp", search));
      exit_me (1);
      }

    if (1 == length (man_page))
      {
      retval = getpage (man_page[0];rm_head_ws = 3);
      exit_me (retval);
      }

    ar = array_map (String_Type, &path_basename, man_page);
    _for i (0, length (ar) - 1)
      ar[i] = strchop (ar[i], '.', 0)[1];

    variable sorted = array_sort (ar);
    ar = ar[sorted];
    man_page = man_page[sorted];

    ar = array_map (String_Type, &sprintf, "%s (%s)",
      array_map (String_Type, &path_basename_sans_extname, man_page), ar);

    retval = IO.ask ([
      sprintf ("@There %d man pages that match", length (man_page)),
      array_map (String_Type, &sprintf, "%d: %s", [1:length (man_page)], ar)
      ], NULL;get_int);

    if (NULL == retval || 0 == strlen (retval))
      {
      IO.tostderr ("man: Aborting ...");
      exit_me (1);
      }

    retval = String.to_int (retval);
    if (NULL == retval)
      {
      IO.tostderr ("man: Selection is not an integer, Aborting ...");
      exit_me (1);
      }

    if (0 == retval || retval > length (man_page))
      {
      IO.tostderr ("selection is out of range");
      exit_me (1);
      }

    retval--;

    man_page = man_page[retval];

    retval = getpage (man_page;rm_head_ws = 3);
    exit_me (retval);
    }

  ifnot (NULL == from_file)
    {
    if (-1 == access (from_file, F_OK))
      {
      IO.tostderr (from_file, "no such file");
      exit_me (1);
      }

    if (-1 == access (from_file, R_OK))
      {
      IO.tostderr (from_file, "is not readable");
      exit_me (1);
      }

    exit_me (getpage (from_file);rm_head_ws = 3);
   }

  if (i == __argc)
    {
    IO.tostderr ("man: argument is required");
    exit_me (1);
    }

  page = __argv[i];

  ifnot (access (page, F_OK))
    {
    retval = getpage (page;rm_head_ws = 3);
    exit_me (retval);
    }
  else
    {
    if (-1 == access (cachefile, F_OK))
      {
      IO.tostderr (sprintf (
        "%s: cache file not found, run again with --buildcache", cachefile));
      exit_me (1);
      }

    cache = File.readlines (cachefile);
    pat = pcre_compile (sprintf (
      "/%s\\056(h\\056)?[0-9]", page), options);
    if (path_is_absolute (page))
      pos = 0;
    else
      pos = strlen (MANDIR) + 4;

    man_page = NULL;

    _for i (0, length (cache) - 1)
      if (pcre_exec (pat, cache[i], pos))
        {
        man_page = cache[i];
        break;
        }

    if (NULL == man_page)
      {
      IO.tostderr (sprintf ("%s: man page haven't been found", page));
      exit_me (1);
      }

    retval = getpage (man_page;rm_head_ws = 3);
    exit_me (retval);
    }
}
