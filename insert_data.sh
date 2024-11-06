#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

sed '1d' games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do

  win_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")"
  opp_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")"

  if [[ -z "$win_id"  ]]; then
    $PSQL "INSERT INTO teams (name) VALUES ('$winner')"
    win_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$winner'")"
  fi

    if [[ -z "$opp_id"  ]]; then
    $PSQL "INSERT INTO teams (name) VALUES ('$opponent')"
    opp_id="$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent'")"
  fi

  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $win_id, $opp_id, $winner_goals, $opponent_goals)"

done