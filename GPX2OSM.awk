# usage: awk -f GPX2OSM.awk input.gpx > output.osm

BEGIN {
    FS = "[ \"<>]"
    node_id = 0
    way_id = 0
    printf "<?xml version='1.0' encoding='UTF-8'?>\n"
    printf "<osm version='0.6' upload='false' generator='awk'>\n"
}

# 处理 <trkpt> 标签
/<trkpt / {
    lat = ""; lon = ""
    for (i = 1; i <= NF; i++) {
        if ($i == "lat") lat = $(i+1)
        if ($i == "lon") lon = $(i+1)
    }
    node_id++
    nodes[node_id] = sprintf("  <node id='%d' lat='%s' lon='%s'/>\n", node_id, lat, lon)
    nodes_in_way[node_count++] = node_id
}

# 处理 <trk> 标签
/<trk>/ {
    way_id++
    node_count = 0
}

# 处理 </trk> 标签
/<\/trk>/ {
    if (node_count > 0) {
        way[way_id] = sprintf("  <way id='-%d'>\n", way_id)
        for (i = 0; i < node_count; i++) {
            way[way_id] = way[way_id] sprintf("    <nd ref='%d'/>\n", nodes_in_way[i])
        }
        way[way_id] = way[way_id] \
            "    <tag k='gpx' v='trk'/>\n" \
            # "    <tag k='tracknet' v='zhushou|mixture'/>\n" \ # add more tags to suit your own style files
            "  </way>\n"
    }
}

END {
    for (i = 1; i <= node_id; i++) {
        printf "%s", nodes[i]
    }
    for (i = 1; i <= way_id; i++) {
        printf "%s", way[i]
    }
    print "</osm>"
}
