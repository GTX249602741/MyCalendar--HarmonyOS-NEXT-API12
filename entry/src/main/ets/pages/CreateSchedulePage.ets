import font from '@ohos.font'
import { DatePickerDialogPage } from './DatePickerDialogPage'
import { DatePickerDialogPage2 } from './DatePickerDialogPage2'
import { Const } from '../model/ScheduleModel'
import DbUtil from '../Util/DbUtil'
import { ScheduleModel } from '../model/ScheduleModel'
import router from '@ohos.router'
@Entry
@Component
struct CreateSchedulePage {
  @State title: string = ' '

  @State content: string = ''

  date:Date = new Date()

  @State selectedStartYear:number|undefined = this.date.getFullYear()

  @State selectedStartMonth:number|undefined = this.date.getMonth()+1

  @State selectedStartDate:number|undefined = this.date.getDate()

  @State selectedStartHour:number|undefined = this.date.getHours()

  @State selectedStartMinute:number|undefined = this.date.getMinutes()

  @State selectedEndYear:number|undefined = this.date.getFullYear()

  @State selectedEndMonth:number|undefined = this.date.getMonth()+1

  @State selectedEndDate:number|undefined = this.date.getDate()

  @State selectedEndHour:number|undefined = this.date.getHours()

  @State selectedEndMinute:number|undefined = this.date.getMinutes()

  @State fullDayFlag:boolean = false

  @State selectedYear:number|undefined = this.date.getFullYear()

  @State selectedMonth:number|undefined= this.date.getMonth()+1

  @State selectedDate:number|undefined = this.date.getDate()

  @State selectedHour:number|undefined = this.date.getHours()

  @State selectedMinute:number|undefined = this.date.getMinutes()

  @State selectedYear2:number|undefined = this.date.getFullYear()

  @State selectedMonth2:number|undefined = this.date.getMonth()+1

  @State selectedDate2:number|undefined= this.date.getDate()

  @State selectedHour2:number|undefined= this.date.getHours()

  @State selectedMinute2:number|undefined = this.date.getMinutes()

  day:number = this.date.getDay()

  @State day2:string = this.getDay(this.day)

  @State day1:string = this.getDay(this.day)

