/**
 * 操作模式
 */
import TimeConversionTool from '../../utils/TimeConversionTool'
import { CJDateItem } from './CJDateItem'
import { ColorUtil } from '../../utils/ColorUtil'
import { Solar } from 'lunar'
import thermal from '@ohos.thermal'
//import { ifaa } from '@kit.OnlineAuthenticationKit'

export function getLunarDesc(cjDataItem: CJDateItem, showJieQi: boolean | undefined, showJieRi: boolean | undefined): string {
  try {
    if (cjDataItem.solar) {
      if (showJieRi && cjDataItem.solar.getLunar().getFestivals().length > 0) {
        return cjDataItem.solar.getLunar().getFestivals().join()
      }
      if (showJieQi && cjDataItem.solar.getLunar().getJieQi()) {
        return cjDataItem.solar.getLunar().getJieQi()
      }
      return cjDataItem.solar.getLunar().getDayInChinese()
    }
  } catch (e) {

  }
  return ""
}


@Observed
export class CJCalStatusParams {
  title: string = ""
  hasPre: boolean = true
  hasNext: boolean = true
  showFastToday: boolean = true
}

@Observed
export class CJCalStyle {
  rowSpace: Length = 8
  colSpace: Length = 4
}

export class CJCellStyle {
  lunarFontSize: number | string | Resource = 12
  lunarFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary')
  lunarFontFontWeight: FontWeight = FontWeight.Normal
  fontSize: number | string | Resource = 18
  fontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary')
  fontFontWeight: FontWeight = FontWeight.Normal
  // 今日字体颜色
  todayFontColor: ResourceColor = "#03A9F4"
  // 不能使用的日期字体颜色
  disabledFontColor: ResourceColor = "#B1B1B1"
  // 选中日期字体颜色
  selectFontColor: ResourceColor = "#FFFFFF"
  // 选中日期背景颜色, 默认与todayFontColor一致
  itemBackgroundColor: ResourceColor = "#00000000"
  selectItemBackgroundColor: string = "#03A9F4"
  /**
   * RANGE 模式下生效，中间区域颜色变淡比例，范围：0-1
   */
  lightRatio: number = 0.85
  // 边框样式
  /** 边框颜色 */
  boderColor: ResourceColor = "#dbe2ef"
  /** 边框宽度 */
  boderWidth: Length = 0
  /** 边框圆角 */
  boderRadius: Length = 4
}

@Observed
export class CellStatus {
  fontColor: ResourceColor = "#252a34"
  backgroundColor: ResourceColor = "#00000000"
  isStart: boolean = false
  isEnd: boolean = false
  // selected: boolean = false
}

export enum OptMode {
  /** 普通模式 */
  NORMAL = "normal",
  /** 单选模式 */
  SINGLE = "single",
  /** 范围选择模式 */
  RANGE = "range", //一段区域
  /** 多选选择模式 */
  MULTIPLE = "multiple", // 多选
}

/**
 * 选中风格
 */
export enum SelectedStyle {
  /** 独立风格 */
  ALONE = 1,
  /** 封闭风格 */
  CLOSE = 2,
}

@Component
struct ItemCell {
  @State cjCellStatus: CellStatus = new CellStatus()
  @ObjectLink cjDataItem: CJDateItem
  @Prop today: CJDateItem
  @Link @Watch("__onSelectChange") selectedItems: Array<CJDateItem>
  @Prop cjCalStatus: CJCalStatusParams
  selectedStyle: SelectedStyle = SelectedStyle.ALONE
  optMode: OptMode = OptMode.NORMAL
  cjCellStyle: CJCellStyle = new CJCellStyle()
  themeColor: ResourceColor = "#03A9F4"
  onlyShowCurrMonthDay: boolean = false
  showLunar: boolean = false
  showJieQi: boolean = false
  showJieRi: boolean = false
  // 点击
  cellClick: (cjDataItem: CJDateItem) => void = () => {
  }
  // ========自定义布局=======
  @BuilderParam buildCellBackground: CustomBuilder = this.BuildCellBackground
  @BuilderParam buildCellBody: CustomBuilder = this.BuildCellBody

