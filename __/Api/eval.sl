private variable realtime_evaluation = 0;

private define _null_ ()
{
  NULL;
}

private define _tabcallback (s)
{
  variable rl = Rline.init (&_null_);
  Rline.set (rl);

  rl._chr = 0;
  rl.argv = @s.argv;
  rl._col = strlen (rl.argv[0]) + 1;
  rl._ind = 0;
  rl._lin = rl.argv[0];

  Smg.setrcdr (PROMPTROW, strlen (rl.argv[0]));

  variable res;
  variable ar;
  forever
    {
    ar = String_Type[0];
    try
      {
      res = eval (substr (rl.argv[0], 1, strlen (rl.argv[0]) - 1));
      if (typeof (res) == Struct_Type)
        ar = get_struct_field_names (res);
      }
    catch AnyError:
      return 0;

    ifnot (length (ar))
      return 0;

    variable tmp = "";
    variable chr = Rline.hlitem (rl, ar, rl.argv[0], rl._col, &tmp);

    if (' ' == chr)
      {
      Rline.restore (rl.cmp_lnrs, NULL, NULL, rl._columns);

      s.argv[s._ind] += strchop (tmp, ' ', 0)[0];
      s._col = strlen (s.argv[0]) + 1;
      return 0;
      }

    if (1 == rl._col)
      Smg.atrcaddnstr (" ", 0, MSGROW, 0, s._columns);

    if (any (['\r', 033] == chr))
      {
      if (033 == chr)
        return 0;
      s.argv = rl.argv;
      return;
      }

    rl._lin = rl.argv[0];
    Rline.routine (rl;insert_ws);
  }
}

private define _assign_ (line)
{
  variable retval = NULL, _v_ = strchop (line, '=', 0);

  if (1 == length (_v_))
    return retval;

  _v_ = _v_[0];

  try
    {
    eval (line);
    Smg.send_msg (string (eval (string (_v_))), 0); % split and return the var?
    retval = 1;
    }
  catch AnyError:
    Smg.send_msg (__get_exception_info.message, 0);

  retval;
}

private define _evalstr_ (line)
{
  variable res, retval = NULL;
  variable depth = _stkdepth ();

  try
    {
    ifnot ('=' == line[0])
      {
      eval (line);
      if (_stkdepth > depth)
        {
        res = ();
        res = string (res);
        }
      else
        res = "";
      }
    else
      return NULL;

    retval = res;
    }
  catch AnyError:
    res = __get_exception_info.message;

  if (qualifier_exists ("send_msg"))
    Smg.send_msg (res, 0);

  retval;
}

private define eval (self)
{
  variable rl = Rline.init (NULL;pchar = ">");
  Rline.set (rl);

  variable history = String_Type[0];
  variable tabcb = qualifier ("tabhook", &_tabcallback);

  ifnot (access (HIST_EVAL, F_OK|R_OK))
    history = File.readlines (HIST_EVAL);

  Smg.send_msg ("Type an expression" , 0);

  rl.argv = [""];

  variable
    res = NULL,
    index = -1;

  variable depth = _stkdepth ();

  forever
    {
    if (_stkdepth > depth)
      loop (_stkdepth - depth)
        pop ();

    rl._lin = ">" + rl.argv[0];
    Rline.prompt (rl, rl._lin, rl._col);
    rl._chr = Input.getch ();

    if (Input->F1 == rl._chr)
      realtime_evaluation++;

    if ('\t' == rl._chr)
      {
      () = (@tabcb) (rl);
      continue;
      }

    if (Input->CTRL_r == rl._chr)
      {
      variable chr = Input.getch ();

      if ('%' == chr)
        {
        variable absfn = Ved.get_cur_buf ()._abspath;
        rl.argv[0] = substr (rl.argv[0], 1, rl._col - 1) + absfn +
                     substr (rl.argv[0], rl._col, -1);
        }

      if (Input->CTRL_w == chr)
        {
        variable buf = Ved.get_cur_buf ();
        variable line = __vline (buf, '.');
        variable col = buf._index;
        variable start, end;
        variable word = __vfind_word (buf, line, col, &start, &end);
        rl.argv[0] = substr (rl.argv[0], 1, rl._col - 1) + word +
                     substr (rl.argv[0], rl._col, -1);
        }

      if ('/' == chr)
        {
        if (assoc_key_exists (REG, "/"))
          if (1 == length (strtok (REG["/"])))
            rl.argv[0] = substr (rl.argv[0], 1, rl._col - 1) + REG["/"] +
                         substr (rl.argv[0], rl._col, -1);
        }

      continue;
      }

    if (any (Input->rmap.histup == rl._chr))
      {
      ifnot (length (history))
        continue;

      index++;
      if (index >= length (history))
        index = 0;

      rl.argv[0] = history[index];
      rl._col = strlen (rl.argv[0]) + 1;
      ifnot (realtime_evaluation mod 2)
        () = _evalstr_ (rl.argv[0];send_msg);
      continue;
      }

    if (any (Input->rmap.histdown == rl._chr))
      {
      ifnot (length (history))
        continue;

      index--;
      if (index < 0)
        index = length (history) - 1;
      rl.argv[0] = history[index];
      rl._col = strlen (rl.argv[0]) + 1;
      ifnot (realtime_evaluation mod 2)
        () = _evalstr_ (rl.argv[0];send_msg);
      continue;
      }

    if (rl._chr == 033)
      break;

    if ('\r' == rl._chr)
      {
      if ('=' == rl.argv[0][0])
        res = _assign_ (substr (rl.argv[0], 2, -1));
      else
        res = _evalstr_ (rl.argv[0];send_msg);

      ifnot (NULL == res)
        history = [rl.argv[0], history];

      if (qualifier_exists ("return_str"))
        break;

      rl.argv[0] = "";
      rl._col = 1;
      continue;
      }

    Rline.routine (rl;insert_ws);

    ifnot (strlen (rl.argv[0]))
      continue;

    ifnot (realtime_evaluation mod 2)
      () = _evalstr_ (rl.argv[0];send_msg);
    }

  if (length (history))
    () = File.write (HIST_EVAL, strjoin (history, "\n"));

  Smg.send_msg (" ", 0);

  if (qualifier_exists ("return_str"))
    return res;
}
