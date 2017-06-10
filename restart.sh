while true
do
  echo "Pulling that rad code"
  git pull origin master

  echo "Booting up the bot"
  crystal code.cr
done
