all: preview

gendoc = ../docs-generated

build:
	mkdocs build --config-file $(gendoc)/mkdocs.yml

deploy-origin:
	mkdocs gh-deploy --force --remote-name origin --config-file $(gendoc)/mkdocs.yml

#deploy-upstream:
#	mkdocs gh-deploy --force --remote-name upstream --config-file $(gendoc)/mkdocs.yml

check test:
	mkdocs build --strict --config-file $(gendoc)/mkdocs.yml

serve preview:
	mkdocs serve --config-file $(gendoc)/mkdocs.yml
