class Node {
  late final String id;
  late final double temperature;
  late final double humidity;
  late final int gas;
  late final double sound;
  late final int dust;
  late final String imageUrl;


  Node({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.gas,
    required this.sound,
    required this.dust,
    required this.imageUrl,
  });
    factory Node.fromJson(dynamic json) {
    return Node(
      id: json['id'] as String,
      temperature: json ['DHT11']['Temperature'] as double,
      humidity: json ['DHT11']['Humidity'] as double,
      gas: json['MQ135'] ['Value'] as int,
      sound: json['SoundSensor'] ['Value'] as double,
      dust: json['GP2Y1010AU0F'] ['Value'] as int,
      imageUrl: json['imageUrl'] as String,
    )
    ;
    }
    static List<Node> fromJsonList(List list) {
    return list.map((item) => Node.fromJson(item)).toList();
    }
    /*
    @override
     String toString() {
    return 'Node{id: $id, temperature: $temperature, humidity: $humidity, gas: $gas, sound: $sound, dust: $dust}';
    }

     */
}