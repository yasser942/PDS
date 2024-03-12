class Channel {
  final int id;
  final String name;
  final String description;
  final String latitude;
  final String longitude;
  final String field1;
  final String field2;
  final String field3;
  final String field4;
  final String field5;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String elevation;
  final int lastEntryId;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.field1,
    required this.field2,
    required this.field3,
    required this.field4,
    required this.field5,
    required this.createdAt,
    required this.updatedAt,
    required this.elevation,
    required this.lastEntryId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['channel']['id'],
      name: json['channel']['name'],
      description: json['channel']['description'],
      latitude: json['channel']['latitude'],
      longitude: json['channel']['longitude'],
      field1: json['channel']['field1'],
      field2: json['channel']['field2'],
      field3: json['channel']['field3'],
      field4: json['channel']['field4'],
      field5: json['channel']['field5'],
      createdAt: DateTime.parse(json['channel']['created_at']),
      updatedAt: DateTime.parse(json['channel']['updated_at']),
      elevation: json['channel']['elevation'],
      lastEntryId: json['channel']['last_entry_id'],
    );
  }
}

class Feed {
  final DateTime createdAt;
  final int entryId;
  final double? field1;

  Feed({
    required this.createdAt,
    required this.entryId,
    required this.field1,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      createdAt: DateTime.parse(json['created_at']),
      entryId: json['entry_id'],
      field1: json['field1'] != null ? double.parse(json['field1']) : null,
    );
  }
}