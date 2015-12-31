#!/bin/sh
#  Use this file to run the Demandware documentation build. 
#  (c) Copyright Demandware. 2014 All Rights Reserved.
VER="16.1"

myhelp() {
	echo "build [target] [properties file] [warname] [lang]";
	echo "Example: bash build.sh info help DOC1 zh";
	echo "Parameter values:";
	echo "    [target] = type of help to build:";
	echo "        info - english infocenter"
	echo "        infotest - infocenter without javadoc/jdk";
	echo "        transtest - english content but translation filter";
	echo "        eclipse - eclipse help but not infocenter";
	echo "        web";
	echo "        xhtml";
	echo "        office - open office documents";
	echo "        all";
	echo "    [properties file] = name without extension of properties file.";
	echo "    [warname] = name of the war file produced";
	echo "    [lang] = two-letter language code:"; 
	echo "        en (english)";
	echo "        de (german)";
	echo "        it (italian)"; 
	echo "        ja (japanese)"; 
	echo "        zh (chinese)";
	echo " To rewar a file, use bash war.sh [warname]";
	exit
}
 if [ "$1" == "help" ]; then myhelp; fi
 if [ -n "$1" ]; then TARG=$1; else TARG="info"; fi
 if [ -n "$2" ]; then PROP=$2; else PROP="help"; fi
 if [ -n "$3" ]; then WARNAME=$3; else WARNAME="DOC1"; fi
 if [ -n "$4" ]; then LANG=$4; else LANG="en"; fi
 
#  echo "ver is $VER";
#  echo "target is $TARG";
#  echo "$PROP.properties";
#  echo "war is $WARNAME";
#  echo "lang is $LANG";

realpath() {
  case $1 in
    /*) echo "$1" ;;
    *) echo "$PWD/${1#./}" ;;
  esac
}

if [ "${DITA_HOME:+1}" = "1" ] && [ -e "$DITA_HOME" ]; then
  export DITA_DIR="$(realpath "$DITA_HOME")"
else #elif [ "${DITA_HOME:+1}" != "1" ]; then
  export DITA_DIR="$(dirname "$(realpath "$0")")"
fi

if [ -f "$DITA_DIR"/bin/ant ] && [ ! -x "$DITA_DIR"/bin/ant ]; then
  chmod +x "$DITA_DIR"/bin/ant
fi

export ANT_OPTS="-Xmx1024m $ANT_OPTS"
export ANT_OPTS="$ANT_OPTS -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"
export ANT_HOME="$DITA_DIR"
export PATH="$DITA_DIR"/bin:"$PATH"
export JAVA_OPTIONS="-Xms512m"

NEW_CLASSPATH="$DITA_DIR/lib/dost.jar"
NEW_CLASSPATH="$DITA_DIR/lib:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/commons-io-2.4.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/commons-codec-1.9.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/xml-resolver-1.2.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/icu4j-54.1.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/xercesImpl-2.11.0.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/xml-apis-1.4.01.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon-9.1.0.8.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon-9.1.0.8-dom.jar:$NEW_CLASSPATH"
if test -n "$CLASSPATH"; then
  export CLASSPATH="$NEW_CLASSPATH":"$CLASSPATH"
else
  export CLASSPATH="$NEW_CLASSPATH"
fi

#ant $1 -f build_dw.xml -Dproject.lang=$LANG -Dproject.ver=$VER -Dproject.war=$WARNAME -propertyfile properties/$2.properties -l log/$1.log

#bash prod.sh -a zh
#ant $1 -f prod.xml -Dproject.lang=$LANG -Dproject.ver=$VER -Dproject.war=$WARNAME -propertyfile properties/$2.properties -logger org.dita.dost.log.DITAOTBuildLogger production.build
#ant -f test.xml -Dproject.lang=$LANG -Dproject.war=$WARNAME -propertyfile properties/$2.properties -logger org.dita.dost.log.DITAOTBuildLogger
#ant -f test2.xml -Dproject.lang=$LANG -Dproject.war=$WARNAME -propertyfile properties/$2.properties -logger org.dita.dost.log.DITAOTBuildLogger
ant -f test.xml -propertyfile properties/test.properties
egrep -w 'FAILED|ERROR|WARN|INFO' ./log/$TARG.log 