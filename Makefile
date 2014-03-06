CSS_DIR = static/css/
STYLUS_DIR = static/stylus/
JS_DIR = static/js/
COFFEE_DIR = static/coffee/

.PHONY: all css js pub release clean
all: js css
css:
	node ~/node_modules/stylus/bin/stylus -c -o ${CSS_DIR} ${STYLUS_DIR}*.styl

js:
	node ~/node_modules/coffee-script/bin/coffee -o ${JS_DIR} -cb ${COFFEE_DIR}*.coffee

pub:
	rsync -avz ./static/ nimei.org:/home/liszt/work/zx/static 
	rsync -avz ./wp-content/plugins/ nimei.org:/home/liszt/work/zx/wp-content/plugins
	rsync -avz ./index.html nimei.org:/home/liszt/work/zx/

release:
	- rm -rf release/*
	tar --exclude release --exclude design --exclude coffee --exclude stylus --exclude uploads/imgs --exclude logs --exclude=user_guide -czvf release/dp.tar.gz * >/dev/null 2>&1
relver:
	ts=`date +%s` && sed -ie "s/\(.*?relver=\)[^\"]*\(\".*$$\)/\1$${ts}\2/g" static/*.html 
clean:
	- rm release/*
