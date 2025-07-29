local SlotMachineConfig = {
    waitTime = 5.0,                                 --等待的时间
    speed = 0.05,                                   --旋转速度
    isLineWait = true,                             --
    StopInterval = 1.0,
    isDrop = true,                                  --是否开启掉落
    isOpenReboundAnimation = true,                  --是否开启回弹动画
    AxisCount = 5,                                  --列数
    ItemsPerAxis =3,                               --行数
    AddItems = 1,                                   --头尾添加的元素的个数
    dropTime = 0.2,                                 --掉落时间
    isOpenSingleAxisMask = false,                   --是否创建单轴遮罩
    ElementHeight = 300,                            --元素的高度
    ElementWight = 330,                             --元素的宽
    MaskStartPos = CS.UnityEngine.Vector3(0, 0, 0), --游戏根节点，相对父节点的偏移
    AxisOffset = 345,                               --每条轴之间的距离
    AxisSize = CS.UnityEngine.Vector2(337, 964),
    AxisSizeOffset = 0,                             --轴的高度偏移,微调轴的高度
}
return SlotMachineConfig
