class AppState {
  final bool isFirstRun;
  final bool userExists;
  final bool isUserRemoved;
  final bool isUpdateAvailable;
  final bool isForcedUpdate;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final bool isConnected;
  final bool serverUnderMaintenance;
  final bool splashPage;

  AppState({
    this.isFirstRun = false,
    this.userExists = false,
    this.isUserRemoved = false,
    this.isUpdateAvailable = false,
    this.isForcedUpdate = false,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.isConnected = true,
    this.serverUnderMaintenance = false,
    this.splashPage = false,
  });

  AppState copyWith({
    bool? isFirstRun,
    bool? userExists,
    bool? isUserRemoved,
    bool? isUpdateAvailable,
    bool? isForcedUpdate,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? isConnected,
    bool? serverUnderMaintenance,
    bool? splashPage,
  }) {
    return AppState(
      isFirstRun: isFirstRun ?? this.isFirstRun,
      userExists: userExists ?? this.userExists,
      isUserRemoved: isUserRemoved ?? this.isUserRemoved,
      isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
      isForcedUpdate: isForcedUpdate ?? this.isForcedUpdate,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      isConnected: isConnected ?? this.isConnected,
      serverUnderMaintenance:
          serverUnderMaintenance ?? this.serverUnderMaintenance,
      splashPage: splashPage ?? this.splashPage,
    );
  }
}
