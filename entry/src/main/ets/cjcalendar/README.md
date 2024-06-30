# cjcalendar
_最新版文档还在更新中 [**请点这里查看最新文档**](https://atomgit.com/cj-open/CJOpenNext/blob/master/cjcalendar/README.md)_

_发布审核比较慢，有紧急需求或者BUG要解决者，可加裙讨论：806284521_

## 简介

_cjcalendar 是一款日常开发常用的日历组件，内部集成常规、单选、时间范围选择、多选、自定义日期每项显示等._

## 下载安装

`ohpm install cjcalendar`

## 使用方式

````
import { CJCalendar } from 'cjcalendar'
````

````
CJCalendar()
````

## 一、各项属性

| 参数名 | 类型 | 必填 | 说明 |
|--|--|--|--|
| optMode | OptMode | 否 | 操作模式,常规、单选、一段时间、多选：默认：OptMode.NORMAL |
| startDate | Date | 否 | 开始日期：默认：new Date(1970, 0, 1)   |
| endDate | Date | 否 | 截止日期：默认：当前时间+10年 |
| titleHeight | Length | 否 | 标题栏高度：默认：50vp |
| weeks| string[] | 否 | 星期标题，默认：["日","一","二","三","四","五","六",]   |
| weekTitleFontSize| number \| string \| Resource | 否 | 星期标题字体大小，默认：12 |
| weekTitleFontColor| ResourceColor | 否 | 星期标题字体颜色，默认："#9E9E9E"  |
| weekTitleBackgroundColor| ResourceColor | 否 | 星期标题背景色颜色，默认未设置  |
| weekTitleHeight| Length | 否 | 星期标栏高度，默认：40 |
| titleFontSize | number \| string \| Resource| 否 | 标题字体大小，默认：18 |
| titleFontColor| ResourceColor | 否 | 标题字体颜色，默认："#252a34"  |
| showFastToday| boolean | 否 | 是否显示快捷 今，默认：true |
| fastTodayFontSize| number \| string \| Resource| 否 | 快捷返回今天，字体大小，默认：12 |
| fastTodayFontColor| Resource| 否 | 快捷返回今天，字体颜色，默认："#FFFFFF"  |
| fastTodayBg| Resource| 否 | 快捷返回今天，背景颜色，默认与todayFontColor一致 |
| itemFontSize | number \| string \| Resource | 否 | 日期每一项字体大小，默认：18 |
| itemFontColor | Resource | 否 | 日期每一项字体颜色，默认："#252a34"  |
| itemFontWeight | Resource | 否 | 日期每一项字体，默认：FontWeight.Normal |
| todayFontColor | ResourceColor | 否 | “今”日字体颜色，默认："#03A9F4"  |
| disabledFontColor | ResourceColor | 否 | 不能使用的日期字体颜色，默认："#9E9E9E"  |
| selectFontColor | ResourceColor | 否 | 选中日期字体颜色，默认："#FFFFFF"  |
| selectItemBgColor | ResourceColor | 否 | 选中日期背景颜色, 默认与todayFontColor一致 |
| optMode | OptMode | 否 | 操作类型，默认：NORMAL |
| rangeStyle | SelectedStyle | 否 | SelectedStyle.ALONE 独立风格，SelectedStyle.CLOSE 封闭风格，默认：SelectedStyle.ALONE 独立圆形选中风格 |
| extremityRadius | number | 否 | optMode == OptMode。RANGE且rangeStyle==SelectedStyle.CLOSE 时生效，两头选项的圆角 |
| showTime | boolean | 否 | 是否显示时间选择，默认：false |
| timeFontSize | number \| string \| Resource | 否 | 时间选择器字体大小，默认：18 |
| timeFontColor | ResourceColor | 否 | 时间选择器字体颜色，默认：item 字体颜色 |

## 二、常用方法

| 方法 | 参数 | 返回|必填 | 说明 |
|--|--|--|--|--|
| cellLayout | item: CJDateItem | - | 否 | 自定义每一项布局 |
| cusCellMainLayout | item: CJDateItem,params: CellFontStyle | - | 否 | 仅自定义日期文字区 |
| selectedBackgroundLayout | item: CJDateItem | - | 否 | 仅自定义选中背景样式区 |
| titleCenterLayout | - | - | 否 | 自定义日期标题中心内容 |
| titleLeftLayout | - | - | 否 | 自定义日期标题左边内容 |
| titleRightLayout | - | - | 否 | 自定义日期标题右边内容 |
| todayLayout | item: CJDateItem | - | 否 | 仅自定义 今日 样式，当使用cellLayout时，tadayLayout无效 |
| fastTodayLayout | - | - | 否 | 快捷回到今天自定义布局 |
| disableCellClick | item: CJDateItem| - | 否 | 点击不可用item时的事件响应 |
| reBuildDateItem | item: CJDateItem| CJDateItem | 否 | 计算item时，如需添加更多自定义属性时使用 |
| onDateChange | date1: CJDateItem \| Array<CJDateItem>, date2?: CJDateItem | - | 否 | 选择变化监听，OptMode.NORMAL/OptMode.SINGLE,只返：date1；OptMode.RANGE：两个都返,date1为开始时间，date2为结束时间；MULTIPLE：返回Array<CJDateItem>，已选中的日期 |
| onTimeChange | time1: CJTimeItem, time2?: CJTimeItem | - | 否 | 时间选择改变监听 |
| onMonthChange | after: Date, befor: Date | - | 否 | 月份改变回调：after 改变后，befor：改变前 |
| cusTopLayout | preMonth?: () => void, nextMonth?: () => void, backToday?: () => void | - | 否 | 自定义顶部布局，可结合cusTopStateListener使用 |
| cusTopStateListener | title?: string, hasPre?: boolean, hasNext?: boolean, showFastToday?: boolean | - | 否 | 自定义顶部布局时，可直接使用该状态回调用于控制顶部状态 |

## 三、CJDateItem通用属性

| 属性| 类型| 描述 |
|--|--|--|
| fullYear | number | 年 |
| month | number | 月 |
| date | number | 日期 |
| week | number | 星期 |
| time | number | 时间戳 |

## 四、OptMode 操作模式

| 属性 | 描述 |
|--|--|
| NORMAL | 常规 |
| SINGLE | 单选 |
| RANGE | 一段时间 |
| MULTIPLE | 多选 |

## 五、SelectedStyle 选中样式风格

| 属性 | 描述 |
|--|--|
| ALONE | 独立选中风格：默认圆形独立 |
| CLOSE | 封闭选中风格：默认举行封闭 |


## 五、使用案例
### 1、直接使用
```typescript
import { CJCalendar } from 'cjcalendar'
```

```typescript
CJCalendar()
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114156.81672585592185638340370856931281:50001231000000:2800:F9726D626C829E7C2B2E2A428829729738A9FC57DAF98E2ED29C045912456882.png)
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114205.67695106346975738356861182651529:50001231000000:2800:B306FE609A6C76D5FAD4875C7EB5CB5D34B61086A1AC74902490627E8D6667E7.png)


### 2、范围选择
```typescript
CJCalendar({
  // 范围选择
  optMode: OptMode.RANGE,
  rangeStyle: SelectedStyle.CLOSE,// 默认 SelectedStyle.ALONE
  // 日期选择变化监听
  onDateChange: (start: CJDateItem, end: CJDateItem) => {
    console.log(TAG, "start：", JSON.stringify(start))
    console.log(TAG, "end：", JSON.stringify(end))
  },
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114223.65997418039698490583861718476244:50001231000000:2800:B2C18BBDBA1086C5AF2319D6052BB7D42D9C1CB1BDB26A1B8D056B9A35F253C7.png)
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114234.03369615102031284607014565254929:50001231000000:2800:15E115EF87350F5577284D10B5BB24BD290F1525DACF5D5A827059C14CDE7B0C.png)


### 3、多选

```typescript
CJCalendar({
  // 范围选择
  optMode: OptMode.MULTIPLE,
  // 日期选择变化监听
  onDateChange: (dates: CJDateItem[]) => {
    console.log(TAG, "dates：", JSON.stringify(dates))
  },
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114326.81152945831774927379041867730266:50001231000000:2800:375A0B602BD6CDDF68B87CAD86B8F2AE54B3F83601B4391FEF73D3E1E5DFEB9A.png)


### 4、修改主题色

```typescript
CJCalendar({
  // 范围选择
  optMode: OptMode.MULTIPLE,
  // 修改主题色
  todayFontColor: "#00897B",
  // 日期选择变化监听
  onDateChange: (dates: CJDateItem[]) => {
    console.log(TAG, "dates：", JSON.stringify(dates))
  },
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114346.98371906043235395182484178467826:50001231000000:2800:FA91CAE048FEC71F1242E6AF116B08B76D40750BB2736E06A9CCAC114480F119.png)
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114358.72040502806687301025731142112002:50001231000000:2800:8896999E6E45DFE826B3BDEA8E94FDD2F75AA0F00941916423CB2C43B6FAD142.png)
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114417.62148181301451154410169510499069:50001231000000:2800:AF0EE4D1B6325CEE4946310CF4C10826E5B313F36084A7810EC8E8031FA8F067.png)


