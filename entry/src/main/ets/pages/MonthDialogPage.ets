import { CJCalendar, OptMode, Solar } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { Const, ScheduleModel } from '../model/ScheduleModel'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import {getScheduleList} from './Index'
@Component
@CustomDialog
export  struct MonthDialogPage {

  controller:CustomDialogController

  @Link currentYear:number|undefined

  @Link currentMonth:number|undefined

  @Link currentDate:number|undefined

  @Link currentHour:number|undefined

  @Link currentMinute:number|undefined

  @Link scheduleModelArray:Array<ScheduleModel>|undefined

  date:Date = new Date()

  @State item:CJDateItem[]|undefined = []

  aboutToAppear(): void {

    let today: CJDateItem = new CJDateItem(this.date,undefined,undefined,Solar.fromDate(this.date))

    this.item![0] = today
  }


  build() {
    Column(){
      CJCalendar({currentYear:$currentYear,currentMonth:$currentMonth,showLunar:true,onSelectedChanged:(item:CJDateItem[])=>{
        this.item = item
        this.currentYear = item[0].fullYear
        this.currentMonth = item[0].month+1
        this.currentDate = item[0].date

        getScheduleList(this.currentYear as number,this.currentMonth as number,this.currentDate as number,this.currentHour as number,this.currentMinute as number).then((result:ScheduleModel[])=>{
          this.scheduleModelArray = result
        }).catch((err:Error)=>{
          console.log(err.toString())
        })

      },optMode:OptMode.SINGLE})
    }

  }
}