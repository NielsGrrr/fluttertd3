import 'user.dart'; // 👈 On importe la classe User que tu as déjà créée !

class Poll {
  Poll({
    required this.id,
    required this.name,
    required this.description,
    this.imageName,
    this.eventDate,
    this.user,
  });

  int id;
  String name;
  String description;
  String? imageName;
  DateTime? eventDate;
  User? user; // 👈 Le créateur de l'événement

  Poll.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as int,
          name: json['name'] as String,
          description: json['description'] as String,
          imageName: json['imageName'] as String?,
          // On utilise bien 'eventDate' comme indiqué dans le Swagger
          eventDate: json['eventDate'] != null 
              ? DateTime.parse(json['eventDate'] as String) 
              : null,
          // Si on reçoit un utilisateur, on le transforme en objet User !
          user: json['user'] != null 
              ? User.fromJson(json['user'] as Map<String, dynamic>) 
              : null,
        );
}