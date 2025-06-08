
# 制作GPX OVERLAY MAP GPX生成路网
## 使用方法
### 环境配置
#### 1. Windows在应用商店安装ubuntu 22.04或者24.04，进入ubuntu系统
#### 2. 安装java 21, osmium tool，osmosis以及mapsforge插件
```bash	     
sudo apt install openjdk-21-jdk
sudo apt install osmium-tool
sudo apt install osmosis 
wget https://repo1.maven.org/maven2/org/mapsforge/mapsforge-map-writer/0.25.0/mapsforge-map-writer-0.25.0-jar-with-dependencies.jar
mkdir -p ~/.openstreetmap/osmosis/plugins/
mv mapsforge-map-writer-0.25.0-jar-with-dependencies.jar ~/.openstreetmap/osmosis/plugins/
```		
#### 3. 可通过修改`GPX2OSM.awk`文件中的tag，修改或添加更多tag，适配不同的风格文件，此处只提供一个v3版本的风格文件，来自大海路网

### 生成map
解压本压缩包，进入文件夹，比如放在文档目录。将需要合并的gpx文件放到gpx_files下面，单个文件也可以，修改`batch_gpx_to_map.sh`中的`BBOX`和`style`选项，分别控制地图的范围(覆盖整个路网的区域就可以，不需要太大)和mapsforge版本(默认v3版本)。运行如下命令，生成合并后的merge.pbf.map文件，可自定义修改为自己想取的名字。

```bash
cd /mnt/c/User/XXXXXX/Documents/gpx_to_map/
chmod +x batch_gpx_to_map.sh
./batch_gpx_to_map.sh
mv merge.pbf.map xxx.map
```
### locus map显示
拷贝生成的`xxx.map`文件到`Locus Map`的`mapsVector`文件夹，将`style_file/v3`下的风格压缩包拷贝到`mapsVector/_themes`文件夹，重新启动`Locus Map`，选择拷贝的离线地图，然后风格文件选择拷贝的风格压缩包，选中风格选项里自定义轨迹中的一个颜色选项即可。

