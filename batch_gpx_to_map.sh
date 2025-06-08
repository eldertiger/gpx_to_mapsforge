#!/bin/bash

# 设置变量
GPX_DIR="./gpx_files"        # 存放 GPX 文件的目录
TMP_OSM_DIR="./tmp_osm"      # 临时存放 OSM 文件
MERGED_OSM="./merged.osm"    # 合并前的中间 OSM 文件
MERGED_PBF="./merged.pbf"    # 输出的 PBF 文件
BBOX="31,117,32,118"         # 地图边界框（纬度，经度）
STYLE="v3"                   # 样式/风格

# 清理旧的临时文件
rm -rf "$TMP_OSM_DIR"
mkdir -p "$TMP_OSM_DIR"

echo "🚀 开始批量转换 GPX 文件..."

# 步骤 1：转换每个 .gpx 文件为 .osm 并重编号
i=1
for GPX_FILE in "$GPX_DIR"/*.gpx; do
    BASENAME=$(basename "$GPX_FILE" .gpx)
    OSM_FILE="$TMP_OSM_DIR/${BASENAME}.osm"
    RENUM_FILE="$TMP_OSM_DIR/${BASENAME}_renum.osm"

    echo "📍 处理 $GPX_FILE → $OSM_FILE"
    awk -f GPX2OSM.awk "$GPX_FILE" > "$OSM_FILE"

    # 给每个文件分配唯一 ID 起点（例如每个文件增量100000）
    NODE_START=$((i * 100000))
    WAY_START=$((i * 100000))
    REL_START=$((i * 100000))

    osmium renumber -s $NODE_START,$WAY_START,$REL_START "$OSM_FILE" -o "$RENUM_FILE" --overwrite
    i=$((i + 1))
done

# 步骤 2：合并所有 .osm 文件为一个 .pbf 文件
echo "🔀 合并所有 OSM 文件为 $MERGED_PBF..."
osmium merge "$TMP_OSM_DIR"/*_renum.osm -o "$MERGED_PBF" --overwrite

# 步骤 3：调用 pbf2map.sh 生成地图
echo "🗺️ 生成地图..."
./pbf2map.sh "$MERGED_PBF" "$BBOX" "$STYLE"
rm "$MERGED_PBF"
rm -rf "$TMP_OSM_DIR"
echo "✅ 全部完成！地图已生成。"
