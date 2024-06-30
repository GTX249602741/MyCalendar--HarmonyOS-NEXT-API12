import { MonthDialogPage } from './MonthDialogPage'
import router from '@ohos.router'
import { ScheduleModel } from '../model/ScheduleModel'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import { Const } from '../model/ScheduleModel'
import {getScheduleList} from './Index'
import {getScheduleFinishList} from './Index'
import {getScheduleOutDatedList} from './Index'
@Component
export  struct MyOneDayPage {

  date:Date = new Date()

  @Link currentYear:number|undefined

  @Link currentMonth:number|undefined

  @Link currentDate:number|undefined

  @Link currentHour:number|undefined

  @Link currentMinute:number|undefined

  @Link scheduleModelArray:Array<ScheduleModel>|undefined

  @State refreshing:boolean |undefined= false

  scroller:Scroller = new Scroller()

  controller:CustomDialogController = new CustomDialogController({
    builder:MonthDialogPage({currentYear:$currentYear,currentMonth:$currentMonth,currentDate:$currentDate,currentHour:$currentHour,currentMinute:$currentMinute,scheduleModelArray:$scheduleModelArray}),
    alignment:DialogAlignment.Bottom
  })


  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})
  }

  build() {
      Column() {
        Row() {
          Text('我的一天')
            .fontSize(20)
          Blank()
          Image($r('app.media.ic_public_calendar'))
            .size({ width: 20, height: 20 })
            .onClick(() => {
              this.controller.open()
            })
            .margin({right:10})
          Image($r('app.media.ic_public_add_norm'))
            .size({ width: 20, height: 20 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/CreateSchedulePage'},router.RouterMode.Single)
            })
        }.width('90%')
        .height('7%')


        Row() {
          Text(this.currentYear?.toString() + '年' + this.currentMonth!.toString() + '月' + this.currentDate!.toString() + '日')
            .fontSize(20)
            .width('90%')
            .height('10%')
        }

        Refresh({refreshing:$$this.refreshing})
          .onRefreshing(()=>{
            setTimeout(() => {
              getScheduleList(this.currentYear as number,this.currentMonth as number,this.currentDate as number,this.currentHour as number,this.currentMinute as number).then((result:ScheduleModel[])=>{
                this.scheduleModelArray = result
              }).catch((err:Error)=>{
                console.log(err.toString())
              })

              this.refreshing = false
            }, 500)
          })

        Image($r("app.media.RC"))
          .size({ height: 200, width: 200 })
          .margin({ top: 150 })
          .visibility(this.scheduleModelArray!.length! == 0 ? Visibility.Visible : Visibility.None)
        Text('今天要做什么？')
          .fontSize(20)
          .margin({ top: 20 })
          .visibility(this.scheduleModelArray!.length! == 0 ? Visibility.Visible : Visibility.None)
        Text('点击+按钮记录一下')
          .fontSize(15)
          .visibility(this.scheduleModelArray!.length! == 0 ? Visibility.Visible : Visibility.None)

        List({space:15,scroller:this.scroller}) {
          ForEach(this.scheduleModelArray, (item: ScheduleModel) => {
            ListItem() {
              scheduleItem({item:item,currentDate:$currentDate})
              .height('100%')
              .width('100%')
            }
            .height('10%')
            .width('100%')
            .onClick(()=>{
              router.pushUrl({url:'pages/ContentPage',params:{item:item}},router.RouterMode.Single)
            })

          })
        }
        .height('70%')
        .width('95%')

      }.width('100%')
      .height('100%')
    }
}

@Component
struct scheduleItem{

  @ObjectLink item:ScheduleModel

  @Link currentDate:number

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
      Text(this.item.WholeDay == 1?'全天':this.item.HourStart!.toString() + ':' + (this.item.MinuteStart! < 10 ? '0' + this.item.MinuteStart!.toString() : this.item.MinuteStart!.toString()))
        .fontSize(15)
        .margin({ left: 10, right: 10 })

      Divider()
        .vertical(true)
        .color('#0091FF')
        .height('70%')
        .strokeWidth(4)
        .lineCap(LineCapStyle.Round)

      Blank()

      Row() {
        Text(this.item.Title)
          .fontSize(25)
          .margin({ left: 10 })
        Text(this.item.WholeDay == 1?'全天':this.item.StartDate == this.item.EndDate?
                                              this.item.HourStart!.toString() + ':' +(this.item.MinuteStart! <10? '0'+this.item.MinuteStart!.toString(): this.item.MinuteStart!.toString())+'-'+
                                              this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString()):
                                                this.item.StartDate == this.currentDate?this.item.HourStart!.toString() + ':' +(this.item.MinuteStart! <10? '0'+this.item.MinuteStart!.toString(): this.item.MinuteStart!.toString())+' '+'开始':
                                                  this.item.EndDate == this.currentDate?this.item.HourEnd!.toString() + ':' +(this.item.MinuteEnd! <10? '0'+this.item.MinuteEnd!.toString(): this.item.MinuteEnd!.toString())+' '+'结束':'全天'
        )
          .fontSize(15)
          .offset({ x: 0, y: 10 })
          .margin({ right: 10 })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('83%')
      .height('100%')
      .builder()
      .borderRadius(15)

    }
  }
}