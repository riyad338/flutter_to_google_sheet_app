class Userfields {
  static final String date = 'Date';
  static final String mode = 'Mode';
  static final String entry = 'Entry';
  static final String cost = 'Cost';
  static List<String> getfields() => [date, mode, entry, cost];
}

class User {
  final String date;
  final String mode;
  final String entry;
  final String cost;
  const User({
    required this.date,
    required this.mode,
    required this.entry,
    required this.cost,
  });
  static User fromjson(Map<String, dynamic> json) => User(
        date: json[Userfields.date],
        mode: json[Userfields.mode],
        entry: json[Userfields.entry],
        cost: json[Userfields.cost],
      );
  Map<String, dynamic> toJson() => {
        Userfields.date: date,
        Userfields.mode: mode,
        Userfields.entry: entry,
        Userfields.cost: cost,
      };
}
