
/// A CredentialsProvider has a method to fetch an authorization token.
abstract class CredentialsProvider<T> {

  /// Requests token for the current user. Use [invalidateToken] to force-refresh the token.
  ///
  /// Returns a [Future] that will be completed with the current token.
  Future<String> getToken();

  /// Marks the last retrieved token as invalid, making the next [getToken] request force
  /// refresh the token.
  void invalidateToken();

  /// Sets the listener to be notified of credential changes (sign-in / sign-out, token changes). It
  /// is immediately called once with the initial user.
  void setChangeListener(Listener<T> changeListener);

  /// Removes the listener set with [setChangeListener].
  void removeChangeListener();
}