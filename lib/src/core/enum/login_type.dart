enum LoginType {
  normal('normal'),
  google('google'),
  apple('apple');

  final String name;
  const LoginType(this.name);
}
