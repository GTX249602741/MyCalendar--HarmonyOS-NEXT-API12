import { CJCalendar, OptMode } from '../cjcalendar'
import { CJDateItem } from '../cjcalendar/src/main/ets/components/components/CJDateItem'
import { getLunarDesc } from '../cjcalendar/src/main/ets/components/components/CJCalendar'
import { Lunar, Solar} from 'lunar';
import router from '@ohos.router'
import ArrayList from '@ohos.util.ArrayList';
import { ScheduleModel } from '../model/ScheduleModel'
import dbUtil from '../Util/DbUtil'
import thermal from '@ohos.thermal';
import relationalStore from '@ohos.data.relationalStore';
import { Const } from '../model/ScheduleModel'
import {getScheduleList} from './Index'


class param{
  currentYear:number | undefined
  currentMonth:number | undefined
}

@Entry
@Component
export struct MonthPage {

  date:Date = new Date()
  //linkMonth:any = AppStorage.Link('currentMonth')
  //linkYear:any = AppStorage.Link('currentYear')
  @StorageLink('currentYear') @Watch("onYearChange")currentYear:number | undefined =1

  @StorageLink('currentMonth') @Watch('onMonthChange')currentMonth:number | undefined = 1

  @State currentDate:number = this.date.getDate()

  @State currentHour:number = this.date.getHours()

  @State currentMinute:number = this.date.getMinutes()

  @State item:CJDateItem[] = []

  @State scheduleModelArray:Array<ScheduleModel> = []

  scroller:Scroller = new Scroller()

