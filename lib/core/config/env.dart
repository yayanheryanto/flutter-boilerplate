enum Environment {
  dev('dev'),
  stag('stag'),
  prod('prod');

  final String name;
  const Environment(this.name);
}
