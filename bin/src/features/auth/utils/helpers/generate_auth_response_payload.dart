Map<String, Object> generateAuthOkResponseData({
  required int playerId,
  required String playerName,
  required String playerNickname,
}) {
  return {
    "id": playerId,
    "name": playerName,
    "nickname": playerNickname,
  };

// TODO not a standard
  // return {
  //   "ok": true,
  //   "data": {
  //     "id": playerId,
  //     "name": playerName,
  //     "nickname": playerNickname,
  //   },
  //   "message": "User authenticated successfully.",
  // };
}
