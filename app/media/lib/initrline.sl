private variable CUR_PLAYING = struct {fname, time_len, time_left};
private variable CUR_PLAYLIST = NULL;
private variable CUR_STR = "get_file_name\nget_time_length\nget_time_pos\n";

private define _cur_playing_ ()
{
  if (qualifier_exists ("usecur"))
    return;

  CUR_PLAYING.fname = NULL;
  CUR_PLAYING.time_len = NULL;
  CUR_PLAYING.time_left = NULL;

  if (-1 == lseek (MED_STDOUT_FD, 0, SEEK_END))
    return;

  ifnot (strlen (CUR_STR) == write (MED_FD, CUR_STR))
    return;

  sleep (0.3);

  variable buf = NULL, bts;
  forever
    {
    while (0 == (bts = read (MED_STDOUT_FD, &buf, 4096), bts));
    if (bts == -1)
      if (errno == EINTR)
        continue;
      else
        return;

    break;
    }

  buf = strtok (buf, "\n");
  ifnot (3 == length (buf))
    return;

  CUR_PLAYING.fname = strtok (buf[0], "=");
  ifnot (2 == length (CUR_PLAYING.fname))
    CUR_PLAYING.fname = "";
  else
    CUR_PLAYING.fname = substr (CUR_PLAYING.fname[1], 2, strlen (
      CUR_PLAYING.fname[1]) - 2);

  CUR_PLAYING.time_len = strtok (buf[1], "=");
  ifnot (2 == length (CUR_PLAYING.time_len))
    CUR_PLAYING.time_len = "";
  else
    CUR_PLAYING.time_len = CUR_PLAYING.time_len[1];

  variable len = atoi (CUR_PLAYING.time_len);
  ifnot (len)
    {
    CUR_PLAYING.time_left = "";
    return;
    }

  variable tl = strtok (buf[2], "=");
  ifnot (2 == length (tl))
    tl = 0;
  else
    tl = atoi (tl)[1];

  CUR_PLAYING.time_left = string (len - tl);
}

private define __write_info__ ()
{
  variable cur = NULL == CUR_PLAYING.fname ? NULL : @CUR_PLAYING;
  variable buf;

   _cur_playing_ (;;__qualifiers);

  if (NULL == CUR_PLAYING.fname)
    buf = "\n";
  else
    buf =
    "\nfilename : " + path_basename_sans_extname (CUR_PLAYING.fname) +
    "\ntime len : " + CUR_PLAYING.time_len +
    "\ntime left: " + CUR_PLAYING.time_left + "\n";

  ifnot (NULL == cur)
    ifnot (NULL == CUR_PLAYING.fname)
      if (CUR_PLAYING.fname == cur.fname && CUR_PLAYING.time_left ==
          cur.time_left)
        return;

  variable info = Ved.get_frame_buf (1);

  () = File.write (info._abspath, Smg.__HLINE__ () + buf);

  draw (info;force_a_redraw);
}

private define __write_lyric__ ()
{
  _cur_playing_ (;;__qualifiers);
  if (NULL == CUR_PLAYING.fname)
    return;

  variable lyrics = listdir (MED_LYRICS);
  if (NULL == lyrics || 0 == length (lyrics))
    return;

  try
    {
    variable pat = pcre_compile (path_basename_sans_extname (CUR_PLAYING.fname),
        PCRE_CASELESS);
    }
  catch ParseError:
    return;

  variable i, found = NULL;

  _for i (0, length (lyrics) - 1)
    if (pcre_exec (pat, lyrics[i]))
      {
      found = 1;
      break;
      }

  if (NULL == found)
    return;

  variable lyricbuf = Ved.get_frame_buf (0);
  variable lyric = File.read (MED_LYRICS + "/" + lyrics[i]);
  variable title = path_basename_sans_extname (CUR_PLAYING.fname);
  () = File.write (lyricbuf._abspath, "   " + title + "\n" +
      "   " + repeat ("=", strlen (title)) + "\n" + lyric);

  draw (lyricbuf;_i = 0);
}

% declaring is an intention
private define redisplay (argv)
{
  __write_info__;
  __write_lyric__ (;usecur);
}

private define file_callback (file, st, list, ext)
{
  if (any (ext == path_extname (file)))
    ifnot (access (file, F_OK|R_OK))
      if (path_is_absolute (file))
        list_insert (list, file);
      else
        list_insert (list, getcwd () + "/" + file);

  1;
}

private define play_audio (argv)
{
  if (1 == length (argv))
    return;

  variable noranded = Opt.Arg.exists ("--no-random", &argv;del_arg);

  variable files = argv[[1:]];
  variable list = {};
  variable i;

  _for i (0, length (files) - 1)
    if (Dir.isdirectory (files[i]))
      Path.walk (files[i], NULL, &file_callback;fargs = {list, MED_AUD_EXT});
    else
      () = file_callback (files[i], NULL, list, MED_AUD_EXT);

  ifnot (length (list))
    return;

  list = list_to_array (list);

  if (NULL == noranded)
    {
    variable ar = Rand.int_array_uniq (1, length (list), length (list));
    ifnot (NULL == ar)
      {
      ar--;
      list = list[ar];
      }
    }
  else
    list = list[array_sort (list)];

  CUR_PLAYLIST = list;

  () = File.write (MED_LIST, list);
  () = write (MED_FD, "loadlist " + MED_LIST + "\n");
  __write_info__;
  __write_lyric__ (;usecur);
}

