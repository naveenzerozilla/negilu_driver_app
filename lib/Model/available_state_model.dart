class AvailabilityState {
  final bool isOnline;
  final List<dynamic> inProgressBookings;
  final List<dynamic> completedBookings;

  AvailabilityState({
    this.isOnline = false,
    this.inProgressBookings = const [],
    this.completedBookings = const [],
  });

  AvailabilityState copyWith({
    bool? isOnline,
    List<dynamic>? inProgressBookings,
    List<dynamic>? completedBookings,
  }) {
    return AvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      inProgressBookings:
      inProgressBookings ?? this.inProgressBookings,
      completedBookings:
      completedBookings ?? this.completedBookings,
    );
  }
}
