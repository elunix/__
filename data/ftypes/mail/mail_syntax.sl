private variable colors = [
%headers
  3,
  4,
  6,
  5,
  3,
  5,
];

private variable regexps = [
%comments
  pcre_compile ("\
^(From|To|Cc|Bcc|Subject|(In-)?Reply-To|X-Operating-System\
|(X-)?Mailer|Message-I[Dd]|Organization|Date|User-Agent\
|Mail-Followup-To):(?=\s)"R, 0),
  pcre_compile ("(^>($| ).*)", 0),
  pcre_compile ("(^>>($| ).*)", 0),
  pcre_compile ("(^>>>($| ).*)", 0),
  pcre_compile ("(^>>>>($| ).*)", 0),
  pcre_compile ("(^(> )?--\s?)"R, 0)
  ];

define mail_lexicalhl (s, lines, vlines)
{
  __hl_groups (s, lines, vlines, colors, regexps);
}