% there is a bug somewhere in the toolchain
% fails (and hangs (aparrently with no reason)) when "pt_step 1"
% is written later in the fifo 
private define play_video (argv)
{
  if (1 == length (argv))
    return;

  variable noranded = Opt.Arg.exists ("--no-random", &argv;del_arg);

  variable files = argv[[1:]];
  variable list = {};
  variable i;

  _for i (0, length (files) - 1)
    if (Dir.isdirectory (files[i]))
      Path.walk (files[i], NULL, &file_callback;fargs = {list, MED_VID_EXT});
    else
      () = file_callback (files[i], NULL, list, MED_VID_EXT);

  ifnot (length (list))
    return;

  list = list_to_array (list);

  if (NULL == noranded)
    {
    variable ar = Rand.int_array_uniq (1, length (list), length (list));
    ifnot (NULL == ar)
      {
      ar--;
      list = list[ar];
      }
    }
  else
    list = list[array_sort (list)];

  CUR_PLAYLIST = list;

  () = File.write (MED_LIST, list);
  () = write (MED_FD, "loadlist " + MED_LIST + "\n");
  __write_info__;
}

private define __show_list (argv)
{
  () = File.copy (MED_LIST, SCRATCH);
  __scratch (NULL);
}

private define __prev (argv)
{
  () = write (MED_FD, "pt_step -1\n");
}

private define __next (argv)
{
  () = write (MED_FD, "pt_step 1\n");
}

private define __pause (argv)
{
  () = write (MED_FD, "pause\n");
}

private define __stop (argv)
{
  () = write (MED_FD, "stop\n");
}

private define __seek (argv)
{
  () = write (MED_FD, "seek " + (argv[0] == "forward" ? "+" : "-")
     + "14\n");
}

private define _lyric_up (argv)
{
  variable lyricbuf = Ved.get_frame_buf (0);
  lyricbuf.ptr[0] = lyricbuf.vlins[0];
  Ved.Pager.up (lyricbuf);
}

private define _lyric_down (argv)
{
  variable lyricbuf = Ved.get_frame_buf (0);
  lyricbuf.ptr[0] = lyricbuf.vlins[-1];
  Ved.Pager.down (lyricbuf);
}

private define _volume_down (argv)
{
  Hw.volume_down ();
}

private define _volume_up (argv)
{
  Hw.volume_up ();
}

private define my_commands ()
{
  variable a = init_commands ();

  a["videoplay"] = @Argvlist_Type;
  a["videoplay"].func = &play_video;
  a["videoplay"].args = ["--no-random void don't play files randomly, default yes"];

  a["audioplay"] = @Argvlist_Type;
  a["audioplay"].func = &play_audio;
  a["audioplay"].args = ["--no-random void don't play files randomly, default yes"];

  a["playlist"] = @Argvlist_Type;
  a["playlist"].func = &__show_list;

  a["pause"] = @Argvlist_Type;
  a["pause"].func = &__pause;

  a["next"] = @Argvlist_Type;
  a["next"].func = &__next;

  a["prev"] = @Argvlist_Type;
  a["prev"].func = &__prev;

  a["stop"] = @Argvlist_Type;
  a["stop"].func = &__stop;

  a["forward"] = @Argvlist_Type;
  a["forward"].func = &__seek;

  a["backward"] = @Argvlist_Type;
  a["backward"].func = &__seek;

  a["redisplay"] = @Argvlist_Type;
  a["redisplay"].func = &redisplay;

  a["lyrics_down"] = @Argvlist_Type;
  a["lyrics_down"].func = &_lyric_down;

  a["lyrics_up"] = @Argvlist_Type;
  a["lyrics_up"].func = &_lyric_up;

  a["9"] = @Argvlist_Type;
  a["9"].func = &_volume_down;

  a["0"] = @Argvlist_Type;
  a["0"].func = &_volume_up;

  a;
}

private define starthook (s)
{
  if (s._ind || s._col != 1)
    return -1;

  ifnot (NULL == s.argv)
    if (1 == length (s.argv))
      ifnot (strlen (s.argv[0]))
        if (any (['f', 'b', ' ', 'p', 'n', 'r', Input->PPAGE, Input->ESC_up, 'k',
             Input->NPAGE, Input->ESC_down, 'j', '9', '0', 'l', 'a'] == s._chr))
          {
          s.argv[0] = [
            "forward", "backward",  "pause",  "prev", "next",
            "redisplay", "lyrics_up", "lyrics_up", "lyrics_up",
            "lyrics_down", "lyrics_down", "lyrics_down", "9", "0", "playlist", "audioplay"]
            [wherefirst (s._chr == ['f', 'b', ' ', 'p', 'n', 'r', Input->PPAGE,
             Input->ESC_up, 'k', Input->NPAGE, Input->ESC_down, 'j', '9', '0',
             'l', 'a'])];

          if (s.argv[0] == "audioplay")
            {
            s._col = strlen ("audioplay") + 2 + strlen (MED_AUD_DIR[0]);
            s.argv = [s.argv, MED_AUD_DIR[0]];
            Rline.parse_args (NULL, s);
            Rline.prompt (NULL, s, s._lin, s._col);
            s._chr = '\t';
            return -1;
            }

          return 1;
          }

  if (any (s._chr == ['\t', 'q']))
    return -1;

  return 0;
}

public define rlineinit ()
{
  variable rl = Rline.init (&my_commands;;struct
    {
    @__qualifiers (),
    histfile = This.is.my.histfile,
    onnolength = &toplinedr,
    onnolengthargs = {""},
    starthook = &starthook,
    on_lang = &toplinedr,
    on_lang_args = {" -- " + This.is.my.name + " --"}
    });

  IARG = length (rl.history);

  rl;
}

private define __at_exit ()
{
  () = write (MED_FD, "quit\n");
  () = close (MED_FD);
  () = remove (MED_FIFO);
  _exit_ ();
}

This.at_exit = &__at_exit;