# JHImageCarousel
一个简单的图片轮播器, 可以自动循环轮播及点击图片进行操作

这是一个collectionView的无限轮播器, 它的原理是由3个collectionViewCellx无限循环轮播

优点:解决了当图片很多的时候导致内存过高的问题

缺点:当拖动过快时, scrollview尚未滚动停止, 会出现下一张图片未显示出来, 黑色. 因为我的原理是通过scrollviewEnd的代理方法, 在结束滚动时,瞬间切换回中间cell来达到无限循环的效果
![image](https://github.com/oneSmiles/JHImageCarousel/lunbo.png)
