Map<String, dynamic> generateAuthAccessTokenPayload({
  required int authId,
  required int playerId,
}) {
  return {
    "authId": authId,
    "playerId": playerId,
  };
}

// TODO this is not needed
  // TODO this will need to be tested