  getDay(date:number):string {
    switch (date){
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 0:
        return '日';

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

  controller:CustomDialogController = new CustomDialogController({
    builder:DatePickerDialogPage({selectedStartYear:$selectedStartYear,selectedStartMonth:$selectedStartMonth,selectedStartDate:$selectedStartDate,selectedStartHour:$selectedStartHour,selectedStartMinute:$selectedStartMinute,
      selectedEndYear:$selectedEndYear,selectedEndMonth:$selectedEndMonth,selectedEndDate:$selectedEndDate,selectedEndHour:$selectedEndHour,selectedEndMinute:$selectedEndMinute, fullDayFlag:$fullDayFlag,
      selectedYear:$selectedYear,selectedMonth:$selectedMonth,selectedDate:$selectedDate,selectedHour:$selectedHour,selectedMinute:$selectedMinute,day1:$day1}),
    alignment:DialogAlignment.Bottom,
    offset:{dx:0,dy:-10}

  })

  controller2:CustomDialogController = new CustomDialogController({
    builder:DatePickerDialogPage2({selectedStartYear:$selectedStartYear,selectedStartMonth:$selectedStartMonth,selectedStartDate:$selectedStartDate,selectedStartHour:$selectedStartHour,selectedStartMinute:$selectedStartMinute,
      selectedEndYear:$selectedEndYear,selectedEndMonth:$selectedEndMonth,selectedEndDate:$selectedEndDate,selectedEndHour:$selectedEndHour,selectedEndMinute:$selectedEndMinute,fullDayFlag:$fullDayFlag,
      selectedYear2:$selectedYear2,selectedMonth2:$selectedMonth2,selectedDate2:$selectedDate2,selectedHour2:$selectedHour2,selectedMinute2:$selectedMinute2,day2:$day2}),
    alignment:DialogAlignment.Bottom,
    offset:{dx:0,dy:-10}
  })

  onBackPress(){
    //router.back()
  }

  build() {
    Column(){
      Row(){
        Image($r('app.media.ic_public_cancel'))
          .size({width:30,height:30})
          .onClick(()=>{
            router.back()
          })

        Text('新建日程')
          .fontSize(30)
          .margin({left:15})
        Blank()
        Image($r('app.media.ic_public_ok'))
          .size({width:30,height:30})
          .onClick(async ()=>{
            let scheduleModel = new ScheduleModel(0,0,0,0,0,0,0,0,0,0,0,0,0,'','')
            scheduleModel.StartYear = this.selectedStartYear
            scheduleModel.StartMonth = this.selectedStartMonth
            scheduleModel.StartDate = this.selectedStartDate
            scheduleModel.EndYear = this.selectedEndYear
            scheduleModel.EndMonth = this.selectedEndMonth
            scheduleModel.EndDate = this.selectedEndDate
            scheduleModel.IsFinish = 0
            if (this.fullDayFlag == false) {
              scheduleModel.WholeDay = 0
              scheduleModel.HourStart = this.selectedStartHour
              scheduleModel.MinuteStart = this.selectedStartMinute
              scheduleModel.HourEnd = this.selectedEndHour
              scheduleModel.MinuteEnd = this.selectedEndMinute
            }else {
              scheduleModel.WholeDay = undefined
              scheduleModel.HourStart = undefined
              scheduleModel.MinuteStart = undefined
              scheduleModel.HourEnd = undefined
              scheduleModel.MinuteEnd = undefined
            }
            if (this.title == undefined || this.title.trim() == '') {
              AlertDialog.show(
                {
                  title: '',
                  message: '标题不能为空',
                  autoCancel: true,
                  alignment: DialogAlignment.Center,
                  gridCount: 3,
                  confirm: {
                    value: '确认',
                    action: () => {

                    }
                  },
                  cancel: () => {

                  }
                }
              )
            }else {
              scheduleModel.Title = this.title
              scheduleModel.content = this.content
              await DbUtil.insert('DATE',scheduleModel,Const)
              router.back()
            }

          })
      }
      .margin({top:10})
      .width('95%')

      Row(){

        TextInput({text:this.title,placeholder:'标题'})
          .placeholderColor(Color.Black)
          .type(InputType.Normal)
          .height(50)
          .onChange((value=>{
            this.title = value
          }))
          .builder()
          .width('100%')
      }.width('95%')
      .margin({top:70})
      .backgroundColor('#E3E3E3')
      .borderRadius(15)
      .builder()

      Row(){
        TextArea({text:this.content,placeholder:'请输入内容'})
          .size({width:270,height:50})
          .onChange((value=>{
            this.content = value
          }))
          .builder()
          .width('100%')
          .height('100%')
      }.width('95%')
      .height('30%')
      .margin({top:20})
      .backgroundColor('#E3E3E3')
      .borderRadius(15)
      .builder()

      Row(){
        Image($r('app.media.ic_public_clock'))
          .size({width:20,height:20})
          .margin({left:10})
        Text('全天')
          .fontSize(20)
          .margin({left:10})
        Blank()
        Toggle({type:ToggleType.Switch})
          .selectedColor(Color.Blue)
          .size({width:'40',height:'40'})
          .margin({right:10})
          .onChange((isOn:boolean)=>{
            this.fullDayFlag = !this.fullDayFlag
          })

      }
      .width('95%')
      .margin({top:20})
      .borderRadius({topLeft:15,topRight:15})
      .height(50)
      .builder()

      Divider()
      .color(Color.Black)
      .width('95%')

      Row(){
        Column(){

          Text(this.selectedStartHour!.toString()+':'+(this.selectedStartMinute! <10? '0'+this.selectedStartMinute!.toString():this.selectedStartMinute!.toString())!)
            .fontSize(25)
            .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)

          Text(this.selectedStartMonth!.toString()+'月'+this.selectedStartDate!.toString()+'日')
            .fontSize(17)
        }
        .onClick(()=>{
          this.controller.open()
        })

        Image($r('app.media.ic_public_arrow_right'))
          .size({width:30,height:30})

        Column(){

          Text(this.selectedEndHour?.toString()+':'+(this.selectedEndMinute! <10? '0'+this.selectedEndMinute!.toString():this.selectedEndMinute?.toString())!)
            .fontSize(25)
            .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)

          Text(this.selectedEndMonth?.toString()+'月'+this.selectedEndDate?.toString()+'日')
            .fontSize(17)
        }
        .onClick(()=>{
          this.controller2.open()
        })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('95%')
      .borderRadius({bottomLeft:15,bottomRight:15})
      .height(80)
      .builder()
    }
    .width('100%')
    .height('100%')
  }
}
