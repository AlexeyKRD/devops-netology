import json
import yaml
import os

file = 'bad.yaml'
file_name = os.path.splitext(file)[0]
# print(file_name)
is_json = True
is_yaml = True
error = ''

file = input('Enter file name: ')
if os.path.isfile(file):
    with open(file, 'r') as o_file:
        try:
            dict = json.load(o_file)
            # print(dict)
        except Exception as err:
            # print(file + ' - NOT json file')
            # print(type(err))
            # print(err.args)
            error += '\nError open JSON file: ' + str(err)
            is_json = False
    with open(file, 'r') as o_file:
        try:
            dict = yaml.safe_load(o_file)
            # print(dict)
        except Exception as err:
            # print(file + ' - NOT yaml file')
            # print(type(err))
            # print(err.args)
            error += '\nError open YAML file: ' + str(err)
            is_yaml = False
    if is_json:
        print('create file: re_'+ file_name + '.yaml')
        with open('re_' + file_name + '.yaml', 'w') as yml_file:
            yml_file.write(yaml.dump(dict, indent=2))
    elif is_yaml:
        print('create file: re_'+ file_name + '.json')
        with open('re_' + file_name + '.json', 'w') as jsn_file:
            jsn_file.write(json.dumps(dict, indent=2))
    else:
        print('NOT json AND yaml file' + error)
else:
    print(file + ' - DOES not exist')
