import { CJCalendar, OptMode } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { getLunarDesc } from '../cjcalendar/src/main/ets/components/components/CJCalendar'
import { Lunar, Solar} from 'lunar';
import { CJCalendarYear } from '../cjcalendar/src/main/ets/components/components/CJCalendarYear'
import thermal from '@ohos.thermal';
import hilog from '@ohos.hilog';
import router from '@ohos.router'
import {MyDataSource} from '../Util/IDataSource'

@Component
export  struct YearPage {

  date:Date = new Date()

  private data: MyDataSource = new MyDataSource();

  @StorageLink('currentMonth') currentMonth:number = 1

  @Link currentYear:number

  aboutToAppear() {



    for (let index = 0; index < 12
      ; index++) {
      let date :Date = new Date(this.currentYear as number,index)
      this.data.pushData(date)
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
    this.data.clearData()
    for (let index = 0; index < 12
      ; index++) {
      let date :Date = new Date(this.currentYear as number,index)
      this.data.pushData(date)
    }
  }

  build() {
    Column() {
        Row() {
          Image($r('app.media.ic_public_arrow_left_filled'))
            .height(28)
            .onClick(()=>{
              this.currentYear = this.currentYear!-1
              this.getYearDays()
              console.log('test2',this.currentYear.toString())
            })
          Text(this.currentYear.toString()+'年')
            .fontSize(18)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
          Image($r('app.media.ic_public_arrow_right_filled'))
            .height(28)
            .onClick(()=>{
              this.currentYear= this.currentYear!+1
              this.getYearDays()
              console.log('test2',this.currentYear.toString())
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height('7%')
        .width('100%')

        List({initialIndex:this.currentMonth-1}) {
          LazyForEach(this.data, (item: Date, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text((item.getMonth() + 1).toString()+'月')
                    .fontSize(20)
                    .fontColor(new Date().getMonth() == index&&this.currentYear == new Date().getFullYear()?'#0091FF':Color.Black)

                }
                .margin({bottom:20})
                CJCalendarYear({ currMonth: item ,showLunar:true})
                 // .sharedTransition((item.getMonth()+1).toString(),{ duration: 200, curve: Curve.Friction})
              }
            }
            .onClick(()=>{
              this.currentMonth = item.getMonth()+1
              AppStorage.set('currentYear',this.currentYear)
              AppStorage.set('currentMonth',this.currentMonth)
              router.pushUrl({url:'pages/MonthPage'},router.RouterMode.Single)
            })
            .width('100%')
            .margin({ top:'7%' })
          })
        }
        .borderRadius(15)
        .width('100%')
        .height('93%')
    }
    .height('100%')
    .width('100%')
  }
}