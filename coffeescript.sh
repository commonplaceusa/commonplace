for FILENAME in `find . -name "*.js"` do
	js2coffee $FILENAME > ${FILENAME/%js/coffee}
