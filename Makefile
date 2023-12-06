all: preview

gendoc = docs-generated
buildscript = scripts/build_docs.sh

clean-gen:
	/bin/rm -rf $(gendoc)

rebuild-gen:
	$(buildscript)

build: clean-gen rebuild-gen
	mkdocs build --config-file $(gendoc)/mkdocs.yml

deploy-origin: clean-gen rebuild-gen
	mkdocs gh-deploy --force --remote-name origin --config-file $(gendoc)/mkdocs.yml

deploy-upstream: clean-gen rebuild-gen
	mkdocs gh-deploy --force --remote-name upstream --config-file $(gendoc)/mkdocs.yml

check test: clean-gen rebuild-gen
	mkdocs build --strict --config-file $(gendoc)/mkdocs.yml

serve preview: clean-gen rebuild-gen
	mkdocs serve --config-file $(gendoc)/mkdocs.yml


