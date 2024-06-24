class SeizureEvent {
  final String userId;
  final String date;
  final String awareness;
  final String bodySeizure;
  final String movement;
  final String jerkingMovement;
  final String stiffness;
  final String eyes;
  final String possibleTriggers;
  final String? duration;
  final String? eventTime;
  final String? movimento;

  SeizureEvent({
    required this.userId,
    required this.date,
    required this.awareness,
    required this.bodySeizure,
    required this.movement,
    required this.jerkingMovement,
    required this.stiffness,
    required this.eyes,
    required this.possibleTriggers,
    this.duration,
    this.eventTime,
    required this.movimento
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'awareness': awareness,
      'bodySeizure': bodySeizure,
      'movement': movement,
      'jerkingMovement': jerkingMovement,
      'stiffness': stiffness,
      'eyes': eyes,
      'possibleTriggers': possibleTriggers,
      'duration': duration,
      'eventTime': eventTime,
      'automatic': movimento
    };
  }
}