### 5、限制开始日期、截止日期

```typescript
CJCalendar({
  // 范围选择
  optMode: OptMode.RANGE,
  // 修改主题色
  todayFontColor: "#E64A19",
  // 开始日期
  startDate: new Date(2024, 2, 3),
  // 截止日期
  endDate: new Date(2024, 2, 20),
  // 日期选择变化监听
  onDateChange: (date1: CJDateItem, date2: CJDateItem) => {
    console.log(TAG, "date1：", JSON.stringify(date1))
    console.log(TAG, "date2：", JSON.stringify(date2))
  },
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114514.23007792421002332627031405990762:50001231000000:2800:761B90FF5F41866316C601A6186FCD3E39AB1A2FFD7FAFDB739D6E89B2EB77CE.png)
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114537.29080821096532482167479592456675:50001231000000:2800:A134945FCEAAF9BD74CB4CFE8AB83EDD62969FA24D85B696437C2E6D41540494.png)
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114552.19305765650199689265272339893959:50001231000000:2800:B336601B0469AF190606D4EE8B37DF52D2631312F692111B89D61B50A74F4E3F.png)


### 6、自定义排版布局

```typescript
CJCalendar({
  // 范围选择
  optMode: OptMode.RANGE,
  // 修改主题色
  todayFontColor: "#E64A19",
  // 开始日期
  startDate: new Date(2024, 2, 3),
  endDate: new Date(2024, 2, 20),
  // 自定义每项排版布局
  cellLayout: (date: CJDateItem) => {
    this.cellLayout(date)
  },
  // 日期选择变化监听
  onDateChange: (date1: CJDateItem, date2: CJDateItem) => {
    console.log(TAG, "date1：", JSON.stringify(date1))
    console.log(TAG, "date2：", JSON.stringify(date2))
  },
})
```

```typescript
@Builder cellLayout(item: CJDateItem) {
    Column() {
      Text(item.date + "")
        .fontSize(18)
        .fontColor(item.isPre || item.isNext ? "#CCCCCC" : "#323232")
      Text("你好")
        .fontSize(12)
    }
}
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114659.99408718869646960471663892132474:50001231000000:2800:A4FF6FFB8A035D821B557A434EC6D4E71D22C5258559A01061379F0DD32309EC.png)


