CSS_DIR = static/css/
STYLUS_DIR = static/stylus/
JS_DIR = static/js/
COFFEE_DIR = static/coffee/

.PHONY: all css js pub release clean
all: js css
css:
	node ~/node_modules/stylus/bin/stylus -c -o ${CSS_DIR} ${STYLUS_DIR}zx.styl
	node ~/node_modules/stylus/bin/stylus -c -o ${CSS_DIR} ${STYLUS_DIR}zc.styl

js:
	node ~/node_modules/coffee-script/bin/coffee -o ${JS_DIR} -cb ${COFFEE_DIR}*.coffee

put:
	rsync -avz ./static/ nimei.org:/home/liszt/work/zx/static 
	rsync -avz ./zx/ nimei.org:/home/liszt/work/zx/zx 
	rsync -avz ./zc/ nimei.org:/home/liszt/work/zx/zc
	rsync -avz ./wp-content/plugins/ nimei.org:/home/liszt/work/zx/wp-content/plugins
	rsync -avz ./index.html nimei.org:/home/liszt/work/zx/
	rsync -avz ./Makefile nimei.org:/home/liszt/work/zx/
online:
	rsync -avz ./index.html zhangs.me:/home/liszt/work/zhangs/
	rsync -avz ./static/ zhangs.me:/home/liszt/work/zhangs/static 

	rsync -avz ./static/ zhangs.me:/home/liszt/work/zx/static 
	rsync -avz ./zx/ zhangs.me:/home/liszt/work/zx/zx 
	rsync -avz ./zc/ zhangs.me:/home/liszt/work/zx/zc
	rsync -avz ./wp-content/plugins/ zhangs.me:/home/liszt/work/zx/wp-content/plugins
	rsync -avz ./zx/index.html zhangs.me:/home/liszt/work/zx/

	rsync -avz ./static/ zhangs.me:/home/liszt/work/zc/static 
	rsync -avz ./zx/ zhangs.me:/home/liszt/work/zc/zx 
	rsync -avz ./zc/ zhangs.me:/home/liszt/work/zc/zc
	rsync -avz ./wp-content/plugins/ zhangs.me:/home/liszt/work/zc/wp-content/plugins
	rsync -avz ./zc/index.html zhangs.me:/home/liszt/work/zc/
pub:put
	git push origin master
release:
	- rm -rf release/*
	tar --exclude release --exclude design --exclude coffee --exclude stylus --exclude uploads/imgs --exclude logs --exclude=user_guide -czvf release/dp.tar.gz * >/dev/null 2>&1
relver:
	ts=`date +%s` && sed -ie "s/\(.*?relver=\)[^\"]*\(\".*$$\)/\1$${ts}\2/g" static/*.html 
clean:
	- rm release/*
