 
                       M/Monit version 3.7.2
 
### M/Monit-3.7.2破解版本(无license),解压即可用
#### 自定义的M/Monit(如果需要)
假如自定义下载并解压后的M/Monit路径为：/opt/mmonit，找到本项目的patches文件夹
- 使用patches文件夹下的mmonit替换掉自定义的/opt/mmonit/bin/mmonit
- 使用patches文件夹下的libzild.so.0.0.0替换掉自定义的/opt/mmonit/lib/libzild.so.0.0.0

##### patches文件夹下文件说明
- mmonit——破解后的可执行文件
- libzild.so.0.0.0——破解后的库文件
- libzild.so.0.0.0.bsdiff.uue——未反编译的文件
- mmonit.bsdiff.uue——未反编译的文件

##### 破解步骤
1. brew install bsdiff
2. uudecode -o mmonit.bsdiff < mmonit.bsdiff.uue
3. uudecode -o libzild.so.0.0.0.bsdiff < libzild.so.0.0.0.bsdiff.uue
4. bspatch mmonit mmonit mmonit.bsdiff
5. bspatch libzild.so.0.0.0 libzild.so.0.0.0 libzild.so.0.0.0.bsdiff
6. 用反编译出来的mmonit、libzild.so.0.0.0替换掉原项目中的同名文件
7. chmod +x mmonit
其中6中的mmonit为官方项目中的mmonit文件

###### 感谢大神们的辛勤付出[grimore.org](http://grimore.org/cracks)

##### 声明：本项目仅供学习使用，请勿用作非法用途。非法使用产生的任何问题与此项目及本人无关！
