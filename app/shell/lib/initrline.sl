private define _intro_ (argv)
{
  intro (Ved.get_cur_rline (), Ved.get_cur_buf ());
}

private define my_commands ()
{
  variable a = init_commands ();

  a["intro"] = @Argvlist_Type;
  a["intro"].func = &_intro_;

  a;
}

private define filtercommands (s, ar)
{
  ar = ar[where (1 < strlen (ar))];
  ar = ar[Array.__wherenot (ar, ["w!", "global"])];
  __APP__->__filtercommands (s, ar, ['~', '_']);
}

private define filterargs (s, args, type, desc)
{
  [args, "--su", "--pager"], [type, "void", "void"],
  [desc, "execute command as superuser", "viewoutput in a scratch buffer"];
}

private define tabhook (s)
{
  ifnot (s._ind)
    return -1;

  ifnot (any (s.argv[0] == ["__killbgjob", "man"]))
    return -1;

  if (strlen (s.argv[s._ind]) && '-' == s.argv[s._ind][0])
    return -1;

  ifnot ("man" == s.argv[0])
    {
    variable pids = assoc_get_keys (BGPIDS);

    ifnot (length (pids))
      return -1;

    variable i;
    _for i (0, length (pids) - 1)
      pids[i] = pids[i] + " void " + strjoin (BGPIDS[pids[i]].argv, " ");

    return Rline.argroutine (s;args = pids, accept_ws);
    }
  else
    {
    variable file = Env->STD_COM_PATH + "/man/pages.txt";
    if (-1 == access (file, F_OK))
      return -1;

    variable pages = File.readlines (file);
    ifnot (length (pages))
      return -1;

    return Rline.argroutine (s;args = pages, accept_ws);
    }
}

public define rlineinit ()
{
  variable rl = Rline.init (&my_commands;;struct
    {
    @__qualifiers (),
    histfile = This.is.my.histfile,
    filtercommands = &filtercommands,
    filterargs = &filterargs,
    tabhook = &tabhook,
    onnolength = &toplinedr,
    onnolengthargs = {""},
    on_lang = &toplinedr,
    on_lang_args = {" -- shell --"}
    });

  IARG = length (rl.history);

  rl;
}