  aboutToAppear(): void {
    // if (this.cjDataItem.equalDay(this.today)) {
    //   this.cjCellStatus.fontColor = this.cjCellStyle.todayFontColor
    // } else {
    //   this.cjCellStatus.fontColor = this.cjCellStyle.fontColor
    // }

    this.__onSelectChange()
  }

  build() {
    if (this.onlyShowCurrMonthDay && (this.cjDataItem.isSmallThanStart || this.cjDataItem.isBigThanEnd)) {
      Stack()
    } else {
      Stack() {
        // 背景
        this.CellBackground()

        // 主题内容
        this.CellMain()
      }
      .onClick(() => {

        if ((!this.cjDataItem.isPre && !this.cjDataItem.isNext) ||
          (this.cjDataItem.isPre && this.cjCalStatus.hasPre) ||
          (this.cjDataItem.isNext && this.cjCalStatus.hasNext)) {

          if (this.optMode == OptMode.NORMAL || this.optMode == OptMode.SINGLE) { // 正常

            this.selectedItems[0] = this.cjDataItem
            // this.cjDataItem.date = 66

          } else if (this.optMode == OptMode.MULTIPLE) { //多选

            const index = this.containsItem(this.cjDataItem)
            if (index >= 0) {
              this.selectedItems.splice(index, 1)
            } else {
              this.selectedItems.push(this.cjDataItem)
            }

          } else if (this.optMode == OptMode.RANGE) { //范围

            if (this.selectedItems.length == 0) { //一个没选
              this.selectedItems.push(this.cjDataItem)
            } else if (this.selectedItems.length == 1) { // 选了一个
              if (this.cjDataItem.bigThan(this.selectedItems[0])) {
                this.selectedItems.push(this.cjDataItem)
              } else {
                this.selectedItems.splice(0, 0, this.cjDataItem)
              }

            } else if (this.selectedItems.length == 2) { // 选了两个
              this.selectedItems.splice(0, 2)
              this.selectedItems.push(this.cjDataItem)
            }

          }

        }

        // 回调点击
        this.cellClick(this.cjDataItem)
      })
    }
  }

  @Builder
  BuildCellBackground() {

  }

  @Builder
  BuildCellBody() {

  }

  @Builder
  CellBackground() {
    Stack() {
      if (this.buildCellBackground) {
        this.buildCellBackground()
      }
    }
    .width('100%')
    .aspectRatio(1)
    .clip(true)
  }

  @Builder
  CellMain() {
    if (this.buildCellBody) {
      this.buildCellBody()
    }
  }

