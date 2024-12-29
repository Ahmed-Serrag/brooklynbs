class BookExam {
  static final String ID = 'ID';
  static final String Group = 'Group';
  static final String Module = 'Module';
  static final String Date = 'Date';
  static final String Time = 'Time';
  static final String Branch = 'Branch';
  static final String Notes = 'Notes';

  static List<String> getFields() =>
      [ID, Group, Module, Date, Time, Branch, Notes];
}

class exam {
  final String ID;
  final String Group;
  final String Module;
  final String Date;
  final String Time;
  final String Branch;
  final String Notes;

  const exam({
    required this.ID,
    required this.Group,
    required this.Module,
    required this.Date,
    required this.Time,
    required this.Branch,
    required this.Notes,
  });

  exam copy({
    String? ID,
    String? Group,
    String? Module,
    String? Date,
    String? Time,
    String? Branch,
    String? Notes,
  }) =>
      exam(
          ID: ID ?? this.ID,
          Group: Group ?? this.Group,
          Module: Module ?? this.Module,
          Date: Date ?? this.Date,
          Time: Time ?? this.Time,
          Branch: Branch ?? this.Branch,
          Notes: Notes ?? this.Notes);

  Map<String, dynamic> toJson() => {
        BookExam.ID: ID,
        BookExam.Group: Group,
        BookExam.Module: Module,
        BookExam.Date: Date,
        BookExam.Time: Time,
        BookExam.Branch: Branch,
        BookExam.Notes: Notes,
      };
}