### 7、自定义顶部布局


```typescript
CJCalendar({
  // 范围选择
  optMode: OptMode.RANGE,
  // 修改主题色
  todayFontColor: "#E64A19",
  // 开始日期
  startDate: new Date(2024, 2, 3),
  endDate: new Date(2024, 2, 20),
  cusTopLayout: (
    preMonth: () => void,
    nextMonth: () => void,
    backToday: () => void,
  ) => {
    this.cusTopLayout(preMonth, nextMonth, backToday)
  },
  cusTopStateListener: (title?: string,
                        hasPre?: boolean,
                        hasNext?: boolean,
                        showFastToday?: boolean) => {
    this.title = title
  }
})
```

```typescript
@Builder cusTopLayout(preMonth: () => void,
    nextMonth: () => void,
    backToday: () => void) {
        Column() {
          Row() {
            Button("上一月")
              .onClick(() => {
                preMonth()
              })
            Text(this.title)
            Button("下一月")
              .onClick(() => {
                nextMonth()
              })
            Button("今天")
              .onClick(() => {
                backToday()
              })
          }
    .justifyContent(FlexAlign.Center)
      .width("100%")
    
    Text("广告位啥的你来加")
      .width("100%")
      .height(100)
      .fontSize(20)
      .backgroundColor("#ffcfdf")
      .fontColor("#112d4e")
      .textAlign(TextAlign.Center)
    }
    .width("100%")
}
```


![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114719.31946060229435111966404149166491:50001231000000:2800:70E5ED575B5729C590B22FE896610606B545E0C6237424F4650EA068238B875A.png)



### 8、初始化选中项

#### a、多选默认项

