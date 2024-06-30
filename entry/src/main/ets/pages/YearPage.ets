import { CJCalendar, OptMode } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { getLunarDesc } from '../cjcalendar/src/main/ets/components/components/CJCalendar'
import { Lunar, Solar} from 'lunar';
import { CJCalendarYear } from '../cjcalendar/src/main/ets/components/components/CJCalendarYear'
import thermal from '@ohos.thermal';
import hilog from '@ohos.hilog';
import router from '@ohos.router'

@Component
export  struct YearPage {
  date:Date = new Date()

  @State array: Date[] = []

  @State currentMonth:number = this.date.getMonth()+1

  @Link currentYear:number

  aboutToAppear() {

    for (let index = 0; index < 12
      ; index++) {
      let date :Date = new Date(this.currentYear,index)
      this.array.push(date)
    }
  }

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }

  getYearDays(){
    this.array = []
    for (let index = 0; index < 12
      ; index++) {
      let date :Date = new Date(this.currentYear,index)
      this.array.push(date)
    }
  }

  build() {
    Column() {
        Row() {
          Image($r('app.media.ic_public_arrow_left_filled'))
            .height(28)
            .onClick(()=>{
              this.currentYear = this.currentYear-1
              this.getYearDays()
              console.log('test2',this.currentYear.toString())
            })
          Text(this.currentYear.toString()+'年')
            .fontSize(18)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          Image($r('app.media.ic_public_arrow_right_filled'))
            .height(28)
            .onClick(()=>{
              this.currentYear= this.currentYear+1
              this.getYearDays()
              console.log('test2',this.currentYear.toString())
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height('7%')
        .width('100%')

        Grid() {
          ForEach(this.array, (item: Date, index: number) => {
            GridItem() {
              Column() {
                Row() {
                  Text((item.getMonth() + 1).toString())
                    .fontSize(15)
                    .fontColor(this.currentMonth == index+1?'#0091FF':Color.Black)
                  Text('月')
                    .fontSize(8)
                    .height(20)
                    .baselineOffset(10)
                    .fontColor(this.currentMonth == index+1?'#0091FF':Color.Black)
                }
                CJCalendarYear({ currMonth: item })
                 // .sharedTransition((item.getMonth()+1).toString(),{ duration: 200, curve: Curve.Friction})
              }.alignItems(HorizontalAlign.Start)
            }
            .onClick(()=>{
              this.currentMonth = item.getMonth()+1
              router.pushUrl({url:'pages/MonthPage'},router.RouterMode.Single)
              AppStorage.Set('currentYear',this.currentYear)
              AppStorage.Set('currentMonth',this.currentMonth)
            })
            .selectable(true)
            .width('30%')
            .height('17%')
            .margin({ top:'7%' })
          })
        }
        .borderRadius(15)
        .columnsTemplate('1fr,1fr,1fr')
        .columnsGap('15')
        .rowsGap(15)
        .width('100%')
        .height('93%')
    }
    .height('100%')
    .width('100%')
  }
}