  __onSelectChange() {
    // 初始化颜色
    if (this.cjDataItem.isPre || this.cjDataItem.isNext) {
      this.cjCellStatus.fontColor = this.cjCellStyle.disabledFontColor
    } else if (this.cjDataItem.equalDay(this.today)) {
      this.cjCellStatus.fontColor = this.cjCellStyle.todayFontColor
      this.cjCellStatus.backgroundColor = this.cjCellStyle.todayFontColor
    }

    if (this.optMode == OptMode.NORMAL || this.optMode == OptMode.SINGLE) { // 正常

      if (this.cjDataItem.equalDay(this.selectedItems[0])) {
        // this.cjCellStatus.selected = true
        this.cjCellStatus.fontColor = this.cjCellStyle.selectFontColor
        this.cjCellStatus.backgroundColor = this.cjCellStyle.selectItemBackgroundColor
      } else {
        // this.cjCellStatus.selected = false
        if (this.cjDataItem.equalDay(this.today)) {
          this.cjCellStatus.fontColor = this.cjCellStyle.todayFontColor
        } else {
          if (!this.cjDataItem.isPre && !this.cjDataItem.isNext) {
            this.cjCellStatus.fontColor = this.cjCellStyle.fontColor
          }
        }
        this.cjCellStatus.backgroundColor = this.cjCellStyle.itemBackgroundColor
      }

    } else if (this.optMode == OptMode.MULTIPLE) { //多选

      if (this.containsItem(this.cjDataItem) >= 0) {
        if (!this.cjDataItem.isPre && !this.cjDataItem.isNext) {
          this.cjCellStatus.fontColor = this.cjCellStyle.selectFontColor
          this.cjCellStatus.backgroundColor = this.cjCellStyle.selectItemBackgroundColor
        } else {
          this.cjCellStatus.backgroundColor = ColorUtil.lightenColor(this.cjCellStyle.selectItemBackgroundColor, this.cjCellStyle.lightRatio)
        }
      } else {
        // this.cjCellStatus.selected = false
        if (this.cjDataItem.equalDay(this.today)) {
          this.cjCellStatus.fontColor = this.cjCellStyle.todayFontColor
        } else {
          if (!this.cjDataItem.isPre && !this.cjDataItem.isNext) {
            this.cjCellStatus.fontColor = this.cjCellStyle.fontColor
          }
        }
        this.cjCellStatus.backgroundColor = this.cjCellStyle.itemBackgroundColor
      }

    } else if (this.optMode == OptMode.RANGE) { //范围

      let isStart = this.cjDataItem.equalDay(this.selectedItems[0])
      let isEnd = this.cjDataItem.equalDay(this.selectedItems[1])
      if (isStart && !this.selectedItems[1]) {
        isEnd = true
      }
      if (isStart || isEnd) { // 两端状态
        this.cjCellStatus.fontColor = this.cjCellStyle.selectFontColor
        this.cjCellStatus.backgroundColor = this.cjCellStyle.selectItemBackgroundColor
        this.cjDataItem.equalDay(this.selectedItems[0])
        this.cjCellStatus.isStart = isStart
        this.cjCellStatus.isEnd = isEnd
      } else if (this.selectedItems.length == 2 &&
        (this.cjDataItem.bigThan(this.selectedItems[0]) && this.cjDataItem.smallThan(this.selectedItems[1]))) { //中间状态

        if (this.cjDataItem.equalDay(this.today)) {
          this.cjCellStatus.fontColor = this.cjCellStyle.todayFontColor
        } else {
          if (!this.cjDataItem.isPre && !this.cjDataItem.isNext) {
            this.cjCellStatus.fontColor = this.cjCellStyle.fontColor
          }
        }
        this.cjCellStatus.backgroundColor = ColorUtil.lightenColor(this.cjCellStyle.selectItemBackgroundColor, this.cjCellStyle.lightRatio);
      } else {
        // this.cjCellStatus.selected = false
        if (this.cjDataItem.equalDay(this.today)) {
          this.cjCellStatus.fontColor = this.cjCellStyle.todayFontColor
        } else {
          if (!this.cjDataItem.isPre && !this.cjDataItem.isNext) {
            this.cjCellStatus.fontColor = this.cjCellStyle.fontColor
          }
        }
        this.cjCellStatus.backgroundColor = this.cjCellStyle.itemBackgroundColor
      }
    }
  }

