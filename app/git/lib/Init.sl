Class.load ("Scm");

public define setrepo ();

public variable VED_INFOCLRFG = Smg->NOCOLOR;
public variable VED_INFOCLRBG = Smg->NOCOLOR;

public variable DIFF = This.tmpdir + "/__DIFF__.diff";
public variable DIFF_VED = Ved.init_ftype ("diff");

DIFF_VED._fd = IO.open_fn (DIFF);
diff_settype (DIFF_VED, DIFF, VED_ROWS, NULL;_autochdir = 0, show_tilda = 0);

private variable i_colors = [Smg->COLOR.infobg];

private variable i_regexps = [
  pcre_compile ("^(\w*( url)?\s*(?=:)|^(\S*$))"R, 0)];

private define info_lexicalhl (s, lines, vlines)
{
  __hl_groups (lines, vlines, i_colors, i_regexps);
}

private variable s_regexps = [
  pcre_compile ("(STATUS)"R, 0)];

private define stat_lexicalhl (s, lines, vlines)
{
  __hl_groups (lines, vlines, i_colors, s_regexps);
}

public define on_wind_change (w)
{
  Ved.setbuf (w.frame_names[w.cur_frame]);
  This.stdoutFd = Ved.get_frame_buf (0)._fd;

  ifnot (NULL == w.dir)
    {
    () = chdir (w.dir);

    if (any (assoc_get_keys (W_REPOS) == w.name))
      CUR_REPO = path_basename (w.dir);
    else
      CUR_REPO = "NONE";
    }
  else
    CUR_REPO == "NONE";

  topline (" -- git --");
}

public define on_wind_new (w)
{
  CUR_REPO = "NONE";

  This.stdoutFn = This.tmpdir + "/__STDOUT_" + w.name + "_" + string (_time)[[5:]] +
  "." + This.stdouttype;

  variable b = This.tmpdir + "/__INFO_" + w.name + "_" + string (_time)[[5:]] + ".txt";

  SPECIAL = [SPECIAL, This.stdoutFn];

  variable aved = Ved.init_ftype (This.stdouttype);
  variable bved = Ved.init_ftype ("txt");

  aved._fd = IO.open_fn (This.stdoutFn);
  bved._fd = IO.open_fn (b);

  (@__get_reference (This.stdouttype + "_settype"))
    (aved, This.stdoutFn, w.frame_rows[0], NULL;_autochdir = 0);

  txt_settype (bved, b, w.frame_rows[1], NULL;_autochdir = 0);

  aved.opt_show_tilda = 0;
  bved.opt_show_tilda = 0;
  aved._indent = 2;

  bved.lexicalhl = &info_lexicalhl;
  aved.lexicalhl = &stat_lexicalhl;

  Ved.setbuf (b;frame = 1);
  Ved.setbuf (This.stdoutFn);

  __vset_clr_bg (bved, NULL);

  This.stdoutFd = aved._fd;

  topline (" -- git --");

  (@__get_reference ("__initrline"));

  Ved.draw_wind ();
}

public define _del_frame_ (s)
{
}

public define _new_frame_ (s)
{
}

private define _myframesize_ ()
{
  loop (_NARGS) pop ();

  variable f = Array_Type[2];
  f[0] = [1:LINES - 9];
  f[1] = [LINES - 8:LINES - 3];
  f;
}

This.framesize_fun = &_myframesize_;

Load.file (This.appdir + "/lib/git", NULL);