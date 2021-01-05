#!/bin/bash
GREEN='\033[1;32m'
if [[ "$VIRTUAL_ENV" != "" ]]
then
    echo "Running in virtual environment already, deactivating current python venv"
    source $VIRTUAL_ENV/bin/activate
    deactivate
else
  echo "No virtual environment found, continuing with setup"
fi
echo -e "${GREEN}Step 1 of 3 - Setting up python virtual environment and Ansible prerequisites..."
mkdir -p $HOME/venv/pihole
python3 -m venv $HOME/venv/pihole
source $HOME/venv/pihole/bin/activate
pip install wheel > /dev/null
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U > /dev/null
pip install -r ./requirements.txt > /dev/null
export ANSIBLE_STRATEGY_PLUGINS=$HOME/venv/pihole/lib/python3.8/site-packages/ansible_mitogen/plugins/strategy
export ANSIBLE_STRATEGY=mitogen_linear
echo -e "${GREEN}Step 2 of 3 - Initial setup complete, running Ansible playbook..."
ansible-playbook ./setup_pihole.yml

echo -e "${GREEN}Step 3 of 3 - Setup complete, cleaning up venv directories..."
deactivate
rm -rf $HOME/venv/pihole