  containsItem(cellItem: CJDateItem): number {
    return this.selectedItems.findIndex(item => item.equalDay(cellItem))
  }
}
@Component
export struct CJCalendar {
  @State @Watch("__onStatusChange") cjCalStatus: CJCalStatusParams = new CJCalStatusParams()
  @State days: Array<Array<CJDateItem>> = new Array<Array<CJDateItem>>()
  @State selectedItems: Array<CJDateItem> = new Array()
  //================
  /** 操作模式 */
  optMode: OptMode = OptMode.NORMAL
  today: CJDateItem = new CJDateItem(new Date())
  selectedStyle: SelectedStyle = SelectedStyle.ALONE
  // 当前显示月份
  @Link currentMonth:number
  @Link currentYear:number
  currMonth: Date = new Date(this.currentYear,this.currentMonth-1)
  startDate: Date = new Date("1970-01-01")
  endDate: Date = new Date(this.currMonth.getFullYear() + 10, 0, 1)
  /** 样式 */
  calStyle: CJCalStyle = new CJCalStyle()
  cjDataItem: CJDateItem = new CJDateItem(new Date())
  weeks: string[] = [
    "日",
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
  ]
  /** 星期标题字体大小 */
  weekTitleFontSize: number | string | Resource = 13
  /** 星期标题字体颜色 */
  weekTitleFontColor: ResourceColor = "#9E9E9E"
  weekTitleBackgroundColor: ResourceColor = "#00000000"
  // 星期标栏高度
  weekTitleHeight: Length = 40
  // =====theme======
  // themeColor: ResourceColor = "#03A9F4"
  itemFontColor: ResourceColor = "#252a34"
  cjCellStatus: CellStatus = new CellStatus()
  cjCellStyle: CJCellStyle = new CJCellStyle()
  // 不能使用的日期字体颜色
  disabledFontColor: ResourceColor = "#9E9E9E"
  titleHeight: Length = 50
  titleBackground: ResourceColor = "#00000000"
  // 标题年月格式化,默认：yyyy-MM
  titleFormat: string = ""
  // 标题字体大小
  titleFontSize: number | string | Resource = 18
  // 标题字体颜色
  titleFontColor: ResourceColor = "#252a34"
  // 是否显示快捷 今
  showFastToday: boolean = true
  fastTodayFontSize: number | string | Resource = 12
  fastTodayFontColor: ResourceColor = "#FFFFFF"
  fastTodayBackgroundColor: ResourceColor = "#03A9F4"
  // 是否仅显示当月日期
  onlyShowCurrMonthDay: boolean = false
  // 是否显示农历
  showLunar: boolean = false
  showJieQi: boolean | undefined
  showJieRi: boolean | undefined
  /** 日期选中 */
  onItemSelected: (items: Array<CJDateItem>) => void = () => {
  }
  /** 状态改变回调 */
  onStatusChange: (cjCalStatus: CJCalStatusParams) => void = () => {
    console.log("状态变化：", JSON.stringify(this.cjCalStatus))
  }
  buildCellStyle: (cjDataItem: CJDateItem) => CJCellStyle = () => {
    return new CJCellStyle()
  }
  /**
   * 选择改变监听，
   * 如果 optMode == SINGLE ： CJDateItem，
   * 如果 optMode == RANGE || MULTIPLE ：Array<CJDateItem>
   */
  onSelectedChanged: (items: Array<CJDateItem>) => void = () => {

  }
  /**
   * 点击日期事件响应
   */
  onCellItemClick: (item: CJDateItem) => void = () => {
  }
  /**
   * 不能点击项的点击日期事件响应
   */

  onDisableCellItemClick: (item: CJDateItem) => void = () => {
  }
  /**
   * 月份切换
   */
  onMonthChanged: (month: Date) => void = () => {
  }
  /**
   * 重新构建Item
   */
  reBuildCellItem: (cjDateItem: CJDateItem) => CJDateItem = (cjDateItem: CJDateItem) => {
    return cjDateItem
  }
  // ========自定义布局==========
  @BuilderParam toolbarLayout: CustomBuilder = this.ToolbarLayout
  @BuilderParam buildCellBackground: CustomBuilder = this.BuildCellBackground
  @BuilderParam buildCellBody: CustomBuilder = this.BuildCellBody

  aboutToAppear() {
    this.__initAttrs()
    // this.buildCellBackground.bind(this)
    // 初始化其他参数
    // this.fastTodayBackgroundColor = this.themeColor
    this.cjCalStatus.showFastToday = this.showFastToday

    // 初始化日期项
    this.__initDays()

  }

