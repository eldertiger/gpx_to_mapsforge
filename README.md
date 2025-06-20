# 制作GPX OVERLAY MAP 通过GPX文件生成路网

Simple scripts to convert GPX files to mapsforge for use in Locus Map and other Apps

## 使用方法 How to use
### 环境配置 Environment set
#### 1. Windows在应用商店安装ubuntu 22.04或者24.04，进入ubuntu系统

Install ubuntu 22.04 or 24.04 from windows store and login into ubuntu system.
#### 2. 安装java 21, osmium tool，osmosis以及mapsforge插件  

Install java 21, osmium tool，osmosis and mapsforge plugin
```bash	     
sudo apt install openjdk-21-jdk
sudo apt install osmium-tool
sudo apt install osmosis 
wget https://repo1.maven.org/maven2/org/mapsforge/mapsforge-map-writer/0.25.0/mapsforge-map-writer-0.25.0-jar-with-dependencies.jar
mkdir -p ~/.openstreetmap/osmosis/plugins/
mv mapsforge-map-writer-0.25.0-jar-with-dependencies.jar ~/.openstreetmap/osmosis/plugins/
```		
#### 3. 可通过修改`GPX2OSM.awk`文件中的tag，修改或添加更多tag，适配不同的风格文件，此处只提供一个v3版本的风格文件，来自大海路网

You can modify tags in GPX2OSM.awk file to suit other style files, here only a V3 style file from 大海 is provided.

### 生成map Generating Map

解压本压缩包或git clone到本地，进入文件夹，比如放在文档目录。新建gpx_files目录，将需要合并的gpx文件放到gpx_files下面，单个文件也可以，修改`batch_gpx_to_map.sh`中的`BBOX`和`style`选项，分别控制地图的范围(覆盖整个路网的区域就可以，不需要太大)和mapsforge版本(默认v3版本)。运行如下命令，生成合并后的merge.pbf.map文件，可自定义修改为自己想取的名字。

Unzip this repo or git clone it in dirctories like Documents. Newly build gpx_files directory, mv your own gpx files to gpx_files(one gpx is also supported). modify `BBOX` and `style` in `batch_gpx_to_map.sh` to conrtol map range and mapsforge edition(default v3).
run following command to generate the merge.pbf.map, change it's name to meet your own need.
```bash
cd /mnt/c/User/XXXXXX/Documents/gpx_to_map/
chmod +x batch_gpx_to_map.sh
./batch_gpx_to_map.sh
mv merge.pbf.map xxx.map
```
### locus map or other App
拷贝生成的`xxx.map`文件到`Locus Map`的`mapsVector`文件夹，将`style_file/v3`下的风格压缩包拷贝到`mapsVector/_themes`文件夹，重新启动`Locus Map`，选择拷贝的离线地图，然后风格文件选择拷贝的风格压缩包，选中风格选项里自定义轨迹中的一个颜色选项即可。

Copy generated`xxx.map` to `Locus Map`-`mapsVector`, copy `style_file/v3` style file to `mapsVector/_themes`, restart`Locus Map`，choose the merged map and choose the v3 style file, check one custom track option.
