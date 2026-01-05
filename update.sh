#!/bin/bash
# backup.sh
source /opt/venv/djangoEnv/bin/activate

#———————————————————————————————————————— update svija

clear
printf "\nUpdating Svija Cloud\n\n"
pip install git+ssh://git@github.com/svijalove/cloud.git@stable#egg=django-svija --upgrade
printf "\n————— Svija updated"
printf "\n————————————————————————————————————————————————————————————————————————————————\n"

#———————————————————————————————————————— update svija

#   current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#   cd "$current_dir"
#   printf "\n————— cd $current_dir"

while IFS= read -r site_folder; do

  cd /home/$site_folder
  printf "\n————— cd $site_folder/\n\n"

  ./manage.py migrate
  printf "\n————— $site_folder migrated\n"

  printf "\n————— collectstatic"
  ./manage.py collectstatic --noinput

# printf "\n————— loading fixtures\n"
# ./manage.py loaddata ../cloud-update/fixture-cloud-modules.json
# ./manage.py loaddata ../cloud-update/fixture-cloud-module-scripts.json

  printf "\n\n————————————————————————————————————————————————————————————————————————————————\n"
  
done < /opt/sitelist.txt

#———————————————————————————————————————— uwsgi

printf "\n————— restarting uwsgi..."
sudo service uwsgi restart

#———————————————————————————————————————— clean up

deactivate
cd /opt && rm -rf cloud-update
printf "\n————— updates complete.\n\n"

#———————————————————————————————————————— fin