  /**
   * 初始化属性
   */
  __initAttrs() {
    // 初始化农历相关属性
    if (this.showLunar) {
      if (this.showJieQi == undefined) {
        this.showJieQi = true
      }
      if (this.showJieRi == undefined) {
        this.showJieRi = true
      }
    }
  }

  aboutToDisappear() {

  }

  build() {
    Column() {
      // this.testTitle()
      // 顶部导航
      if (this.toolbarLayout) {
        this.toolbarLayout()
      }
      // 星期
      this.WeekLayout()
      // 日期
      this.DayLayout()
    }
    .width('100%')

  }

  @Builder
  BuildCellBackground() {
    if (this.optMode == OptMode.NORMAL ||
      this.optMode == OptMode.MULTIPLE ||
      this.optMode == OptMode.SINGLE) {
      Column()
        .backgroundColor(this.cjCellStatus.backgroundColor)
        .width('85%')
        .aspectRatio(1)
        .border({
          width: this.cjCellStyle.boderWidth,
          color: this.cjCellStyle.boderColor
        })
        .borderRadius(this.cjCellStyle.boderRadius)
    } else if (this.optMode == OptMode.RANGE) {
      if (this.selectedStyle == SelectedStyle.ALONE) { // 独立
        Column()
          .backgroundColor(this.cjCellStatus.backgroundColor)
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
          .width('100%')
          .height("90%")// .aspectRatio(1)
          .border({
            width: this.cjCellStyle.boderWidth,
            color: this.cjCellStyle.boderColor
          })
          .borderRadius({
            topLeft: this.cjCellStatus.isStart ? this.cjCellStyle.boderRadius : 0,
            topRight: this.cjCellStatus.isEnd ? this.cjCellStyle.boderRadius : 0,
            bottomLeft: this.cjCellStatus.isStart ? this.cjCellStyle.boderRadius : 0,
            bottomRight: this.cjCellStatus.isEnd ? this.cjCellStyle.boderRadius : 0
          })
        // .borderRadius(this.cjCellStyle.boderRadius)
      }

    }

    // Text(this.selectedStyle + "")
  }

  @Builder
  BuildCellBody() {
    Column() {
      Text(this.cjDataItem.date + '')
        .fontColor(this.cjCellStatus.fontColor)
        .fontSize(this.cjCellStyle.fontSize)
        .fontWeight(this.cjCellStyle.fontFontWeight)
      if (this.showLunar && this.cjDataItem.solar) {
        Text(getLunarDesc(this.cjDataItem, this.showJieQi, this.showJieRi))
          .fontSize(this.cjCellStyle.lunarFontSize)
          .fontColor(this.cjCellStatus.fontColor)
          .fontWeight(this.cjCellStyle.lunarFontFontWeight)
          .margin({
            top: 2
          })
      }
    }
  }

  @Builder
  ToolbarLayout() {
    Row() {
      Image($r("app.media.ic_public_arrow_left_filled"))
        .width(28)
        .fillColor(this.cjCalStatus.hasPre ? this.itemFontColor : this.disabledFontColor)
        .aspectRatio(1)
        .onClick(() => {
          // this.cjCalStatus.title = "2024-04"
          this.__preMonth()
        })

      Blank()

      Row() {
        Text(this.cjCalStatus.title)
          .fontSize(this.titleFontSize)
          .fontColor(this.titleFontColor)

        if (this.showFastToday && !this.cjCalStatus.showFastToday) {
          Text("今")
            .fontSize(this.fastTodayFontSize)
            .fontColor(this.fastTodayFontColor)
            .backgroundColor(this.fastTodayBackgroundColor)
            .borderRadius(50)
            .padding(4)
            .margin({ left: 4 })
            .onClick(() => {
              this.__backToday()
            })
        }
      }

      Blank()

      Image($r("app.media.ic_public_arrow_right_filled"))
        .width(28)
        .fillColor(this.cjCalStatus.hasNext ? this.itemFontColor : this.disabledFontColor)
        .aspectRatio(1)
        .onClick(() => {
          // this.cjCalStatus.title = "2024-06"
          this.__nextMonth()
        })
    }
    .width('100%')
    .backgroundColor(this.titleBackground)
    .alignItems(VerticalAlign.Center)
    .height(this.titleHeight)
  }

