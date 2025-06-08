#!/bin/bash
# usage：
# ./pbf2map.sh xxx.osm  lat_s,lon_s,lat_e,lon_e v3/v5
# 定义变量
GPX_OSM=$1
GPX_BASE=$(basename "$GPX_OSM" .osm)
BBOX=$2
MAP_VER=$3
language="zh,en"
if [ "$MAP_VER" = "v3" ]; then
    echo "mapsforge version will be $MAP_VER"
    language="en"
fi
echo $MAP_VER
echo $language
# OSMOSIS_CMD="osmosis"  # 请根据实际情况修改
# TOOLS_DIR=tools
OSMOSIS_CMD="./osmosis-0.49.2/bin/osmosis"
OSMOSIS_CMD="osmosis"
MAPWITER_THREADS=8  # 根据需要设置线程数
VERSION="1.0"  # 请根据需要设置版本号

# 检查输入文件是否存在
if [ ! -f $GPX_OSM ]; then
    echo "Error: Input file $GPX_OSM does not exist."
    exit 1
fi

# 删除之前的文件
rm -f "${GPX_BASE}-sed.pbf" "${GPX_BASE}-ren.pbf"

# 运行 Python 脚本进行处理
# python3 osm_scripts/gpx_handler.py "$GPX_BASE_EXT" "${GPX_BASE}-sed.pbf"

# 执行 osmium renumber
# osmium renumber -s 1,1,0 "${GPX_BASE}-sed.pbf" -Oo "${GPX_BASE}-ren.pbf"

# # 检查 osmium renumber 的输出文件是否生成
# if [ ! -f "${GPX_BASE}-ren.pbf" ]; then
#     echo "Error: osmium renumber failed to produce ${GPX_BASE}-ren.pbf."
#     exit 1
# fi

# 执行 osmosis 合并命令
export JAVACMD_OPTIONS="-Xmx68G -server -Dfile.encoding=UTF-8" && \
    $OSMOSIS_CMD --read-pbf $GPX_OSM  --buffer --mapfile-writer   \
    type=ram threads=$MAPWITER_THREADS  bbox=$BBOX \
    tag-conf-file="gpx-mapping.xml"   \
    preferred-languages=$language \
    polygon-clipping=true  way-clipping=true  label-position=true zoom-interval-conf="6,0,6,10,7,11,14,12,21"  map-start-zoom="12"  \
    comment="$VERSION / (c) GPX: $(basename $GPX_BASE)"    file=${GPX_BASE}.map
echo "$OSMOSIS_CMD --read-pbf $GPX_OSM --buffer --mapfile-writer type=ram threads=$MAPWITER_THREADS bbox=$BBOX tag-conf-file=osm_scripts/gpx-mapping.xml polygon-clipping=true way-clipping=true label-position=true zoom-interval-conf=\"6,0,6,10,7,11,14,12,21\" map-start-zoom=\"12\" comment=$VERSION / (c) GPX: \$(basename \"$GPX_BASE\")\" file=${GPX_BASE}.map\""

# 检查合并结果文件是否生成
if [ ! -f "${GPX_BASE}.map" ]; then
    echo "Error: osmosis merge failed to produce ${GPX_BASE}.map."
    exit 1
fi

echo "Processing completed successfully."
