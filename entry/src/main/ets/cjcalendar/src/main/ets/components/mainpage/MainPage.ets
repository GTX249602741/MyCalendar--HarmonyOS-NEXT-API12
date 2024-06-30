import {
  CellStatus,
  CJCalendar,
  CJCalStatusParams,
  CJCalStyle,
  CJCellStyle,
  OptMode,
  SelectedStyle
} from '../components/CJCalendar';
import { CJDateItem } from '../components/CJDateItem';
//import { ifaa } from '@kit.OnlineAuthenticationKit';
import { Solar } from 'lunar';

@Component
@Entry
export struct MainPage {
  @State message: string = 'Hello World';
  cjCalStatus: CJCalStatusParams = new CJCalStatusParams()
  cjCellStyle: CJCellStyle = new CJCellStyle()
  cjCellStatus: CellStatus = new CellStatus()
  cjDataItem: CJDateItem = new CJDateItem(new Date())
  today11 = new Date()

  // @BuilderParam testTitle: () => void = this.TestTitle

  build() {
    Column() {
      Text("日历Demo")
        .height(50)
        .textAlign(TextAlign.Center)
      Scroll() {
        Column() {
          // Text(this.message)
          //   .fontSize(50)
          //   .fontWeight(FontWeight.Bold)

          // 正常使用
          // CJCalendar()
          //
          // Divider()
          //   .margin({ top: 20, bottom: 20 })
          //   .height(10)
          //
          // CJCalendar({
          //   // themeColor: Color.Orange
          // })
          //
          // Divider()
          //   .margin({ top: 20, bottom: 20 })
          //   .height(10)

          CJCalendar({
            // testTitle: this.TestTitle,

            selectedStyle: SelectedStyle.CLOSE,
            optMode: OptMode.NORMAL,
            startDate: new Date("2024-04-20"),
            endDate: new Date("2024-06-20"),
            showFastToday: true,
            // 是否显示农历
            showLunar: true,
            // 是否显示节日
            // showJieRi: false,
            // 是否显示节气
            // showJieQi: false,
            // 是否仅显示当月日期
            // onlyShowCurrMonthDay: true,
            // toolbarLayout: this.ToolbarLayout,
            // 自定义单元格背景
            // buildCellBackground: this.BuildCellBackground,
            onMonthChanged: (month: Date) => {
              console.log("月份切换：", JSON.stringify(month))
            },
            onCellItemClick: (item: CJDateItem) => {
              // 这里修改数据后会同步更新到界面
              // item.date = item.date + 1
              // item.extras.set("test", "-" + (item.date + 1) + "-")
              console.log("点击了：", JSON.stringify(item))
            },
            onDisableCellItemClick: (item: CJDateItem) => {
              console.log("越界点击了：", JSON.stringify(item))
            },
            onSelectedChanged: (items: Array<CJDateItem>) => {
              console.log("选择变化：", JSON.stringify(items))
            },
            // 自定义主体部分
            // buildCellBody: this.BuildCellBody,
            // 向CellItem中添加自定义属性
            // reBuildCellItem: (cjDateItem: CJDateItem) => {
            //   // 需要向 CJDateItem 中添加附加数据时，可是使用如下方式
            //   cjDateItem.extras.set("test", "-" + cjDateItem.date + "-")
            //   return cjDateItem
            // },

            // 自定义Cell样式风格
            // buildCellStyle: (item: CJDateItem) => {
            //   let cjCellStyle: CJCellStyle = new CJCellStyle()
            //   if (item.date < 7) {
            //     cjCellStyle.itemBackgroundColor = "#abedd8"
            //     cjCellStyle.fontColor = "#3f72af"
            //   } else if (item.date >= 10 && item.date < 16) {
            //     cjCellStyle.itemBackgroundColor = "#e4f9f5"
            //     cjCellStyle.fontColor = "#3d84a8"
            //   } else if (item.date >= 20 && item.date <= 28) {
            //     cjCellStyle.itemBackgroundColor = "#88304e"
            //     cjCellStyle.fontColor = "#fae3d9"
            //   }
            //   return cjCellStyle
            // }
          })

          // CJCalendar({
          //   // testTitle: this.TestTitle,
          //   optMode: OptMode.RANGE,
          //   startDate: new Date("2024-04-20"),
          //   endDate: new Date("2024-06-20"),
          //   showFastToday: true,
          //   // toolbarLayout: this.ToolbarLayout,
          //   buildCellBackground: this.BuildCellBackground,
          //   buildCellBody: this.BuildCellBody,
          //   onMonthChanged: (month: Date) => {
          //     console.log("月份切换：", JSON.stringify(month))
          //   },
          //   onCellItemClick: (item: CJDateItem) => {
          //     // 这里修改数据后会同步更新到界面
          //     // item.date = item.date + 1
          //     // item.extras.set("test", "-" + (item.date + 1) + "-")
          //     console.log("点击了：", JSON.stringify(item))
          //   },
          //   onDisableCellItemClick: (item: CJDateItem) => {
          //     console.log("越界点击了：", JSON.stringify(item))
          //   },
          //   onSelectedChanged: (items: Array<CJDateItem>) => {
          //     console.log("选择变化：", JSON.stringify(items))
          //   },
          //   reBuildCellItem: (cjDateItem: CJDateItem) => {
          //     // 需要向 CJDateItem 中添加附加数据时，可是使用如下方式
          //     cjDateItem.extras.set("test", "-" + cjDateItem.date + "-")
          //     return cjDateItem
          //   },
          //   buildCellStyle: (item: CJDateItem) => {
          //     let cjCellStyle: CJCellStyle = new CJCellStyle()
          //     if (item.date < 7) {
          //       cjCellStyle.itemBackgroundColor = "#abedd8"
          //       cjCellStyle.fontColor = "#3f72af"
          //     } else if (item.date >= 10 && item.date < 16) {
          //       cjCellStyle.itemBackgroundColor = "#e4f9f5"
          //       cjCellStyle.fontColor = "#3d84a8"
          //     } else if (item.date >= 20 && item.date <= 28) {
          //       cjCellStyle.itemBackgroundColor = "#88304e"
          //       cjCellStyle.fontColor = "#fae3d9"
          //     }
          //     return cjCellStyle
          //   }
          // })

        }
        .justifyContent(FlexAlign.Start)
      }
      .align(Alignment.Top)
      .layoutWeight(1)
    }
    .height("100%")
  }