  @Builder
  WeekLayout() {
    Row() {
      ForEach(this.weeks, (item: string, index) => {
        this.WeekCell(item)
      })
    }
    .backgroundColor(this.weekTitleBackgroundColor)
    .alignItems(VerticalAlign.Center)
    .height(this.weekTitleHeight)

  }

  @Builder
  WeekCell(week: string) {
    Text(week)
      .textAlign(TextAlign.Center)
      .fontColor(this.weekTitleFontColor)
      .fontSize(this.weekTitleFontSize)
      .layoutWeight(1)
  }

  @Builder
  DayLayout() {
    Stack() {
      Column() {
        Flex({
          wrap: FlexWrap.Wrap
        }) {
          ForEach(this.days[0], (item: CJDateItem, index: number) => {
            ItemCell({
              cjDataItem: item,
              today: this.today,
              optMode: this.optMode,
              cjCalStatus: this.cjCalStatus,
              // themeColor: this.themeColor,
              selectedItems: this.selectedItems,
              cjCellStyle: this.buildCellStyle(item),
              selectedStyle: this.selectedStyle,
              onlyShowCurrMonthDay: this.onlyShowCurrMonthDay,
              showLunar: this.showLunar,
              showJieQi: this.showJieQi,
              showJieRi: this.showJieRi,
              // buildCellBackground: (item: CJDateItem, cjCellStyle: CJCellStyle, cjCellStatus: CellStatus) => {
              //   this.buildCellBackground(item, cjCellStyle, cjCellStatus)
              // },
              buildCellBackground: this.buildCellBackground,
              buildCellBody: this.buildCellBody,
              cellClick: (cellItem: CJDateItem) => {
                if (cellItem.isPre) {
                  this.__preMonth()
                } else if (cellItem.isNext) {
                  this.__nextMonth()
                }
                if (cellItem.smallThan(new CJDateItem(this.startDate)) ||
                cellItem.bigThan(new CJDateItem(this.endDate))) {
                  if (this.onDisableCellItemClick) {
                    this.onDisableCellItemClick(cellItem)
                  } else {
                    if (this.onCellItemClick) {
                      this.onCellItemClick(cellItem)
                    }
                  }
                } else {
                  if (this.onCellItemClick) {
                    this.onCellItemClick(cellItem)
                  }
                }
                this.onSelectedChanged(this.selectedItems)
              }
            })
              .width("14.28%")
              .margin({ bottom: this.calStyle.rowSpace })
          })
        }
        .width("100%")
      }
      .width('100%')

    }
    .clip(true)
    .width('100%')
  }

  __onStatusChange() {
    this.onStatusChange(this.cjCalStatus)
  }

  /**
   * 上一月
   */
  __preMonth() {
    if (!this.cjCalStatus.hasPre) {
      return
    }
    this.currMonth.setMonth(this.currMonth.getMonth() - 1)
    this.currentYear = this.currMonth.getFullYear()
    this.currentMonth = this.currMonth.getMonth()+1
    this.__calcMonthDays(this.currMonth)
    if (this.onMonthChanged) {
      this.onMonthChanged(this.currMonth)
    }
  }

  /**
   * 下一月
   */
  __nextMonth() {
    if (!this.cjCalStatus.hasNext) {
      return
    }
    this.currMonth.setMonth(this.currMonth.getMonth() + 1)
    this.currentYear = this.currMonth.getFullYear()
    this.currentMonth = this.currMonth.getMonth()+1
    this.__calcMonthDays(this.currMonth)
    if (this.onMonthChanged) {
      this.onMonthChanged(this.currMonth)
    }
  }

