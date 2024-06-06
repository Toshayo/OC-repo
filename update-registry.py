#!/bin/python3
import json
import os


def get_pkg_files(pkg_path: str) -> list:
	items = []
	for pkg_item in os.scandir(pkg_path):
		if pkg_item.is_file() and pkg_item.name != 'info.json':
			items.append(pkg_path + '/' + pkg_item.name)
		elif pkg_item.is_dir():
			items += get_pkg_files(pkg_path + '/' + pkg_item.name)
	return items


if __name__ == '__main__':
	known_programs = []
	with open('programs.cfg', 'w') as registry:
		registry.write('{\n')

		is_first = True
		for item in os.scandir('.'):
			if item.is_dir() and not item.name.startswith('.'):
				if not os.path.exists(os.path.join(item.path, 'info.json')):
					print('Invalid package "' + item.name + '"')
					continue
				with open(os.path.join(item.path, 'info.json')) as pkg_info_file:
					pkg_info = json.load(pkg_info_file)
				if pkg_info['id'] in known_programs:
					print('Program ' + pkg_info['id'] + ' already registered! Skipping!')
					continue
				known_programs.append(pkg_info['id'])
				if is_first:
					is_first = False
				else:
					registry.write(',\n')
				registry.write('\t["' + pkg_info['id'] + '"] = {\n')
				for key, value in pkg_info.items():
					if key == 'id':
						continue
					registry.write(f'\t\t{key} = "{value}",\n')
				registry.write('\t\tfiles = {\n')
				pkg_files = get_pkg_files(item.name)
				pkg_files_cnt = len(pkg_files)
				for i, file in enumerate(pkg_files):
					registry.write(f'\t\t\t["master/{file}"] = "{file[len(item.name):]}"')
					if i < pkg_files_cnt:
						registry.write(',')
					registry.write('\n')
				registry.write('\t\t}\n\t}')
		registry.write('\n}\n')