  @Builder
  ToolbarLayout() {
    Column() {
      Row() {
        Button("上一月")
          .onClick(() => {
            this.__preMonth()
          })
        Blank()
        Text(this.cjCalStatus.title)
          .fontColor(Color.White)
        Blank()
        Button("下一月")
          .onClick(() => {
            this.__nextMonth()
          })
      }
      .width("100%")

      Text("此处可添加广告位")
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width("100%")
        .height(100)
        .backgroundColor(Color.Pink)
    }
    .backgroundColor(Color.Orange)
    .width("100%")

    // .height(50)
  }

  @Builder
  TestTitle() {

    // 这里的 this 指向子组件，
    // 想要在这里同时使用父组件的数据该怎样操作


    Text(this.cjCalStatus.title)
  }

  @Builder
  BuildCellBackground() {
    if (this.cjDataItem.isToday) { // 今天
      Column()
        .backgroundColor(Color.Yellow)
        .width('85%')
        .aspectRatio(1)
        .border({
          width: this.cjCellStyle.boderWidth,
          color: this.cjCellStyle.boderColor
        })
        .borderRadius(this.cjCellStyle.boderRadius)
    } else {
      Column()
        .backgroundColor(this.cjCellStatus.backgroundColor)
        .width('85%')
        .aspectRatio(1)
        .border({
          width: this.cjCellStyle.boderWidth,
          color: this.cjCellStyle.boderColor
        })
        .borderRadius(this.cjCellStyle.boderRadius)
    }

  }

  @Builder
  BuildCellBody() {
    Column() {
      Text(this.cjDataItem.date + '')
        .fontColor(this.cjCellStatus.fontColor)
        .fontSize(this.cjCellStyle.fontSize)
        .fontWeight(this.cjCellStyle.fontFontWeight)
      Text(this.cjDataItem.extras.get("test") as string)
        .fontSize(10)
        .fontColor(Color.Gray)
        .fontColor(this.cjCellStatus.fontColor)
    }
    .alignItems(HorizontalAlign.Center)

  }

  __preMonth() {
  }

  __nextMonth() {
  }
}