  @State show:boolean = false

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }
  onYearChange(){
    AppStorage.set('currentYear',this.currentYear)

  }

  onMonthChange(){
    AppStorage.set('currentMonth',this.currentMonth)

  }

  aboutToAppear(): void {

    let today: CJDateItem = new CJDateItem(this.date,undefined,undefined,Solar.fromDate(this.date))
    //this.currentYear = this.date.getFullYear()
    //this.currentMonth = this.date.getMonth()+1
   // this.currentDate = this.date.getDate()
    if (this.currentMonth != this.date.getMonth()+1){
      this.currentDate = 1
      let date1 = new Date(this.currentYear as number,this.currentMonth as number,this.currentDate as number)
      let day: CJDateItem = new CJDateItem(date1,undefined,undefined,Solar.fromDate(date1))
      this.item[0] = day
    }
    if(this.currentMonth == this.date.getMonth()+1&&this.currentDate != this.date.getDate()){
      this.currentDate = 1
      let date1 = new Date(this.currentYear as number,this.currentMonth,this.currentDate)
      let day: CJDateItem = new CJDateItem(date1,undefined,undefined,Solar.fromDate(date1))
      this.item[0] = day
    }
    this.item[0] = today

  }

  onPageShow(){
    getScheduleList(this.currentYear as number,this.currentMonth as number,this.currentDate as number,this.currentHour as number,this.currentMinute as number).then((result:ScheduleModel[])=>{
      this.scheduleModelArray = result
      console.log('test5','month'+this.scheduleModelArray.length.toString())
      console.log('test5','MonthTime'+this.currentYear!.toString()+this.currentMonth!.toString()+this.currentDate.toString()+this.currentHour.toString()+this.currentMinute.toString())
    }).catch((err:Error)=>{
      console.log(err.toString())
    })

  }

  onBackPress(){
    //router.pushUrl({url:'pages/Index'},router.RouterMode.Single)
   // AppStorage.SetOrCreate('currentYear',this.currentYear)
    //AppStorage.SetOrCreate('currentMonth',this.currentMonth)

  }

  build() {
    Column(){
      CJCalendar({currentYear:this.currentYear,currentMonth:this.currentMonth,showLunar:true,showJieRi:true,onSelectedChanged:async (item:CJDateItem[])=>{
        this.item = item
        this.currentYear = item[0].fullYear
        this.currentMonth = item[0].month+1
        this.currentDate = item[0].date

        getScheduleList(this.currentYear,this.currentMonth,this.currentDate,this.currentHour,this.currentMinute).then((result:ScheduleModel[])=>{
          this.scheduleModelArray = result
        }).catch((err:Error)=>{
          console.log(err.toString())
        })
        //console.log('test4',this.currentYear.toString())
      },optMode:OptMode.SINGLE})
      //.sharedTransition(this.currentMonth.toString(),{ duration: 200, curve: Curve.Friction})



      Row(){
        Text(this.currentMonth == this.date.getMonth()+1&&this.currentDate == this.date.getDate()? '今天':this.currentMonth+'月'+this.currentDate+'日')
          .width(60)
          .height(50)
          .margin({left:10})
          .fontSize(15)
        Text('农历'+Lunar.fromDate(new Date(this.currentYear,this.currentMonth!-1,this.currentDate)).toString().split('年')[1])
          .width(230)
          .height(50)
          .fontSize(15)
        Blank()
        Image($r('app.media.ic_public_add_norm'))
          .size({width:20,height:20})
          .margin({right:10})
          .onClick(()=>{
            router.pushUrl({url:'pages/CreateSchedulePage'},router.RouterMode.Single)
          })
      }
      .width('100%')
      .height('7%')
      .justifyContent(FlexAlign.Start)

      Image($r('app.media.ic_public_calendar1'))
        .size({height:100})
        .visibility(this.scheduleModelArray.length == 0? Visibility.Visible : Visibility.None)
        .margin({top:60})

      Text('没有日程')
        .visibility(this.scheduleModelArray.length == 0? Visibility.Visible : Visibility.None)
        .fontColor(Color.Gray)

      List({space:15,scroller:this.scroller}){
        ForEach(this.scheduleModelArray,(item:ScheduleModel)=>{
          ListItem(){
            ScheduleItem({item:item,currentDate:$currentDate,currentYear:$currentYear,currentMonth:$currentMonth})
          }
          .onClick(()=>{
            router.pushUrl({url:'pages/ContentPage',params:{item:item}},router.RouterMode.Single)
          })
        })
      }.width('95%')
      .height('35%')
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ScheduleItem{

  @State show:boolean = false

  @ObjectLink item:ScheduleModel

  @Link currentYear:number

  @Link currentMonth:number

  @Link currentDate:number

  getTextString():string{
    if (this.item.WholeDay == 1) {
      return "全"
    }
    if (this.item.StartYear == this.currentYear&&this.currentYear == this.item.EndYear) {
      if (this.item.StartMonth ==this.currentMonth&&this.currentMonth== this.item.EndMonth) {
        if (this.item.StartDate ==this.currentDate&&this.currentDate== this.item.EndDate) {
          return this.item.HourStart!.toString() + ':' +(this.item.MinuteStart! <10? '0'+this.item.MinuteStart!.toString(): this.item.MinuteStart!.toString())

        }
        if (this.item.StartDate ==this.currentDate&&this.currentDate < this.item.EndDate!){
          return this.item.HourStart!.toString() + ':' +(this.item.MinuteStart! <10? '0'+this.item.MinuteStart!.toString(): this.item.MinuteStart!.toString())
        }
        if (this.item.StartDate! < this.currentDate&&this.currentDate == this.item.EndDate){
          return this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString())
        }

        if (this.item.StartDate! <this.currentDate&&this.currentDate< this.item.EndDate!) {
          return'全'
        }
      }
      if (this.item.StartMonth == this.currentMonth &&this.currentMonth < this.item.EndMonth!) {
        if (this.item.StartDate == this.currentDate) {
          return this.item.HourStart!.toString() + ':' +(this.item.MinuteStart! <10? '0'+this.item.MinuteStart!.toString(): this.item.MinuteStart!.toString())
        }
        if (this.item.StartDate! < this.currentDate) {
          return '全'
        }
      }
      if (this.item.StartMonth! < this.currentMonth &&this.currentMonth == this.item.EndMonth) {
        if (this.item.EndDate == this.currentDate) {
          return this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString())
        }
        if (this.item.EndDate! > this.currentDate) {
          return '全'
        }
      }
    }
    if (this.item.StartYear! < this.currentYear&&this.currentYear < this.item.EndYear!) {
      return '全'
    }
    if (this.item.StartYear == this.currentYear&&this.currentYear < this.item.EndYear!) {
      if (this.item.StartMonth ==this.currentMonth) {
        if (this.item.StartDate ==this.currentDate) {
          return this.item.HourStart!.toString() + ':' +(this.item.MinuteStart! <10? '0'+this.item.MinuteStart!.toString(): this.item.MinuteStart!.toString())
        }
        if (this.item.StartDate! <this.currentDate) {
          return'全'
        }
      }
      if (this.item.StartMonth! < this.currentMonth) {
        return '全'
      }
    }
    if (this.item.StartYear! < this.currentYear&&this.currentYear == this.item.EndYear) {
      if (this.currentMonth== this.item.EndMonth) {
        if (this.currentDate== this.item.EndDate) {
          return this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString())+' '
        }
        if (this.currentDate< this.item.EndDate!) {
          return'全'
        }
      }
      if (this.currentMonth < this.item.EndMonth!) {
        return '全'
      }
    }
    return ''
  }

  getTextString2():string{
    if (this.item.WholeDay == 1) {
      return "天"
    }
    if (this.item.StartYear == this.currentYear&&this.currentYear == this.item.EndYear) {
      if (this.item.StartMonth ==this.currentMonth&&this.currentMonth== this.item.EndMonth) {
        if (this.item.StartDate ==this.currentDate&&this.currentDate== this.item.EndDate) {
          return this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString())
        }
        if (this.item.StartDate == this.currentDate&&this.currentDate < this.item.EndDate!){
          return '开始'
        }
        if (this.item.StartDate! < this.currentDate&&this.currentDate == this.item.EndDate){
          return '结束'
        }
        if (this.item.StartDate! <this.currentDate&&this.currentDate< this.item.EndDate!) {
          return'天'
        }
      }
      if (this.item.StartMonth == this.currentMonth &&this.currentMonth < this.item.EndMonth!) {
        if (this.item.StartDate == this.currentDate) {
          return '开始'
        }
        if (this.item.StartDate! < this.currentDate) {
          return '天'
        }
      }
      if (this.item.StartMonth! < this.currentMonth &&this.currentMonth == this.item.EndMonth) {
        if (this.item.EndDate == this.currentDate) {
          return '结束'
        }
        if (this.item.EndDate! > this.currentDate) {
          return '天'
        }
      }
    }
    if (this.item.StartYear! < this.currentYear&&this.currentYear < this.item.EndYear!) {
      return '天'
    }
    if (this.item.StartYear == this.currentYear&&this.currentYear < this.item.EndYear!) {
      if (this.item.StartMonth ==this.currentMonth) {
        if (this.item.StartDate ==this.currentDate) {
          return '开始'
        }
        if (this.item.StartDate! <this.currentDate) {
          return'天'
        }
      }
      if (this.item.StartMonth! < this.currentMonth) {
        return '天'
      }
    }
    if (this.item.StartYear! < this.currentYear&&this.currentYear == this.item.EndYear) {
      if (this.currentMonth== this.item.EndMonth) {
        if (this.currentDate== this.item.EndDate) {
          return this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString())+' '+'结束'
        }
        if (this.currentDate< this.item.EndDate!) {
          return'天'
        }
      }
      if (this.currentMonth < this.item.EndMonth!) {
        return '天'
      }
    }
    return ''
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

  build(){
    Row() {
      Column({space:10}){

       Text(this.getTextString())
          .fontSize(10)

        Text(this.getTextString2())
          .fontSize(10)

      }
      .width('10%')
      .margin({left:10,top:10,bottom:10,right:10})

      Divider()
        .vertical(true)
        .height(30)
        .color('#0091FF')
        .strokeWidth(3)
        .lineCap(LineCapStyle.Round)

      Text(this.item.Title)
        .fontSize(25)
        .margin({left:10})

    }.width('100%')
    .height(50)
    .borderRadius(15)
    .justifyContent(FlexAlign.Start)
    .builder()
  }

}