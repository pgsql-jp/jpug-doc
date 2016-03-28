#!/bin/sh

FONTPATH1="/usr/share/fonts/truetype/takao-gothic/TakaoPGothic.ttf"
FONTNAME1="TakaoPGothic"
FONTPATH2="/usr/share/fonts/truetype/takao-gothic/TakaoGothic.ttf"
FONTNAME2="TakaoGothic"
FONTPATH3="/usr/share/fonts/truetype/takao-mincho/TakaoPMincho.ttf"
FONTNAME3="TakaoPMincho"

FOPCONF=$1

FONTMETRICS=".fontmetrics"

if [ $# -ne 1 ]
then
    echo "usage: fop-font.sh fop.xconf"
    exit 1
fi

fontgen() {
  path=$1
  name=$2

  result=`fop-ttfreader ${path} ${FONTMETRICS}/${name}.xml 2>/dev/null`
  ret=$?
  if [ ${ret} -ne 0 ]
  then
    return
  fi

  echo "        <font metrics-url=\"${FONTMETRICS}/${name}.xml\" kerning=\"yes\" embed-url=\"${path}\">"
  echo "          <font-triplet name=\"${name}\" style=\"normal\" weight=\"normal\"/>"
  echo "          <font-triplet name=\"${name}\" style=\"normal\" weight=\"bold\"/>"
  echo "          <font-triplet name=\"${name}\" style=\"italic\" weight=\"normal\"/>"
  echo "          <font-triplet name=\"${name}\" style=\"italic\" weight=\"bold\"/>"
  echo "        </font>"
}

fontsgen() {
  fontgen ${FONTPATH1} ${FONTNAME1}
  fontgen ${FONTPATH2} ${FONTNAME2}
  fontgen ${FONTPATH3} ${FONTNAME3}
}


fopgen() {
cat <<EOF
<?xml version="1.0" ?>
<fop version="1.0">
  <renderers>
    <renderer mime="application/pdf">
      <fonts>
EOF

fontsgen

cat <<EOF
        <auto-detect/>
      </fonts>
    </renderer>
  </renderers>
</fop>
EOF
}

if [ ! -d "${FONTMETRICS}" ]; then
	mkdir ${FONTMETRICS}
fi

fopgen > ${FOPCONF}