  /**
   * 回到今天
   */
  __backToday() {
    this.currMonth.setMonth(new Date().getMonth())
    this.__calcMonthDays(this.currMonth)
    if (this.onMonthChanged) {
      this.onMonthChanged(this.currMonth)
    }
  }

  /**
   * 初始化日期项
   */
  __initDays() {
    this.__calcMonthDays(this.currMonth)
  }

  /**
   * 计算指定月份的所有日期
   */
  __calcMonthDays(month: Date) {
    month.setDate(1)
    this.cjCalStatus.title = month.getFullYear() + "-" + (month.getMonth() + 1).toString().padStart(2, "0")

    // 是否有上一月
    if (month.getFullYear() < this.startDate.getFullYear()
      || (month.getFullYear() == this.startDate.getFullYear() && month.getMonth() <= this.startDate.getMonth())) {
      this.cjCalStatus.hasPre = false
    } else {
      this.cjCalStatus.hasPre = true
    }

    // 是否有下一月
    if (month.getFullYear() > this.endDate.getFullYear()
      || (month.getFullYear() == this.endDate.getFullYear() && month.getMonth() >= this.endDate.getMonth())) {
      this.cjCalStatus.hasNext = false
    } else {
      this.cjCalStatus.hasNext = true
    }

    // 是否是当前月
    if (this.today.fullYear == month.getFullYear() && this.today.month == month.getMonth()) {
      this.cjCalStatus.showFastToday = true
    } else {
      this.cjCalStatus.showFastToday = false
    }

    const datas: Array<CJDateItem> = new Array()
    // 计算第一个月
    // 获取第一个月总天数
    let endDay: Date = new Date(
      month.getFullYear(),
      month.getMonth() + 1,
      0, 23, 59, 59)

    console.log("endDay：", endDay.getFullYear() + "-" + (endDay.getMonth() + 1) + "-" + endDay.getDate())
    // TimeConversionTool.formatDateTime()

    let tempDate: Date = new Date(month)

    console.log("tempDate：", tempDate.getFullYear() + "-" + (tempDate.getMonth() + 1) + "-" + tempDate.getDate())
    console.log("tempDate 星期：", tempDate.getDay())

    const count = endDay.getDate()
    const preCount = month.getDay()
    const nextCount = 6 - endDay.getDay()
    const finilCount = count + preCount + nextCount

    // 补齐上一个月
    tempDate.setDate(tempDate.getDate() - preCount)
    console.log("补齐上一个月 tempDate：", tempDate.getFullYear() + "-" + (tempDate.getMonth() + 1) + "-" + tempDate.getDate())

    // 添加日期
    for (let index = 0; index < finilCount; index++) {
      let item = new CJDateItem(
        tempDate,
        (index < preCount ? true : false) || this.startDate.getTime() > tempDate.getTime(),
        (index >= preCount + count ? true : false) || this.endDate.getTime() < tempDate.getTime()
      )
      item.isSmallThanStart = index < preCount
      item.isBigThanEnd = index >= preCount + count
      console.log("date:", item.date, ",isSmallThanStart:", item.isSmallThanStart, ",isBigThanEnd:", item.isBigThanEnd)
      item.isToday = tempDate.getFullYear() == this.today.fullYear && tempDate.getMonth() == this.today.month && tempDate.getDate() == this.today.date
      if (this.reBuildCellItem) {
        item = this.reBuildCellItem(item)
      }
      if (this.showLunar) { // 显示农历
        item.solar = Solar.fromYmd(item.fullYear, item.month + 1, item.date)
      }
      // this.reBuildDateItem(item)
      datas.push(item)
      tempDate.setDate(tempDate.getDate() + 1)
    }

    this.days.splice(0, 1)
    this.days.push(datas)
  }
}