```typescript
CJCalendar({
selectedDates: [
  "2024-03-12",
  "2024-03-15",
  "2024-03-18",
  "2024-03-28"
],
optMode: OptMode.MULTIPLE,
onDateChange: (dates: CJDateItem[]) => {
  console.log(TAG, "date1：", JSON.stringify(dates))
},
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114742.14781774082390244878873777752801:50001231000000:2800:5ABB0D7162E6F76A02912EEE1C1FB0D549776DEDD6B9531EAEADFD2A7063E1EB.png)


#### b、范围选择默认项

```typescript
CJCalendar({
selectedDates: [
  "2024-03-05",
  "2024-03-13",
],
optMode: OptMode.RANGE,
onDateChange: (date1: CJDateItem, date2: CJDateItem) => {
  console.log(TAG, "date1：", JSON.stringify(date1))
  console.log(TAG, "date2：", JSON.stringify(date2))
},
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114757.81326036709525725315163752752121:50001231000000:2800:2056867757DDD002BA204F006984FE294ABD5E7CFDC561E9DF50901BDD5FCF3D.png)


#### c、单选择默认项

```typescript
CJCalendar({
selectedDates: [
  "2024-03-11",
],
optMode: OptMode.SINGLE,
onDateChange: (date1: CJDateItem) => {
  console.log(TAG, "date1：", JSON.stringify(date1))
},
})
```

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114817.86889790464330021292879826090611:50001231000000:2800:58DB7B4003220A57D0954F8CAFBC3FA73FBE9D4A54075FDD1BBDA87C1115C99A.png)


### 9、自定义选中样式

#### a、自定义独立选中风格样式

```typescript
CJCalendar({
    optMode: OptMode.RANGE,
    rangeStyle: SelectedStyle.CLOSE,// ALONE：独立风格， CLOSE：封闭风格
    selectedBackgroundLayout: (item: CJDateItem, isStart?: boolean, isEnd?: boolean) => {
      this.AloneSelectedLayout(item, isStart, isEnd)
    },
    onDateChange: (date1: CJDateItem, date2: CJDateItem) => {
      console.log(TAG, "date1：", JSON.stringify(date1))
      console.log(TAG, "date2：", JSON.stringify(date2))
    },
})
```

```typescript
@Builder
SelectedBackgroundLayout(item: CJDateItem, isStart?: boolean, isEnd?: boolean){
    Column()
      .width("100%")
      .height("100%")
      .backgroundColor(Color.Brown)
}
```
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114902.83595162994334157856049338701256:50001231000000:2800:F57B2385BA74A48A4C2316A7C8D2DAF61E5990DE9A33BBB2664CF403C70A5C7F.png)

![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114846.57397508710145829021077401703059:50001231000000:2800:113A77AA4438A22BC1D72F5238D3E284B969053B50E9ADD47FF23BD9E7238CA1.png)


#### b、自定义封闭式范围选择两端圆角

```typescript
CJCalendar({
    optMode: OptMode.RANGE,
    rangeStyle: SelectedStyle.CLOSE,// ALONE：独立风格， CLOSE：封闭风格
    extremityRadius: 999,  
    selectedBackgroundLayout: (item: CJDateItem, isStart?: boolean, isEnd?: boolean) => {
      this.AloneSelectedLayout(item, isStart, isEnd)
    },
    onDateChange: (date1: CJDateItem, date2: CJDateItem) => {
      console.log(TAG, "date1：", JSON.stringify(date1))
      console.log(TAG, "date2：", JSON.stringify(date2))
    },
})
```

```typescript
@Builder
SelectedBackgroundLayout(item: CJDateItem, isStart?: boolean, isEnd?: boolean){
    Column()
      .width("100%")
      .height("100%")
      .backgroundColor(Color.Brown)
}
```
![在这里插入图片描述](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/028/132/711/0900086000028132711.20240407114915.15760674699722344502123130453301:50001231000000:2800:13D83E2AC3870A162B692DA709C3D545DE26515618DC218A0ACC1C8692115FC2.png)



### 移驾学习交流群
![鸿蒙开发交流群二维码.png](https://atomgit.com/cj-open/CJOpenNext/raw/master/screenshots%2Fqrcode%2F%E9%B8%BF%E8%92%99%E5%BC%80%E5%8F%91%E4%BA%A4%E6%B5%81%E7%BE%A4%E4%BA%8C%E7%BB%B4%E7%A0%81.png)


这只是冰山一脚，

还有很多功能可自行探索
。。。。。。


