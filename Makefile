# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)

all:  clean
	mkdir --parents $(PWD)/build/Boilerplate.AppDir
	apprepo --destination=$(PWD)/build appdir boilerplate libatk1.0-0 libatk-bridge2.0-0 libgtk2.0-0 libpangoxft-1.0-0 libprotobuf-c1 breeze-gtk-theme
	
	wget --output-document=$(PWD)/build/build.tar.gz https://22549-30791823-gh.circle-artifacts.com/0/linux/_CPack_Packages/Linux/TGZ/navit.tar.gz
	tar -xf $(PWD)/build/build.tar.gz -C $(PWD)/build

	
	echo '' 										>> $(PWD)/build/Boilerplate.AppDir/AppRun	
	echo '' 										>> $(PWD)/build/Boilerplate.AppDir/AppRun			
	echo 'case "$${1}" in' 					        			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    "--maptool") exec $${APPDIR}/bin/maptool  $${@:2} ;;' 			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    *)           exec $${APPDIR}/bin/navit    $${@}   ;;' 			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'esac' 						        			>> $(PWD)/build/Boilerplate.AppDir/AppRun
	
	
	cp --force --recursive $(PWD)/build/navit/bin/* 	$(PWD)/build/Boilerplate.AppDir/bin
	cp --force --recursive $(PWD)/build/navit/lib64/* 	$(PWD)/build/Boilerplate.AppDir/lib64
	cp --force --recursive $(PWD)/build/navit/share/* 	$(PWD)/build/Boilerplate.AppDir/share
	cp --force --recursive $(PWD)/AppDir/*.xml 		$(PWD)/build/Boilerplate.AppDir/share/navit

	cp --force $(PWD)/AppDir/*.png 		$(PWD)/build/Boilerplate.AppDir/ 	|| true
	cp --force $(PWD)/AppDir/*.desktop 	$(PWD)/build/Boilerplate.AppDir/	|| true
	cp --force $(PWD)/AppDir/*.svg 		$(PWD)/build/Boilerplate.AppDir/ 	|| true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/Navit.AppImage
	chmod +x $(PWD)/Navit.AppImage


clean:
	rm -rf $(PWD)/build
