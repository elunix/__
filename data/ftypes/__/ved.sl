public define ___ved (s, fname)
{
  ___settype (s, fname, VED_ROWS, NULL);

  Ved.setbuf (s._abspath);

  Ved.write_prompt (" ", 0);

  s.draw ();

  Ved.preloop (s);

  toplinedr (" -- pager --");

  s.vedloop ();
}