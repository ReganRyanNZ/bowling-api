# Bowling API

This API is able to run games of ten pin bowling.

## Quick reference

* `POST /games` will create a new game and return the game's id.
```
{"game_id":6}
```
* `POST /games/6/players?name=Batman` will create a new player for game `6` and set the player's name to `Batman`.
```
{
  "id":13,
  "game_id":6,
  "name":"Batman",
  "created_at":"2019-04-15T12:08:01.737Z",
  "updated_at":"2019-04-15T12:08:01.737Z",
  "score":""
}
```
* `PUT /games/6?ball_score=8` will update game `6` to say that 8 pins were knocked down with the most recent ball. It returns the player's current score for all frames in the game thus far.
```
{"new_score":"8\n"}
```
* `GET /games/6` will return the current scores for each player, their total score, whether the game is complete, and the current frame and turn for the next player to bowl. This is in human-readable format, so the player is referenced by name, and the frame number is referenced on a 1-10 scale.
```
{"scores":{"Batman":{"frames":"5,4\n6\n","total":22}},"current_turn":"Batman","current_frame":2,"game_complete":false}
```
